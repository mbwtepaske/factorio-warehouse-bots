local Bot = require("bot")
local Inspect = require("inspect")
local Time = require("stdlib.time")

function OnCommand(player, command, parameters)  
end

function OnConfigurationChanged() 
  OnInitialize()
end

function OnBuild(item)
	local entity = item.created_entity
	
	if entity.type == "car" and entity.name == "warehouse-bot" then       
    game.print("Build: " .. entity.unit_number)
    
    global.BotList[entity.unit_number] = Bot.Create(entity)    
	end
  
  if entity.name == "warehouse-direction-tile" then
    for direction, v in pairs(defines.direction) do
      if v == entity.direction then
        game.print("Build: " .. direction)
      end
    end
    
    for direction, value in pairs(defines.direction) do
      if value == entity.direction then
        entity.surface.set_tiles({ { name = "warehouse-direction-tile-" .. direction, position = entity.position } }, false)    
        break        
      end
    end
    
    entity.destroy()    
  end
end

function OnDestroy(item)
	local entity = item.entity
	
	if entity.type == "car" and entity.name == "warehouse-bot" then
    game.print("Destroy: " .. entity.unit_number)
    
    global.BotList[entity.unit_number] = nil
	end
end

function OnInitialize()
	global.BotList = global.BotList or {}  
end

function OnLoad()
end

function OnTick()
	if global.BotList then
    for key, bot in pairs(global.BotList) do
      if bot then
        --game.print(type(bot) .. Inspect(bot))
        Bot.Update(bot)
      end
    end
	end
end

--function OnParade()
--  for index, bot in pairs(global.BotList) do
--    --bot.Entity.speed = bot.Entity.speed + 0.01
--  end
--end

script.on_event("bot-readout", function(event)
  game.print(Inspect(event))
  
  if global.BotList then
    for key, bot in pairs(global.BotList) do
      Bot.Readout(bot)
    end
	end
end)


script.on_init(OnInitialize)
script.on_load(OnLoad)
script.on_configuration_changed(OnConfigurationChanged)
script.on_event(defines.events.on_built_entity, OnBuild)
script.on_event(defines.events.on_robot_built_entity, OnBuild)
--script.on_event(defines.events.on_console_command, OnCommand)
script.on_event(defines.events.on_preplayer_mined_item, OnDestroy)
script.on_event(defines.events.on_robot_pre_mined, OnDestroy)
script.on_event(defines.events.on_entity_died, OnDestroy)
script.on_event(defines.events.on_tick, OnTick)
remote.add_interface("WarehouseBots", 
{
  --Parade = OnParade
})  