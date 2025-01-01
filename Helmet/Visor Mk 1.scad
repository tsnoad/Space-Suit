
include <Helmet Mk 1 Include.scad>;

$fn = 36;





vis_arm_z0 = 5;
vis_arm_h = 5;
vis_arm_z1 = vis_arm_z0 + vis_arm_h;

lck_arm_z0 = vis_arm_z1 + clr_v;
lck_arm_h = 7;
lck_arm_z1 = lck_arm_z0 + lck_arm_h;

piv_arm_z0 = lck_arm_z1 + clr_v;
piv_arm_h = 5;
piv_arm_z1 = piv_arm_z0 + piv_arm_h;


mnt_inn_z0 = 0;
mnt_inn_z1 = vis_arm_z0-clr_v;
mnt_inn_z2 = vis_arm_z1;
mnt_inn_h = mnt_inn_z2-mnt_inn_z0;

mnt_out_z0 = mnt_inn_z2;
mnt_out_z1 = lck_arm_z1+clr_v; //ceiling above locking bar
mnt_out_z2 = piv_arm_z1+clr_v; //ceiling above pivot bar
mnt_out_h = mnt_out_z2-mnt_out_z0+5;

//echo(mnt_inn_h);
//echo(mnt_out_z2);

vis_arm_bolt_clr_z0 = vis_arm_z0;
vis_arm_bolt_clr_h = 14;

lck_arm_bolt_clr_z0 = lck_arm_z0;
lck_arm_bolt_clr_h = 14;

piv_arm_bolt_clr_z0 = piv_arm_z0;
piv_arm_bolt_clr_h = 50;

bar_len = 17.5;


//echo(acos((bar_len-(0*17.5)/2)/bar_len));
//echo(acos((bar_len-(1*17.5)/2)/bar_len));

module datum_helmet_from_visor() {
    translate([20,5,0]) {
        rotate([0,-90,0]) rotate([-90,0,0]) {
            translate([-(head_min_rad+5),0,0]) {
                children();
            }
        }
    }
}

module datum_faceplate_from_visor() {
}

module datum_visor_from_helmet() {
    translate([(head_min_rad+5),0,0]) {
        rotate([90,0,0]) rotate([0,90,0]) {
            translate([-20,-5,0]) {
                children();
            }
        }
    }
}

//clearance shape for the visor, relative to the locking bar
*for(j=[0:1/($fn/2):1-1/($fn/2)]) hull() for(i=[j,j+1/($fn/2)]) {
    rotate([-30,0,0]) translate([0,i*17.5,0]) rotate([pow(i,3)*60,0,0]) rotate([30,0,0]) {
        rotate([-acos((bar_len-(i*17.5)/2)/bar_len),0,0]) {
            translate([0,20,5]) translate([0,0,20]) translate([0,40,-100]) cylinder(r=120+5+2.5,h=100+25);
        }
    }
}
 

//align for printing
*visor_arm();
*rotate([0,0,(viewport_w_a/2-viewport_crn_w_a)]) visor_vert_brk();
*!visor_horiz_brk();
*!visor_horiz_brk();

*!for(i=[0,1]) mirror([i,0,0]) translate([-15,i*40,0]) locking_bar(false);
*!pivot_bar();
*!for(i=[0,1]) mirror([i,0,0]) translate([22.5,0,0]) mount_inner();
*!mount_outer();

*union() {
    helmet_simple();
    *translate([0,0,0]) {
        translate([(head_min_rad+5),0,0]) {
            rotate([90,0,0]) rotate([0,90,0]) {
            
                mount_inner();
            }
        }
    }
}

*union() {
    glass_wid = viewport_w_a/360*viewport_crv_d+2*outset_glass;
    glass_hgt = (face_top-face_bottom)+2*(outset_glass);
    
    echo(str("Glass panel width is: ", glass_wid, "mm"));
    echo(str("Glass panel height is: ", glass_hgt, "mm"));
    
    bev_1_x = (viewport_crn_r+outset_glass)*tan(15);
    bev_1_y = viewport_crn_r+outset_glass;
    
    echo(str("Bevel 1 inset is: ", bev_1_x, "mm from side edge (horizontal)"));
    echo(str("Bevel 1 inset is: ", bev_1_y, "mm from bottom edge (vertical)"));
    
    bev_2_x = ((viewport_crn_r+outset_glass)/sin(45)-(viewport_crn_r+outset_glass)*cos(15))/cos(45);
    bev_2_y = bev_2_x;
    
    echo(str("Bevel 2 inset is: ", bev_2_x, "mm from side edge (horizontal)"));
    echo(str("Bevel 2 inset is: ", bev_2_y, "mm from bottom edge (vertical)"));
    
    bev_3_x = bev_1_y;
    bev_3_y = bev_1_x;
    
    echo(str("Bevel 3 inset is: ", bev_3_x, "mm from side edge (horizontal)"));
    echo(str("Bevel 3 inset is: ", bev_3_y, "mm from bottom edge (vertical)"));
    
    //roll_x = viewport_w_a/2*viewport_crv_d/360 + outset_glass;
    roll_x = (viewport_w_a/2-viewport_crn_w_a)*viewport_crv_d/360;
    
    translate([-roll_x,0,0]) {
        translate([-glass_wid/2,rad_vis_seat,face_bottom-outset_glass]) intersection() {
            cube([glass_wid,1,glass_hgt]);
            
            hull() {
                cube([glass_wid-bev_1_x,1,glass_hgt]);
                translate([0,0,bev_1_y]) cube([glass_wid,1,glass_hgt-bev_1_y]);
            }
            
            hull() {
                cube([glass_wid-bev_2_x,1,glass_hgt]);
                translate([0,0,bev_2_y]) cube([glass_wid,1,glass_hgt-bev_2_y]);
            }
            
            hull() {
                cube([glass_wid-bev_3_x,1,glass_hgt]);
                translate([0,0,bev_3_y]) cube([glass_wid,1,glass_hgt-bev_3_y]);
            }
            
        }
    }
    
    rotate([0,0,roll_x/viewport_crv_d*360]) {
        difference() {
            $fn=72;
            intersection() {
                union() {
                    $fn=4*2*3;
                    viewport_shape(outset_glass);
                }
            translate([0,0,-200]) cylinder(r=rad_vis_seat,h=400,$fn=$fn*2);
            }
            translate([0,0,-200]) cylinder(r=rad_vis_seat-1,h=400,$fn=$fn*2);
        }
    }
}
 


$t=0.0;
j = sin(($t*360-90))/2+0.5;

//over-center travel of locking bar
echo(-acos((bar_len-0.25)/bar_len));

*datum_visor_from_helmet() {
    j_vis = j;
    //j_lck = acos((bar_len-(j*17.5)/2)/bar_len);
    
    ot_a = acos((bar_len-0.25)/bar_len);
    
    
            
    lck_rot_min = -acos((bar_len-0.25)/bar_len);
    lck_rot_max = acos((bar_len-17.5/2)/bar_len);
    
    j_lck = j*(lck_rot_max-lck_rot_min)+lck_rot_min;
    
    //j_lck = j*(60+acos((bar_len-0.25)/bar_len)+ot_a)-ot_a;
    //j_vis = 2*(bar_len-cos(j_lck-ot_a)*bar_len)/17.5;
    
    //datum_helmet_from_visor() helmet_simple();

    mount_inner();
    mount_outer();
    
    trans_hinge(j_vis) {
        datum_helmet_from_visor() {
            visor_arm();
        
            translate([0,face_outset,20]) {
                visor_vert_brk();
                for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) visor_horiz_brk();
                visor_glass();
            }
        }
    }
    
    rotate([0,0,30]) translate([2*bar_len,0,0]) {
        pivot_bar_motion(j_lck) {
            *translate([0,0,piv_arm_z0]) pivot_bar();
            
            *bolt_bearings_ph(mnt_out_z2);
            
            translate([bar_len,0,0]) {
                *bolt_bearings_ph(piv_arm_z0);
                
                *locking_bar_motion(j_lck) {
                    translate([-bar_len,0,lck_arm_z0]) locking_bar();
                }
            }
        }
    }
}


module pivot_bar_motion(j_lck) {
    rotate([0,0,180-j_lck]) {
        children();
    }
}

module locking_bar_motion(j_lck) {
    rotate([0,0,180+2*j_lck]) {
        children();
    }
}

