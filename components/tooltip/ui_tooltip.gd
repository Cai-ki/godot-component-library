class_name UITooltip
extends Node

## Tooltip that appears above (or below) the parent Control on hover.
## Usage: add as child of any Control and set tip_text.
##   var btn = Button.new()
##   var tip = UITooltip.new()
##   tip.tip_text = "Click to save"
##   btn.add_child(tip)

@export var tip_text: String = ""
## Force position: 0 = auto (above, fallback below), 1 = always below
@export_enum("Auto", "Below") var tip_position: int = 0

var _panel: PanelContainer
var _label: Label


func _ready() -> void:
	var parent := get_parent()
	if not parent is Control:
		push_warning("UITooltip must be a child of a Control node.")
		return
	var target := parent as Control
	target.mouse_entered.connect(_on_mouse_entered.bind(target))
	target.mouse_exited.connect(_on_mouse_exited)
	_build_panel()


func _exit_tree() -> void:
	if is_instance_valid(_panel):
		_panel.queue_free()


func _on_mouse_entered(target: Control) -> void:
	if not is_instance_valid(_panel):
		return
	_label.text = tip_text
	_panel.visible = false
	_panel.reset_size()
	_position_panel.bind(target).call_deferred()


func _on_mouse_exited() -> void:
	if is_instance_valid(_panel):
		_panel.visible = false


func _position_panel(target: Control) -> void:
	if not is_instance_valid(target) or not is_instance_valid(_panel):
		return

	var rect        := target.get_global_rect()
	var panel_size  := _panel.get_minimum_size()
	var vp_size     := target.get_viewport().get_visible_rect().size

	var x := rect.position.x + rect.size.x * 0.5 - panel_size.x * 0.5
	var y := rect.position.y - panel_size.y - 8.0  # above by default

	if tip_position == 1 or y < 8.0:
		y = rect.position.y + rect.size.y + 8.0  # below

	_panel.position = Vector2(clampf(x, 8.0, vp_size.x - panel_size.x - 8.0), y)
	_panel.visible = true


func _build_panel() -> void:
	# Find or create the shared CanvasLayer for all tooltips
	var root  := get_tree().root
	var layer : CanvasLayer
	for child in root.get_children():
		if child.name == &"_UITooltipLayer":
			layer = child as CanvasLayer
			break
	if not layer:
		layer = CanvasLayer.new()
		layer.name = "_UITooltipLayer"
		layer.layer = 101  # above UIToast (100)
		root.add_child(layer)

	_panel = PanelContainer.new()
	_panel.visible = false
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var s := StyleBoxFlat.new()
	s.bg_color = UITheme.SURFACE_4
	s.corner_radius_top_left     = UITheme.RADIUS_SM
	s.corner_radius_top_right    = UITheme.RADIUS_SM
	s.corner_radius_bottom_left  = UITheme.RADIUS_SM
	s.corner_radius_bottom_right = UITheme.RADIUS_SM
	s.border_width_top    = 1; s.border_width_bottom = 1
	s.border_width_left   = 1; s.border_width_right  = 1
	s.border_color  = UITheme.BORDER_STRONG
	s.shadow_size   = 8
	s.shadow_color  = Color(0, 0, 0, 0.3)
	s.shadow_offset = Vector2(0, 3)
	s.content_margin_left   = 12; s.content_margin_right  = 12
	s.content_margin_top    = 8;  s.content_margin_bottom = 8
	_panel.add_theme_stylebox_override("panel", s)
	layer.add_child(_panel)

	_label = Label.new()
	_label.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_label.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	# BUG-9 FIX: apply FONT_SANS override to match other components' typography
	if UITheme.FONT_SANS: _label.add_theme_font_override("font", UITheme.FONT_SANS)
	_panel.add_child(_label)
