$fn = 144;

lat_rad = 75;
horiz_rad = 50;

chest_wid = 180;
chest_hgt = 160;
chest_up_a = 22.5;
chest_low_a = 7.5;
chest_lat_a = 22.5;

plate_wid = 310;

corn_rad = 10;

chest_thk = 8;

bev_edge = 1;


flange_wid = 15;
flange_clr_int = 0.2;
flange_clr_ext = 0.1;


mag_r = 10/2+0.2;
mah_h = 2;

*chest_plate() translate([-200,0,-100]) cube([400,200,200]);

*union() {
    chest_plate() int_a_segment();
    translate([10,0,0]) support_leg_int();
    translate([95,0,0]) support_leg_ext();
}
!union() {
    chest_plate() int_b_segment();
    translate([-10,0,0]) support_leg_int();
    translate([-95,0,0]) support_leg_ext();
}

module chest_plate() difference() {
    union() {
        //chest shape
        intersection() {
            //outside bevel
            hull() for(ib=[0,bev_edge]) intersection() {
                chest_shape(chest_thk-(bev_edge-ib));
                chest_shape_int(-ib);
            }
        
            //intersect segment
            children();
        }
        
        //bosses for magnets to mate DCU
        intersection() {
            dcu_chest_magnet_loc() {
                rotate([-90,0,0]) rotate_extrude() hull() {
                    translate([0,-2*2.5-50]) square([mag_r+5,2*2.5+50]);
                    translate([mag_r+5,-2.5]) circle(r=2.5);
                    translate([mag_r+5+50,-2.5-50]) circle(r=2.5);
                }
            }
            
            translate([-200,0,-(chest_hgt/2-0.4)]) cube([400,200,2*(chest_hgt/2-0.4)]);
            
            //intersect segment
            children();
        }
    }
    
    //cutout inside of chest shape
    chest_shape(0);
    
    //inside bevels
    union() {
        //%chest_shape_int_trans() rotate([-90,0,0]) cylinder(r=corn_ra d,h=400);
            
        for(ia=[90+60:((180)-(90+60))/($fn/4):180]) hull() for(ib=[0,0.4]) intersection() {
            chest_shape(ib);
            for(ixm=[0,1]) mirror([ixm,0,0]) chest_shape_int_trans([40],undef) {
                rotate([0,-ia,0]) translate([-200,0,-100-corn_rad+(0.4-ib)]) cube([400,200,100]);
            }
        }
        for(ia=[90:((90+60)-(90))/($fn/4):90+60]) hull() for(ib=[0,0.4]) intersection() {
            chest_shape(ib);
            for(ixm=[0,1]) mirror([ixm,0,0]) chest_shape_int_trans([0],undef) {
                rotate([0,-ia,0]) translate([-200,0,-100-corn_rad+(0.4-ib)]) cube([400,200,100]);
            }
        }  
        for(ia=[90-22.5:((90)-(90-22.5))/($fn/4):90]) hull() for(ib=[0,0.4]) intersection() {
            chest_shape(ib);
            for(ixm=[0,1]) mirror([ixm,0,0]) chest_shape_int_trans(undef,[0]) {
                rotate([0,-ia,0]) translate([-200,0,-100-corn_rad+(0.4-ib)]) cube([400,200,100]);
            }
        }
        for(ia=[0:((90-22.5)-(0))/($fn/4):90-22.5]) if(ia==0||ia>=45) hull() for(ib=[0,0.4]) intersection() {
            chest_shape(ib);
            for(ixm=[0,1]) mirror([ixm,0,0]) chest_shape_int_trans(undef,[40]) {
                rotate([0,-ia,0]) translate([-200,0,-100-corn_rad+(0.4-ib)]) cube([400,200,100]);
            }
        }
    }
    
    //cutout flange screws
    for(iz=[-1,0,1]*(chest_hgt/2)-[-1,0,1]*(flange_wid/2+5)) for(ix=[0]) {
        intersection() {
            translate([ix,0,iz]) rotate([-90,0,0]) cylinder(r=1.25,h=200);
            chest_shape(chest_thk-1.6);
        }
        //bevel for countsunk screw head
        //this whole mess is so we can have the bevel axially aligned, but not have to do a fuckton of trig to work out how deep it needs to be
        hull() {
            for(ia=[0:360/($fn/2):360-360/($fn/2)]) translate([ix,0,iz]) rotate([0,ia,0]) translate([0,-3,3+3]) translate([0,0,-iz]) intersection() {
                translate([0,0,iz]) rotate([-90,0,0]) cylinder(r=0.01,h=200);
                chest_shape(0);
            }
            translate([0,3,0]) intersection() {
                translate([ix,0,iz]) rotate([-90,0,0]) cylinder(r=0.01,h=200);
                chest_shape(0);
            }
        }
    }
    
