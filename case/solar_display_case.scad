// Wall-mounted case for a Waveshare 7.5" V2 e-paper + XIAO ePaper Board EE04 + LiPo.
//
// Two printed parts:
//   front : tray with display window, panel pocket and M3 heat-set insert posts
//           (print face down)
//   back  : lid with keyholes, battery pocket, board standoffs and pressure pads
//           (print outer face down, already flipped when part = "back")
//
// Coordinates: X/Y as seen from the BACK with the lid removed, origin at the
// bottom-left outer corner. y = 0 is the bottom edge (USB-C, switch, buttons).
// z = 0 is the front face, the lid sits on top at z = tray_h.
//
// Panel values: Waveshare "7.5inch e-Paper V2 Specification" drawing.
// Board values: Seeed's STEP model "XIAO ePaper Display Board EE04 v2".
//
// The panel's FPC tail is only 24 mm long and the EE04's 24-pin connector sits
// on the board edge opposite USB-C/switch/buttons, so the panel connects through
// a 24-pin 0.5 mm FFC extension (adapter + ~10 cm cable).

/* [Part] */
part = "assembly"; // [assembly, open, front, back]

/* [Panel: Waveshare 7.5" V2 raw panel] */
panel_w = 170.2;
panel_h = 111.2;
panel_t = 1.18;      // Waveshare spec
aa_w = 163.2;        // active area
aa_h = 97.92;
aa_left = 3.5;       // active area offset from left/right panel edge
aa_bottom = 9.78;    // active area offset from bottom (FPC) panel edge (top: 3.5)
fpc_gap = 4;         // room below the panel for the FPC to fold back
fpc_from_left = 73.03; // FPC tail (22.04 wide) offset from panel edge, view side unclear in the drawing
fpc_tail_w = 22.04;
window_margin = 0.6; // window is this much larger than the active area per side
window_chamfer = 1.0;

/* [Case] */
clr = 0.4;           // panel pocket clearance per side
border = 8;          // frame width around the panel pocket (holds the posts)
wall = 2;
front_t = 1.6;       // front plate thickness
inner_d = 15;        // inside depth from front plate to lid
lid_t = 3;
corner_r = 4;
lip_h = 2;           // locating lip of the lid
foam_t = 1.0;        // foam tape between pressure pads and panel back

/* [Screws: M3 heat-set inserts + M3 countersunk] */
post_d = 7.5;
insert_d = 4.0;
insert_depth = 6;
screw_d = 3.4;
screw_head_d = 6.2;

/* [Battery: 606090 LiPo, 6 x 60 x 90 mm] */
batt_w = 90;
batt_h = 60;
batt_t = 6;
batt_x = 87;         // lower-left corner of the battery (not the pocket)
batt_y = 30;
batt_clr = 1;
batt_wall = 1.6;

/* [Board: XIAO ePaper Board EE04] */
// Mounted component side towards the panel, I/O edge against the bottom wall.
// "along" = offset along the board's long side from its centre (case X).
board_len = 80.0;
board_wid = 41.23;
board_cx = 42.5;         // board centre, case X
board_edge_y = 2.9;      // PCB I/O edge, case Y: sets how far the parts reach into the wall
standoff_h = 3;          // lid -> PCB back (switch pins stick out 1.9 mm)
standoff_d = 5;
standoff_hole_d = 1.8;   // M2 self-tapping screws, 2.5 mm holes in the PCB
board_holes = [[-37.46, -18.14], [37.45, -18.14], [-37.46, 18.06], [37.45, 18.06]]; // [along, across]
usb_along = 25.64;       // XIAO USB-C
usb_up = 4.3;            // centre height above the PCB back
usb_w = 12.5;            // opening, big enough for a cable overmold
usb_h = 7;
switch_along = -29.68;   // battery ON/OFF slide switch
switch_up = 3.4;
switch_w = 7;
switch_h = 4;
key_along = [8.40, -0.92, -10.27]; // silkscreen KEY1, KEY2, KEY3 -> flexure buttons
reset_along = -19.57;              // RESET -> pin hole
key_up = 3.3;            // button actuator height above the PCB back (checked on the board)
key_tongue_w = 5;
key_tongue_t = 1.0;      // tongue thickness; long + thin = soft, absorbs print tolerance (button travel only ~0.1 mm)
key_slot = 0.6;
key_nub = 0.4;           // nub on the tongue: 0.04 mm short of the plunger (sticks out 0.46 mm, checked)
reset_d = 2;
show_board_model = true; // assembly view: import ref/ee04.stl

