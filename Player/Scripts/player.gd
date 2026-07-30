class_name Player extends CharacterBody2D

signal DirectionChanged( new_direction : Vector2 )

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction : Vector2 = Vector2.ZERO

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var shadow_sprite : Node2D = get_node_or_null("Sprite2D/ShadowSprite")

var can_dash : bool = true
var is_dashing : bool = false
var dash_speed : float = 400.0
var dash_distance : float = 80.0
var dash_cooldown : float = 0.5
var dash_cooldown_timer : float = 0.0
var dash_start_pos : Vector2 = Vector2.ZERO
var dash_dir_stored : Vector2 = Vector2.ZERO
@export var dash_distance_idle : float = 80.0
@export var dash_distance_walk : float = 80.0

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize( self )
	if shadow_sprite == null:
		push_warning("Player: ShadowSprite node not found — check the node name/path in the Player scene.")

func _process( _delta : float ) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = direction.normalized()
	update_z_index()

func _physics_process( delta : float ) -> void:
	if is_dashing:
		var dist_travelled = global_position.distance_to(dash_start_pos)
		if dist_travelled >= dash_distance:
			is_dashing = false
			dash_cooldown_timer = dash_cooldown
			velocity = Vector2.ZERO

	if not can_dash:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true

	handle_dash()
	move_and_slide()

func update_z_index() -> void:
	var y_ref : float = shadow_sprite.global_position.y if shadow_sprite else global_position.y
	z_index = int(clamp(y_ref, -4000.0, 4000.0))

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int( round( ( direction ).angle() / TAU * DIR_4.size() ) )
	var new_direction = DIR_4[ direction_id ]
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale = Vector2(-1, sprite_2d.scale.y)
	else:
		sprite_2d.scale = Vector2(1, sprite_2d.scale.y)
	DirectionChanged.emit( cardinal_direction )
	return true

func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func handle_dash() -> void:
	if Input.is_action_just_pressed("ui_shift") and can_dash and not is_dashing:
		is_dashing = true
		can_dash = false
		dash_start_pos = global_position
		var dash_dir : Vector2 = direction
		if dash_dir == Vector2.ZERO:
			dash_dir = cardinal_direction
			dash_distance = dash_distance_idle
		else:
			dash_distance = dash_distance_walk
		dash_dir_stored = dash_dir
		velocity = dash_dir * dash_speed
