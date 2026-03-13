## UIColorPicker — Standalone Component
## Color selector with swatch grid, hex input, current color preview,
## and color_changed signal.
##
## Usage:
##   var picker := UIColorPicker.new()
##   picker.current_color = Color("#6C63FF")
##   picker.color_changed.connect(func(c): print(c))
##   parent.add_child(picker)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIColorPicker
extends VBoxContainer

signal color_changed(color: Color)

@export var current_color: Color = UITheme.PRIMARY:
	set(v): current_color = v; _update_preview(); color_changed.emit(v)

@export var show_hex_input: bool = true:
	set(v): show_hex_input = v; if is_inside_tree(): _rebuild.call_deferred()

var _preview: Control
var _hex_input: LineEdit
var _updating_hex: bool = false

const SWATCH_COLORS: Array[Color] = [
	# Row 1: Reds / Pinks
	Color("#EF4444"), Color("#F87171"), Color("#FB7185"), Color("#F472B6"),
	Color("#E879F9"), Color("#C084FC"), Color("#A78BFA"), Color("#818CF8"),
	# Row 2: Blues / Cyans
	Color("#6C63FF"), Color("#6366F1"), Color("#3B82F6"), Color("#60A5FA"),
	Color("#38BDF8"), Color("#22D3EE"), Color("#2DD4BF"), Color("#34D399"),
	# Row 3: Greens / Yellows
	Color("#4ADE80"), Color("#86EFAC"), Color("#A3E635"), Color("#FACC15"),
	Color("#FBBF24"), Color("#FB923C"), Color("#F97316"), Color("#EA580C"),
	# Row 4: Neutrals
	Color("#FFFFFF"), Color("#E8E9F3"), Color("#8B90A7"), Color("#555A72"),
	Color("#2E3347"), Color("#1C1F2E"), Color("#141720"), Color("#0D0F14"),
]

const COLS := 8
const SWATCH_SIZE := 28
const SWATCH_GAP := 4


func _ready() -> void:
	add_theme_constant_override("separation", 12)
	_rebuild()


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()
	_preview = null
	_hex_input = null
	_build()


func _build() -> void:
	# ── Preview + Hex row ──
	var top_row := HBoxContainer.new()
	top_row.add_theme_constant_override("separation", 12)
	add_child(top_row)

	# Color preview
	_preview = Control.new()
	_preview.custom_minimum_size = Vector2(44, 44)
	var preview_ref := _preview
	var color_ref := func() -> Color: return current_color
	_preview.draw.connect(func():
		var s := preview_ref.size
		var r := minf(s.x, s.y) / 2.0
		preview_ref.draw_circle(s / 2.0, r, color_ref.call())
		# Border ring
		preview_ref.draw_arc(s / 2.0, r, 0, TAU, 32, UITheme.BORDER, 1.5)
	)
	top_row.add_child(_preview)

	# Hex input + label
	if show_hex_input:
		var hex_col := VBoxContainer.new()
		hex_col.add_theme_constant_override("separation", 4)
		hex_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		top_row.add_child(hex_col)

		var hex_lbl := Label.new()
		hex_lbl.text = "HEX"
		hex_lbl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
		hex_lbl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		hex_col.add_child(hex_lbl)

		_hex_input = LineEdit.new()
		_hex_input.text = "#" + current_color.to_html(false)
		_hex_input.placeholder_text = "#6C63FF"
		_hex_input.add_theme_font_size_override("font_size", UITheme.FONT_SM)
		_hex_input.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		_hex_input.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
		_hex_input.add_theme_color_override("caret_color", UITheme.PRIMARY)

		var input_s := StyleBoxFlat.new()
		input_s.bg_color = UITheme.SURFACE_3
		input_s.border_color = UITheme.BORDER
		input_s.border_width_bottom = 1; input_s.border_width_top = 1
		input_s.border_width_left = 1; input_s.border_width_right = 1
		input_s.corner_radius_top_left = UITheme.RADIUS_SM
		input_s.corner_radius_top_right = UITheme.RADIUS_SM
		input_s.corner_radius_bottom_left = UITheme.RADIUS_SM
		input_s.corner_radius_bottom_right = UITheme.RADIUS_SM
		input_s.content_margin_left = 10; input_s.content_margin_right = 10
		input_s.content_margin_top = 6; input_s.content_margin_bottom = 6

		var focus_s := input_s.duplicate()
		focus_s.border_color = UITheme.PRIMARY
		_hex_input.add_theme_stylebox_override("normal", input_s)
		_hex_input.add_theme_stylebox_override("focus", focus_s)
		_hex_input.text_submitted.connect(_on_hex_submitted)
		hex_col.add_child(_hex_input)

	# ── Swatch grid ──
	var grid := GridContainer.new()
	grid.columns = COLS
	grid.add_theme_constant_override("h_separation", SWATCH_GAP)
	grid.add_theme_constant_override("v_separation", SWATCH_GAP)
	add_child(grid)

	for i in SWATCH_COLORS.size():
		var c: Color = SWATCH_COLORS[i]
		_build_swatch(grid, c)


