## UIDatePicker — Standalone Component
## Calendar-based date selector with month/year navigation,
## day grid, and CanvasLayer overlay for dropdown mode.
##
## Usage:
##   var dp := UIDatePicker.new()
##   dp.date_selected.connect(func(d): print(d))  # Dictionary {year, month, day}
##   parent.add_child(dp)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIDatePicker
extends VBoxContainer

signal date_selected(date: Dictionary)

@export var label_text: String = "":
	set(v): label_text = v; if is_inside_tree(): _rebuild.call_deferred()

@export var placeholder: String = "Select date...":
	set(v): placeholder = v; if _trigger_btn: _trigger_btn.text = v if _selected_date.is_empty() else _format_date()

var _selected_date: Dictionary = {}   # {year, month, day}
var _view_year: int
var _view_month: int      # 1-12
var _trigger_btn: Button
var _calendar_panel: PanelContainer
var _is_open: bool = false

const LAYER_NAME := "_UIDatePickerLayer"
const LAYER_Z := 105
const CELL_SIZE := 36
const COLS := 7
const DAY_NAMES := ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]


func _ready() -> void:
	add_theme_constant_override("separation", 4)
	var now := Time.get_datetime_dict_from_system()
	_view_year = now["year"]
	_view_month = now["month"]
	_rebuild()


func get_date() -> Dictionary:
	return _selected_date


func clear_date() -> void:
	_selected_date = {}
	if _trigger_btn:
		_trigger_btn.text = placeholder
	date_selected.emit({})


func _rebuild() -> void:
	while get_child_count() > 0:
		var child := get_child(0)
		remove_child(child)
		child.queue_free()
	_trigger_btn = null
	_build()


func _build() -> void:
	# Optional label
	if not label_text.is_empty():
		var lbl := Label.new()
		lbl.text = label_text
		lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
		lbl.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
		add_child(lbl)

	# Trigger button
	_trigger_btn = Button.new()
	_trigger_btn.text = _format_date() if not _selected_date.is_empty() else placeholder
	_trigger_btn.focus_mode = Control.FOCUS_NONE
	_trigger_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_trigger_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_trigger_btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	var text_c := UITheme.TEXT_PRIMARY if not _selected_date.is_empty() else UITheme.TEXT_MUTED
	_trigger_btn.add_theme_color_override("font_color", text_c)
	_trigger_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)

	var n_s := StyleBoxFlat.new()
	n_s.bg_color = UITheme.SURFACE_3
	n_s.border_color = UITheme.BORDER
	n_s.border_width_left = 1; n_s.border_width_right = 1
	n_s.border_width_top = 1; n_s.border_width_bottom = 1
	n_s.corner_radius_top_left = UITheme.RADIUS_MD
	n_s.corner_radius_top_right = UITheme.RADIUS_MD
	n_s.corner_radius_bottom_left = UITheme.RADIUS_MD
	n_s.corner_radius_bottom_right = UITheme.RADIUS_MD
	n_s.content_margin_left = 12; n_s.content_margin_right = 12
	n_s.content_margin_top = 8; n_s.content_margin_bottom = 8

	var h_s := n_s.duplicate()
	h_s.border_color = UITheme.PRIMARY

	_trigger_btn.add_theme_stylebox_override("normal", n_s)
	_trigger_btn.add_theme_stylebox_override("hover", h_s)
	_trigger_btn.add_theme_stylebox_override("pressed", h_s)
	_trigger_btn.add_theme_stylebox_override("focus", n_s)
	_trigger_btn.pressed.connect(_toggle_calendar)
	add_child(_trigger_btn)


func _toggle_calendar() -> void:
	if _is_open:
		_close_calendar()
	else:
		_open_calendar()


