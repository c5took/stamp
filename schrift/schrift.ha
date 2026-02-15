use types::c;

export type Font = opaque;
export type UChar = c::uint_least32;
export type Glyph = c::uint_fast32;

export def DOWNWARD_Y = 0x01;

export type SFT = struct {
	font: *Font,
	xScale: f64,
	yScale: f64,
	xOffset: f64,
	yOffset: f64,
	flags: int,
};

export type LMetrics = struct {
	ascender: f64,
	descender: f64,
	lineGap: f64,
};

export type GMetrics = struct {
	advanceWidth: f64,
	leftSideBearing: f64,
	yOffset: int,
	minWidth: int,
	minHeight: int,
};

export type Image = struct {
	pixels: nullable *opaque,
	width: int,
	height: int,
};

export @symbol("sft_loadfile") fn loadfile(filename: *const c::char) nullable *Font;
export @symbol("sft_freefont") fn freefont(filename: *Font) void;
export @symbol("sft_lmetrics") fn lmetrics(sft: *const SFT, metrics: *LMetrics) int;
export @symbol("sft_lookup") fn lookup(sft: *const SFT, codepoint: UChar, glyph: *Glyph) int;
export @symbol("sft_gmetrics") fn gmetrics(sft: *const SFT, glyph: Glyph, metrics: *GMetrics) int;
export @symbol("sft_render") fn render(sft: *const SFT, glyph: Glyph, image: Image) int;
