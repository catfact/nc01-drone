local ratio_to_tick_count = function(num,denom)
   return gcd(num,denom)
end

local tick_count = tab_map(zongs, function(k,v)
			      local r = v['ratios']
			      local num = tab_map(r, function(i,v)						     end						  
			      )
						  
end)

local handle_tick = function(count)
   
end

begin_hands = function()   
   tick = require('metro').init(handle_tick, 0.001)
   tick:start()
end
