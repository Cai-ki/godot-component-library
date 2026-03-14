## UISegmentedControl — Standalone Component
## Horizontal single-select button group with animated sliding indicator.
##
## Usage:
##   var seg := UISegmentedControl.new()
##   seg.items = PackedStringArray(["Day", "Week", "Month"])
##   seg.selected_index = 0
##   seg.selection_changed.connect(func(i): print(i))
##   parent.add_child(seg)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UISegmentedControl
extends PanelContainer

signal selection_changed(index: int)

enum Size { SM, MD, LG }

@export var items: PackedStringArray = PackedStringArray():
	set(v):
		items = v
		if is_inside_tree(): _rebuild.call_deferred()

@export var selected_index: int = 0:
	set(v):
		if items.size() == 0:
			selected_index = v
			return
		var clamped := clampi(v, 0, maxi(items.size() - 1, 0))
		if selected_index == clamped and _built:
			return
		selected_index = clamped
		if is_inside_tree(): _slide_to(selected_index)

@export var control_size: Size = Size.MD:
	set(v):
		control_size = v
		if is_inside_tree(): _rebuild.call_deferred()

@export var disabled: bool = false:
	set(v):
		disabled = v
		if is_inside_tree(): _rebuild.call_deferred()

@export var full_width: bool = false:
	set(v):
		full_width = v
		if is_inside_tree(): _rebuild.call_deferred()

# ── Indicator animation state ─────────────────────────────────
var _ind_x: float = 0.0
var _ind_w: float = 0.0
var _ind_radius: int = 6

# ── Private vars ──────────────────────────────────────────────
var _hbox: HBoxContainer
var _buttons: Array[Button] = []
var _built: bool = false


func _ready() -> void:
	# Non-full_width: shrink to content; full_width: expand to fill parent
	if full_width:
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
	else:
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	_rebuild()


# ── Public API ────────────────────────────────────────────────
func get_selected_text() -> String:
	if selected_index >= 0 and selected_index < items.size():
		return items[selected_index]
	return ""


# ── Draw indicator ────────────────────────────────────────────
func _draw() -> void:
	if not _built or _buttons.size() == 0: return
	if selected_index < 0 or selected_index >= _buttons.size(): return

	# Draw indicator rect behind buttons (PanelContainer draws its bg first, then _draw, then children)
	var content_pos := _hbox.position  # offset from PanelContainer content margin
	var rect := Rect2(
		content_pos.x + _ind_x,
		content_pos.y,
		_ind_w,
		_hbox.size.y
	)
	var sb := StyleBoxFlat.new()
	if disabled:
		sb.bg_color = UITheme.SURFACE_3
	else:
		sb.bg_color = UITheme.SURFACE_3.lightened(0.15)
		sb.border_width_top = 1; sb.border_width_bottom = 1
		sb.border_width_left = 1; sb.border_width_right = 1
		sb.border_color = UITheme.BORDER_LIGHT
	sb.set_corner_radius_all(_ind_radius)
	sb.shadow_size = 3
	sb.shadow_color = Color(0, 0, 0, 0.2)
	draw_style_box(sb, rect)


