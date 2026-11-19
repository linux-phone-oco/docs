# The bring-up graph's data, as JSON, from the bring-up rows (bin/render-pages.sh feeds it): docs/graph/bringup.json,
# which docs/graph.html draws. Arguments, each a one-element array of the rows: steps, edges, devices, status.
# The page reads the devices from here, so a device added to the devices table gets its tab without a change to it.
{
  steps: ($steps[0] | map({id, title, stage, done_when, proof, guide})),
  edges: ($edges[0] | map({step, requires, kind, group})),
  devices: ($devices[0] | map({id, name, codename})),
  status: ($status[0] | map({device_id, step_id, status}))
}
