use fmt;
use io;
use os;
use time;
use time::date;
use strings;
use unix::signal;
use types::c;

use wayland;
use wayland::client;
use wayland::wl;
use wayland::xdg;
use wayland::wlr;

use schrift;

type pixel = struct {
	b: u8,
	g: u8,
	r: u8,
	a: u8,
};

def BLACK = pixel {r = 0, g = 0, b = 0, a = 255};
def RED = pixel {r = 255, g = 0, b = 0, a = 255};
def WHITE = pixel {r = 255, g = 255, b = 255, a = 255};
def TRANSPARENT = pixel {r = 0, g = 0, b = 0, a = 0};

type texture = struct {
	pixels: []pixel,
	width: int,
	height: int,
};

fn texture_init(width: int, height: int, fill: pixel = BLACK) texture = {
	let pixels = match (alloc([fill...], (width * height): size)) {
	case let block: []pixel => yield block;
	case nomem => fmt::fatalf("fuck");
	};
	return texture {
		pixels = pixels,
		width = width,
		height = height,
	};
};

fn texture_resize(texture: *texture, width: int, height: int) void = {
	if (width <= 0 || height <= 0) fmt::fatalf("idk");
	let sz = (width * height): size;
	if (sz > len(texture.pixels)) {
		fmt::fatalf("too big!!");
		// append(texture.pixels, [BLACK...], sz - len(texture.pixels))!;
	};
	texture.width = width;
	texture.height = height;
};

fn texture_get_pixel(tex: *const texture, x: int, y: int) pixel = {
	if (x < 0 || y < 0 || x >= tex.width || y >= tex.height)
		return pixel { r = 0, g = 0, b = 0, a = 255 };
	return tex.pixels[x + y * tex.width];
};

fn draw_pixel(target: *texture, x: int, y: int, pixel: pixel) void = {
	if (x < 0 || y < 0 || x >= target.width || y >= target.height)
		return;
	target.pixels[x + y * target.width] = pixel;
};

fn draw_texture(target: *texture, src: *const texture, x: int, y: int) void = {
	let width = src.width;
	let height = src.height;
	if (width > target.width + x) width = target.width - x;
	if (height > target.height + y) height = target.height - y;
	for (let i = 0; i < height; i += 1) {
		for (let j = 0; j < width; j += 1) {
			void;
			// draw_pixel(target, x + j, y + i, texture_get_pixel(src, j, i));
		};
	};
};

fn draw_rect(target: *texture, x: int, y: int, width: int, height: int, color: pixel) void = {
	if (width > target.width + x) width = target.width - x;
	if (height > target.height + y) height = target.height - y;
	for (let i = 0; i < height; i += 1) {
		for (let j = 0; j < width; j += 1) {
			draw_pixel(target, x + j, y + i, color);
		};
	};
};

fn lookup_glyph(sft: *const schrift::SFT, codepoint: schrift::UChar) (schrift::Glyph | void) = {
	let glyph: schrift::Glyph = 0;
	if (schrift::lookup(sft, codepoint, &glyph) < 0) return void;
	return glyph;
};

fn line_metrics(sft: *const schrift::SFT) (schrift::LMetrics | void) = {
	let mtx = schrift::LMetrics {...};
	if (schrift::lmetrics(sft, &mtx) < 0) return void;
	return mtx;
};

fn glyph_metrics(sft: *const schrift::SFT, glyph: schrift::Glyph) (schrift::GMetrics | void) = {
	let mtx = schrift::GMetrics {...};
	if (schrift::gmetrics(sft, glyph, &mtx) < 0) return void;
	return mtx;
};

fn measure_text(sft: *const schrift::SFT, text: str) int = {
	let off = 0;
	let iter = strings::iter(text);
	for (let c => strings::next(&iter)) {
		const glyph = lookup_glyph(sft, c: schrift::UChar) as schrift::Glyph;
		const metrics = glyph_metrics(sft, glyph) as schrift::GMetrics;

		off += metrics.advanceWidth: int;
	};

	return off;
};

