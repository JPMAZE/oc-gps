
local component = require("component")
local gps = require("gps")
local serialization = require("serialization")
local event = require("event")

local CHANNEL_GPS = 65534
local modem = component.modem

local function printUsage()
  print( "Usages:" )
  print( "gps host" )
  print( "gps host <x> <y> <z>" )
  print( "gps locate" )
end

local tArgs = { ... }
if #tArgs < 1 then
  printUsage()
  return
end

local function readNumber()
  local num = nil
  while num == nil do
    num = tonumber(io.read())
    if not num then
      write( "Not a number. Try again: " )
    end
  end
  return math.floor( num + 0.5 )
end

local function wirelessmodem()
  if modem.isWireless() then
    return true
  else
    print("No wireless network card installed")
    return false
  end
end
 
local sCommand = tArgs[1]
if sCommand == "locate" then
  if wirelessmodem() then
    gps.locate( 2, true )
  end
  
elseif sCommand == "host" then
  if robot then
    print( "Robots cannot act as GPS hosts." )
    return
  end

  if wirelessmodem() then
    local x, y, z
    if #tArgs >= 4 then
      x = tonumber(tArgs[2])
      y = tonumber(tArgs[3])
      z = tonumber(tArgs[4])
      if x == nil or y == nil or z == nil then
        printUsage()
        return
      end
      print( "Position is "..x..","..y..","..z )
    else
      x,y,z = gps.locate( 2, true )
      if x == nil then
        print( "Run \"gps host <x> <y> <z>\" to set position manually" )
        return
      end
    end
  
    print( "Serving GPS requests" )
  
    local nServed = 0
    while true do
      _, _, sender, _, distance, message = event.pull("modem_message")
      if message == "PING" then
        modem.send(sender, CHANNEL_GPS, serialization.serialize({x,y,z}))
        
        nServed = nServed + 1
        --[[if nServed > 1 then
          local x, y = term.getCursorPos()
          term.setCursorPos(1,y-1)
        end]]
        print( nServed.." GPS Requests served" )
      end
    end
  end
  
else
  printUsage()
  return
end