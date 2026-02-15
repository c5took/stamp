// Generated code for 'wlr_layer_shell_unstable_v1' protocol
use fmt;
use memio;
use io;
use wayland;
use wayland::wl;
use wayland::xdg;

// Clients can use this interface to assign the surface_layer role to
// wl_surfaces. Such surfaces are assigned to a "layer" of the output and
// rendered with a defined z-depth respective to each other. They may also be
// anchored to the edges and corners of a screen and specify input handling
// semantics. This interface should be suitable for the implementation of
// many desktop shell components, and a broad number of other applications
// that interact with the desktop.
export type layer_shell_v1 = struct {
	object: wayland::object,
	listener: nullable *layer_shell_v1_listener,
	userdata: nullable *opaque,
};

export fn layer_shell_v1_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &layer_shell_v1_interface};
	let r = alloc(layer_shell_v1 {
		object = o,
		...
	})?;
	return r;
};

export fn layer_shell_v1_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const layer_shell_v1_interface = wayland::interface {
	name = "zwlr_layer_shell_v1",
	version = 5,
	requests = [
		wayland::request {
			name = "get_layer_surface",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "id",
					type_ = wayland::argtype::NEW_ID,
					enum_ = "",
					interface = "zwlr_layer_surface_v1",
					allownull = false,
				},
				wayland::argument {
					name = "surface",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_surface",
					allownull = false,
				},
				wayland::argument {
					name = "output",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_output",
					allownull = true,
				},
				wayland::argument {
					name = "layer",
					type_ = wayland::argtype::UINT,
					enum_ = "layer",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "namespace",
					type_ = wayland::argtype::STRING,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "destroy",
			since = 3,
			type_ = "destructor",
			args = [
			],
		},
	],
	events = [
	],
	enums = [
	],
	init = &layer_shell_v1_obj_init,
	finish = &layer_shell_v1_obj_finish,
};

// Create a layer surface for an existing surface. This assigns the role of
// layer_surface, or raises a protocol error if another role is already
// assigned.
// 
// Creating a layer surface from a wl_surface which has a buffer attached
// or committed is a client error, and any attempts by a client to attach
// or manipulate a buffer prior to the first layer_surface.configure call
// must also be treated as errors.
// 
// After creating a layer_surface object and setting it up, the client
// must perform an initial commit without any buffer attached.
// The compositor will reply with a layer_surface.configure event.
// The client must acknowledge it and is then allowed to attach a buffer
// to map the surface.
// 
// You may pass NULL for output to allow the compositor to decide which
// output to use. Generally this will be the one that the user most
// recently interacted with.
// 
// Clients can specify a namespace that defines the purpose of the layer
// surface.
export fn layer_shell_v1_get_layer_surface(obj: *layer_shell_v1, surface_: *wl::surface, output_: nullable *wl::output, layer_: u32, namespace_: str) *layer_surface_v1 = {
	let buf = memio::dynamic();
	let iface = &layer_surface_v1_interface;
	let robj = iface.init(obj.object.client): *layer_surface_v1;
	wayland::registry_add(&obj.object.client.registry, robj)!;
	wayland::marshal_u32(obj.object.client, &buf, (robj: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, (surface_: *wayland::object).id);
	if (output_ is null) {
		wayland::marshal_u32(obj.object.client, &buf, 0);
	} else {
		wayland::marshal_u32(obj.object.client, &buf, (output_: *wayland::object).id);
	};
	wayland::marshal_u32(obj.object.client, &buf, layer_);
	wayland::marshal_str(obj.object.client, &buf, namespace_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "get_layer_surface", robj: *wayland::new_object, surface_: *wayland::object, output_: nullable *wayland::object, layer_, namespace_)!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
	return robj;
};

// This request indicates that the client will not use the layer_shell
// object any more. Objects that have been created through this instance
// are not affected.
export fn layer_shell_v1_destroy(obj: *layer_shell_v1) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};
export type layer_shell_v1_listener = opaque;

// 
export type zwlr_layer_shell_v1_error = enum u32 {
	ROLE = 0,
	INVALID_LAYER = 1,
	ALREADY_CONSTRUCTED = 2,
};

