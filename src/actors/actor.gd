extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var health = 100

export var speed: = Vector2(100.0, 300.0)
export var gravity: = 800.0

var _velocity: = Vector2.ZERO
var max_jumps = 2
var jump_count = 0

