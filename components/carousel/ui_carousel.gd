## UICarousel — Standalone Component
## Content slider with arrows, dot indicators, and optional auto-play.
##
## Usage:
##   var carousel := UICarousel.new()
##   carousel.add_slide(my_control)
##   carousel.slide_changed.connect(func(i): print(i))
##   parent.add_child(carousel)
##
## Dependencies: scripts/theme.gd (UITheme)
class_name UICarousel
extends VBoxContainer

signal slide_changed(index: int)

@export var show_arrows: bool = true:
	set(v): show_arrows = v; if is_inside_tree(): _update_chrome()

@export var show_indicators: bool = true:
	set(v): show_indicators = v; if is_inside_tree(): _update_indicators()

@export var auto_play: bool = false:
	set(v):
		auto_play = v
		if not _auto_timer: return
		if auto_play: _auto_timer.start(interval)
		else: _auto_timer.stop()

@export var interval: float = 4.0:
	set(v):
		interval = maxf(v, 0.5)
		if _auto_timer and auto_play: _auto_timer.wait_time = interval

@export var loop: bool = true

@export var slide_height: float = 200.0:
	set(v):
		slide_height = v
		if _slide_area: _slide_area.custom_minimum_size.y = v

# ── Private vars ──────────────────────────────────────────────
var _slides: Array[Control] = []
var _current: int = 0

var _slide_area: Control    # bare Control that holds slides
var _left_btn: Button
var _right_btn: Button
var _dots_row: HBoxContainer
var _dots: Array[Control] = []
var _auto_timer: Timer
var _animating: bool = false


func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 0)
	_build()


# ── Public API ────────────────────────────────────────────────

func add_slide(content: Control) -> void:
	_slides.append(content)
	content.visible = (_slides.size() == 1)
	if is_instance_valid(_slide_area):
		_slide_area.add_child(content)
		_fit_slide(content)
	_update_chrome()
	_update_indicators()


func go_to(index: int) -> void:
	var clamped := clampi(index, 0, maxi(_slides.size() - 1, 0))
	if clamped == _current: return
	_animate_to(clamped)


func next_slide() -> void:
	if _slides.size() <= 1: return
	var idx := _current + 1
	if idx >= _slides.size():
		if loop: idx = 0
		else: return
	_animate_to(idx)


func prev_slide() -> void:
	if _slides.size() <= 1: return
	var idx := _current - 1
	if idx < 0:
		if loop: idx = _slides.size() - 1
		else: return
	_animate_to(idx)


# ── Build ─────────────────────────────────────────────────────

func _build() -> void:
	# Row: [left_btn] [panel] [right_btn]
	var slide_row := HBoxContainer.new()
	slide_row.add_theme_constant_override("separation", 0)
	slide_row.alignment = BoxContainer.ALIGNMENT_CENTER
	add_child(slide_row)

	# Left arrow
	_left_btn = _make_arrow_btn("◂")
	_left_btn.pressed.connect(func(): prev_slide())
	slide_row.add_child(_left_btn)

	# Panel (border frame)
	var frame := PanelContainer.new()
	frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var ps := StyleBoxFlat.new()
	ps.bg_color = UITheme.SURFACE_2
	ps.set_corner_radius_all(UITheme.RADIUS_LG)
	ps.border_width_top = 1; ps.border_width_bottom = 1
	ps.border_width_left = 1; ps.border_width_right = 1
	ps.border_color = UITheme.BORDER
	ps.content_margin_left = 0; ps.content_margin_right = 0
	ps.content_margin_top = 0; ps.content_margin_bottom = 0
	frame.add_theme_stylebox_override("panel", ps)
	slide_row.add_child(frame)

	# Slide area inside frame
	_slide_area = Control.new()
	_slide_area.custom_minimum_size = Vector2(0, slide_height)
	_slide_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slide_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
	frame.add_child(_slide_area)

	# Right arrow
	_right_btn = _make_arrow_btn("▸")
	_right_btn.pressed.connect(func(): next_slide())
	slide_row.add_child(_right_btn)

	# Dot row
	var dots_m := MarginContainer.new()
	dots_m.add_theme_constant_override("margin_top", 10)
	dots_m.add_theme_constant_override("margin_bottom", 6)
	add_child(dots_m)
	_dots_row = HBoxContainer.new()
	_dots_row.add_theme_constant_override("separation", 8)
	_dots_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_dots_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dots_m.add_child(_dots_row)

	# Auto-play timer
	_auto_timer = Timer.new()
	_auto_timer.one_shot = false
	_auto_timer.timeout.connect(func(): next_slide())
	add_child(_auto_timer)
	if auto_play: _auto_timer.start(interval)

	# Add pending slides
	for slide in _slides:
		_slide_area.add_child(slide)

	_slide_area.resized.connect(func(): _fit_all_slides())
	_update_chrome()
	_update_indicators()
	_fit_all_slides.call_deferred()


