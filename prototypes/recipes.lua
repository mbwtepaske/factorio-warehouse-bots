local function create_recipe(name, recipe)
  return table.merge(
  {
		type          = "recipe";
		name          = name;
		enabled       = true;
		result        = name;
		result_count  = 1;
		ingredients   =	{}
	}, recipe)
end

data:extend
{
  create_recipe("warehouse-bot");
  create_recipe("warehouse-bot-battery");
  create_recipe("warehouse-direction-tile");
}