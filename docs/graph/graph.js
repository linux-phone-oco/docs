'use strict';
// The bring-up graph (backlog bringup-graph-page, decision 2026-11-19-bringup-graph-cytoscape-dagre): drawn in the browser
// from graph/bringup.json, which bin/render-pages.sh writes from the rows. Cytoscape.js with the dagre layered layout, left to
// right: the chosen goal stands on the left, what it needs to its right. Built to carry a thousand steps: the view opens
// folded, a goal's needs grouped by stage into one node each, and only the part in view is laid out.

var GOAL_STAGE = 'goals', DEFAULT_GOAL = 'daily-usable-phone', GENERIC = 'generic', GROUP_ABOVE = 6;
var STATUS_COLOUR = { done: '#2e9e5b', partial: '#e8a317', failing: '#d64545', open: '#ffffff', unknown: '#b5b8bd', 'not-needed': '#d6e4d6' };
var STATUS_TEXT = { done: '#ffffff', failing: '#ffffff' };
var NO_STATUS_COLOUR = '#e3eaf3';
var GROUP_COLOURS = ['#7b3fbf', '#d9480f', '#0b7285', '#a61e4d', '#5c940d', '#1864ab'];
var HARD_COLOUR = '#777777';
var RANKER = 'network-simplex';
// dagre lays out 138 nodes in 0.13 s, 456 in 1.7 s and 944 in 9.5 s (docs/graph measurements, bin/graph-fixture.sh 1500): a change that would draw more is refused
var MAX_NODES = 500;

var data, byId, needs, stageTitle, claims, cy, groupColour = {};
// what the person has done to the view; the model below is a pure function of it
var S = { tab: null, goal: null, depth: 0, toggled: new Map(), groupsOpen: new Set(), pinned: new Set(), all: false, openOnly: false };
var distCache = {};

function el(id) { return document.getElementById(id); }
function say(text) { el('msg').textContent = text; el('msg').hidden = !text; }
function node(tag, text) { var e = document.createElement(tag); if (text !== undefined) e.textContent = text; return e; }

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