//locking bar
//i = j;
i = 0;
*rotate([-30,0,0]) translate([0,i*17.5,0]) rotate([30,0,0]) {
    rotate([acos((bar_len-(i*17.5)/2)/bar_len),0,0]) {
        translate([0,0,-75]) rotate([-15-7.5,0,0]) translate([0,2.5,-10/2]) difference() {
            hull() {
                cylinder(r=120+5+5+5+10,h=10);
                translate([0,40,0]) cylinder(r=120+5+5+5+10,h=10);
            }
            translate([0,0,-1]) hull() {
                cylinder(r=120+5+5+5,h=50);
                translate([0,40,0]) cylinder(r=120+5+5+5,h=50);
            }
            translate([0,0,5]) hull() {
                cylinder(r1=120+5+5+5,r2=120+5+5+5+50,h=50);
                translate([0,40,0]) cylinder(r1=120+5+5+5,r2=120+5+5+5+50,h=50);
            }
            translate([-200,-200,-100]) cube([400,200,200]);
        }
    }
}

module trans_hinge(i) {
    trans_hinge_piv(i) {
        *rotate([0,0,pow(i,2.5)*60]) {
            children();
        }
        union() {
            start = 0.4;
            end = 1.0;
            end_slope = 0;
            
            if(i<start) {
                rotate([0,0,0]) children();
            } else if(i<end) {
                rotate([0,0,pow((i-start)/(end-start),1.2)*60]) children();
            } else {
                rotate([0,0,((1-end_slope*end)+end_slope*i)*60]) children();
            }
        }
        *rotate([0,0,ix*60]) {
            children();
        }
        *union() {
            start = 0.4;
            //end = 0.6;
            
            if(i<start) {
                rotate([0,0,0]) children();
            } else {
                rotate([0,0,(sin(((0.5+start/2)*i-0.25-start/2)*360)/2+0.5)*60]) children();
            }
        }
    }
}

module trans_hinge_piv(i) {
    translate([i*17.5*cos(30),i*17.5*sin(30),0]) {
        children();
    }
}

module trans_A() {
    translate([60,15-5,0]) children();
}

module trans_B() {
    trans_A() rotate([0,0,-30+acos((bar_len-0.25)/bar_len)]) translate([15+20-15,0,0]) children();
}

module trans_C() {
    trans_B() translate([15,-15,0]) children();
}

module trans_D() {
    trans_C() translate([0,-85,0]) children();
}

module trans_l_A() {
    translate([62.5,-(15-5),0]) children();
}

module trans_l_B() {
    trans_l_A() {translate([-2.5,30-2*5,0]) 
        rotate([0,0,-30+acos((bar_len-0.25)/bar_len)]) translate([15+20-10,0,0]) {
            translate([10,-10,0]) 
            translate([-20,-20+20*tan(30-acos((bar_len-0.25)/bar_len)),0]) 
            children();
        }
    }
}
module trans_l_C() {
    trans_D() translate([-20,0,0]) children();
}

