$fn = 72;

use <PLSS Torso Shared Modules.scad>;
use <Neckring Torso Shared Modules.scad>;

include <../Neck Ring/Neck Ring Mk 1 Include.scad>;

inc_aircon = true; //include an air connector inlet and vent duct

bev_s = 0.4; //bevel
flange_wid = 15; //width of flange/tab used to join segments

//parameters for o-ring that is used to seal against the suit material
oring_rad = 1.5;
oring_area = 3.14159*pow(oring_rad,2);
oring_gland_rad = sqrt((0.9*oring_area)/3.14159); //compress to 90%

//used by make script
*/* make 'Neckring Interface A.stl' */ neckring_interface() mirror([1,0,0]) int_c_segment();
*/* make 'Neckring Interface B.stl' */ neckring_interface() int_b_segment();
*/* make 'Neckring Interface C.stl' */ neckring_interface() mirror([1,0,0]) int_a_segment();
*/* make 'Neckring Interface D.stl' */ aircon_block();

//assembled view
neckring_interface() translate([-200,-200,-200]) cube([400,400,400]);
translate([0,0,7.5]) {
    rotate([-15,0,0]) translate([0,40,0]) {
        trans_aircon_boss() translate([0,0,120+5+2.5]) {
            aircon_block();
        }
    }
}