fn draw_text(target: *texture, sft: *const schrift::SFT, x: int, y: int, text: str, fg: pixel = WHITE, bg: pixel = TRANSPARENT) int = {
	let width = 0;
	let height = 0;
	let pixels: [1024]u8 = [0...];

	let off = 0;

	let iter = strings::iter(text);
	const metrics = line_metrics(sft) as schrift::LMetrics;
	const ascent = metrics.ascender: int;
	const descent = metrics.descender: int;

	for (let c => strings::next(&iter)) {
		const glyph = lookup_glyph(sft, c: schrift::UChar) as schrift::Glyph;
		const metrics = glyph_metrics(sft, glyph) as schrift::GMetrics;

		width = metrics.minWidth;
		height = metrics.minHeight;
		let sz = (width * height): size;
		if (sz > len(pixels)) {
			fmt::fatalf("glyph texture is too big");
		};

		assert(schrift::render(sft, glyph, schrift::Image {
			pixels = &pixels,
			width = width,
			height = height,
		}) > -1);

		for (let i = 0; i < height; i += 1) {
			for (let j = 0; j < width; j += 1) {
				const idx = j + i * width;
				const value = pixels[idx];
				draw_pixel(target, x + off + j + metrics.leftSideBearing: int, y - i - metrics.yOffset + descent, pixel {
					r = ((fg.r: u32 + bg.r) * value / 255): u8,
					g = ((fg.g: u32 + bg.g) * value / 255): u8,
					b = ((fg.b: u32 + bg.b) * value / 255): u8,
					a = bg.a + value,
				});
			};
		};
		off += metrics.advanceWidth: int;
	};
	return off;
};

type state = struct {
	quit: bool,
	width: int,
	height: int,
	compositor: nullable *wl::compositor,
	shm: nullable *wl::shm,
	output: nullable *wl::output,
	wm_base: nullable *xdg::wm_base,
	layer_shell_v1: nullable *wlr::layer_shell_v1,
};

type module = struct {
	content: str,
	width: int,
};

fn registry_global(userdata: nullable *opaque, obj: *wl::registry, name: u32, interface: str, version: u32) void = {
	let state = userdata: *state;

	switch (interface) {
	case "wl_compositor" =>
		state.compositor = wl::registry_bind(obj, name, &wl::compositor_interface, version): *wl::compositor;
	case "wl_shm" =>
		state.shm = wl::registry_bind(obj, name, &wl::shm_interface, version): *wl::shm;
	case "wl_output" =>
		state.output = wl::registry_bind(obj, name, &wl::output_interface, version): *wl::output;
	// case "xdg_wm_base" => state.wm_base = wl::registry_bind(obj, name, &xdg::wm_base_interface, version): *xdg::wm_base;
	case "zwlr_layer_shell_v1" =>
		state.layer_shell_v1 = wl::registry_bind(obj, name, &wlr::layer_shell_v1_interface, version): *wlr::layer_shell_v1;
	case => void;
	};
};

fn layer_surface_configure(userdata: nullable *opaque, obj: *wlr::layer_surface_v1, serial: u32, width: u32, height: u32) void = {
	let state = userdata: *state;
	state.width = width: int;
	state.height = height: int;
	wlr::layer_surface_v1_ack_configure(obj, serial);
};

fn layer_surface_closed(userdata: nullable *opaque, obj: *wlr::layer_surface_v1) void = {
	let state = userdata: *state;
	state.quit = true;
};

const registry_listener = wl::registry_listener {
	global = &registry_global,
	...
};

const layer_surface_listener = wlr::layer_surface_v1_listener {
	configure = &layer_surface_configure,
	closed = &layer_surface_closed,
	...
};

