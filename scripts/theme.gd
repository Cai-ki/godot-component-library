class_name UITheme
extends RefCounted

# =============================================
# BACKGROUND HIERARCHY
# =============================================
static var BG := Color("#0B0C10")
static var SURFACE_1 := Color("#12141C")
static var SURFACE_2 := Color("#1A1D27")
static var SURFACE_3 := Color("#232735")
static var SURFACE_4 := Color("#2C3144")

# =============================================
# BORDER COLORS
# =============================================
static var BORDER := Color("#1E2235")
static var BORDER_LIGHT := Color("#2A2F45")
static var BORDER_STRONG := Color("#3F4660")

# =============================================
# BRAND COLORS
# =============================================
static var PRIMARY := Color("#7C69FF")
static var PRIMARY_DARK := Color("#6355E5")
static var PRIMARY_LIGHT := Color("#A394FF")
static var PRIMARY_SOFT := Color(0.486, 0.412, 1.0, 0.12)

static var SECONDARY := Color("#38BDF8")
static var SECONDARY_DARK := Color("#0EA5E9")
static var SECONDARY_LIGHT := Color("#7DD3FC")
static var SECONDARY_SOFT := Color(0.22, 0.741, 0.973, 0.12)

# =============================================
# STATUS COLORS
# =============================================
static var SUCCESS := Color("#2DD4BF")
static var SUCCESS_DARK := Color("#14B8A6")
static var SUCCESS_LIGHT := Color("#99F6E4")
static var SUCCESS_SOFT := Color(0.176, 0.831, 0.749, 0.12)

static var WARNING := Color("#F59E0B")
static var WARNING_DARK := Color("#D97706")
static var WARNING_LIGHT := Color("#FCD34D")
static var WARNING_SOFT := Color(0.96, 0.62, 0.04, 0.12)

static var DANGER := Color("#F43F5E")
static var DANGER_DARK := Color("#E11D48")
static var DANGER_LIGHT := Color("#FB7185")
static var DANGER_SOFT := Color(0.957, 0.247, 0.369, 0.12)

static var INFO := Color("#0EA5E9")
static var INFO_DARK := Color("#0284C7")
static var INFO_LIGHT := Color("#7DD3FC")
static var INFO_SOFT := Color(0.05, 0.65, 0.91, 0.12)

# =============================================
# TEXT COLORS
# =============================================
static var TEXT_PRIMARY := Color("#F8FAFC")
static var TEXT_SECONDARY := Color("#94A3B8")
static var TEXT_MUTED := Color("#64748B")
static var TEXT_INVERSE := Color("#050914")

# =============================================
# FONTS (Optional: Set these to your loaded font resources)
# =============================================
static var FONT_SANS: Font = null
static var FONT_BOLD: Font = null
static var FONT_MONO: Font = null
static var FONT_CHINESE: Font = null

# =============================================
# FONT SIZES
# =============================================
const FONT_XS: int = 11
const FONT_SM: int = 12
const FONT_MD: int = 14
const FONT_BASE: int = 16
const FONT_LG: int = 18
const FONT_XL: int = 20
const FONT_2XL: int = 24
const FONT_3XL: int = 30

# =============================================
# BORDER RADIUS
# =============================================
const RADIUS_XS: int = 3
const RADIUS_SM: int = 6
const RADIUS_MD: int = 8
const RADIUS_LG: int = 12
const RADIUS_XL: int = 16
const RADIUS_PILL: int = 999

# =============================================
# SPACING
# =============================================
const SP_1: int = 4
const SP_2: int = 8
const SP_3: int = 12
const SP_4: int = 16
const SP_5: int = 20
const SP_6: int = 24
const SP_8: int = 32
const SP_10: int = 40
const SP_12: int = 48
