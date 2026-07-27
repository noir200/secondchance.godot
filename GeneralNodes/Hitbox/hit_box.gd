class_name Hitbox extends Area2D
signal damaged( damage : int )

func take_damage( damage : int ) -> void:
	print( "TakeDamage: ", damage )
	damaged.emit( damage )