export fn main() void = {
	let state = state {...};

	signal::ignore(signal::sig::PIPE);

	let modules: []module = [];

	let font = schrift::loadfile(c::nulstr("FiraMono-Regular.ttf\0"));
	assert(font != null);
	defer schrift::freefont(font: *schrift::Font);

	let sft = schrift::SFT {
		font = font: *schrift::Font,
		xScale = 16.0,
		yScale = 16.0,
		xOffset = 0.0,
		yOffset = 0.0,
		flags = 0,
	};

	let time_buffer: [64]u8 = [0...];

	const inner_pad = 10;
	const outer_pad = 10;
	const line_height = -5;

	const line_metrics = line_metrics(&sft) as schrift::LMetrics;
	append(modules, module {
		content = "",
		width = measure_text(&sft, date::bsformat(
			time_buffer, date::STAMP, &date::now()
		) as str),
	})!;

	append(modules, module {
		content = "100%",
		width = measure_text(&sft, "100%"),
	})!;

	const text_height = (line_metrics.ascender - line_metrics.descender + line_metrics.lineGap): int;
	const box_height = text_height + inner_pad + line_height;
	const height = box_height + outer_pad / 2;

	const bg = pixel {r = 0, g = 0, b = 0, a = 0x80};
	const fg = WHITE;

	let display = match (client::connect("")) {
	case let display: *wl::display =>
		yield display;
	};
	defer client::disconnect(display)!;


	let registry = wl::display_get_registry(display);
	wl::registry_add_listener(registry, &registry_listener, &state);

	client::roundtrip(display)!;

	assert(state.compositor != null);
	assert(state.shm != null);
	assert(state.output != null);
	assert(state.layer_shell_v1 != null);

	const compositor = state.compositor as *wl::compositor;
	const shm = state.shm as *wl::shm;
	const output = state.output as *wl::output;
	const layer_shell_v1 = state.layer_shell_v1 as *wlr::layer_shell_v1;

	let region = wl::compositor_create_region(compositor);
	defer wl::region_destroy(region);

	let surface = wl::compositor_create_surface(compositor);
	defer wl::surface_destroy(surface);
	wl::surface_set_input_region(surface, region);

	let layer_surface = wlr::layer_shell_v1_get_layer_surface(layer_shell_v1, surface, null, wlr::zwlr_layer_shell_v1_layer::OVERLAY, "stamp");
	defer wlr::layer_surface_v1_destroy(layer_surface);
	wlr::layer_surface_v1_set_size(layer_surface, 0, height: u32);

	wlr::layer_surface_v1_set_anchor(
		layer_surface,
		wlr::zwlr_layer_surface_v1_anchor::LEFT  |
		wlr::zwlr_layer_surface_v1_anchor::RIGHT |
		wlr::zwlr_layer_surface_v1_anchor::BOTTOM
	);

	wlr::layer_surface_v1_add_listener(layer_surface, &layer_surface_listener, &state);

	wl::surface_commit(surface);

	client::roundtrip(display)!;

	const stride = size(u32) * state.width: size;
	const sz = stride * state.height: size;

	let shm_fd = os::memfd("shm")!;
	io::trunc(shm_fd, sz)!;

	let shm_buf = io::mmap(null, sz,
		io::prot::READ | io::prot::WRITE, io::mflag::SHARED, shm_fd, 0)!: *[*]pixel;
	defer io::munmap(shm_buf, sz)!;
	let buffer_texture = texture {
		pixels = shm_buf[..state.width * state.height],
		width = state.width,
		height = state.height,
	};

	let shm_pool = wl::shm_create_pool(shm, shm_fd, sz: i32);
	defer wl::shm_pool_destroy(shm_pool);

	const box_y = 0;

	const text_y = box_y + box_height - inner_pad / 2;


	let buffer = wl::shm_pool_create_buffer(
		shm_pool, 0, state.width: i32, state.height: i32,
		stride: i32, wl::wl_shm_format::ARGB8888
	);
	defer wl::buffer_destroy(buffer);

	for (!state.quit) {
		const time_str = date::bsformat(time_buffer, date::STAMP, &date::localnow()) as str;

		modules[0].content = time_str;

		let off = 0;
		for (let module .. modules) {
			const box_width = module.width + inner_pad;
			const box_x = buffer_texture.width - box_width - outer_pad / 2 + off;
			const text_x = box_x + inner_pad / 2;

			draw_rect(&buffer_texture, box_x, box_y, box_width, box_height, bg);
			draw_text(&buffer_texture, &sft, text_x, text_y, module.content, fg, bg);

			off -= box_width + outer_pad/2;
		};


		wl::surface_attach(surface, buffer, 0, 0);
		wl::surface_damage_buffer(surface, 0, 0, buffer_texture.width, buffer_texture.height);
		wl::surface_commit(surface);

		client::dispatch(display)!;

		time::sleep(time::SECOND * 1);
	};
};
