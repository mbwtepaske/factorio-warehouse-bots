local Time = require("stdlib.time")

local Bot = {}

function Bot.Create(entity) 

  local bot = 
  {
    Entity      = entity;
    Battery     = 5E3 * Time.HOUR / Time.SECOND; -- 5 KWh battery
    SpeedLimit  = 2.5; -- Tiles / second
    Current     = CreateState(entity);
    Previous    = CreateState(entity);
    Target      = CreateState(entity);
    Tick        = 0;
  }  
  
  setmetatable(bot, self)
  
  self.__index = self
  
  return bot
end

function CreateState(entity)
  return
  {
    Orientation = entity.orientation;
    Position    = entity.position;
    Speed       = entity.speed;
  }
end

function Bot.Update(self)
  local entity = self.Entity
  local sign = 0
  
  if      entity.speed > 0 then sign =  1
  elseif  entity.speed < 0 then sign = -1
  end
  
  entity.speed = math.min(math.abs(entity.speed), 20.0 / 216.0) * sign
  
  self.Tick = self.Tick + 1
  
  UpdateEnergy(self, entity)
  UpdateStates(self, entity)
end

function UpdateEnergy(self, entity)
  --entity.energy = entity.energy + (2.5E2 / Time.SECOND)
  --entity.energy = math.min(entity.energy, self.Battery)
  entity.energy = self.Battery  
end

function UpdateStates(self, entity)
  self.Previous = self.Current
  self.Current  = CreateState(self.Entity)
end

function Bot.Readout(self)
  local entity = self.Entity
  local tile = entity.surface.get_tile(math.floor(entity.position.x), math.floor(entity.position.y))
  
  game.print(string.format("Tile: %s\nBattery: %.2f\nPosition: [%.2f, %.2f]\nDirection: %.f0\nSpeed: %.1f KM/h"
    , tile.prototype.name
    , entity.energy
    , entity.position.x
    , entity.position.y
    , entity.orientation * 360
    , entity.speed * 216
    ))
end

return Bot