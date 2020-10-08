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
module CncVPlate() {
  20mm_v_plate();
  translate([-20,-20,-12])
    vwheel();
  translate([-20,-20,-6])
    spacer();
  translate([-20,20,-12])
    vwheel();
  translate([-20,20,-6])
    spacer();
  translate([20,-20,-12])
    vwheel();
  translate([20,-20,-6])
    spacer();
  translate([20,20,-12])
    vwheel();
  translate([20,20,-6])
    spacer();
  
}
module CncGantry(Width, Length, Height) {
  translate([0,Width/2-30,Height+24])
    rotate([0,90,0])
      vslot20x40(Width);
  translate([10,Width/2,45])
    rotate([0,0,90])
      vslot20x40(Height);
  translate([490,Width/2,45])
    rotate([0,0,90])
      vslot20x40(Height);
  translate([10,Width/2,43])
    CncVPlate();
  translate([490,Width/2,43])
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