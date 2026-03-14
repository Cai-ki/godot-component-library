## UINumberInput — Standalone Component
## Numeric input with increment/decrement buttons.
##
## Usage:
##   var ni := UINumberInput.new()
##   ni.value = 5.0
##   ni.min_value = 0.0
##   ni.max_value = 100.0
##   ni.value_changed.connect(func(v): print(v))
##   parent.add_child(ni)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UINumberInput
extends VBoxContainer

signal value_changed(new_value: float)

@export var label_text: String = "":
	set(v):
		label_text = v
		if _lbl: _lbl.text = v; _lbl.visible = v != ""

@export var value: float = 0.0:
	set(v):
		var new_v := _snap(clampf(v, min_value, max_value))
		if value == new_v: return
		value = new_v
		if _line_edit: _line_edit.text = _format_value(value)
		_update_btn_states()

@export var min_value: float = 0.0:
	set(v):
		min_value = v
		value = _snap(clampf(value, min_value, max_value))
		if _line_edit: _line_edit.text = _format_value(value)
		_update_btn_states()

@export var max_value: float = 100.0:
	set(v):
		max_value = v
		value = _snap(clampf(value, min_value, max_value))
		if _line_edit: _line_edit.text = _format_value(value)
		_update_btn_states()

@export var step: float = 1.0

@export var prefix: String = "":
	set(v):
		prefix = v
		if _prefix_lbl: _prefix_lbl.text = v; _prefix_lbl.visible = v != ""

@export var suffix: String = "":
	set(v):
		suffix = v
		if _suffix_lbl: _suffix_lbl.text = v; _suffix_lbl.visible = v != ""

@export var disabled: bool = false:
	set(v):
		disabled = v
		if is_inside_tree(): _apply_styles()

@export var input_width: float = 80.0:
	set(v):
		input_width = v
		if _line_edit: _line_edit.custom_minimum_size.x = v

# ── Private vars ──────────────────────────────────────────────
var _lbl: Label
var _row: HBoxContainer
var _dec_btn: Button
var _inc_btn: Button
var _line_edit: LineEdit
var _prefix_lbl: Label
var _suffix_lbl: Label

# Long-press repeat
var _repeat_timer: Timer
var _repeat_dir: int = 0   # -1 = dec, +1 = inc
const REPEAT_INITIAL := 0.4
const REPEAT_INTERVAL := 0.08


func _ready() -> void:
	add_theme_constant_override("separation", 6)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()


# ── Public API ────────────────────────────────────────────────
func set_value_no_signal(v: float) -> void:
	var new_v := _snap(clampf(v, min_value, max_value))
	value = new_v


# ── Internal ──────────────────────────────────────────────────
func _build() -> void:
	# Label
	_lbl = Label.new()
	_lbl.text = label_text
	_lbl.visible = label_text != ""
	_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if UITheme.FONT_SANS: _lbl.add_theme_font_override("font", UITheme.FONT_SANS)
	add_child(_lbl)

	# Row: [dec] [prefix] [input] [suffix] [inc]
	_row = HBoxContainer.new()
	_row.add_theme_constant_override("separation", 0)
	add_child(_row)

	# Decrement button
	_dec_btn = Button.new()
	_dec_btn.text = "−"
	_dec_btn.focus_mode = Control.FOCUS_NONE
	_dec_btn.custom_minimum_size = Vector2(36, 36)
	_dec_btn.pressed.connect(func(): _step_value(-1))
	_dec_btn.button_down.connect(func(): _start_repeat(-1))
	_dec_btn.button_up.connect(func(): _stop_repeat())
	_row.add_child(_dec_btn)

	# Prefix label
	_prefix_lbl = Label.new()
	_prefix_lbl.text = prefix
	_prefix_lbl.visible = prefix != ""
	_prefix_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_prefix_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_prefix_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if UITheme.FONT_SANS: _prefix_lbl.add_theme_font_override("font", UITheme.FONT_SANS)
	_row.add_child(_prefix_lbl)

	# Line edit for value
	_line_edit = LineEdit.new()
	_line_edit.text = _format_value(value)
	_line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	_line_edit.custom_minimum_size = Vector2(input_width, 36)
	_line_edit.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_line_edit.text_submitted.connect(_on_text_submitted)
	_line_edit.focus_exited.connect(_on_focus_exited)
	_row.add_child(_line_edit)

	# Suffix label
	_suffix_lbl = Label.new()
	_suffix_lbl.text = suffix
	_suffix_lbl.visible = suffix != ""
	_suffix_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_suffix_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_suffix_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if UITheme.FONT_SANS: _suffix_lbl.add_theme_font_override("font", UITheme.FONT_SANS)
	_row.add_child(_suffix_lbl)

	# Increment button
	_inc_btn = Button.new()
	_inc_btn.text = "+"
	_inc_btn.focus_mode = Control.FOCUS_NONE
	_inc_btn.custom_minimum_size = Vector2(36, 36)
	_inc_btn.pressed.connect(func(): _step_value(1))
	_inc_btn.button_down.connect(func(): _start_repeat(1))
	_inc_btn.button_up.connect(func(): _stop_repeat())
	_row.add_child(_inc_btn)

	# Repeat timer
	_repeat_timer = Timer.new()
	_repeat_timer.one_shot = false
	_repeat_timer.timeout.connect(_on_repeat)
	add_child(_repeat_timer)

	_apply_styles()


