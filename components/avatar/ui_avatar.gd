## UIAvatar — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIAvatar
extends Control

enum AvatarSize   { XS, SM, MD, LG, XL }
enum StatusType   { NONE, ONLINE, AWAY, BUSY, OFFLINE }

@export var initials: String = "?":
	set(v): initials = v.left(2).to_upper(); queue_redraw()

@export var bg_color: Color = UITheme.PRIMARY:
	set(v): bg_color = v; queue_redraw()

@export var avatar_size: AvatarSize = AvatarSize.MD:
	set(v): avatar_size = v; _update_min_size(); queue_redraw()

@export var status: StatusType = StatusType.NONE:
	set(v): status = v; queue_redraw()

func _ready() -> void:
	_update_min_size()

func _update_min_size() -> void:
	var s := _px()
	custom_minimum_size = Vector2(s, s)

func _px() -> int:
	match avatar_size:
		AvatarSize.XS: return 28
		AvatarSize.SM: return 36
		AvatarSize.LG: return 52
		AvatarSize.XL: return 64
		_: return 44

func _draw() -> void:
	var s     := float(_px())
	var center := Vector2(s * 0.5, s * 0.5)
	var radius := s * 0.5

	# Avatar circle
	draw_circle(center, radius, bg_color)

	# Initials
	var font      := ThemeDB.fallback_font
	var font_size := int(s * 0.35)
	var tsz       := font.get_string_size(initials, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var tpos      := center + Vector2(-tsz.x * 0.5, tsz.y * 0.3)
	draw_string(font, tpos, initials, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)

	# Status dot
	if status != StatusType.NONE:
		var dot_r := s * 0.13
		var dot_pos := center + Vector2(radius * 0.68, radius * 0.68)
		var dot_c: Color
		match status:
			StatusType.ONLINE:  dot_c = UITheme.SUCCESS
			StatusType.AWAY:    dot_c = UITheme.WARNING
			StatusType.BUSY:    dot_c = UITheme.DANGER
			_:                  dot_c = UITheme.TEXT_MUTED
		draw_circle(dot_pos, dot_r + 2.0, UITheme.SURFACE_1)
		draw_circle(dot_pos, dot_r, dot_c)