module neckring_interface() {
    difference() {
        intersection() {
            translate([0,0,7.5]) {
                rotate([-15,0,0]) translate([0,40,0]) {
                    hull() neck_spacer_shape(120+5);
                    
                    //brim to match the radius of the neckring
                    translate([0,0,2]) hull() {
                        cylinder(r=120+5+5-bev_s,h=5,$fn=$fn*2);
                        translate([0,0,bev_s]) cylinder(r=120+5+5,h=5-2*bev_s,$fn=$fn*2);
                    }
                    //fillet
                    hull() {
                        cylinder(r=120+5,h=5+2,$fn=$fn*2);
                        translate([0,0,2]) cylinder(r=120+5+2,h=5,$fn=$fn*2);
                    }
                    
                    //boss for air connector
                    if(inc_aircon) aircon_boss_pos();
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
                //shift the cutout up to account for fabric thickness
                translate([0,0,1]) {
                    trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
                }
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
        
        //cutout groove for gasket
        for(ix=[0,1]) mirror([ix,0,0]) translate([0,0,/*(sqrt(pow(120+5,2)+pow(40,2))-(120+5))*/7.5]) {
            rotate([-15,0,0]) translate([0,40,0]) {
                //shift the cutout up to account for fabric thickness
                translate([0,0,1]) {
                    s1_a = asin((-40+75)/(120+5-4));
                    
                    translate([0,-40+75,0]) rotate([-15,0,0]) {
                        translate([0,-(-40+75),0]) rotate([0,0,s1_a]) rotate_extrude(angle=90-s1_a+0.01,$fn=$fn*2) gasket_co_cs($fn=$fn/2);
                    }
                    
                    //join the gap between gasket segments
                    hull() {
                        rotate([0,0,s1_a]) gasket_join_sphere();
                        translate([0,-40+75,0]) rotate([-15,0,0]) {
                            translate([0,-(-40+75),0]) rotate([0,0,s1_a]) gasket_join_z_sphere();
                        }
                        rotate([0,0,s1_a]) gasket_join_z_sphere();
                    }
                    
                    s3_a = -asin(40/(120+5-4));
                    
                    rotate([0,0,s3_a]) rotate_extrude(angle=-s3_a+s1_a,$fn=$fn*2) { 
                        $fn=$fn/2;
                        translate([120+5-4,0]) hull() {
                            translate([0,4*tan(25)]) circle(r=oring_gland_rad);
                            circle(r=oring_gland_rad);
                        }
                    }
                    
                    
                    hull() {
                        rotate([0,0,s3_a]) gasket_join_sphere();
                        rotate([0,0,s3_a]) gasket_join_z_sphere();
                        translate([0,-40,0]) rotate([15,0,0]) {
                            translate([0,40,0]) rotate([0,0,s3_a]) gasket_join_z_sphere();
                        }
                    }
                    
                    s4_a = -asin((25/cos(30))/(120+5-4));
                    
                    translate([0,-40,0]) rotate([15,0,0]) {
                        translate([0,40,0]) rotate([0,0,s3_a]) rotate_extrude(angle=s4_a,$fn=$fn*2) gasket_co_cs($fn=$fn/2);
                    }
                    
                    s34_a = -asin((40+25/cos(30))/(120+5-4));
                    
                    hull() {
                        translate([0,-40,0]) rotate([15,0,0]) {
                            translate([0,40,0]) rotate([0,0,s3_a+s4_a]) gasket_join_sphere();
                        }
                        translate([0,-40,0]) rotate([15,0,0]) {
                            translate([0,40,0]) rotate([0,0,s3_a+s4_a]) gasket_join_z_sphere();
                        }
                        translate([0,-40,0]) rotate([15,0,0]) {
                            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                                translate([0,40,0]) rotate([0,0,s34_a]) gasket_join_z_sphere();
                            }
                        }
                    }
                    
                    translate([0,-40,0]) rotate([15,0,0]) {
                        translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                            translate([0,40,0]) rotate([0,0,s34_a]) rotate_extrude(angle=-90-s34_a,$fn=$fn*2) gasket_co_cs($fn=$fn/2);
                        }
                    }
                }
            }
        }
        
        //cutouts for screws for joining segments
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
                    
                mag_is = (8+5)/2-0.75;
                mag_rad = (120-8+mag_is);
                mag_hgt = (120+5-mag_rad)*tan(25);
                    
                for(ii=[0,1,4,5]) neck_space_mag_co(ii,true) {
                    translate([0,0,-50]) cylinder(r=1.5+0.15,h=50+5+2+5+5);
                    
                    translate([0,0,5]) hull() {
                        cylinder(r=1.5+0.15+0.2,h=2+5);
                        translate([0,0,-0.2]) cylinder(r=1.5+0.15,h=2+5+2*0.2);
                    }
                    
                    hull() for(j=[0,-20]) translate([0,j,5+2]) hull() {
                        cylinder(r=3/cos(30)+0.15-bev_s,h=5);
                        translate([0,0,bev_s]) cylinder(r=3/cos(30)+0.15,h=5-2*bev_s);
                    }
                    
                    translate([0,0,5]) hull() {
                        for(i=[0:5]) rotate([0,0,i*60+30]) translate([0,3/cos(30),0]) {
                            cylinder(r=0.01,h=2+bev_s+0.01);
                            translate([0,0,0.15]) cylinder(r=0.15,h=2-0.15+bev_s+0.01);
                        }
                        translate([0,0,-(3/cos(30))*tan(22.5)]) cylinder(r=0.01,h=1);
                    }
                }
                for(ii=[2,3]) neck_space_mag_co(ii) {
                    translate([0,0,-50]) cylinder(r=1.5+0.15,h=50+10);
                    translate([0,0,-mag_hgt+5+2-bev_s+0.01]) cylinder(r1=1.5+0.15,r2=1.5+0.15+bev_s,h=bev_s);
                    
                    /*mag_is = (8+5)/2-0.75;
                    mag_rad = (120-8+mag_is);
                    mag_hgt = (120+5-mag_rad)*tan(25);
                    
                    translate([0,0,2+5-mag_hgt-1]) {
                        hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,3/cos(30),0]) {
                            cylinder(r=0.15,h=50);
                        }
                        hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,3/cos(30),-0.2]) {
                            cylinder(r=0.15,h=50);
                        }
                    }*/
                }
                  
                difference() {
                    for(ii=[0,1,4,5]) neck_space_mag_co(ii,true) {
                        hull() for(j=[0,-20]) translate([0,j,5+2-0.2]) hull() {
                            cylinder(r=3/cos(30)+0.15-bev_s,h=5);
                            translate([0,0,bev_s]) cylinder(r=3/cos(30)+0.15,h=5-2*bev_s);
                        }
                    }
                    
                    neck_spacer_shape(120-8+mag_is-3,true);
                }
            }
        }
        