/* [Wall mount: keyholes for screws with heads up to 8 mm] */
keyhole_spacing = 100;
keyhole_y_from_top = 28;
keyhole_head_d = 8.5;
keyhole_shank_d = 4.2;
keyhole_slot = 10;

/* [Pressure pads: [x, y] lower-left corners] */
pad_size = 8;

$fn = 48;

// ---------- derived ----------
outer_w = panel_w + 2 * clr + 2 * border;
outer_h = panel_h + 2 * clr + fpc_gap + 2 * border;
tray_h = front_t + inner_d;
panel_x0 = border + clr;
panel_y0 = border + fpc_gap + clr;
board_cy = board_edge_y + board_wid / 2;
board_top = board_edge_y + board_wid;
pcb_back_z = tray_h - standoff_h;
usb_x = board_cx + usb_along;
switch_x = board_cx + switch_along;
// bottom-left post moved above the board, the board occupies that corner
post_pos = [
  [border / 2, board_top + 6],
  [outer_w - border / 2, border / 2],
  [border / 2, outer_h - border / 2],
  [outer_w - border / 2, outer_h - border / 2],
];
keyhole_pos = [for (s = [-1, 1]) [outer_w / 2 + s * keyhole_spacing / 2, outer_h - keyhole_y_from_top]];
pads = [
  [panel_x0 + 6, panel_y0 + panel_h - 6 - pad_size],                      // top left
  [panel_x0 + panel_w - 6 - pad_size, panel_y0 + panel_h - 6 - pad_size], // top right
  [panel_x0 + panel_w - 6 - pad_size, panel_y0 + 6],                      // bottom right
  [panel_x0 + 6, board_top + 6],                                          // left, above the board
];

echo(str("Outer size: ", outer_w, " x ", outer_h, " x ", tray_h + lid_t, " mm"));
// the FPC tail folds back behind the panel; keep the board clear of it (either drawing side)
// (the PCB sits well above the folded tail, so only its parts below matter)
fpc_x_min = panel_x0 + min(fpc_from_left, panel_w - fpc_from_left - fpc_tail_w);
if (board_cx + board_len / 2 > fpc_x_min - 1 && pcb_back_z - 1.51 < front_t + panel_t + 6)
  echo(str("WARNING: board reaches into the FPC tail area (x > ", fpc_x_min - 1, ")"));

// ---------- helpers ----------
module rbox(w, h, d, r) {
  linear_extrude(d) offset(r) offset(-r) square([w, h]);
}

// rounded slot through the bottom wall (y = 0), centred at x / z
module wall_slot(x, z, w, h) {
  translate([x, -1, z]) rotate([-90, 0, 0])
    linear_extrude(wall + 2) offset(min(h, w) / 2 - 0.01) offset(-(min(h, w) / 2 - 0.01))
      square([w, h], center = true);
}

// ---------- front tray ----------
module window() {
  wx = panel_x0 + aa_left - window_margin;
  wy = panel_y0 + aa_bottom - window_margin;
  ww = aa_w + 2 * window_margin;
  wh = aa_h + 2 * window_margin;
  c = window_chamfer;
  hull() {
    translate([wx - c, wy - c, -0.01]) cube([ww + 2 * c, wh + 2 * c, 0.01]);
    translate([wx, wy, c]) cube([ww, wh, 0.01]);
  }
  translate([wx, wy, -0.01]) cube([ww, wh, front_t + 0.02]);
}

