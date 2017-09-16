require("stdlib.table")

data:extend
{
  table.merge(table.deepcopy(data.raw["constant-combinator"]["constant-combinator"]),
  {
    name = "warehouse-direction-tile",
    icon = modification .. "graphics/icons/warehouse-direction-tile.png",
    collision_mask = { "floor-layer" },
    minable = { hardness = 0.2, mining_time = 0.5, result = "warehouse-direction-tile" },
    max_health = 100,
    item_slot_count = 0,
    sprites =
    {
      north =
      {
        frame_count = 1,
        filename    = modification .. "graphics/entities/warehouse-direction-tile.png",
        x       = 0,
        y       = 0,
        width   = 32,
        height  = 32,
        shift   = {0 , 0}
      },
      east =
      {
        frame_count = 1,
        filename    = modification .. "graphics/entities/warehouse-direction-tile.png",
        x       = 96,
        y       = 0,
        width   = 32,
        height  = 32,
        shift   = {0 , 0}
      },
      south =
      {
        frame_count = 1,
        filename    = modification .. "graphics/entities/warehouse-direction-tile.png",
        x       = 32,
        y       = 0,
        width   = 32,
        height  = 32,
        shift   = {0 , 0}
      },
      west =
      {
        frame_count = 1,
        filename    = modification .. "graphics/entities/warehouse-direction-tile.png",
        x       = 64,
        y       = 0,
        width   = 32,
        height  = 32,
        shift   = {0 , 0}
      }
    },
  }),
	table.merge(table.deepcopy(data.raw["car"]["car"]),
  {
		name            = "warehouse-bot";
		icon            = "__base__/graphics/icons/wooden-chest.png";
    flags           = { "placeable-neutral", "player-creation" };
		inventory_size  = 0;
		max_health      = 100;
		minable         = { mining_time = 1, result = "warehouse-bot" };
		corpse          = "small-remnants";
		resistances     =	{ {	type = "impact",	percent = 100	}	};
		collision_box   = { {-0.25, -0.25}, {0.25, 0.25} };
		selection_box   = { {-0.50, -0.50}, {0.50, 0.50} };
		effectivity     = 1;
		consumption     = "1kW";
		braking_power   = "50kW";
		friction        = 2E-3;
		rotation_speed  = 1 / 60.0;
		weight          = 10;
		burner          = { effectivity = 1,	fuel_inventory_size = 0, };
    tank_driving    = true; -- allow turning while standing still
    guns            = {};
		light           =
    {	
      {
        color = {r = 0.7, g = 0.7, b = 1.0},
        intensity = 0,
        size = 1,
      }
    },
		animation =
    {
			layers =
      {
        {
          priority        = "low",
          width           = 48,
          height          = 48,
          frame_count     = 1,
          direction_count = 64,
          animation_speed = 8,
          shift           = {0, 0},
          max_advance     = 1,
          stripes =
          {
            {
             filename = modification .. "graphics/entities/arrow.png",
             width_in_frames  = 8,
             height_in_frames = 8,
            }
          }
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
    turret_animation = 
    {
      layers =
      {
        {
          filename        = "__base__/graphics/entity/car/car-turret.png",
          priority        = "low",
          animation_speed = 8;
          line_length     = 8,
          width           = 36,
          height          = 29,
          frame_count     = 1,
          direction_count = 0,
          shift           = { 0, 0 },
        }
      }
    };
    working_sound =
    { 
      sound             = { volume = 0; filename = "__base__/sound/car-engine.ogg" };
      activate_sound    = { volume = 0; filename = "__base__/sound/car-engine-start.ogg" };
      deactivate_sound  = { volume = 0; filename = "__base__/sound/car-engine-stop.ogg" };
    },
	})
}
