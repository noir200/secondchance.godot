class_name State_Attack extends State
 
@export var attack_sound : AudioStream
@export_range(1,20,0.5) var decelerate_speed : float = 5.0
 
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim : AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var hurt_box : HurtBox = $"../../Interactions/HurtBox"
@onready var attack : State_Attack = $"."
@onready var idle : State_Idle = $"../idle"
@onready var walk : State = $"../walk"
 
var attacking : bool = false
 
func _ready() -> void:
	animation_player.animation_finished.connect( EndAttack )
 
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play( "attack_" + player.AnimDirection() )
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 0.9, 1.1 )
	audio.play()
	attacking = true
	await get_tree().create_timer(0.075).timeout
	hurt_box.monitoring = true
 
func Exit() -> void:
	attacking = false
	hurt_box.monitoring = false
 
func Process( _delta : float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
 
func Physics( _delta : float ) -> State:
	return null
 
func HandleInput( _event : InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
 
func EndAttack( _newAnimName : String ) -> void:
	attacking = false
 
 
 
