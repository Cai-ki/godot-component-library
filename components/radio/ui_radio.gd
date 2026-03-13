## UIRadio — Standalone Component
## Custom-styled radio button with optional label.
##
## Usage:
##   var radio := UIRadio.new()
##   radio.label_text = "Option A"
##   radio.toggled.connect(func(v): print(v))
##   parent.add_child(radio)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UIRadio
extends HBoxContainer

signal toggled(value: bool)

@export var checked: bool = false:
	set(v): checked = v; if is_inside_tree(): _refresh()

@export var label_text: String = "":
	set(v):
		label_text = v
		if _text_lbl: _text_lbl.text = v; _text_lbl.visible = v != ""

@export var disabled: bool = false:
	set(v): disabled = v; if is_inside_tree(): _refresh()

@export var accent_color: Color = Color("6C63FF"):   # UITheme.PRIMARY
	set(v): accent_color = v; if is_inside_tree(): _refresh()

const BOX_SIZE := 20.0
const INNER_R  := 5.0   # inner dot radius when checked

var _box:      Control
var _text_lbl: Label
var _hover:    bool = false


func _ready() -> void:
	add_theme_constant_override("separation", 10)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build()


# ── Build ─────────────────────────────────────────────────────────────────────

func _build() -> void:
	# Radio circle (custom drawn)
	_box = Control.new()
	_box.custom_minimum_size = Vector2(BOX_SIZE, BOX_SIZE)
	_box.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_box.draw.connect(_draw_box)
	add_child(_box)

	# Label
	_text_lbl = Label.new()
	_text_lbl.text = label_text
	_text_lbl.visible = label_text != ""
	_text_lbl.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	_text_lbl.add_theme_color_override("font_color", UITheme.TEXT_PRIMARY)
	_text_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_text_lbl.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	add_child(_text_lbl)

	gui_input.connect(_on_input)
	mouse_entered.connect(func(): _hover = true;  _box.queue_redraw())
	mouse_exited.connect(func():  _hover = false; _box.queue_redraw())


func _on_input(event: InputEvent) -> void:
	if disabled: return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			if not checked:
				checked = true
				toggled.emit(true)


func _refresh() -> void:
	if _box: _box.queue_redraw()
	if _text_lbl:
		_text_lbl.add_theme_color_override("font_color",
			UITheme.TEXT_MUTED if disabled else UITheme.TEXT_PRIMARY)


# ── Draw ──────────────────────────────────────────────────────────────────────

func _draw_box() -> void:
	var sz  := _box.size
	var cx  := sz.x * 0.5
	var cy  := sz.y * 0.5
	var r   := sz.x * 0.5

	# Outer ring
	var ring_c: Color
	if checked:
		ring_c = accent_color
		if _hover and not disabled: ring_c = ring_c.lightened(0.15)
		if disabled: ring_c = UITheme.SURFACE_4
	else:
		if disabled:
			ring_c = UITheme.SURFACE_3
		elif _hover:
			ring_c = UITheme.BORDER_LIGHT
		else:
			ring_c = UITheme.BORDER

	_box.draw_arc(Vector2(cx, cy), r - 1.5, 0.0, TAU, 32, ring_c, 2.0, true)

	# Inner dot (checked)
	if checked:
		var dot_c := Color.WHITE if not disabled else UITheme.TEXT_MUTED
		_box.draw_circle(Vector2(cx, cy), INNER_R, dot_c)
