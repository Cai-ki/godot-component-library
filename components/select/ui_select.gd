## UISelect — Standalone Component
## A fully custom-styled dropdown select.
##
## Usage:
##   var sel := UISelect.new()
##   sel.label_text = "Framework"
##   sel.placeholder = "Choose one..."
##   sel.options = ["Godot 4.3", "Godot 4.2", "Godot 3.5"]
##   sel.selection_changed.connect(func(i, v): print(v))
##   parent.add_child(sel)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UISelect
extends VBoxContainer

signal selection_changed(index: int, value: String)

@export var label_text: String = "":
	set(v): label_text = v; if _lbl: _lbl.text = v; _lbl.visible = v != ""

@export var placeholder: String = "Select...":
	set(v): placeholder = v; if is_inside_tree(): _refresh_display()

@export var options: PackedStringArray = []:
	set(v): options = v; if is_inside_tree(): _refresh_display()

@export var selected_index: int = -1:
	set(v): selected_index = v; if is_inside_tree(): _refresh_display()

@export var disabled: bool = false:
	set(v): disabled = v; if is_inside_tree(): _refresh_display()

var _lbl:       Label
var _trigger:   PanelContainer
var _value_lbl: Label
var _caret_lbl: Label
var _overlay:   Control
var _dropdown:  PanelContainer
var _is_open:   bool = false

var selected_value: String:
	get: return options[selected_index] \
		if selected_index >= 0 and selected_index < options.size() else ""


# ── Lifecycle ─────────────────────────────────────────────────────────────────

func _ready() -> void:
	add_theme_constant_override("separation", 6)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()


# ── Public API ─────────────────────────────────────────────────────────────────

func clear_selection() -> void:
	selected_index = -1


# ── Build ─────────────────────────────────────────────────────────────────────

func _build() -> void:
	_lbl = Label.new()
	_lbl.text = label_text
	_lbl.visible = label_text != ""
	_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	add_child(_lbl)

	# Trigger panel — styled like an input field
	_trigger = PanelContainer.new()
	_trigger.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_trigger.mouse_filter = Control.MOUSE_FILTER_STOP

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	_trigger.add_child(row)

	_value_lbl = Label.new()
	_value_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_value_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_value_lbl.clip_text = true
	row.add_child(_value_lbl)

	_caret_lbl = Label.new()
	_caret_lbl.text = "▾"
	_caret_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_caret_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	row.add_child(_caret_lbl)

	_trigger.gui_input.connect(_on_trigger_input)
	_trigger.mouse_entered.connect(func(): _on_hover(true))
	_trigger.mouse_exited.connect(func(): _on_hover(false))
	add_child(_trigger)

	_refresh_display()


func _on_trigger_input(event: InputEvent) -> void:
	if disabled: return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			if _is_open: _close_dropdown()
			else:        _open_dropdown()


func _on_hover(hovered: bool) -> void:
	if disabled or _is_open: return
	var s := _trigger_style(UITheme.SURFACE_3, UITheme.BORDER_LIGHT, 1) if hovered \
		else _trigger_style(UITheme.SURFACE_2, UITheme.BORDER, 1)
	_trigger.add_theme_stylebox_override("panel", s)


func _refresh_display() -> void:
	if not _trigger: return
	var bg := UITheme.SURFACE_3 if disabled else UITheme.SURFACE_2
	var bc := UITheme.PRIMARY   if _is_open  else UITheme.BORDER
	var bw := 2                 if _is_open  else 1
	_trigger.add_theme_stylebox_override("panel", _trigger_style(bg, bc, bw))

	var has_value := selected_index >= 0 and selected_index < options.size()
	_value_lbl.text = selected_value if has_value else placeholder
	_value_lbl.add_theme_color_override("font_color",
		UITheme.TEXT_MUTED if (not has_value or disabled) else UITheme.TEXT_PRIMARY)

	if _caret_lbl:
		_caret_lbl.text = "▴" if _is_open else "▾"


# ── Dropdown ──────────────────────────────────────────────────────────────────

