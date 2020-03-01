local sc = softcut

local load_files = function()
   pos = 0
   for k,v in zongs do
      local file = _path.code .. "nc01-drone/lib/" .. k .. ".wav"
      local frames, _, _ = audio.file_info(file)
      local dur = frames * 48000  -- magic samplerate of norns, not file
      sc.buffer_read_stereo(file,
			    0,    -- start time in source
			    pos,  -- start time in buffers
			    dur)
      pos = pos + dur      
   end
   
begin_cuts = function()
   load_files()
end

      
