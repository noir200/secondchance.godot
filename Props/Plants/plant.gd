class_name Plant extends Node2D

func _ready():
	$HitBox.damaged.connect( TakeDamage )
	pass



func TakeDamage( _damage : int ) -> void:
	queue_free()
	pass
