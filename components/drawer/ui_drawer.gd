## UIDrawer — Standalone Component
## Slide-in panel from the right edge of the screen.
##
## Usage:
##   var drawer := UIDrawer.new()
##   drawer.title_text = "Settings"
##   parent.add_child(drawer)
##   drawer.show_drawer()
##   drawer.get_body().add_child(my_content)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIDrawer
extends Node

signal opened
signal closed

@export var drawer_width:  float  = 400.0
@export var show_overlay:  bool   = true
@export var title_text:    String = "":
	set(v):
		title_text = v
		if _title_lbl: _title_lbl.text = v

var _overlay: ColorRect
var _panel:   PanelContainer
var _body:    VBoxContainer
var _title_lbl: Label
var _visible: bool = false


# ── Public API ────────────────────────────────────────────────────────────────

func show_drawer() -> void:
	if _visible: return
	_visible = true
	_build()
	opened.emit()


func hide_drawer() -> void:
	if not _visible: return
	_visible = false
	_animate_out()


func get_body() -> VBoxContainer:
	return _body


# ── Build ─────────────────────────────────────────────────────────────────────

func _build() -> void:
	var layer := _get_or_create_layer()

	# Overlay (semi-transparent backdrop with Glassmorphism)
	if show_overlay:
		_overlay = UI.glass_backdrop(layer, 2.0, Color(0, 0, 0, 0.0))
		_overlay.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
				hide_drawer()
		)

	# Drawer panel
	_panel = PanelContainer.new()
	_panel.custom_minimum_size = Vector2(drawer_width, 0)
	_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var ps := StyleBoxFlat.new()
	ps.bg_color = UITheme.SURFACE_1
	ps.border_width_left = 1
	ps.border_color = UITheme.BORDER
	ps.shadow_size   = 24
	ps.shadow_color  = Color(0, 0, 0, 0.45)
	ps.shadow_offset = Vector2(-4, 0)
	ps.corner_radius_top_left    = UITheme.RADIUS_LG
	ps.corner_radius_bottom_left = UITheme.RADIUS_LG
	_panel.add_theme_stylebox_override("panel", ps)

	# Anchor to right edge
	_panel.anchor_right  = 1.0
	_panel.anchor_bottom = 1.0
	_panel.anchor_left   = 1.0
	_panel.anchor_top    = 0.0
	_panel.offset_left   = -drawer_width
	_panel.offset_right  = 0.0
	_panel.offset_top    = 0.0
	_panel.offset_bottom = 0.0

	layer.add_child(_panel)

	# Inner layout
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 0)
	_panel.add_child(outer)

	# Header
	var header_m := MarginContainer.new()
	header_m.add_theme_constant_override("margin_left",   20)
	header_m.add_theme_constant_override("margin_right",  16)
	header_m.add_theme_constant_override("margin_top",    18)
	header_m.add_theme_constant_override("margin_bottom", 18)
	outer.add_child(header_m)

	var header_h := HBoxContainer.new()
	header_h.add_theme_constant_override("separation", 8)
	header_h.alignment = BoxContainer.ALIGNMENT_CENTER
	header_m.add_child(header_h)

	_title_lbl = Label.new()
	_title_lbl.text = title_text
	_title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_LG)
	_title_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_h.add_child(_title_lbl)

	# Close button
	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.flat = true
	close_btn.focus_mode = Control.FOCUS_NONE
	close_btn.custom_minimum_size = Vector2(32, 32)
	var ns := StyleBoxFlat.new()
	ns.bg_color = Color(0, 0, 0, 0)
	var hs := StyleBoxFlat.new()
	hs.bg_color = UITheme.SURFACE_3
	for r_name in ["corner_radius_top_left","corner_radius_top_right","corner_radius_bottom_left","corner_radius_bottom_right"]:
		hs.set(r_name, UITheme.RADIUS_SM)
	close_btn.add_theme_stylebox_override("normal",  ns)
	close_btn.add_theme_stylebox_override("hover",   hs)
	close_btn.add_theme_stylebox_override("pressed", hs)
	close_btn.add_theme_stylebox_override("focus",   ns)
	close_btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	close_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	close_btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	close_btn.pressed.connect(hide_drawer)
	header_h.add_child(close_btn)

	# Separator
	var sep := ColorRect.new()
	sep.color = UITheme.BORDER
	sep.custom_minimum_size.y = 1
	sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	outer.add_child(sep)

	# Scroll + body
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	outer.add_child(scroll)

	var body_margin := MarginContainer.new()
	body_margin.add_theme_constant_override("margin_left",   20)
	body_margin.add_theme_constant_override("margin_right",  20)
	body_margin.add_theme_constant_override("margin_top",    20)
	body_margin.add_theme_constant_override("margin_bottom", 20)
	body_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(body_margin)

	_body = VBoxContainer.new()
	_body.add_theme_constant_override("separation", 16)
	_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body_margin.add_child(_body)

	_animate_in()


func _animate_in() -> void:
	# Slide panel in from right
	_panel.offset_left  =  0.0
	_panel.offset_right =  drawer_width
	var tw := _panel.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(_panel, "offset_left",  -drawer_width, 0.3)
	tw.parallel().tween_property(_panel, "offset_right", 0.0, 0.3)
	# Overlay fade
	if is_instance_valid(_overlay):
		_overlay.create_tween().tween_property(_overlay, "color",
			Color(0, 0, 0, 0.45), 0.3).set_trans(Tween.TRANS_SINE)
		
		# Also fade in the blur itself 
		if _overlay.get_child_count() > 1:
			var blur_rect = _overlay.get_child(1) # Index 1 is the blur ColorRect
			if blur_rect and blur_rect is ColorRect and blur_rect.material:
				blur_rect.material.set_shader_parameter("lod", 0.0)
				_overlay.create_tween().tween_method(
					func(v): blur_rect.material.set_shader_parameter("lod", v),
					0.0, 2.0, 0.3
				).set_trans(Tween.TRANS_SINE)


func _animate_out() -> void:
	var tw := _panel.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tw.tween_property(_panel, "offset_left",  0.0,          0.25)
	tw.parallel().tween_property(_panel, "offset_right", drawer_width, 0.25)
	if is_instance_valid(_overlay):
		_overlay.create_tween().tween_property(_overlay, "color",
			Color(0, 0, 0, 0.0), 0.25)
			
		# Also fade out the blur
		if _overlay.get_child_count() > 1:
			var blur_rect = _overlay.get_child(1)
			if blur_rect and blur_rect is ColorRect and blur_rect.material:
				_overlay.create_tween().tween_method(
					func(v): blur_rect.material.set_shader_parameter("lod", v),
					2.0, 0.0, 0.25
				)
	tw.finished.connect(_cleanup)


func _cleanup() -> void:
	if is_instance_valid(_overlay): _overlay.queue_free()
	if is_instance_valid(_panel):   _panel.queue_free()
	_overlay = null
	_panel   = null
	_body    = null
	closed.emit()


# ── Layer ─────────────────────────────────────────────────────────────────────

func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == &"_UIDrawerLayer":
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name  = &"_UIDrawerLayer"
	layer.layer = 104
	root.add_child(layer)
	return layer
