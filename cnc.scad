include <openscad-openbuilds/hardware/acme_lead_screw_nut.scad>
include <openscad-openbuilds/brackets/angle_corner.scad>
include <openscad-openbuilds/linear_rails/vslot.scad>
include <openscad-openbuilds/plates/vslot_gantry_plate.scad>
include <openscad-openbuilds/plates/motor_mount_plate.scad>
include <openscad-openbuilds/plates/build_plate.scad>
include <openscad-openbuilds/shims_and_spacers/spacer.scad>
include <openscad-openbuilds/shims_and_spacers/shim.scad>
include <openscad-openbuilds/wheels/vwheel.scad>
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
  InnerWidth=Width-40;
  translate([10,0,20])
    rotate([0,90,90])
      Extrusion(20,40,Length);
  translate([Width-10,0,20])
    rotate([0,90,90])
      Extrusion(20,40,Length);
  translate([20,10,20])
    rotate([0,90,0])
      Extrusion(20,40,InnerWidth);
  translate([20,Length-10,20])
    rotate([0,90,0])
      Extrusion(20,40,InnerWidth);
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
  translate([X,Y,-14])
    vwheel();
  translate([X,Y,-9])
    precision_shim();
  translate([X,Y,-8])
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
module Coupler(Diameter) {
  CouplerLength=25;
  color("Blue")
    cylinder(d=Diameter,
      h=CouplerLength);
}
module SainSmart100(Z) {
  /* This is baed on SainSmart 
  100mm linear actuator with ball
  screw.
  https://smile.amazon.com/gp/product/B07DC42DLW/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&th=1
  */
  CarriageWidth=78;
  CarriageHeight=60;
  CouplerLength=25;
  Travel=100;
  ScrewLength=170;
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
  translate([PlateWidth/2, -PlateLength/4,Plate+ScrewLength])
    Coupler(Diameter*2);
  // carriage
  CarriageLength=ExtrusionWidth;
  translate([-(CarriageWidth-
    ExtrusionLength)/2,-CarriageLength,
    Plate+ScrewLength/2-
    CarriageHeight/2+Z]){
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
      hull(){
        cylinder(d=52, h=SpindleHeight);
        cylinder(d=40, h=SpindleHeight+10);
      }
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
}
module CncZPlate(X, Y, Z) {
  translate([X,Y,Z])
    rotate([0,90,270])
      CncGantryPlate();
}
module CncZ(Width, Length, Height, CarriageZ) {
  CarriageZAdjusted=CarriageZ-55;
  GantryY=Length/4*3;
  X=Width/2;
  Y=GantryY+4;
  Z=Height-25;
  AxisToPlateOffset=-10;
  AxisX=X-30;
  AxisY=Y-20;
  AxisZ=Z-50+AxisToPlateOffset;
  translate([AxisX,AxisY,AxisZ])
    SainSmart100(CarriageZAdjusted);
  SpindleX=AxisX+30;
  SpindleY=AxisY-56;
  SpindleZ=AxisZ+20+CarriageZAdjusted;
  translate([SpindleX,SpindleY,SpindleZ])
    Spindle();
  PlateX=X;
  PlateY=Y+12;
  PlateZ=Z+25;
  CncZPlate(PlateX,PlateY,PlateZ);
}
module CncX(Width, Length, Height) {
  // gantry towers
  GantryY=Length/4*3;
  translate([10,GantryY,40])
    rotate([0,0,90])
      Extrusion(20,40,Height);
  translate([Width-10,GantryY,40])
    rotate([0,0,90])
      Extrusion(20,40,Height);
  // x rail
  translate([0,GantryY+30,Height])
    rotate([0,90,0])
      Extrusion(20,40,Width);
      /*
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
      */
  // left corner brackets
  translate([20,GantryY+20,Height-20])
    rotate([-90,0,0])
      angle_corner();
  translate([20,GantryY+20,Height+20])
    angle_corner();
  translate([20,GantryY+20,40])
    angle_corner();
  translate([0,GantryY-20,40])
    rotate([0,0,180])
      angle_corner();
  // right corner brackets
  translate([Width,GantryY+20,Height-20])
    rotate([-90,0,0])
      angle_corner();
  translate([Width,GantryY+20,Height+20])
    angle_corner();
  translate([Width,GantryY+20,40])
    angle_corner();
  translate([Width-20,GantryY-20,40])
    rotate([0,0,180])
      angle_corner();
}
module YVPlate() {
  CncVPlate();
  translate([0,20,0])
    spacer();
  translate([20,0,0])
    spacer();
  translate([-20,0,0])
    spacer();
  translate([0,-20,0])
    spacer();
}
module CncTable(Width, Length, Height, Y) {
  BoardWidth=Width-80;
  BoardLength=Length/2;
  BoardHeight=6;
  ExtrusionWidth=Width/3*2;
  translate([(Width-ExtrusionWidth)/2,Y,80])
    rotate([90,0,90])
      Extrusion(20,60,ExtrusionWidth);
  translate([(Width-BoardWidth)/2,Y-Length/4,90])
    color("Brown")
      cube([BoardWidth,BoardLength,BoardHeight]);
}
module CncY(Width, Length, Height, YParam) {
  Y=YParam+30;
  CouplerLength=25;
  Spread=20;
  HalfSpread=Spread/2;
  TableWidth=Width/4*3;
  TableLength=Length;
  PlateWidth=65.5;
  NutBlockWidth=34;
  NutBlockLength=33;
  RailSpace=PlateWidth+NutBlockWidth;
  Offset=PlateWidth+NutBlockWidth;
  translate([Width/2-Offset/2,0,0]){
    // left rail
    translate([0,Length, 50])
      rotate([90,0,0])
        Extrusion(20,20,Length);
    // right rail
    translate([Offset,Length, 50])
      rotate([90,0,0])
        Extrusion(20,20,Length);
  }
  PlateZ=64;  
//  PlateY=Length/2+Y+PlateWidth-5;
  PlateY=Y;
  // left plate
  translate([Width/2-Offset/2, PlateY, PlateZ])
    YVPlate();
  // right plate
  translate([Width/2+Offset/2,PlateY,PlateZ])
    YVPlate();
  // build area
  CncTable(Width,Length,Height,Y);
  // nut block
  translate([Width/2,Y,PlateZ-10])
    rotate([0,0,0]) {
      acme_lead_screw_nut_block_anti_backlash();
      translate([-10,6.5,12]) spacer();
      translate([10,6.5,12]) spacer();
    }

