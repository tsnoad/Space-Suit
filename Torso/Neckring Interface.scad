$fn = 72;

use <PLSS Torso Shared Modules.scad>;
use <Neckring Torso Shared Modules.scad>;

outset = 8;
bev_s = 0.5; //bevel

flange_wid = 15;

//neck_spacer([0,120,240]);

neckring_interface() int_c_segment();

module neckring_interface() difference() {
    intersection() {
        translate([0,0,7.5]) {
            rotate([-15,0,0]) translate([0,40,0]) {
                hull() neck_spacer_shape(120+5);
                translate([0,0,2]) hull() {
                    cylinder(r=120+5+5-bev_s,h=5,$fn=$fn*2);
                    translate([0,0,bev_s]) cylinder(r=120+5+5,h=5-2*bev_s,$fn=$fn*2);
                }
                hull() {
                    cylinder(r=120+5,h=5+2,$fn=$fn*2);
                    translate([0,0,2]) cylinder(r=120+5+2,h=5,$fn=$fn*2);
                }
            }
        }
        
        //intersections to create segments
        translate([0,0,7.5]) {
            rotate([-15,0,0]) translate([0,40,0]) {
                children();
            }
        }
    }
    
    //cutout conical flange
    translate([0,0,/*(sqrt(pow(120+5,2)+pow(40,2))-(120+5))*/7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) hull() {
            trans1() cylinder(r1=120+5+200*tan(15),r2=120+5,h=200,$fn=$fn*2);
            trans1() hull() {
                cylinder(r=120+5,h=200,$fn=$fn*2);
                cylinder(r=120+5-50/tan(25),h=200+50,$fn=$fn*2);
            }
        }
    }
    
