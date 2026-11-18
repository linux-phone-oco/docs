# The cells of the face's steps view: a cell for every step and every device that has a claim, the claim in the words
# the face draws (failing is fail, not-needed is n/a: the engine knows no other bad or not-applicable words), and in
# notes the claim as it stands. A step the device's base never claimed is unknown, and says so.
# Arguments, each a one-element array of rows: steps (id), claims (device_id, step_id, status, proof, run, notes).
def face: if . == "failing" then "fail" elif . == "not-needed" then "n/a" else . end;
($claims[0] | map({key: "\(.device_id) \(.step_id)", value: .}) | from_entries) as $c
| ([$claims[0][].device_id] | unique) as $devices
| $devices[] as $d | $steps[0][] | .id as $id | ($c["\($d) \($id)"]) as $x
| if $x == null then {device_id: $d, step_id: $id, status: "unknown", notes: "not known yet: its base has not claimed this step"}
  else {device_id: $d, step_id: $id, status: ($x.status | face),
        notes: ([(if $x.status | IN("failing", "not-needed") then "claimed \($x.status)" else empty end),
                 (if $x.proof then "proof \($x.proof)" else empty end), (if $x.run then "run \($x.run)" else empty end),
                 (if $x.notes then $x.notes else empty end)] | join("; "))} end
| . + {project: "linux-phone-oco/docs"}
