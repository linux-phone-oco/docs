(function () {
'use strict';
// The bring-up graph (backlog bringup-graph-page, decision 2026-11-19-bringup-graph-cytoscape-dagre): the Graph tab of the
// site's bring-up steps page, drawn in the browser from graph/bringup.json, which bin/render-pages.sh writes from the rows.
// The engine (ocoeco-engine, a view of kind embed) copies this script and the data beside the page and writes the container
// just before the script tag; the page's own classes and colours style it. Cytoscape.js with the dagre layered layout, left
// to right: the chosen goal stands on the left, what it needs to its right. Built to carry a thousand steps: the view opens
// folded, a goal's needs grouped by stage into one node each, and only the part in view is laid out.

var GOAL_STAGE = 'goals', DEFAULT_GOAL = 'daily-usable-phone', GENERIC = 'generic', GROUP_ABOVE = 6;
var STATUS_COLOUR = { done: '#2e9e5b', partial: '#e8a317', failing: '#d64545', open: '#ffffff', unknown: '#b5b8bd', 'not-needed': '#d6e4d6' };
var STATUS_TEXT = { done: '#ffffff', failing: '#ffffff' };
var NO_STATUS_COLOUR = '#e3eaf3';
var GROUP_COLOURS = ['#7b3fbf', '#d9480f', '#0b7285', '#a61e4d', '#5c940d', '#1864ab'];
var HARD_COLOUR = '#777777';
// a node's label is cut at a word to LABEL_CHARS characters with an ellipsis; the whole title is the tooltip and the panel
var LABEL_CHARS = 28;
var RANKER = 'network-simplex';
// dagre lays out 138 nodes in 0.13 s, 456 in 1.7 s and 944 in 9.5 s (docs/graph measurements, bin/graph-fixture.sh 1500): a change that would draw more is refused
var MAX_NODES = 500;
var PANEL_KEY = 'bringup-graph-panel';

var box = document.currentScript.previousElementSibling; // the container the engine wrote just before this script
var data, byId, needs, stageTitle, claims, cy, groupColour = {};
// the parts of the view, by name, made once by build()
var ui = {}, tabLinks = {};
// what the person has done to the view; the model below is a pure function of it
var S = { tab: null, goal: null, depth: 0, toggled: new Map(), groupsOpen: new Set(), pinned: new Set(), all: false, openOnly: false, panel: true };
var distCache = {};

function el(id) { return ui[id]; }
function say(text) { el('msg').textContent = text; el('msg').hidden = !text; }
function node(tag, text) { var e = document.createElement(tag); if (text !== undefined) e.textContent = text; return e; }
// an element with a name in ui, a class, inline style (only what the site's stylesheet has no class for) and children
function part(name, tag, cls, css, kids) {
	var e = node(tag); if (cls) e.className = cls; if (css) e.style.cssText = css;
	(kids || []).forEach(function (k) { e.appendChild(typeof k === 'string' ? document.createTextNode(k) : k); });
	if (name) ui[name] = e;
	return e;
}
function button(name, text) { var b = part(name, 'button'); b.type = 'button'; b.textContent = text; return b; }

// ---- the page of the view: made here, inside the container, from the site's classes
function build() {
	var goal = part('goal', 'select'), search = part('search', 'input');
	search.type = 'search'; search.placeholder = 'a word of its title'; search.autocomplete = 'off';
	var openOnly = part('open-only', 'input'); openOnly.type = 'checkbox';
	var lab = function (text, ctl) { return part(null, 'label', '', '', [text + ' ', ctl]); };
	var onlyLab = part('open-only-label', 'label', '', '', [openOnly, ' open only (hide done steps)']);
	box.textContent = '';
	[
		part('tabs', 'nav', '', 'display:flex;flex-wrap:wrap;gap:6px;margin:0 0 12px'),
		part(null, 'div', 'embed-bar', '', [lab('Goal', goal), lab('Find a step', search), onlyLab]),
		part(null, 'div', 'embed-bar', '', [button('less', 'Show less'), button('more', 'Show more'), button('unfold', 'Unfold all'), button('fold', 'Fold all'),
			button('panel-toggle', 'Hide details'), button('full', 'Full screen')]),
		part('found', 'ul', '', 'list-style:none;margin:0 0 8px;padding:0'),
		part('count', 'p', 'mute', 'margin:4px 0;font-size:14.5px'),
		part('msg', 'p', '', 'margin:6px 0'),
		part(null, 'div', 'embed-stage', '', [part('cy', 'div', 'embed-canvas', 'touch-action:none'),
			part('panel', 'aside', 'embed-side', '', [node('p', 'Click a step to read it.')])]),
		part('tip', 'div', '', 'position:fixed;z-index:60;max-width:24rem;padding:4px 8px;background:#1a1a1a;color:#fff;border-radius:6px;font-size:13px;pointer-events:none'),
		part('legend', 'div', 'legend'),
		part('timing', 'p', 'mute', 'margin:6px 0 0;font-size:13px')
	].forEach(function (p) { box.appendChild(p); });
	el('tip').hidden = true; say('Loading the steps...');
}

// ---- the rows, indexed once
function index() {
	byId = {}; needs = {}; claims = {}; stageTitle = {};
	data.stages.forEach(function (g) { stageTitle[g.id] = g.title; });
	data.steps.forEach(function (s) { byId[s.id] = s; needs[s.id] = []; });
	data.edges.forEach(function (e) { needs[e.step].push(e); });
	data.status.forEach(function (c) { (claims[c.device_id] = claims[c.device_id] || {})[c.step_id] = c.status; });
	data.edges.map(function (e) { return e.group; }).filter(Boolean).sort().filter(function (g, i, a) { return a.indexOf(g) === i; })
		.forEach(function (g, i) { groupColour[g] = GROUP_COLOURS[i % GROUP_COLOURS.length]; });
}

function statusOf(id) { return S.tab === GENERIC ? null : (claims[S.tab] || {})[id] || 'unknown'; }
function colourOf(st) { return st ? (STATUS_COLOUR[st] || STATUS_COLOUR.unknown) : NO_STATUS_COLOUR; }
function tabName(id) { var d = data.devices.filter(function (x) { return x.id === id; })[0]; return d ? d.name : id; }

// ---- the model: which steps and which stage groups are drawn, a pure function of S

// the shortest way from the goal to every step it needs: its distance and the step before it on that way
function reach(goal) {
	if (distCache[goal]) return distCache[goal];
	var dist = {}, pred = {}, queue = [goal]; dist[goal] = 0;
	for (var i = 0; i < queue.length; i++) {
		needs[queue[i]].forEach(function (e) {
			if (dist[e.requires] === undefined) { dist[e.requires] = dist[queue[i]] + 1; pred[e.requires] = queue[i]; queue.push(e.requires); }
		});
	}
	return (distCache[goal] = { dist: dist, pred: pred, size: queue.length });
}

function hidden(id) { return S.openOnly && S.tab !== GENERIC && id !== S.goal && statusOf(id) === 'done'; }

// a step shows what it needs when the person opened it (a step the person folded stays folded, even after "Unfold all"), or when it is nearer the goal than the depth asked for
function isOpen(id, dist) { return S.toggled.has(id) ? S.toggled.get(id) : S.all || dist[id] <= S.depth; }

function model() {
	var dist = reach(S.goal).dist, steps = new Set([S.goal]), groups = [], queue = [S.goal];
	for (var i = 0; i < queue.length; i++) {
		var p = queue[i];
		if (!isOpen(p, dist)) continue;
		var byStage = {};
		var shownNeeds = needs[p].filter(function (e) { return !hidden(e.requires); });
		shownNeeds.forEach(function (e) { (byStage[byId[e.requires].stage] = byStage[byId[e.requires].stage] || []).push(e); });
		Object.keys(byStage).sort().forEach(function (stage) {
			var es = byStage[stage], apart = es.length === 1 || shownNeeds.length <= GROUP_ABOVE || dist[p] < S.depth || S.all || S.groupsOpen.has(p + '|' + stage), rest = [];
			es.forEach(function (e) {
				if (apart || S.pinned.has(e.requires) || steps.has(e.requires)) { if (!steps.has(e.requires)) { steps.add(e.requires); queue.push(e.requires); } }
				else rest.push(e);
			});
			if (rest.length) groups.push({ id: 'group:' + p + '|' + stage, parent: p, stage: stage, edges: rest });
		});
	}
	groups.forEach(function (g) { g.edges = g.edges.filter(function (e) { return !steps.has(e.requires); }); });
	return { steps: steps, groups: groups.filter(function (g) { return g.edges.length; }), dist: dist };
}

// what a closed step hides: the needs that no drawn step or group shows
function hiddenNeeds(id, m) {
	return needs[id].filter(function (e) { return !hidden(e.requires) && !m.steps.has(e.requires); }).length;
}

function groupStatus(g) {
	if (S.tab === GENERIC) return null;
	var st = g.edges.map(function (e) { return statusOf(e.requires); });
	if (st.indexOf('failing') >= 0) return 'failing';
	if (st.every(function (s) { return s === 'done' || s === 'not-needed'; })) return 'done';
	if (st.some(function (s) { return s === 'done' || s === 'partial'; })) return 'partial';
	if (st.every(function (s) { return s === 'open'; })) return 'open';
	return 'unknown';
}

function shorten(text, max) {
	max = max || LABEL_CHARS;
	if (text.length <= max) return text;
	var cut = text.lastIndexOf(' ', max - 1);
	return text.slice(0, cut > max / 2 ? cut : max - 1).replace(/[ ,;:.-]+$/, '') + '…';
}

// the whole title of a node, in a small box beside it, while the pointer is on it
function tooltip(on, node) {
	var tip = el('tip');
	tip.hidden = !on;
	if (!on) return;
	var rect = el('cy').getBoundingClientRect(), at = node.renderedPosition();
	tip.textContent = node.data('full');
	tip.style.left = Math.max(4, Math.min(rect.left + at.x - 60, window.innerWidth - tip.offsetWidth - 4)) + 'px';
	tip.style.top = (rect.top + at.y + 28 * cy.zoom() + 6) + 'px';
}

// ---- the elements Cytoscape draws, from the model
function elements(m) {
	var els = [], placed = {};
	m.steps.forEach(function (id) {
		var st = statusOf(id), more = needs[id].length && !isOpen(id, m.dist) ? hiddenNeeds(id, m) : 0;
		els.push({ group: 'nodes', data: { id: id, kind: 'step', label: shorten(byId[id].title) + (more ? '  [+' + more + ']' : ''),
			full: byId[id].title + (st ? ' - ' + st + ' on ' + tabName(S.tab) : ''),
			fill: colourOf(st), ink: STATUS_TEXT[st] || '#1a1a1a', folded: more ? 'yes' : 'no' } });
	});
	m.groups.forEach(function (g) {
		var st = groupStatus(g), done = g.edges.filter(function (e) { return statusOf(e.requires) === 'done'; }).length;
		els.push({ group: 'nodes', data: { id: g.id, kind: 'group', fill: colourOf(st), ink: STATUS_TEXT[st] || '#1a1a1a', folded: 'no',
			label: shorten(stageTitle[g.stage] || g.stage, 20) + ': ' + g.edges.length + ' steps' + (st ? ' (' + done + ' done)' : '') + '  [+]',
			full: (stageTitle[g.stage] || g.stage) + ': ' + g.edges.length + ' steps folded' + (st ? ', ' + done + ' done on ' + tabName(S.tab) : '') + '; click to open' } });
		els.push({ group: 'edges', data: { id: g.parent + '>' + g.id, source: g.parent, target: g.id, colour: HARD_COLOUR,
			kind: g.edges.some(function (e) { return e.kind === 'hard'; }) ? 'hard' : 'soft' } });
	});
	data.edges.forEach(function (e) {
		if (!m.steps.has(e.step) || !m.steps.has(e.requires)) return;
		els.push({ group: 'edges', data: { id: e.step + '>' + e.requires, source: e.step, target: e.requires, kind: e.kind, colour: e.group ? groupColour[e.group] : HARD_COLOUR } });
	});
	return els;
}

var STYLE = [
	{ selector: 'node', style: { shape: 'round-rectangle', width: 190, height: 50, label: 'data(label)', 'background-color': 'data(fill)', color: 'data(ink)',
		'font-size': 12, 'text-wrap': 'wrap', 'text-max-width': 176, 'text-valign': 'center', 'text-halign': 'center', 'border-width': 1.5, 'border-color': '#4a4f57' } },
	{ selector: 'node[kind = "group"]', style: { shape: 'cut-rectangle', 'font-weight': 'bold', 'border-width': 2.5 } },
	{ selector: 'node[folded = "yes"]', style: { 'border-width': 4, 'border-style': 'double' } },
	{ selector: 'node:selected', style: { 'border-width': 4, 'border-color': '#1a73e8', 'border-style': 'solid' } },
	{ selector: 'edge', style: { width: 2, 'line-color': 'data(colour)', 'target-arrow-color': 'data(colour)', 'target-arrow-shape': 'triangle', 'arrow-scale': 1.1, 'curve-style': 'bezier' } },
	{ selector: 'edge[kind = "soft"]', style: { 'line-style': 'dashed', 'line-dash-pattern': [6, 4] } }
];

// a change to the view, undone with a word when what it would draw is too big to lay out in about a second or two
function copyState() { return { tab: S.tab, goal: S.goal, depth: S.depth, toggled: new Map(S.toggled), groupsOpen: new Set(S.groupsOpen), pinned: new Set(S.pinned), all: S.all, openOnly: S.openOnly, panel: S.panel }; }
function change(apply, fit) {
	var before = copyState(); apply();
	var m = model(), size = m.steps.size + m.groups.length;
	if (size > MAX_NODES) { S = before; say("That would draw " + size + " steps and groups, more than the " + MAX_NODES + " the layout carries in a second or two: open a stage group, search for a step" + (S.tab === GENERIC ? "." : ", or turn on open only."));  return false; }
	say(""); draw(fit); return true;
}

// ---- drawing: only what the model says is laid out; the view is fitted when the goal or tab changed, kept when a fold did
function draw(fit) {
	var pan = cy.pan(), zoom = cy.zoom(), selected = cy.$(':selected').id(), m = model(), t0 = performance.now();
	cy.batch(function () { cy.elements().remove(); cy.add(elements(m)); });
	var t1 = performance.now();
	cy.layout({ name: 'dagre', rankDir: 'LR', nodeSep: 12, rankSep: 70, edgeSep: 8, ranker: RANKER, fit: false, animate: false }).run();
	var t2 = performance.now();
	if (fit) { cy.fit(undefined, 20); focusGoal(); } else { cy.zoom(zoom); cy.pan(pan); }
	if (!fit && selected && cy.getElementById(selected).nonempty()) cy.getElementById(selected).select();
	window.graphTimings = { nodes: cy.nodes().length, edges: cy.edges().length, buildMs: Math.round(t1 - t0), layoutMs: Math.round(t2 - t1) };
	count(m);
}

// the goal is on the left: when fitted, show it at a readable size at the left edge rather than shrinking the whole graph to nothing
function focusGoal() {
	var g = cy.getElementById(S.goal);
	if (cy.zoom() < 0.45) cy.zoom({ level: 0.45, renderedPosition: { x: 20, y: 20 } });
	cy.pan({ x: 115 - g.position().x * cy.zoom(), y: cy.height() / 2 - g.position().y * cy.zoom() });
}

function count(m) {
	var shown = m.steps.size, text = shown + ' of the ' + reach(S.goal).size + ' steps this goal needs shown, ' + m.groups.length + ' stage groups folded';
	if (S.tab !== GENERIC) {
		var done = 0; m.steps.forEach(function (id) { if (statusOf(id) === 'done') done++; });
		text += '; ' + done + ' of those done on ' + tabName(S.tab);
	}
	el('count').textContent = text;
	el('timing').textContent = 'layout ' + window.graphTimings.layoutMs + ' ms';
}

// ---- the legend, for this tab
function legend() {
	var legendBox = el('legend'); legendBox.textContent = '';
	function item(swatch, text) { var s = node('span'); s.appendChild(swatch); s.appendChild(document.createTextNode(text)); legendBox.appendChild(s); }
	function sw(colour, extra) { var e = node('i'); e.style.cssText = 'background:' + colour + ';border:1px solid #4a4f57;' + (extra || ''); return e; }
	function ln(colour, soft) { var e = node('i'); e.style.cssText = 'background:none;height:0;border-radius:0;border-top:3px ' + (soft ? 'dashed ' : 'solid ') + colour + ';vertical-align:5px'; return e; }
	if (S.tab === GENERIC) item(sw(NO_STATUS_COLOUR), 'generic: no status colouring');
	else [['done', 'done'], ['partial', 'partial'], ['failing', 'failing'], ['open', 'open (claimed, not done)'], ['unknown', 'unknown: no claim yet'], ['not-needed', 'not needed']]
		.forEach(function (p) { item(sw(STATUS_COLOUR[p[0]]), p[1]); });
	item(ln(HARD_COLOUR, false), 'hard need: cannot be done before');
	item(ln(HARD_COLOUR, true), 'soft need: can be, but blind or at much greater cost');
	Object.keys(groupColour).forEach(function (g) { item(ln(groupColour[g], false), 'alternatives "' + g + '": one done is enough'); });
	item(sw('#ffffff', 'border-style:dashed;border-width:2px'), 'a stage group: click to open it (its colour: the worst of its steps)');
	item(sw('#ffffff', 'border-style:double;border-width:4px'), 'folded step: click to show its needs [+n]');
}

// ---- the side panel: it shows the selected step whether or not it is open; only its button opens it
function panelReset() { var p = el('panel'); p.textContent = ''; p.appendChild(node('p', 'Click a step to read it. Click it again to fold what it needs.')); }
function heading(text) { var h = node('h4', text); h.style.cssText = 'margin:0 0 4px;font-size:17px'; return h; }
function term(text) { var t = node('dt', text); t.style.cssText = 'font-weight:600;margin-top:10px'; return t; }
function def(text) { var d = node('dd', text); d.style.cssText = 'margin:0;white-space:pre-wrap;overflow-wrap:anywhere;font-size:14.5px'; return d; }
function link(text, action) { var a = node('a', text); a.href = '#'; a.onclick = function (e) { e.preventDefault(); action(); }; return a; }

function panelStep(id) {
	var s = byId[id], side = el('panel'); side.textContent = '';
	side.appendChild(heading(s.title));
	side.appendChild(node('div', s.id + ' - stage ' + (stageTitle[s.stage] || s.stage) + (S.tab === GENERIC ? '' : ' - ' + tabName(S.tab) + ': ' + statusOf(id))));
	var dl = node('dl'); side.appendChild(dl);
	[['Done when', s.done_when], ['Proof', s.proof], ['Guide', s.guide]].forEach(function (r) { dl.appendChild(term(r[0])); dl.appendChild(def(r[1])); });
	if (needs[id].length) {
		dl.appendChild(term('Needs'));
		var d = node('dd'), ul = node('ul'); d.style.margin = '0'; ul.style.cssText = 'margin:0;padding-left:18px'; d.appendChild(ul); dl.appendChild(d);
		needs[id].forEach(function (e) {
			var li = node('li');
			li.appendChild(link(byId[e.requires].title, function () { reveal(e.requires); }));
			li.appendChild(document.createTextNode(' (' + e.kind + (e.group ? ', alternatives "' + e.group + '"' : '') + ')'));
			ul.appendChild(li);
		});
	}
}

function panelGroup(g) {
	var side = el('panel'); side.textContent = '';
	side.appendChild(heading((stageTitle[g.stage] || g.stage) + ': ' + g.edges.length + ' steps folded'));
	var ul = node('ul'); ul.style.cssText = 'margin:0;padding-left:18px'; side.appendChild(ul);
	g.edges.forEach(function (e) { var li = node('li'); li.appendChild(link(byId[e.requires].title, function () { reveal(e.requires); })); ul.appendChild(li); });
}

// ---- what a click does
// a step: read it, and fold or unfold what it needs; a stage group: open it into its steps
function onTap(event) {
	var id = event.target.id(), m = model(), g = m.groups.filter(function (x) { return x.id === id; })[0];
	if (g) { panelGroup(g); change(function () { S.groupsOpen.add(g.parent + '|' + g.stage); }, false); return; }
	panelStep(id);
	if (needs[id].length && change(function () { S.toggled.set(id, !isOpen(id, m.dist)); }, false)) cy.getElementById(id).select();
}

// bring a step into view from where it is named (a need in the panel, a search result): open the way to it from the goal
function reveal(id) {
	var r = reach(S.goal);
	if (r.dist[id] === undefined) { say(byId[id].title + ' is not needed by this goal.'); return; }
	if (hidden(id)) { say(byId[id].title + ' is done on ' + tabName(S.tab) + ' and hidden by "open only".'); return; }
	if (!change(function () { for (var at = id; at !== S.goal; at = r.pred[at]) { S.pinned.add(at); S.toggled.set(r.pred[at], true); } }, false)) return;
	if (cy.getElementById(id).empty()) { say(byId[id].title + " is reached only through done steps, which open only hides."); return; }
	var n = cy.getElementById(id); cy.$(':selected').unselect(); n.select(); panelStep(id);
	cy.animate({ center: { eles: n }, zoom: Math.max(cy.zoom(), 0.7), duration: 250 });
}

function search(text) {
	var found = el('found'); found.textContent = '';
	var q = text.trim().toLowerCase(); if (!q) return;
	var needed = reach(S.goal).dist, hits = data.steps.filter(function (s) { return s.title.toLowerCase().indexOf(q) >= 0 || s.id.indexOf(q) >= 0; })
		.sort(function (a, b) { return (needed[a.id] === undefined) - (needed[b.id] === undefined); });
	hits.slice(0, 8).forEach(function (s) {
		var li = node('li');
		li.appendChild(link(s.title + (needed[s.id] === undefined ? ' (not needed by this goal)' : ''), function () { found.textContent = ''; reveal(s.id); }));
		found.appendChild(li);
	});
	if (hits.length > 8) found.appendChild(node('li', '... ' + (hits.length - 8) + ' more: narrow the search'));
	if (!hits.length) found.appendChild(node('li', 'No step matches.'));
}


// ---- the tabs: a device per row of the devices table, then the generic one. Each tab is a link whose id is the device's, inside
// the Graph pane, so the address #xiaomi-surya opens the Graph tab of the page on that device (the page's CSS shows the pane that holds the target)
function tabList() { return data.devices.map(function (d) { return d.id; }).concat([GENERIC]); }

function tabs() {
	var nav = el('tabs'); nav.textContent = '';
	tabList().forEach(function (id) {
		var a = node('a', id === GENERIC ? 'generic' : tabName(id));
		a.href = '#' + id; a.id = id; a.className = 'chip'; nav.appendChild(a); tabLinks[id] = a;
	});
}

// the tab the hash names; a hash that is not a tab (or not valid text) names none
function hashTab() { try { return decodeURIComponent(location.hash.slice(1)); } catch (e) { return ''; } }

// the device with the most steps done is where the page opens when the hash names no tab
function defaultTab() {
	var best = GENERIC, most = 0;
	data.devices.forEach(function (d) {
		var n = Object.keys(claims[d.id] || {}).filter(function (k) { return claims[d.id][k] === 'done'; }).length;
		if (n > most) { most = n; best = d.id; }
	});
	return best;
}

function foldAll() { S.depth = 0; S.all = false; S.toggled.clear(); S.groupsOpen.clear(); S.pinned.clear(); }

function showTab() {
	// an address that names no device (#graph, #table) leaves the device as it is: showing the tab again changes nothing
	var want = hashTab(), next = tabList().indexOf(want) >= 0 ? want : S.tab || defaultTab();
	if (next === S.tab) return;
	S.tab = next;
	tabList().forEach(function (id) {
		tabLinks[id].classList.toggle('warn', id === S.tab);
		if (id === S.tab) tabLinks[id].setAttribute('aria-current', 'true'); else tabLinks[id].removeAttribute('aria-current');
	});
	el('open-only-label').hidden = S.tab === GENERIC; el('open-only').disabled = S.tab === GENERIC;
	if (S.tab === GENERIC) S.openOnly = false;
	el('open-only').checked = S.openOnly;
	foldAll(); legend(); draw(true); panelReset();
}

// ---- the panel and the full screen: two buttons of the bar. The panel is shown or hidden by its button alone (a click on a
// step only selects and folds it, it never opens the panel); the choice is kept for the viewer where storage allows. Full
// screen is the container's, so the graph and its panel go together; both re-fit the view to the room they now have.
function refit() { cy.resize(); cy.fit(undefined, 20); focusGoal(); }

function storedPanel() { try { return localStorage.getItem(PANEL_KEY) !== 'hidden'; } catch (e) { return true; } }
function storePanel(open) { try { localStorage.setItem(PANEL_KEY, open ? 'open' : 'hidden'); } catch (e) { /* no storage: the choice lasts for the page */ } }

function showPanel(open, keep) {
	S.panel = open; el('panel').hidden = !open;
	el('panel-toggle').textContent = open ? 'Hide details' : 'Show details';
	el('panel-toggle').setAttribute('aria-pressed', String(!open));
	if (!keep) storePanel(open);
	if (cy && !keep) refit();
}

var fullApi = !!(box.requestFullscreen || box.webkitRequestFullscreen);
function isFull() { return document.fullscreenElement === box || document.webkitFullscreenElement === box || box.classList.contains('full'); }
var wasFull = false, fallbackTimer = null;
function fullChanged() {
	if (isFull() === wasFull) return; // another element's full screen is not ours
	wasFull = isFull(); clearTimeout(fallbackTimer);
	el('full').textContent = wasFull ? 'Leave full screen' : 'Full screen';
	el('full').setAttribute('aria-pressed', String(wasFull));
	if (cy) refit();
}
function toggleFull() {
	clearTimeout(fallbackTimer);
	if (box.classList.contains('full')) { box.classList.remove('full'); fullChanged(); return; }
	if (document.fullscreenElement === box || document.webkitFullscreenElement === box) { (document.exitFullscreen || document.webkitExitFullscreen).call(document); return; }
	// the browser's full screen where it gives one; where it has none, refuses, or says nothing (a web view in an app), the graph fills the window instead
	function inWindow() { if (!isFull()) { box.classList.add('full'); fullChanged(); } }
	if (!fullApi) { inWindow(); return; }
	var asked = (box.requestFullscreen || box.webkitRequestFullscreen).call(box);
	if (asked && asked.catch) asked.catch(inWindow);
	fallbackTimer = setTimeout(inWindow, 600);
}

// ---- the controls
function controls() {
	var sel = el('goal'), goalSteps = data.steps.filter(function (s) { return s.stage === GOAL_STAGE; });
	if (!goalSteps.length) throw new Error('the steps have no goal (stage ' + GOAL_STAGE + ')');
	goalSteps.forEach(function (s) { var o = node('option', s.title + ' (' + s.id + ')'); o.value = s.id; sel.appendChild(o); });
	if (byId[DEFAULT_GOAL]) sel.value = DEFAULT_GOAL;
	S.goal = sel.value;
	sel.onchange = function () { S.goal = sel.value; foldAll(); draw(true); panelReset(); el('found').textContent = ''; el('search').value = ''; };
	el('more').onclick = function () { change(function () { S.depth++; S.all = false; S.toggled.clear(); S.pinned.clear(); }, false); };
	el('less').onclick = function () { change(function () { S.depth = Math.max(0, S.depth - 1); S.all = false; S.toggled.clear(); S.pinned.clear(); }, false); };
	el('unfold').onclick = function () { change(function () { S.all = true; }, false); };
	el('fold').onclick = function () { foldAll(); draw(true); panelReset(); };
	el('open-only').onchange = function () { var checkbox = this; if (!change(function () { S.openOnly = checkbox.checked; }, true)) checkbox.checked = S.openOnly; };
	el('search').oninput = function () { search(this.value); };
	el('panel-toggle').onclick = function () { showPanel(!S.panel); };
	el('full').onclick = toggleFull;
	document.addEventListener('fullscreenchange', fullChanged);
	document.addEventListener('webkitfullscreenchange', fullChanged);
	document.addEventListener('keydown', function (e) { if (e.key === 'Escape' && box.classList.contains('full')) toggleFull(); });
}

// the container has no size while another tab of the page shows: when it gets one, fit the graph to it
function whenShown(canvas) {
	var sized = canvas.offsetWidth > 0;
	function seen() {
		if (!sized && canvas.offsetWidth > 0) { sized = true; cy.resize(); draw(true); }
		else if (canvas.offsetWidth === 0) sized = false;
	}
	if (window.ResizeObserver) new ResizeObserver(seen).observe(canvas); else window.addEventListener('hashchange', seen);
}

function start() {
	cytoscape.use(cytoscapeDagre);
	cy = cytoscape({ container: el('cy'), elements: [], style: STYLE, wheelSensitivity: 0.3, minZoom: 0.05, maxZoom: 2.5, boxSelectionEnabled: false });
	cy.on('tap', 'node', onTap);
	cy.on('mouseover', 'node', function (event) { tooltip(true, event.target); });
	cy.on('mouseout tap', 'node', function () { tooltip(false); });
	cy.on('viewport', function () { tooltip(false); });
	tabs(); controls();
	if (!fullApi) el('full').title = 'This browser has no full screen for part of a page: the graph fills the window instead';
	showPanel(storedPanel(), true);
	window.addEventListener('hashchange', showTab);
	window.addEventListener('resize', function () { cy.resize(); });
	whenShown(el('cy'));
	showTab();
	say('');
	// an address that names a device was made before that device's tab existed, and the page's CSS shows the pane that holds the
	// address's target: replacing the address with itself (no new history entry, no hashchange) has the browser look for the target again
	if (location.hash.length > 1) location.replace(location.href);
}

function load() {
	build();
	if (typeof cytoscape === 'undefined' || typeof cytoscapeDagre === 'undefined') { say('The graph libraries did not load (they come from cdn.jsdelivr.net): reload when online.'); Array.prototype.forEach.call(box.querySelectorAll('button, input, select'), function (c) { c.disabled = true; }); return; }
	var from = box.getAttribute('data-data');
	fetch(from).then(function (r) { if (!r.ok) throw new Error(from + ': ' + r.status); return r.json(); })
		.then(function (d) { data = d; index(); start(); })
		.catch(function (e) { say('The steps did not load: ' + e.message); });
}
load();
})();
