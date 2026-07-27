class_name EnemyStateStun extends EnemyState
@export var anim_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category("AI")
@export var next_state : EnemyState
var _direction : Vector2 = Vector2.DOWN
var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )

func enter() -> void:
	enemy.has_been_stunned = true
	_animation_finished = false
	enemy.set_direction( _direction )
	enemy.velocity = _direction * -knockback_speed
	enemy.update_animation( anim_name )

func exit() -> void:
	pass

func process( _delta : float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	if _animation_finished == true:
		return next_state
	return null

func physics( _delta : float ) -> EnemyState:
	return null

func _on_enemy_damaged() -> void:
	if enemy.player:
		_direction = ( enemy.global_position - enemy.player.global_position ).normalized()
	state_machine.change_state( self )

func _on_animation_finished( _anim_name : String ) -> void:
	_animation_finished = true
