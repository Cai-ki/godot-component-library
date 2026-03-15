## UIPopover — Standalone Component
## Click-triggered popover that can hold any Control content.
## Unlike UITooltip (text-only, hover), UIPopover supports interactive content.
##
## Usage:
##   var pop := UIPopover.new()
##   pop.attach(my_button)
##   pop.content_builder = func(body: VBoxContainer):
##       body.add_child(Label.new())  # add anything
##   parent.add_child(pop)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIPopover
extends Node

signal opened
signal closed

enum Position { AUTO, BELOW, ABOVE, LEFT, RIGHT }

const LAYER_NAME := "_UIPopoverLayer"
const LAYER_INDEX := 108

@export var position_mode: Position = Position.AUTO
@export var popover_width: float = 260.0

## Called when popover opens. Receives the body VBoxContainer to fill with content.
var content_builder: Callable

var _overlay: Control
var _panel: PanelContainer
var _target: Control
var _body: VBoxContainer
var _is_open: bool = false


# ── Public API ────────────────────────────────────────────────

func attach(target: Control) -> void:
	_target = target
	if target.has_signal("pressed"):
		target.pressed.connect(func(): toggle())
	else:
		target.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				toggle()
		)


func toggle() -> void:
	if is_instance_valid(_panel):
		hide_popover()
	else:
		show_popover()


func show_popover() -> void:
	_close()
	if not is_instance_valid(_target): return
	_is_open = true
	var layer := _get_or_create_layer()

	# Full-screen transparent dismiss
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.pressed:
			hide_popover()
	)
	layer.add_child(_overlay)

	# Panel
	_panel = PanelContainer.new()
	_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_panel.custom_minimum_size.x = popover_width
	var ps := StyleBoxFlat.new()
	ps.bg_color = UITheme.SURFACE_2
	ps.set_corner_radius_all(UITheme.RADIUS_LG)
	ps.border_width_top = 1; ps.border_width_bottom = 1
	ps.border_width_left = 1; ps.border_width_right = 1
	ps.border_color = UITheme.BORDER_STRONG
	ps.shadow_size = 16
	ps.shadow_color = Color(0, 0, 0, 0.35)
	ps.shadow_offset = Vector2(0, 4)
	ps.content_margin_left = 16; ps.content_margin_right = 16
	ps.content_margin_top = 14; ps.content_margin_bottom = 14
	_panel.add_theme_stylebox_override("panel", ps)

	# Body container
	_body = VBoxContainer.new()
	_body.add_theme_constant_override("separation", 10)
	_panel.add_child(_body)

	# Let caller fill content
	if content_builder.is_valid():
		content_builder.call(_body)

	_overlay.add_child(_panel)

	# Position relative to target
	_position_panel.call_deferred()

	# Fade in
	_panel.modulate.a = 0.0
	_panel.create_tween().tween_property(_panel, "modulate:a", 1.0, 0.15).set_trans(Tween.TRANS_SINE)

	opened.emit()


func hide_popover() -> void:
	if not _is_open:
		return
	_is_open = false

	if is_instance_valid(_panel):
		var panel_ref := _panel
		var overlay_ref := _overlay
		var t := panel_ref.create_tween()
		t.tween_property(panel_ref, "modulate:a", 0.0, 0.1)
		t.finished.connect(func():
			if is_instance_valid(overlay_ref): overlay_ref.queue_free()
		)
	_overlay = null
	_panel = null
	_body = null
	closed.emit()


func get_body() -> VBoxContainer:
	return _body


# ── Positioning ───────────────────────────────────────────────

func _position_panel() -> void:
	if not is_instance_valid(_panel) or not is_instance_valid(_target): return

	var target_rect := _target.get_global_rect()
	var panel_size := _panel.get_combined_minimum_size()
	var vp := get_tree().root.get_visible_rect().size
	var gap := 6.0

	var pos := Vector2.ZERO
	var mode := position_mode

	if mode == Position.AUTO:
		# Prefer below, fall back to above
		var below_y := target_rect.position.y + target_rect.size.y + gap
		if below_y + panel_size.y <= vp.y - 8:
			mode = Position.BELOW
		else:
			mode = Position.ABOVE

	match mode:
		Position.BELOW:
			pos.x = target_rect.position.x
			pos.y = target_rect.position.y + target_rect.size.y + gap
		Position.ABOVE:
			pos.x = target_rect.position.x
			pos.y = target_rect.position.y - panel_size.y - gap
		Position.LEFT:
			pos.x = target_rect.position.x - panel_size.x - gap
			pos.y = target_rect.position.y
		Position.RIGHT:
			pos.x = target_rect.position.x + target_rect.size.x + gap
			pos.y = target_rect.position.y

	# Clamp to viewport
	pos.x = clampf(pos.x, 8.0, vp.x - panel_size.x - 8.0)
	pos.y = clampf(pos.y, 8.0, vp.y - panel_size.y - 8.0)

	_panel.position = pos


# ── Cleanup ───────────────────────────────────────────────────

func _close() -> void:
	_is_open = false
	if is_instance_valid(_overlay):
		_overlay.queue_free()
	_overlay = null
	_panel = null
	_body = null


func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == LAYER_NAME:
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name = LAYER_NAME
	layer.layer = LAYER_INDEX
	root.add_child(layer)
	return layer


func _exit_tree() -> void:
	_close()