    //cutout flange screws
    /*union() {
        screw_z = chest_hgt/2-flange_wid/2-5;
        
        translate([0,lat_rad-horiz_rad-(screw_z-horiz_rad*sin(chest_up_a))*tan(chest_up_a),screw_z-horiz_rad*sin(chest_up_a)]) rotate([chest_up_a,0,0]) flange_screw_co();
        
        translate([0,lat_rad-horiz_rad,0]) flange_screw_co();
        
        translate([0,lat_rad-horiz_rad-(screw_z-horiz_rad*sin(chest_low_a))*tan(chest_low_a),-(screw_z-horiz_rad*sin(chest_low_a))]) rotate([-chest_low_a,0,0]) flange_screw_co();
    }*/
    
    //cutout for magnets
    dcu_chest_magnet_loc() {
        rotate([90,0,0]) translate([0,0,0.8]) {
            hull() {
                cylinder_oh(mag_r-0.2,50);
                translate([0,0,0.2]) cylinder_oh(mag_r,50);
            }
            
            translate([0,0,mah_h]) hull() {
                cylinder_oh(mag_r,50);
                translate([0,0,2]) cylinder_oh(mag_r+2,50);
            }
            translate([0,0,mah_h+2+5]) hull() {
                cylinder_oh(mag_r+2,50);
                translate([0,0,20]) cylinder_oh(mag_r+2+20,50);
            }
        }
    }
    *dcu_chest_magnet_loc_int(false,0.4-ib) {
        //bevel
        hull() for(ib=[0,0.4]) intersection() {
            //rotate([90,0,0]) translate([0,0,0.8]) cylinder_oh(mag_r+2+ib,50);
            chest_shape(0.4-ib);
        }
    }
    
    //cutout holes for elastic cord
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        //upper holes (up to torso)
        for(iy=[[5],[40-5]]) {
            //hole
            chest_shape_int_trans(iy,undef) rotate([-90,0,0]) hull() cylinder_oh(2.5,400);
            
            //inset to create space for cord
            hull() for(ib=[0,2.5]) intersection() {
                chest_shape_int_trans(iy,undef) rotate([-90,0,0]) hull() {
                    cylinder(r=5+ib,h=400);
                    rotate([0,0,-60]) translate([20,0,0]) cylinder(r=5+ib,h=400);
                }
                chest_shape(2.5-ib);
            }
            
            //inner bevel
            hull() for(ib=[0,0.4]) intersection() {
                chest_shape_int_trans(iy,undef) rotate([-90,0,0]) hull() cylinder_oh(2.5+ib,400);
                chest_shape(2.5+(0.4-ib));
            }
            
            //outer bevel
            hull() for(ib=[-1,1+1]) difference() {
                chest_shape_int_trans(iy,undef) rotate([-90,0,0]) hull() cylinder_oh(2.5+ib,400);
                chest_shape(chest_thk-(1-ib));
            }
        }
        
        //lower holes (around to back)
        for(iy=[[0],[20],[40]]) {
            //hole
            chest_shape_int_trans(undef,iy) rotate([-90,0,0]) hull() cylinder_oh(2.5,400);
            
            //inset to create space for cord
            hull() for(ib=[0,2.5]) intersection() {
                chest_shape_int_trans(undef,iy) rotate([-90,0,0]) hull() {
                    cylinder(r=5+ib,h=400);
                    rotate([0,0,22.5]) translate([20,0,0]) cylinder(r=5+ib,h=400);
                }
                chest_shape(2.5-ib);
            }
            
            //inner bevel
            hull() for(ib=[0,0.4]) intersection() {
                chest_shape_int_trans(undef,iy) rotate([-90,0,0]) hull() cylinder_oh(2.5+ib,400);
                chest_shape(2.5+(0.4-ib));
            }
            
            //outer bevel
            hull() for(ib=[-1,1+1]) difference() {
                chest_shape_int_trans(undef,iy) rotate([-90,0,0]) hull() cylinder_oh(2.5+ib,400);
                chest_shape(chest_thk-(1-ib));
            }
        }
    }
}

module int_a_segment() {
    translate([flange_wid/2,0,-chest_hgt/2]) cube([200,200,chest_hgt]);
    
    //flange positive
    intersection() {
        chest_shape(2.4);
        translate([-flange_wid/2+flange_clr_int,0,-chest_hgt/2]) cube([200,200,chest_hgt]);
    }
}

module int_b_segment() difference() {
    translate([-200+flange_wid/2-flange_clr_ext,0,-chest_hgt/2]) cube([200,200,chest_hgt]);
    
    //flange recess
    intersection() {
        chest_shape(2.4);
        translate([-flange_wid/2,0,-100]) cube([200,200,200]);
    }
}