func _step_value(dir: int) -> void:
	if disabled: return
	var s := step if step > 0.0 else 1.0
	var new_v := _snap(clampf(value + s * dir, min_value, max_value))
	if new_v != value:
		value = new_v
		value_changed.emit(value)


func _start_repeat(dir: int) -> void:
	if disabled: return
	_repeat_dir = dir
	_repeat_timer.start(REPEAT_INITIAL)


func _stop_repeat() -> void:
	_repeat_timer.stop()
	_repeat_dir = 0


func _on_repeat() -> void:
	_step_value(_repeat_dir)
	if _repeat_timer.wait_time != REPEAT_INTERVAL:
		_repeat_timer.wait_time = REPEAT_INTERVAL


func _on_text_submitted(_t: String) -> void:
	_commit_text()
	_line_edit.release_focus()


func _on_focus_exited() -> void:
	_commit_text()


func _commit_text() -> void:
	if not _line_edit: return
	var txt := _line_edit.text.strip_edges()
	if txt.is_valid_float():
		var new_v := _snap(clampf(txt.to_float(), min_value, max_value))
		if new_v != value:
			value = new_v
			value_changed.emit(value)
		else:
			_line_edit.text = _format_value(value)
	else:
		_line_edit.text = _format_value(value)
		UI.shake(_line_edit)


func _snap(v: float) -> float:
	if step <= 0.0: return v
	return roundf(v / step) * step


func _format_value(v: float) -> String:
	if step >= 1.0:
		return str(int(v))
	else:
		# Show decimal places matching step precision
		var decimals := 0
		var s := str(step)
		var dot := s.find(".")
		if dot >= 0:
			decimals = s.length() - dot - 1
		return "%.*f" % [decimals, v]


func _update_btn_states() -> void:
	if not _dec_btn: return
	_dec_btn.disabled = disabled or value <= min_value
	_inc_btn.disabled = disabled or value >= max_value


func _apply_styles() -> void:
	if not _row: return

	_update_btn_states()

	# Input style
	var bg := UITheme.SURFACE_3 if disabled else UITheme.SURFACE_2
	var n := _input_style(bg, 1, UITheme.BORDER)
	var f := _input_style(bg, 2, UITheme.PRIMARY)
	_line_edit.add_theme_stylebox_override("normal", n)
	_line_edit.add_theme_stylebox_override("focus", f)
	_line_edit.add_theme_stylebox_override("read_only", _input_style(UITheme.SURFACE_3, 1, UITheme.BORDER))
	_line_edit.editable = !disabled
	_line_edit.add_theme_color_override("font_color", UITheme.TEXT_MUTED if disabled else UITheme.TEXT_PRIMARY)
	_line_edit.add_theme_color_override("caret_color", UITheme.PRIMARY)
	_line_edit.add_theme_color_override("selection_color", UITheme.PRIMARY_SOFT)
	_line_edit.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	if UITheme.FONT_SANS: _line_edit.add_theme_font_override("font", UITheme.FONT_SANS)

	# Button styles
	_style_btn(_dec_btn, "left")
	_style_btn(_inc_btn, "right")

	# Prefix / suffix colors
	var txt_c := UITheme.TEXT_MUTED if disabled else UITheme.TEXT_SECONDARY
	_prefix_lbl.add_theme_color_override("font_color", txt_c)
	_suffix_lbl.add_theme_color_override("font_color", txt_c)


func _style_btn(btn: Button, side: String) -> void:
	var is_left := side == "left"

	for state in ["normal", "hover", "pressed", "disabled"]:
		var s := StyleBoxFlat.new()
		match state:
			"normal":   s.bg_color = UITheme.SURFACE_2
			"hover":    s.bg_color = UITheme.SURFACE_3
			"pressed":  s.bg_color = UITheme.SURFACE_4
			"disabled": s.bg_color = UITheme.SURFACE_2

		# Rounded on outer side, flat on inner side
		var r := UITheme.RADIUS_MD
		if is_left:
			s.corner_radius_top_left = r; s.corner_radius_bottom_left = r
			s.corner_radius_top_right = 0; s.corner_radius_bottom_right = 0
		else:
			s.corner_radius_top_right = r; s.corner_radius_bottom_right = r
			s.corner_radius_top_left = 0; s.corner_radius_bottom_left = 0

		s.border_width_top = 1; s.border_width_bottom = 1
		s.border_width_left = 1; s.border_width_right = 1
		s.border_color = UITheme.BORDER

		btn.add_theme_stylebox_override(state, s)

	btn.add_theme_font_size_override("font_size", UITheme.FONT_LG)
	var fc := UITheme.TEXT_MUTED if btn.disabled else UITheme.TEXT_PRIMARY
	btn.add_theme_color_override("font_color", fc)
	btn.add_theme_color_override("font_disabled_color", UITheme.TEXT_MUTED)


func _input_style(bg: Color, bw: int, bc: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(0)   # flat sides, buttons have the rounding
	s.border_width_top = bw; s.border_width_bottom = bw
	s.border_width_left = 0; s.border_width_right = 0
	s.border_color = bc
	s.content_margin_left = 8; s.content_margin_right = 8
	s.content_margin_top = 8; s.content_margin_bottom = 8
	return s
