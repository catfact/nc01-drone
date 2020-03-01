function begin_hands()
   params:add_number("bright", "bright", 0, 256)
   params:set_action("bright", function(val)
			local dry = val/256
			local lp =  1 - dry
			local bp = 1 - dry
			local rq = 1 - (val/222)
			for i=1,6 do
			   softcut.post_filter_dry(i, dry)
			   softcut.post_filter_lp(i, lp)
			   softcut.post_filter_bp(i, bp)
			   softcut.post_filter_br(i, bp * 0.25)
			   softcut.post_filter_rq(i, rq)
			end
   	
   end)
   params:add_number("dense", "dense", 0, 256)
   params:set_action("dense", function(val)
			local rec = val/512
			local pre = val/1024
			for i=1,6 do
			   softcut.rec_level(i, rec)
			   softcut.rec_level(i, pre)
			end
   end)
end

delta_volume = function(z)
end

delta_bright = function(z)
   params:delta("bright", z);
end

delta_dense = function(z)   
   params:delta("dense", z);
end

press_evolve = function(z)
   cut_advance_voice_rate()
end

local world = 1
press_world = function(z)
  if z == 1 then
    world = world + 1
    if world > 3 then world = 1 end
    set_world(world)
  end
end