func _build_swatch(parent: Control, c: Color) -> void:
	var swatch := PanelContainer.new()
	swatch.custom_minimum_size = Vector2(SWATCH_SIZE, SWATCH_SIZE)
	swatch.mouse_filter = Control.MOUSE_FILTER_STOP
	swatch.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	var is_sel := c.is_equal_approx(current_color)
	var s := _swatch_style(c, is_sel, false)
	swatch.add_theme_stylebox_override("panel", s)

	swatch.mouse_entered.connect(func():
		swatch.add_theme_stylebox_override("panel", _swatch_style(c, is_sel, true)))
	swatch.mouse_exited.connect(func():
		swatch.add_theme_stylebox_override("panel", _swatch_style(c, is_sel, false)))

	swatch.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			var mb := event as InputEventMouseButton
			if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
				_updating_hex = true
				current_color = c
				_updating_hex = false
				_rebuild.call_deferred()
	)

	# Checkmark for selected
	if is_sel:
		var check_center := CenterContainer.new()
		swatch.add_child(check_center)
		var check_lbl := Label.new()
		check_lbl.text = "✓"
		check_lbl.add_theme_font_size_override("font_size", 12)
		# Contrast: white text on dark colors, dark on light
		check_lbl.add_theme_color_override("font_color", Color.WHITE if c.get_luminance() < 0.5 else Color.BLACK)
		check_center.add_child(check_lbl)

	parent.add_child(swatch)


func _swatch_style(c: Color, is_selected: bool, hovered: bool) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = c
	var r := UITheme.RADIUS_XS
	s.corner_radius_top_left = r; s.corner_radius_top_right = r
	s.corner_radius_bottom_left = r; s.corner_radius_bottom_right = r

	if is_selected:
		s.border_color = Color.WHITE if c.get_luminance() < 0.5 else UITheme.BG
		s.border_width_left = 2; s.border_width_right = 2
		s.border_width_top = 2; s.border_width_bottom = 2
	elif hovered:
		s.border_color = UITheme.BORDER_STRONG
		s.border_width_left = 2; s.border_width_right = 2
		s.border_width_top = 2; s.border_width_bottom = 2

	return s


func _on_hex_submitted(hex_text: String) -> void:
	var clean := hex_text.strip_edges()
	if not clean.begins_with("#"):
		clean = "#" + clean
	if clean.length() != 7 and clean.length() != 9: return

	var parsed := Color.from_string(clean, Color(-1, -1, -1))
	if parsed.r < 0: return

	_updating_hex = true
	current_color = parsed
	_updating_hex = false
	_rebuild.call_deferred()


func _update_preview() -> void:
	if _preview != null:
		_preview.queue_redraw()
	if _hex_input != null and not _updating_hex:
		_hex_input.text = "#" + current_color.to_html(false)
