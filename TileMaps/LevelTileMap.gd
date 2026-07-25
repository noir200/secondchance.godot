class_name LevelTileMap extends TileMap


func _ready() -> void:
	LevelManager.ChangeTileMapBounds( GetTilemapBounds() )
	pass 

func GetTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	bounds.append(
		Vector2( get_used_rect().position * tile_set.tile_size )
	)
	bounds.append(
		Vector2( get_used_rect().end * tile_set.tile_size )
		)
	return bounds