// These values indicate which layers a surface can be rendered in. They
// are ordered by z depth, bottom-most first. Traditional shell surfaces
// will typically be rendered between the bottom and top layers.
// Fullscreen shell surfaces are typically rendered at the top layer.
// Multiple surfaces can share a single layer, and ordering within a
// single layer is undefined.
export type zwlr_layer_shell_v1_layer = enum u32 {
	BACKGROUND = 0,
	BOTTOM = 1,
	TOP = 2,
	OVERLAY = 3,
};

// An interface that may be implemented by a wl_surface, for surfaces that
// are designed to be rendered as a layer of a stacked desktop-like
// environment.
// 
// Layer surface state (layer, size, anchor, exclusive zone,
// margin, interactivity) is double-buffered, and will be applied at the
// time wl_surface.commit of the corresponding wl_surface is called.
// 
// Attaching a null buffer to a layer surface unmaps it.
// 
// Unmapping a layer_surface means that the surface cannot be shown by the
// compositor until it is explicitly mapped again. The layer_surface
// returns to the state it had right after layer_shell.get_layer_surface.
// The client can re-map the surface by performing a commit without any
// buffer attached, waiting for a configure event and handling it as usual.
export type layer_surface_v1 = struct {
	object: wayland::object,
	listener: nullable *layer_surface_v1_listener,
	userdata: nullable *opaque,
};

export fn layer_surface_v1_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &layer_surface_v1_interface};
	let r = alloc(layer_surface_v1 {
		object = o,
		...
	})?;
	return r;
};