func _open_calendar() -> void:
	_is_open = true
	var layer := _get_or_create_layer()

	# Click-outside overlay
	var overlay := ColorRect.new()
	overlay.name = "_overlay"
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.15)
	overlay.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			var mb := event as InputEventMouseButton
			if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
				_close_calendar()
	)
	layer.add_child(overlay)

	# Calendar panel
	_calendar_panel = PanelContainer.new()
	var panel_s := StyleBoxFlat.new()
	panel_s.bg_color = UITheme.SURFACE_2
	panel_s.border_color = UITheme.BORDER
	panel_s.border_width_left = 1; panel_s.border_width_right = 1
	panel_s.border_width_top = 1; panel_s.border_width_bottom = 1
	panel_s.corner_radius_top_left = UITheme.RADIUS_LG
	panel_s.corner_radius_top_right = UITheme.RADIUS_LG
	panel_s.corner_radius_bottom_left = UITheme.RADIUS_LG
	panel_s.corner_radius_bottom_right = UITheme.RADIUS_LG
	panel_s.shadow_size = 12
	panel_s.shadow_color = Color(0, 0, 0, 0.3)
	panel_s.content_margin_left = 16; panel_s.content_margin_right = 16
	panel_s.content_margin_top = 12; panel_s.content_margin_bottom = 12
	_calendar_panel.add_theme_stylebox_override("panel", panel_s)

	# Position below trigger
	var gpos := _trigger_btn.global_position
	var gsz := _trigger_btn.size
	_calendar_panel.position = Vector2(gpos.x, gpos.y + gsz.y + 4)
	layer.add_child(_calendar_panel)

	_build_calendar_content()

	# Fade in
	_calendar_panel.modulate.a = 0.0
	var t := _calendar_panel.create_tween()
	t.tween_property(_calendar_panel, "modulate:a", 1.0, 0.15)


func _close_calendar() -> void:
	_is_open = false
	var layer := _get_or_create_layer()
	for child in layer.get_children():
		child.queue_free()
	_calendar_panel = null


func _build_calendar_content() -> void:
	if _calendar_panel == null: return
	# Clear existing content
	for c in _calendar_panel.get_children():
		c.queue_free()

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	_calendar_panel.add_child(vbox)

	# ── Header: < Month Year > ──
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	header.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(header)

	var prev_btn := Button.new()
	prev_btn.text = "◂"
	prev_btn.flat = true
	prev_btn.focus_mode = Control.FOCUS_NONE
	prev_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	prev_btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	prev_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	prev_btn.pressed.connect(func():
		_view_month -= 1
		if _view_month < 1:
			_view_month = 12; _view_year -= 1
		_build_calendar_content()
	)
	header.add_child(prev_btn)

	var month_lbl := Label.new()
	month_lbl.text = _month_name(_view_month) + " " + str(_view_year)
	month_lbl.custom_minimum_size.x = 140
	month_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	month_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	month_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	header.add_child(month_lbl)

	var next_btn := Button.new()
	next_btn.text = "▸"
	next_btn.flat = true
	next_btn.focus_mode = Control.FOCUS_NONE
	next_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	next_btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	next_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	next_btn.pressed.connect(func():
		_view_month += 1
		if _view_month > 12:
			_view_month = 1; _view_year += 1
		_build_calendar_content()
	)
	header.add_child(next_btn)

	# ── Day-of-week headers ──
	var day_header := GridContainer.new()
	day_header.columns = COLS
	day_header.add_theme_constant_override("h_separation", 2)
	day_header.add_theme_constant_override("v_separation", 2)
	vbox.add_child(day_header)

	for dn in DAY_NAMES:
		var dl := Label.new()
		dl.text = dn
		dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		dl.custom_minimum_size = Vector2(CELL_SIZE, CELL_SIZE * 0.7)
		dl.add_theme_font_size_override("font_size", UITheme.FONT_XS)
		dl.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		day_header.add_child(dl)

	# ── Day grid ──
	var grid := GridContainer.new()
	grid.columns = COLS
	grid.add_theme_constant_override("h_separation", 2)
	grid.add_theme_constant_override("v_separation", 2)
	vbox.add_child(grid)

	var first_weekday := _weekday_of(1)   # 0=Mon
	var days_in_month := _days_in_month()
	var now := Time.get_datetime_dict_from_system()

	# Empty cells before first day
	for i in first_weekday:
		var empty := Control.new()
		empty.custom_minimum_size = Vector2(CELL_SIZE, CELL_SIZE)
		grid.add_child(empty)

	# Day buttons
	for day in range(1, days_in_month + 1):
		var is_today: bool = _view_year == now["year"] and _view_month == now["month"] and day == now["day"]
		var is_selected: bool = (not _selected_date.is_empty() and
			_selected_date.get("year", -1) == _view_year and
			_selected_date.get("month", -1) == _view_month and
			_selected_date.get("day", -1) == day)

		var day_btn := Button.new()
		day_btn.text = str(day)
		day_btn.focus_mode = Control.FOCUS_NONE
		day_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		day_btn.custom_minimum_size = Vector2(CELL_SIZE, CELL_SIZE)
		day_btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)

		var d_n := StyleBoxFlat.new()
		var d_h := StyleBoxFlat.new()
		var rad := UITheme.RADIUS_SM
		for s: StyleBoxFlat in [d_n, d_h]:
			s.corner_radius_top_left = rad; s.corner_radius_top_right = rad
			s.corner_radius_bottom_left = rad; s.corner_radius_bottom_right = rad

		if is_selected:
			d_n.bg_color = UITheme.PRIMARY
			d_h.bg_color = UITheme.PRIMARY_DARK
			day_btn.add_theme_color_override("font_color", Color.WHITE)
			day_btn.add_theme_color_override("font_hover_color", Color.WHITE)
		elif is_today:
			d_n.bg_color = Color.TRANSPARENT
			d_n.border_color = UITheme.PRIMARY
			d_n.border_width_left = 1; d_n.border_width_right = 1
			d_n.border_width_top = 1; d_n.border_width_bottom = 1
			d_h.bg_color = UITheme.PRIMARY_SOFT
			day_btn.add_theme_color_override("font_color", UITheme.PRIMARY)
			day_btn.add_theme_color_override("font_hover_color", UITheme.PRIMARY)
		else:
			d_n.bg_color = Color.TRANSPARENT
			d_h.bg_color = UITheme.SURFACE_3
			day_btn.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
			day_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)

		day_btn.add_theme_stylebox_override("normal", d_n)
		day_btn.add_theme_stylebox_override("hover", d_h)
		day_btn.add_theme_stylebox_override("pressed", d_h)
		day_btn.add_theme_stylebox_override("focus", d_n)

		var captured_day := day
		day_btn.pressed.connect(func():
			_selected_date = {"year": _view_year, "month": _view_month, "day": captured_day}
			date_selected.emit(_selected_date)
			if _trigger_btn:
				_trigger_btn.text = _format_date()
				_trigger_btn.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
			_close_calendar()
		)
		grid.add_child(day_btn)

	# ── Today button ──
	var today_row := CenterContainer.new()
	vbox.add_child(today_row)

	var today_btn := Button.new()
	today_btn.text = "Today"
	today_btn.flat = true
	today_btn.focus_mode = Control.FOCUS_NONE
	today_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	today_btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	today_btn.add_theme_color_override("font_color", UITheme.PRIMARY)
	today_btn.add_theme_color_override("font_hover_color", UITheme.PRIMARY_LIGHT)
	today_btn.pressed.connect(func():
		var today := Time.get_datetime_dict_from_system()
		_selected_date = {"year": today["year"], "month": today["month"], "day": today["day"]}
		_view_year = today["year"]; _view_month = today["month"]
		date_selected.emit(_selected_date)
		if _trigger_btn:
			_trigger_btn.text = _format_date()
			_trigger_btn.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		_close_calendar()
	)
	today_row.add_child(today_btn)


