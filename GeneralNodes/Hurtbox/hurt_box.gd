class_name HurtBox extends Area2D
@export var damage : int = 1
var _already_hit : Array[Area2D] = []

func _ready() -> void:
	area_entered.connect( AreaEntered )

func AreaEntered( a : Area2D ) -> void:
	if a is Hitbox:
		if a in _already_hit:
			return
		_already_hit.append( a )
		a.take_damage( damage )

func reset_hits() -> void:
	_already_hit.clear()
