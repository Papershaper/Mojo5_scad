// MOJO 5bar
//include <Getriebe.scad>;  //gear library

$fn=33;
//m3 holes
m3_hr=1.75; //m3  3.5/2
m3_hd=m3_hr*2;
m4_hr=2.15; //m4
m4_hd=m4_hr*2;
post_hd = m3_hd - 0.5;
//bearing
bearing_OD = 22.6;  //perfect for fit(?)
bearing_ID = 8;  //8.2  -- 8 for size
bearing_h = 7;
//servo - MG995
servo_l =40;
servo_w = 20;    // servo_w is the width of a single servo (mg995)
servo_h = 35;
servo_d = 2;
servo_nob_d = 16;
servo_nob_h = 8;
servo_tab = 7;
servo_tab_pos = 8;    // servo_tab_pos (8) is the (x/depth) offset between the axis and where the tabs are.
servo_gear = 6;
servo_hole_d = 2.5;    //hole size for the servo mounting screws. 2 is too small.

//servo arm
servo_arm_h = 5;
servo_arm_l = 40;
servo_pin_d = 2;

link_h = 3;

//servo Mount - holds two servos together in tandem
servo_mount_w = 80;  //depreciated?  --> using servo_l
servo_mount_thick = 18;     // servo_mount_thick is the width of the component (x) deep
servo_mount_h = 10;    // servo_mount_h is the hight of the main block, being reduced now
side_w = 3;

//yaw Mount - holds the servo mount on an axis, supports yaw servo
yaw_space_w = 20;
yaw_space_h = 20;
yaw_mount_w = servo_l+servo_mount_h*2+yaw_space_w;  //servo mount width plus space around it
yaw_mount_h = servo_w*2 + side_w*2 + yaw_space_h; //servo sizing
yaw_mount_thick = servo_mount_thick; // depth x direction around 18
yaw_block = 10; //thickness for the structure mount
yaw_top = 8; //thickness at top for structure
yaw_bottom = 3; //thickenss at bottom

//dowel
dowel_d = 5.25;

//upper leg
servo_hub = 12;
servo_hub_h = 5;
//servo_gear = 6;  //reference
up_leg_l = 70;
up_leg_w = 16;
up_leg_h = 6;
//lower leg
low_leg_l = 20; // from knee
low_leg_w = 8;
low_leg_h = 6;
low_leg_offset = 8; //position of stable screw from end hole
//paw
paw_stem = 25;
paw_stem_d = 24;

//hip cam
hip_cam_r = 20;  //this one drives most of the connector lengths off of axis


