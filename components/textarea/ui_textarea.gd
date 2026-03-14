## UITextArea — Standalone Component
## Multi-line text input with label, placeholder, character counter, and validation.
##
## Usage:
##   var ta := UITextArea.new()
##   ta.label_text = "Description"
##   ta.placeholder = "Enter description..."
##   ta.max_length = 500
##   ta.show_counter = true
##   ta.text_changed.connect(func(t): print(t))
##   parent.add_child(ta)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UITextArea
extends VBoxContainer

signal text_changed(new_text: String)

enum State { DEFAULT, SUCCESS, ERROR, WARNING }

@export var label_text: String = "":
	set(v):
		label_text = v
		if _lbl: _lbl.text = v; _lbl.visible = v != ""

@export var placeholder: String = "":
	set(v):
		placeholder = v
		if _edit: _edit.placeholder_text = v

@export var hint_text: String = "":
	set(v):
		hint_text = v
		if _hint: _hint.text = v; _hint.visible = v != ""
		_update_footer_visibility()

@export var max_length: int = 0:
	set(v):
		max_length = v
		_update_counter()
		_update_footer_visibility()

@export var show_counter: bool = false:
	set(v):
		show_counter = v
		_update_counter()
		_update_footer_visibility()

@export var min_lines: int = 4:
	set(v):
		min_lines = v
		if _edit: _edit.custom_minimum_size.y = _calc_height()

@export var readonly: bool = false:
	set(v):
		readonly = v
		if _edit: _edit.editable = !v
		if is_inside_tree(): _refresh_state()

@export var disabled: bool = false:
	set(v):
		disabled = v
		if _edit: _edit.editable = !v
		if is_inside_tree(): _refresh_state()

@export var validation_state: State = State.DEFAULT:
	set(v):
		validation_state = v
		if is_inside_tree(): _refresh_state()

@export var resize_vertical: bool = false

# ── Private vars ──────────────────────────────────────────────
var _lbl: Label
var _edit: TextEdit
var _footer: HBoxContainer
var _hint: Label
var _counter: Label

var text: String:
	get: return _edit.text if _edit else ""
	set(v):
		if _edit: _edit.text = v; _update_counter()


func _ready() -> void:
	add_theme_constant_override("separation", 6)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()


# ── Public API ────────────────────────────────────────────────
func clear() -> void:
	if _edit: _edit.text = ""
	_update_counter()

func grab_focus_input() -> void:
	if _edit: _edit.grab_focus()


# ── Internal ──────────────────────────────────────────────────
func _build() -> void:
	# Label
	_lbl = Label.new()
	_lbl.text = label_text
	_lbl.visible = label_text != ""
	_lbl.add_theme_font_size_override("font_size", UITheme.FONT_SM)
	_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_lbl)

	# TextEdit
	_edit = TextEdit.new()
	_edit.placeholder_text = placeholder
	_edit.editable = !(disabled or readonly)
	_edit.custom_minimum_size = Vector2(0, _calc_height())
	_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	_edit.scroll_fit_content_height = resize_vertical
	_edit.text_changed.connect(_on_text_changed)
	_edit.focus_entered.connect(func(): _apply_border(true))
	_edit.focus_exited.connect(func(): _apply_border(false))
	add_child(_edit)

	# Footer row: hint (left) + counter (right)
	_footer = HBoxContainer.new()
	_footer.add_theme_constant_override("separation", 8)
	_footer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_footer)

	_hint = Label.new()
	_hint.text = hint_text
	_hint.visible = hint_text != ""
	_hint.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_hint.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_footer.add_child(_hint)

	_counter = Label.new()
	_counter.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_counter.add_theme_font_size_override("font_size", UITheme.FONT_XS)
	_counter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_footer.add_child(_counter)

	_update_counter()
	_update_footer_visibility()
	_refresh_state()


func _calc_height() -> float:
	# Approximate: font size + line spacing * lines + padding
	var line_h := UITheme.FONT_MD + 6
	return line_h * min_lines + 20


func _on_text_changed() -> void:
	if max_length > 0 and _edit.text.length() > max_length:
		var caret_line := _edit.get_caret_line()
		var caret_col := _edit.get_caret_column()
		_edit.text = _edit.text.left(max_length)
		_edit.set_caret_line(caret_line)
		_edit.set_caret_column(mini(caret_col, _edit.get_line(caret_line).length()))
	_update_counter()
	text_changed.emit(_edit.text)


func _update_counter() -> void:
	if not _counter: return
	if show_counter and max_length > 0:
		_counter.text = "%d / %d" % [_edit.text.length() if _edit else 0, max_length]
		_counter.visible = true
	elif show_counter:
		_counter.text = str(_edit.text.length() if _edit else 0)
		_counter.visible = true
	else:
		_counter.visible = false


func _update_footer_visibility() -> void:
	if not _footer: return
	var hint_vis := hint_text != ""
	var counter_vis := show_counter
	_footer.visible = hint_vis or counter_vis


func _apply_border(focused: bool) -> void:
	if not _edit: return
	var border_c: Color
	var bw: int
	match validation_state:
		State.SUCCESS: border_c = UITheme.SUCCESS; bw = 2
		State.ERROR:   border_c = UITheme.DANGER;  bw = 2
		State.WARNING: border_c = UITheme.WARNING; bw = 2
		_:
			if focused:
				border_c = UITheme.PRIMARY; bw = 2
			else:
				border_c = UITheme.BORDER; bw = 1

	var bg := UITheme.SURFACE_3 if (disabled or readonly) else UITheme.SURFACE_2
	var s := _edit_style(bg, bw, border_c)
	_edit.add_theme_stylebox_override("normal", s)
	_edit.add_theme_stylebox_override("focus", s)
	_edit.add_theme_stylebox_override("read_only", _edit_style(UITheme.SURFACE_3, 1, UITheme.BORDER))


func _refresh_state() -> void:
	if not _edit: return

	_apply_border(false)

	var txt_c := UITheme.TEXT_MUTED if (disabled or readonly) else UITheme.TEXT_PRIMARY
	_edit.add_theme_color_override("font_color", txt_c)
	_edit.add_theme_color_override("font_placeholder_color", UITheme.TEXT_MUTED)
	_edit.add_theme_color_override("caret_color", UITheme.PRIMARY)
	_edit.add_theme_color_override("selection_color", UITheme.PRIMARY_SOFT)
	_edit.add_theme_font_size_override("font_size", UITheme.FONT_MD)

	# Hint color follows validation state
	var hint_c: Color
	match validation_state:
		State.SUCCESS: hint_c = UITheme.SUCCESS
		State.ERROR:   hint_c = UITheme.DANGER
		State.WARNING: hint_c = UITheme.WARNING
		_:             hint_c = UITheme.TEXT_MUTED
	_hint.add_theme_color_override("font_color", hint_c)
	_counter.add_theme_color_override("font_color", UITheme.TEXT_MUTED)


func _edit_style(bg: Color, bw: int, bc: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(UITheme.RADIUS_MD)
	s.border_width_top = bw; s.border_width_bottom = bw
	s.border_width_left = bw; s.border_width_right = bw
	s.border_color = bc
	s.content_margin_left = 12; s.content_margin_right = 12
	s.content_margin_top = 10; s.content_margin_bottom = 10
	return s
