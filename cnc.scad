include <openscad-openbuilds/linear_rails/vslot.scad>
include <openscad-openbuilds/plates/vslot_gantry_plate.scad>
include <openscad-openbuilds/wheels/vwheel.scad>
include <openscad-openbuilds/shims_and_spacers/spacer.scad>
include <openscad-openbuilds/plates/motor_mount_plate.scad>
include <MCAD/motors.scad>
module CncStepper(TX, TY, TZ,
  RX, RY, RZ) {
  translate([TX,TY,TZ])rotate([RX,RY,RZ])
    stepper_motor_mount(17);
}
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
module CncMotors(Length, Width, Height){
  translate([0, Width, 0])
    rotate([90,0,270])
      motor_mount_plate_nema17();
    translate([Width+3, Width, 0])
    rotate([90,0,270])
      motor_mount_plate_nema17();
  translate([40,Width/2-40,Height+44])
    rotate([0,0,90])
      motor_mount_plate_nema17();
  CncStepper(0,Length-20,60.5,0,90,180);
  CncStepper(Width,Length-20,60.5,0,90,0);
  CncStepper(-20,Width/2-20,Height+40,0,0,0);
}
module CncIdlers(Length, Width, Height) {
  translate([0, 40, 0])
    rotate([90,0,270])
  idler_pulley_plate();
  translate([503, 40, 0])
    rotate([90,0,270])
  idler_pulley_plate();
  translate([460,Width/2, Height+44])
    rotate([0,0,270])
  idler_pulley_plate();
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
  CncMotors(Width, Length, Height);
  CncIdlers(Width, Length, Height);
}
Cnc();