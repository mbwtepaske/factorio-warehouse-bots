require("stdlib/utils/table")

local Inspect   = require("inspect")
local Entity    = require("stdlib/entity/entity")
local Position  = require('stdlib/area/position')
local Time      = require("stdlib/defines/time")

Bot = 
{  
  Names =
  {
    "warehouse-bot"
  };
  Cache =
  {
  }
}

function Bot.IsWarehouseBot(entity)  
  for _, name in ipairs(Bot.Names) do
    if entity.name == name then
      return true
    end
  end
  
  return false
end

function Bot.GetAreaAhead(entity, range)
  range = range or 1
  
  local orientation = math.floor((entity.orientation + 0.125) * 4)
  local area = 
  {
    
  }
  local position = entity.position
  
  if      orientation < 1 then return { x = entity.position.x;          y = entity.position.y - range; }
  elseif  orientation < 2 then return { x = entity.position.x + range;  y = entity.position.y; }
  elseif  orientation < 3 then return { x = entity.position.x;          y = entity.position.y + range; }
  elseif  orientation < 4 then return { x = entity.position.x - range;  y = entity.position.y; }
  end
end

function Bot.GetPositionAhead(entity, range)
  range = range or 1
  
  local orientation = math.floor((entity.orientation + 0.125) * 4)
  
  if      orientation < 1 then return { x = entity.position.x;          y = entity.position.y - range; }
  elseif  orientation < 2 then return { x = entity.position.x + range;  y = entity.position.y; }
  elseif  orientation < 3 then return { x = entity.position.x;          y = entity.position.y + range; }
  elseif  orientation < 4 then return { x = entity.position.x - range;  y = entity.position.y; }
  end
end

function Bot.GetDirection(entity)
  return math.floor(entity.orientation * 8 + 0.5)
end

function Bot.Readout(entity)
  local tile = entity.surface.get_tile(math.floor(entity.position.x), math.floor(entity.position.y))
  
  local front_position = Bot.GetPositionAhead(entity, 1)  
  local front_tile = entity.surface.get_tile(front_position)
  
  game.print(string.format("Tile (Current): %s\tTile (Front): %s\tPosition (Current / Next): [%.2f, %.2f]/[%.2f, %.2f]\tDirection: %.3f\nSpeed: %.1f m/s\tBattery: %i %%"
    , tile.prototype.name
    , front_tile.prototype.name
    , entity.position.x
    , entity.position.y
    , front_position.x
    , front_position.y
    , entity.orientation
    , entity.speed  * 60
    , (entity.grid.available_in_batteries / entity.grid.battery_capacity) * 100
    ))
end

function Bot.Update(entity)
  Bot.UpdateEnergy(entity)
  Bot.UpdateStates(entity)
end

function Bot.UpdateEnergy(entity)
  local grid        = entity.grid
  local available   = grid.available_in_batteries
  local consumption = entity.prototype.consumption
  
  for index = #grid.equipment, 1, -1 do
    local equipment = grid.equipment[index]
    
    if entity.energy < consumption and equipment.energy > 0 then
      local drain = math.min(equipment.energy, consumption - entity.energy)
    
      equipment.energy  = equipment.energy - drain
      entity.energy     = entity.energy + drain
    end
  end
end

function Bot.UpdateStates(entity)
  local acceleration  = entity.riding_state.acceleration
  local position      = Position.ceil(entity.position)
  
  if entity.speed == 0 then
    local direction_entity = entity.surface.find_entity(Tile.DirectionTile, Position.center(entity.position))
    
    if direction_entity then
      local current_orientation = entity.orientation
      local target_orientation = direction_entity.direction / 8      
      
      if current_orientation ~= target_orientation then
        --game.print(string.format("Tile: %i°, Bot: %i°", target_orientation * 360, current_orientation * 360))
        
        -- Bot is unaligned with tile orientation, rotate the bot...
        global.BotRotatingTable[entity.unit_number] = target_orientation
      else
        -- Bot is aligned with tile orientation, move the bot forward...
        global.BotMovingTable[entity.unit_number] = 2.5 / 60 -- Target velocity: 2.5 Tile / second
      end
    else
      --game.print(string.format("No direction!"))
    end
  --elseif acceleration == defines.riding.acceleration.accelerating then
  end
end

