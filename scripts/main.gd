extends Node

var current_page: String = "home"
var _current_theme_id: String = "dark_indigo"
var nav_buttons: Dictionary = {}
var content_container: VBoxContainer
var _bg: ColorRect
var _main_hbox: HBoxContainer
var _sidebar_node: PanelContainer


func _ready() -> void:
	_build_shell()
	_navigate_to("buttons")


# =============================================
# SHELL STRUCTURE
# =============================================

func _build_shell() -> void:
	var canvas := CanvasLayer.new()
	add_child(canvas)

	# Background
	_bg = ColorRect.new()
	_bg.color = UITheme.BG
	_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(_bg)

	# Root
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(root)

	# Main HBox
	_main_hbox = HBoxContainer.new()
	_main_hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_main_hbox.add_theme_constant_override("separation", 0)
	_main_hbox.clip_contents = true
	root.add_child(_main_hbox)

	_build_sidebar(_main_hbox)
	_build_content(_main_hbox)


# =============================================
# SIDEBAR
# =============================================

func _build_sidebar(parent: Control) -> void:
	_sidebar_node = PanelContainer.new()
	_sidebar_node.custom_minimum_size.x = 240
	_sidebar_node.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var sidebar_style := UI.style(UITheme.SURFACE_1, 0, 0)
	sidebar_style.border_width_right = 1
	sidebar_style.border_color = UITheme.BORDER
	_sidebar_node.add_theme_stylebox_override("panel", sidebar_style)
	parent.add_child(_sidebar_node)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 16)
	_sidebar_node.add_child(margin)

	# Outer VBox: scrollable nav area + fixed theme switcher at bottom
	var outer_vbox := VBoxContainer.new()
	outer_vbox.add_theme_constant_override("separation", 0)
	margin.add_child(outer_vbox)

	# Scrollable nav area
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	outer_vbox.add_child(scroll)
	# Hide sidebar scrollbar — scroll via mouse wheel only
	scroll.get_v_scroll_bar().modulate = Color(0, 0, 0, 0)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)

	# Logo area
	_build_logo(vbox)
	UI.spacer(vbox, 12)

	# Home
	_add_nav_button(vbox, "home", "⬡  Overview")
	UI.spacer(vbox, 4)

	# Separator
	UI.sep(vbox, 0)
	UI.spacer(vbox, 12)

	# Section label
	var section_label := UI.label("COMPONENTS", UITheme.FONT_XS, UITheme.TEXT_MUTED)
	vbox.add_child(section_label)
	UI.spacer(vbox, 4)

	# Nav section: Primitives
	var pages: Array = [
		["buttons",  "◉  Buttons"],
		["cards",    "⊞  Cards"],
		["inputs",   "⊟  Form Inputs"],
		["badges",   "◈  Badges & Tags"],
		["alerts",   "◎  Alerts"],
		["progress", "▤  Progress"],
	]
	for page_data in pages:
		_add_nav_button(vbox, page_data[0], page_data[1])

	# Section divider
	UI.spacer(vbox, 8)
	UI.sep(vbox, 0)
	UI.spacer(vbox, 8)
	var section2 := UI.label("INTERACTIVE", UITheme.FONT_XS, UITheme.TEXT_MUTED)
	vbox.add_child(section2)
	UI.spacer(vbox, 4)

	# Nav section: Interactive
	var pages2: Array = [
		["navigation", "⊡  Navigation"],
		["data",       "⊤  Data & Display"],
		["modals",     "⊞  Modals"],
		["forms",      "⊟  Form Validation"],
	]
	for page_data in pages2:
		_add_nav_button(vbox, page_data[0], page_data[1])

	# Section divider: Design
	UI.spacer(vbox, 8)
	UI.sep(vbox, 0)
	UI.spacer(vbox, 8)
	var section3 := UI.label("DESIGN", UITheme.FONT_XS, UITheme.TEXT_MUTED)
	vbox.add_child(section3)
	UI.spacer(vbox, 4)

	var pages3: Array = [
		["themes",     "◆  Themes"],
		["shapes",     "◇  Shapes"],
		["layouts",    "▦  Layouts"],
		["animations", "◎  Animations"],
	]
	for page_data in pages3:
		_add_nav_button(vbox, page_data[0], page_data[1])

	# Section divider: Extended
	UI.spacer(vbox, 8)
	UI.sep(vbox, 0)
	UI.spacer(vbox, 8)
	var section_ext := UI.label("EXTENDED", UITheme.FONT_XS, UITheme.TEXT_MUTED)
	vbox.add_child(section_ext)
	UI.spacer(vbox, 4)

	var pages_ext: Array = [
		["extended",  "◈  Extended"],
		["advanced",  "◆  Advanced"],
	]
	for page_data in pages_ext:
		_add_nav_button(vbox, page_data[0], page_data[1])

	# Section divider: Scenes
	UI.spacer(vbox, 8)
	UI.sep(vbox, 0)
	UI.spacer(vbox, 8)
	var section4 := UI.label("SCENES", UITheme.FONT_XS, UITheme.TEXT_MUTED)
	vbox.add_child(section4)
	UI.spacer(vbox, 4)

	var pages4: Array = [
		["scene_login",     "⊟  Login Form"],
		["scene_dashboard", "⊞  Dashboard"],
		["scene_settings",  "⊠  Settings"],
	]
	for page_data in pages4:
		_add_nav_button(vbox, page_data[0], page_data[1])

	# ── Theme switcher (fixed at bottom) ─────────────────────────────────────
	UI.sep(outer_vbox, 0)
	UI.spacer(outer_vbox, 8)
	outer_vbox.add_child(UI.label("THEME", UITheme.FONT_XS, UITheme.TEXT_MUTED))
	UI.spacer(outer_vbox, 6)
	_build_theme_switcher(outer_vbox)


