## UIModal — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
## Usage: Add as child of a CanvasLayer or call show_modal() to auto-reparent to root.
class_name UIModal
extends Control

signal closed
@warning_ignore("unused_signal")
signal confirmed

@export var title_text: String = "Modal":
	set(v): title_text = v; if _title_lbl: _title_lbl.text = v

@export var show_close_button: bool = true:
	set(v): show_close_button = v; if _close_btn: _close_btn.visible = v

@export var dialog_width: float = 480.0

var _title_lbl: Label
var _close_btn: Button
var _body:      VBoxContainer
var _footer:    HBoxContainer
var _orig_parent: Node
var _is_shown: bool = false  # BUG-5 FIX: guard against duplicate hide calls

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_process_unhandled_input(true)
	visible = false
	_build()

# ── Public API ────────────────────────────────────
func show_modal() -> void:
	if _is_shown: return  # BUG-5 FIX: idempotent guard
	_is_shown = true
	var tree := get_tree()
	_orig_parent = get_parent()
	if _orig_parent:
		_orig_parent.remove_child(self)
	tree.root.add_child(self)
	visible = true

func hide_modal() -> void:
	if not _is_shown: return  # BUG-5 FIX: prevents duplicate closed signal
	_is_shown = false
	visible = false
	var tree := get_tree()
	if _orig_parent and tree and get_parent() != _orig_parent:
		tree.root.remove_child(self)
		_orig_parent.add_child(self)
	closed.emit()

func get_body()   -> VBoxContainer:  return _body
func get_footer() -> HBoxContainer: return _footer

# ── Internal ──────────────────────────────────────
func _build() -> void:
	# Backdrop with Glassmorphism
	var backdrop = UI.glass_backdrop(self, 2.0, Color(0, 0, 0, 0.45))
	backdrop.gui_input.connect(func(e):
		if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
			hide_modal()
	)

	# Center
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(center)

	var dialog := PanelContainer.new()
	dialog.custom_minimum_size.x = dialog_width
	dialog.mouse_filter = Control.MOUSE_FILTER_STOP
	var ds := StyleBoxFlat.new()
	ds.bg_color = UITheme.SURFACE_2
	ds.corner_radius_top_left     = UITheme.RADIUS_XL; ds.corner_radius_top_right    = UITheme.RADIUS_XL
	ds.corner_radius_bottom_left  = UITheme.RADIUS_XL; ds.corner_radius_bottom_right = UITheme.RADIUS_XL
	ds.border_width_top = 1; ds.border_width_bottom = 1
	ds.border_width_left = 1; ds.border_width_right = 1
	ds.border_color = UITheme.BORDER_LIGHT
	ds.shadow_size = 32; ds.shadow_color = Color(0,0,0,0.45); ds.shadow_offset = Vector2(0, 8)
	dialog.add_theme_stylebox_override("panel", ds)
	center.add_child(dialog)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 0)
	dialog.add_child(col)

	_build_header(col)
	_hsep(col)
	_build_body(col)
	_hsep(col)
	_build_footer(col)

func _hsep(parent: Control) -> void:
	var r := ColorRect.new()
	r.color = UITheme.BORDER
	r.custom_minimum_size.y = 1
	parent.add_child(r)

func _build_header(col: Control) -> void:
	var m := _margin(col, 24, 16, 20, 16)
	var row := HBoxContainer.new()
	m.add_child(row)
	_title_lbl = Label.new()
	_title_lbl.text = title_text
	_title_lbl.add_theme_font_size_override("font_size", UITheme.FONT_LG)
	_title_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_title_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(_title_lbl)
	_close_btn = Button.new()
	_close_btn.text = "✕"; _close_btn.flat = true; _close_btn.focus_mode = Control.FOCUS_NONE
	_close_btn.visible = show_close_button
	_close_btn.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
	_close_btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	_close_btn.pressed.connect(hide_modal)
	row.add_child(_close_btn)

func _build_body(col: Control) -> void:
	var m := _margin(col, 24, 24, 20, 20)
	_body = VBoxContainer.new()
	_body.add_theme_constant_override("separation", 12)
	m.add_child(_body)

func _build_footer(col: Control) -> void:
	var m := _margin(col, 24, 24, 16, 16)
	_footer = HBoxContainer.new()
	_footer.add_theme_constant_override("separation", 8)
	_footer.alignment = BoxContainer.ALIGNMENT_END
	m.add_child(_footer)

func _margin(parent: Control, l: int, r: int, t: int, b: int) -> MarginContainer:
	var m := MarginContainer.new()
	m.add_theme_constant_override("margin_left", l); m.add_theme_constant_override("margin_right", r)
	m.add_theme_constant_override("margin_top",  t); m.add_theme_constant_override("margin_bottom", b)
	parent.add_child(m)
	return m


func _unhandled_input(event: InputEvent) -> void:
	if not _is_shown: return
	if not (event is InputEventKey): return
	var ke := event as InputEventKey
	if not ke.pressed or ke.echo: return
	if ke.keycode == KEY_ESCAPE:
		hide_modal()
		get_viewport().set_input_as_handled()