module pocket_rim() {
  rim_t = 1.2;
  rim_h = panel_t + 0.4;
  x0 = border; x1 = border + panel_w + 2 * clr;
  y0 = border + fpc_gap; y1 = y0 + panel_h + 2 * clr;
  translate([0, 0, front_t]) {
    translate([x0 - rim_t, y1, 0]) cube([x1 - x0 + 2 * rim_t, rim_t, rim_h]);   // top
    translate([x0 - rim_t, y0, 0]) cube([rim_t, y1 - y0, rim_h]);               // left
    translate([x1, y0, 0]) cube([rim_t, y1 - y0, rim_h]);                       // right
    // short stubs at the bottom, the FPC exits in between
    translate([x0, y0 - rim_t, 0]) cube([12, rim_t, rim_h]);
    translate([x1 - 12, y0 - rim_t, 0]) cube([12, rim_t, rim_h]);
  }
}

// flexure button in the bottom wall: U-slot around a thinned tongue whose free
// end (top) carries a nub that presses the side-actuated button
key_z = pcb_back_z - key_up;
module key_cut(x) {
  z1 = key_z + 2;
  z0 = front_t + 0.6;   // anchor as close to the front plate as possible
  hw = key_tongue_w / 2;
  translate([0, -1, 0]) {
    translate([x - hw - key_slot, 0, z0]) cube([key_slot, wall + 2, z1 - z0 + key_slot]);
    translate([x + hw, 0, z0]) cube([key_slot, wall + 2, z1 - z0 + key_slot]);
    translate([x - hw - key_slot, 0, z1]) cube([key_tongue_w + 2 * key_slot, wall + 2, key_slot]);
  }
  translate([x - hw, -1, z0]) cube([key_tongue_w, 1 + wall - key_tongue_t, z1 - z0]); // thin the tongue from outside
}

module key_nub(x) {
  translate([x - 1.5, wall - 0.01, key_z - 1.5]) cube([3, key_nub + 0.01, 3]);
}

module front() {
  difference() {
    union() {
      difference() {
        rbox(outer_w, outer_h, tray_h, corner_r);
        translate([wall, wall, front_t])
          translate([0, 0, 0]) rbox(outer_w - 2 * wall, outer_h - 2 * wall, tray_h, max(corner_r - wall, 0.5));
      }
      pocket_rim();
      for (p = post_pos) translate([p[0], p[1], front_t]) cylinder(d = post_d, h = inner_d);
      for (a = key_along) key_nub(board_cx + a);
    }
    window();
    for (p = post_pos) translate([p[0], p[1], tray_h - insert_depth]) cylinder(d = insert_d, h = insert_depth + 1);
    wall_slot(usb_x, pcb_back_z - usb_up, usb_w, usb_h);
    wall_slot(switch_x, pcb_back_z - switch_up, switch_w, switch_h);
    for (a = key_along) key_cut(board_cx + a);
    translate([board_cx + reset_along, -1, key_z]) rotate([-90, 0, 0]) cylinder(d = reset_d, h = wall + 2);
  }
}

// ---------- back lid (modelled in assembly position) ----------
module keyhole_cut(p) {
  // through the lid plate: entry hole + slot upwards
  translate([0, 0, tray_h - 0.01]) linear_extrude(lid_t + 0.02) {
    translate(p) circle(d = keyhole_head_d);
    hull() { translate(p) circle(d = keyhole_shank_d); translate(p + [0, keyhole_slot]) circle(d = keyhole_shank_d); }
  }
  // pocket for the screw head inside the boss
  translate([0, 0, tray_h - 3]) linear_extrude(3.01)
    hull() { translate(p) circle(d = keyhole_head_d + 0.5); translate(p + [0, keyhole_slot]) circle(d = keyhole_head_d + 0.5); }
}

module keyhole_boss(p) {
  translate([0, 0, tray_h - 4.5]) linear_extrude(4.51)
    hull() { translate(p) circle(d = keyhole_head_d + 6.5); translate(p + [0, keyhole_slot]) circle(d = keyhole_head_d + 6.5); }
}

module lid_lip() {
  i = wall + 0.3;
  t = 1.2;
  translate([0, 0, tray_h - lip_h]) difference() {
    translate([i, i, 0]) rbox(outer_w - 2 * i, outer_h - 2 * i, lip_h + 0.01, max(corner_r - i, 0.5));
    translate([i + t, i + t, -1]) rbox(outer_w - 2 * (i + t), outer_h - 2 * (i + t), lip_h + 2, max(corner_r - i - t, 0.5));
    translate([-1, -1, -1]) cube([outer_w + 2, i + t + 2, lip_h + 2]);  // open at the bottom (board, USB)
    translate([-1, -1, -1]) cube([board_cx + board_len / 2 + 3, board_top + 4, lip_h + 2]); // clear the board
    for (p = post_pos) translate([p[0], p[1], -1]) cylinder(d = post_d + 1, h = lip_h + 2);
  }
}

