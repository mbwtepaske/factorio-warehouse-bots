data:extend
{
  {
    type                  = "equipment-grid";
    name                  = "warehouse-bot-grid";
    width                 = 8;
    height                = 2;
    equipment_categories  = { "warehouse-bot-equipment" }
  };
  {
    type          = "battery-equipment";
    name          = "warehouse-bot-battery";
    categories    = { "warehouse-bot-equipment" };
    energy_source =
    {
      type              = "electric";
      buffer_capacity   = 60 * 2 .. "MW";
      input_flow_limit  = 60 * 1 .. "MW";
      output_flow_limit = 60 * 0 .. "W";
      usage_priority    = "primary-input"
    };
    shape =
    {
      type    = "full";
      width   = 1;
      height  = 2;
    };
    sprite =
    {
      filename  = "__base__/graphics/equipment/battery-equipment.png",
      width     = 32,
      height    = 64,
      priority  = "medium"
    };
  };
}
