local sc = softcut

world_start = {}
world_end = {}

local load_files = function()
   local pos = 0
   local i = 1
   for i,k in ipairs(world_keys) do
      local file = _path.code .. "nc01-drone/lib/" .. k .. ".wav"
      local _, frames, _ = audio.file_info(file)
      local dur = worlds[k].dur
      sc.buffer_read_stereo(file, worlds[k].start, pos, dur)
      world_start[i] = pos
      world_end[i] = pos+dur
      print(file, world_start[i], world_end[i])
      pos = pos + dur
      i = i+1
   end
   tab.print(world_start)
   tab.print(world_end)
end

set_voice_world = function(i, z, start_off, end_off)
   
   print("set_voice world; voice="..i.."; world="..z.."; off: ", start_off, end_off)
   print("world_key: "..world_keys[z])
   local zs = world_start[z] + start_off
   local ze = world_end[z] + end_off
   print("loop: ", zs, ze)
    sc.loop_start(i, zs)
    sc.loop_start(i+3, zs)
    sc.loop_end(i, ze)
    sc.loop_end(i+3, ze)
    local hz1 = worlds[world_keys[z]].key_hz
    local hz2= hz1
    local r = worlds[world_keys[z]].ratios
    if (i>1) then
       hz1 = hz1 * r[i-1][1] / r[i-1][2]
       hz2 = hz2 * r[i+1][1] / r[i+1][2]
    end
    while (hz1 > 200) do hz1 = hz1 / 2 end
    while (hz2 > 200) do hz2 = hz2 / 2 end
    sc.post_filter_fc(i,hz1)
    sc.post_filter_fc(i+3,hz2)    
end

set_voice_pos = function(i, pos)
   local zs = world_start[which_world]
   local ze = world_end[which_world]
   local scaled_pos = zs + pos*(ze-zs)
   --print(i, pos, zs, ze, scaled_pos)
   if scaled_pos > ze then
      print ("!!!!!!!!!!!!!!!")
      print ("!!!!!!!!!!!!!!!")
      print(pos, scaled_pos, ze)
   end

   if scaled_pos < zs then
      print ("!!!!!!!!!!!!!!!")
      print ("!!!!!!!!!!!!!!!")
      print(pos, scaled_pos, zs)
   end

    sc.position(i, scaled_pos)
    sc.position(i+3, scaled_pos)
end 

cut_set_world = function(z)
   for i=1,3 do
    set_voice_world(i, z, i, -2*i)
    set_voice_pos(i, voice_pos[i])
    print("setting world; setting voice pos: ", i, voice_pos[i])
    print("current, z: ", which_world, z)
  end
end 

cur_voice_rate_idx = { 1, 2, 3 }
cut_advance_voice_rate = function()
   for i=1,3 do
      cur_voice_rate_idx[i] = cur_voice_rate_idx[i] + 1
      if cur_voice_rate_idx[i] > 4 then cur_voice_rate_idx[i] = 1 end
      print( cur_voice_rate_idx[i])
      local ratio = worlds[world_keys[which_world]].ratios[cur_voice_rate_idx[i]]
      sc.rate(i, ratio[1] / ratio[2])
   end
end

begin_cuts = function()
   load_files()
   
   for i=1,6 do
    sc.enable(i, 1)
    sc.level(i, 0.5)
    sc.loop(i,1)
    sc.rate(i,1.0)
    sc.play(i,1)
    sc.rec(i,1)
    sc.rec_level(i,0)
    sc.pre_level(i,1)
    sc.post_filter_dry(i,0)
    sc.post_filter_lp(i,0.5)
    sc.post_filter_hp(i,0)
    sc.post_filter_bp(i,0.25)
    sc.post_filter_br(i,0)
    sc.post_filter_rq(i,1/12)
   end
  
   for i=1,3 do
    sc.buffer(i, 1)
    sc.buffer(i+3, 2)
    sc.pan(i, -1)
    sc.pan(i+3, 1)
  end
  
  sc.level_cut_cut(1, 4, 1)
  sc.level_cut_cut(2, 5, 1)
  sc.level_cut_cut(3, 6, 1)
  sc.level_cut_cut(4, 1, 1)
  sc.level_cut_cut(5, 2, 1)
  sc.level_cut_cut(6, 3, 1)
  
  cut_set_world(which_world)
   
end

      