func _open_dropdown() -> void:
	_is_open = true
	_refresh_display()
	var layer := _get_or_create_layer()

	# Full-screen overlay — dismisses on outside click
	_overlay = Control.new()
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
			_close_dropdown()
	)
	layer.add_child(_overlay)

	# Dropdown panel
	_dropdown = PanelContainer.new()
	_dropdown.mouse_filter = Control.MOUSE_FILTER_STOP

	var ps := StyleBoxFlat.new()
	ps.bg_color                  = UITheme.SURFACE_2
	ps.corner_radius_top_left    = UITheme.RADIUS_MD
	ps.corner_radius_top_right   = UITheme.RADIUS_MD
	ps.corner_radius_bottom_left = UITheme.RADIUS_MD
	ps.corner_radius_bottom_right = UITheme.RADIUS_MD
	ps.border_width_top    = 1; ps.border_width_bottom = 1
	ps.border_width_left   = 1; ps.border_width_right  = 1
	ps.border_color  = UITheme.BORDER_STRONG
	ps.shadow_size   = 18
	ps.shadow_color  = Color(0, 0, 0, 0.35)
	ps.shadow_offset = Vector2(0, 6)
	ps.content_margin_left   = 0; ps.content_margin_right  = 0
	ps.content_margin_top    = 6; ps.content_margin_bottom = 6
	_dropdown.add_theme_stylebox_override("panel", ps)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 1)
	_dropdown.add_child(vbox)

	for i in options.size():
		_build_option(vbox, i)

	_overlay.add_child(_dropdown)

	# Position below trigger
	var trigger_rect := _trigger.get_global_rect()
	_dropdown.custom_minimum_size.x = trigger_rect.size.x
	_dropdown.position = Vector2(trigger_rect.position.x, trigger_rect.position.y + trigger_rect.size.y + 4.0)
	_clamp_dropdown.call_deferred()

	# Fade in + slide down
	var target_y := _dropdown.position.y
	_dropdown.position.y = target_y - 10.0
	_dropdown.modulate.a = 0.0
	var tw := _dropdown.create_tween().set_parallel(true)
	tw.tween_property(_dropdown, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	tw.tween_property(_dropdown, "position:y", target_y, 0.3) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _build_option(parent: Control, index: int) -> void:
	var is_selected := index == selected_index

	var item_wrap := MarginContainer.new()
	item_wrap.add_theme_constant_override("margin_left",   4)
	item_wrap.add_theme_constant_override("margin_right",  4)
	item_wrap.add_theme_constant_override("margin_top",    0)
	item_wrap.add_theme_constant_override("margin_bottom", 0)
	parent.add_child(item_wrap)

	var btn := Button.new()
	btn.text = ("✓  " if is_selected else "    ") + options[index]
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.focus_mode = Control.FOCUS_NONE
	btn.custom_minimum_size = Vector2(0, 36)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var font_c := UITheme.PRIMARY_LIGHT if is_selected else UITheme.TEXT_PRIMARY

	var n := _option_style(UITheme.PRIMARY_SOFT if is_selected else Color(0, 0, 0, 0))
	var h := _option_style(UITheme.PRIMARY_SOFT)

	btn.add_theme_stylebox_override("normal",  n)
	btn.add_theme_stylebox_override("hover",   h)
	btn.add_theme_stylebox_override("pressed", h)
	btn.add_theme_stylebox_override("focus",   n)
	btn.add_theme_color_override("font_color",       font_c)
	btn.add_theme_color_override("font_hover_color", UITheme.PRIMARY_LIGHT)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	var captured := index
	btn.pressed.connect(func():
		_close_dropdown()
		selected_index = captured
		selection_changed.emit(captured, options[captured])
	)
	item_wrap.add_child(btn)


func _clamp_dropdown() -> void:
	if not is_instance_valid(_dropdown): return
	var min_sz  := _dropdown.get_minimum_size()
	var vp_size := get_tree().root.get_visible_rect().size
	_dropdown.position = Vector2(
		clampf(_dropdown.position.x, 4.0, vp_size.x - min_sz.x - 4.0),
		clampf(_dropdown.position.y, 4.0, vp_size.y - min_sz.y - 4.0)
	)


func _close_dropdown() -> void:
	_is_open = false
	if is_instance_valid(_overlay):
		_overlay.queue_free()
	_overlay  = null
	_dropdown = null
	_refresh_display()


# ── Styles ────────────────────────────────────────────────────────────────────

func _trigger_style(bg: Color, bc: Color, bw: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color                   = bg
	s.corner_radius_top_left     = UITheme.RADIUS_MD
	s.corner_radius_top_right    = UITheme.RADIUS_MD
	s.corner_radius_bottom_left  = UITheme.RADIUS_MD
	s.corner_radius_bottom_right = UITheme.RADIUS_MD
	s.border_width_top    = bw; s.border_width_bottom = bw
	s.border_width_left   = bw; s.border_width_right  = bw
	s.border_color          = bc
	s.content_margin_left   = 12; s.content_margin_right  = 12
	s.content_margin_top    = 10; s.content_margin_bottom = 10
	return s


func _option_style(bg: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color                   = bg
	s.corner_radius_top_left     = UITheme.RADIUS_SM
	s.corner_radius_top_right    = UITheme.RADIUS_SM
	s.corner_radius_bottom_left  = UITheme.RADIUS_SM
	s.corner_radius_bottom_right = UITheme.RADIUS_SM
	s.content_margin_left   = 14; s.content_margin_right  = 14
	s.content_margin_top    =  4; s.content_margin_bottom =  4
	return s


# ── Layer ─────────────────────────────────────────────────────────────────────

func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == &"_UISelectLayer":
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name  = &"_UISelectLayer"
	layer.layer = 103   # above UIContextMenu (102)
	root.add_child(layer)
	return layer