module dcu_chest_magnet_loc(onlyhalf=false) {
    rotate([7.5,0,0]) translate([0,chest_thk+lat_rad+2.5,-10]) dcu_magnet_loc(onlyhalf) children();
}

module dcu_chest_magnet_loc_int(onlyhalf=false,chest_outset=0) intersection() {
}

module dcu_magnet_loc(onlyhalf=false) {
    for(ix=(onlyhalf?[25,75]:[-75,-25,25,75])) for(iz=[-40,40]) translate([ix,0,iz]) children();
}

module chest_shape(outset=0) {
    hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([chest_wid/2,0,0]) {
        rotate([chest_up_a,0,0]) rotate([0,0,chest_lat_a]) translate([0,-(lat_rad-horiz_rad),0]) rotate([-chest_up_a,0,0]) {
            rotate([chest_up_a,0,0]) translate([0,lat_rad-horiz_rad,0]) cylinder(r=lat_rad+outset,h=400,$fn=$fn*2);
            rotate([0,90,0]) rotate([0,0,90-chest_low_a]) rotate_extrude(angle=chest_up_a+chest_low_a,$fn=$fn*2) intersection() {
                translate([-horiz_rad+lat_rad,0]) circle(r=lat_rad+outset);
                translate([0,-(lat_rad+outset)]) square([200,2*(lat_rad+outset)]);
            }
            rotate([-chest_low_a,0,0]) translate([0,lat_rad-horiz_rad,-400]) cylinder(r=lat_rad+outset,h=400,$fn=$fn*2);
        }
    }
}

module chest_shape_int(outset=0) {
    hull() for(ixm=[0,1]) mirror([ixm,0,0]) {
        chest_shape_int_trans([0,40],[0]) rotate([-90,0,0]) cylinder(r=corn_rad+outset,h=400);
        chest_shape_int_trans(undef,[40]) rotate([-90,0,0]) hull() cylinder_oh(corn_rad+outset,400);
    }
}

module chest_shape_int_trans(up_iy=[0,40],low_iy=[0,40]) {
    translate([plate_wid/2-lat_rad*tan(30),0,0]) rotate([0,0,-30]) {
        for(iy=up_iy) translate([-iy*sin(60),0,(chest_hgt/2-corn_rad)-(40-iy)*cos(60)]) children();
        for(iy=low_iy) translate([-iy*sin(22.5),0,-(chest_hgt/2-corn_rad)+(40-iy)*cos(22.5)]) children();
    }
}

/*module flange_screw_co() {
    rotate([-90,0,0]) {
        hull() {
            cylinder_oh(1.25-0.5,horiz_rad+chest_thk-1.6);
            cylinder_oh(1.25,horiz_rad+chest_thk-1.6-0.5);
        }
        hull() {
            cylinder_oh(1.5+0.15,horiz_rad+2.4);
            cylinder(r=0.01,h=horiz_rad+2.5+1.5+0.15);
        }
        hull() {
            cylinder_oh(3,horiz_rad);
            cylinder(r=0.01,h=horiz_rad+3);
        }
    }
}*/

module support_leg_int() {
    leg_len = 18+0.4;

    intersection() {
        translate([0,69,-chest_hgt/2]) for(iz=[0:2:leg_len-0.4]) hull() {
            translate([0,0,iz]) cylinder(r=0.4,h=0.4);
            translate([0,200,iz]) cylinder(r=0.4,h=0.4);
        }
        chest_shape(chest_thk/2);
    }
    
    translate([0,69,-chest_hgt/2]) hull() {
        translate([0,0,0]) cylinder(r=1.2,h=leg_len);
        translate([0,-leg_len,0]) cylinder(r=1.2,h=0.2);
        translate([0,leg_len*tan(chest_low_a*0.8),leg_len-0.01]) cylinder(r=1.2,h=0.01);
    }
}

module support_leg_ext() {
    leg_len = 18+0.4;

    difference() {
        translate([0,69+12.5,-chest_hgt/2]) for(iz=[0:2:leg_len-0.4]) hull() {
            translate([0,iz*tan(chest_low_a*0.8),iz]) cylinder(r=0.4,h=0.4);
            translate([0,-200,iz]) cylinder(r=0.4,h=0.4);
        }
        chest_shape(chest_thk/2);
    }
    
    translate([0,69+12.5,-chest_hgt/2]) hull() {
        translate([0,0,0]) cylinder(r=1.2,h=0.2);
        translate([0,leg_len,0]) cylinder(r=1.2,h=0.2);
        translate([0,leg_len*tan(chest_low_a*0.8),leg_len-0.01]) cylinder(r=1.2,h=0.01);
    }
}


module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}