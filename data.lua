require("config")

require("prototypes.entities")
require("prototypes.items")
require("prototypes.recipes")
require("prototypes.tiles")

data:extend
{
  {
    type = "custom-input",
    name = "bot-readout",
    key_sequence = "CONTROL + R",
    consuming = "none"
  }
}