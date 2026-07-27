class_name Enemy extends CharacterBody2D
signal direction_changed( new_direction : Vector2 )
signal enemy_damaged()
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
@export var hp : int = 3
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var shadow_sprite : Node2D = get_node_or_null("ShadowSprite2D")
@onready var hit_box: Hitbox = $HitBox

func _ready():
	state_machine.initialize( self )
	player = PlayerManager.player
	hit_box.damaged.connect( _take_damage )
	if shadow_sprite == null:
		push_warning("Enemy: ShadowSprite node not found — check the node name/path in the Slime scene.")

func _process(_delta: float) -> void:
	update_z_index()

func update_z_index() -> void:
	var y_ref : float = shadow_sprite.global_position.y if shadow_sprite else global_position.y
	z_index = int(clamp(y_ref, -4000.0, 4000.0))

func _physics_process(_delta):
	move_and_slide()

func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_direction = DIR_4[ direction_id ]
	if new_direction == cardinal_direction:
		return false
	cardinal_direction = new_direction
	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale = Vector2(-1, sprite_2d.scale.y)
	else:
		sprite_2d.scale = Vector2(1, sprite_2d.scale.y)
	direction_changed.emit( cardinal_direction )
	return true

func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage( damage : int ) -> void:
	if invulnerable:
		return
	hp -= damage
	enemy_damaged.emit()
	if hp <= 0:
		queue_free()
