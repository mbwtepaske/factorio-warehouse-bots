data:extend
{
  {
    type                  = "equipment-grid";
    name                  = "warehouse-bot-grid";
    width                 = 2;
    height                = 4;
    equipment_categories  = { "warehouse-bot-equipment" }
  };
  {
    type          = "battery-equipment";
    name          = "warehouse-bot-battery";
    categories    = { "warehouse-bot-equipment" };
    energy_source =
    {
      type              = "electric";
      buffer_capacity   = 18 .. "MJ";
      input_flow_limit  = 50 .. "KW";
      output_flow_limit = 50 .. "KW";
      usage_priority    = "primary-output"
    };
    shape =
    {
      type    = "full";
      width   = 2;
      height  = 4;
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