module locking_bar(inc_chin_bar=true) {
    difference() {
        union() {
            lck_rot_min = -acos((bar_len-0.25)/bar_len);
            lck_rot_max = acos((bar_len-17.5/2)/bar_len);
             
            hull() {
                cylinder(r=15-bev_s,h=lck_arm_h);
                translate([0,0,bev_s]) cylinder(r=15,h=lck_arm_h-2*bev_s);
                
                translate([17.5,0,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,-(15-10),0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
            }
            hull() {
                translate([17.5-10,-(15-10),0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-10,0,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-10,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-15,-35,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-35,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
            }
            hull() {
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-10,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-55,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
            }
            hull() {
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-55,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-15,-35,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                
                trans_chin_bar_from_locking_bar() translate([120+5+lck_arm_z0,55-35,5]) {
                    translate([0,0,0]) rotate([0,90,0]) {
                        cylinder(r=5-bev_s,h=lck_arm_h);
                        translate([0,0,bev_s]) cylinder(r=5,h=lck_arm_h-2*bev_s);
                    }
                    translate([0,30-2.5,5]) rotate([0,90,0]) {
                        cylinder(r=2.5-bev_s,h=lck_arm_h);
                        translate([0,0,bev_s]) cylinder(r=2.5,h=lck_arm_h-2*bev_s);
                    }
                    translate([0,30-1,-5+1]) rotate([0,90,0]) {
                        cylinder(r=1-bev_s,h=lck_arm_h);
                        translate([0,0,bev_s]) cylinder(r=1,h=lck_arm_h-2*bev_s);
                    }
                }
            }
        }
        
        for(i=[0,bar_len]) translate([i,0,0]) bearing_co(lck_arm_h);
        
        for(j=[0:1/($fn/2):1-1/($fn/2)]) {
            hull() for(i=[j,j+1/($fn/2)]) {
                lck_rot_min = -acos((bar_len-0.25)/bar_len);
                lck_rot_max = acos((bar_len-17.5/2)/bar_len);
            
                //j_lck = i*(60+acos((bar_len-0.25)/bar_len))-acos((bar_len-0.25)/bar_len);
                //j_vis = 2*(bar_len-cos(j_lck)*bar_len)/17.5;
                
                //rotate([0,0,-30]) rotate([0,0,-(acos((bar_len-(i*17.5)/2)/bar_len)-acos((bar_len-0.25)/bar_len))]) {
                
                translate([bar_len,0,0]) rotate([0,0,-2*(lck_rot_min+i*(lck_rot_max-lck_rot_min))]) translate([bar_len,0,0]) {
                    translate([0,0,lck_arm_z1-lck_arm_z0]) {
                        translate([0,0,-2.5]) cylinder(r=5-2.5,h=7.5);
                        cylinder(r=5,h=7.5-2.5);
                    }
                }
            }
        }
        
        //cutout to clear visor bearing bolt
        locking_bar_clearance_visor_bolt() {
            translate([25,0,-lck_arm_z0+vis_arm_bolt_clr_z0]) {
                //cylinder(r=5-2.5,h=10);
                //cylinder(r=5,h=10-2.5);
                cylinder(r=4-2.5,h=7.5);
                cylinder(r=4,h=7.5-2.5);
            }
        }
        *locking_bar_clearance_visor_bolt() {
            translate([25,0,-lck_arm_z0+vis_arm_bolt_clr_z0]) {
                cylinder(r=5-2.5,h=vis_arm_bolt_clr_h);
            }
        }
        
        trans_chin_bar_from_locking_bar() translate([120+5+lck_arm_z0,55-35,5]) {
            hull() for(iy=[5,50]) for(iz=[0,-10]) translate([6,iy,iz]) {
                rotate([0,90,0]) cylinder(r=5+0.2,h=50);
            }
            for(iy=[5,30-5]) translate([6,iy,0]) rotate([0,90,0]) mount_screw_co(10-2);
        }
    }
    
    
    if(inc_chin_bar) trans_chin_bar_from_locking_bar() {
        //translate([120+5+5+5,10,5]) rotate([0,90,0]) cylinder(r=5,h=10);
        //translate([120+5+5+5,20,5]) rotate([0,90,0]) cylinder(r=5,h=10);
        
        chin_bar_side(true);
        chin_bar_side(false);
    }
}

module trans_chin_bar_from_locking_bar() {
    j_lck = -acos((bar_len-0.25)/bar_len);
    
    translate([bar_len,0,-lck_arm_z0]) {
        rotate([0,0,-(180+2*j_lck)]) {
            translate([-bar_len,0,0]) {
                rotate([0,0,-(180-j_lck)]) {
                    translate([-2*bar_len,0,0]) {
                        rotate([0,0,-30]) {
                            datum_helmet_from_visor() {
                                translate([0,-20,-75]) rotate([-15-7.5,0,0]) {
                                    children();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

module chin_bar_side(right_hand_side=true) {
    bar_rad_inner = head_min_rad+5+lck_arm_z0;
    bar_rad_outer = bar_rad_inner+10;
    
    //bar_rad_sides = bar_rad_inner - 40; //use this to make the edges a bit more pointy, so we can get around the visor
    bar_rad_sides = 50;
    bar_rad_sides_y = 30+25;
    
    bar_offset_y = 50;
    
    side_if_y = 55-35;
    
    intersection() {
        difference() {
            $fn = $fn*4;
            
            hull() {
                for(iy=[0,bar_offset_y]) translate([0,iy,0]) {
                    cylinder(r=bar_rad_outer-bev_s,h=10);
                    translate([0,0,bev_s]) cylinder(r=bar_rad_outer,h=10-2*bev_s);
                }
                
                for(ix=[0,1]) mirror([ix,0,0]) translate([-bar_rad_sides+bar_rad_outer,side_if_y+bar_rad_sides_y,0]) {
                    cylinder(r=bar_rad_sides-bev_s,h=10);
                    translate([0,0,bev_s]) cylinder(r=bar_rad_sides,h=10-2*bev_s);
                }
            }
            translate([0,0,-0.01]) {
                //inside cutout
                hull() {
                    for(iy=[0,bar_offset_y]) translate([0,iy,0]) {
                        cylinder(r=bar_rad_inner,h=50);
                    }
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-bar_rad_sides+bar_rad_outer,side_if_y+bar_rad_sides_y,0]) cylinder(r=bar_rad_sides-(bar_rad_outer-bar_rad_inner),h=50);
                }
                //inside bottom bevel
                hull() {
                    for(iy=[0,bar_offset_y]) translate([0,iy,0]) {
                        cylinder(r1=bar_rad_inner+bev_s,r2=bar_rad_inner,h=bev_s);
                    }
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-bar_rad_sides+bar_rad_outer,side_if_y+bar_rad_sides_y,0]) cylinder(r1=bar_rad_sides-(bar_rad_outer-bar_rad_inner)+bev_s,r2=bar_rad_sides-(bar_rad_outer-bar_rad_inner),h=bev_s);
                }
                //inside bottom bevel
                translate([0,0,10-bev_xl+2*0.01]) hull() {
                    for(iy=[0,bar_offset_y]) translate([0,iy,0]) {
                        cylinder(r1=bar_rad_inner,r2=bar_rad_inner+bev_xl,h=bev_xl);
                    }
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-bar_rad_sides+bar_rad_outer,side_if_y+bar_rad_sides_y,0]) cylinder(r1=bar_rad_sides-(bar_rad_outer-bar_rad_inner),r2=bar_rad_sides-(bar_rad_outer-bar_rad_inner)+bev_xl,h=bev_xl);
                }
            }
            
            //cutouts for interface to side locking bar
            for(ix=[0,1]) mirror([ix,0,0]) translate([0,side_if_y,5]) {
                hull() for(iy=[5,30-5]) for(iz=[-10,10]) translate([0,iy,iz]) {
                    rotate([0,90,0]) cylinder(r=5+0.2,h=bar_rad_inner+6);
                }
                for(iy=[5,30-5]) translate([bar_rad_inner+6,iy,0]) rotate([0,90,0]) rotate([0,0,90]) mount_screw_co_oh(4,4-1);
            }
            
            //cutout for screws to join halves of locking bar
            translate([0,bar_offset_y,0]) rotate([0,0,90]) {
                for(i=[-1,1]) rotate([0,0,i*asin(10/bar_rad_outer)]) {
                    translate([bar_rad_inner+6,0,5]) rotate([0,90,0]) rotate([0,0,90]) mount_screw_co_oh(4,4-1);
                }
            }
        }
        
        //interface to create rounded ends at interface with side locking bar
        translate([0,side_if_y,5]) {
            hull() for(iy=[5,200]) for(ix=[0,1]) mirror([ix,0,0]) translate([0,iy,0]) {
                rotate([0,90,0]) {
                    cylinder(r=5,h=bar_rad_outer-bev_s);
                    cylinder(r=5-bev_s,h=bar_rad_outer);
                    
                    if(iy==5) intersection() {
                        rotate([0,0,90]) {
                            cylinder_oh(5,bar_rad_outer-bev_s);
                            cylinder_oh(5-bev_s,bar_rad_outer);
                        }
                        translate([0,-20,0]) cube([20,20,200]);
                    }
                }
            }
        }
        
        
        //create tabs and tab recesses to join both sides
        translate([-0.01,bar_offset_y,-1]) {
            $fn = $fn*4;
            
            if(right_hand_side) {
                difference() {
                    union() {
                        linear_extrude(height=50,convexity=10) polygon([
                            [0,-100],
                            [15+0.1,20],
                            [15+0.1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2))],
                            [15-0.1-1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2))],
                            [200*tan(atan((15-0.1-1)/(bar_rad_outer-4-(1+0.1)))),200],
                            [200,200],
                            [200,-100],
                        ]);
                        difference() {
                            linear_extrude(height=50,convexity=10) polygon([
                                [0,0],
                                [15-0.1-1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2))],
                                [200*tan(atan((15-0.1-1)/(bar_rad_outer-4-(1+0.1)))),200],
                                [-(15-0.1),200],
                                [-(15-0.1),sqrt(pow(bar_rad_outer-4+(1+0.1),2)-pow(15-0.1-1,2))],
                                [-(15-0.1-1),sqrt(pow(bar_rad_outer-4+(1+0.1),2)-pow(15-0.1-1,2))],
                            ]);
                            cylinder(r=bar_rad_outer-4+0.1,h=50);
                        }
                        translate([-(15-0.1-1),sqrt(pow(bar_rad_outer-4+(1+0.1),2)-pow(15-0.1-1,2)),0]) cylinder(r=1,h=50);
                    }
                    translate([15-0.1-1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2)),0]) cylinder(r=1+0.2,h=50);
                }
            } else {
                union() {
                    intersection() {
                        linear_extrude(height=50,convexity=10) polygon([
                            [0,0],
                            [15-0.1,20],
                            [15-0.1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2))],
                            [15-0.1-1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2))],
                            [200*tan(atan((15-0.1-1)/(bar_rad_outer-4-(1+0.1)))),200],
                            [-(15+0.1),200],
                            [-(15+0.1),20],
                        ]);
                        cylinder(r=bar_rad_outer-4-0.1,h=50);
                    }
                    translate([15-0.1-1,sqrt(pow(bar_rad_outer-4-(1+0.1),2)-pow(15-0.1-1,2)),0]) cylinder(r=1,h=50);
                    difference() {
                        linear_extrude(height=50,convexity=10) polygon([
                            [0,-100],
                            [-(15-0.1-1),sqrt(pow(bar_rad_outer-4+(1+0.1),2)-pow(15-0.1-1,2))],
                            [-(15+0.1),sqrt(pow(bar_rad_outer-4+(1+0.1),2)-pow(15-0.1-1,2))],
                            [-(15+0.1),200],
                            [-200,200],
                            [-200,-100],
                        ]);
                        translate([-(15-0.1-1),sqrt(pow(bar_rad_outer-4+(1+0.1),2)-pow(15-0.1-1,2)),0]) cylinder(r=1+0.2,h=50);
                    }
                }
            }
        }
    }
}

module locking_bar_clearance_visor_bolt() {
    for(j=[0:1/($fn/2):1-1/($fn/2)]) {
        hull() for(i=[j,j+1/($fn/2)]) {
            j_lck = i*(60+acos((bar_len-0.25)/bar_len))-acos((bar_len-0.25)/bar_len);
            j_vis = 2*(bar_len-cos(j_lck)*bar_len)/17.5;
            
            //rotate([0,0,-30]) rotate([0,0,-(acos((bar_len-(i*17.5)/2)/bar_len)-acos((bar_len-0.25)/bar_len))]) {
            rotate([0,0,-30]) rotate([0,0,-j_lck]) {
                rotate([0,0,pow(j_vis,3)*60]) {
                    children();
                    translate([10,-10,0]) children();
                }
            }
        }
    }
}

module bearing_co(co_h,co_1=true,co_2=true,co_3=true) {
    bearing_clr_r = 4 + 0.3;
    
    if(co_1) translate([0,0,-0.01]) cylinder(r=bearing_clr_r,h=co_h+2*0.01);
    
    if(co_2) translate([0,0,-0.01]) cylinder(r1=bearing_clr_r+bev_xs,r2=bearing_clr_r,h=bev_xs);
        
    if(co_3) translate([0,0,co_h+0.01-bev_xs]) cylinder(r1=bearing_clr_r,r2=bearing_clr_r+bev_xs,h=bev_xs);
}

//relative to head side (not nut side)
module bolt_mount_co() {
    translate([0,0,-0.6-0.01]) cylinder(r=2+0.2,h=50);
            
    hull() for(j=[0:5]) rotate([0,0,j*60]) translate([0,3.5/cos(30),3]) cylinder(r=0.2,h=10);
    hull() for(j=[0:2]) rotate([0,0,j*120]) translate([0,3.5/cos(30),3-0.2]) cylinder(r=0.2,h=10);
}

//relative to head side (not nut side)
//head is z-negative (down)
module bolt_mount_pos(co_h) {
    hull() {
        translate([0,0,-0.6]) cylinder(r=2+0.2+1.2,h=co_h+0.6);
        cylinder(r=2+0.2+1.2+0.6,h=5);
    }
}

