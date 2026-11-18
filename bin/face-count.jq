# How many of a goal's steps a device has done: X of N, from tad q bringup-chain --goal G --device D. A step not
# needed counts, as it does for readiness.
"\([.[] | select(.status | IN("done", "not-needed"))] | length) of \(length)"
