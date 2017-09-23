require("warehouse-bot")
require("warehouse-tile")

local Inspect = require("inspect")

function OnConfigurationChanged() 
  Bot.OnInitialize()
end

script.on_configuration_changed(OnConfigurationChanged)

script.on_event(defines.events.on_built_entity,
  function(event)
    Bot.OnBuildEntity(event.created_entity, game.players[event.player_index])
    Tile.OnBuildEntity(event.created_entity, game.players[event.player_index])
  end)

script.on_event(defines.events.on_robot_built_entity,
  function(event)
    Bot.OnBuildEntity(event.created_entity, event.robot)
    Tile.OnBuildEntity(event.created_entity, event.robot)
  end)

script.on_event(defines.events.on_player_built_tile,
  function(event)
    Tile.OnBuildTile(event.positions, game.players[event.player_index])
  end)

script.on_event(defines.events.on_robot_built_tile,
  function(event)
    Tile.OnBuildTile(event.positions, event.robot)
  end)

script.on_event(defines.events.on_entity_died,
  function(event)
    Bot.OnDestroyEntity(event.entity, event.cause or event.last_user)
    Tile.OnDestroyEntity(event.entity, event.cause or event.last_user)
  end)

script.on_event(defines.events.on_preplayer_mined_item,
  function(event)
    Bot.OnDestroyEntity(event.entity, game.players[event.player_index])
    Tile.OnDestroyEntity(event.entity, game.players[event.player_index])
  end)
  
script.on_event(defines.events.on_robot_pre_mined,
  function(event)
    Bot.OnDestroyEntity(event.entity, event.robot)
    Tile.OnDestroyEntity(event.entity, event.robot)
  end)

script.on_event(defines.events.on_player_rotated_entity,
  function(event)
    Tile.OnRotateEntity(event.entity, game.players[event.player_index])
  end)

script.on_init(Bot.OnInitialize)
script.on_init(Tile.OnInitialize)
script.on_load(Bot.OnLoad)
script.on_load(Tile.OnLoad)
script.on_event(defines.events.on_tick, Bot.OnTick)

script.on_event("bot-readout",
  function(event)
    local player = game.players[event.player_index]

    if player.selected then
      Bot.OnReadout(player.selected)
    end
  end)
