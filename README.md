# Fixing floating sands

This mod enhances map generation; it replaces any falling blocks above air into their solid form. Currently, Minetest Game is supported. Other mods could register their list of falling nodes by adding entries into the `fix_floating.list_nodes` table.

Now, no sand nor gravel would fall upon contact; but this raises another question; what keeps the sandstones in place? The 9.81 meters per second gravity due to Earth is being ignored...

## Known Bugs

* If a WorldEdit operation places supported falling blocks out of the currently emerged areas without support, they would be transformed into solid blocks. This is due to those modifications being done pre-emerge; the phenomenon of such blocks being affected by map generation (e.g. ore generation) is a known upstream bug.