module battery_pocket() {
  iw = batt_w + 2 * batt_clr;
  ih = batt_h + 2 * batt_clr;
  translate([batt_x - batt_clr - batt_wall, batt_y - batt_clr - batt_wall, tray_h - batt_t]) difference() {
    cube([iw + 2 * batt_wall, ih + 2 * batt_wall, batt_t + 0.01]);
    translate([batt_wall, batt_wall, -1]) cube([iw, ih, batt_t + 2]);
    translate([-1, batt_wall + ih / 2 - 6, -1]) cube([batt_wall + 2, 12, batt_t + 2]); // cable exit, left side
  }
}

module board_standoffs() {
  for (h = board_holes) translate([board_cx + h[0], board_cy + h[1], pcb_back_z]) difference() {
    cylinder(d = standoff_d, h = standoff_h + 0.01);
    translate([0, 0, -0.01]) cylinder(d = standoff_hole_d, h = standoff_h + lid_t - 0.8);
  }
}

module pressure_pads() {
  z0 = front_t + panel_t + foam_t;
  for (p = pads) translate([p[0], p[1], z0]) cube([pad_size, pad_size, tray_h - z0 + 0.01]);
}

module back_assembled() {
  difference() {
    union() {
      translate([0, 0, tray_h]) rbox(outer_w, outer_h, lid_t, corner_r);
      lid_lip();
      battery_pocket();
      board_standoffs();
      pressure_pads();
      for (p = keyhole_pos) keyhole_boss(p);
    }
    for (p = keyhole_pos) keyhole_cut(p);
    for (h = board_holes)  // screw pilot continues into the lid plate
      translate([board_cx + h[0], board_cy + h[1], tray_h - 0.01]) cylinder(d = standoff_hole_d, h = lid_t - 0.8);
    for (p = post_pos) {
      translate([p[0], p[1], tray_h - 1]) cylinder(d = screw_d, h = lid_t + 2);
      cs = (screw_head_d - screw_d) / 2;
      translate([p[0], p[1], tray_h + lid_t - cs]) cylinder(d1 = screw_d, d2 = screw_head_d, h = cs + 0.01);
    }
  }
}

// ---------- dummies for the assembly view ----------
module dummies() {
  color("white", 0.6) translate([panel_x0, panel_y0, front_t]) cube([panel_w, panel_h, panel_t]);
  color("silver", 0.6) translate([batt_x, batt_y, tray_h - batt_t]) cube([batt_w, batt_h, batt_t]);
  // STEP model coordinates: PCB centred at the origin, I/O edge at -x, components +z
  if (show_board_model)
    color("green") multmatrix([[0, 1, 0, board_cx], [1, 0, 0, board_cy], [0, 0, -1, pcb_back_z], [0, 0, 0, 1]])
      import("ref/ee04.stl");
  else
    color("green", 0.6) translate([board_cx - board_len / 2, board_edge_y, pcb_back_z - 1.51]) cube([board_len, board_wid, 1.51]);
  // FPC tail, folded back behind the panel (both possible drawing sides)
  for (x = [fpc_from_left, panel_w - fpc_from_left - fpc_tail_w])
    color("orange", 0.4) translate([panel_x0 + x, panel_y0 - 2, front_t + panel_t + 2.5]) cube([fpc_tail_w, 18, 0.2]);
}

// ---------- output ----------
if (part == "front") {
  front();
} else if (part == "back") {
  translate([0, outer_h, tray_h + lid_t]) rotate([180, 0, 0]) back_assembled();
} else if (part == "open") {
  color("dimgray") front();
  dummies();
} else {
  color("dimgray") front();
  color("lightgray", 0.8) translate([0, 0, 25]) back_assembled();
  dummies();
}
