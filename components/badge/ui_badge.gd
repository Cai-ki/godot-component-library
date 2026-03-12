## UIBadge — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
class_name UIBadge
extends PanelContainer

enum Variant     { FILLED, OUTLINE, SOFT }
enum ColorScheme { PRIMARY, SECONDARY, SUCCESS, WARNING, DANGER, INFO, NEUTRAL }

@export var badge_text: String = "Badge":
	set(v): badge_text = v; if _lbl: _lbl.text = v

@export var variant: Variant = Variant.FILLED:
	set(v): variant = v; if is_inside_tree(): _refresh()

@export var color_scheme: ColorScheme = ColorScheme.PRIMARY:
	set(v): color_scheme = v; if is_inside_tree(): _refresh()

@export var pill_shape: bool = false:
	set(v): pill_shape = v; if is_inside_tree(): _refresh()

@export var font_size: int = UITheme.FONT_SM:
	set(v): font_size = v; if _lbl: _lbl.add_theme_font_size_override("font_size", v)

var _lbl: Label

func _ready() -> void:
	_lbl = Label.new()
	_lbl.text = badge_text
	_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lbl.add_theme_font_size_override("font_size", font_size)
	add_child(_lbl)
	_refresh()

func _get_color() -> Color:
	match color_scheme:
		ColorScheme.SECONDARY: return UITheme.SECONDARY
		ColorScheme.SUCCESS:   return UITheme.SUCCESS
		ColorScheme.WARNING:   return UITheme.WARNING
		ColorScheme.DANGER:    return UITheme.DANGER
		ColorScheme.INFO:      return UITheme.INFO
		ColorScheme.NEUTRAL:   return UITheme.BORDER_STRONG
		_: return UITheme.PRIMARY

func _refresh() -> void:
	var c := _get_color()
	var r := UITheme.RADIUS_PILL if pill_shape else UITheme.RADIUS_XS
	var s := StyleBoxFlat.new()
	s.corner_radius_top_left     = r; s.corner_radius_top_right    = r
	s.corner_radius_bottom_left  = r; s.corner_radius_bottom_right = r
	s.content_margin_left = 10; s.content_margin_right  = 10
	s.content_margin_top  = 4;  s.content_margin_bottom = 4

	match variant:
		Variant.FILLED:
			s.bg_color = c
			_lbl.add_theme_color_override("font_color", Color.WHITE)
		Variant.OUTLINE:
			s.bg_color = Color(0, 0, 0, 0)
			s.border_width_top = 1; s.border_width_bottom = 1
			s.border_width_left = 1; s.border_width_right = 1
			s.border_color = c
			_lbl.add_theme_color_override("font_color", c)
		Variant.SOFT:
			s.bg_color = Color(c.r, c.g, c.b, 0.12)
			_lbl.add_theme_color_override("font_color", c)

	add_theme_stylebox_override("panel", s)
