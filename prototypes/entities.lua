require("stdlib.table")

local function get_direction_tile_sprite(offsetX, offsetY)
  return 
  {
    frame_count = 1;
    filename    = modification .. "graphics/entities/warehouse-direction-tile.png";
    x           = offsetX or 0;
    y           = offsetY or 0;
    width       = 32;
    height      = 32;
    shift       = {0 , 0}
  }
end

local empty_sprite =
{
  priority        = "extra-high";
  filename        = "__core__/graphics/empty.png";
  direction_count = 1;
  frame_count     = 1;
  width           = 1;
  height          = 1;
}

data:extend
{
  table.merge(table.deepcopy(data.raw["constant-combinator"]["constant-combinator"]),
  {
    name            = "warehouse-direction-tile";
    icon            = modification .. "graphics/icons/warehouse-direction-tile.png";
    collision_mask  = { "floor-layer" };    
    minable         = nil; --{ hardness = 0.2, mining_time = 0.5, result = "warehouse-direction-tile" },
    max_health      = 100;
    item_slot_count = 0;
    sprites         =
    {
      north = get_direction_tile_sprite( 0);
      east  = get_direction_tile_sprite(96);
      south = get_direction_tile_sprite(32);
      west  = get_direction_tile_sprite(64);
    };
    --fast_replaceable_group = "warehouse-tile"
  });
  table.merge(table.deepcopy(data.raw["constant-combinator"]["constant-combinator"]),
  {
    name            = "warehouse-direction-tile-ghost";
    icon            = modification .. "graphics/icons/warehouse-direction-tile.png";
    collision_mask  = { "floor-layer" };
    minable         = { hardness = 0.2, mining_time = 0.5, result = "warehouse-direction-tile" };
    max_health      = 100;
    item_slot_count = 0;
    sprites         =
    {
      north = empty_sprite;
      east  = empty_sprite;
      south = empty_sprite;
      west  = empty_sprite;
    };
    --fast_replaceable_group = "warehouse-tile"
  });
	table.merge(table.deepcopy(data.raw["car"]["car"]),
  {
		name            = "warehouse-bot";
		icon            = "__base__/graphics/icons/wooden-chest.png";
    flags           = { "placeable-neutral", "player-creation" };
		inventory_size  = 2;
		max_health      = 100;
		minable         = { mining_time = 1, result = "warehouse-bot" };
		corpse          = "small-remnants";
		resistances     =	{ {	type = "impact",	percent = 100	}	};
		collision_box   = { {-0.25, -0.25}, {0.25, 0.25} };
		selection_box   = { {-0.50, -0.50}, {0.50, 0.50} };
		effectivity     = 1;
		consumption     =  9 .. "KW";
		braking_power   = 18 .. "KW";
		friction        = 2E-3;
    render_layer    = "higher-object-above";
		rotation_speed  = 1 / 60.0;
		weight          = 50;
    tank_driving    = true; -- allow turning while standing still
    guns            = {};
		burner          = 
    { 
      --type                      = "electric";
      --buffer_capacity           = 18 .. "MJ";
      --input_flow_limit          = 10 .. "KW";
      --output_flow_limit         = 10 .. "KW";
      --effectivity               = 1;
      emissions                 = 0;
      fuel_inventory_size       = 0;
      render_no_power_icon      = true;
      render_no_network_icon    = false;
      resting_consumption_ratio = 0;
      --usage_priority            = "primary-input";
    };
		light           =
    {	
      {
        color = {r = 0.7, g = 0.7, b = 1.0};
        intensity = 0;
        size = 1;
      }
    };
		animation =
    {
			layers =
      {
        {
          filename        = modification .. "graphics/entities/arrow.png";
          priority        = "high";
          animation_speed = 8;
          direction_count = 64;
          frame_count     = 1;
          line_length     = 8;
          width           = 48;
          height          = 48;
          shift           = {0, 0};
        }
			}
		};
		stop_trigger =
    {
			{
				type = "play-sound",
				sound =
				{
					{
						filename = "__base__/sound/car-breaks.ogg",
						volume = 0.0
					}
				}
			}
		};
    turret_animation = { layers = { empty_sprite } };
    working_sound =
    { 
      sound             = { volume = 0; filename = "__base__/sound/car-engine.ogg" };
      activate_sound    = { volume = 0; filename = "__base__/sound/car-engine-start.ogg" };
      deactivate_sound  = { volume = 0; filename = "__base__/sound/car-engine-stop.ogg" };
    };
    equipment_grid        = "warehouse-bot-grid";
    equipment_categories  = { "warehouse-bot-equipment" };
	});
}