func _fit_all_slides() -> void:
	var w := _slide_area.size.x
	var h := _slide_area.size.y
	if w <= 0 or h <= 0: return
	for slide in _slides:
		slide.position = Vector2.ZERO
		slide.size = Vector2(w, h)


func _fit_slide(slide: Control) -> void:
	var w := _slide_area.size.x
	var h := _slide_area.size.y
	if w > 0 and h > 0:
		slide.position = Vector2.ZERO
		slide.size = Vector2(w, h)


# ── Animation ─────────────────────────────────────────────────

func _animate_to(index: int) -> void:
	if _animating: return
	_animating = true

	var old_idx := _current
	_current = index

	var w := _slide_area.size.x
	var direction := 1 if index > old_idx else -1
	if loop and _slides.size() > 1:
		if old_idx == _slides.size() - 1 and index == 0: direction = 1
		elif old_idx == 0 and index == _slides.size() - 1: direction = -1

	var old_slide := _slides[old_idx]
	var new_slide := _slides[index]
	var offset := w * 0.15

	new_slide.position = Vector2(offset * direction, 0)
	new_slide.size = Vector2(w, _slide_area.size.y)
	new_slide.modulate.a = 0.0
	new_slide.visible = true

	var dur := 0.28
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(old_slide, "modulate:a", 0.0, dur * 0.8)
	tween.tween_property(old_slide, "position:x", -offset * direction, dur)
	tween.tween_property(new_slide, "position:x", 0.0, dur)
	tween.tween_property(new_slide, "modulate:a", 1.0, dur)

	tween.finished.connect(func():
		old_slide.visible = false
		old_slide.modulate.a = 1.0
		old_slide.position = Vector2.ZERO
		_animating = false
	)

	_update_chrome()
	_update_indicators()
	slide_changed.emit(_current)
	if auto_play: _auto_timer.start(interval)


# ── Arrows ────────────────────────────────────────────────────

func _make_arrow_btn(symbol: String) -> Button:
	var btn := Button.new()
	btn.text = symbol
	btn.flat = true
	btn.focus_mode = Control.FOCUS_NONE
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	btn.custom_minimum_size = Vector2(32, slide_height)
	btn.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var n := StyleBoxFlat.new()
	n.bg_color = Color.TRANSPARENT
	n.content_margin_left = 4; n.content_margin_right = 4

	var h_style := StyleBoxFlat.new()
	h_style.bg_color = UITheme.PRIMARY_SOFT
	h_style.content_margin_left = 4; h_style.content_margin_right = 4

	btn.add_theme_stylebox_override("normal", n)
	btn.add_theme_stylebox_override("hover", h_style)
	btn.add_theme_stylebox_override("pressed", h_style)
	btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
	btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)
	btn.add_theme_font_size_override("font_size", UITheme.FONT_LG)
	return btn


func _update_chrome() -> void:
	if not is_instance_valid(_left_btn): return
	var multi := _slides.size() > 1
	_left_btn.visible = show_arrows and multi
	_right_btn.visible = show_arrows and multi
	if not loop:
		_left_btn.disabled = _current <= 0
		_right_btn.disabled = _current >= _slides.size() - 1


# ── Dots ──────────────────────────────────────────────────────

func _update_indicators() -> void:
	if not is_instance_valid(_dots_row): return
	_dots_row.visible = show_indicators and _slides.size() > 1

	if _dots.size() != _slides.size():
		for d in _dots:
			if is_instance_valid(d): d.queue_free()
		_dots.clear()
		for i in range(_slides.size()):
			var dot := _DotControl.new()
			dot.custom_minimum_size = Vector2(10, 10)
			dot.mouse_filter = Control.MOUSE_FILTER_STOP
			dot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			var ci := i
			dot.gui_input.connect(func(event: InputEvent):
				if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					go_to(ci)
			)
			_dots_row.add_child(dot)
			_dots.append(dot)

	for i in range(_dots.size()):
		(_dots[i] as _DotControl).active = (i == _current)


class _DotControl extends Control:
	var active: bool = false:
		set(v): active = v; queue_redraw()

	func _draw() -> void:
		var r := minf(size.x, size.y) * 0.5
		draw_circle(size * 0.5, r, UITheme.PRIMARY if active else UITheme.BORDER_STRONG)
