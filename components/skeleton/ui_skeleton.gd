## UISkeletonLoader — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UISkeletonLoader
extends PanelContainer

@export var min_width:  float = 200.0:
	set(v): min_width = v; custom_minimum_size.x = v

@export var min_height: float = 16.0:
	set(v): min_height = v; custom_minimum_size.y = v

@export var radius: int = UITheme.RADIUS_SM:
	set(v): radius = v; if is_inside_tree(): _apply()

@export var animated: bool = true:
	set(v): animated = v; set_process(v)

var _style: StyleBoxFlat
var _t: float = 0.0

func _ready() -> void:
	custom_minimum_size = Vector2(min_width, min_height)
	_style = StyleBoxFlat.new()
	_style.bg_color = UITheme.SURFACE_3
	_apply()
	set_process(animated)

func _process(delta: float) -> void:
	_t += delta * 1.4
	_style.bg_color = UITheme.SURFACE_3.lerp(UITheme.SURFACE_4, (sin(_t) + 1.0) * 0.5)
	add_theme_stylebox_override("panel", _style)

func _apply() -> void:
	if not _style: return
	_style.corner_radius_top_left     = radius; _style.corner_radius_top_right    = radius
	_style.corner_radius_bottom_left  = radius; _style.corner_radius_bottom_right = radius
	add_theme_stylebox_override("panel", _style)
