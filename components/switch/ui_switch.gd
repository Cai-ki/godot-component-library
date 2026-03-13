## UISwitch — Standalone Component
## Modern toggle switch with sliding knob animation.
##
## Usage:
##   var sw := UISwitch.new()
##   sw.toggled_on = true
##   sw.toggled.connect(func(v): print("on" if v else "off"))
##   parent.add_child(sw)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UISwitch
extends Control

signal toggled(value: bool)

@export var toggled_on: bool = false:
	set(v):
		toggled_on = v
		if is_inside_tree(): _animate()

@export var disabled: bool = false:
	set(v): disabled = v; queue_redraw()

@export var accent_color: Color = Color("6C63FF"):   # UITheme.PRIMARY
	set(v): accent_color = v; queue_redraw()

const TRACK_W   := 44.0
const TRACK_H   := 24.0
const KNOB_R    := 8.0
const KNOB_PAD  := 4.0

var _knob_t: float = 0.0   # 0 = off, 1 = on
var _hover:  bool  = false
var _tw:     Tween


func _ready() -> void:
	custom_minimum_size = Vector2(TRACK_W, TRACK_H)
	_knob_t = 1.0 if toggled_on else 0.0
	mouse_filter = MOUSE_FILTER_STOP
	mouse_entered.connect(func(): _hover = true;  queue_redraw())
	mouse_exited.connect(func():  _hover = false; queue_redraw())


func _gui_input(event: InputEvent) -> void:
	if disabled: return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and mb.pressed:
			toggled_on = !toggled_on
			toggled.emit(toggled_on)


# ── Animation ─────────────────────────────────────────────────────────────────

func _animate() -> void:
	if _tw and _tw.is_valid(): _tw.kill()
	_tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tw.tween_method(_set_knob_t, _knob_t, 1.0 if toggled_on else 0.0, 0.2)

func _set_knob_t(v: float) -> void:
	_knob_t = v
	queue_redraw()


# ── Draw ──────────────────────────────────────────────────────────────────────

func _draw() -> void:
	# Track color
	var track_c: Color
	if disabled:
		track_c = UITheme.SURFACE_3
	elif toggled_on:
		track_c = accent_color.lightened(0.1) if _hover else accent_color
	else:
		track_c = UITheme.SURFACE_4 if _hover else UITheme.SURFACE_3

	# Track (pill shape)
	var ts := StyleBoxFlat.new()
	ts.bg_color = track_c
	var r := int(TRACK_H / 2.0)
	ts.corner_radius_top_left     = r
	ts.corner_radius_top_right    = r
	ts.corner_radius_bottom_left  = r
	ts.corner_radius_bottom_right = r
	if not toggled_on and not disabled:
		ts.border_width_top    = 1; ts.border_width_bottom = 1
		ts.border_width_left   = 1; ts.border_width_right  = 1
		ts.border_color = UITheme.BORDER
	draw_style_box(ts, Rect2(Vector2.ZERO, Vector2(TRACK_W, TRACK_H)))

	# Knob (circle)
	var left_x  := KNOB_PAD + KNOB_R
	var right_x := TRACK_W - KNOB_PAD - KNOB_R
	var knob_x  := lerpf(left_x, right_x, _knob_t)
	var knob_y  := TRACK_H / 2.0
	var knob_c  := Color.WHITE if not disabled else UITheme.TEXT_MUTED
	draw_circle(Vector2(knob_x, knob_y), KNOB_R, knob_c)
