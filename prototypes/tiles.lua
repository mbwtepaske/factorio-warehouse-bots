for _, direction in ipairs({ "north", "south", "west", "east" }) do
  local name = "warehouse-direction-tile-" .. direction

  data:extend
  {
    {
      type = "tile",
      name = name,
      needs_correction = false,
      minable = { hardness = 0.2, mining_time = 0.5, result = "warehouse-direction-tile" },
      mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg", volume = 0.0 },
      collision_mask = { "ground-tile" },
      walking_speed_modifier = 1.0,
      layer = 70,
      decorative_removal_probability = 1.5,
      variants =
      {
        main =
        {
          {
            width = 64,
            height = 32,
            picture = modification .. "graphics/tiles/" .. name .. ".png",
            count = 1,
            size = 1
          },
        },
        inner_corner = { picture = "", count = 0 },
        outer_corner = { picture = "", count = 0 },
        side = { picture = "", count = 0 }
      },
      walking_sound =
      {
        { filename = "__base__/sound/walking/concrete-01.ogg", volume = 0 },
      },
      map_color = {r=100, g=100, b=100},
      ageing = 0
    }
  }
end