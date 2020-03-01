---
-- ?
---

which_world = 1

-- order of includes matters in this case
include ('lib/zerg/util')  -- extra utilities
include ('lib/zerg/worlds') -- world data
include ('lib/zerg/cuts')  -- softcut setup

function set_world(ix)
   print('setting world: ' .. ix)
   which_world = ix
   cut_set_world(ix)
end

include ('lib/zerg/moves') -- sequence
include ('lib/zerg/eyes')  -- visuals
include ('lib/zerg/hands')  -- logic

function init()
   begin_cuts()
   begin_moves()
   --begin_eyes()
   begin_hands()
end

function enc(n,z) 
  if n == 1 then delta_volume(z) end
  if n == 2 then delta_bright(z) end
  if n == 3 then delta_dense(z) end
end

function key(n,z) 
  if n == 2 then press_evolve(z) end
  if n == 3 then press_world(z) end
end
