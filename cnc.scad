include <openscad-openbuilds/linear_rails/vslot.scad>
include <openscad-openbuilds/plates/vslot_gantry_plate.scad>
include <openscad-openbuilds/wheels/vwheel.scad>
include <openscad-openbuilds/shims_and_spacers/spacer.scad>
include <openscad-openbuilds/plates/motor_mount_plate.scad>
include <MCAD/motors.scad>

module Extrusion(Y,X,Length) {
  if (IsDetailed) {
    if (X==20)
      vslot20x40(Length);
    if (X==40)
      vslot20x40(Length);
    if (X==60)
      vslot20x60(Length);
  } else {
    translate([-X/2,-Y/2,0])
      cube([X,Y,Length]);
  }
}
module CncStepper(TX, TY, TZ,
  RX, RY, RZ) {
  translate([TX,TY,TZ])rotate([RX,RY,RZ])
    stepper_motor_mount(17);
}
module CncBase(Width, Length) {
  translate([10,0,20])
    rotate([0,90,90])
      Extrusion(20,40,Width);
  translate([Width-10,0,20])
    rotate([0,90,90])
      Extrusion(20,40,Width);
  translate([0,-10,20])
    rotate([0,90,0])
      Extrusion(20,40,Length);
  translate([0,Length+10,20])
    rotate([0,90,0])
      Extrusion(20,40,Length);
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
  translate([Width+3, 40, 0])
    rotate([90,0,270])
  idler_pulley_plate();
  translate([Width-40,Length/2,
    Height+44])
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
  PlateThick=6;
  translate([Width/2,Length/2-40, Height+25])
  rotate([0,90,270])
  CncGantryPlate(Width, 
    Length, Height);
  Offset=60;
  translate([0,0,-40]){
    translate([Width/2,
      Length/2-50,Height])
      Extrusion(20,60,Height/2);
    translate([Width/2-30,
      Length/2-80,Height+Height/2])
      color("#333")
        cube([60,40,PlateThick]);
    translate([Width/2-30,
      Length/2-80,Height-PlateThick])
      color("#333")
        cube([60,40,PlateThick]);
    translate([Width/2,Length/2-70,
      Height]) color("#666") 
      cylinder(d=12,
        h=Height/2);
    CncStepper(Width/2,
      Length/2-70,
      Height+Height/2+PlateThick,
      180,0,0);
    CarriageZ=Height+Height/4;
    CarriageWidth=60;
    CarriageLength=40;
    CarriageHeight=40;
    translate([Width/2-30,
      Length/2-CarriageLength-Offset,
      CarriageZ])
      color("#999")
        cube([CarriageWidth,
          CarriageLength,
          CarriageHeight]);
    SpindleHeight=100;
    translate([Width/2,
      Length/2-80-CarriageLength,
      CarriageZ-SpindleHeight/3])
      color("#666") 
        cylinder(d=52,
          h=SpindleHeight);
    ColletHeight=20;
    translate([Width/2,
      Length/2-80-CarriageLength,
      CarriageZ-SpindleHeight/3
      -ColletHeight])
      color("#222") 
        cylinder(d=12,
          h=ColletHeight);
    EndMillDiameter=3;
    translate([Width/2,
      Length/2-80-CarriageLength,
      CarriageZ-SpindleHeight/3
      -ColletHeight*2])
      color("#336") 
        cylinder(d=EndMillDiameter,
          h=ColletHeight*2);      
  }
}
module CncGantry(Width, Length, Height) {
  CncZ(Width, Length, Height);
  translate([0,Length/2-30,Height+24])
    rotate([0,90,0])
      Extrusion(20,40,Width);
  translate([10,Length/2,44])
    rotate([0,0,90])
      Extrusion(20,40,Height);
  translate([Width-10,Length/2,44])
    rotate([0,0,90])
      Extrusion(20,40,Height);
//  translate([10,Width/2,42])
//    CncVPlate();
//  translate([Width-10,Length/2,42])
//    CncVPlate();
}
module CncTable(Width, Length, Height) {
}
module Cnc() {
  Width = 250;
  Length = 250;
  Height = 250;
  CncBase(Width, Length);
  CncGantry(Width, Length, Height);
  CncMotors(Width, Length, Height);
  CncIdlers(Width, Length, Height);
}
Cnc();