export fn layer_surface_v1_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const layer_surface_v1_interface = wayland::interface {
	name = "zwlr_layer_surface_v1",
	version = 5,
	requests = [
		wayland::request {
			name = "set_size",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_anchor",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "anchor",
					type_ = wayland::argtype::UINT,
					enum_ = "anchor",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_exclusive_zone",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "zone",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_margin",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "top",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "right",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "bottom",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "left",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_keyboard_interactivity",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "keyboard_interactivity",
					type_ = wayland::argtype::UINT,
					enum_ = "keyboard_interactivity",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "get_popup",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "popup",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "xdg_popup",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "ack_configure",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "serial",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "destroy",
			since = 0,
			type_ = "destructor",
			args = [
			],
		},
		wayland::request {
			name = "set_layer",
			since = 2,
			type_ = "",
			args = [
				wayland::argument {
					name = "layer",
					type_ = wayland::argtype::UINT,
					enum_ = "zwlr_layer_shell_v1.layer",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_exclusive_edge",
			since = 5,
			type_ = "",
			args = [
				wayland::argument {
					name = "edge",
					type_ = wayland::argtype::UINT,
					enum_ = "anchor",
					interface = "",
					allownull = false,
				},
			],
		},
	],
	events = [
		wayland::event {
			name = "configure",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "serial",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
			cb = &layer_surface_v1_configure_unmarshal,
		},
		wayland::event {
			name = "closed",
			since = 0,
			type_ = "",
			args = [
			],
			cb = &layer_surface_v1_closed_unmarshal,
		},
	],
	enums = [
	],
	init = &layer_surface_v1_obj_init,
	finish = &layer_surface_v1_obj_finish,
};

// Sets the size of the surface in surface-local coordinates. The
// compositor will display the surface centered with respect to its
// anchors.
// 
// If you pass 0 for either value, the compositor will assign it and
// inform you of the assignment in the configure event. You must set your
// anchor to opposite edges in the dimensions you omit; not doing so is a
// protocol error. Both values are 0 by default.
// 
// Size is double-buffered, see wl_surface.commit.
export fn layer_surface_v1_set_size(obj: *layer_surface_v1, width_: u32, height_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, width_);
	wayland::marshal_u32(obj.object.client, &buf, height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_size", width_, height_)!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Requests that the compositor anchor the surface to the specified edges
// and corners. If two orthogonal edges are specified (e.g. 'top' and
// 'left'), then the anchor point will be the intersection of the edges
// (e.g. the top left corner of the output); otherwise the anchor point
// will be centered on that edge, or in the center if none is specified.
// 
// Anchor is double-buffered, see wl_surface.commit.
export fn layer_surface_v1_set_anchor(obj: *layer_surface_v1, anchor_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, anchor_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_anchor", anchor_)!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Requests that the compositor avoids occluding an area with other
// surfaces. The compositor's use of this information is
// implementation-dependent - do not assume that this region will not
// actually be occluded.
// 
// A positive value is only meaningful if the surface is anchored to one
// edge or an edge and both perpendicular edges. If the surface is not
// anchored, anchored to only two perpendicular edges (a corner), anchored
// to only two parallel edges or anchored to all edges, a positive value
// will be treated the same as zero.
// 
// A positive zone is the distance from the edge in surface-local
// coordinates to consider exclusive.
// 
// Surfaces that do not wish to have an exclusive zone may instead specify
// how they should interact with surfaces that do. If set to zero, the
// surface indicates that it would like to be moved to avoid occluding
// surfaces with a positive exclusive zone. If set to -1, the surface
// indicates that it would not like to be moved to accommodate for other
// surfaces, and the compositor should extend it all the way to the edges
// it is anchored to.
// 
// For example, a panel might set its exclusive zone to 10, so that
// maximized shell surfaces are not shown on top of it. A notification
// might set its exclusive zone to 0, so that it is moved to avoid
// occluding the panel, but shell surfaces are shown underneath it. A
// wallpaper or lock screen might set their exclusive zone to -1, so that
// they stretch below or over the panel.
// 
// The default value is 0.
// 
// Exclusive zone is double-buffered, see wl_surface.commit.
export fn layer_surface_v1_set_exclusive_zone(obj: *layer_surface_v1, zone_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, zone_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_exclusive_zone", zone_)!;
	};
	match (wayland::queue_request(obj, 2, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Requests that the surface be placed some distance away from the anchor
// point on the output, in surface-local coordinates. Setting this value
// for edges you are not anchored to has no effect.
// 
// The exclusive zone includes the margin.
// 
// Margin is double-buffered, see wl_surface.commit.
export fn layer_surface_v1_set_margin(obj: *layer_surface_v1, top_: i32, right_: i32, bottom_: i32, left_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, top_);
	wayland::marshal_i32(obj.object.client, &buf, right_);
	wayland::marshal_i32(obj.object.client, &buf, bottom_);
	wayland::marshal_i32(obj.object.client, &buf, left_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_margin", top_, right_, bottom_, left_)!;
	};
	match (wayland::queue_request(obj, 3, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set how keyboard events are delivered to this surface. By default,
// layer shell surfaces do not receive keyboard events; this request can
// be used to change this.
// 
// This setting is inherited by child surfaces set by the get_popup
// request.
// 
// Layer surfaces receive pointer, touch, and tablet events normally. If
// you do not want to receive them, set the input region on your surface
// to an empty region.
// 
// Keyboard interactivity is double-buffered, see wl_surface.commit.
export fn layer_surface_v1_set_keyboard_interactivity(obj: *layer_surface_v1, keyboard_interactivity_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, keyboard_interactivity_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_keyboard_interactivity", keyboard_interactivity_)!;
	};
	match (wayland::queue_request(obj, 4, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// This assigns an xdg_popup's parent to this layer_surface.  This popup
// should have been created via xdg_surface::get_popup with the parent set
// to NULL, and this request must be invoked before committing the popup's
// initial state.
// 
// See the documentation of xdg_popup for more details about what an
// xdg_popup is and how it is used.
export fn layer_surface_v1_get_popup(obj: *layer_surface_v1, popup_: *xdg::popup) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, (popup_: *wayland::object).id);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "get_popup", popup_: *wayland::object)!;
	};
	match (wayland::queue_request(obj, 5, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// When a configure event is received, if a client commits the
// surface in response to the configure event, then the client
// must make an ack_configure request sometime before the commit
// request, passing along the serial of the configure event.
// 
// If the client receives multiple configure events before it
// can respond to one, it only has to ack the last configure event.
// 
// A client is not required to commit immediately after sending
// an ack_configure request - it may even ack_configure several times
// before its next surface commit.
// 
// A client may send multiple ack_configure requests before committing, but
// only the last request sent before a commit indicates which configure
// event the client really is responding to.
export fn layer_surface_v1_ack_configure(obj: *layer_surface_v1, serial_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "ack_configure", serial_)!;
	};
	match (wayland::queue_request(obj, 6, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// This request destroys the layer surface.
export fn layer_surface_v1_destroy(obj: *layer_surface_v1) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 7, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Change the layer that the surface is rendered on.
// 
// Layer is double-buffered, see wl_surface.commit.
export fn layer_surface_v1_set_layer(obj: *layer_surface_v1, layer_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, layer_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_layer", layer_)!;
	};
	match (wayland::queue_request(obj, 8, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Requests an edge for the exclusive zone to apply. The exclusive
// edge will be automatically deduced from anchor points when possible,
// but when the surface is anchored to a corner, it will be necessary
// to set it explicitly to disambiguate, as it is not possible to deduce
// which one of the two corner edges should be used.
// 
// The edge must be one the surface is anchored to, otherwise the
// invalid_exclusive_edge protocol error will be raised.
export fn layer_surface_v1_set_exclusive_edge(obj: *layer_surface_v1, edge_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, edge_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_exclusive_edge", edge_)!;
	};
	match (wayland::queue_request(obj, 9, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

export type layer_surface_v1_configure_cb = fn(userdata: nullable *opaque, obj: *layer_surface_v1, serial_: u32, width_: u32, height_: u32) void;

export fn layer_surface_v1_configure_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *layer_surface_v1;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_serial: u32 = wayland::unmarshal_u32(conn, &buf);
	let ev_arg_width: u32 = wayland::unmarshal_u32(conn, &buf);
	let ev_arg_height: u32 = wayland::unmarshal_u32(conn, &buf);
	match (obj.listener) {
	case let l: *layer_surface_v1_listener =>
		match (l.configure) {
		case let cb: *layer_surface_v1_configure_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "configure", ev_arg_serial, ev_arg_width, ev_arg_height)!;
			};
			cb(obj.userdata, obj, ev_arg_serial, ev_arg_width, ev_arg_height);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

export type layer_surface_v1_closed_cb = fn(userdata: nullable *opaque, obj: *layer_surface_v1) void;

export fn layer_surface_v1_closed_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *layer_surface_v1;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	match (obj.listener) {
	case let l: *layer_surface_v1_listener =>
		match (l.closed) {
		case let cb: *layer_surface_v1_closed_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "closed")!;
			};
			cb(obj.userdata, obj);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

// a set of callback functions for [[layer_surface_v1]]
export type layer_surface_v1_listener = struct {
// The configure event asks the client to resize its surface.
// 
// Clients should arrange their surface for the new states, and then send
// an ack_configure request with the serial sent in this configure event at
// some point before committing the new surface.
// 
// The client is free to dismiss all but the last configure event it
// received.
// 
// The width and height arguments specify the size of the window in
// surface-local coordinates.
// 
// The size is a hint, in the sense that the client is free to ignore it if
// it doesn't resize, pick a smaller size (to satisfy aspect ratio or
// resize in steps of NxM pixels). If the client picks a smaller size and
// is anchored to two opposite anchors (e.g. 'top' and 'bottom'), the
// surface will be centered on this axis.
// 
// If the width or height arguments are zero, it means the client should
// decide its own window dimension.
	configure: nullable *layer_surface_v1_configure_cb,
// The closed event is sent by the compositor when the surface will no
// longer be shown. The output may have been destroyed or the user may
// have asked for it to be removed. Further changes to the surface will be
// ignored. The client should destroy the resource after receiving this
// event, and create a new surface if they so choose.
	closed: nullable *layer_surface_v1_closed_cb,
};

export fn layer_surface_v1_add_listener(
	o: *layer_surface_v1,
	listener: *layer_surface_v1_listener,
	userdata: nullable *opaque,
) void = {
	assert(o.listener == null, "Attempted to set listener twice on one Wayland object");
	o.listener = listener;
	o.userdata = userdata;
};

// Types of keyboard interaction possible for layer shell surfaces. The
// rationale for this is twofold: (1) some applications are not interested
// in keyboard events and not allowing them to be focused can improve the
// desktop experience; (2) some applications will want to take exclusive
// keyboard focus.
export type zwlr_layer_surface_v1_keyboard_interactivity = enum u32 {
	NONE = 0,
	EXCLUSIVE = 1,
	ON_DEMAND = 2,
};

// 
export type zwlr_layer_surface_v1_error = enum u32 {
	INVALID_SURFACE_STATE = 0,
	INVALID_SIZE = 1,
	INVALID_ANCHOR = 2,
	INVALID_KEYBOARD_INTERACTIVITY = 3,
	INVALID_EXCLUSIVE_EDGE = 4,
};

// 
export type zwlr_layer_surface_v1_anchor = enum u32 {
	TOP = 1,
	BOTTOM = 2,
	LEFT = 4,
	RIGHT = 8,
};