module pivot_bar() {
    difference() {
        union() {
            hull() for(i=[0,bar_len]) translate([i,0,0]) {
                cylinder(r=10-bev_s,h=piv_arm_h);
                translate([0,0,bev_s]) cylinder(r=10,h=piv_arm_h-2*bev_s);
            }
            
            translate([bar_len,0,0]) bolt_mount_pos(piv_arm_h);
        }
        //translate([bar_len,0,0]) bolt_mount_co();
        
        translate([bar_len,0,-1]) cylinder(r=2+0.2,h=50);
        
        #translate([bar_len,0,piv_arm_h-2]) {
                cylinder(r=4,h=50);
                translate([-sqrt(pow(4,2)-pow(2+0.2,2)),-(2+0.2),-0.2]) cube([2*sqrt(pow(4,2)-pow(2+0.2,2)),2*(2+0.2),50]);
                translate([-(2+0.2),-(2+0.2),-0.4]) cube([2*(2+0.2),2*(2+0.2),50]);
            }
        
        bearing_co(piv_arm_h);
    }
}

module visor_arm_bearing_pos(inner=true,outer=true) {
    if(inner) children();
    if(outer) translate([25,0,0]) children();
}

module visor_arm_bearings() translate([head_min_rad+5,0,0]) rotate([90,0,0]) rotate([0,90,0]) {
    translate([-20,-5,vis_arm_z0-3-0.6]) {
        visor_arm_bearing_pos() {
            cylinder(r=4,h=3);
            
            //ULP
            union() {
                translate([0,0,-1.2]) cylinder(r=2,h=17);
                translate([0,0,0]) rotate_extrude() {
                    translate([7.8/2-1.2/2,-1.2/2]) circle(r=1.2/2);
                    translate([0,-1.2]) square([7.8/2-1.2/2,1.2]);
                }
            }
        }
        visor_arm_bearing_pos(true,false) {
            
            //translate([0,0,3+2]) cylinder(r=2+1.5,h=4);
            
            
            translate([0,0,10]) cylinder(r=4,h=3);
        }
    }
}

module bolt_bearings_ph(ref_z) union() {
    translate([0,0,ref_z-3-0.6]) {
        cylinder(r=4,h=3);
            
        //short button head
        *union() {
            translate([0,0,0]) cylinder(r=2,h=9.7);
            translate([0,0,0]) rotate_extrude() {
                translate([6.9/2-(12.5-9.7)/2,-(12.5-9.7)/2]) circle(r=(12.5-9.7)/2);
                translate([0,-(12.5-9.7)]) square([6.9/2-(12.5-9.7)/2,(12.5-9.7)]);
                translate([0,-(12.5-9.7)/2]) square([6.9/2,(12.5-9.7)/2]);
            }
        }
        
        //ULP
        union() {
            translate([0,0,-1.2]) cylinder(r=2,h=17);
            translate([0,0,0]) rotate_extrude() {
                translate([7.8/2-1.2/2,-1.2/2]) circle(r=1.2/2);
                translate([0,-1.2]) square([7.8/2-1.2/2,1.2]);
            }
        }
    }
}
    
module visor_arm() translate([head_min_rad+5,0,0]) rotate([90,0,0]) rotate([0,90,0]) union() {
    translate([0,0,0]) difference() {
        l1 = (120+5+2.5)*cos(viewport_w_a/2-viewport_crn_w_a)-((120+5+5+5)-(120+5+2.5)*sin((viewport_w_a/2-viewport_crn_w_a)))*tan((viewport_w_a/2-viewport_crn_w_a));
        l2 = l1-15/tan(viewport_w_a/2-viewport_crn_w_a);
        
        union() {
            translate([0,0,vis_arm_z0]) hull() {
                //translate([0,5,5]) cylinder(r=30,h=5);
                translate([-20,-5,0]) {
                    translate([0,0,0]) cylinder(r=10,h=vis_arm_h);
                    translate([10,-10,0]) cylinder(r=10,h=vis_arm_h);
                    translate([20,20,0]) cylinder(r=10,h=vis_arm_h);
                }
                translate([10,-30+5,0]) cube([-10+face_outset+10+1,50,vis_arm_h]);
            }
            
            /*difference() {
                union() {
                    translate([45-10-2,-30+5-2,5]) cube([10+2,50+2,5]);
                    translate([45-10,-30+5-10+2,5]) cube([10,50+10-2,5]);
                    translate([45-10+2,-30+5-10,5]) cube([10-2,50+10,5]);
                    translate([45-10+2,-40+5+2,5]) cylinder(r=2,h=5);
                }
                translate([45-10-2,-40+5+10-2,0]) cylinder(r=2,h=50);
            }*/
            
            translate([face_outset+5,-20-5,vis_arm_z0]) linear_extrude(height=vis_arm_h) {
                //echo(atan((10-2-2)/(10+2)));
                //echo(atan((2+2)/sqrt(pow(10-2-2,2)+pow(10+2,2))));
                step_a = atan((10-2-2)/(10+2)) + atan((2+2)/sqrt(pow(10-2-2,2)+pow(10+2,2)));
                
                difference() {
                    union() {
                        translate([0,-10+2]) circle(r=2);
                        polygon([
                            [-10-2,20],
                            [-10-2,-2],
                            [-10-2+2*sin(step_a),-2+2*cos(step_a)],
                            [-2*sin(step_a),-10+2-2*cos(step_a)],
                            [0,-10+2],
                            [0,-10],
                            [10,-10],
                            [10,20],
                        ]);
                    }
                    translate([-10-2,-2]) circle(r=2);
                }   
            }
            
            translate([0,0,vis_arm_z0]) hull() {
                translate([face_outset+5,-40+5,0]) cube([5,2*30,5]);
                translate([55,-40+5,5-0.01]) cube([-55+face_outset+l1,2*30,0.01]);
                translate([face_outset+l2-4,-40+5,-10]) cube([4,2*30,15]);
            }
            
            //#translate([40+l2,-10+5-5/2,5-10+5]) cube([l1-l2,5,10]);
            for(iz2=[-22.5,0,22.5]) translate([face_outset+l1,-10+5+iz2,5+5]) mirror([0,0,1]) {
                rotate([0,viewport_w_a/2-viewport_crn_w_a-7.5,0]) {
                    hull() for(iz=[-(5/2-1),(5/2-1)]) for(iy=[4-0.4,10]) translate([-iy,iz,0]) {
                        translate([0,0,-0.01]) cylinder(r=1,h=5-1);
                        translate([0,0,5-1]) {
                            sphere(r=1);
                            translate([-5*tan(viewport_w_a/2-viewport_crn_w_a-7.5),0,-5]) sphere(r=1);
                        }
                    }
                }
            }
            
            //studs for pivot bolts
            translate([-20,-5,vis_arm_z0]) visor_arm_bearing_pos() bolt_mount_pos(vis_arm_h);
        }
        
        //cutout for magnet to hold visor up
        translate([-20,-5,vis_arm_z0]) translate([20+5,5+15,0]) {
            magnet_r = 8/2-0.05;
            magnet_dep = 3;
            
            translate([0,0,-0.01]) cylinder(r1=magnet_r+bev_s,r2=magnet_r,h=bev_s);
            translate([0,0,-0.01]) hull() {
                cylinder(r=magnet_r-bev_xs,h=magnet_dep+0.5);
                cylinder(r=magnet_r,h=magnet_dep+0.5-bev_xs);
            }
        }
        
        //cutouts for pivot bolts
        translate([-20,-5,vis_arm_z0]) {
            //visor_arm_bearing_pos(true,false) translate([0,0,-0.6-0.01]) cylinder(r=2+0.2,h=50);
            visor_arm_bearing_pos(true,false) bolt_mount_co();
            //visor_arm_bearing_pos(false,true) bolt_mount_co();
            visor_arm_bearing_pos(false,true) translate([0,0,-0.6-0.01]) cylinder(r=2+0.2,h=50);
            visor_arm_bearing_pos(false,true) translate([0,0,-vis_arm_z0+vis_arm_z1-2.4]) {
                cylinder(r=4,h=50);
                translate([-sqrt(pow(4,2)-pow(2+0.2,2)),-(2+0.2),-0.2]) cube([2*sqrt(pow(4,2)-pow(2+0.2,2)),2*(2+0.2),50]);
                translate([-(2+0.2),-(2+0.2),-0.4]) cube([2*(2+0.2),2*(2+0.2),50]);
            }
        }
           
        //cutout for bolts and nuts to attach visor vertical bracket
        for(i=[-15,15]) {
            translate([face_outset+l1-(l1-l2)/2,-10+5+i,0]) {
                translate([0,0,5+5-15/2]) rotate([0,-90,0]) {
                    translate([0,0,-5]) rotate([0,0,90]) hull() cylinder_oh(1.75,20);
                    translate([0,0,(l1-l2)/2+4-2]) hull() for(j=[0:5]) rotate([0,0,j*60]) translate([0,2.75/cos(30),0]) cylinder(r=0.2,h=10);
                }
            }
        }
        
        //cutouts to access nuts
        translate([face_outset+l2,-10+5,5+2]) {
            hull() for(k=[0,12.5]) mirror([0,0,1]) {
                translate([-4-2-k,-15+(15-2-4/2),0]) {
                    translate([0,0,0]) cylinder(r=2,h=20);
                    translate([-2,0,2]) cylinder(r=2,h=20);
                }
                translate([-4-2-k+(k>0?(4+2)/sqrt(2):0),-15-(15-2-4),0]) {
                    translate([0,0,0]) cylinder(r=2,h=20);
                    translate([-2,0,2]) cylinder(r=2,h=20);
                }
                translate([-4-2-k,-15-(15-2-4)+(4+2)/sqrt(2),0]) {
                    translate([0,0,0]) cylinder(r=2,h=20);
                    translate([-2,0,2]) cylinder(r=2,h=20);
                }
            }
            hull() for(k=[0,12.5]) for(j=[(15-2-4),-(15-2-4/2)]) translate([-4-2-k,15+j,0]) mirror([0,0,1]) {
                translate([0,0,0]) cylinder(r=2,h=20);
                translate([-2,0,2]) cylinder(r=2,h=20);
            }
        }
    }
}

