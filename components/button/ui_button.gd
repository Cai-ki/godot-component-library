## UIButton — Standalone Component
## Dependencies: scripts/theme.gd (UITheme)
## Copy: components/button/ui_button.gd + scripts/theme.gd
class_name UIButton
extends Button

enum Variant { SOLID, OUTLINE, SOFT, GHOST }
enum ColorScheme { PRIMARY, SECONDARY, SUCCESS, WARNING, DANGER, INFO, NEUTRAL }
enum Size { XS, SM, MD, LG, XL }

@export var variant: Variant = Variant.SOLID:
	set(v): variant = v; if is_inside_tree(): _apply_styles()

@export var color_scheme: ColorScheme = ColorScheme.PRIMARY:
	set(v): color_scheme = v; if is_inside_tree(): _apply_styles()

@export var size: Size = Size.MD:
	set(v): size = v; if is_inside_tree(): _apply_styles()

@export var pill_shape: bool = false:
	set(v): pill_shape = v; if is_inside_tree(): _apply_styles()

@export var is_loading: bool = false:
	set(v): is_loading = v; if is_inside_tree(): _apply_loading()

var _saved_text: String = ""

func _ready() -> void:
	focus_mode = Control.FOCUS_NONE
	_apply_styles()

# ── Public API ────────────────────────────────────
func set_loading(v: bool) -> void:
	is_loading = v

# ── Internal ──────────────────────────────────────
func _get_color() -> Color:
	match color_scheme:
		ColorScheme.SECONDARY: return UITheme.SECONDARY
		ColorScheme.SUCCESS:   return UITheme.SUCCESS
		ColorScheme.WARNING:   return UITheme.WARNING
		ColorScheme.DANGER:    return UITheme.DANGER
		ColorScheme.INFO:      return UITheme.INFO
		ColorScheme.NEUTRAL:   return UITheme.SURFACE_4
		_: return UITheme.PRIMARY

func _size_params() -> Array:  # [px, py, font_size]
	match size:
		Size.XS: return [12, 4,  UITheme.FONT_XS]
		Size.SM: return [14, 6,  UITheme.FONT_SM]
		Size.LG: return [24, 12, UITheme.FONT_BASE]
		Size.XL: return [32, 16, UITheme.FONT_LG]
		_:       return [20, 10, UITheme.FONT_MD]

func _radius() -> int:
	return UITheme.RADIUS_PILL if pill_shape else UITheme.RADIUS_MD

func _make_s(bg: Color, bw: int = 0, bc: Color = Color.TRANSPARENT,
		shadow: int = 0) -> StyleBoxFlat:
	var p := _size_params()
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	var r := _radius()
	s.corner_radius_top_left    = r
	s.corner_radius_top_right   = r
	s.corner_radius_bottom_left = r
	s.corner_radius_bottom_right = r
	s.content_margin_left   = p[0]
	s.content_margin_right  = p[0]
	s.content_margin_top    = p[1]
	s.content_margin_bottom = p[1]
	if bw > 0:
		s.border_width_top = bw; s.border_width_bottom = bw
		s.border_width_left = bw; s.border_width_right = bw
		s.border_color = bc
	if shadow > 0:
		s.shadow_size = shadow
		s.shadow_color = Color(0, 0, 0, 0.22)
		s.shadow_offset = Vector2(0, shadow * 0.4)
	return s

func _apply_styles() -> void:
	var c := _get_color()
	var p := _size_params()
	add_theme_font_size_override("font_size", p[2])

	var n: StyleBoxFlat; var h: StyleBoxFlat; var pr: StyleBoxFlat
	var fc: Color; var hc: Color

	match variant:
		Variant.SOLID:
			n  = _make_s(c, 0, Color.TRANSPARENT, 4)
			h  = _make_s(c.lightened(0.15), 0, Color.TRANSPARENT, 8)
			pr = _make_s(c.darkened(0.15))
			fc = Color.WHITE if color_scheme != ColorScheme.NEUTRAL else UITheme.TEXT_PRIMARY
			hc = fc
		Variant.OUTLINE:
			n  = _make_s(Color(c.r,c.g,c.b,0.0), 1, c)
			h  = _make_s(Color(c.r,c.g,c.b,0.12), 1, c.lightened(0.2))
			pr = _make_s(Color(c.r,c.g,c.b,0.2), 1, c)
			fc = c; hc = c.lightened(0.15)
		Variant.SOFT:
			n  = _make_s(Color(c.r,c.g,c.b,0.12))
			h  = _make_s(Color(c.r,c.g,c.b,0.2))
			pr = _make_s(Color(c.r,c.g,c.b,0.28))
			fc = c; hc = c.lightened(0.1)
		Variant.GHOST:
			n  = _make_s(Color(0,0,0,0))
			h  = _make_s(Color(c.r,c.g,c.b,0.08))
			pr = _make_s(Color(c.r,c.g,c.b,0.15))
			fc = c; hc = c.lightened(0.15)
		_:
			n  = _make_s(c); h = n.duplicate(); pr = n.duplicate()
			fc = Color.WHITE; hc = Color.WHITE

	var dis := _make_s(UITheme.SURFACE_3)
	add_theme_stylebox_override("normal",   n)
	add_theme_stylebox_override("hover",    h)
	add_theme_stylebox_override("pressed",  pr)
	add_theme_stylebox_override("focus",    n)
	add_theme_stylebox_override("disabled", dis)
	add_theme_color_override("font_color",          fc)
	add_theme_color_override("font_hover_color",    hc)
	add_theme_color_override("font_pressed_color",  fc)
	add_theme_color_override("font_disabled_color", UITheme.TEXT_MUTED)

func _apply_loading() -> void:
	if is_loading:
		_saved_text = text
		text = "⟳  " + text
		disabled = true
	else:
		if _saved_text != "":
			text = _saved_text
			_saved_text = ""
		disabled = false
