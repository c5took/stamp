// Generated code for 'xdg_shell' protocol
use fmt;
use memio;
use io;
use wayland;
use wayland::wl;

// The xdg_wm_base interface is exposed as a global object enabling clients
// to turn their wl_surfaces into windows in a desktop environment. It
// defines the basic functionality needed for clients and the compositor to
// create windows that can be dragged, resized, maximized, etc, as well as
// creating transient windows such as popup menus.
export type wm_base = struct {
	object: wayland::object,
	listener: nullable *wm_base_listener,
	userdata: nullable *opaque,
};

export fn wm_base_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &wm_base_interface};
	let r = alloc(wm_base {
		object = o,
		...
	})?;
	return r;
};

export fn wm_base_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const wm_base_interface = wayland::interface {
	name = "xdg_wm_base",
	version = 7,
	requests = [
		wayland::request {
			name = "destroy",
			since = 0,
			type_ = "destructor",
			args = [
			],
		},
		wayland::request {
			name = "create_positioner",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "id",
					type_ = wayland::argtype::NEW_ID,
					enum_ = "",
					interface = "xdg_positioner",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "get_xdg_surface",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "id",
					type_ = wayland::argtype::NEW_ID,
					enum_ = "",
					interface = "xdg_surface",
					allownull = false,
				},
				wayland::argument {
					name = "surface",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_surface",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "pong",
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
	],
	events = [
		wayland::event {
			name = "ping",
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
			cb = &wm_base_ping_unmarshal,
		},
	],
	enums = [
	],
	init = &wm_base_obj_init,
	finish = &wm_base_obj_finish,
};

// Destroy this xdg_wm_base object.
// 
// Destroying a bound xdg_wm_base object while there are surfaces
// still alive created by this xdg_wm_base object instance is illegal
// and will result in a defunct_surfaces error.
export fn wm_base_destroy(obj: *wm_base) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Create a positioner object. A positioner object is used to position
// surfaces relative to some parent surface. See the interface description
// and xdg_surface.get_popup for details.
export fn wm_base_create_positioner(obj: *wm_base) *positioner = {
	let buf = memio::dynamic();
	let iface = &positioner_interface;
	let robj = iface.init(obj.object.client): *positioner;
	wayland::registry_add(&obj.object.client.registry, robj)!;
	wayland::marshal_u32(obj.object.client, &buf, (robj: *wayland::object).id);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "create_positioner", robj: *wayland::new_object)!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
	return robj;
};

// This creates an xdg_surface for the given surface. While xdg_surface
// itself is not a role, the corresponding surface may only be assigned
// a role extending xdg_surface, such as xdg_toplevel or xdg_popup. It is
// illegal to create an xdg_surface for a wl_surface which already has an
// assigned role and this will result in a role error.
// 
// This creates an xdg_surface for the given surface. An xdg_surface is
// used as basis to define a role to a given surface, such as xdg_toplevel
// or xdg_popup. It also manages functionality shared between xdg_surface
// based surface roles.
// 
// See the documentation of xdg_surface for more details about what an
// xdg_surface is and how it is used.
export fn wm_base_get_xdg_surface(obj: *wm_base, surface_: *wl::surface) *surface = {
	let buf = memio::dynamic();
	let iface = &surface_interface;
	let robj = iface.init(obj.object.client): *surface;
	wayland::registry_add(&obj.object.client.registry, robj)!;
	wayland::marshal_u32(obj.object.client, &buf, (robj: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, (surface_: *wayland::object).id);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "get_xdg_surface", robj: *wayland::new_object, surface_: *wayland::object)!;
	};
	match (wayland::queue_request(obj, 2, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
	return robj;
};

// A client must respond to a ping event with a pong request or
// the client may be deemed unresponsive. See xdg_wm_base.ping
// and xdg_wm_base.error.unresponsive.
export fn wm_base_pong(obj: *wm_base, serial_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "pong", serial_)!;
	};
	match (wayland::queue_request(obj, 3, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

export type wm_base_ping_cb = fn(userdata: nullable *opaque, obj: *wm_base, serial_: u32) void;

export fn wm_base_ping_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *wm_base;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_serial: u32 = wayland::unmarshal_u32(conn, &buf);
	match (obj.listener) {
	case let l: *wm_base_listener =>
		match (l.ping) {
		case let cb: *wm_base_ping_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "ping", ev_arg_serial)!;
			};
			cb(obj.userdata, obj, ev_arg_serial);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

// a set of callback functions for [[wm_base]]
export type wm_base_listener = struct {
// The ping event asks the client if it's still alive. Pass the
// serial specified in the event back to the compositor by sending
// a "pong" request back with the specified serial. See xdg_wm_base.pong.
// 
// Compositors can use this to determine if the client is still
// alive. It's unspecified what will happen if the client doesn't
// respond to the ping request, or in what timeframe. Clients should
// try to respond in a reasonable amount of time. The “unresponsive”
// error is provided for compositors that wish to disconnect unresponsive
// clients.
// 
// A compositor is free to ping in any way it wants, but a client must
// always respond to any xdg_wm_base object it created.
	ping: nullable *wm_base_ping_cb,
};

export fn wm_base_add_listener(
	o: *wm_base,
	listener: *wm_base_listener,
	userdata: nullable *opaque,
) void = {
	assert(o.listener == null, "Attempted to set listener twice on one Wayland object");
	o.listener = listener;
	o.userdata = userdata;
};

// 
export type xdg_wm_base_error = enum u32 {
	ROLE = 0,
	DEFUNCT_SURFACES = 1,
	NOT_THE_TOPMOST_POPUP = 2,
	INVALID_POPUP_PARENT = 3,
	INVALID_SURFACE_STATE = 4,
	INVALID_POSITIONER = 5,
	UNRESPONSIVE = 6,
};

// The xdg_positioner provides a collection of rules for the placement of a
// child surface relative to a parent surface. Rules can be defined to ensure
// the child surface remains within the visible area's borders, and to
// specify how the child surface changes its position, such as sliding along
// an axis, or flipping around a rectangle. These positioner-created rules are
// constrained by the requirement that a child surface must intersect with or
// be at least partially adjacent to its parent surface.
// 
// See the various requests for details about possible rules.
// 
// At the time of the request, the compositor makes a copy of the rules
// specified by the xdg_positioner. Thus, after the request is complete the
// xdg_positioner object can be destroyed or reused; further changes to the
// object will have no effect on previous usages.
// 
// For an xdg_positioner object to be considered complete, it must have a
// non-zero size set by set_size, and a non-zero anchor rectangle set by
// set_anchor_rect. Passing an incomplete xdg_positioner object when
// positioning a surface raises an invalid_positioner error.
export type positioner = struct {
	object: wayland::object,
	listener: nullable *positioner_listener,
	userdata: nullable *opaque,
};

export fn positioner_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &positioner_interface};
	let r = alloc(positioner {
		object = o,
		...
	})?;
	return r;
};