// ---- the elements Cytoscape draws, from the model
function elements(m) {
	var els = [], placed = {};
	m.steps.forEach(function (id) {
		var st = statusOf(id), more = needs[id].length && !isOpen(id, m.dist) ? hiddenNeeds(id, m) : 0;
		els.push({ group: 'nodes', data: { id: id, kind: 'step', label: byId[id].title + (more ? '  [+' + more + ']' : ''),
			fill: colourOf(st), ink: STATUS_TEXT[st] || '#1a1a1a', folded: more ? 'yes' : 'no' } });
	});
	m.groups.forEach(function (g) {
		var st = groupStatus(g), done = g.edges.filter(function (e) { return statusOf(e.requires) === 'done'; }).length;
		els.push({ group: 'nodes', data: { id: g.id, kind: 'group', fill: colourOf(st), ink: STATUS_TEXT[st] || '#1a1a1a', folded: 'no',
			label: (stageTitle[g.stage] || g.stage) + ': ' + g.edges.length + ' steps' + (st ? ' (' + done + ' done)' : '') + '  [+]' } });
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
function copyState() { return { tab: S.tab, goal: S.goal, depth: S.depth, toggled: new Map(S.toggled), groupsOpen: new Set(S.groupsOpen), pinned: new Set(S.pinned), all: S.all, openOnly: S.openOnly }; }
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
	var box = el('legend'); box.textContent = '';
	function item(swatch, text) { var s = node('span'); s.appendChild(swatch); s.appendChild(document.createTextNode(text)); box.appendChild(s); }
	function sw(colour, cls) { var e = node('i'); e.className = 'sw ' + (cls || ''); e.style.background = colour; return e; }
	function ln(colour, soft) { var e = node('i'); e.className = 'ln' + (soft ? ' soft' : ''); e.style.borderTopColor = colour; return e; }
	if (S.tab === GENERIC) item(sw(NO_STATUS_COLOUR), 'generic: no status colouring');
	else [['done', 'done'], ['partial', 'partial'], ['failing', 'failing'], ['open', 'open (claimed, not done)'], ['unknown', 'unknown: no claim yet'], ['not-needed', 'not needed']]
		.forEach(function (p) { item(sw(STATUS_COLOUR[p[0]]), p[1]); });
	item(ln(HARD_COLOUR, false), 'hard need: cannot be done before');
	item(ln(HARD_COLOUR, true), 'soft need: can be, but blind or at much greater cost');
	Object.keys(groupColour).forEach(function (g) { item(ln(groupColour[g], false), 'alternatives "' + g + '": one done is enough'); });
	item(sw('#ffffff', 'grp'), 'a stage group: click to open it (its colour: the worst of its steps)');
	item(sw('#ffffff', 'fold'), 'folded step: click to show its needs [+n]');
}

// ---- the side panel
function panelReset() { var p = el('panel'); p.textContent = ''; p.appendChild(node('p', 'Click a step to read it. Click it again to fold what it needs.')); }

function panelStep(id) {
	var s = byId[id], box = el('panel'); box.textContent = '';
	box.appendChild(node('h2', s.title));
	box.appendChild(node('div', s.id + ' - stage ' + (stageTitle[s.stage] || s.stage) + (S.tab === GENERIC ? '' : ' - ' + tabName(S.tab) + ': ' + statusOf(id))));
	var dl = node('dl'); box.appendChild(dl);
	[['Done when', s.done_when], ['Proof', s.proof], ['Guide', s.guide]].forEach(function (r) { dl.appendChild(node('dt', r[0])); dl.appendChild(node('dd', r[1])); });
	if (needs[id].length) {
		dl.appendChild(node('dt', 'Needs'));
		var d = node('dd'), ul = node('ul'); d.appendChild(ul); dl.appendChild(d);
		needs[id].forEach(function (e) {
			var li = node('li'), a = node('a', byId[e.requires].title);
			a.onclick = function () { reveal(e.requires); };
			li.appendChild(a); li.appendChild(document.createTextNode(' (' + e.kind + (e.group ? ', alternatives "' + e.group + '"' : '') + ')'));
			ul.appendChild(li);
		});
	}
}

function panelGroup(g) {
	var box = el('panel'); box.textContent = '';
	box.appendChild(node('h2', (stageTitle[g.stage] || g.stage) + ': ' + g.edges.length + ' steps folded'));
	var ul = node('ul'); box.appendChild(ul);
	g.edges.forEach(function (e) { var li = node('li'), a = node('a', byId[e.requires].title); a.onclick = function () { reveal(e.requires); }; li.appendChild(a); ul.appendChild(li); });
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
	var box = el('found'); box.textContent = '';
	var q = text.trim().toLowerCase(); if (!q) return;
	var needed = reach(S.goal).dist, hits = data.steps.filter(function (s) { return s.title.toLowerCase().indexOf(q) >= 0 || s.id.indexOf(q) >= 0; })
		.sort(function (a, b) { return (needed[a.id] === undefined) - (needed[b.id] === undefined); });
	hits.slice(0, 8).forEach(function (s) {
		var li = node('li'), a = node('a', s.title + (reach(S.goal).dist[s.id] === undefined ? ' (not needed by this goal)' : ''));
		a.onclick = function () { box.textContent = ''; reveal(s.id); }; li.appendChild(a); box.appendChild(li);
	});
	if (hits.length > 8) box.appendChild(node('li', '... ' + (hits.length - 8) + ' more: narrow the search'));
	if (!hits.length) box.appendChild(node('li', 'No step matches.'));
}

// ---- the tabs: a device per row of the devices table, then the generic one; the hash names the tab
function tabList() { return data.devices.map(function (d) { return d.id; }).concat([GENERIC]); }

function tabs() {
	var ul = el('tabs'); ul.textContent = '';
	tabList().forEach(function (id) {
		var li = node('li'), a = node('a', id === GENERIC ? 'generic' : tabName(id));
		a.href = '#' + id; a.id = 'tab-' + id; a.setAttribute('role', 'tab'); li.appendChild(a); ul.appendChild(li);
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
	var want = hashTab();
	S.tab = tabList().indexOf(want) >= 0 ? want : defaultTab();
	tabList().forEach(function (id) { el('tab-' + id).setAttribute('aria-selected', String(id === S.tab)); });
	el('open-only').disabled = S.tab === GENERIC; el('open-only').parentNode.hidden = S.tab === GENERIC;
	if (S.tab === GENERIC) S.openOnly = false;
	el('open-only').checked = S.openOnly;
	foldAll(); legend(); draw(true); panelReset();
}

// ---- the controls
function controls() {
	var sel = el('goal'), goalSteps = data.steps.filter(function (s) { return s.stage === GOAL_STAGE; });
	if (!goalSteps.length) throw new Error('the steps have no goal (stage ' + GOAL_STAGE + ')');
	goalSteps.forEach(function (s) { var o = node('option', s.title + ' (' + s.id + ')'); o.value = s.id; sel.appendChild(o); });
	if (byId[DEFAULT_GOAL]) sel.value = DEFAULT_GOAL;
	S.goal = sel.value;
	sel.onchange = function () { S.goal = sel.value; foldAll(); draw(true); panelReset(); el('found').textContent = ""; el('search').value = ""; };
	el('more').onclick = function () { change(function () { S.depth++; S.all = false; S.toggled.clear(); S.pinned.clear(); }, false); };
	el('less').onclick = function () { change(function () { S.depth = Math.max(0, S.depth - 1); S.all = false; S.toggled.clear(); S.pinned.clear(); }, false); };
	el('unfold').onclick = function () { change(function () { S.all = true; }, false); };
	el('fold').onclick = function () { foldAll(); draw(true); panelReset(); };
	el('open-only').onchange = function () { var box = this; if (!change(function () { S.openOnly = box.checked; }, true)) box.checked = S.openOnly; };
	el('search').oninput = function () { search(this.value); };
}

function start() {
	cytoscape.use(cytoscapeDagre);
	cy = cytoscape({ container: el('cy'), elements: [], style: STYLE, wheelSensitivity: 0.3, minZoom: 0.05, maxZoom: 2.5, boxSelectionEnabled: false });
	cy.on('tap', 'node', onTap);
	tabs(); controls();
	window.addEventListener('hashchange', showTab);
	window.addEventListener('resize', function () { cy.resize(); });
	showTab();
	say('');
}

function load() {
	if (typeof cytoscape === 'undefined' || typeof cytoscapeDagre === 'undefined') { say('The graph libraries did not load (they come from cdn.jsdelivr.net): reload when online.'); return; }
	fetch('graph/bringup.json').then(function (r) { if (!r.ok) throw new Error('graph/bringup.json: ' + r.status); return r.json(); })
		.then(function (d) { data = d; index(); start(); })
		.catch(function (e) { say('The steps did not load: ' + e.message); });
}
load();
