include <../openscad-openbuilds/linear_rails/vslot.scad>
include <../openscad-openbuilds/plates/vslot_gantry_plate.scad>
include <../openscad-openbuilds/wheels/vwheel.scad>
include <../openscad-openbuilds/shims_and_spacers/spacer.scad>
module CncBase(Width, Length) {
  translate([10,0,20])
    rotate([0,90,90])
      vslot20x40(Width);
  translate([490,0,20])
    rotate([0,90,90])
      vslot20x40(Width);
  translate([0,-10,20])
    rotate([0,90,0])
      vslot20x40(Length);
  translate([0,510,20])
    rotate([0,90,0])
      vslot20x40(Length);
}
module CncWheel(X, Y) {
    translate([X,Y,-11])
    vwheel();
  translate([X,Y,-6])
    spacer();
}
module CncVPlate() {
  20mm_v_plate();
  CncWheel(-20,-20);
  CncWheel(-20,20);
  CncWheel(20,-20);
  CncWheel(20,20);
}
module universal_v_plate() {
  universel_v_plate();
}
module CncGantryPlate(Width, Length, Height) {
  universal_v_plate();
  CncWheel(-30,30);
  CncWheel(-30,-30);
  CncWheel(30,30);
  CncWheel(30,-30);
}
module CncZ(Width, Length, Height) {
  translate([Width/2,Length/2-40, Height+25])
  rotate([0,90,270])
  CncGantryPlate(Width, Length, Height);
  translate([Width/2,Length/2-50,Height/2])
  vslot20x60(Height);
}
module CncGantry(Width, Length, Height) {
  CncZ(Width, Length, Height);
  translate([0,Width/2-30,Height+24])
    rotate([0,90,0])
      vslot20x40(Width);
  translate([10,Width/2,44])
    rotate([0,0,90])
      vslot20x40(Height);
  translate([490,Width/2,44])
    rotate([0,0,90])
      vslot20x40(Height);
  translate([10,Width/2,42])
    CncVPlate();
  translate([490,Width/2,42])
    CncVPlate();
}
module Cnc() {
  Width = 500;
  Length = 500;
  Height = 250;
  CncBase(Width, Length);
  CncGantry(Width, Length, Height);
}
Cnc();