export fn positioner_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const positioner_interface = wayland::interface {
	name = "xdg_positioner",
	version = 7,
	requests = [
		wayland::request {
			name = "destroy",
			since = 0,
			type_ = "destructor",
			args = [
			],
		},
		wayland::request {
			name = "set_size",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_anchor_rect",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "x",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "y",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
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
			name = "set_gravity",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "gravity",
					type_ = wayland::argtype::UINT,
					enum_ = "gravity",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_constraint_adjustment",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "constraint_adjustment",
					type_ = wayland::argtype::UINT,
					enum_ = "constraint_adjustment",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_offset",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "x",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "y",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_reactive",
			since = 3,
			type_ = "",
			args = [
			],
		},
		wayland::request {
			name = "set_parent_size",
			since = 3,
			type_ = "",
			args = [
				wayland::argument {
					name = "parent_width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "parent_height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_parent_configure",
			since = 3,
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
	],
	events = [
	],
	enums = [
	],
	init = &positioner_obj_init,
	finish = &positioner_obj_finish,
};

// Notify the compositor that the xdg_positioner will no longer be used.
export fn positioner_destroy(obj: *positioner) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set the size of the surface that is to be positioned with the positioner
// object. The size is in surface-local coordinates and corresponds to the
// window geometry. See xdg_surface.set_window_geometry.
// 
// If a zero or negative size is set the invalid_input error is raised.
export fn positioner_set_size(obj: *positioner, width_: i32, height_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, width_);
	wayland::marshal_i32(obj.object.client, &buf, height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_size", width_, height_)!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Specify the anchor rectangle within the parent surface that the child
// surface will be placed relative to. The rectangle is relative to the
// window geometry as defined by xdg_surface.set_window_geometry of the
// parent surface.
// 
// When the xdg_positioner object is used to position a child surface, the
// anchor rectangle may not extend outside the window geometry of the
// positioned child's parent surface.
// 
// If a negative size is set the invalid_input error is raised.
export fn positioner_set_anchor_rect(obj: *positioner, x_: i32, y_: i32, width_: i32, height_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, x_);
	wayland::marshal_i32(obj.object.client, &buf, y_);
	wayland::marshal_i32(obj.object.client, &buf, width_);
	wayland::marshal_i32(obj.object.client, &buf, height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_anchor_rect", x_, y_, width_, height_)!;
	};
	match (wayland::queue_request(obj, 2, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Defines the anchor point for the anchor rectangle. The specified anchor
// is used derive an anchor point that the child surface will be
// positioned relative to. If a corner anchor is set (e.g. 'top_left' or
// 'bottom_right'), the anchor point will be at the specified corner;
// otherwise, the derived anchor point will be centered on the specified
// edge, or in the center of the anchor rectangle if no edge is specified.
export fn positioner_set_anchor(obj: *positioner, anchor_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, anchor_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_anchor", anchor_)!;
	};
	match (wayland::queue_request(obj, 3, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Defines in what direction a surface should be positioned, relative to
// the anchor point of the parent surface. If a corner gravity is
// specified (e.g. 'bottom_right' or 'top_left'), then the child surface
// will be placed towards the specified gravity; otherwise, the child
// surface will be centered over the anchor point on any axis that had no
// gravity specified. If the gravity is not in the ‘gravity’ enum, an
// invalid_input error is raised.
export fn positioner_set_gravity(obj: *positioner, gravity_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, gravity_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_gravity", gravity_)!;
	};
	match (wayland::queue_request(obj, 4, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Specify how the window should be positioned if the originally intended
// position caused the surface to be constrained, meaning at least
// partially outside positioning boundaries set by the compositor. The
// adjustment is set by constructing a bitmask describing the adjustment to
// be made when the surface is constrained on that axis.
// 
// If no bit for one axis is set, the compositor will assume that the child
// surface should not change its position on that axis when constrained.
// 
// If more than one bit for one axis is set, the order of how adjustments
// are applied is specified in the corresponding adjustment descriptions.
// 
// The default adjustment is none.
export fn positioner_set_constraint_adjustment(obj: *positioner, constraint_adjustment_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, constraint_adjustment_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_constraint_adjustment", constraint_adjustment_)!;
	};
	match (wayland::queue_request(obj, 5, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Specify the surface position offset relative to the position of the
// anchor on the anchor rectangle and the anchor on the surface. For
// example if the anchor of the anchor rectangle is at (x, y), the surface
// has the gravity bottom|right, and the offset is (ox, oy), the calculated
// surface position will be (x + ox, y + oy). The offset position of the
// surface is the one used for constraint testing. See
// set_constraint_adjustment.
// 
// An example use case is placing a popup menu on top of a user interface
// element, while aligning the user interface element of the parent surface
// with some user interface element placed somewhere in the popup surface.
export fn positioner_set_offset(obj: *positioner, x_: i32, y_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, x_);
	wayland::marshal_i32(obj.object.client, &buf, y_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_offset", x_, y_)!;
	};
	match (wayland::queue_request(obj, 6, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// When set reactive, the surface is reconstrained if the conditions used
// for constraining changed, e.g. the parent window moved.
// 
// If the conditions changed and the popup was reconstrained, an
// xdg_popup.configure event is sent with updated geometry, followed by an
// xdg_surface.configure event.
export fn positioner_set_reactive(obj: *positioner) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_reactive")!;
	};
	match (wayland::queue_request(obj, 7, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set the parent window geometry the compositor should use when
// positioning the popup. The compositor may use this information to
// determine the future state the popup should be constrained using. If
// this doesn't match the dimension of the parent the popup is eventually
// positioned against, the behavior is undefined.
// 
// The arguments are given in the surface-local coordinate space.
export fn positioner_set_parent_size(obj: *positioner, parent_width_: i32, parent_height_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, parent_width_);
	wayland::marshal_i32(obj.object.client, &buf, parent_height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_parent_size", parent_width_, parent_height_)!;
	};
	match (wayland::queue_request(obj, 8, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set the serial of an xdg_surface.configure event this positioner will be
// used in response to. The compositor may use this information together
// with set_parent_size to determine what future state the popup should be
// constrained using.
export fn positioner_set_parent_configure(obj: *positioner, serial_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_parent_configure", serial_)!;
	};
	match (wayland::queue_request(obj, 9, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};
export type positioner_listener = opaque;

// 
export type xdg_positioner_error = enum u32 {
	INVALID_INPUT = 0,
};

// 
export type xdg_positioner_anchor = enum u32 {
	NONE = 0,
	TOP = 1,
	BOTTOM = 2,
	LEFT = 3,
	RIGHT = 4,
	TOP_LEFT = 5,
	BOTTOM_LEFT = 6,
	TOP_RIGHT = 7,
	BOTTOM_RIGHT = 8,
};

// 
export type xdg_positioner_gravity = enum u32 {
	NONE = 0,
	TOP = 1,
	BOTTOM = 2,
	LEFT = 3,
	RIGHT = 4,
	TOP_LEFT = 5,
	BOTTOM_LEFT = 6,
	TOP_RIGHT = 7,
	BOTTOM_RIGHT = 8,
};

// The constraint adjustment value define ways the compositor will adjust
// the position of the surface, if the unadjusted position would result
// in the surface being partly constrained.
// 
// Whether a surface is considered 'constrained' is left to the compositor
// to determine. For example, the surface may be partly outside the
// compositor's defined 'work area', thus necessitating the child surface's
// position be adjusted until it is entirely inside the work area.
// 
// The adjustments can be combined, according to a defined precedence: 1)
// Flip, 2) Slide, 3) Resize.
export type xdg_positioner_constraint_adjustment = enum u32 {
	NONE = 0,
	SLIDE_X = 1,
	SLIDE_Y = 2,
	FLIP_X = 4,
	FLIP_Y = 8,
	RESIZE_X = 16,
	RESIZE_Y = 32,
};

// An interface that may be implemented by a wl_surface, for
// implementations that provide a desktop-style user interface.
// 
// It provides a base set of functionality required to construct user
// interface elements requiring management by the compositor, such as
// toplevel windows, menus, etc. The types of functionality are split into
// xdg_surface roles.
// 
// Creating an xdg_surface does not set the role for a wl_surface. In order
// to map an xdg_surface, the client must create a role-specific object
// using, e.g., get_toplevel, get_popup. The wl_surface for any given
// xdg_surface can have at most one role, and may not be assigned any role
// not based on xdg_surface.
// 
// A role must be assigned before any other requests are made to the
// xdg_surface object.
// 
// The client must call wl_surface.commit on the corresponding wl_surface
// for the xdg_surface state to take effect.
// 
// Creating an xdg_surface from a wl_surface which has a buffer attached or
// committed is a client error, and any attempts by a client to attach or
// manipulate a buffer prior to the first xdg_surface.configure call must
// also be treated as errors.
// 
// After creating a role-specific object and setting it up (e.g. by sending
// the title, app ID, size constraints, parent, etc), the client must
// perform an initial commit without any buffer attached. The compositor
// will reply with initial wl_surface state such as
// wl_surface.preferred_buffer_scale followed by an xdg_surface.configure
// event. The client must acknowledge it and is then allowed to attach a
// buffer to map the surface.
// 
// Mapping an xdg_surface-based role surface is defined as making it
// possible for the surface to be shown by the compositor. Note that
// a mapped surface is not guaranteed to be visible once it is mapped.
// 
// For an xdg_surface to be mapped by the compositor, the following
// conditions must be met:
// (1) the client has assigned an xdg_surface-based role to the surface
// (2) the client has set and committed the xdg_surface state and the
// role-dependent state to the surface
// (3) the client has committed a buffer to the surface
// 
// A newly-unmapped surface is considered to have met condition (1) out
// of the 3 required conditions for mapping a surface if its role surface
// has not been destroyed, i.e. the client must perform the initial commit
// again before attaching a buffer.
export type surface = struct {
	object: wayland::object,
	listener: nullable *surface_listener,
	userdata: nullable *opaque,
};

export fn surface_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &surface_interface};
	let r = alloc(surface {
		object = o,
		...
	})?;
	return r;
};

export fn surface_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const surface_interface = wayland::interface {
	name = "xdg_surface",
	version = 7,
	requests = [
		wayland::request {
			name = "destroy",
			since = 0,
			type_ = "destructor",
			args = [
			],
		},
		wayland::request {
			name = "get_toplevel",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "id",
					type_ = wayland::argtype::NEW_ID,
					enum_ = "",
					interface = "xdg_toplevel",
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
					name = "id",
					type_ = wayland::argtype::NEW_ID,
					enum_ = "",
					interface = "xdg_popup",
					allownull = false,
				},
				wayland::argument {
					name = "parent",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "xdg_surface",
					allownull = true,
				},
				wayland::argument {
					name = "positioner",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "xdg_positioner",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_window_geometry",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "x",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "y",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
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
			],
			cb = &surface_configure_unmarshal,
		},
	],
	enums = [
	],
	init = &surface_obj_init,
	finish = &surface_obj_finish,
};

// Destroy the xdg_surface object. An xdg_surface must only be destroyed
// after its role object has been destroyed, otherwise
// a defunct_role_object error is raised.
export fn surface_destroy(obj: *surface) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// This creates an xdg_toplevel object for the given xdg_surface and gives
// the associated wl_surface the xdg_toplevel role.
// 
// See the documentation of xdg_toplevel for more details about what an
// xdg_toplevel is and how it is used.
export fn surface_get_toplevel(obj: *surface) *toplevel = {
	let buf = memio::dynamic();
	let iface = &toplevel_interface;
	let robj = iface.init(obj.object.client): *toplevel;
	wayland::registry_add(&obj.object.client.registry, robj)!;
	wayland::marshal_u32(obj.object.client, &buf, (robj: *wayland::object).id);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "get_toplevel", robj: *wayland::new_object)!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
	return robj;
};

// This creates an xdg_popup object for the given xdg_surface and gives
// the associated wl_surface the xdg_popup role.
// 
// If null is passed as a parent, a parent surface must be specified using
// some other protocol, before committing the initial state.
// 
// See the documentation of xdg_popup for more details about what an
// xdg_popup is and how it is used.
export fn surface_get_popup(obj: *surface, parent_: nullable *surface, positioner_: *positioner) *popup = {
	let buf = memio::dynamic();
	let iface = &popup_interface;
	let robj = iface.init(obj.object.client): *popup;
	wayland::registry_add(&obj.object.client.registry, robj)!;
	wayland::marshal_u32(obj.object.client, &buf, (robj: *wayland::object).id);
	if (parent_ is null) {
		wayland::marshal_u32(obj.object.client, &buf, 0);
	} else {
		wayland::marshal_u32(obj.object.client, &buf, (parent_: *wayland::object).id);
	};
	wayland::marshal_u32(obj.object.client, &buf, (positioner_: *wayland::object).id);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "get_popup", robj: *wayland::new_object, parent_: nullable *wayland::object, positioner_: *wayland::object)!;
	};
	match (wayland::queue_request(obj, 2, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
	return robj;
};

// The window geometry of a surface is its "visible bounds" from the
// user's perspective. Client-side decorations often have invisible
// portions like drop-shadows which should be ignored for the
// purposes of aligning, placing and constraining windows.
// 
// The window geometry is double-buffered state, see wl_surface.commit.
// 
// When maintaining a position, the compositor should treat the (x, y)
// coordinate of the window geometry as the top left corner of the window.
// A client changing the (x, y) window geometry coordinate should in
// general not alter the position of the window.
// 
// Once the window geometry of the surface is set, it is not possible to
// unset it, and it will remain the same until set_window_geometry is
// called again, even if a new subsurface or buffer is attached.
// 
// If never set, the value is the full bounds of the surface,
// including any subsurfaces. This updates dynamically on every
// commit. This unset is meant for extremely simple clients.
// 
// The arguments are given in the surface-local coordinate space of
// the wl_surface associated with this xdg_surface, and may extend outside
// of the wl_surface itself to mark parts of the subsurface tree as part of
// the window geometry.
// 
// When applied, the effective window geometry will be the set window
// geometry clamped to the bounding rectangle of the combined
// geometry of the surface of the xdg_surface and the associated
// subsurfaces.
// 
// The effective geometry will not be recalculated unless a new call to
// set_window_geometry is done and the new pending surface state is
// subsequently applied.
// 
// The width and height of the effective window geometry must be
// greater than zero. Setting an invalid size will raise an
// invalid_size error.
export fn surface_set_window_geometry(obj: *surface, x_: i32, y_: i32, width_: i32, height_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, x_);
	wayland::marshal_i32(obj.object.client, &buf, y_);
	wayland::marshal_i32(obj.object.client, &buf, width_);
	wayland::marshal_i32(obj.object.client, &buf, height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_window_geometry", x_, y_, width_, height_)!;
	};
	match (wayland::queue_request(obj, 3, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// When a configure event is received, if a client commits the
// surface in response to the configure event, then the client
// must make an ack_configure request sometime before the commit
// request, passing along the serial of the configure event.
// 
// For instance, for toplevel surfaces the compositor might use this
// information to move a surface to the top left only when the client has
// drawn itself for the maximized or fullscreen state.
// 
// If the client receives multiple configure events before it
// can respond to one, it only has to ack the last configure event.
// Acking a configure event that was never sent raises an invalid_serial
// error.
// 
// A client is not required to commit immediately after sending
// an ack_configure request - it may even ack_configure several times
// before its next surface commit.
// 
// A client may send multiple ack_configure requests before committing, but
// only the last request sent before a commit indicates which configure
// event the client really is responding to.
// 
// Sending an ack_configure request consumes the serial number sent with
// the request, as well as serial numbers sent by all configure events
// sent on this xdg_surface prior to the configure event referenced by
// the committed serial.
// 
// It is an error to issue multiple ack_configure requests referencing a
// serial from the same configure event, or to issue an ack_configure
// request referencing a serial from a configure event issued before the
// event identified by the last ack_configure request for the same
// xdg_surface. Doing so will raise an invalid_serial error.
export fn surface_ack_configure(obj: *surface, serial_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "ack_configure", serial_)!;
	};
	match (wayland::queue_request(obj, 4, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

export type surface_configure_cb = fn(userdata: nullable *opaque, obj: *surface, serial_: u32) void;

export fn surface_configure_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *surface;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_serial: u32 = wayland::unmarshal_u32(conn, &buf);
	match (obj.listener) {
	case let l: *surface_listener =>
		match (l.configure) {
		case let cb: *surface_configure_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "configure", ev_arg_serial)!;
			};
			cb(obj.userdata, obj, ev_arg_serial);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

// a set of callback functions for [[surface]]
export type surface_listener = struct {
// The configure event marks the end of a configure sequence. A configure
// sequence is a set of one or more events configuring the state of the
// xdg_surface, including the final xdg_surface.configure event.
// 
// Where applicable, xdg_surface surface roles will during a configure
// sequence extend this event as a latched state sent as events before the
// xdg_surface.configure event. Such events should be considered to make up
// a set of atomically applied configuration states, where the
// xdg_surface.configure commits the accumulated state.
// 
// Clients should arrange their surface for the new states, and then send
// an ack_configure request with the serial sent in this configure event at
// some point before committing the new surface.
// 
// If the client receives multiple configure events before it can respond
// to one, it is free to discard all but the last event it received.
	configure: nullable *surface_configure_cb,
};

export fn surface_add_listener(
	o: *surface,
	listener: *surface_listener,
	userdata: nullable *opaque,
) void = {
	assert(o.listener == null, "Attempted to set listener twice on one Wayland object");
	o.listener = listener;
	o.userdata = userdata;
};

// 
export type xdg_surface_error = enum u32 {
	NOT_CONSTRUCTED = 1,
	ALREADY_CONSTRUCTED = 2,
	UNCONFIGURED_BUFFER = 3,
	INVALID_SERIAL = 4,
	INVALID_SIZE = 5,
	DEFUNCT_ROLE_OBJECT = 6,
};

// This interface defines an xdg_surface role which allows a surface to,
// among other things, set window-like properties such as maximize,
// fullscreen, and minimize, set application-specific metadata like title and
// id, and well as trigger user interactive operations such as interactive
// resize and move.
// 
// A xdg_toplevel by default is responsible for providing the full intended
// visual representation of the toplevel, which depending on the window
// state, may mean things like a title bar, window controls and drop shadow.
// 
// Unmapping an xdg_toplevel means that the surface cannot be shown
// by the compositor until it is explicitly mapped again.
// All active operations (e.g., move, resize) are canceled and all
// attributes (e.g. title, state, stacking, ...) are discarded for
// an xdg_toplevel surface when it is unmapped. The xdg_toplevel returns to
// the state it had right after xdg_surface.get_toplevel. The client
// can re-map the toplevel by performing a commit without any buffer
// attached, waiting for a configure event and handling it as usual (see
// xdg_surface description).
// 
// Attaching a null buffer to a toplevel unmaps the surface.
export type toplevel = struct {
	object: wayland::object,
	listener: nullable *toplevel_listener,
	userdata: nullable *opaque,
};

export fn toplevel_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &toplevel_interface};
	let r = alloc(toplevel {
		object = o,
		...
	})?;
	return r;
};

export fn toplevel_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const toplevel_interface = wayland::interface {
	name = "xdg_toplevel",
	version = 7,
	requests = [
		wayland::request {
			name = "destroy",
			since = 0,
			type_ = "destructor",
			args = [
			],
		},
		wayland::request {
			name = "set_parent",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "parent",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "xdg_toplevel",
					allownull = true,
				},
			],
		},
		wayland::request {
			name = "set_title",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "title",
					type_ = wayland::argtype::STRING,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_app_id",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "app_id",
					type_ = wayland::argtype::STRING,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "show_window_menu",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "seat",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_seat",
					allownull = false,
				},
				wayland::argument {
					name = "serial",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "x",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "y",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "move",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "seat",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_seat",
					allownull = false,
				},
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
			name = "resize",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "seat",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_seat",
					allownull = false,
				},
				wayland::argument {
					name = "serial",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "edges",
					type_ = wayland::argtype::UINT,
					enum_ = "resize_edge",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_max_size",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_min_size",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
		},
		wayland::request {
			name = "set_maximized",
			since = 0,
			type_ = "",
			args = [
			],
		},
		wayland::request {
			name = "unset_maximized",
			since = 0,
			type_ = "",
			args = [
			],
		},
		wayland::request {
			name = "set_fullscreen",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "output",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_output",
					allownull = true,
				},
			],
		},
		wayland::request {
			name = "unset_fullscreen",
			since = 0,
			type_ = "",
			args = [
			],
		},
		wayland::request {
			name = "set_minimized",
			since = 0,
			type_ = "",
			args = [
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
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "states",
					type_ = wayland::argtype::ARRAY,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
			cb = &toplevel_configure_unmarshal,
		},
		wayland::event {
			name = "close",
			since = 0,
			type_ = "",
			args = [
			],
			cb = &toplevel_close_unmarshal,
		},
		wayland::event {
			name = "configure_bounds",
			since = 4,
			type_ = "",
			args = [
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
			cb = &toplevel_configure_bounds_unmarshal,
		},
		wayland::event {
			name = "wm_capabilities",
			since = 5,
			type_ = "",
			args = [
				wayland::argument {
					name = "capabilities",
					type_ = wayland::argtype::ARRAY,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
			cb = &toplevel_wm_capabilities_unmarshal,
		},
	],
	enums = [
	],
	init = &toplevel_obj_init,
	finish = &toplevel_obj_finish,
};

// This request destroys the role surface and unmaps the surface;
// see "Unmapping" behavior in interface section for details.
export fn toplevel_destroy(obj: *toplevel) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set the "parent" of this surface. This surface should be stacked
// above the parent surface and all other ancestor surfaces.
// 
// Parent surfaces should be set on dialogs, toolboxes, or other
// "auxiliary" surfaces, so that the parent is raised when the dialog
// is raised.
// 
// Setting a null parent for a child surface unsets its parent. Setting
// a null parent for a surface which currently has no parent is a no-op.
// 
// Only mapped surfaces can have child surfaces. Setting a parent which
// is not mapped is equivalent to setting a null parent. If a surface
// becomes unmapped, its children's parent is set to the parent of
// the now-unmapped surface. If the now-unmapped surface has no parent,
// its children's parent is unset. If the now-unmapped surface becomes
// mapped again, its parent-child relationship is not restored.
// 
// The parent toplevel must not be one of the child toplevel's
// descendants, and the parent must be different from the child toplevel,
// otherwise the invalid_parent protocol error is raised.
export fn toplevel_set_parent(obj: *toplevel, parent_: nullable *toplevel) void = {
	let buf = memio::dynamic();
	if (parent_ is null) {
		wayland::marshal_u32(obj.object.client, &buf, 0);
	} else {
		wayland::marshal_u32(obj.object.client, &buf, (parent_: *wayland::object).id);
	};
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_parent", parent_: nullable *wayland::object)!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set a short title for the surface.
// 
// This string may be used to identify the surface in a task bar,
// window list, or other user interface elements provided by the
// compositor.
// 
// The string must be encoded in UTF-8.
export fn toplevel_set_title(obj: *toplevel, title_: str) void = {
	let buf = memio::dynamic();
	wayland::marshal_str(obj.object.client, &buf, title_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_title", title_)!;
	};
	match (wayland::queue_request(obj, 2, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set an application identifier for the surface.
// 
// The app ID identifies the general class of applications to which
// the surface belongs. The compositor can use this to group multiple
// surfaces together, or to determine how to launch a new application.
// 
// For D-Bus activatable applications, the app ID is used as the D-Bus
// service name.
// 
// The compositor shell will try to group application surfaces together
// by their app ID. As a best practice, it is suggested to select app
// ID's that match the basename of the application's .desktop file.
// For example, "org.freedesktop.FooViewer" where the .desktop file is
// "org.freedesktop.FooViewer.desktop".
// 
// Like other properties, a set_app_id request can be sent after the
// xdg_toplevel has been mapped to update the property.
// 
// See the desktop-entry specification [0] for more details on
// application identifiers and how they relate to well-known D-Bus
// names and .desktop files.
// 
// [0] https://standards.freedesktop.org/desktop-entry-spec/
export fn toplevel_set_app_id(obj: *toplevel, app_id_: str) void = {
	let buf = memio::dynamic();
	wayland::marshal_str(obj.object.client, &buf, app_id_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_app_id", app_id_)!;
	};
	match (wayland::queue_request(obj, 3, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Clients implementing client-side decorations might want to show
// a context menu when right-clicking on the decorations, giving the
// user a menu that they can use to maximize or minimize the window.
// 
// This request asks the compositor to pop up such a window menu at
// the given position, relative to the local surface coordinates of
// the parent surface. There are no guarantees as to what menu items
// the window menu contains, or even if a window menu will be drawn
// at all.
// 
// This request must be used in response to some sort of user action
// like a button press, key press, or touch down event.
export fn toplevel_show_window_menu(obj: *toplevel, seat_: *wl::seat, serial_: u32, x_: i32, y_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, (seat_: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	wayland::marshal_i32(obj.object.client, &buf, x_);
	wayland::marshal_i32(obj.object.client, &buf, y_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "show_window_menu", seat_: *wayland::object, serial_, x_, y_)!;
	};
	match (wayland::queue_request(obj, 4, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Start an interactive, user-driven move of the surface.
// 
// This request must be used in response to some sort of user action
// like a button press, key press, or touch down event. The passed
// serial is used to determine the type of interactive move (touch,
// pointer, etc).
// 
// The server may ignore move requests depending on the state of
// the surface (e.g. fullscreen or maximized), or if the passed serial
// is no longer valid.
// 
// If triggered, the surface will lose the focus of the device
// (wl_pointer, wl_touch, etc) used for the move. It is up to the
// compositor to visually indicate that the move is taking place, such as
// updating a pointer cursor, during the move. There is no guarantee
// that the device focus will return when the move is completed.
export fn toplevel_move(obj: *toplevel, seat_: *wl::seat, serial_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, (seat_: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "move", seat_: *wayland::object, serial_)!;
	};
	match (wayland::queue_request(obj, 5, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Start a user-driven, interactive resize of the surface.
// 
// This request must be used in response to some sort of user action
// like a button press, key press, or touch down event. The passed
// serial is used to determine the type of interactive resize (touch,
// pointer, etc).
// 
// The server may ignore resize requests depending on the state of
// the surface (e.g. fullscreen or maximized).
// 
// If triggered, the client will receive configure events with the
// "resize" state enum value and the expected sizes. See the "resize"
// enum value for more details about what is required. The client
// must also acknowledge configure events using "ack_configure". After
// the resize is completed, the client will receive another "configure"
// event without the resize state.
// 
// If triggered, the surface also will lose the focus of the device
// (wl_pointer, wl_touch, etc) used for the resize. It is up to the
// compositor to visually indicate that the resize is taking place,
// such as updating a pointer cursor, during the resize. There is no
// guarantee that the device focus will return when the resize is
// completed.
// 
// The edges parameter specifies how the surface should be resized, and
// is one of the values of the resize_edge enum. Values not matching
// a variant of the enum will cause the invalid_resize_edge protocol error.
// The compositor may use this information to update the surface position
// for example when dragging the top left corner. The compositor may also
// use this information to adapt its behavior, e.g. choose an appropriate
// cursor image.
export fn toplevel_resize(obj: *toplevel, seat_: *wl::seat, serial_: u32, edges_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, (seat_: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	wayland::marshal_u32(obj.object.client, &buf, edges_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "resize", seat_: *wayland::object, serial_, edges_)!;
	};
	match (wayland::queue_request(obj, 6, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set a maximum size for the window.
// 
// The client can specify a maximum size so that the compositor does
// not try to configure the window beyond this size.
// 
// The width and height arguments are in window geometry coordinates.
// See xdg_surface.set_window_geometry.
// 
// Values set in this way are double-buffered, see wl_surface.commit.
// 
// The compositor can use this information to allow or disallow
// different states like maximize or fullscreen and draw accurate
// animations.
// 
// Similarly, a tiling window manager may use this information to
// place and resize client windows in a more effective way.
// 
// The client should not rely on the compositor to obey the maximum
// size. The compositor may decide to ignore the values set by the
// client and request a larger size.
// 
// If never set, or a value of zero in the request, means that the
// client has no expected maximum size in the given dimension.
// As a result, a client wishing to reset the maximum size
// to an unspecified state can use zero for width and height in the
// request.
// 
// Requesting a maximum size to be smaller than the minimum size of
// a surface is illegal and will result in an invalid_size error.
// 
// The width and height must be greater than or equal to zero. Using
// strictly negative values for width or height will result in a
// invalid_size error.
export fn toplevel_set_max_size(obj: *toplevel, width_: i32, height_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, width_);
	wayland::marshal_i32(obj.object.client, &buf, height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_max_size", width_, height_)!;
	};
	match (wayland::queue_request(obj, 7, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Set a minimum size for the window.
// 
// The client can specify a minimum size so that the compositor does
// not try to configure the window below this size.
// 
// The width and height arguments are in window geometry coordinates.
// See xdg_surface.set_window_geometry.
// 
// Values set in this way are double-buffered, see wl_surface.commit.
// 
// The compositor can use this information to allow or disallow
// different states like maximize or fullscreen and draw accurate
// animations.
// 
// Similarly, a tiling window manager may use this information to
// place and resize client windows in a more effective way.
// 
// The client should not rely on the compositor to obey the minimum
// size. The compositor may decide to ignore the values set by the
// client and request a smaller size.
// 
// If never set, or a value of zero in the request, means that the
// client has no expected minimum size in the given dimension.
// As a result, a client wishing to reset the minimum size
// to an unspecified state can use zero for width and height in the
// request.
// 
// Requesting a minimum size to be larger than the maximum size of
// a surface is illegal and will result in an invalid_size error.
// 
// The width and height must be greater than or equal to zero. Using
// strictly negative values for width and height will result in a
// invalid_size error.
export fn toplevel_set_min_size(obj: *toplevel, width_: i32, height_: i32) void = {
	let buf = memio::dynamic();
	wayland::marshal_i32(obj.object.client, &buf, width_);
	wayland::marshal_i32(obj.object.client, &buf, height_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_min_size", width_, height_)!;
	};
	match (wayland::queue_request(obj, 8, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Maximize the surface.
// 
// After requesting that the surface should be maximized, the compositor
// will respond by emitting a configure event. Whether this configure
// actually sets the window maximized is subject to compositor policies.
// The client must then update its content, drawing in the configured
// state. The client must also acknowledge the configure when committing
// the new content (see ack_configure).
// 
// It is up to the compositor to decide how and where to maximize the
// surface, for example which output and what region of the screen should
// be used.
// 
// If the surface was already maximized, the compositor will still emit
// a configure event with the "maximized" state.
// 
// If the surface is in a fullscreen state, this request has no direct
// effect. It may alter the state the surface is returned to when
// unmaximized unless overridden by the compositor.
export fn toplevel_set_maximized(obj: *toplevel) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_maximized")!;
	};
	match (wayland::queue_request(obj, 9, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Unmaximize the surface.
// 
// After requesting that the surface should be unmaximized, the compositor
// will respond by emitting a configure event. Whether this actually
// un-maximizes the window is subject to compositor policies.
// If available and applicable, the compositor will include the window
// geometry dimensions the window had prior to being maximized in the
// configure event. The client must then update its content, drawing it in
// the configured state. The client must also acknowledge the configure
// when committing the new content (see ack_configure).
// 
// It is up to the compositor to position the surface after it was
// unmaximized; usually the position the surface had before maximizing, if
// applicable.
// 
// If the surface was already not maximized, the compositor will still
// emit a configure event without the "maximized" state.
// 
// If the surface is in a fullscreen state, this request has no direct
// effect. It may alter the state the surface is returned to when
// unmaximized unless overridden by the compositor.
export fn toplevel_unset_maximized(obj: *toplevel) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "unset_maximized")!;
	};
	match (wayland::queue_request(obj, 10, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Make the surface fullscreen.
// 
// After requesting that the surface should be fullscreened, the
// compositor will respond by emitting a configure event. Whether the
// client is actually put into a fullscreen state is subject to compositor
// policies. The client must also acknowledge the configure when
// committing the new content (see ack_configure).
// 
// The output passed by the request indicates the client's preference as
// to which display it should be set fullscreen on. If this value is NULL,
// it's up to the compositor to choose which display will be used to map
// this surface.
// 
// If the surface doesn't cover the whole output, the compositor will
// position the surface in the center of the output and compensate with
// with border fill covering the rest of the output. The content of the
// border fill is undefined, but should be assumed to be in some way that
// attempts to blend into the surrounding area (e.g. solid black).
// 
// If the fullscreened surface is not opaque, the compositor must make
// sure that other screen content not part of the same surface tree (made
// up of subsurfaces, popups or similarly coupled surfaces) are not
// visible below the fullscreened surface.
export fn toplevel_set_fullscreen(obj: *toplevel, output_: nullable *wl::output) void = {
	let buf = memio::dynamic();
	if (output_ is null) {
		wayland::marshal_u32(obj.object.client, &buf, 0);
	} else {
		wayland::marshal_u32(obj.object.client, &buf, (output_: *wayland::object).id);
	};
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_fullscreen", output_: nullable *wayland::object)!;
	};
	match (wayland::queue_request(obj, 11, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Make the surface no longer fullscreen.
// 
// After requesting that the surface should be unfullscreened, the
// compositor will respond by emitting a configure event.
// Whether this actually removes the fullscreen state of the client is
// subject to compositor policies.
// 
// Making a surface unfullscreen sets states for the surface based on the following:
// * the state(s) it may have had before becoming fullscreen
// * any state(s) decided by the compositor
// * any state(s) requested by the client while the surface was fullscreen
// 
// The compositor may include the previous window geometry dimensions in
// the configure event, if applicable.
// 
// The client must also acknowledge the configure when committing the new
// content (see ack_configure).
export fn toplevel_unset_fullscreen(obj: *toplevel) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "unset_fullscreen")!;
	};
	match (wayland::queue_request(obj, 12, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Request that the compositor minimize your surface. There is no
// way to know if the surface is currently minimized, nor is there
// any way to unset minimization on this surface.
// 
// If you are looking to throttle redrawing when minimized, please
// instead use the wl_surface.frame event for this, as this will
// also work with live previews on windows in Alt-Tab, Expose or
// similar compositor features.
export fn toplevel_set_minimized(obj: *toplevel) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "set_minimized")!;
	};
	match (wayland::queue_request(obj, 13, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

export type toplevel_configure_cb = fn(userdata: nullable *opaque, obj: *toplevel, width_: i32, height_: i32, states_: wayland::array) void;

export fn toplevel_configure_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *toplevel;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_width: i32 = wayland::unmarshal_i32(conn, &buf);
	let ev_arg_height: i32 = wayland::unmarshal_i32(conn, &buf);
	let ev_arg_states: wayland::array = wayland::unmarshal_array(conn, &buf);
	match (obj.listener) {
	case let l: *toplevel_listener =>
		match (l.configure) {
		case let cb: *toplevel_configure_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "configure", ev_arg_width, ev_arg_height, ev_arg_states)!;
			};
			cb(obj.userdata, obj, ev_arg_width, ev_arg_height, ev_arg_states);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

export type toplevel_close_cb = fn(userdata: nullable *opaque, obj: *toplevel) void;

export fn toplevel_close_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *toplevel;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	match (obj.listener) {
	case let l: *toplevel_listener =>
		match (l.close) {
		case let cb: *toplevel_close_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "close")!;
			};
			cb(obj.userdata, obj);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

export type toplevel_configure_bounds_cb = fn(userdata: nullable *opaque, obj: *toplevel, width_: i32, height_: i32) void;

export fn toplevel_configure_bounds_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *toplevel;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_width: i32 = wayland::unmarshal_i32(conn, &buf);
	let ev_arg_height: i32 = wayland::unmarshal_i32(conn, &buf);
	match (obj.listener) {
	case let l: *toplevel_listener =>
		match (l.configure_bounds) {
		case let cb: *toplevel_configure_bounds_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "configure_bounds", ev_arg_width, ev_arg_height)!;
			};
			cb(obj.userdata, obj, ev_arg_width, ev_arg_height);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

export type toplevel_wm_capabilities_cb = fn(userdata: nullable *opaque, obj: *toplevel, capabilities_: wayland::array) void;

export fn toplevel_wm_capabilities_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *toplevel;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_capabilities: wayland::array = wayland::unmarshal_array(conn, &buf);
	match (obj.listener) {
	case let l: *toplevel_listener =>
		match (l.wm_capabilities) {
		case let cb: *toplevel_wm_capabilities_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "wm_capabilities", ev_arg_capabilities)!;
			};
			cb(obj.userdata, obj, ev_arg_capabilities);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

// a set of callback functions for [[toplevel]]
export type toplevel_listener = struct {
// This configure event asks the client to resize its toplevel surface or
// to change its state. The configured state should not be applied
// immediately. See xdg_surface.configure for details.
// 
// The width and height arguments specify a hint to the window
// about how its surface should be resized in window geometry
// coordinates. See set_window_geometry.
// 
// If the width or height arguments are zero, it means the client
// should decide its own window dimension. This may happen when the
// compositor needs to configure the state of the surface but doesn't
// have any information about any previous or expected dimension.
// 
// The states listed in the event specify how the width/height
// arguments should be interpreted, and possibly how it should be
// drawn.
// 
// Clients must send an ack_configure in response to this event. See
// xdg_surface.configure and xdg_surface.ack_configure for details.
	configure: nullable *toplevel_configure_cb,
// The close event is sent by the compositor when the user
// wants the surface to be closed. This should be equivalent to
// the user clicking the close button in client-side decorations,
// if your application has any.
// 
// This is only a request that the user intends to close the
// window. The client may choose to ignore this request, or show
// a dialog to ask the user to save their data, etc.
	close: nullable *toplevel_close_cb,
// The configure_bounds event may be sent prior to a xdg_toplevel.configure
// event to communicate the bounds a window geometry size is recommended
// to constrain to.
// 
// The passed width and height are in surface coordinate space. If width
// and height are 0, it means bounds is unknown and equivalent to as if no
// configure_bounds event was ever sent for this surface.
// 
// The bounds can for example correspond to the size of a monitor excluding
// any panels or other shell components, so that a surface isn't created in
// a way that it cannot fit.
// 
// The bounds may change at any point, and in such a case, a new
// xdg_toplevel.configure_bounds will be sent, followed by
// xdg_toplevel.configure and xdg_surface.configure.
	configure_bounds: nullable *toplevel_configure_bounds_cb,
// This event advertises the capabilities supported by the compositor. If
// a capability isn't supported, clients should hide or disable the UI
// elements that expose this functionality. For instance, if the
// compositor doesn't advertise support for minimized toplevels, a button
// triggering the set_minimized request should not be displayed.
// 
// The compositor will ignore requests it doesn't support. For instance,
// a compositor which doesn't advertise support for minimized will ignore
// set_minimized requests.
// 
// Compositors must send this event once before the first
// xdg_surface.configure event. When the capabilities change, compositors
// must send this event again and then send an xdg_surface.configure
// event.
// 
// The configured state should not be applied immediately. See
// xdg_surface.configure for details.
// 
// The capabilities are sent as an array of 32-bit unsigned integers in
// native endianness.
	wm_capabilities: nullable *toplevel_wm_capabilities_cb,
};

export fn toplevel_add_listener(
	o: *toplevel,
	listener: *toplevel_listener,
	userdata: nullable *opaque,
) void = {
	assert(o.listener == null, "Attempted to set listener twice on one Wayland object");
	o.listener = listener;
	o.userdata = userdata;
};

// 
export type xdg_toplevel_error = enum u32 {
	INVALID_RESIZE_EDGE = 0,
	INVALID_PARENT = 1,
	INVALID_SIZE = 2,
};

// These values are used to indicate which edge of a surface
// is being dragged in a resize operation.
export type xdg_toplevel_resize_edge = enum u32 {
	NONE = 0,
	TOP = 1,
	BOTTOM = 2,
	LEFT = 4,
	TOP_LEFT = 5,
	BOTTOM_LEFT = 6,
	RIGHT = 8,
	TOP_RIGHT = 9,
	BOTTOM_RIGHT = 10,
};

// The different state values used on the surface. This is designed for
// state values like maximized, fullscreen. It is paired with the
// configure event to ensure that both the client and the compositor
// setting the state can be synchronized.
// 
// States set in this way are double-buffered, see wl_surface.commit.
export type xdg_toplevel_state = enum u32 {
	MAXIMIZED = 1,
	FULLSCREEN = 2,
	RESIZING = 3,
	ACTIVATED = 4,
	TILED_LEFT = 5,
	TILED_RIGHT = 6,
	TILED_TOP = 7,
	TILED_BOTTOM = 8,
	SUSPENDED = 9,
	CONSTRAINED_LEFT = 10,
	CONSTRAINED_RIGHT = 11,
	CONSTRAINED_TOP = 12,
	CONSTRAINED_BOTTOM = 13,
};

// 
export type xdg_toplevel_wm_capabilities = enum u32 {
	WINDOW_MENU = 1,
	MAXIMIZE = 2,
	FULLSCREEN = 3,
	MINIMIZE = 4,
};

// A popup surface is a short-lived, temporary surface. It can be used to
// implement for example menus, popovers, tooltips and other similar user
// interface concepts.
// 
// A popup can be made to take an explicit grab. See xdg_popup.grab for
// details.
// 
// When the popup is dismissed, a popup_done event will be sent out, and at
// the same time the surface will be unmapped. See the xdg_popup.popup_done
// event for details.
// 
// Explicitly destroying the xdg_popup object will also dismiss the popup and
// unmap the surface. Clients that want to dismiss the popup when another
// surface of their own is clicked should dismiss the popup using the destroy
// request.
// 
// A newly created xdg_popup will be stacked on top of all previously created
// xdg_popup surfaces associated with the same xdg_toplevel.
// 
// The parent of an xdg_popup must be mapped (see the xdg_surface
// description) before the xdg_popup itself.
// 
// The client must call wl_surface.commit on the corresponding wl_surface
// for the xdg_popup state to take effect.
export type popup = struct {
	object: wayland::object,
	listener: nullable *popup_listener,
	userdata: nullable *opaque,
};

export fn popup_obj_init(c: *wayland::client) (*wayland::object | nomem) = {
	let o = wayland::object{id = 0, client = c, iface = &popup_interface};
	let r = alloc(popup {
		object = o,
		...
	})?;
	return r;
};

export fn popup_obj_finish(o: *wayland::object) void = {
	free(o);
};

export const popup_interface = wayland::interface {
	name = "xdg_popup",
	version = 7,
	requests = [
		wayland::request {
			name = "destroy",
			since = 0,
			type_ = "destructor",
			args = [
			],
		},
		wayland::request {
			name = "grab",
			since = 0,
			type_ = "",
			args = [
				wayland::argument {
					name = "seat",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "wl_seat",
					allownull = false,
				},
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
			name = "reposition",
			since = 3,
			type_ = "",
			args = [
				wayland::argument {
					name = "positioner",
					type_ = wayland::argtype::OBJECT,
					enum_ = "",
					interface = "xdg_positioner",
					allownull = false,
				},
				wayland::argument {
					name = "token",
					type_ = wayland::argtype::UINT,
					enum_ = "",
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
					name = "x",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "y",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "width",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
				wayland::argument {
					name = "height",
					type_ = wayland::argtype::INT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
			cb = &popup_configure_unmarshal,
		},
		wayland::event {
			name = "popup_done",
			since = 0,
			type_ = "",
			args = [
			],
			cb = &popup_popup_done_unmarshal,
		},
		wayland::event {
			name = "repositioned",
			since = 3,
			type_ = "",
			args = [
				wayland::argument {
					name = "token",
					type_ = wayland::argtype::UINT,
					enum_ = "",
					interface = "",
					allownull = false,
				},
			],
			cb = &popup_repositioned_unmarshal,
		},
	],
	enums = [
	],
	init = &popup_obj_init,
	finish = &popup_obj_finish,
};

// This destroys the popup. Explicitly destroying the xdg_popup
// object will also dismiss the popup, and unmap the surface.
// 
// If this xdg_popup is not the "topmost" popup, the
// xdg_wm_base.not_the_topmost_popup protocol error will be sent.
export fn popup_destroy(obj: *popup) void = {
	let buf = memio::dynamic();
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "destroy")!;
	};
	match (wayland::queue_request(obj, 0, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// This request makes the created popup take an explicit grab. An explicit
// grab will be dismissed when the user dismisses the popup, or when the
// client destroys the xdg_popup. This can be done by the user clicking
// outside the surface, using the keyboard, or even locking the screen
// through closing the lid or a timeout.
// 
// If the compositor denies the grab, the popup will be immediately
// dismissed.
// 
// This request must be used in response to some sort of user action like a
// button press, key press, or touch down event. The serial number of the
// event should be passed as 'serial'.
// 
// The parent of a grabbing popup must either be an xdg_toplevel surface or
// another xdg_popup with an explicit grab. If the parent is another
// xdg_popup it means that the popups are nested, with this popup now being
// the topmost popup.
// 
// Nested popups must be destroyed in the reverse order they were created
// in, e.g. the only popup you are allowed to destroy at all times is the
// topmost one.
// 
// When compositors choose to dismiss a popup, they may dismiss every
// nested grabbing popup as well. When a compositor dismisses popups, it
// will follow the same dismissing order as required from the client.
// 
// If the topmost grabbing popup is destroyed, the grab will be returned to
// the parent of the popup, if that parent previously had an explicit grab.
// 
// If the parent is a grabbing popup which has already been dismissed, this
// popup will be immediately dismissed. If the parent is a popup that did
// not take an explicit grab, an error will be raised.
// 
// During a popup grab, the client owning the grab will receive pointer
// and touch events for all their surfaces as normal (similar to an
// "owner-events" grab in X11 parlance), while the top most grabbing popup
// will always have keyboard focus.
export fn popup_grab(obj: *popup, seat_: *wl::seat, serial_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, (seat_: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, serial_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "grab", seat_: *wayland::object, serial_)!;
	};
	match (wayland::queue_request(obj, 1, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

// Reposition an already-mapped popup. The popup will be placed given the
// details in the passed xdg_positioner object, and a
// xdg_popup.repositioned followed by xdg_popup.configure and
// xdg_surface.configure will be emitted in response. Any parameters set
// by the previous positioner will be discarded.
// 
// The passed token will be sent in the corresponding
// xdg_popup.repositioned event. The new popup position will not take
// effect until the corresponding configure event is acknowledged by the
// client. See xdg_popup.repositioned for details. The token itself is
// opaque, and has no other special meaning.
// 
// If multiple reposition requests are sent, the compositor may skip all
// but the last one.
// 
// If the popup is repositioned in response to a configure event for its
// parent, the client should send an xdg_positioner.set_parent_configure
// and possibly an xdg_positioner.set_parent_size request to allow the
// compositor to properly constrain the popup.
// 
// If the popup is repositioned together with a parent that is being
// resized, but not in response to a configure event, the client should
// send an xdg_positioner.set_parent_size request.
export fn popup_reposition(obj: *popup, positioner_: *positioner, token_: u32) void = {
	let buf = memio::dynamic();
	wayland::marshal_u32(obj.object.client, &buf, (positioner_: *wayland::object).id);
	wayland::marshal_u32(obj.object.client, &buf, token_);
	if (obj.object.client.debug) {
		wayland::debug_request(obj, "reposition", positioner_: *wayland::object, token_)!;
	};
	match (wayland::queue_request(obj, 2, memio::buffer(&buf))) {
	case void => void;
	case let e: io::error => fmt::fatal("I/O error: {}", io::strerror(e));
	};
};

export type popup_configure_cb = fn(userdata: nullable *opaque, obj: *popup, x_: i32, y_: i32, width_: i32, height_: i32) void;

export fn popup_configure_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *popup;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_x: i32 = wayland::unmarshal_i32(conn, &buf);
	let ev_arg_y: i32 = wayland::unmarshal_i32(conn, &buf);
	let ev_arg_width: i32 = wayland::unmarshal_i32(conn, &buf);
	let ev_arg_height: i32 = wayland::unmarshal_i32(conn, &buf);
	match (obj.listener) {
	case let l: *popup_listener =>
		match (l.configure) {
		case let cb: *popup_configure_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "configure", ev_arg_x, ev_arg_y, ev_arg_width, ev_arg_height)!;
			};
			cb(obj.userdata, obj, ev_arg_x, ev_arg_y, ev_arg_width, ev_arg_height);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

export type popup_popup_done_cb = fn(userdata: nullable *opaque, obj: *popup) void;

export fn popup_popup_done_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *popup;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	match (obj.listener) {
	case let l: *popup_listener =>
		match (l.popup_done) {
		case let cb: *popup_popup_done_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "popup_done")!;
			};
			cb(obj.userdata, obj);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

export type popup_repositioned_cb = fn(userdata: nullable *opaque, obj: *popup, token_: u32) void;

export fn popup_repositioned_unmarshal(id: wayland::object_id, conn: *wayland::client) void = {
	let obj = match (wayland::registry_get(&conn.registry, id)) {
	case let o: *wayland::object =>
		yield o: *popup;
	case null =>
		fmt::fatal("callback for unregistered object id");
	};
	let buf = memio::fixed(conn.mbuf[8..]);
	let ev_arg_token: u32 = wayland::unmarshal_u32(conn, &buf);
	match (obj.listener) {
	case let l: *popup_listener =>
		match (l.repositioned) {
		case let cb: *popup_repositioned_cb =>
			if (conn.debug) {
				wayland::debug_cb(obj, "repositioned", ev_arg_token)!;
			};
			cb(obj.userdata, obj, ev_arg_token);
		case null =>
			yield;
		};
	case =>
		yield;
	};
};

// a set of callback functions for [[popup]]
export type popup_listener = struct {
// This event asks the popup surface to configure itself given the
// configuration. The configured state should not be applied immediately.
// See xdg_surface.configure for details.
// 
// The x and y arguments represent the position the popup was placed at
// given the xdg_positioner rule, relative to the upper left corner of the
// window geometry of the parent surface.
// 
// For version 2 or older, the configure event for an xdg_popup is only
// ever sent once for the initial configuration. Starting with version 3,
// it may be sent again if the popup is setup with an xdg_positioner with
// set_reactive requested, or in response to xdg_popup.reposition requests.
	configure: nullable *popup_configure_cb,
// The popup_done event is sent out when a popup is dismissed by the
// compositor. The client should destroy the xdg_popup object at this
// point.
	popup_done: nullable *popup_popup_done_cb,
// The repositioned event is sent as part of a popup configuration
// sequence, together with xdg_popup.configure and lastly
// xdg_surface.configure to notify the completion of a reposition request.
// 
// The repositioned event is to notify about the completion of a
// xdg_popup.reposition request. The token argument is the token passed
// in the xdg_popup.reposition request.
// 
// Immediately after this event is emitted, xdg_popup.configure and
// xdg_surface.configure will be sent with the updated size and position,
// as well as a new configure serial.
// 
// The client should optionally update the content of the popup, but must
// acknowledge the new popup configuration for the new position to take
// effect. See xdg_surface.ack_configure for details.
	repositioned: nullable *popup_repositioned_cb,
};

export fn popup_add_listener(
	o: *popup,
	listener: *popup_listener,
	userdata: nullable *opaque,
) void = {
	assert(o.listener == null, "Attempted to set listener twice on one Wayland object");
	o.listener = listener;
	o.userdata = userdata;
};

// 
export type xdg_popup_error = enum u32 {
	INVALID_GRAB = 0,
};