  // motor plate
  translate([Width/2-20,Length+3,0])
    rotate([90,0,0])
      motor_mount_plate_nema17();
  // motor
  translate([Width/2,Length+3,60])
    rotate([90,0,0])
      stepper_motor_mount(17);
      // motor(model=Nema17);
  // leadscrew
  LeadScrewDiameter=8;
  translate([Width/2,Length-CouplerLength,60])
    rotate([90,0,0])
      color("Silver")
        cylinder(d=LeadScrewDiameter,h=Length-CouplerLength);
  // coupler
  UseCoupler=true;
  if (UseCoupler) {
    translate([Width/2,Length-CouplerLength/2,60])
      rotate([90,0,0])
        Coupler(LeadScrewDiameter * 2);
  }
}
module Cnc() {
  Width = 300;
  Length = 200;
  Height = 250;
  // Use this to move the carriages:
  X=-Width/4; // min
  //X=Width/4; // max
  Y=Length/2;
  //Y=0;
  //Z=75; // max
  /* The tool should be able to cut waste board but not extrusion.  */
  Z=0; // min
  CncBase(Width, Length);
  CncX(Width, Length, Height);
  CncY(Width, Length, Height, Y);
  translate([X,0,0])
    CncZ(Width, Length, Height, Z);
}
Cnc();
