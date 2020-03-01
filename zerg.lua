---
-- ?
---

-- order of includes matters in this case
include ('lib/zerg/util')  -- extra utilities
include ('lib/zerg/zongs') -- zong data
include ('lib/zerg/cuts')  -- softcut setup
include ('lib/zerg/moves') -- sequence
include ('lib/zerg/eyes')  -- visuals
include ('lib/zerg/hands')  -- logic

function init()
   begin_cuts()
   begin_moves()
   begin_eyes()
   begin_hands()
end

local press_nothing = function(n,z) end
enc_fn = { delta_volume, delta_bright, delta_dense }
key_fn = { press_nothing, press_evolve, press_world }

function enc(n,z) enc_fn[n](z) end
function key(n,z) key_fn[n](z) end