    //cutout groove for gasket
    for(ix=[0,1]) mirror([ix,0,0]) translate([0,0,/*(sqrt(pow(120+5,2)+pow(40,2))-(120+5))*/7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) {
            translate([0,-40+75,0]) rotate([-15,0,0]) {
                translate([0,-(-40+75),0]) rotate([0,0,asin((-40+75)/(120+5-4))]) rotate_extrude(angle=90-asin((-40+75)/(120+5-4)),$fn=$fn*2) {
                    $fn=$fn/2;
                    translate([120+5-4,0]) hull() {
                        translate([0,4*tan(25)]) circle(r=1.5);
                        circle(r=1.5);
                    }
                }
            }
            
            hull() {
                rotate([0,0,asin((-40+75)/(120+5-4))]) translate([120+5-4,0,0]) sphere(r=1.5);
                translate([0,-40+75,0]) rotate([-15,0,0]) {
                    translate([0,-(-40+75),0]) rotate([0,0,asin((-40+75)/(120+5-4))]) translate([120+5-4,0,4*tan(25)]) sphere(r=1.5);
                }
                rotate([0,0,asin((-40+75)/(120+5-4))]) translate([120+5-4,0,4*tan(25)]) sphere(r=1.5);
            }
            
            rotate([0,0,-asin(40/(120+5-4))]) rotate_extrude(angle=asin(40/(120+5-4))+asin((-40+75)/(120+5-4)),$fn=$fn*2) { 
                $fn=$fn/2;
                translate([120+5-4,0]) hull() {
                    translate([0,4*tan(25)]) circle(r=1.5);
                    circle(r=1.5);
                }
            }
            
            
            hull() {
                rotate([0,0,-asin((40)/(120+5-4))]) translate([120+5-4,0,0]) sphere(r=1.5);
                rotate([0,0,-asin((40)/(120+5-4))]) translate([120+5-4,0,4*tan(25)]) sphere(r=1.5);
                translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,40,0]) rotate([0,0,-asin((40)/(120+5-4))]) translate([120+5-4,0,4*tan(25)]) sphere(r=1.5);
                }
            }
            
            translate([0,-40,0]) rotate([15,0,0]) {
                translate([0,40,0]) rotate([0,0,-asin((40)/(120+5-4))]) rotate_extrude(angle=-asin((25/cos(30))/(120+5-4)),$fn=$fn*2) {
                    $fn=$fn/2;
                    translate([120+5-4,0]) hull() {
                        translate([0,4*tan(25)]) circle(r=1.5);
                        circle(r=1.5);
                    }
                }
            }
            hull() {
                translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,40,0]) rotate([0,0,-asin((40)/(120+5-4))-asin((25/cos(30))/(120+5-4))]) translate([120+5-4,0,0]) sphere(r=1.5);
                }
                translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,40,0]) rotate([0,0,-asin((40)/(120+5-4))-asin((25/cos(30))/(120+5-4))]) translate([120+5-4,0,4*tan(25)]) sphere(r=1.5);
                }
                translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                        translate([0,40,0]) rotate([0,0,-asin((40+25/cos(30))/(120+5-4))]) translate([120+5-4,0,4*tan(25)]) sphere(r=1.5);
                    }
                }
            }
            
            translate([0,-40,0]) rotate([15,0,0]) {
                translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                    translate([0,40,0]) rotate([0,0,-asin((40+25/cos(30))/(120+5-4))]) rotate_extrude(angle=-90+asin((40+25/cos(30))/(120+5-4)),$fn=$fn*2) {
                        $fn=$fn/2;
                        translate([120+5-4,0]) hull() {
                            translate([0,4*tan(25)]) circle(r=1.5);
                            circle(r=1.5);
                        }
                    }
                }
            }
            
        
        
             /*intersection() {
                translate([0,0,-200]) children();
                    
                translate([0,-40+75,0]) rotate([-15,0,0]) {
                    translate([0,-(-40+75),-200]) children();
                }
                
                translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,40,-200]) children();
                }
                translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                        translate([0,40,-200]) children();
                    }
                }
            }*/
        }
    }    
        
    
    //cutout neck hole
    translate([0,0,7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) {
            hull() {
                neck_spacer_shape(120-8,true);
                trans1() cylinder(r=120-8,h=200+0.01,$fn=$fn*2);
                cylinder(r=120-8,h=200,$fn=$fn*2);
            }
            translate([0,0,2+5-bev_s+0.01]) cylinder(r1=120-8,r2=120-8+bev_s,h=bev_s,$fn=$fn*2);
        }
    }
    
    translate([0,0,7.5]) rotate([-15,0,0]) translate([0,40,0]) {
        //side screws
        translate([0,-40+75,5+2-5]) rotate([0,0,0]) translate([0,-(-40+75),0]) {
           for(ia=[-1,1]*(60-7.5)) rotate([0,0,180+ia]) {
                screw_co();
            }
        }
        
        //back screws
        translate([0,-40,0]) {
            rotate([15*1/4*0,0,0]) translate([0,40,0]) {
                screw_co();
            }
            
            rotate([15,0,0]) translate([0,-25,0]) rotate([15*0,0,0]) translate([0,25,0]) translate([0,40,0]) {
                screw_co();
            }
        }
    }
        

    //cutouts for screws for interface from torso to neckring spacer
    for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) {
            for(ii=[0,1,4,5]) neck_space_mag_co(ii,true) {
                translate([0,0,-50]) cylinder(r=1.5+0.15,h=50+10);
                
                hull() for(j=[0,-20]) translate([0,j,5+2]) cylinder(r=3/cos(30)+0.15,h=5);
                translate([0,0,5]) hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,3/cos(30),0]) {
                    cylinder(r=0.15,h=2+0.01);
                }
            }
            for(ii=[2,3]) neck_space_mag_co(ii) {
                translate([0,0,-50]) cylinder(r=1.5+0.15,h=50+10);
                translate([0,0,0]) hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,3/cos(30),0]) {
                    cylinder(r=0.15,h=5);
                }
            }
        }
    }
}




module int_ac_segment() {
    clr = 0.2;
    
