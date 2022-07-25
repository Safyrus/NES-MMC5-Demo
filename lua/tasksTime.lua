--
maxFrame = 60
lh = 30

--
loMdls = {}
hiMdls = {}
for i=1, maxFrame do
  loMdls[i] = 0
  hiMdls[i] = 0
end

--
function lowerModulesEnd()
  loMdls[1] = emu.getState().ppu.scanline
  if loMdls[1] > 240 then
    loMdls[1] = 0
  end
end

--
function higherModulesEnd()
  hiMdls[1] = emu.getState().ppu.scanline
  if hiMdls[1] > 240 then
    hiMdls[1] = 0
  end
end

--
function nextFrame()
  --
  timeUsageLo = 0
  timeUsageHi = 0
  
  --
  emu.drawRectangle(7, 7, maxFrame+2, lh+3, 0xA0000000, true, 1)
  for i=1, maxFrame do
    --
    emu.drawLine(i+7, lh+8, i+7, lh-(loMdls[i]*lh/240)+8, 0x60FF0000, 1)
    emu.drawLine(i+7, lh+8, i+7, lh-(hiMdls[i]*lh/240)+8, 0x80FF00FF, 1)
    --
    timeUsageLo = timeUsageLo + (loMdls[i] - hiMdls[i])
    timeUsageHi = timeUsageHi + hiMdls[i]
  end

  --
  timeUsageLo = timeUsageLo / maxFrame / 240 * 100
  timeUsageHi = timeUsageHi / maxFrame / 240 * 100
  
  --
  emu.drawString(maxFrame+10, 9, "LO:" .. math.ceil(timeUsageLo) .. "%", 0x00FFFFFF, 0xA0000000, 1)
  emu.drawString(maxFrame+10, 9+8, "HI:" .. math.ceil(timeUsageHi) .. "%", 0x00FFFFFF, 0xA0000000, 1)

  --
  adr = emu.getLabelAddress("game_flag")
  lag = emu.read(adr, emu.memType.cpuDebug) & 0x01
  color = 0x00FFFFFF
  if lag > 0 then
    color = 0x00FF0000
  end
  emu.drawString(maxFrame+10, 9+16, "LAG", color, 0xA0000000, 1)

  --
  for i=maxFrame, 1, -1 do
    hiMdls[i] = hiMdls[i-1]
    loMdls[i] = loMdls[i-1]
  end
  loMdls[1] = 240
  hiMdls[1] = 240
end

--
emu.displayMessage("Script", "Starting.")
emu.addEventCallback(nextFrame, emu.eventType.endFrame)

--
adr = emu.getLabelAddress("@run_lower_modules_end")
emu.addMemoryCallback(lowerModulesEnd, emu.memCallbackType.cpuExec, adr)

--
adr = emu.getLabelAddress("@run_higher_modules_end")
emu.addMemoryCallback(higherModulesEnd, emu.memCallbackType.cpuExec, adr)
