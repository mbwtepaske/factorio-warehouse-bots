Tile = {}
Tile.DirectionTile       = "warehouse-direction-tile";
Tile.DirectionTileGhost  = Tile.DirectionTile .. "-ghost";

function Tile.OnBuildEntity(entity, instigator)
  if entity.name == DirectionTile or entity.name == DirectionTileGhost then    
    local old_entity = entity
    
    entity = entity.surface.create_entity
    { 
      name          = DirectionTileGhost;
      direction     = entity.direction;
      fast_replace  = true;
      force         = "player";
      position      = entity.position;
      operable      = false;
      spill         = false;
    }
    entity.operable = false
    
    old_entity.destroy()
    
    PlaceWarehouseTile(entity, instigator)
  end
end

function Tile.OnBuildTile(positions, instigator)  
  local area = 
  { 
    left_top = 
    { 
      x = positions[1].x;
      y = positions[1].y;
    };
    right_bottom =
    {
      x = positions[1].x;
      y = positions[1].y;
    };
  }
  
  for index, position in ipairs(positions) do
    area.left_top.x = math.min(area.left_top.x, position.x - 0)
    area.left_top.y = math.min(area.left_top.y, position.y - 0)
    area.right_bottom.x = math.max(area.right_bottom.x, position.x + 1)
    area.right_bottom.y = math.max(area.right_bottom.y, position.y + 1)
  end
  
  for index, entity in ipairs(instigator.surface.find_entities(area)) do
    if entity.name == DirectionTile then
      PlaceWarehouseTile(entity, instigator)
    end
  end 
end

function Tile.OnDestroyEntity(entity, instigator)
  if entity.name == DirectionTileGhost then
    instigator.mine_tile(entity.surface.get_tile(entity.position.x, entity.position.y))
  end
end

function Tile.OnRotateEntity(entity, instigator)
  if entity.name == DirectionTileGhost then
    entity.surface.set_tiles(
    {
      { 
        name = DirectionTile .. "-" .. string.lower(game.direction_to_string(entity.direction));
        position = entity.position;
      } 
    }, false)
  end
end

function Tile.PlaceWarehouseTile(entity, instigator)
  local tile = instigator.surface.get_tile(entity.position)
  
  if tile then
    instigator.mine_tile(tile)
  end
  
  instigator.surface.set_tiles(
  { 
    { 
        name = DirectionTile .. "-" .. string.lower(game.direction_to_string(entity.direction));
      position = entity.position
    }
  }, false)
end