## UITable — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UITable
extends VBoxContainer

@export var striped:     bool = true
@export var show_border: bool = true
@export var sortable:    bool = false
@export var filterable:  bool = false

var _columns:       PackedStringArray = []
var _rows_data:     Array = []
var _filtered_data: Array = []
var _search_text:   String = ""
var _search_input:  LineEdit
var _header_h:  HBoxContainer
var _body_v:    VBoxContainer
var _sort_col:  int  = -1
var _sort_asc:  bool = true

func _ready() -> void:
	add_theme_constant_override("separation", 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()

# ── Public API ────────────────────────────────────
func set_columns(cols: PackedStringArray) -> void:
	_columns = cols
	_rebuild_header()

func add_row(data: Array) -> void:
	_rows_data.append(data)
	_apply_filter()
	_rebuild_body()

func clear_rows() -> void:
	_rows_data.clear()
	_filtered_data.clear()
	for c in _body_v.get_children():
		c.queue_free()

func set_data(cols: PackedStringArray, rows: Array) -> void:
	set_columns(cols)
	for row in rows:
		_rows_data.append(row)
	_apply_filter()
	_rebuild_body()

# ── Internal ──────────────────────────────────────
func _build() -> void:
	# Search bar (filterable only)
	if filterable:
		var search_m := MarginContainer.new()
		search_m.add_theme_constant_override("margin_left",   0)
		search_m.add_theme_constant_override("margin_right",  0)
		search_m.add_theme_constant_override("margin_top",    0)
		search_m.add_theme_constant_override("margin_bottom", 8)
		search_m.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(search_m)

		_search_input = LineEdit.new()
		_search_input.placeholder_text = "Search..."
		_search_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var normal_s := StyleBoxFlat.new()
		normal_s.bg_color = UITheme.SURFACE_2
		normal_s.corner_radius_top_left     = UITheme.RADIUS_MD
		normal_s.corner_radius_top_right    = UITheme.RADIUS_MD
		normal_s.corner_radius_bottom_left  = UITheme.RADIUS_MD
		normal_s.corner_radius_bottom_right = UITheme.RADIUS_MD
		normal_s.border_width_top = 1; normal_s.border_width_bottom = 1
		normal_s.border_width_left = 1; normal_s.border_width_right = 1
		normal_s.border_color = UITheme.BORDER
		normal_s.content_margin_left = 12; normal_s.content_margin_right = 12
		normal_s.content_margin_top = 9; normal_s.content_margin_bottom = 9
		var focus_s := normal_s.duplicate()
		focus_s.border_color = UITheme.PRIMARY
		_search_input.add_theme_stylebox_override("normal", normal_s)
		_search_input.add_theme_stylebox_override("focus",  focus_s)
		_search_input.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		_search_input.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
		_search_input.add_theme_color_override("caret_color", UITheme.PRIMARY)
		_search_input.add_theme_font_size_override("font_size", UITheme.FONT_MD)
		_search_input.text_changed.connect(_on_search_changed)
		search_m.add_child(_search_input)

	# Header
	var hp := PanelContainer.new()
	hp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var hs := StyleBoxFlat.new()
	hs.bg_color = UITheme.SURFACE_3
	hs.corner_radius_top_left  = UITheme.RADIUS_LG; hs.corner_radius_top_right = UITheme.RADIUS_LG
	if show_border:
		hs.border_width_top = 1; hs.border_width_left = 1; hs.border_width_right = 1
		hs.border_color = UITheme.BORDER
	hs.content_margin_left = 16; hs.content_margin_right  = 16
	hs.content_margin_top  = 12; hs.content_margin_bottom = 12
	hp.add_theme_stylebox_override("panel", hs)
	add_child(hp)

	_header_h = HBoxContainer.new()
	_header_h.add_theme_constant_override("separation", 0)
	hp.add_child(_header_h)

	# Body
	var bp := PanelContainer.new()
	bp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var bs := StyleBoxFlat.new()
	bs.bg_color = UITheme.SURFACE_2
	bs.corner_radius_bottom_left  = UITheme.RADIUS_LG
	bs.corner_radius_bottom_right = UITheme.RADIUS_LG
	if show_border:
		bs.border_width_bottom = 1; bs.border_width_left = 1; bs.border_width_right = 1
		bs.border_color = UITheme.BORDER
	bp.add_theme_stylebox_override("panel", bs)
	add_child(bp)

	_body_v = VBoxContainer.new()
	_body_v.add_theme_constant_override("separation", 0)
	_body_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bp.add_child(_body_v)

func _rebuild_header() -> void:
	for c in _header_h.get_children(): c.queue_free()
	for i in _columns.size():
		if sortable:
			var btn := Button.new()
			btn.flat = true
			btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			btn.focus_mode = Control.FOCUS_NONE
			btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			var arrow := ""
			if i == _sort_col:
				arrow = "  ▲" if _sort_asc else "  ▼"
			btn.text = _columns[i] + arrow
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.add_theme_font_size_override("font_size", UITheme.FONT_SM)
			var fc := UITheme.TEXT_PRIMARY if i == _sort_col else UITheme.TEXT_MUTED
			btn.add_theme_color_override("font_color", fc)
			btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
			var ns := StyleBoxFlat.new()
			ns.bg_color = Color(0, 0, 0, 0)
			btn.add_theme_stylebox_override("normal",  ns)
			btn.add_theme_stylebox_override("hover",   ns)
			btn.add_theme_stylebox_override("pressed", ns)
			btn.add_theme_stylebox_override("focus",   ns)
			var captured := i
			btn.pressed.connect(func(): _sort_by(captured))
			_header_h.add_child(btn)
		else:
			var l := Label.new()
			l.text = _columns[i]
			l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			l.add_theme_font_size_override("font_size", UITheme.FONT_SM)
			l.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
			_header_h.add_child(l)


func _sort_by(col: int) -> void:
	if col == _sort_col:
		_sort_asc = !_sort_asc
	else:
		_sort_col = col
		_sort_asc = true

	var asc := _sort_asc
	_rows_data.sort_custom(func(a: Array, b: Array) -> bool:
		var sa := str(a[col])
		var sb := str(b[col])
		if sa.is_valid_float() and sb.is_valid_float():
			return float(sa) < float(sb) if asc else float(sa) > float(sb)
		return (sa < sb) if asc else (sa > sb)
	)

	_apply_filter()
	_rebuild_header()
	_rebuild_body()


func _on_search_changed(text: String) -> void:
	_search_text = text
	_apply_filter()
	_rebuild_body()


func _apply_filter() -> void:
	if _search_text.strip_edges() == "":
		_filtered_data = _rows_data.duplicate()
		return
	var query := _search_text.to_lower()
	_filtered_data.clear()
	for row in _rows_data:
		for cell in row:
			if str(cell).to_lower().contains(query):
				_filtered_data.append(row)
				break


func _rebuild_body() -> void:
	while _body_v.get_child_count() > 0:
		var child := _body_v.get_child(0)
		_body_v.remove_child(child)
		child.queue_free()
	for i in _filtered_data.size():
		var row: Array = _filtered_data[i]
		_add_row_ui(row, i)

func _add_row_ui(data: Array, row_idx: int) -> void:
	var is_last := row_idx == _filtered_data.size() - 1
	var rp := PanelContainer.new()
	rp.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var rs := StyleBoxFlat.new()
	rs.bg_color = UITheme.SURFACE_3 if (striped and row_idx % 2 == 1) else UITheme.SURFACE_2
	if not is_last and show_border:
		rs.border_width_bottom = 1; rs.border_color = UITheme.BORDER
	rs.content_margin_left = 16; rs.content_margin_right  = 16
	rs.content_margin_top  = 13; rs.content_margin_bottom = 13
	rp.add_theme_stylebox_override("panel", rs)

	var hover_s := rs.duplicate()
	hover_s.bg_color = UITheme.SURFACE_4
	rp.mouse_entered.connect(func(): rp.add_theme_stylebox_override("panel", hover_s))
	rp.mouse_exited.connect(func():  rp.add_theme_stylebox_override("panel", rs))

	_body_v.add_child(rp)
	var rh := HBoxContainer.new()
	rh.add_theme_constant_override("separation", 0)
	rp.add_child(rh)

	for cell in data:
		var l := Label.new()
		l.text = str(cell)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.add_theme_font_size_override("font_size", UITheme.FONT_MD)
		l.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
		rh.add_child(l)

