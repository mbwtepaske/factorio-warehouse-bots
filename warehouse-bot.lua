require("stdlib.table")

local Inspect = require("inspect")
local Entity = require("stdlib.entity.entity")
local Time = require("stdlib.time")

Bot = 
{
  Mode = 
  {
    Waiting     = 0;
    Following   = 1;
    Acting      = 2;
  };
  ActingMode    =
  {
    DropOff     = 1;
    PickUp      = 2;
  };
  WaitingMode   = 
  {
    Order       = 0;
    Recharge    = 1;
  };
  
  Names =
  {
    "warehouse-bot"
  };
}

function CreateState(entity)
  return
  {
    Orientation = entity.orientation;
    Position    = entity.position;
    Speed       = entity.speed;
  }
end

function UpdateEnergy(entity)
  if entity.Tick % 90 == 0 then
  --  game.print(string.format("UpdateEnergy(%i): Entity = '%3f' (%3f)", entity.unit_number or -1, entity.energy, energy))  
  end
  
  entity.Entity.energy = 6
  entity.energy = 10
end

function UpdateStates(entity)
  entity.Previous = entity.Current
  entity.Current  = CreateState(entity)
  entity.Tick = entity.Tick + 1
  
end

function Bot.Create(entity)  
  if Bot.IsWarehouseBot(entity) then
    return setmetatable(
    {
      Entity      = entity;
      Current     = CreateState(entity);
      Previous    = CreateState(entity);
      Target      = CreateState(entity);
      Tick        = 42;
    }, { __index = entity })    
  end
  
  game.print(string.format("Bot.Create(%i) failed! Entity = '%s' (%s)", entity.unit_number or -1, entity.name, entity.type))
  
  return entity
end

function Bot.Destroy(entity)
  if Bot.IsWarehouseBot(entity) then
  end
end

function Bot.IsWarehouseBot(entity)  
  for _, name in ipairs(Bot.Names) do
    if entity.name == name then
      return true
    end
  end
  
  return false
end

function Bot.Readout(entity)
  local tile = entity.surface.get_tile(math.floor(entity.position.x), math.floor(entity.position.y))
  
  local front_position = entity.position
  local orientation = math.floor((entity.orientation + 0.125) * 4)
  
  if      orientation < 1 then front_position = { x = front_position.x + 0; y = front_position.y - 1; }
  elseif  orientation < 2 then front_position = { x = front_position.x + 1; y = front_position.y - 0; }
  elseif  orientation < 3 then front_position = { x = front_position.x + 0; y = front_position.y + 1; }
  elseif  orientation < 4 then front_position = { x = front_position.x - 1; y = front_position.y + 0; }
  end
  
  local front_tile = entity.surface.get_tile(front_position)
  
  game.print(string.format("Tick: %i\tTile (Current): %s\tTile (Front): %s\tPosition (Current / Next): [%.2f, %.2f]/[%.2f, %.2f]\tDirection: %.3f\nSpeed: %.1f KM/h\tEnergy: %.1f"
    , entity.Tick
    , tile.prototype.name
    , front_tile.prototype.name
    , entity.position.x
    , entity.position.y
    , front_position.x
    , front_position.y
    , entity.orientation
    , entity.speed * 216
    , entity.energy
    ))
end

function Bot.Update(entity)
  local sign = 0
  
  if      entity.speed > 0 then sign =  1
  elseif  entity.speed < 0 then sign = -1
  end
  
  entity.speed  = math.min(math.abs(entity.speed), 40.0 / 206.0) * sign
  
  UpdateEnergy(entity)
  UpdateStates(entity)
end

function Bot.OnBuildEntity(entity, instigator)
  if Bot.IsWarehouseBot(entity) then
    global.BotList[entity.unit_number] = Bot.Create(entity)
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

function Bot.OnReadout(entity)    
  if entity and Bot.IsWarehouseBot(entity) then
    Bot.Readout(global.BotList[entity.unit_number])
  else
    game.print(string.format("No warehouse-bot selected! Name = %s (%s)", entity.name, entity.type))
  end
end

function Bot.OnTick()
  for unit_number, entity in pairs(global.BotList) do
    Bot.Update(entity)
  end
end