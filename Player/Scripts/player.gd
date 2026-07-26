class_name Player extends CharacterBody2D
signal DirectionChanged( new_direction : Vector2 )
var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction : Vector2 = Vector2.ZERO
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var shadow_sprite : Node2D = get_node_or_null("Sprite2D/ShadowSprite")

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

func _physics_process( _delta : float ) -> void:
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
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
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