    rotate([0,0,30+7.5]) translate([0,-200-flange_wid/2,-200+2+5]) hull() {
        translate([0,0,-bev_s]) cube([200,200,200]);
        translate([0,-bev_s,0]) cube([200,200,200]);
    }
    intersection() {
        rotate([0,0,30+7.5]) translate([0,-200+flange_wid/2-clr,-100]) cube([200,200,200]);
        neck_spacer_shape(120-8+2.4);
    }
    hull() for(ibz=[0,bev_s]) for(ib=[0,bev_s]) intersection() {
        rotate([0,0,30+7.5]) translate([0,-200-flange_wid/2+(bev_s-ib)-(bev_s-ibz),-200+2+5]) cube([200,200,200-ibz]);
        neck_spacer_shape(120-8+2.4+ib);
    }
}

module int_a_segment() {
    clr = 0.2;
    
    difference() {
        union() {
            translate([-flange_wid/2+clr,-200,-200+2+5]) hull() {
                translate([0,0,-bev_s]) cube([200,200,200]);
                translate([bev_s,0,0]) cube([200,200,200]);
            }
            int_ac_segment();
        }
        hull() for(ib=[0,bev_s]) intersection() {
            translate([-200+flange_wid/2+(bev_s-ib),-200,-100]) cube([200,200,200]);
            neck_spacer_shape(120-8+2.4+ib,true);
        }
        hull() for(ibz=[0,bev_s]) for(ib=[0,bev_s]) intersection() {
            translate([-200+flange_wid/2+(bev_s-ib)+ibz,-200,2+5-(bev_s-ibz)]) cube([200,200,200]);
            neck_spacer_shape(120-8+2.4+ib+ibz,true);
        }
    }
}

module int_b_segment() {
    clr = 0.2;
    
    for(ix=[0,1]) mirror([ix,0,0]) difference() {
        union() {
            rotate([0,0,60-7.5]) translate([-flange_wid/2+clr,0,-200+2+5]) hull() {
                translate([0,0,-bev_s]) cube([200,200,200]);
                translate([bev_s,0,0]) cube([200,200,200]);
            }
        }
        hull() for(ib=[0,bev_s]) intersection() {
            rotate([0,0,60-7.5]) translate([-200+flange_wid/2+(bev_s-ib),0,-100]) cube([200,200,200]);
            neck_spacer_shape(120-8+2.4+ib,true);
        }
        hull() for(ibz=[0,bev_s]) for(ib=[0,bev_s]) intersection() {
            rotate([0,0,60-7.5]) translate([-200+flange_wid/2+(bev_s-ib)+ibz,0,2+5-(bev_s-ibz)]) cube([200,200,200]);
            neck_spacer_shape(120-8+2.4+ib+ibz,true);
        }
    }
}

module int_c_segment() {
    clr = 0.2;
    
    translate([-200-flange_wid/2,-200,-200+2+5]) hull() {
        translate([0,0,-bev_s]) cube([200,200,200]);
        translate([-bev_s,0,0]) cube([200,200,200]);
    }
    
    intersection() {
        translate([-200+flange_wid/2-clr,-200,-100]) cube([200,200,200]);
        neck_spacer_shape(120-8+2.4);
    }
    hull() for(ibz=[0,bev_s]) for(ib=[0,bev_s]) intersection() {
        translate([-200-flange_wid/2+(bev_s-ib)-(bev_s-ibz),-200,-200+2+5]) cube([200,200,200-ibz]);
        neck_spacer_shape(120-8+2.4+ib);
    }
    
    mirror([1,0,0]) int_ac_segment();
}

module screw_co() rotate([90,0,0]) {
    hull() {
        cylinder_oh(1.25,120-8+8-0.5);
        cylinder_oh(1.25-0.5,120-8+8);
    }
    hull() cylinder_oh(1.75,120-8+2.4+0.01);
    hull() {
        cylinder_oh(3,120-8);
        cylinder_oh(0.01,120-8+3);
    }
}

