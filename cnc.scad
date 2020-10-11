include <openscad-openbuilds/linear_rails/vslot.scad>
include <openscad-openbuilds/plates/vslot_gantry_plate.scad>
include <openscad-openbuilds/wheels/vwheel.scad>
include <openscad-openbuilds/shims_and_spacers/spacer.scad>
include <openscad-openbuilds/shims_and_spacers/shim.scad>
include <openscad-openbuilds/plates/motor_mount_plate.scad>
include <openscad-openbuilds/plates/build_plate.scad>
include <MCAD/motors.scad>
IsDetailed=true;
// Render error tolerance.
E=0.01;
// Tolerance.
T=0.5;
module Extrusion(Y,X,Length) {
  if (IsDetailed) {
    vslot(Length,X/20);
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
  CncStepper(0,Length-20,60.5,0,90,180);
  CncStepper(Width,Length-20,60.5,0,90,0);
}
module CncIdlers(Length, Width, Height) {
  translate([0, 40, 0])
    rotate([90,0,270])
  idler_pulley_plate();
  translate([Width+3, 40, 0])
    rotate([90,0,270])
  idler_pulley_plate();
}
module CncWheel(X, Y) {
  translate([X,Y,-12])
    vwheel();
  translate([X,Y,-7])
    precision_shim();
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
module CncGantryPlate() {
  universal_v_plate();
  CncWheel(-30,30);
  CncWheel(-30,-30);
  CncWheel(30,30);
  CncWheel(30,-30);
}
module CncZPlate(Width,
  Length, Height) {
  translate([Width/2,Length/2-42, Height+25])
  rotate([0,90,270])
  CncGantryPlate();
}
module SainSmart100() {
  /* This is baed on SainSmart 
  100mm linear actuator with ball
  screw.
  https://smile.amazon.com/gp/product/B07DC42DLW/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&th=1
  */
  CarriageWidth=78;
  CarriageHeight=60;
  Travel=100;
  ScrewLength=170;
  CouplerLength=25;
  ExtrusionHeight=ScrewLength+
    CouplerLength;
  ExtrusionWidth=30;
  ExtrusionLength=ExtrusionWidth*2;
  Plate=10; // plate thickness
  
  PlateWidth=ExtrusionLength;
  PlateLength=PlateWidth;
  Diameter=12; // ball screw diameter
  PlateY=ExtrusionWidth-PlateLength;
  // bottom plate
  translate([0,PlateY,0])
  color("Black")
    cube([PlateWidth,PlateLength,
      Plate]);
  // extrusion
  translate([0,0,Plate])
    color("Silver")
      cube([ExtrusionLength,
        ExtrusionWidth,
        ExtrusionHeight]);
  // top plate
  translate([0,PlateY,Plate+
    ExtrusionHeight])
    color("Black")
      cube([PlateWidth,PlateLength,
        Plate]);
  // motor
  MotorZ=ExtrusionHeight+Plate*2;
  CncStepper(PlateWidth/2,
    -PlateLength/4,MotorZ,
    180,0,0);
  // screw  
  translate([PlateWidth/2,
    -PlateLength/4,Plate])
    color("Silver")
      cylinder(d=Diameter,
        h=ScrewLength);
  // coupler
  translate([PlateWidth/2,
    -PlateLength/4,Plate+ScrewLength])
    color("Blue")
      cylinder(d=Diameter*2,
        h=CouplerLength);
  // carriage
  CarriageLength=ExtrusionWidth;
  translate([-(CarriageWidth-
    ExtrusionLength)/2,-CarriageLength,
    Plate+ScrewLength/2-
    CarriageHeight/2]){
      color("Silver")
        difference(){
          Slot=CarriageHeight/10;
          cube([CarriageWidth,
            CarriageLength,
            CarriageHeight]);
          translate([0,-E,Slot*3.33-
            Slot/2])
            cube([CarriageWidth,Slot,
              Slot]);
          translate([0,-E,Slot*6.77
            -Slot/2])
            cube([CarriageWidth,Slot,
              Slot]);
        }
      translate([-1,0,0])
        color("Black")
          cube([1,
            CarriageLength,
            CarriageHeight]);
      translate([CarriageWidth,0,0])
        color("Black")
          cube([1,
            CarriageLength,
            CarriageHeight]);
    }
}
//SainSmart100();
module Spindle() {
  SpindleHeight=100;
    color("Gray") 
      cylinder(d=52,
        h=SpindleHeight);
  ColletHeight=20;
  translate([0,0,-ColletHeight])
    color("Black") 
      cylinder(d=12,h=ColletHeight);
  EndMillDiameter=3;
  EndMillHeight=ColletHeight*2;
  translate([0,0,-EndMillHeight])
    color("Navy") 
      cylinder(d=EndMillDiameter,
        h=ColletHeight*2); 
    translate([Width-40,Length/2,
    Height+44])
    rotate([0,0,270])
  idler_pulley_plate();

}
module CncZ(Width, Length, Height) {
  CncZPlate(Width,Length,Height);
  OffsetX=30;
  OffsetY=75;
  OffsetZ=70;
  translate([Width/2-OffsetX,
    Length/2-OffsetY,Height-OffsetZ])
    SainSmart100();
  SpindleX=Width/2;
  SpindleY=Length/2-OffsetY-56;
  SpindleZ=Height-40;
  translate([SpindleX,SpindleY,
    SpindleZ])
    Spindle();
}
module CncX(Width, Length, Height) {
  // gantry towers
  translate([10,Length/2,40])
    rotate([0,0,90])
      Extrusion(20,40,Height);
  translate([Width-10,Length/2,40])
    rotate([0,0,90])
      Extrusion(20,40,Height);
  // x rail
  translate([0,Length/2-30,Height+24])
    rotate([0,90,0])
      Extrusion(20,40,Width);
  // x idler
  translate([Width-40,Length/2,
    Height+44])
    rotate([0,0,270])
      idler_pulley_plate();
  // x motor
  CncStepper(-20,Width/2-20,Height+40,0,0,0);
  // x motor plate
  translate([40,Width/2-40,Height+44])
    rotate([0,0,90])
      motor_mount_plate_nema17();

}
module CncTable(Width, Length, Height) {
  build_plate();
}
module CncY(Width, Length, Height) {
  CncTable(Width, Length, Height);
}
module Cnc() {
  Width = 250;
  Length = 250;
  Height = 250;
  CncBase(Width, Length);
  CncX(Width, Length, Height);
  CncY(Width, Length, Height);
  CncZ(Width, Length, Height);
}
Cnc();