module servo(){
    //center the axis - draw vertical
    rotate([180,0,0]){
        translate([-servo_h,-servo_w/2,-servo_w/2]) cube([servo_h, servo_w, servo_l]);
        rotate([0,90,0]) cylinder(d=servo_nob_d, h=servo_nob_h/2);
        rotate([0,90,0]) cylinder(d=servo_nob_d/2, h=servo_nob_h);
        translate([-servo_tab_pos,-servo_w/2,-servo_w/2-servo_tab]) cube([2.7, servo_w, servo_l+(servo_tab*2)]);
    }
}
module servo_arm(){
//part is upside down
    difference(){
        union(){
            hull(){
                translate([0,0,0]) cylinder(d=servo_hub, h=servo_arm_h);
                translate([hip_cam_r,0,0]) cylinder(d=servo_pin_d*3, h=servo_arm_h/2);
            }
        }
        union(){
            translate([0,0,1]) cylinder(d=servo_gear, h=servo_arm_h);  //gear part
            translate([0,0,-1]) cylinder(d=m3_hd, h=servo_arm_h);  //gear part
            translate([hip_cam_r,0,-1]) cylinder(d=servo_pin_d, h=servo_arm_h+2);
        }
    }
}
module cam_link(){
    difference(){
        union(){
            hull(){
                translate([0,0,0]) cylinder(d=servo_pin_d*3, h=link_h);
                translate([hip_cam_r,0,0]) cylinder(d=servo_pin_d*3, h=link_h);
            }
        }
        union(){
            translate([0,0,-1]) cylinder(d=servo_pin_d, h=servo_arm_h+2); 
            translate([hip_cam_r,0,-1]) cylinder(d=servo_pin_d, h=servo_arm_h+2);
        }
    }
}
module upper_leg(){
    difference(){
        union(){
            hull(){
                cylinder(d=up_leg_w,h=up_leg_h);
                translate([70,0,0])cylinder(d=up_leg_w/2,h=up_leg_h);
            }
            cylinder(d=servo_hub,h=up_leg_h+servo_hub_h);
        }
        union(){
            translate([0,0,up_leg_h])cylinder(d=servo_gear,h=servo_hub_h+1);
            translate([70,0,-1])cylinder(d=m3_hd,h=up_leg_h+2);
        }
    }
}
module lower_leg_a(){
    difference(){
        union(){
            hull(){
                translate([-hip_cam_r,0,0])cylinder(d=low_leg_w,h=low_leg_h);
                translate([low_leg_l,0,0])cylinder(d=low_leg_w,h=low_leg_h);
            }
            hull(){
                translate([low_leg_l-low_leg_offset,0,low_leg_h])cylinder(d=low_leg_w,h=low_leg_h);
                translate([low_leg_l,0,low_leg_h])cylinder(d=low_leg_w,h=low_leg_h);
            }
            hull(){
                translate([low_leg_l,0,0])cylinder(d=low_leg_w,h=low_leg_h);
                translate([low_leg_l,0,low_leg_h])cylinder(d=low_leg_w,h=low_leg_h);
                translate([low_leg_l+5,0,paw_stem_d/2+1])rotate([0,90,0])cylinder(d=paw_stem_d+2,h=paw_stem);
            }
        }
        union(){
            translate([0,0,-1])cylinder(d=m3_hd,h=low_leg_h+2);
            translate([-hip_cam_r,0,-1])cylinder(d=m3_hd,h=low_leg_h+2);
            translate([low_leg_l-low_leg_offset,0,-1])cylinder(d=m3_hd,h=low_leg_h*2+2);
            translate([low_leg_l,0,-1])cylinder(d=m3_hd,h=low_leg_h*2+2);
            //paw
            translate([low_leg_l+5,0,paw_stem_d/2+1])rotate([0,90,0])cylinder(d1=paw_stem_d,d2=paw_stem_d-2,h=paw_stem+1);
            //neg half
            translate([low_leg_l-5,-paw_stem_d/2-1,low_leg_h*2])cube([paw_stem+11,paw_stem_d+2,paw_stem_d/2+5]);
        }
    }
}
module lower_leg_b(){
    difference(){
        union(){
            hull(){
                translate([-hip_cam_r,0,0])cylinder(d=low_leg_w,h=low_leg_h);
                translate([low_leg_l,0,0])cylinder(d=low_leg_w,h=low_leg_h);
            }
        }
        union(){
            translate([0,0,-1])cylinder(d=m3_hd,h=low_leg_h+2);
            translate([-hip_cam_r,0,-1])cylinder(d=m3_hd,h=low_leg_h+2);
            translate([low_leg_l-low_leg_offset,0,-1])cylinder(d=m3_hd,h=low_leg_h*2+2);
            translate([low_leg_l,0,-1])cylinder(d=m3_hd,h=low_leg_h*2+2);
        }
    }
}
module hip_cam(){
    tol = 0.8;

    difference(){
        union(){
            hull(){
                cylinder(d=servo_hub+6,h=servo_hub_h);
                translate([hip_cam_r,0,0])cylinder(d=m3_hd+4,h=servo_hub_h);
                translate([0,hip_cam_r,0])cylinder(d=m3_hd+4,h=servo_hub_h);
            }
        }
        union(){
            translate([0,0,-1])cylinder(d=servo_hub+tol,h=servo_hub_h+2);
            //connector holes
            translate([hip_cam_r,0,-1])cylinder(d=m3_hd,h=servo_hub_h+2);
            translate([0,hip_cam_r,-1])cylinder(d=m3_hd,h=servo_hub_h+2);
        }
    }

}