        //cutouts for screws for interface to neckring
        translate([0,0,7.5]) rotate([-15,0,0]) translate([0,40,0]) {
            translate([0,0,5+2]) {
                base_ring_screw_pos() {
                    translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt-18]) cylinder_bev(1.25,50,0.5,0);
                    translate([0,0,-bev_s+0.01]) cylinder(r1=1.25,r2=1.25+bev_s,h=bev_s);
                }
            
                base_ring_screw_pos(true) {
                    cylinder_neg_bev(1.25,1.25,bev_s,0);
                    translate([0,0,bring_btm_hgt+lring_btm_hgt-1.8-8]) {
                        cylinder_bev(1.25,8,0,0.25);
                        translate([0,0,-50]) cylinder_bev(3,50+3,0,3-0.01);
                    }
                }
            }
        }
                    
        //cutouts for air connector
        if(inc_aircon) translate([0,0,7.5]) {
            rotate([-15,0,0]) translate([0,40,0]) {
                aircon_boss_neg();
            }
        }
    }
    
    //duct from air connector
    if(inc_aircon) translate([0,0,7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) {
            difference() {
                intersection() {
                    duct();
                    hull() neck_spacer_shape(120-8+bev_s);
                    
                    //intersections to create segments
                    children();
                }
                aircon_boss_neg();
            }
        }
    }
}

module gasket_join_sphere() {
    translate([120+5-4,0,0]) sphere(r=oring_gland_rad);
}

module gasket_join_z_sphere() {
    translate([120+5-4,0,4*tan(25)]) sphere(r=oring_gland_rad);
}