func _build_theme_switcher(parent: Control) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	parent.add_child(row)

	var themes := [
		["dark_indigo", "Indigo"],
		["light",       "Light"],
		["midnight",    "Night"],
		["slate",       "Slate"],
		["stone",       "Stone"],
	]

	for t in themes:
		var tid: String = t[0]
		var tlabel: String = t[1]
		var btn := Button.new()
		btn.text = tlabel
		btn.flat = true
		btn.focus_mode = Control.FOCUS_NONE
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size.y = 30
		btn.add_theme_font_size_override("font_size", UITheme.FONT_XS)

		var is_active := (tid == _current_theme_id)
		_apply_theme_btn_style(btn, is_active)

		btn.pressed.connect(func(): _switch_theme(tid))
		row.add_child(btn)


func _apply_theme_btn_style(btn: Button, active: bool) -> void:
	var r := UITheme.RADIUS_SM
	if active:
		var s := StyleBoxFlat.new()
		s.bg_color = UITheme.PRIMARY_SOFT
		s.corner_radius_top_left     = r
		s.corner_radius_top_right    = r
		s.corner_radius_bottom_left  = r
		s.corner_radius_bottom_right = r
		s.border_width_top = 1; s.border_width_bottom = 1
		s.border_width_left = 1; s.border_width_right = 1
		s.border_color = UITheme.PRIMARY
		btn.add_theme_stylebox_override("normal",  s)
		btn.add_theme_stylebox_override("hover",   s)
		btn.add_theme_stylebox_override("pressed", s)
		btn.add_theme_stylebox_override("focus",   s)
		btn.add_theme_color_override("font_color", UITheme.PRIMARY_LIGHT)
		btn.add_theme_color_override("font_hover_color", UITheme.PRIMARY_LIGHT)
	else:
		var n := StyleBoxFlat.new()
		n.bg_color = Color(0, 0, 0, 0)
		n.corner_radius_top_left     = r
		n.corner_radius_top_right    = r
		n.corner_radius_bottom_left  = r
		n.corner_radius_bottom_right = r
		var h := StyleBoxFlat.new()
		h.bg_color = UITheme.SURFACE_3
		h.corner_radius_top_left     = r
		h.corner_radius_top_right    = r
		h.corner_radius_bottom_left  = r
		h.corner_radius_bottom_right = r
		btn.add_theme_stylebox_override("normal",  n)
		btn.add_theme_stylebox_override("hover",   h)
		btn.add_theme_stylebox_override("pressed", n)
		btn.add_theme_stylebox_override("focus",   n)
		btn.add_theme_color_override("font_color", UITheme.TEXT_MUTED)
		btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)


func _build_logo(parent: Control) -> void:
	var logo_v := VBoxContainer.new()
	logo_v.add_theme_constant_override("separation", 4)
	parent.add_child(logo_v)

	logo_v.add_child(UI.label("⬡  UI Components", UITheme.FONT_LG, UITheme.TEXT_PRIMARY))
	logo_v.add_child(UI.label("Design System v1.0", UITheme.FONT_XS, UITheme.TEXT_MUTED))


func _add_nav_button(parent: Control, page_id: String, text: String) -> void:
	var btn := Button.new()
	btn.text = text
	btn.flat = true
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.custom_minimum_size = Vector2(0, 38)
	btn.focus_mode = Control.FOCUS_NONE

	_apply_nav_style(btn, false)

	btn.add_theme_font_size_override("font_size", UITheme.FONT_MD)
	btn.pressed.connect(func(): _navigate_to(page_id))

	nav_buttons[page_id] = btn
	parent.add_child(btn)


