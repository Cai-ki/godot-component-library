extends Node

var current_page: String = "buttons"
var nav_buttons: Dictionary = {}
var content_container: VBoxContainer


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
	var bg := ColorRect.new()
	bg.color = UITheme.BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(bg)

	# Root
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(root)

	# Main HBox
	var main_hbox := HBoxContainer.new()
	main_hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_hbox.add_theme_constant_override("separation", 0)
	root.add_child(main_hbox)

	_build_sidebar(main_hbox)
	_build_content(main_hbox)


# =============================================
# SIDEBAR
# =============================================

func _build_sidebar(parent: Control) -> void:
	var sidebar := PanelContainer.new()
	sidebar.custom_minimum_size.x = 240
	sidebar.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var sidebar_style := UI.style(UITheme.SURFACE_1, 0, 0)
	sidebar_style.border_width_right = 1
	sidebar_style.border_color = UITheme.BORDER
	sidebar.add_theme_stylebox_override("panel", sidebar_style)
	parent.add_child(sidebar)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	sidebar.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	margin.add_child(vbox)

	# Logo area
	_build_logo(vbox)
	UI.spacer(vbox, 16)

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
