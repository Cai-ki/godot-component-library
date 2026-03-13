## UISlider — Standalone Component
## Custom-drawn horizontal range slider.
##
## Usage:
##   var sl := UISlider.new()
##   sl.value = 50.0
##   sl.value_changed.connect(func(v): print(v))
##   parent.add_child(sl)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UISlider
extends Control

signal value_changed(v: float)

@export var value: float = 0.0:
	set(v):
		var new_v := _snap(clampf(v, min_value, max_value))
		if value == new_v: return
		value = new_v
		queue_redraw()

@export var min_value: float = 0.0:
	set(v): min_value = v; queue_redraw()

@export var max_value: float = 100.0:
	set(v): max_value = v; queue_redraw()

@export var step: float = 1.0

@export var accent_color: Color = Color("6C63FF"):   # UITheme.PRIMARY
	set(v): accent_color = v; queue_redraw()

@export var disabled: bool = false:
	set(v): disabled = v; queue_redraw()

@export var show_value: bool = false:
	set(v): show_value = v; queue_redraw()

const TRACK_H  := 6.0
const KNOB_R   := 9.0
const PAD_X    := KNOB_R          # horizontal padding so knob doesn't clip
const LABEL_W  := 38.0

var _dragging: bool = false
var _hover_knob: bool = false


func _ready() -> void:
	custom_minimum_size = Vector2(120, 28)
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_entered.connect(func(): queue_redraw())
	mouse_exited.connect(func(): _hover_knob = false; queue_redraw())


# ── Input ─────────────────────────────────────────────────────────────────────

func _gui_input(event: InputEvent) -> void:
	if disabled: return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				_dragging = true
				_set_value_from_x(mb.position.x)
			else:
				_dragging = false
	elif event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		# Hover knob detection
		var knob_x := _value_to_x(value)
		_hover_knob = abs(mm.position.x - knob_x) <= KNOB_R + 4
		queue_redraw()
		if _dragging:
			_set_value_from_x(mm.position.x)


func _set_value_from_x(x: float) -> void:
	var track_w := size.x - PAD_X * 2.0
	var ratio := clampf((x - PAD_X) / track_w, 0.0, 1.0)
	var new_val := _snap(min_value + ratio * (max_value - min_value))
	if new_val != value:
		value = new_val
		value_changed.emit(value)


func _snap(v: float) -> float:
	if step <= 0.0: return v
	return roundf(v / step) * step


func _value_to_x(v: float) -> float:
	var track_w := size.x - PAD_X * 2.0
	var ratio := (v - min_value) / (max_value - min_value) if max_value != min_value else 0.0
	return PAD_X + ratio * track_w


# ── Draw ──────────────────────────────────────────────────────────────────────

func _draw() -> void:
	var h := size.y
	var cy := h * 0.5
	var track_start := Vector2(PAD_X, cy - TRACK_H * 0.5)
	var track_end   := Vector2(size.x - PAD_X, cy + TRACK_H * 0.5)
	var track_rect  := Rect2(track_start, track_end - track_start)
	var knob_x      := _value_to_x(value)

	# Track background
	var ts := StyleBoxFlat.new()
	ts.bg_color = UITheme.SURFACE_3
	var r := int(TRACK_H * 0.5)
	ts.corner_radius_top_left     = r
	ts.corner_radius_top_right    = r
	ts.corner_radius_bottom_left  = r
	ts.corner_radius_bottom_right = r
	draw_style_box(ts, track_rect)

	# Filled portion
	var fill_w := knob_x - PAD_X
	if fill_w > 0:
		var fill_rect := Rect2(track_start, Vector2(fill_w, TRACK_H))
		var fs := ts.duplicate()
		fs.bg_color = accent_color if not disabled else UITheme.SURFACE_4
		fs.corner_radius_top_right    = 0
		fs.corner_radius_bottom_right = 0
		draw_style_box(fs, fill_rect)

	# Knob
	var knob_c: Color
	if disabled:
		knob_c = UITheme.SURFACE_4
	elif _hover_knob or _dragging:
		knob_c = accent_color.lightened(0.15) if not disabled else UITheme.SURFACE_4
	else:
		knob_c = Color.WHITE
	draw_circle(Vector2(knob_x, cy), KNOB_R, knob_c)
	# Knob border ring
	var ring_c := accent_color if not disabled else UITheme.BORDER
	draw_arc(Vector2(knob_x, cy), KNOB_R, 0.0, TAU, 32, ring_c, 1.5, true)

	# Value label
	if show_value:
		var font := ThemeDB.fallback_font
		var fs2 := UITheme.FONT_SM
		var txt := str(int(value))
		var tsz := font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2)
		var lx := minf(knob_x - tsz.x * 0.5, size.x - tsz.x - 2)
		lx = maxf(lx, 2.0)
		draw_string(font, Vector2(lx, cy - KNOB_R - 4), txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs2,
			UITheme.TEXT_SECONDARY)
