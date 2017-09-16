data:extend
{
  {
		type          = "item",
		name          = "warehouse-bot",
		icon          = modification .. "graphics/icons/warehouse-bot.png",
		flags         = {"goes-to-quickbar"},
		subgroup      = "transport",
		--order         = "b[warehouse-bot]",
		place_result  = "warehouse-bot",
		stack_size    = 50
	},
  {
		type          = "item",
		name          = "warehouse-direction-tile",
		icon          = modification .. "graphics/icons/warehouse-direction-tile.png",
		flags         = {"goes-to-quickbar"},
		subgroup      = "transport",
		--order         = "b[warehouse-bot]",
		place_result  = "warehouse-direction-tile",
		stack_size    = 200
	},
  --{
  --  type          = "item",
  --  name          = "warehouse-direction-tile-north",
  --  icon          = modification .. "graphics/icons/warehouse-direction-tile.png",
  --  flags         = {"goes-to-main-inventory"},
  --  subgroup      = "terrain",
  --  order         = "b",
  --  stack_size    = 100,
  --  place_as_tile =
  --  {
  --    result = "warehouse-direction-tile-north",
  --    condition_size = 4,
  --    condition = { "water-tile" }
  --  }
  --}
}