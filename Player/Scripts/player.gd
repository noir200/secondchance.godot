class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var move_speed : float = 100.0
var state : String = "idle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready():
	pass
	

func _process( delta ):
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = direction * move_speed
	UpdateAnimation()
	pass

func _physics_process( delta ):
	move_and_slide()

func SetDirection() -> bool:
	return true

func UpdateAnimation() -> void:
	pass