func _apply_nav_style(btn: Button, active: bool) -> void:
	if active:
		var active_style := UI.style(
			UITheme.PRIMARY_SOFT, UITheme.RADIUS_MD,
			0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 0
		)
		active_style.border_width_left = 3
		active_style.border_color = UITheme.PRIMARY
		btn.add_theme_stylebox_override("normal", active_style)
		btn.add_theme_stylebox_override("hover", active_style)
		btn.add_theme_color_override("font_color", UITheme.PRIMARY_LIGHT)
		btn.add_theme_color_override("font_hover_color", UITheme.PRIMARY_LIGHT)
	else:
		var normal := UI.style(
			Color(0, 0, 0, 0), UITheme.RADIUS_MD,
			0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 0
		)
		var hover := UI.style(
			UITheme.SURFACE_3, UITheme.RADIUS_MD,
			0, Color.TRANSPARENT, 0, Color.TRANSPARENT, Vector2.ZERO, 14, 0
		)
		btn.add_theme_stylebox_override("normal", normal)
		btn.add_theme_stylebox_override("hover", hover)
		btn.add_theme_color_override("font_color", UITheme.TEXT_SECONDARY)
		btn.add_theme_color_override("font_hover_color", UITheme.TEXT_PRIMARY)


# =============================================
# CONTENT AREA
# =============================================

func _build_content(parent: Control) -> void:
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(scroll)

	# Style content scrollbar — thin, dark, rounded
	_style_scrollbar(scroll.get_v_scroll_bar())

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 40)
	margin.add_theme_constant_override("margin_right", 40)
	margin.add_theme_constant_override("margin_top", 40)
	margin.add_theme_constant_override("margin_bottom", 40)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)

	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 12)
	margin.add_child(content_container)


# =============================================
# NAVIGATION
# =============================================

func _navigate_to(page_id: String) -> void:
	# Update nav button styles
	for id in nav_buttons:
		_apply_nav_style(nav_buttons[id], id == page_id)

	# Clear content
	for child in content_container.get_children():
		child.queue_free()

	# Wait a frame for queue_free to process
	await get_tree().process_frame

	# Load page
	current_page = page_id
	match page_id:
		"home":
			HomePage.new().build(content_container)
		"buttons":
			ButtonsPage.new().build(content_container)
		"cards":
			CardsPage.new().build(content_container)
		"inputs":
			InputsPage.new().build(content_container)
		"badges":
			BadgesPage.new().build(content_container)
		"alerts":
			AlertsPage.new().build(content_container)
		"progress":
			ProgressPage.new().build(content_container)
		"navigation":
			NavigationPage.new().build(content_container)
		"data":
			DataPage.new().build(content_container)
		"modals":
			ModalsPage.new().build(content_container)
		"forms":
			FormsPage.new().build(content_container)
		"themes":
			ThemesPage.new().build(content_container)
		"shapes":
			ShapesPage.new().build(content_container)
		"layouts":
			LayoutsPage.new().build(content_container)
		"animations":
			AnimationsPage.new().build(content_container)
		"scene_login":
			LoginScenePage.new().build(content_container)
		"scene_dashboard":
			DashboardScenePage.new().build(content_container)
		"scene_settings":
			SettingsScenePage.new().build(content_container)
		"extended":
			ExtendedPage.new().build(content_container)
		"advanced":
			AdvancedPage.new().build(content_container)


# =============================================
# THEME SWITCHING
# =============================================

func _switch_theme(theme_id: String) -> void:
	if _current_theme_id == theme_id: return
	_current_theme_id = theme_id

	# Apply color values
	match theme_id:
		"dark_indigo": UIThemePresets.apply_dark_indigo()
		"light":       UIThemePresets.apply_light()
		"midnight":    UIThemePresets.apply_midnight()
		"slate":       UIThemePresets.apply_slate()
		"stone":       UIThemePresets.apply_stone()

	# Update background
	_bg.color = UITheme.BG

	# Rebuild sidebar (remove old, build new)
	nav_buttons.clear()
	_sidebar_node.queue_free()
	_sidebar_node = null
	await get_tree().process_frame
	_build_sidebar(_main_hbox)
	# Move sidebar before content (it was added after; reorder)
	_main_hbox.move_child(_sidebar_node, 0)

	# Rebuild current page
	_navigate_to(current_page)


# =============================================
# SCROLLBAR STYLING
# =============================================

func _style_scrollbar(bar: ScrollBar) -> void:
	# Grabber (the draggable thumb)
	var grabber := StyleBoxFlat.new()
	grabber.bg_color = UITheme.BORDER
	grabber.corner_radius_top_left     = 4
	grabber.corner_radius_top_right    = 4
	grabber.corner_radius_bottom_left  = 4
	grabber.corner_radius_bottom_right = 4
	grabber.content_margin_left  = 3
	grabber.content_margin_right = 3

	var grabber_hl := grabber.duplicate()
	grabber_hl.bg_color = UITheme.BORDER_LIGHT

	var grabber_pr := grabber.duplicate()
	grabber_pr.bg_color = UITheme.BORDER_STRONG

	bar.add_theme_stylebox_override("grabber",            grabber)
	bar.add_theme_stylebox_override("grabber_highlight",  grabber_hl)
	bar.add_theme_stylebox_override("grabber_pressed",    grabber_pr)

	# Track (background behind grabber)
	var track := StyleBoxFlat.new()
	track.bg_color = Color(0, 0, 0, 0)
	track.content_margin_left  = 3
	track.content_margin_right = 3
	bar.add_theme_stylebox_override("scroll", track)

	# Make bar narrower
	bar.custom_minimum_size.x = 8