# ── Date helpers ──────────────────────────────────────────────────────────────

func _format_date() -> String:
	if _selected_date.is_empty(): return placeholder
	return "%04d-%02d-%02d" % [_selected_date["year"], _selected_date["month"], _selected_date["day"]]


func _month_name(m: int) -> String:
	var names := ["", "January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"]
	return names[clampi(m, 1, 12)]


func _days_in_month() -> int:
	var m := _view_month
	var y := _view_year
	match m:
		1, 3, 5, 7, 8, 10, 12: return 31
		4, 6, 9, 11: return 30
		2:
			if y % 400 == 0: return 29
			if y % 100 == 0: return 28
			if y % 4 == 0: return 29
			return 28
		_: return 30


@warning_ignore("integer_division")
func _weekday_of(day: int) -> int:
	# Zeller's congruence — floori used for explicit integer floor division
	var y := _view_year
	var m := _view_month
	if m < 3:
		m += 12; y -= 1
	var k: int = y % 100
	var j: int = floori(y / 100.0)
	var z1: int = floori((13 * (m + 1)) / 5.0)
	var z2: int = floori(k / 4.0)
	var z3: int = floori(j / 4.0)
	var h: int = (day + z1 + k + z2 + z3 + 5 * j) % 7
	# h: 0=Sat,1=Sun,2=Mon,...,6=Fri → convert to 0=Mon
	return (h + 5) % 7


func _get_or_create_layer() -> CanvasLayer:
	var root := get_tree().root
	for child in root.get_children():
		if child.name == LAYER_NAME:
			return child as CanvasLayer
	var layer := CanvasLayer.new()
	layer.name = LAYER_NAME
	layer.layer = LAYER_Z
	root.add_child(layer)
	return layer


func _exit_tree() -> void:
	if _is_open:
		_close_calendar()