module visor_vert_brk() {
    difference() {
        thk = 15/cos(90-(viewport_w_a/2-viewport_crn_w_a));
        a_len = ((120+5+5+5)-rad_vis_outer*sin((viewport_w_a/2-viewport_crn_w_a)))/cos((viewport_w_a/2-viewport_crn_w_a));
        
        union() {
            intersection() {
                rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([0,head_min_rad+5+2.5-thk,face_bottom-outset_bez_outer]) {
                    cube([a_len,thk,abs(face_bottom)+face_top+2*outset_bez_outer]);
                }
                
                hull() {
                    for(iz=[face_bottom,face_top]) {
                        translate([0,0,iz-sign(iz)*viewport_crn_r]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) rotate([-90,0,0]) {
                            cylinder(r=viewport_crn_r+outset_bez_outer-0.4,h=rad_vis_outer);
                            cylinder(r=viewport_crn_r+outset_bez_outer,h=rad_vis_outer-0.4);
                        }
                    }
                        
                    for(iz=[face_bottom,face_top]) for(ix=[0,10]) {
                        translate([0,0,iz-sign(iz)*(-outset_bez_outer+5)]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([ix,0,0]) rotate([-90,0,0]) {
                            cylinder(r=5-0.4,h=rad_vis_outer);
                            cylinder(r=5,h=rad_vis_outer-0.4);
                        }
                    }
                }
            }
            
            //interface to visor_arm
            rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([0,rad_vis_outer-thk,-30-20-5]) hull() {
                cube([a_len,thk,60]);
                translate([-5,0,-5]) cube([a_len,thk,60]);
            }
            
            //top corner fillet
            rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([0,rad_vis_outer-thk,face_top-40]) rotate([-90,0,0]) difference() {
                linear_extrude(height=thk) polygon([
                    [0,0],
                    [sqrt(pow((viewport_crn_r+outset_bez_outer)+5,2)-pow(30-5+5,2)),0],
                    [sqrt(pow((viewport_crn_r+outset_bez_outer)+5,2)-pow(30-5+5,2)),-(30-5+5)],
                ]);
                translate([sqrt(pow((viewport_crn_r+outset_bez_outer)+5,2)-pow(30-5+5,2)),-(30-5+5),0]) {
                    translate([0,0,-1]) cylinder(r=5,h=50);
                    translate([0,0,thk-0.4]) cylinder(r1=5,r2=5+50,h=50);
                }
            }
        }
        
        //interface to visor arm
        //interface notch
        /*#hull() for(iz=[-2,2]) {
            rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([0,rad_vis_outer,-20-5+iz]) {
                translate([a_len,0,0]) rotate([0,0,-90+(viewport_w_a/2-viewport_crn_w_a)]) for(iy=[0,50]) translate([iy,0,0]) rotate([90,0,0]) cylinder(r=0.4,h=10+0.4);
            }
        }*/
        for(iz2=[-22.5,0,22.5]) {
            rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([0,rad_vis_outer,-20-5+iz2]) translate([a_len,0,0]) rotate([0,0,-90+7.5]) {
                hull() for(iz=[-(5/2-1),(5/2-1)]) for(iy=[4,10]) translate([iy,0,iz]) rotate([90,0,0]) {
                    translate([0,0,-0.01]) cylinder(r=1+0.2,h=5-1);
                    translate([0,0,5-1]) {
                        sphere(r=1+0.2);
                        translate([5*tan(viewport_w_a/2-viewport_crn_w_a-7.5),0,-5]) sphere(r=1+0.2);
                    }
                }
            }
        }
        
        //screw holes
        rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) {
            for(i=[-15,15]) {
                translate([a_len,rad_vis_outer-thk/2,-50-5+30+i]) {
                    rotate([0,0,-90+(viewport_w_a/2-viewport_crn_w_a)]) rotate([0,-90,0]) {
                        translate([0,0,-5]) hull() cylinder_oh(1.75,50);
                        translate([0,0,5]) hull() cylinder_oh(3,50);
                        
                        translate([0,0,5+5]) hull() {
                            cylinder_oh(3,50);
                            translate([0,0,10]) cylinder_oh(3+10*tan(viewport_w_a/2-viewport_crn_w_a),50);
                        }
                    }
                }
            }
        }
    
        //inner radius cutout
        translate([0,0,-200]) cylinder(r=rad_vis_inner,h=400,$fn=$fn*2);
        
        //bezel inside cutout
        hull() for(iz=[face_bottom,face_top]) translate([0,0,iz-sign(iz)*40]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) rotate([-90,0,0]) cylinder(r=viewport_crn_r+outset_bez_inner,h=200);
                    
        //bezel bevel
        hull() for(iz=[face_bottom,face_top]) translate([0,0,iz-sign(iz)*40]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) rotate([-90,0,0]) {
            translate([0,0,rad_vis_bev]) cylinder(r=viewport_crn_r+outset_bez_inner,h=200);
            translate([0,0,rad_vis_outer]) cylinder(r=viewport_crn_r+outset_bez_bev,h=200);
        }
        
        //interface to bezel horizontal bars
        for(iz=[face_bottom,face_top]) {
            //cutout for seat
            hull() for(ix=[0,50]) for(iz2=[0,50]) translate([0,0,iz+sign(iz)*(outset_bez_inner+5+2.4+iz2)]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([5-ix,0,0]) {
                /*translate([0,0,-0.8]) rotate([-90,0,0]) cylinder(r=5,h=rad_vis_seat+2.4+0.2);
                translate([0,-0.8,0]) rotate([-90,0,0]) cylinder(r=5,h=rad_vis_seat+2.4+0.2);*/
                
                rotate([-90,0,0]) cylinder(r=5,h=rad_vis_seat+1.6+0.2);
            }
              
            //cutout for screws
            translate([0,0,iz+sign(iz)*(outset_glass+1.75)]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([2.4+1.5,0,0]) rotate([-90,0,0]) cylinder(r=1.25,h=rad_vis_outer-0.8);
        }

        //cutout for glass seat
        intersection() {
            union() {
                $fn=4*2*3;
                viewport_shape(outset_glass+0.5);
            }
            translate([0,0,-200]) cylinder(r=rad_vis_seat,h=400,$fn=$fn*2);
        }
    }
}
    
outset_glass = 7.5+2.5;
outset_bez_inner = 7.5+2.5-7.5;
outset_bez_outer = 7.5+2.5+5;

rad_vis_inner = head_min_rad;
rad_vis_outer = head_min_rad+5+2.5;
rad_vis_seat = head_min_rad+1.5;

rad_vis_bev = rad_vis_seat+2.4;
outset_bez_bev = outset_bez_inner+(rad_vis_outer-rad_vis_bev);



module visor_horiz_brk() {
    intersection() {
        difference() {
            hull() translate([0,0,-outset_bez_outer]) {
                translate([0,0,0.4]) {
                    cylinder(r=rad_vis_bev,h=outset_bez_outer-outset_bez_inner-0.4,$fn=$fn*2);
                    cylinder(r=rad_vis_outer,h=outset_bez_outer-outset_bez_bev-0.4,$fn=$fn*2);
                }
                cylinder(r=rad_vis_outer-0.4,h=outset_bez_outer-outset_bez_bev,$fn=$fn*2);
            }
            translate([0,0,-50]) cylinder(r=rad_vis_inner,h=400,$fn=$fn*2);
            translate([0,0,-(outset_glass+0.5)]) cylinder(r=rad_vis_seat,h=50,$fn=$fn*2);
        }
        translate([0,0,-200]) linear_extrude(height=400) polygon([
            [0,0],
            [200*tan(viewport_w_a/2-viewport_crn_w_a),200],
            [-200*tan(viewport_w_a/2-viewport_crn_w_a),200],
        ]);
    }
    
    difference() {
        for(ix=[0,1]) mirror([ix,0,0]) rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([-0.01,0,0]) {
            translate([0,0,-outset_bez_outer]) {
                cube([10-0.2,rad_vis_seat+1.6,outset_bez_outer+(-outset_bez_inner-2.4-5)]);
            }
            translate([0,0,-outset_bez_outer]) {
                cube([10-0.2-(5-0.2),rad_vis_seat+1.6,outset_bez_outer+(-outset_bez_inner-2.4-5+(5-0.2))]);
            }
            translate([10-0.2-(5-0.2),0,-outset_bez_inner-2.4-5]) {
                rotate([-90,0,0]) cylinder(r=5-0.2,h=rad_vis_seat+1.6);
            }
        }
        
        translate([0,0,-50]) cylinder(r=rad_vis_inner,h=400,$fn=$fn*2);
        

        //cutout for glass seat
        translate([0,0,-face_bottom]) intersection() {
            union() {
                $fn=4*2*3;
                viewport_shape(outset_glass+0.5);
            }
            translate([0,0,-200]) cylinder(r=rad_vis_seat,h=400,$fn=$fn*2);
        }
        
        //screws to attach to vertical bracket
        for(ix=[0,1]) mirror([ix,0,0]) {
            //new design - counter-sunk head screw
            rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([1.5+2.5,0,-(outset_glass+1.75)]) {
                rotate([-90,0,0]) hull() {
                    cylinder_oh(1.75,rad_vis_outer-0.8-(6+0.4)+(3-1.75));
                    cylinder_oh(3,rad_vis_outer-0.8-(6+0.4));
                }
                rotate([-90,0,0]) hull() cylinder_oh(1.75,rad_vis_outer-0.8);
            }
            
            //old design - button head screw
            *rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([1.5+2.5,0,-(outset_glass+1.75)]) {
                rotate([-90,0,0]) hull() cylinder_oh(1.75,200);
                *hull() for(iz=[0]) translate([0,0,iz]) {
                    rotate([-90,0,0]) cylinder_oh(1.75,rad_vis_seat);
                }
            }
            *hull() {
                intersection() {
                    rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([1.5+2.5,0,-(outset_glass+1.75)]) {
                        for(iz=[0,10]) translate([0,0,iz]) {
                            rotate([-90,0,0]) cylinder_oh(3,rad_vis_seat);
                        }
                    }
                    translate([0,0,-200]) cylinder(r=rad_vis_seat,h=400,$fn=$fn*2);
                }
                rotate([0,0,-(viewport_w_a/2-viewport_crn_w_a)]) translate([1.5+2.5,0,-(outset_glass+1.75)]) {
                    for(iz=[0,10]) translate([0,0,iz]) {
                        rotate([-90,0,0]) cylinder_oh(3-0.25,rad_vis_seat);
                    }
                }
            }
        }
    }
}

module visor_glass() {
    intersection() {
        difference() {
            viewport_shape(outset_glass-0.5);
            //viewport_shape(0);
            translate([0,0,-200]) cylinder(r=head_min_rad,h=400);
        }
        translate([0,0,-200]) cylinder(r=head_min_rad+1.5,h=400);
    }
}

module mount_screw_co(hgt_to_bevel,head_oh=false) {
    translate([0,0,-8]) hull() {
        cylinder(r=1.25,h=20);
        translate([0,0,-1.25]) cylinder(r=0.01,h=20);
    }
            
    translate([0,0,-0.01]) cylinder(r=1.75,h=20);
    translate([0,0,2]) {
        cylinder(r=3,h=20);
        
        if(head_oh) {
            translate([-1.75,-sqrt(pow(3,2)-pow(1.75,2)),-0.2]) cube([2*1.75,2*sqrt(pow(3,2)-pow(1.75,2)),20]);
            translate([-1.75,-1.75,-0.4]) cube([2*1.75,2*1.75,20]);
        }
    }
    
    translate([0,0,hgt_to_bevel]) hull() {
        translate([0,0,-bev_s]) cylinder(r=3,h=50);
        cylinder(r=3+bev_s,h=50);
    }
}

module mount_screw_co_oh(hgt_to_bevel,hgt_to_head) {
    translate([0,0,-8]) hull() {
        cylinder_oh(1.25,20);
        translate([0,0,-1.25]) cylinder(r=0.01,h=20);
    }
            
    translate([0,0,-0.01]) hull() cylinder_oh(1.75,20);
    translate([0,0,hgt_to_head]) hull() cylinder_oh(3,20);
    
    translate([0,0,hgt_to_bevel]) hull() {
        translate([0,0,-bev_s]) cylinder_oh(3,50);
        cylinder_oh(3+bev_s,50);
    }
}

module mount_outer() difference() {
    union() {
        difference() {
            bearing_r = 4+clr_h;
            
            translate([20,5,mnt_out_z0]) hull() {
                cylinder(r=40-0.2,h=mnt_out_h);
                translate([0,0,0.2]) cylinder(r=40,h=mnt_out_h-2*0.2);
            
                for(ia=[90,180,270]) rotate([0,0,ia-15]) translate([20,20,0]) {
                    cylinder(r=20-0.2,h=mnt_out_h);
                    translate([0,0,0.2]) cylinder(r=20,h=mnt_out_h-2*0.2);
                }
            }
            
            translate([20,5,0]) {
                mount_outer_screw_pos() translate([0,0,mnt_out_z0]) {
                    //mount_screw_co(mnt_out_h,true);
                    
                    screw_co(8,8-2.4,mnt_out_h);
                }
            }
            
            visor_arm_clearance();
            locking_bar_clearance();
            pivot_bar_clearance();
        }
        
        rotate([0,0,30]) translate([2*bar_len,0,mnt_out_z2]) bolt_mount_pos(mnt_out_h-(mnt_out_z2-mnt_out_z0));
    }
    
    //cutout to reduce printing time
    *translate([20,5,0]) rotate([0,0,-15]) hull() {
        translate([20,-20,0]) cylinder(r=15,h=mnt_out_z2+5-0.6);
        translate([20-20,-20-10,0]) cylinder(r=5,h=mnt_out_z2+5-0.6);
        translate([20+10,-20+20,0]) cylinder(r=5,h=mnt_out_z2+5-0.6);
    }
    
    //rotate([0,0,30]) translate([2*bar_len,0,mnt_out_z2]) bolt_mount_co();
    
    
                    
    rotate([0,0,30]) translate([2*bar_len,0,mnt_out_z0-1]) cylinder(r=2+0.2,h=50);

    rotate([0,0,30]) translate([2*bar_len,0,mnt_out_z0+mnt_out_h-1])  {
            cylinder(r=4,h=50);
            translate([0,0,1-0.4+0.01]) cylinder(r1=4,r2=4+0.4,h=0.4);
            translate([-sqrt(pow(4,2)-pow(2+0.2,2)),-(2+0.2),-0.2]) cube([2*sqrt(pow(4,2)-pow(2+0.2,2)),2*(2+0.2),50]);
            translate([-(2+0.2),-(2+0.2),-0.4]) cube([2*(2+0.2),2*(2+0.2),50]);
        }
    
    //clearance for pivot arm bolt
    mount_outer_clearance_pivot_bolt() {
        cylinder(r=5-2.5,h=piv_arm_bolt_clr_h);
        cylinder(r=5,h=piv_arm_bolt_clr_h-2.5);
    }
    translate([0,0,-piv_arm_bolt_clr_z0]) {
        mount_outer_clearance_pivot_bolt() translate([0,0,mnt_out_z2-0.01]) {
            cylinder(r1=5+bev_s,r2=5,h=bev_s);
        }
        mount_outer_clearance_pivot_bolt() translate([0,0,mnt_out_z0+mnt_out_h-bev_s+0.01]) {
            cylinder(r1=5,r2=5+bev_s,h=bev_s);
        }
    }

    
    //clearance for visor arm bolts
    *for(j=[0:1/($fn/2):1-1/($fn/2)]) {
        hull() for(i=[j,j+1/($fn/2)]) trans_hinge(i) {
            translate([25,0,vis_arm_bolt_clr_z0]) {
                cylinder(r=5-2.5,h=vis_arm_bolt_clr_h);
                cylinder(r=5,h=vis_arm_bolt_clr_h-2.5);
            }
        }
    }
    *hull() for(i=[0,1]) trans_hinge(i) {
        translate([0,0,vis_arm_bolt_clr_z0]) {
            cylinder(r=5-2.5,h=vis_arm_bolt_clr_h);
            cylinder(r=5,h=vis_arm_bolt_clr_h-2.5);
        }
    }
}

module mount_outer_clearance_pivot_bolt() {
    for(j=[0:1/($fn/2):1-1/($fn/2)]) {
        hull() for(i=[j,j+1/($fn/2)]) {
            
            lck_rot_min = -acos((bar_len-0.25)/bar_len);
            lck_rot_max = acos((bar_len-17.5/2)/bar_len);
            
            j_lck = i*(lck_rot_max-lck_rot_min)+lck_rot_min;
            
            rotate([0,0,30]) translate([2*bar_len,0,0]) {
                pivot_bar_motion(j_lck) {
                    translate([bar_len,0,piv_arm_bolt_clr_z0]) {
                        children();
                    }
                }
            }
        }
    }
}

module mount_inner_screw_pos() {
    /*mnt_angles = [60+45,-60+5,180+15];
    mnt_dist = [25,32.5,20];
    
    for(i=[0:2]) {
        rotate([0,0,30+mnt_angles[i]]) translate([mnt_dist[i],0,0]) {
            children();
        }
    }*/
    
    rotate([0,0,-15]) {
        translate([-27.5,-27.5,0]) children();
        translate([-27.5,27.5,0]) children();
        
        translate([32.5,0,0]) children();
    }
}

module mount_outer_screw_pos() {
    /*mnt_angles = [120,240+20];
    mnt_dist = [32.5,32.5];
    
    for(i=[0:1]) {
        rotate([0,0,30+mnt_angles[i]]) translate([mnt_dist[i],0,0]) {
            children();
        }
    }*/
    
    rotate([0,0,-15]) {
        translate([-32.5,15,0]) children();
        //translate([-32.5,-15,0]) children();
        translate([-12.5,-32.5,0]) children();
    }
}
/*
            hull() {
                cylinder(r=15-bev_s,h=lck_arm_h);
                translate([0,0,bev_s]) cylinder(r=15,h=lck_arm_h-2*bev_s);
                
                translate([17.5,0,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,-(15-10),0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
            }
            hull() {
                translate([17.5-10,-(15-10),0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-10,0,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-10,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-15,-35,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-35,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
            }
            hull() {
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-10,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-55,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
            }
            hull() {
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-55,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-15,-35,0]) {
                    cylinder(r=10-bev_s,h=lck_arm_h);
                    translate([0,0,bev_s]) cylinder(r=10,h=lck_arm_h-2*bev_s);
                }
                
                trans_chin_bar_from_locking_bar() translate([120+5+lck_arm_z0,55-35,5]) {
                    translate([0,0,0]) rotate([0,90,0]) {
                        cylinder(r=5-bev_s,h=lck_arm_h);
                        translate([0,0,bev_s]) cylinder(r=5,h=lck_arm_h-2*bev_s);
                    }
                    translate([0,30-2.5,5]) rotate([0,90,0]) {
                        cylinder(r=2.5-bev_s,h=lck_arm_h);
                        translate([0,0,bev_s]) cylinder(r=2.5,h=lck_arm_h-2*bev_s);
                    }
                    translate([0,30-1,-5+1]) rotate([0,90,0]) {
                        cylinder(r=1-bev_s,h=lck_arm_h);
                        translate([0,0,bev_s]) cylinder(r=1,h=lck_arm_h-2*bev_s);
                    }
                }
            }
        }
                */

module locking_bar_clearance() {
    for(j=[0:1/($fn/2):1-1/($fn/2)]) hull() for(i=[j,j+1/($fn/2)]) {
        co_hgt = lck_arm_h+clr_v+clr_v+1;
        
        lck_rot_min = -acos((bar_len-0.25)/bar_len);
        lck_rot_max = acos((bar_len-17.5/2)/bar_len);
        
        j_lck = i*(lck_rot_max-lck_rot_min)+lck_rot_min;
        
        rotate([0,0,30]) translate([2*bar_len,0,-1]) {
            pivot_bar_motion(j_lck) {
                translate([bar_len,0,0]) {
                    locking_bar_motion(j_lck) {
                        translate([-bar_len,0,lck_arm_z0-clr_v]) {
                            translate([0,0,0]) {
                                cylinder(r=15+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=15+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,0,0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,-(15-10),0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                        }
                    }
                }
            }
        }
    }
    for(j=[0:1/($fn/2):1-1/($fn/2)]) hull() for(i=[j,j+1/($fn/2)]) {
        co_hgt = lck_arm_h+clr_v+clr_v+1;
        
        lck_rot_min = -acos((bar_len-0.25)/bar_len);
        lck_rot_max = acos((bar_len-17.5/2)/bar_len);
        
        j_lck = i*(lck_rot_max-lck_rot_min)+lck_rot_min;
        
        rotate([0,0,30]) translate([2*bar_len,0,-1]) {
            pivot_bar_motion(j_lck) {
                translate([bar_len,0,0]) {
                    locking_bar_motion(j_lck) {
                        translate([-bar_len,0,lck_arm_z0-clr_v]) {
                            translate([17.5-10,-(15-10),0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,0,0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-10,0,0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-10,0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30-15,-35,0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                            translate([17.5,0,0]) rotate([0,0,-lck_rot_min-30-15]) translate([30,-35,0]) {
                                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                            }
                        }
                    }
                }
            }
        }
    }
}

module pivot_bar_clearance() {
    for(j=[0:1/($fn/2):1-1/($fn/2)]) hull() for(i=[j,j+1/($fn/2)]) {
        co_hgt = piv_arm_h+clr_v+clr_v+1;
        
        lck_rot_min = -acos((bar_len-0.25)/bar_len);
        lck_rot_max = acos((bar_len-17.5/2)/bar_len);
        
        j_lck = i*(lck_rot_max-lck_rot_min)+lck_rot_min;
        
        rotate([0,0,30]) translate([2*bar_len,0,-1]) {
            pivot_bar_motion(j_lck) {
                translate([0,0,piv_arm_z0-clr_v]) {
                    translate([0,0,0]) {
                        cylinder(r=10+clr_h-bev_s,h=co_hgt);
                        translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                    }
                    translate([bar_len,0,0]) {
                        cylinder(r=10+clr_h-bev_s,h=co_hgt);
                        translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
                    }
                }
                translate([bar_len,0,0]) {
                    locking_bar_motion(j_lck) {
                    }
                }
            }
        }
    }
}

module visor_arm_clearance() {
    for(j=[0:1/($fn/2):1-1/($fn/2)]) hull() for(i=[j,j+1/($fn/2)]) {
        trans_hinge(i) translate([0,0,vis_arm_z0-clr_v]) {
            co_hgt = vis_arm_h+clr_v+clr_v;
            
            translate([0,0,0]) {
                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
            }
            translate([10,-10,0]) {
                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
            }
            translate([20+50,20+50,0]) {
                cylinder(r=10+clr_h-bev_s,h=co_hgt);
                translate([0,0,bev_s]) cylinder(r=10+clr_h,h=co_hgt-2*bev_s);
            }
            translate([100,5,0]) {
                cylinder(r=(50/2)+clr_h-bev_s,h=co_hgt);
                translate([0,0,bev_s]) cylinder(r=(50/2)+clr_h,h=co_hgt-2*bev_s);
            }
        }
    }
}

module mount_inner() difference() {
    bearing_r = 4+clr_h;
    
    translate([20,5,0]) {
        hull() {
            cylinder(r=40-0.2,h=10);
            translate([0,0,0.2]) cylinder(r=40,h=10-2*0.2);
            
            for(ia=[90,180,270]) rotate([0,0,ia-15]) translate([20,20,0]) {
                cylinder(r=20-0.2,h=10);
                translate([0,0,0.2]) cylinder(r=20,h=10-2*0.2);
            }
        }
    }
    
    *translate([20,5,mnt_inn_z0]) mount_inner_screw_pos() {
        //mount_screw_co(mnt_inn_z1-mnt_inn_z0);
        screw_co(8,8-2.4,mnt_inn_z1-mnt_inn_z0);
    }
    translate([20,5,mnt_inn_z0]) rotate([0,0,-15]) {
        translate([-27.5,-27.5,0]) screw_co(8,8-2.4,mnt_inn_z2-mnt_inn_z0);
        translate([-27.5,27.5,0]) screw_co(8,8-2.4,mnt_inn_z1-mnt_inn_z0);
        
        #translate([32.5,0,0]) screw_co(8,8-2.4,mnt_inn_z1-mnt_inn_z0);
    }
    translate([20,5,mnt_out_z0]) mount_outer_screw_pos() {
        //mount_screw_co(mnt_out_h);
        screw_co(8,8-2,mnt_out_z1-mnt_out_z0);
    }
        
    visor_arm_clearance();
    
    //cutout for magnet to hold visor up
    for(i=[1]) trans_hinge(i) translate([20+5,5+15,0]) {
        magnet_r = 8/2-0.05;
        magnet_dep = 3;
        
        translate([0,0,mnt_inn_z1-bev_s+0.01]) cylinder(r1=magnet_r,r2=magnet_r+bev_s,h=bev_s);
        #translate([0,0,mnt_inn_z1-(magnet_dep+0.5)+0.01]) hull() {
            cylinder(r=magnet_r-bev_xs,h=10);
            translate([0,0,bev_xs]) cylinder(r=magnet_r,h=10);
        }
    }
    
    //bearing track
    for(j=[0:1/($fn/2):1-1/($fn/2)]) {
        hull() for(i=[j,j+1/($fn/2)]) trans_hinge(i) {
            translate([25,0,0]) bearing_co(5-clr_v,true,false,false);
        }
        hull() for(i=[j,j+1/($fn/2)]) trans_hinge(i) {
            translate([25,0,0]) bearing_co(5-clr_v,false,true,false);
        }
        hull() for(i=[j,j+1/($fn/2)]) trans_hinge(i) {
            translate([25,0,0]) bearing_co(5-clr_v,false,false,true);
        }
    }
    hull() for(i=[0,1]) trans_hinge(i) {
        bearing_co(5-clr_v,true,false,false);
    }
    hull() for(i=[0,1]) trans_hinge(i) {
        bearing_co(5-clr_v,false,true,false);
    }
    hull() for(i=[0,1]) trans_hinge(i) {
        bearing_co(5-clr_v,false,false,true);
    }
}

module viewport_shape(viewport_inset=0) {
    for(ix=[0,1]) mirror([ix,0,0]) {
        for(j=[0:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
            for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                    rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/viewport_crv_d*360]) translate([0,120-8-0.1,0]) rotate([-90,0,0]) cylinder(r=0.01,h=50,$fn=8);
                }
            }
        }
    }
    rotate([0,0,(180-viewport_w_a)/2+viewport_crn_w_a]) rotate_extrude(angle=viewport_w_a-2*viewport_crn_w_a) {
        polygon([
            [(head_min_rad-8-0.02)+50,face_bottom-viewport_inset],
            [(head_min_rad-8-0.02),face_bottom-viewport_inset],
            [(head_min_rad-8-0.02),face_top+viewport_inset],
            [(head_min_rad-8-0.02)+50,face_top+viewport_inset],
        ]);
    }
}

module locking_wedge() difference() {
    datum_helmet_from_visor() translate([head_min_rad+5,0,0]) rotate([90,0,0]) rotate([0,90,0]) {
        *translate([0,0,vis_arm_z0]) hull() {
            translate([-20,-5,0]) {
                translate([0,0,0]) cylinder(r=10,h=vis_arm_h);
                translate([10,-10,0]) cylinder(r=10,h=vis_arm_h);
                translate([70,0,0]) cylinder(r=10,h=vis_arm_h);
                translate([70,-10,0]) cylinder(r=10,h=vis_arm_h);
            }
        }
        translate([0,0,vis_arm_z0]) hull() {
            translate([-20,-5,0]) {
                translate([70-5,-5,0]) cylinder(r=15,h=vis_arm_h);
                translate([70-15,-5,0]) cylinder(r=15,h=vis_arm_h);
            }
        }
        translate([0,0,vis_arm_z0]) hull() {
            translate([-20,-5,0]) {
                *translate([7.5,-7.5,0]) cylinder(r=10,h=vis_arm_h);
                translate([10,-10,0]) cylinder(r=10,h=vis_arm_h);
                *translate([60,-7.5,0]) cylinder(r=10,h=vis_arm_h);
                translate([60,-10,0]) cylinder(r=10,h=vis_arm_h);
            }
        }
    }
    datum_helmet_from_visor() translate([head_min_rad+5,0,0]) rotate([90,0,0]) rotate([0,90,0]) {
        translate([0,0,vis_arm_z0]) hull() {
            translate([-20,-5,0]) {
                translate([70-5,-5,0]) cylinder(r=10,h=vis_arm_h);
                translate([70-15,-5,0]) cylinder(r=10,h=vis_arm_h);
            }
        }
    }
    trans_hinge(0.825) datum_helmet_from_visor() translate([head_min_rad+5,0,0]) rotate([90,0,0]) rotate([0,90,0]) {
        translate([0,0,vis_arm_z0]) hull() {
            translate([-20,-5,0]) {
                translate([0,0,0]) cylinder(r=10+0.2,h=vis_arm_h);
                translate([10,-10,0]) cylinder(r=10+0.2,h=vis_arm_h);
                translate([70,0,0]) cylinder(r=10+0.2,h=vis_arm_h);
                translate([70,-10,0]) cylinder(r=10+0.2,h=vis_arm_h);

                *translate([70,0,0]) cylinder(r=10+0.2,h=vis_arm_h);
                *translate([70,-10,0]) cylinder(r=10+0.2,h=vis_arm_h);
            }
        }
    }
}

/*module helmet_simple() translate([0,0,20]) {
    translate([0,dat_neckring_bottom_y,dat_neckring_bottom_z]) rotate([-face_angle,0,0]) {
        for(i=[0,1]) mirror([i,0,0]) {
            import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet A2.stl");
            import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet B2.stl");
            import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet C.stl");
            import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet D.stl");
            import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet E.stl");
        }
        
        *for(i=[0:3]) rotate([0,0,i*90]) {
            *rotate([0,0,45+22.5]) {
                import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring A.stl");
                rotate([0,0,22.5]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring B.stl");
            }
            rotate([0,0,22.5]) {
                import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring C.stl");
                rotate([0,0,45]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring D.stl");
            }
        }
    }
}*/
        
        
        
module screw_co(screw_len=8,eng_dep=5,top_bev_dist=20) {
    outer_r = 1.5+0.2;
    iface_r = 1.25;
    head_r = 3;
    
    rotate_extrude() polygon([
        [0,-eng_dep],
        
        //bevel at base of screw engagement
        [iface_r-0.5,-eng_dep],
        [iface_r,-eng_dep+0.5],
        
        //bevel and lead-in on engagement side of screw
        [iface_r,-(outer_r-iface_r)],
        [outer_r,-0.01],
        
        //bevel on head side of screw
        [outer_r+bev_s,-0.01],
        [outer_r+bev_s,0.01],
        [outer_r,bev_s],
        
        //seat for countersunk head
        [outer_r,-eng_dep+screw_len-(head_r-outer_r)],
        [head_r,-eng_dep+screw_len],
        
        //bevel at top of head site
        [head_r,top_bev_dist-bev_s],
        [head_r+bev_s,top_bev_dist+0.01],
        
        [0,top_bev_dist+0.01],
    ]);
}

module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}

module boule(inset=0,xor=0,tor_a=360) rotate([0,90,0]) {
    rotate_extrude(angle=tor_a) {
        intersection() {
            translate([xor,0]) circle(r=120+inset);
            translate([0,-120]) square([500,2*120]);
        }
        if(xor>0) translate([0,-(120+inset)]) square([xor,2*(120+inset)]);
    }
}