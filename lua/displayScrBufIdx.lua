function drawScreenBufferIdx()
  --Get the emulation state
  state = emu.getState()

  --Draw the background
  emu.drawRectangle(8, 8, 64, 38, 0x80699EFC, true, 1)
  emu.drawRectangle(8, 8, 64, 38, 0x80FEFFFF, false, 1)

  for j=0,2 do
    for i=0,2 do
      -- Get the screen index
      adr_idx = emu.getLabelAddress("scrbuf_update_array_scr")
      scrBufIdx = emu.read(adr_idx+i+(j*3), emu.memType.cpuDebug, false)

      -- Get if the screen buffer is loading
      adr_act = emu.getLabelAddress("scrbuf_update_array_act")
      busy = emu.read(adr_act+i+(j*3), emu.memType.cpuDebug, false) > 0
      
      fgColor = 0xFFFFFF
      -- Change the color if the screen buffer is loading
      if busy then
        fgColor = 0x20FF0000
      end
      
      -- Print the index
      emu.drawString(11+i*20, 11+j*12, scrBufIdx, fgColor, 0xFF000000)
    end
  end
end

--Register some code (printInfo function) that will be run at the end of each frame
emu.addEventCallback(drawScreenBufferIdx, emu.eventType.endFrame)

--Display a startup message
emu.displayMessage("Script", "Displaying current screen buffer index")