module servo_mount(){
    // V5 \\
    tol = 0.7;
    screw_offset = 3.5;  //side screw offset from BOTH middle and end/tops
    // everything has been offset from the prime servo axis
    // servo_tab_pos (8) is the (x/depth) offset between the axis and where the tabs are.
    // servo_mount_thick is the width of the component (x) deep
    // servo_w is the width of a single servo (mg995)
    // servo_mount_h is the hight of the main block, being reduced now
    difference(){
        union(){
            // main block on end of servo w/servo mount holes
            translate([-servo_mount_thick-servo_tab_pos,-servo_w/2,servo_w/2])cube([servo_mount_thick,servo_w*2+tol,servo_mount_h]);
            //side connect
            translate([-servo_mount_thick-servo_tab_pos,-servo_w/2-side_w,servo_w/2-servo_l-servo_mount_h-tol])cube([servo_mount_thick,side_w,servo_l+servo_mount_h*2+tol]);
        }
        union(){
            //screw mount holes for servo
            translate([-servo_tab_pos+.1,-servo_w/4,servo_tab/2+servo_w/2])rotate([0,-90,0])cylinder(d=servo_hole_d,h=8);
            translate([-servo_tab_pos+.1,+servo_w/4,servo_tab/2+servo_w/2])rotate([0,-90,0])cylinder(d=servo_hole_d,h=8);
            translate([-servo_tab_pos+.1,servo_w/2+servo_w/4,servo_tab/2+servo_w/2])rotate([0,-90,0])cylinder(d=servo_hole_d,h=8);
            translate([-servo_tab_pos+.1,servo_w+servo_w/4,servo_tab/2+servo_w/2])rotate([0,-90,0])cylinder(d=servo_hole_d,h=8);
            //side screw hole
            translate([-servo_tab_pos-screw_offset,-servo_w/2-side_w-1,servo_w/2-servo_l-servo_mount_h+screw_offset-tol])rotate([-90,0,0])cylinder(d=post_hd,h=side_w+2);
            translate([-servo_mount_thick-servo_tab_pos+screw_offset,-servo_w/2-side_w-1,servo_w/2-servo_l-servo_mount_h+screw_offset-tol])rotate([-90,0,0])cylinder(d=post_hd,h=side_w+2);
            //uppers side screw holes
            translate([-servo_tab_pos-screw_offset,servo_w*3/2-7,servo_w/2+servo_mount_h-screw_offset])rotate([-90,0,0])cylinder(d=post_hd,h=7+2);
            translate([-servo_tab_pos-servo_mount_thick+screw_offset,servo_w*3/2-7,servo_w/2+servo_mount_h-screw_offset])rotate([-90,0,0])cylinder(d=post_hd,h=7+2);
            //Yaw Axis Holes for holding the axels (M3: 30mm shaft, 2mm head, 4mm head d)
            translate([-servo_mount_thick/2-servo_tab_pos,+servo_w/2,servo_w/2-1])rotate([0,0,0])cylinder(d=m3_hd, h=30+2+2);  //shaft
            translate([-servo_mount_thick/2-servo_tab_pos,+servo_w/2,servo_w/2-1])rotate([0,0,0])cylinder(d=5+1, h=3+1);  //recess d5+1tol, depth 2=>3 
        }

    }
    
