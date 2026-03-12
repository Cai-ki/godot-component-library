## UITable — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UITable
extends VBoxContainer

@export var striped:     bool = true
@export var show_border: bool = true

var _columns:   PackedStringArray = []
var _rows_data: Array = []
var _header_h:  HBoxContainer
var _body_v:    VBoxContainer

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
	_add_row_ui(data, _rows_data.size() - 1)

func clear_rows() -> void:
	_rows_data.clear()
	for c in _body_v.get_children():
		c.queue_free()

func set_data(cols: PackedStringArray, rows: Array) -> void:
	set_columns(cols)
	for row in rows:
		add_row(row)

# ── Internal ──────────────────────────────────────
func _build() -> void:
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
	for col in _columns:
		var l := Label.new()
		l.text = col
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.add_theme_font_size_override("font_size", UITheme.FONT_SM)
		l.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		_header_h.add_child(l)

func _add_row_ui(data: Array, row_idx: int) -> void:
	var is_last := row_idx == _rows_data.size() - 1
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
