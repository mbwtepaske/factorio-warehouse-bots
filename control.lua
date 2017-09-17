local Bot = require("bot")
local Inspect = require("inspect")
local Time = require("stdlib.time")

function OnCommand(player, command, parameters)  
end

function OnConfigurationChanged() 
  OnInitialize()
end

script.on_configuration_changed(OnConfigurationChanged)

function OnBuildEntity(entity, instigator)	
	if entity.type == "car" and entity.name == "warehouse-bot" then
    global.BotList[entity.unit_number] = Bot.Create(entity)    
	end
  
  if entity.name == "warehouse-direction-tile" or entity.name == "warehouse-direction-tile-ghost" then
    local entity = entity.surface.create_entity
    { 
      name          = "warehouse-direction-tile-ghost";
      direction     = entity.direction;
      fast_replace  = true;
      force         = "player";
      position      = entity.position;
      operable      = false;
      spill         = false;
    }
    
    entity.operable = false    
    entity.surface.set_tiles(
    {
      { 
        name = "warehouse-direction-tile-" .. string.lower(game.direction_to_string(entity.direction));
        position = entity.position;
      } 
    }, false)
  end
end

script.on_event(defines.events.on_built_entity, function(event) OnBuildEntity(event.created_entity, game.players[event.player_index]) end)
script.on_event(defines.events.on_robot_built_entity, function(event) OnBuildEntity(event.created_entity, event.robot) end)

function OnBuildTile(positions, instigator)
  
end

function OnDestroyEntity(entity, instigator)
	if entity.type == "car" and entity.name == "warehouse-bot" then
    global.BotList[entity.unit_number] = nil
	end
  
  if entity.name == "warehouse-direction-tile-ghost" then
    instigator.mine_tile(entity.surface.get_tile(entity.position.x, entity.position.y))
  end
end

script.on_event(defines.events.on_entity_died, function(event) OnDestroyEntity(event.entity, event.cause or event.last_user) end)
script.on_event(defines.events.on_preplayer_mined_item, function(event) OnDestroyEntity(event.entity, game.players[event.player_index]) end)
script.on_event(defines.events.on_robot_pre_mined, function(event) OnDestroyEntity(event.entity, event.robot) end)

function OnRotateEntity(entity, instigator)
  if entity.name == "warehouse-direction-tile-ghost" then
    entity.surface.set_tiles(
    {
      { 
        name = "warehouse-direction-tile-" .. string.lower(game.direction_to_string(entity.direction));
        position = entity.position;
      } 
    }, false)
  end
end

script.on_event(defines.events.on_player_rotated_entity, function(event) OnRotateEntity(event.entity, game.players[event.player_index]) end)

script.on_event(defines.events.on_pre_entity_settings_pasted, function(event)
  game.print(Inspect(event))
end)

function OnInitialize()
	global.BotList = global.BotList or {}
  global.Tiles = globalTiles or {}
end

script.on_init(OnInitialize)

function OnLoad()
end

script.on_load(OnLoad)

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

script.on_event(defines.events.on_tick, OnTick)

script.on_event("bot-readout", function(event)  
  if global.BotList then
    for key, bot in pairs(global.BotList) do
      Bot.Readout(bot)
    end
	end
end)

--function OnParade()
--  for index, bot in pairs(global.BotList) do
--    --bot.Entity.speed = bot.Entity.speed + 0.01
--  end
--end

--script.on_event(defines.events.on_console_command, OnCommand)
remote.add_interface("WarehouseBots", 
{
  --Parade = OnParade
})  