    //servos
    //translate([0,0,0])rotate([0,0,0])color("Tomato", 0.75)servo();
    //translate([0,servo_w,-servo_w])rotate([180,0,0])color("Tomato", 0.75)servo();
   
}
module yaw_mount(){
    //*** V1 ***\\
    // This component holds the servo mount and provides the yaw to the leg
    // oriented around main axis and center for symetry
    //yaw_space_w = 20;
    //yaw_space_h = 20;
    //yaw_mount_w = servo_l+servo_mount_h*2+yaw_space_w;  //servo mount width plus space around it
    //yaw_mount_h = servo_2*2 + side_2*2 + yaw_space_h; //servo sizing
    //yaw_mount_thick = servo_mount_thick; // depth x direction around 18
    //yaw_block = 10; //thickness for the structure mount
    //yaw_top = 8; //thickness at top for structure
    //yaw_bottom = 3; //thickenss at bottomtructure

    difference(){
        union(){
            //sides
            translate([-yaw_mount_thick/2,-yaw_mount_w/2-yaw_block,-yaw_mount_h/2-yaw_bottom])cube([yaw_mount_thick,yaw_block,yaw_mount_h+yaw_bottom]);
            translate([-yaw_mount_thick/2,yaw_mount_w/2,-yaw_mount_h/2-yaw_bottom])cube([yaw_mount_thick,yaw_block,yaw_mount_h+yaw_bottom]);
            //bottom - thin
            translate([-yaw_mount_thick/2,-yaw_mount_w/2,-yaw_mount_h/2-yaw_bottom])cube([yaw_mount_thick,yaw_mount_w,yaw_bottom]);
            //top - thicker for structure
            translate([-yaw_mount_thick/2,-yaw_mount_w/2-yaw_block,yaw_mount_h/2])cube([yaw_mount_thick,yaw_mount_w+yaw_block*2,yaw_top]);
        }
        union(){
            //dowel holes
            translate([-servo_mount_thick/2-servo_tab_pos,servo_w/2,servo_mount_h/2+servo_w/2])rotate([0,-90,0])cylinder(d=dowel_d, h=20);
            translate([-servo_mount_thick/2-servo_tab_pos,servo_w/2-4,servo_mount_h/2+servo_w/2])rotate([45,-90,0])cylinder(d=dowel_d, h=40);
            translate([-servo_mount_thick/2-servo_tab_pos,servo_w/2+4,servo_mount_h/2+servo_w/2])rotate([-45,-90,0])cylinder(d=dowel_d, h=40);
            translate([-servo_mount_thick/2-servo_tab_pos,servo_w/2-4,servo_mount_h/2+servo_w/2])rotate([90,-90,0])cylinder(d=dowel_d, h=40);
            translate([-servo_mount_thick/2-servo_tab_pos,servo_w/2+4,servo_mount_h/2+servo_w/2])rotate([-90,-90,0])cylinder(d=dowel_d, h=40);

        }
    }
}

module layout(){
    //servo();
    //servo_mount();
    yaw_mount();
    //servo_arm();
    //cam_link();
    //upper_leg();
    //lower_leg_a();
    //lower_leg_b();
    //hip_cam();

}

module leg_assembly(){

    //servos
    translate([0,0,0])rotate([0,0,0])color("Tomato", 0.75)servo();
    translate([0,servo_w,-servo_w])rotate([180,0,0])color("Tomato", 0.75)servo();
    //servo mount
    translate([0,0,0])rotate([0,0,0])servo_mount();
    translate([0,servo_w,-20.7])rotate([180,0,0])servo_mount();
    //upper leg
    translate([15,0,0])rotate([0,-90,0])rotate([0,0,-120])color("Yellow", 0.9)upper_leg();
    //cam
    translate([10,0,0])rotate([0,-90,0])rotate([0,0,-30])color("Blue", 0.90)hip_cam();
    //servo arm
    translate([10,20,-20])rotate([0,-90,0])rotate([0,0,40])color("Blue", 0.90)servo_arm();
    //cam link
    translate([13,18,11])rotate([0,-90,0])rotate([0,-0,135])color("Blue", 0.7)cam_link();
}

module assembly(){

}

//[[***** CONSTRUTION  ********]]//
layout();
// leg_assembly();
//assembly();