module gasket_co_cs() {
    translate([120+5-4,0])  hull() {
        translate([0,4*tan(25)]) circle(r=oring_gland_rad);
        circle(r=oring_gland_rad);
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
    
    #difference() {
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

module trans_aircon_boss(os_axis_rot=0,os_tilt_rot=0) {
    translate([0,-40,0]) rotate([15,0,0]) rotate([-5+os_tilt_rot,0,0]) translate([0,40,0]) {
        //cylinder(r=120+5,h=5);
        rotate([0,0,22.5+os_axis_rot]) rotate([90,0,0]) children();
    }
}

module aircon_boss_pos() {
    ac_blk_widh = 12.5;
    
    hull() {
        trans_aircon_boss() for(ix=[-1,1]*(ac_blk_widh-2.5)+[-5,5]) for(iy=[-1,1]*(ac_blk_widh-2.5)) translate([ix,iy,0]) cylinder(r=2.5,h=120+5+2.5);
        
        intersection() {
            neck_spacer_shape(120+5);
            trans_aircon_boss() for(ix=[-1,1]*(ac_blk_widh-2.5)+[-5,5]) for(iy=[-1,1]*(ac_blk_widh-2.5)) translate([ix,iy,0]) cylinder(r=2.5+2.5,h=120+5+2.5);
        }
    }
}

module aircon_boss_neg() {
    ac_blk_widh = 12.5;
    
    //air port routing
    port_r = 3;
    trans_aircon_boss() translate([0,0,120+5-2.4-port_r]) {
        hull() cylinder_oh(port_r,50);
    }
    hull() {
        trans_aircon_boss() translate([0,0,120+5-2.4-port_r]) rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
        trans_aircon_boss(-2.5) translate([0,0,120+5-2.4-port_r]) rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
    }
    hull() {
        trans_aircon_boss(-2.5) translate([0,0,120+5-2.4-port_r]) rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
        trans_aircon_boss(-2.5-7.5,-10) translate([0,0,120+5-2.4-port_r]) rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
    }
    hull() {
        trans_aircon_boss(-2.5-7.5,-10) translate([0,0,120+5-2.4-port_r]) rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
        trans_aircon_boss(-22.5+10,-10) translate([0,0,120+5-2.4-port_r]) rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
    }
    trans_aircon_boss(-22.5+10,-10) translate([0,0,120-8-2.5]) {
        hull() cylinder_oh(port_r,2.5+8+5-2.4-port_r);
        hull() {
            cylinder_oh(port_r,2.5+1);
            cylinder_oh(port_r+2.5+1,0.01);
        }
    }
        
    //o-ring
    trans_aircon_boss() translate([0,0,120+5+2.5]) rotate_extrude() hull() {
        oring_ir = 10/2;
        oring_r = 2/2;
        translate([0,0,0.5]) {
            translate([oring_ir+oring_r,0]) {
                circle(r=oring_r);
                translate([-(oring_r*sqrt(2)),0]) square([2*(oring_r*sqrt(2)),2]);
            }
        }
    }
    
    //screw holes
    trans_aircon_boss() for(ix=[-1,1]*(ac_blk_widh-3-1.6)) for(iy=[-1,1]*(ac_blk_widh-3-1.6)) translate([ix,iy,120+5+2.5]) {
        translate([0,0,-8+2.4]) hull() {
            cylinder_oh(1.25,50);
            translate([0,0,-0.5]) cylinder_oh(1.25-0.5,50);
        }
        hull() {
            cylinder_oh(1.75,50);
            translate([0,0,-(1.75-1.25)]) cylinder_oh(1.25,50);
        }
        translate([0,0,2.4]) hull() {
            cylinder_oh(3+1,50);
            translate([0,0,-3]) cylinder_oh(0.01,50);
        }
    }
}

module aircon_block() difference() {
    ac_blk_hgt = 18;
    ac_blk_widh = 12.5;
    
    hull() {
        for(ix=[-1,1]*(ac_blk_widh-2.5)) for(iy=[-1,1]*(ac_blk_widh-2.5)) translate([ix,iy,0]) {
            cylinder(r=2.5-bev_s,h=ac_blk_hgt);
            translate([0,0,bev_s]) cylinder(r=2.5,h=ac_blk_hgt-2*bev_s);
        }
        for(ix=[-1]*(ac_blk_widh-2.5)) for(iy=[-1,1]*(ac_blk_widh-2.5)) translate([ix-5,iy,0]) {
            cylinder(r=2.5-bev_s,h=ac_blk_hgt-5);
            translate([0,0,bev_s]) cylinder(r=2.5,h=ac_blk_hgt-5-2*bev_s);
        }
        
        translate([0,-(ac_blk_widh-bev_s),0]) cube([ac_blk_widh+10,2*(ac_blk_widh-bev_s),ac_blk_hgt]);
        translate([0,-ac_blk_widh,bev_s]) cube([ac_blk_widh+10,2*ac_blk_widh,ac_blk_hgt-2*bev_s]);
    }
    
    //screw holes
    for(ix=[-1,1]*(ac_blk_widh-3-1.6)) for(iy=[-1,1]*(ac_blk_widh-3-1.6)) translate([ix,iy,0]) rotate([0,0,90]) {
        translate([0,0,-8+2.4]) hull() {
            cylinder_oh(1.25,50);
            translate([0,0,-0.5]) cylinder_oh(1.25-0.5,50);
        }
        hull() {
            cylinder_oh(1.75,50);
            translate([0,0,-(1.75-1.25)]) cylinder_oh(1.25,50);
        }
        translate([0,0,2.4]) hull() {
            cylinder_oh(3,50);
            translate([0,0,-3]) cylinder_oh(0.01,50);
        }
        translate([0,0,ac_blk_hgt]) hull() {
            translate([0,0,-bev_s]) cylinder_oh(3,50);
            cylinder_oh(3+bev_s,50);
        }
    }
    
    //o-ring
    rotate_extrude() hull() {
        oring_ir = 10/2;
        oring_r = 2/2;
        translate([0,0,-0.5]) {
            translate([oring_ir+oring_r,0]) {
                circle(r=oring_r);
                translate([-(oring_r*sqrt(2)),-2]) square([2*(oring_r*sqrt(2)),2]);
            }
        }
    }
    
    //air port routing
    port_r = 3;
    translate([0,0,ac_blk_hgt/2]) hull() rotate([0,0,90]) {
        translate([0,0,-50]) cylinder_oh(port_r,50);
        
        rotate([90,0,0]) {
            sphere(r=port_r);
            translate([0,0,-port_r]) cylinder(r=port_r*tan(22.5),h=2*port_r);
        }
    }
    translate([0,0,ac_blk_hgt/2]) {
        rotate([0,90,0]) cylinder(r=port_r,h=50);
    }
    
    
    translate([10+2.5+10,0,ac_blk_hgt/2]) rotate([0,90,0]) {
        min_r = 11.445/2+0.15;
        maj_r = 13.157/2+0.15;
        pitch = 1.337;
        qd_h = 10; //depth of qd fitting
        
        translate([0,0,-qd_h]) hull() {
            cylinder(r=min_r,h=20);
            translate([0,0,-(min_r-port_r)]) cylinder(r=port_r,h=20);
        }
        
        hull() {
            translate([0,0,-qd_h]) cylinder(r=min_r,h=20);
            translate([0,0,-1.5*0.907-0.907]) cylinder(r=min_r+(maj_r-min_r)*0.5,h=20);
        }
        
        //lead-in
        hull() {
            translate([0,0,-1.5*0.907-0.907]) cylinder(r=min_r+(maj_r-min_r)*0.5,h=20);
            translate([0,0,-1.5*0.907]) cylinder(r=maj_r,h=20);
        }
        //top bevel
        translate([0,0,-bev_s+0.01]) cylinder(r1=maj_r,r2=maj_r+bev_s,h=bev_s);
    }
}

module duct() {
    inset = 0;
    
    translate([0,0,-0.01]) linear_extrude(height=5+2+0.01) duct_cs();
    
    translate([0,-40,0]) rotate([5,0,0]) {
        rotate([-90,0,0]) rotate([0,90,0]) rotate_extrude(angle=-5,$fn=$fn*2) translate([-40,0]) rotate([0,0,90]) duct_cs();
    }
    
    translate([0,-40,0]) rotate([5,0,0]) translate([0,40,0]) union() {
        rv = 2.5; //minor radius (how thick is the vent)
        rl = 120-8-0.2; //outside major radius
        a = 3*3.14159*pow(8/2,2); //area
        theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
        
        round_r0 = rv+1.6;
        round_r1 = 3;
        
        step_r0 = 120-8-2*rv-1.6;
        step_r1 = 120-8;
        step_a = asin(7.5/step_r1);
        theta2 = theta;
        
        hgt1 = 5+5;
        
        step_a_nr = asin(10/(120-8));
        

        ia_inc = 1/($fn/2);
        v_outset = 0;
        
        rotate([0,0,theta+step_a_nr]) difference() {
            for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv,0]) {
                    sphere(r=rv+1.6);
                    translate([0,50,0]) sphere(r=rv+1.6+20);
                }
            }
            
            for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv,0]) sphere(r=rv+v_outset);
            }
            translate([0,0,0.01]) cylinder(r=200,h=50);
        }
    }
}

module duct_cs() {
    rv = 2.5; //minor radius (how thick is the vent)
    rl = 120-8-0.2; //outside major radius
    a = 3*3.14159*pow(8/2,2); //area
    theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
    
    step_a_nr = asin(10/(120-8));
    
    rotate([0,0,theta+step_a_nr]) difference() {
        round_r0 = rv+1.6;
        round_r1 = 3;
        
        step_r0 = 120-8-2*rv-1.6;
        step_r1 = 120-8;
        step_a = asin(7.5/step_r1);
        theta2 = theta;

        ia_inc = 1/($fn/2);
        v_outset = 0;
        
        for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
            rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) {
                circle(r=rv+1.6);
                translate([0,50]) circle(r=rv+1.6+20);
            }
        }
        
        for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
            rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) circle(r=rv+v_outset);
        }
    }
}


module screw_co() rotate([90,0,0]) {
    hull() {
        cylinder_oh(1.25,120-8+8-0.5);
        cylinder_oh(1.25-0.5,120-8+8);
    }
    hull() cylinder_oh(1.75,120-8+2.4+0.01);
    hull() {
        cylinder_oh(3+1,120-8-1);
        cylinder_oh(0.01,120-8+3);
    }
}