# ── Internal ──────────────────────────────────────────────────
func _rebuild() -> void:
	_built = false
	for child in get_children():
		remove_child(child)
		child.queue_free()
	_buttons.clear()

	if items.size() == 0:
		_built = true
		return

	# Sizing mode
	if full_width:
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
	else:
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN

	# Sizes
	var font_size: int
	var pad_x: int
	var pad_y: int
	match control_size:
		Size.SM:
			font_size = UITheme.FONT_XS; pad_x = 12; pad_y = 5; _ind_radius = UITheme.RADIUS_SM - 1
		Size.LG:
			font_size = UITheme.FONT_BASE; pad_x = 24; pad_y = 10; _ind_radius = UITheme.RADIUS_LG - 2
		_:
			font_size = UITheme.FONT_SM; pad_x = 16; pad_y = 7; _ind_radius = UITheme.RADIUS_MD - 1

	# Track background
	var radius: int
	match control_size:
		Size.SM: radius = UITheme.RADIUS_SM
		Size.LG: radius = UITheme.RADIUS_LG
		_: radius = UITheme.RADIUS_MD

	var track_s := StyleBoxFlat.new()
	track_s.bg_color = UITheme.SURFACE_2
	track_s.set_corner_radius_all(radius)
	track_s.border_width_top = 1; track_s.border_width_bottom = 1
	track_s.border_width_left = 1; track_s.border_width_right = 1
	track_s.border_color = UITheme.BORDER
	track_s.content_margin_left = 3; track_s.content_margin_right = 3
	track_s.content_margin_top = 3; track_s.content_margin_bottom = 3
	add_theme_stylebox_override("panel", track_s)

	# HBox for buttons — the only child of PanelContainer
	_hbox = HBoxContainer.new()
	_hbox.add_theme_constant_override("separation", 0)
	_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hbox)

	# Buttons
	for i in range(items.size()):
		var btn := Button.new()
		btn.text = items[i]
		btn.flat = true
		btn.focus_mode = Control.FOCUS_ALL
		btn.clip_text = true
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if not disabled else Control.CURSOR_ARROW
		btn.disabled = disabled
		if full_width:
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.add_theme_font_size_override("font_size", font_size)

		# Transparent backgrounds — indicator drawn via _draw()
		for state in ["normal", "hover", "pressed", "disabled"]:
			var s := StyleBoxFlat.new()
			s.bg_color = Color.TRANSPARENT
			s.content_margin_left = pad_x; s.content_margin_right = pad_x
			s.content_margin_top = pad_y; s.content_margin_bottom = pad_y
			btn.add_theme_stylebox_override(state, s)
		
		var fo := StyleBoxFlat.new()
		fo.bg_color = Color.TRANSPARENT
		fo.border_width_top = 2; fo.border_width_bottom = 2
		fo.border_width_left = 2; fo.border_width_right = 2
		fo.border_color = UITheme.PRIMARY_SOFT
		fo.set_corner_radius_all(_ind_radius)
		btn.add_theme_stylebox_override("focus", fo)

		var captured_i := i
		btn.pressed.connect(func():
			if disabled: return
			if selected_index != captured_i:
				selected_index = captured_i
				selection_changed.emit(selected_index)
		)
		_hbox.add_child(btn)
		_buttons.append(btn)

	_built = true

	# Wait one frame for layout
	await get_tree().process_frame
	_snap_indicator()
	_update_button_colors()
	queue_redraw()


func _slide_to(idx: int) -> void:
	if not _built or _buttons.size() == 0: return
	_update_button_colors()
	if idx < 0 or idx >= _buttons.size(): return

	var target_btn := _buttons[idx]
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_method(func(v: float): _ind_x = v; queue_redraw(), _ind_x, target_btn.position.x, 0.2)
	tween.tween_method(func(v: float): _ind_w = v; queue_redraw(), _ind_w, target_btn.size.x, 0.2)


func _snap_indicator() -> void:
	if _buttons.size() == 0 or selected_index < 0 or selected_index >= _buttons.size():
		return
	var target_btn := _buttons[selected_index]
	_ind_x = target_btn.position.x
	_ind_w = target_btn.size.x


func _update_button_colors() -> void:
	for i in range(_buttons.size()):
		var btn := _buttons[i]
		var is_sel := i == selected_index
		var fc: Color
		if disabled:
			fc = UITheme.TEXT_MUTED
		elif is_sel:
			fc = UITheme.TEXT_PRIMARY
		else:
			fc = UITheme.TEXT_SECONDARY
		btn.add_theme_color_override("font_color", fc)
		btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY if not disabled else UITheme.TEXT_MUTED)
		btn.add_theme_color_override("font_pressed_color", fc)
		btn.add_theme_color_override("font_disabled_color", UITheme.TEXT_MUTED)
