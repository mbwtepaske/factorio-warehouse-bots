require("stdlib.table")

local Inspect   = require("inspect")
local Entity    = require("stdlib/entity/entity")
local Position  = require('stdlib/area/position')
local Time      = require("stdlib/time")

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

function Bot.GetPositionAhead(entity, range)
  range = range or 1
  
  local orientation = math.floor((entity.orientation + 0.125) * 4)
  
  if      orientation < 1 then return { x = entity.position.x;          y = entity.position.y - range; }
  elseif  orientation < 2 then return { x = entity.position.x + range;  y = entity.position.y; }
  elseif  orientation < 3 then return { x = entity.position.x;          y = entity.position.y + range; }
  elseif  orientation < 4 then return { x = entity.position.x - range;  y = entity.position.y; }
  end
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
  --local sign = 0
  
  --if      entity.speed > 0 then sign =  1
  --elseif  entity.speed < 0 then sign = -1
  --end
  --
  --entity.speed  = math.min(math.abs(entity.speed), 10.0 / 60.0) * sign
  
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
  
  if acceleration == defines.riding.acceleration.nothing then
    if global.TileMap then
      local direction_entity = entity.surface.find_entity(Tile.DirectionTile, entity.position) -- global.TileMap[position]
      
      if direction_entity then
        game.print(string.format("Test 123: Direction = %s", game.direction_to_string(direction_entity.direction)))
      else
        game.print(string.format("Test 123: No direction! #Connections: %i", #global.TileMap))
      end
    end
  elseif acceleration == defines.riding.acceleration.accelerating then
    
  end
end

function Bot.OnBuildEntity(entity, instigator)
  if Bot.IsWarehouseBot(entity) then
    global.BotList[entity.unit_number] = entity
    
    if entity.valid and entity.grid and #entity.grid.equipment == 0 then
      local battery = entity.grid.put
      { 
        name      = "warehouse-bot-battery";
        position  = { 0; 0 }
      }
      
      battery.energy = battery.max_energy * 0.8
    end
  end
end

function Bot.OnDestroyEntity(entity, instigator)
	if Bot.IsWarehouseBot(entity) then
    global.BotList[entity.unit_number] = nil
	end
end

function Bot.OnInitialize()
	--global.BotDataList = global.BotDataList or {}
	global.BotList = global.BotList or {}
end

function Bot.OnLoad()
end

function Bot.OnReadout(entity)    
  if entity and Bot.IsWarehouseBot(entity) then
    Bot.Readout(global.BotList[entity.unit_number])
  else
    game.print(string.format("No warehouse-bot selected! Name = %s (%s)", entity.name, entity.type))
  end
end

function Bot.OnTick()
  for _, entity in pairs(global.BotList) do
    if entity.valid then
      Bot.Update(entity)
    else
    end
  end
end