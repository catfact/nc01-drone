local sc = softcut

world_start = {}
world_end = {}


local load_files = function()
   local pos = 0
   local i = 1
   for k,v in pairs(worlds) do
      local file = _path.code .. "nc01-drone/lib/" .. k .. ".wav"
      print(file)
      local _, frames, _ = audio.file_info(file)
      local dur = frames / 48000  -- magic samplerate of norns, not file
      -- file, start_src, start_dst, dur
      sc.buffer_read_stereo(file, 0, pos, -1)
      world_start[i] = pos
      pos = pos + dur
      world_end[i] = pos
      i = i+1
   end
   tab.print(world_start)
   tab.print(world_end)
end

set_voice_world = function(i, z, start_off, end_off)
   print("set_voice world; voice="..i.."; world="..z.."; off: ", start_off, end_off)
   local zs = world_start[z] + start_off
   local ze = world_end[z] + end_off
    sc.loop_start(i, zs)
    sc.loop_start(i+3, zs)
    sc.loop_end(i, ze)
    sc.loop_end(i+3, ze)
    local hz1 = worlds[world_keys[i]].key_hz
    local hz2= hz1
    local r = worlds[world_keys[i]].ratios
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
   --print(i, pos)
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

      
