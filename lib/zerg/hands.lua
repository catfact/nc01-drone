function begin_hands()
  --...
end

delta_volume = function(z)
end

delta_bright = function(z)
end

delta_dense = function(z)
end

press_evolve = function(z)
end

local world = 1
press_world = function(z)
  if z == 1 then
    world = world + 1
    if world > 3 then world = 1 end
    set_world(world)
  end
end

