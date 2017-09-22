require("config")

require("prototypes.categories")
require("prototypes.entities")
require("prototypes.equipment")
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