function Bot.UpdateOrientation(entity)
  local current_orientation = entity.orientation
  local target_orientation = global.BotRotatingTable[entity.unit_number]
  
  if target_orientation ~= nil then
    if math.abs(current_orientation - target_orientation) <= entity.prototype.rotation_speed then
    
      -- Stop turning around
      Bot.UpdateRidingState(entity, nil, defines.riding.direction.straight)
      
      -- Snap to target orientation
      entity.orientation = target_orientation
      
      -- Remove the bot from the rotating state table
      global.BotRotatingTable[entity.unit_number] = nil    
    elseif entity.riding_state.direction == defines.riding.direction.straight then
    
      local difference = target_orientation - current_orientation
      
      if (difference <= 0.5 and difference > 0) or (1 + difference <= 0.5) then
        -- Turn clock-wise
        Bot.UpdateRidingState(entity, nil, defines.riding.direction.right)
      else
        -- Turn counter-clock-wise
        Bot.UpdateRidingState(entity, nil, defines.riding.direction.left)
      end
    end
  end
end

function Bot.UpdateRidingState(entity, acceleration, direction)
  local current_state = entity.riding_state
  
  entity.riding_state =
  {
    acceleration  = acceleration  or current_state.acceleration;
    direction     = direction     or current_state.direction;
  }
end

function Bot.UpdateVelocity(entity)
  local current_velocity = entity.speed
  local target_velocity = global.BotMovingTable[entity.unit_number]
  
  if target_velocity ~= nil then
    local look_ahead_area = {}
    --if global.Tick % 30 == 0 then
    --  --game.print(string.format("Current: %.3f, Previous: %.3f, Difference: %.3f"
    --  --  , entity.speed * 60
    --  --  , global.Temp  * 60
    --  --  , math.abs(entity.speed - global.Temp) * 60))  
    --  --global.Temp = entity.speed
    --end
    
    --if entity.speed == target_velocity then
    --  local p = entity.position
    --  local t = global.Temp
    --  local distance = math.sqrt(math.abs(p.x - t.x)^2 + math.abs(p.y - t.y)^2)
    --  local time = global.Tick / 60
    --  local a = distance / (0.80 * 60 * time + 0.5 * time ^ 2)
    --  game.print(string.format("Distance: %.5f m, Time: %.5f s, Acceleration: %.5f m/s^2", distance, time, a))
    --  global.BotMovingTable[entity.unit_number] = nil      
    --  return
    --end
    --
    --if entity.speed < target_velocity then
    --  --Bot.UpdateRidingState(entity, defines.riding.acceleration.accelerating, nil)
    --else
    --  --entity.speed = target_velocity
    --  --Bot.UpdateRidingState(entity, defines.riding.acceleration.nothing, nil)
    --end
  end
end

function Bot.StopProcedure(entity)
  entity.speed = 0.80
  global.Tick = 0
  global.Time = 0
  global.Temp = entity.position
  global.BotMovingTable[entity.unit_number] = 0
  
  Bot.UpdateRidingState(entity, defines.riding.acceleration.braking, nil)  
end

function Bot.OnBuildEntity(entity, instigator)
  if Bot.IsWarehouseBot(entity) then
    global.BotTable[entity.unit_number] = entity
    
    if entity.valid and entity.grid and #entity.grid.equipment == 0 then
      -- Create a new battery for the robot
      local battery = entity.grid.put(
      { 
        name      = "warehouse-bot-battery";
        position  = { 0; 0 }
      })
      
      battery.energy = battery.max_energy * 0.8
    end
  end
end

function Bot.OnDestroyEntity(entity, instigator)
	if Bot.IsWarehouseBot(entity) then
    global.BotTable[entity.unit_number] = nil
	end
end

function Bot.OnInitialize()
  
  if not global.BotMovingTable then
    global.BotMovingTable = {}
  end
  
  if not global.BotRotatingTable then
    global.BotRotatingTable = {}
  end
  
	if not global.BotTable then
    global.BotTable = {}
  end
  
  global.Temp = 0
  global.Tick = 0
  global.Time = 0
end

function Bot.OnLoad()
end

function Bot.OnReadout(entity)    
  if entity and Bot.IsWarehouseBot(entity) then
    Bot.Readout(global.BotTable[entity.unit_number])
  else
    game.print(string.format("No warehouse-bot selected! Name = %s (%s)", entity.name, entity.type))
  end
end

function Bot.OnTick()
  global.Tick = global.Tick + 1
  for unit_number, entity in pairs(global.BotTable) do
    if entity.valid then
      Bot.UpdateEnergy(entity)
      
      if global.BotMovingTable[unit_number] then
        Bot.UpdateVelocity(entity)
      elseif global.BotRotatingTable[unit_number] then
        Bot.UpdateOrientation(entity)
      else
        Bot.UpdateStates(entity)
      end
    else
    end
  end
end