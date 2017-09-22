local function create_item(name, subgroup, stack_size, type_override)
  return
  {
		type          = type_override or "item";
		name          = name;
		icon          = modification .. "graphics/icons/" .. name .. ".png";
		flags         = { "goes-to-quickbar" };
		subgroup      = subgroup;		
		place_result  = name;
		stack_size    = stack_size or 50;
	};
end

local function create_item_as_equipment(name)
  return
  {
		type        = "item";
		name        = name;
		icon        = modification .. "graphics/icons/" .. name .. ".png";
		flags       = { "goes-to-quickbar" };
		subgroup    = "equipment";
		stack_size  = 50;
    placed_as_equipment_result = name
	};
end

local function create_item_as_tile(name, icon)
  return
  {
		type          = "item";
		name          = name;
		icon          = modification .. "graphics/icons/" .. icon .. ".png";
		flags         = { "goes-to-quickbar" };
		subgroup      = "terrain";
		stack_size    = 1024;
    place_as_tile =
    {
      result          = name;
      condition       = { "water-tile" };
      condition_size  = 1;
    };
	};
end

data:extend
{
  create_item("warehouse-bot", "transport", 50, "item-with-entity-data");  
  create_item("warehouse-direction-tile", "transport", 200);
  create_item("warehouse-direction-tile-ghost", "transport", 200);
  
  create_item_as_equipment("warehouse-bot-battery");
  
  create_item_as_tile("warehouse-direction-tile-north", "warehouse-direction-tile");
  create_item_as_tile("warehouse-direction-tile-south", "warehouse-direction-tile");
  create_item_as_tile("warehouse-direction-tile-east", "warehouse-direction-tile");
  create_item_as_tile("warehouse-direction-tile-west", "warehouse-direction-tile");
}