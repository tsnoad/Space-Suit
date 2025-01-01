/*
 * Spacesuit Helmet Mk 1
 * Licenced under CC BY-NC-SA 4.0
 * By: TSnoad
 * https://github.com/tsnoad/TBC
 * https://hackaday.io/project/TBC
 */

//$fn = 36;


include <../Neck Ring/Neck Ring Mk 1 Include.scad>;

include <Helmet Mk 1 Include.scad>;

include <Visor Mk 1.scad>;


//used by make script
*/* make 'Helmet Mk 1 AL.stl' */ union() {
    helmet() int_al_segment();
    mirror([1,0,0]) for(ia=[45]) support_leg_int(ia);
}
*/* make 'Helmet Mk 1 AR.stl' */ union() {
    helmet() int_ar_segment();
    for(ia=[45]) support_leg_int(ia);
}
*/* make 'Helmet Mk 1 BL.stl' */ union() {
    helmet() int_bl_segment();
    mirror([1,0,0]) for(ia=[-20,-65]) support_leg(ia);
    mirror([1,0,0]) for(ia=[-30,-60]) support_leg_int(ia);
}
*/* make 'Helmet Mk 1 BR.stl' */ union() {
    helmet() int_br_segment();
    for(ia=[-20,-65]) support_leg(ia);
    for(ia=[-30,-60]) support_leg_int(ia);
}
*/* make 'Helmet Mk 1 CL.stl' */ helmet() int_cl_segment();
*/* make 'Helmet Mk 1 CR.stl' */ helmet() int_cr_segment();
*/* make 'Helmet Mk 1 DL.stl' */ helmet() int_dl_segment();
*/* make 'Helmet Mk 1 DR.stl' */ helmet() int_dr_segment();
*/* make 'Helmet Mk 1 EL.stl' */ helmet() int_el_segment();
*/* make 'Helmet Mk 1 ER.stl' */ helmet() int_er_segment();
*/* make 'Helmet Mk 1 F1.stl' */ helmet() int_f_segment(0);
*/* make 'Helmet Mk 1 F2.stl' */ helmet() int_f_segment(90);
*/* make 'Helmet Mk 1 F3.stl' */ helmet() int_f_segment(180);
*/* make 'Helmet Mk 1 F4.stl' */ helmet() int_f_segment(270);


//assembled view
helmet() translate([-200,-200,0]) cube([400,400,400]);
*union() {
    //co_screws();
    
    helmet() int_al_segment();
    helmet() int_bl_segment();
    helmet() int_cl_segment();
    helmet() int_dl_segment();
    helmet() int_el_segment();
    
    helmet() int_ar_segment();
    helmet() int_br_segment();
    helmet() int_cr_segment();
    helmet() int_dr_segment();
    helmet() int_er_segment();
    
    helmet() int_f_segment(0);
    helmet() int_f_segment(90);
    helmet() int_f_segment(180);
    helmet() int_f_segment(270);
    
    //alignment indicators
    /*union() {
        *co_screws() {
            translate([0,0,-(scnd_rad-120)]) cylinder(r1=0,r2=5,h=(scnd_rad-120));
            cylinder(r1=5,r2=0,h=prime_r_in);
            
        }
        for(iz=[0,-(scnd_rad-120)]) translate([0,0,iz]) rotate([0,90,0]) {
            cylinder(r1=0,r2=5,h=50);
            translate([0,0,50]) cylinder(r1=5,r2=0,h=-50+prime_r_in);
        }
        color("green") translate([0,0,-(scnd_rad-120)]) rotate([15,0,0]) translate([0,0,(scnd_rad-120)]) rotate([0,90,0]) {
            cylinder(r1=0,r2=5,h=50);
            translate([0,0,50]) cylinder(r1=5,r2=0,h=-50+prime_r_in);
        }
    }*/
}

*/* make 'Visor Mk 1 G.stl' */ mount_inner();
*/* make 'Visor Mk 1 H.stl' */ mount_outer();
*/* make 'Visor Mk 1 I.stl' */ visor_arm();
*/* make 'Visor Mk 1 J.stl' */ rotate([0,0,(viewport_w_a/2-viewport_crn_w_a)]) visor_vert_brk();
*/* make 'Visor Mk 1 K.stl' */ visor_horiz_brk();
*/* make 'Visor Mk 1 M.stl' */ chin_bar_side(true);
*/* make 'Visor Mk 1 N.stl' */ chin_bar_side(false);
*/* make 'Visor Mk 1 O.stl' */ locking_bar(false);
*/* make 'Visor Mk 1 P.stl' */ pivot_bar();


//assembled view
*union() {
    //$t=0.4;
    //j = sin(($t*360-90))/2+0.5;
    j = 0;

    //over-center travel of locking bar
    //echo(-acos((bar_len-0.25)/bar_len));
    
    *helmet() translate([-200,-200,0]) cube([400,400,400]);

    *put_on_ring() translate([0,0,-20]) for(ixm=[0,1]) mirror([ixm,0,0]) datum_visor_from_helmet() {
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
        *mount_outer();
        
        *locking_wedge();
        
        trans_hinge(j_vis) {
            datum_helmet_from_visor() {
                visor_arm();
            
                translate([0,face_outset,20]) {
                    visor_vert_brk();
                    
                    if(ixm==0) for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) visor_horiz_brk();
                    
                    *if(ixm==0) visor_glass();
                }
            }
        }
        
        rotate([0,0,30]) translate([2*bar_len,0,0]) {
            pivot_bar_motion(j_lck) {
                translate([0,0,piv_arm_z0]) pivot_bar();
                
                *bolt_bearings_ph(mnt_out_z2);
                
                translate([bar_len,0,0]) {
                    *bolt_bearings_ph(piv_arm_z0);
                    
                    locking_bar_motion(j_lck) translate([-bar_len,0,lck_arm_z0]) {
                        locking_bar(false);
                        
                        if(ixm==0) trans_chin_bar_from_locking_bar() chin_bar_side(true);
                        if(ixm==0) trans_chin_bar_from_locking_bar() chin_bar_side(false);
                    }
                }
            }
        }
    }
    
    //check clearance
    /*intersection() {
        put_on_ring() helmet_shape(0);
        
        for(ic=[0:0.5/36:0.5]) {
            j = sin((ic*360-90))/2+0.5;
            
            #put_on_ring() translate([0,0,-20]) datum_visor_from_helmet() {
                j_vis = j;
                ot_a = acos((bar_len-0.25)/bar_len);
                        
                lck_rot_min = -acos((bar_len-0.25)/bar_len);
                lck_rot_max = acos((bar_len-17.5/2)/bar_len);
                
                j_lck = j*(lck_rot_max-lck_rot_min)+lck_rot_min;
                
                trans_hinge(j_vis) {
                    datum_helmet_from_visor() {
                        translate([0,face_outset,20]) {
                            rotate([0,0,90-(120+22.5)/2]) rotate_extrude(angle=120+22.5) translate([120,-200]) square([200,400]); 
                        }
                    }
                }
            }
        }
    }*/
}












    


module put_on_ring() {
    translate([0,-120-20,20]) {
        rotate([45,0,0]) {
            translate([0,scnd_rad+20,0]) {
                rotate([-30,0,0]) {
                    translate([0,0,scnd_rad-120]) {
                        children();
                    }
                }
            }
        }
    }
}

module trans_helmet_base() {
    translate([0,0,-(scnd_rad-120)]) rotate([120,0,0]) translate([0,0,120+20+(scnd_rad-120)]) rotate([0,90,0]) rotate([0,0,-45]) translate([120+20,0,0]) rotate([-90,0,0]) translate([0,0,-20]) children();
}

module helmet() difference() {
    union() {
        difference() {
            intersection() {
                //outside features
                union() {
                    intersection() {
                        put_on_ring() helmet_shape(0);
                        //outside bevel on bottom of helmet
                        cylinder(r1=prime_r-bev_l,r2=prime_r+500,h=bev_l+500,$fn=$fn*2);
                    }

                    put_on_ring() {
                        //locking ring lugs
                        trans_helmet_base() lug_ring();
                        
                        //visor mount
                        hull() {
                            translate([(head_min_rad+5),0,-20]) rotate([0,-90,0]) hull() {
                                cylinder(r=40+0.4,h=2*(120+5));
                                for(ia=[90,180,270]) rotate([0,0,ia+15]) translate([20,20,0]) cylinder(r=20+0.4,h=2*(120+5));
                            }
                            intersection() {
                                helmet_shape(0);
                                translate([200,0,-20]) rotate([0,-90,0]) hull() {
                                    cylinder(r=40+0.4+5,h=400);
                                    for(ia=[90,180,270]) rotate([0,0,ia+15]) translate([20,20,0]) cylinder(r=20+0.4+5,h=400);
                                }
                            }
                        }

                        shroud_guards();
                        hull() for(ib=[0,1]) intersection() {
                            helmet_shape(1-ib);
                            shroud_guards(ib);
                        }
                        
                        //bump ribs
                        for(k=[0,-45]) hull() for(ib=[0,5]) intersection() {
                            helmet_shape(5-ib);
                            
                            hull() translate([0,0,-10]) rotate([k,0,0]) for(ix=[-1,1]) rotate([0,0,ix*(k==0?30:60)]) rotate([90,0,0]) cylinder(r=5+ib,h=400);
                        }
                        
                        //cable port
                        cable_port_pos();
                    }
                }
                union() {
                    children();
                }
            }
            
            //cutout from outside features only
            union() {
                put_on_ring() helmet_shape(-wall_thk);
                put_on_ring() helmet_viewport();
                
                translate([0,0,-50]) cylinder(r=prime_r_in,h=50+20);
                
                translate([0,0,-0.01]) cylinder(r1=prime_r_in+bev_xs,r2=prime_r_in,h=bev_xs,$fn=$fn*2);
                
                //cable port cutout
                put_on_ring() cable_port_neg();
                
                put_on_ring() for(ix=[0,1]) mirror([ix,0,0]) {
                    //cutout from shroud guards
                    hull() translate([0,0,-20]) rotate([0,-90,0]) {
                        translate([0,0,120+5]) {
                            hull() {
                                cylinder(r=40,h=200);
                                translate([0,0,0.4]) cylinder(r=40+0.4,h=200);
                            }
                        }
                        for(ia=[90,180,270]) rotate([0,0,ia+15]) translate([20,20,120+5]) {
                            hull() {
                                cylinder(r=20,h=200);
                                translate([0,0,0.4]) cylinder(r=20+0.4,h=200);
                            }
                        }
                    }
                    hull() translate([0,0,-20]) rotate([0,-90,0]) {
                        translate([0,0,120+5]) {
                            translate([0,0,30-5]) hull() {
                                cylinder(r=40+0.4+0.4,h=200);
                                translate([0,0,-0.4]) cylinder(r=40+0.4,h=200);
                            }
                        }
                        for(ia=[90,180,270]) rotate([0,0,ia+15]) translate([20,20,120+5]) {
                            translate([0,0,30-5]) hull() {
                                cylinder(r=20+0.4+0.4,h=200);
                                translate([0,0,-0.4]) cylinder(r=20+0.4,h=200);
                            }
                        }
                    }
                        
                    //cutout for clearance for visor moving parts
                    translate([0,0,-20]) datum_visor_from_helmet() translate([20,5,0]) rotate([0,0,-15]) hull() {
                        translate([0,0,-5]) cylinder(r1=22.5,r2=22.5+10,h=10);
                        translate([0,7.5,-5]) cylinder(r1=22.5,r2=22.5+10,h=10);
                        translate([-(22.5-7.5),-(22.5-7.5),-5]) cylinder(r1=7.5,r2=7.5+10,h=10);
                    }
                }
                
                //remove some material to make print faster
                /*hull() {
                    intersection() {
                        put_on_ring() rotate([17.5,0,0]) rotate([0,0,45]) rotate([90,0,0]) hull() {
                            cylinder(r=37.5,h=200);
                            rotate([0,0,15]) rotate([10,0,0]) cylinder(r=25,h=200);
                        }
                        put_on_ring() helmet_shape(-2.4);
                    }
                    intersection() {
                        put_on_ring() rotate([17.5,0,0]) rotate([0,0,45]) rotate([90,0,0]) hull() {
                            cylinder(r=37.5+(8-2.4),h=200);
                            rotate([0,0,15]) rotate([10,0,0]) cylinder(r=25+(8-2.4),h=200);
                        }
                        put_on_ring() helmet_shape(-8);
                    }
                }*/
            }
        }
            
        //inside features
        intersection() {
            union() {
                //comms mounts
                for(ix=[0,1]) mirror([ix,0,0]) put_on_ring() translate([prime_r_in-2,15,-35]) rotate([0,90,0]) rotate_extrude() polygon([
                    [35-7.5,0],
                    [35+7.5,0],
                    [35+7.5+20,20],
                    [35-7.5-20,20],
                ]);
                
                //ventilation duct
                duct();
            }
            
            put_on_ring() helmet_shape(-0.01);
            
            cylinder(r1=prime_r-bev_l,r2=prime_r+500,h=bev_l+500,$fn=$fn*2);
            
            union() {
                children();
            }
        }
    }
        
    //all the screws that join the segmetns
    intersection() {
        co_screws();
        //ensure there is al
        put_on_ring() helmet_shape(-1.6);
    }
    
                    
    //screws to mount visor pivot assembly
    put_on_ring() for(ix=[0,1]) mirror([ix,0,0]) translate([0,0,-20]) datum_visor_from_helmet() translate([20,5,0]) mount_inner_screw_pos() {
        //translate([0,0,-8]) cylinder(r=1.25,h=50);
        
        screw_len=8;
        screw_dep=screw_len-2;
        inner_rot = 0;
        outer_rot = 0;
        
        translate([0,0,-screw_dep]) hull() {
            cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
            translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
            translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
        }
        
        hull() {
            cylinder_oh_opt(1.5+0.15,20,true,outer_rot);
            translate([0,0,-(1.5+0.15)]) cylinder_oh_opt(0.01,20,true,outer_rot);
        }
        
        translate([0,0,screw_len-screw_dep]) hull() {
            translate([0,0,5]) cylinder_oh_opt(3+5,20,true,outer_rot);
            translate([0,0,-3]) cylinder(r=0.01,h=20);
        }
    }
    
    //comms mounts
    put_on_ring() for(ix=[0,1]) mirror([ix,0,0]) translate([prime_r_in-2,15,-35]) rotate([0,-90,0]) for(ia=[0:90:360-90]) rotate([0,0,ia+45+15]) translate([0,35,0]) rotate([0,0,ia+45]) {
        screw_len=8;
        screw_dep=screw_len-3;
        inner_rot = 0;
        outer_rot = 0;
        
        translate([0,0,-screw_dep]) hull() {
            cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
            translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
            translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
        }
        
        hull() {
            cylinder_oh_opt(1.5+0.15,20,true,outer_rot);
            translate([0,0,-(1.5+0.15)]) cylinder_oh_opt(0.01,20,true,outer_rot);
        }
        
        translate([0,0,screw_len-screw_dep]) hull() {
            translate([0,0,5]) cylinder_oh_opt(3+5,20,true,outer_rot);
            translate([0,0,-3]) cylinder(r=0.01,h=20);
        }
    }
    
    translate([0,0,-0.01]) rotate_extrude($fn=$fn*2) union() {
        //cutout for the o-ring gland
        polygon([
            [oring_gland_rad+oring_gland_wid/2+bev_xs,0],
            [oring_gland_rad+oring_gland_wid/2,bev_xs],
            [oring_gland_rad+oring_gland_wid/2,oring_gland_dep-bev_s],
            [oring_gland_rad+oring_gland_wid/2-bev_s,oring_gland_dep],
            [oring_gland_rad-oring_gland_wid/2+bev_s,oring_gland_dep],
            [oring_gland_rad-oring_gland_wid/2,oring_gland_dep-bev_s],
            [oring_gland_rad-oring_gland_wid/2,bev_xs],
            [oring_gland_rad-oring_gland_wid/2-bev_xs,0],
        ]);
    }
}

module cable_port_trans(rotate_to_horiz=false) {
    translate([0,0,prime_r-scnd_rad]) rotate([30,0,0]) rotate([0,0,30]) rotate([90,0,0]) {
        //rotate to align with neckring datum
        //I love this function so much, it's also useful for graphing orbital paths!
        rotate([0,0,-(rotate_to_horiz?1:0)*atan(sin(30)/tan(90-30-15))]) {
            translate([0,0,scnd_rad]) {
                children();
            }
        }
    }
}

module cable_port_pos() {
    hull() {
        cable_port_trans() rotate_extrude() translate([15,0]) circle(r=2.5);
        
        intersection() {
            helmet_shape(0);
            cable_port_trans() translate([0,0,-50]) cylinder(r=15+2.5+5,h=400);
        }
    }
    
    //placeholder for comms cable gland
    *%cable_port_trans(true) {
        translate([0,0,5-4]) rotate([0,0,-15]) {
            cylinder(r=7.5,h=23-7.5);
            translate([0,0,23-7.5]) {
                sphere(r=7.5);
                rotate([0,90,0]) {
                    cylinder(r=7.5,h=40-7.5);
                    translate([0,0,17-7.5]) cylinder(r=9.25/cos(30),h=18,$fn=6);
                }
            }
        }
    }
}
module cable_port_neg() {
    gland_r = 8;
    gland_nut_r = 9.5/cos(30);
    
    cable_port_trans(true) {
        hull() translate([0,0,-50]) cylinder_oh(gland_r,200);
        
        //recess to clock gland
        translate([0,0,5-4]) rotate([0,0,30-15]) cylinder(r1=gland_nut_r,r2=gland_nut_r+50*tan(45),h=50,$fn=6);
    }
    
    //inside recess
    hull() {
        cable_port_trans() translate([0,0,-50]) cylinder(r=12.5,h=50+5-4-4);
        intersection() {
            helmet_shape(-wall_thk);
            cable_port_trans() translate([0,0,-50]) cylinder(r=12.5+5,h=200);
        }
    }
}


module co_screws() {
    put_on_ring() {
        //A-A screws
        translate([0,face_outset,face_bottom]) translate([0,prime_r*(cos(viewport_w_a/2)),0]) rotate([-15,0,0]) {
            rotate([5,0,0]) translate([0,-prime_r*(cos(viewport_w_a/2)),0]) rotate([0,0,asin(15/2/(prime_r_in+2.4))]) {
                rotate([-90,0,0]) translate([0,0,-prime_r_in*0]) flange_screw_co(0,0);
            }
            
            translate([0,-120*(cos(viewport_w_a/2)),0]) rotate([0,0,asin(15/2/(prime_r_in+2.4))]) {
                rotate([-90,0,0]) translate([0,0,(120-37.5)]) rotate([-45,0,0]) {
                translate([0,0,-(120-37.5)]) flange_screw_co(0,0);
                }
            }
        }
        
        
        //A-E screws
        for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,face_outset,0]) for(ia=[asin(25/120)]) rotate([0,0,ia]) translate([0,0,-120*sin(ia)*tan(15)-face_outset*tan(15)-(scnd_rad-120)*cos(15)+(17.5)+(15/2)/cos(15)]) rotate([0,90,0]) flange_screw_co(90-15,90-15);
    
        //B-B screws
        translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) {
            pos_screw(-7.5,17.5+7.5,(scnd_rad-120));
            for(iz=[-30,-80]) pos_screw(-7.5,iz,(scnd_rad-120));
        }
        
        //B-C screws
        for(ia=[-75,-40,25,47.5,75]) {
            translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) pos_screw(120*sin(ia),17.5+7.5,(scnd_rad-120));
        }
        
        //B-D screws
        for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) {
            translate([0,15,17.5+7.5]) rotate([0,90,0]) flange_screw_co(90,90-(60-7.5));
        }
        
        //C-C, D-D screws
        translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) for(screw_a=[30,65]) {
            screw_x = -7.5;
            screw_rot = 0;
            
            rotate([-screw_a-asin((scnd_rad-120)/scnd_rad),0,0]) {
                translate([0,-(scnd_rad-120),0]) rotate([0,0,asin(screw_x/120)]) {
                    rotate([90,0,0]) flange_screw_co(screw_rot,screw_rot);
                }
            }
        }
        
        //C-D screws
        for(ixm=[0,1]) mirror([ixm,0,0]) for(ia=[20,65]) {
            datum_cd() pos_screw(120*sin(ia),7.5,(scnd_rad-120),-(60-7.5));
        }
        
        //D-E screws
        for(ixm=[0,1]) mirror([ixm,0,0]) for(ia=[20,45]) {
            datum_de() pos_screw(120*sin(ia),7.5,(tert_rad-120),-(105-7.5-60));
        }
        
        //D-D, E-E screws
        translate([0,0,-(tert_rad-120)]) rotate([-15,0,0]) for(screw_a=[60,80,95]) {
            screw_x = -7.5;
            screw_rot = 0;
            
            rotate([-screw_a-asin((tert_rad-120)/scnd_rad),0,0]) {
                translate([0,-(tert_rad-120),0]) rotate([0,0,asin(screw_x/120)]) {
                    rotate([90,0,0]) flange_screw_co(screw_rot,screw_rot);
                }
            }
        }
        
    }
    
    //A-B screws
    for(ixm=[0,1]) mirror([ixm,0,0]) for(iz=[70,130]) translate([0,-10+15/2,iz]) rotate([0,90,0]) flange_screw_co(90,90);
    
    //F-A/B screws
    for(ia=
        [-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1]*(atan(10/prime_r_in))
        +[0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1]*45
        +[0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3]*90
        +[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0]*22.5 //match location of A-B seam
        +[0,0,0,0,-1,-1,0,0,0,0,0,0,1,1,0,0]*(atan(10/120)) //avoid the ventilation duct
    ) rotate([0,0,ia]) translate([0,0,5+5+15/2]) rotate([90,0,0]) flange_screw_co(0,0);
}

// screw_z is relative to center of torus
module pos_screw(screw_x,screw_z,tor_maj_rad,rot_extra=0) {
    screw_y = tor_maj_rad + sqrt(pow(120,2)-pow(screw_x,2));
    
    screw_rot = -atan(sin(asin(screw_x/120))/tan(90-rot_extra+asin(screw_z/screw_y)));
    
    rotate([-asin(screw_z/screw_y),0,0]) {
        translate([0,-tor_maj_rad,0]) rotate([0,0,asin(screw_x/120)]) {
            rotate([90,0,0]) flange_screw_co(screw_rot,screw_rot);
        }
    }
}

module flange_screw_co(outer_rot=0,inner_rot=0) translate([0,0,prime_r_in]) mirror([0,0,1]) {
    screw_len=6;
    screw_dep=8-1.6;
    
    translate([0,0,-screw_dep]) hull() {
        cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
        translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
        translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
    }
    
    hull() {
        cylinder_oh_opt(1.5+0.15,20,true,outer_rot);
        translate([0,0,-(1.5+0.15)]) cylinder_oh_opt(0.01,20,true,outer_rot);
    }
    
    translate([0,0,screw_len-screw_dep]) hull() {
        translate([0,0,5]) cylinder_oh_opt(3+5,20,true,outer_rot);
        translate([0,0,-3]) cylinder(r=0.01,h=20);
    }
}





module int_ar_segment() {
    difference() {
        intersection() {
            union() {
                translate([0,-10+flange_clr_ext,flange_clr_ext]) cube([200,200,200]);
                
                intersection() {
                    put_on_ring() helmet_shape(-8+2.4);
                    
                    hull() {
                        translate([0,15-10,(5+5+15)]) cube([200,200,200]);
                        translate([-15+flange_clr_int,15-10,(5+5+15)+15]) cube([200,200,200]);
                    }
                }
            }
               
            put_on_ring() {
                datum_upper_lower() translate([-200,0,-200]) cube([400,400,200]);
                intersection() {
                    helmet_shape(-8+2.4);
                    //B-C flange pos
                    datum_upper_lower() translate([-200,-200,-200+15-flange_clr_int]) cube([400,400,200]);
                }
            }
        }
            
        //A-B flange recess
        intersection() {
            put_on_ring() helmet_shape(-8+2.4+0.01);
            translate([0,-200+15-10,0]) cube([200,200,200]);
        }
        
        //F-A/B flange recess
        translate([0,0,-0.01]) {
            cylinder(r=200,h=5+5+flange_clr_ext);
            hull() {
                cylinder(r=prime_r_in+2.4,h=5+5+15,$fn=$fn*2);
                cylinder(r=prime_r_in+2.4-50,h=5+5+15+50,$fn=$fn*2);
            }
        }
    }
}

module int_al_segment() {
    difference() {
        intersection() {
            union() {
                translate([-200-flange_clr_ext,-10+flange_clr_ext,flange_clr_ext]) cube([200,200,200]);
            }
               
            put_on_ring() {
                datum_upper_lower() translate([-200,0,-200]) cube([400,400,200]);
                intersection() {
                    helmet_shape(-8+2.4);
                    //B-C flange pos
                    datum_upper_lower() translate([-200,-200,-200+15-flange_clr_int]) cube([400,400,200]);
                }
            }
        }
            
        //A-B flange recess
        intersection() {
            put_on_ring() helmet_shape(-8+2.4+0.01);
            translate([-200,-200+15-10,0]) cube([200,200,200]);
        }
        
        //A-A flange recess
        intersection() {
            put_on_ring() helmet_shape(-8+2.4+0.01);
            translate([-15,-10,5+5+15]) cube([200,200,200]);
        }
        
        
        //F-A/B flange recess
        translate([0,0,-0.01]) {
            cylinder(r=200,h=5+5+flange_clr_ext);
            hull() {
                cylinder(r=prime_r_in+2.4,h=5+5+15,$fn=$fn*2);
                cylinder(r=prime_r_in+2.4-50,h=5+5+15+50,$fn=$fn*2);
            }
        }
    }
}


module int_br_segment() {
    difference() {
        intersection() {
            union() {
                translate([0,-200-10,0]) cube([200,200,400]);
                
                intersection() {
                    put_on_ring() helmet_shape(-8+2.4);
                    hull() {
                        translate([0,-200-10,(5+5+15)]) cube([200,200,400]);
                        translate([-15,-200-10+15,(5+5+15)+15]) cube([200,200,400]);
                    }
                }
            }
            
            put_on_ring() {
                datum_upper_lower() translate([-200,-200,-200]) cube([400,400,200]);
            
                //rotate([-15,0,0]) translate([-200,-200,-200]) cube([400,400,200]);
                
                intersection() {
                    helmet_shape(-8+2.4);
                    datum_upper_lower() translate([-200,-200,-200+15]) cube([400,400,200]);
                }
            }
        }
        
        translate([0,0,-0.01]) cylinder(r=200,h=5+5);
        
        translate([0,0,-0.01]) hull() {
            cylinder(r=prime_r_in+2.4,h=5+5+15);
            cylinder(r=prime_r_in+2.4-50,h=5+5+15+50);
        }
    }
}

module int_br_segment() {
    difference() {
        intersection() {
            union() {
                translate([0,-200-10,0]) cube([200,200,400]);
                
                intersection() {
                    put_on_ring() helmet_shape(-8+2.4);
                    hull() {
                        translate([0,-200-10,(5+5+15)]) cube([200,200,400]);
                        translate([-15,-200-10+15,(5+5+15)+15]) cube([200,200,400]);
                    }
                }
            }
            
            put_on_ring() {
                datum_upper_lower() translate([-200,-200,-200]) cube([400,400,200]);
            
                //rotate([-15,0,0]) translate([-200,-200,-200]) cube([400,400,200]);
                
                intersection() {
                    helmet_shape(-8+2.4);
                    datum_upper_lower() translate([-200,-200,-200+15]) cube([400,400,200]);
                }
            }
        }
        
        translate([0,0,-0.01]) cylinder(r=200,h=5+5);
        
        translate([0,0,-0.01]) hull() {
            cylinder(r=prime_r_in+2.4,h=5+5+15);
            cylinder(r=prime_r_in+2.4-50,h=5+5+15+50);
        }
    }
}

module int_bl_segment() {
    difference() {
        intersection() {
            union() {
                translate([-200-flange_clr_ext,-200-10,flange_clr_ext]) cube([200,200,200]);
                
                intersection() {
                    put_on_ring() helmet_shape(-8+2.4);
                    
                    //A-B flange pos
                    hull() {
                        translate([-200-15,-200-10,(5+5+15)]) cube([200,200,200]);
                        translate([-200-15,-200-10+15-flange_clr_int,(5+5+15)+15]) cube([200,200,200]);
                    }
                }
            }
            
            put_on_ring() {
                datum_upper_lower() translate([-200,-200,-200]) cube([400,400,200]);
                intersection() {
                    helmet_shape(-8+2.4);
                    //B-C flange pos
                    datum_upper_lower() translate([-200,-200,-200+15-flange_clr_int]) cube([400,400,200]);
                }
            }
            
            translate([0,0,5+5+flange_clr_ext]) cylinder(r1=120-bev_xs,r2=120+200,h=bev_xs+200,$fn=$fn*2);
        }
        
        translate([0,0,5+5+flange_clr_ext-0.01]) cylinder(r1=prime_r_in+2.4+bev_xs,r2=prime_r_in+2.4,h=bev_xs,$fn=$fn*2);
        
        //B-B flange recess
        intersection() {
            put_on_ring() helmet_shape(-8+2.4+0.01);
            translate([-15,-200-10,0]) cube([200,200,200]);
        }
        
        //F-A/B flange recess
        translate([0,0,-0.01]) {
            cylinder(r=200,h=5+5+flange_clr_ext);
            hull() {
                cylinder(r=prime_r_in+2.4,h=5+5+15,$fn=$fn*2);
                cylinder(r=prime_r_in+2.4-50,h=5+5+15+50,$fn=$fn*2);
            }
        }
    }
}

//should always exist inside put_on_ring()
module datum_upper_lower() {
    translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) translate([0,0,17.5]) children();
}

module datum_cd() {
    translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) rotate([-(60-7.5),0,0]) children();
}

module datum_de() {
    translate([0,0,-(tert_rad-120)]) rotate([-15,0,0]) rotate([-(105-7.5),0,0]) children();
}

module int_cr_segment() {
    difference() {
        put_on_ring() {
            intersection() {
                datum_upper_lower() translate([0,-200,flange_clr_ext]) cube([200,400,200]);
                datum_cd() translate([0,-200,-200]) cube([200,400,200]);
            }
            intersection() {
                helmet_shape(-8+2.4);
                //C-D flange pos
                datum_cd() translate([-15+flange_clr_ext,-200,-200+15-flange_clr_ext]) cube([200,400,200]);
                datum_cd() translate([-15+flange_clr_ext,-200-17.5/cos(60-7.5)-17.5*sin(60-7.5),-200]) cube([200,200,400]);
                //C-C flange pos
                datum_upper_lower() hull() {
                    translate([-15+flange_clr_ext,-200,15+15]) cube([200,400,200]);
                    translate([0,-200,15]) cube([400,400,200]);
                }
            }
        }
        
        //B-C flange recess
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
    }
}

module int_cl_segment() {
    difference() {
        put_on_ring() {
            intersection() {
                datum_upper_lower() translate([-200-flange_clr_ext,-200,flange_clr_ext]) cube([200,400,200]);
                datum_cd() translate([-200-flange_clr_ext,-200,-200]) cube([200,400,200]);
                
            }
            intersection() {
                helmet_shape(-8+2.4);
                //C-D flange pos
                datum_cd() translate([-15-200,-200,-200+15-flange_clr_int]) cube([200,400,200]);
                datum_cd() translate([-15-200,0-17.5/cos(60-7.5)-17.5*sin(60-7.5)-flange_clr_int,0]) rotate([7.5,0,0]) translate([0,-200,-200]) cube([200,200,400]);
            }
        }
        
        //C-C flange recess
        intersection() {
            put_on_ring() helmet_shape(-8+2.4+0.01);
            translate([-15,-200-10,0]) cube([200,200,400]);
        }
        
        //B-C flange recess
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
    }
}

module int_dr_segment() {
    difference() {
        put_on_ring() {
            intersection() {
                datum_upper_lower() translate([0,-200,flange_clr_ext]) cube([200,400,200]);
                
                datum_cd() translate([0,-200,flange_clr_ext]) cube([200,400,200]);
                datum_de() translate([0,-200,-200]) cube([200,400,200]);
            }
            intersection() {
                helmet_shape(-8+2.4);
                //D-E flange pos
                datum_de() translate([-15+flange_clr_int,-200,-200+15-flange_clr_int]) cube([200,400,200]);
                //D-D flange pos
                datum_cd() hull() {
                    translate([-15+flange_clr_int,-200,15+15]) cube([200,400,200]);
                    translate([0,-200,15]) cube([400,400,200]);
                }
                
                translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) rotate([-(105-7.5),0,0]) {
                    translate([-15,0-(15)/cos(105-7.5-90)-17.5*sin(105-7.5)-flange_clr_int,0]) rotate([7.5+7.5,0,0]) translate([0,-200,-200]) cube([200,200,400]);
                }
            }
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            //datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
            datum_cd() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
    }
}

module int_dl_segment() {
    difference() {
        put_on_ring() {
            intersection() {
                datum_upper_lower() translate([-200-flange_clr_ext,-200,flange_clr_ext]) cube([200,400,200]);
                
                datum_cd() translate([-200-flange_clr_ext,-200,0]) cube([200,400,200]);
                datum_de() translate([-200-flange_clr_ext,-200,-200]) cube([200,400,200]);
            }
            intersection() {
                helmet_shape(-8+2.4);
                datum_upper_lower() translate([-200,-200,flange_clr_ext]) cube([200,400,200]);
                
                //D-E flange pos
                datum_de() translate([-15-200,-200,-200+15-flange_clr_int]) cube([200,400,200]);
                datum_cd() translate([-200,-200,15]) cube([400,400,200]);
                
                
                translate([0,0,-(scnd_rad-120)]) rotate([-15,0,0]) rotate([-(105-7.5),0,0]) {
                    translate([-15-200,0-(15)/cos(105-7.5-90)-17.5*sin(105-7.5)-flange_clr_int,0]) rotate([7.5+7.5,0,0]) translate([0,-200,-200]) cube([200,200,400]);
                }
            }
        }
        
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
        
        //D-D flange recess
        intersection() {
            put_on_ring() helmet_shape(-8+2.4+0.01);
            translate([-15,-200-10,0]) cube([200,400,400]);
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            //datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
            datum_cd() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
    }
}

module int_er_segment() {
    difference() {
        put_on_ring() {
            intersection() {
                datum_upper_lower() translate([0,-200,flange_clr_ext]) cube([200,400,200]);
                datum_de() translate([0,-200,0]) cube([200,400,200]);
            }
            intersection() {
                helmet_shape(-8+2.4);
                datum_de() translate([-15+flange_clr_int,-200,0]) cube([200,200,200]);
                datum_de() hull() {
                    translate([-15+flange_clr_int,-200,15+15]) cube([200,400,200]);
                    translate([0,-200,15]) cube([200,400,200]);
                }
            }
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_de() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
    }
}

module int_el_segment() {
    difference() {
        put_on_ring() {
            intersection() {
                datum_upper_lower() translate([-200,-200,flange_clr_ext]) cube([200,400,200]);
                datum_de() translate([-200,-200,0]) cube([200,400,200]);
            }
            *intersection() {
                helmet_shape(-8+2.4);
                datum_de() translate([-15+flange_clr_int,-200,0]) cube([200,200,200]);
                datum_de() hull() {
                    translate([-15+flange_clr_int,-200,15+15]) cube([200,400,200]);
                    translate([0,-200,15]) cube([200,400,200]);
                }
            }
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_upper_lower() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            translate([-15,-200-10,0]) cube([200,400,400]);
        }
        
        put_on_ring() hull() for(ib=[0,2.4]) intersection() {
            helmet_shape(-8+2.4-ib+0.01);
            datum_de() translate([-200,-200,-200+15+ib]) cube([400,400,200]);
        }
    }
}

module int_f_segment(seg_rot=0) {
    rotate([0,0,seg_rot]) intersection() {
        union() {
            cylinder(r=200,h=5+1);
            hull() {
                cylinder(r=120-bev_xs,h=5+5,$fn=$fn*2);
                cylinder(r=120,h=5+5-bev_xs,$fn=$fn*2);
            }
            hull() {
                cylinder(r=prime_r_in+2.4,h=5+5+bev_xs,$fn=$fn*2);
                cylinder(r=prime_r_in+2.4+bev_xs,h=5+5,$fn=$fn*2);
            }
            cylinder(r=prime_r_in+2.4,h=5+5+15/2,$fn=$fn*2);
            
            intersection() {
                cylinder(r=prime_r_in+2.4,h=200,$fn=$fn*2);
                screw_angles = [-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1,-1,1]*(atan(10/prime_r_in))
                    +[0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1]*45
                    +[0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3]*90
                    +[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0]*22.5 //match location of A-B seam
                    +[0,0,0,0,-1,-1,0,0,0,0,0,0,1,1,0,0]*(atan(10/120)) //avoid the ventilation duct
                ;
                
                rotate([0,0,-seg_rot]) for(ia=[0:2:16-1]) hull() {
                    rotate([0,0,screw_angles[ia]]) translate([0,0,5+5+15/2]) {
                        rotate([90,0,0]) cylinder(r=15/2,h=200);
                        translate([-50,0,-50]) rotate([90,0,0]) cylinder(r=15/2,h=200);
                    }
                    rotate([0,0,screw_angles[ia+1]]) translate([0,0,5+5+15/2]) {
                        rotate([90,0,0]) cylinder(r=15/2,h=200);
                        translate([50,0,-50]) rotate([90,0,0]) cylinder(r=15/2,h=200);
                    }
                }
            }
            
        }
        rotate([0,0,180+45]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,200]);
    }
    
    
    rv = 2.5; //minor radius (how thick is the vent)
    rl = prime_r_in-0.2; //outside major radius
    a = 3*3.14159*pow(8/2,2); //area
    theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
    
    step_a_nr = asin(10/prime_r_in);
    
    intersection() {
        difference() {
            #rotate([0,0,-90]) rotate_extrude(angle=2*(theta+step_a_nr),$fn=$fn*2) polygon([
                [0,5],
                [prime_r_in+2.4,5],
                [prime_r_in+2.4,5+5+15-0.1],
                [prime_r_in+2.4-50,5+5+15-0.2+50],
                [0,5+5+15-0.1+50],
            ]);
            for(ia=[0,2*(theta+step_a_nr)]) rotate([0,0,ia]) translate([0,0,5+5+15+5]) rotate([90,0,0]) cylinder(r=5,h=200);
        }
        rotate([0,0,seg_rot]) {
            rotate([0,0,180+45]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,200]);
        }
    }
}


    
module helmet_shape(inset=0) intersection() {
    int_topback(inset);
    int_bottomback(inset);
    int_topfront(inset);
    int_bottomfront(inset);
}

    
module int_topback(inset=0) {
    hull() {
        for(iz=[0,-(scnd_rad-120)]) translate([0,0,iz]) rotate([-90,0,0]) cylinder(r=120+inset,h=500,$fn=$fn*2);
        
        translate([0,0,-(scnd_rad-120)]) {
            rotate([180,0,0]) boule(inset,scnd_rad-120,$fn=$fn*2);

            rotate([30,0,0]) {
                translate([0,0,-500]) rotate([180,0,0]) boule(inset,scnd_rad-120,$fn=$fn*2);
            }
        }
    }
    
    translate([0,0,-(scnd_rad-120)]) {
        rotate([30,0,0]) {
            rotate([0,0,180]) rotate_extrude(angle=180) translate([0,-500]) square([500,500]);
        }
    }
}
    
module int_bottomback(inset=0) {
    translate([0,0,-(scnd_rad-120)]) rotate([120,0,0]) translate([0,0,120+20+(scnd_rad-120)]) rotate([0,90,0]) {
        rotate_extrude(angle=-45,$fn=$fn*2) translate([120+20,0]) {
            hull() for(iy=[0,500]) translate([iy,0]) circle(r=120+inset);
        }
    
        rotate([0,0,-45]) translate([120+20,0,0]) rotate([-90,0,0]) translate([0,0,-20]) {
            hull() for(iy=[0,500]) translate([iy,0,0]) cylinder(r=120+inset,h=20+0.01,$fn=$fn*2);
        }
        rotate([0,0,0]) translate([120+20,0,0]) rotate([-90,0,0]) translate([0,0,-20]) {
            hull() for(iy=[0,500]) translate([iy,0,-0.01]) cylinder(r=120+inset,h=200,$fn=$fn*2);
        }
    }
}

    
module int_topfront(inset=0) hull() {
    intersection() {
        translate([0,0,-(tert_rad-120)]) rotate([180,0,0]) boule(inset,tert_rad-120,-(90+15),$fn=$fn*2);
        translate([0,face_outset,-200]) cylinder(r=120+inset-(30+inset)*(1-cos(45)),h=400,$fn=$fn*2);
    }
            
    translate([0,0,0]) rotate([90,0,0]) cylinder(r=120+inset,h=500,$fn=$fn*2);
    
    for(ix=[-1,1]) translate([ix*(120-30),face_outset,-500]) rotate([90,0,0]) cylinder(r=30+inset,h=500,$fn=$fn*2);
            
    for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,face_outset,0]) for(ia=[0:360/($fn*2):90]) rotate([0,0,ia]) {
    
        for(iz=[-500,face_top]+[0,-1]*(abs(ia)<viewport_w_a/2?0:(120*(cos(viewport_w_a/2)-cos(ia)))*tan(15))) {
        
            translate([0,head_min_rad-30,iz]) rotate([0,-(abs(ia)<viewport_w_a/2?0:15),0]) rotate([0,0,-ia]) {
                sphere(r=30+inset);
                if(abs(ia)==90 && iz!=-500) rotate([90,0,0]) rotate([0,0,45]) cylinder(r=30+inset,h=500);
                }
        }
    }
}

    
module int_bottomfront(inset=0) {
    translate([0,face_outset+120*(cos(viewport_w_a/2)),face_bottom]) rotate([90,0,0]) boule(inset,-120*(cos(viewport_w_a/2)),-15,$fn=$fn*2);
    
    difference() {
        hull() for(iy=[0,-200]) translate([0,iy+face_outset,face_bottom]) cylinder(r=120+inset,h=400,$fn=$fn*2);
        
        translate([0,face_outset,face_bottom]) translate([0,120*(cos(viewport_w_a/2)),0]) rotate([-15,0,0]) translate([0,-120*(cos(viewport_w_a/2)),0]) translate([-500,-500,-500]) cube([1000,1000,500]);
    }
    
    chin_rad = 37.5;
    
    translate([0,face_outset,face_bottom]) translate([0,120*(cos(viewport_w_a/2)),0]) rotate([-15,0,0]) translate([0,-120*(cos(viewport_w_a/2)),0]) hull() for(iz=[0,-200]) for(iy=[0,-200]) translate([0,iy+iz*tan(45),iz]) rotate_extrude($fn=$fn*2) translate([120-chin_rad,0]) circle(r=chin_rad+inset,$fn=$fn/2);
    
    translate([0,0,-(scnd_rad-120)]) rotate([120,0,0]) translate([0,0,120+20+(scnd_rad-120)]) rotate([0,90,0]) {
    
        rotate([0,0,-45]) translate([120+20,0,0]) rotate([-90,0,0]) translate([0,0,-20]) {
            hull() for(iy=[0,-200]) translate([iy,0,0]) cylinder(r=120+inset,h=50,$fn=$fn*2);
        }
    }
    
    for(i=[0:360/$fn:45-360/$fn]) hull() for(j=[i,i+360/$fn]) {
        fil_rad = 10;
        
        intersection() {
            translate([0,face_outset,face_bottom]) translate([0,120*(cos(viewport_w_a/2)),0]) rotate([-15,0,0]) translate([0,-120*(cos(viewport_w_a/2)),0]) hull() for(iz=[0,-200]) for(iy=[0,-200]) translate([0,iy+iz*tan(45)+fil_rad*cos(45)-fil_rad*cos(j),iz-fil_rad*cos(45)+fil_rad*sin(j)]) rotate_extrude($fn=$fn*2) translate([120-chin_rad,0]) circle(r=chin_rad+inset,$fn=$fn/2);
            
            translate([0,0,-(scnd_rad-120)]) rotate([120,0,0]) translate([0,0,120+20+(scnd_rad-120)]) rotate([0,90,0]) {
            
                rotate([0,0,-45]) translate([120+20,0,0]) rotate([-90,0,0]) translate([fil_rad-fil_rad*cos(j),0,-20]) {
                    cylinder(r=120+inset,h=200,$fn=$fn*2);
                }
            }
        }
    }
}



module duct() {
    put_on_ring() {
        inset = 0;
        
        translate([0,0,-(scnd_rad-120)]) rotate([120,0,0]) translate([0,0,120+20+(scnd_rad-120)]) rotate([0,90,0]) {
            rotate_extrude(angle=-45,$fn=$fn*2) translate([120+20,0]) {
                $fn=$fn/2;
                intersection() {
                    rotate([0,0,-90]) mirror([1,0]) duct_cs();
                    circle(r=120+10);
                }
            }
            
            rotate([0,0,-45]) translate([120+20,0,0]) rotate([-90,0,0]) translate([0,0,-20+5]) {
                linear_extrude(height=20+0.01-5) rotate([0,0,-90]) mirror([0,0]) duct_cs();
            }
        }
        
        translate([0,0,-(scnd_rad-120)]) {
            rotate([180,0,0]) rotate([0,90,0]) rotate([0,0,90-15]) rotate_extrude(angle=-(90-15)+120) translate([(scnd_rad-120),0]) {
            
                rotate([0,0,90]) mirror([0,0]) duct_cs();
            }
        }
    }
    
    
    union() {
        rv = 2.5; //minor radius (how thick is the vent)
        rl = prime_r_in-0.2; //outside major radius
        a = 3*3.14159*pow(8/2,2); //area
        theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
        
        round_r0 = rv+1.6;
        round_r1 = 3;
        
        step_r0 = prime_r_in-2*rv-1.6;
        step_r1 = prime_r_in;
        step_a = asin(7.5/step_r1);
        theta2 = theta;
        
        hgt1 = 5+5;
        
        step_a_nr = asin(10/prime_r_in);
        

        ia_inc = 1/($fn/2);
        v_outset = 0;
        
        rotate([0,0,theta+step_a_nr]) difference() {
            union() {
                for(ixm=[0,1]) mirror([ixm,0,0]) rotate([0,0,-90+theta2]) round_step_on_rad_inside(step_r0,step_r1,step_a,round_r0,round_r1,hgt1,bev_xs,0);
                
                rotate([0,0,-90-theta2]) rotate_extrude(angle=2*theta2,$fn=$fn*2) polygon([
                    [200,0],
                    [step_r0+bev_xs,0],
                    [step_r0,bev_xs],
                    [step_r0,hgt1],
                    [200,hgt1],
                ]);
            }
        
            translate([0,0,-0.01]) for(ia_ex=[0:ia_inc:1-ia_inc]) {
                hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                    rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) cylinder(r=rv+v_outset,h=50);
                }
                hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                    rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) cylinder(r1=rv+v_outset+bev_xs,r2=rv+v_outset,h=bev_xs);
                }
            }
        }
    }
}

module duct_cs() {
    rv = 2.5; //minor radius (how thick is the vent)
    rl = prime_r_in-0.2; //outside major radius
    a = 3*3.14159*pow(8/2,2); //area
    theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
    
    step_a_nr = asin(10/prime_r_in);
    
    rotate([0,0,theta+step_a_nr]) difference() {
        round_r0 = rv+1.6;
        round_r1 = 3;
        
        step_r0 = prime_r_in-2*rv-1.6;
        step_r1 = prime_r_in;
        step_a = asin(7.5/step_r1);
        theta2 = theta;

        ia_inc = 1/($fn/2);
        v_outset = 0;
    
        union() {
            for(ixm=[0,1]) mirror([ixm,0,0]) rotate([0,0,-90+theta2]) round_step_on_rad_inside_2d(step_r0,step_r1,step_a,round_r0,round_r1);
        
            polygon([
                [0,0],
                [200*tan(theta2)+0.01,-200],
                [-200*tan(theta2)-0.01,-200],
            ]);
        }
        circle(r=step_r0,$fn=$fn*2);
        
        for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
            rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) circle(r=rv+v_outset);
        }
    }
}

/*
    union() {
        rv = 2.5; //minor radius (how thick is the vent)
        rl = prime_r_in-0.2; //outside major radius
        a = 3*3.14159*pow(8/2,2); //area
        theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
        
        
        round_r0 = 4;
        round_r1 = rv+1.6+bev_l;
        
        step_r0 = rl-1.6-rv-round_r1;
        step_r1 = passage_r;
        step_a = asin(10/step_r1);
        theta2 = asin((step_r1*sin(theta) + 7.5)/step_r1);
        
        
hgt1 = 20;

                ia_inc = 1/($fn/2);
                //iz_inc = 1/16;
                v_outset = 1.6;
                
                
translate([0,0,20-5]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Neck Ring/Neck Ring Mk 1 G.stl");
                

                
        *translate([0,0,25]) linear_extrude(height=10,convexity=10) duct_cs();
                
        *rotate([0,0,theta+step_a]) {
            *for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                translate([0,0,0]) {
                    rotate([0,0,(2*ia-1)*theta]) translate([0,rl-rv,0]) cylinder(r=rv+v_outset,h=0.01);
                }
            }
            
            union() {
                for(ixm=[0,1]) mirror([ixm,0,0]) rotate([0,0,-90+theta2]) round_step_on_rad_inside(step_r0,step_r1,step_a,round_r0,round_r1,hgt1,bev_xs,0);
                
                rotate([0,0,-90-theta2]) rotate_extrude(angle=2*theta2,$fn=$fn*2) polygon([
                    [200,0],
                    [step_r0+bev_xs,0],
                    [step_r0,bev_xs],
                    [step_r0,hgt1],
                    [200,hgt1],
                ]);
            }
        }
    }
*/


module shroud_guards(inset=0) difference() {
    hull() {
        sg_fwd_ext = -5;
        sg_upw_ext = 5;
        
        for(ixm=[0,1]) mirror([ixm,0,0]) translate([-(120+30-5),0,-20]) rotate([-15,0,0]) translate([0,sg_fwd_ext,sg_upw_ext]) sphere(r=5+inset);
        difference() {
            union() {
                for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-20]) rotate([0,-90,0]) {
                    cylinder(r=40,h=120+30);
                    rotate_extrude() translate([40,120+30-20]) circle(r=20+inset);
                    
                    for(ia=[90,180,270]) rotate([0,0,ia+15]) translate([20,20,0]) rotate_extrude() translate([20,120+30-20]) circle(r=20+inset);
                }
                translate([0,0,-(scnd_rad-120)]) rotate([180,0,0]) boule(0,scnd_rad-120);
                translate([0,0,-(scnd_rad-120)]) translate([0,0,-100]) rotate([180,0,0]) boule(0,scnd_rad-120-50);
            }
            translate([0,0,-20]) rotate([-15,0,0]) {
                translate([-500,sg_fwd_ext,-500]) cube([1000,1000,1000]);
                translate([-500,-500,sg_upw_ext]) cube([1000,1000,1000]);
            }
        }
        
        hull() {
            for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-20]) rotate([-15,0,0]) {
                translate([-120-30+20,-40,sg_upw_ext]) rotate_extrude() translate([20-5,0]) circle(r=5+inset);
            }
            for(iba=[0:360/$fn:90]) difference() {
                translate([0,0,-(scnd_rad-120)]) rotate([180,0,0]) boule(-5+(5+inset)*cos(iba)-inset,scnd_rad-120);
                
                translate([0,0,-20]) rotate([-15,0,0]) {
                    translate([-500,sg_fwd_ext,-500]) cube([1000,1000,1000]);
                    translate([-500,-500,sg_upw_ext+(5+inset)*sin(iba)]) cube([1000,1000,1000]);
                }
            }
        }
        
        hull() {
            for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-20]) rotate([-15,0,0]) rotate([90,0,0]) {
                translate([-120-30+20,-40,-sg_fwd_ext]) rotate_extrude() translate([20-5,0]) circle(r=5+inset);
            }
        
            for(iba=[0:360/$fn:90]) difference() {
                translate([0,0,-(scnd_rad-120)]) translate([0,0,-100]) rotate([180,0,0]) boule(-5+(5+inset)*cos(iba)-inset,scnd_rad-120-50);
                translate([0,0,-20]) rotate([-15,0,0]) {
                    translate([-500,sg_fwd_ext+(5+inset)*sin(iba),-500]) cube([1000,1000,1000]);
                }
            }
        }
    }
    
    *translate([0,0,-20]) rotate([0,-90,0]) {
        translate([0,-40-40,120+5]) cylinder(r1=20,r2=20+50,h=50);
    }
}

*union() {
    head_min_rad = 120;
    head_maj_rad = 20;

    face_angle = 15;
    face_outset = 40;
    face_top = 25;
    face_bottom = -100;

    neckring_angle = 30;
    neckring_hgt = 20;

    neck_hgt = 50;
    neck_angle = neckring_angle-face_angle;

    dat_faceplate_bottom_y = face_outset;
    dat_faceplate_bottom_z = face_bottom;

    //dat_chin_bottom_y = dat_faceplate_bottom_y-head_min_rad+head_min_rad*cos(face_angle);
    //dat_chin_bottom_z = dat_faceplate_bottom_z-head_min_rad*sin(face_angle);

    dat_neck_bottom_y = -head_maj_rad*cos(neck_angle)+neck_hgt*sin(neck_angle);
    dat_neck_bottom_z = -head_maj_rad*sin(neck_angle)-neck_hgt*cos(neck_angle);

    dat_nape_org_y = dat_neck_bottom_y-(head_min_rad+20)*cos(neck_angle);
    dat_nape_org_z = dat_neck_bottom_z-(head_min_rad+20)*sin(neck_angle);

    dat_nape_bottom_y = dat_nape_org_y+(head_min_rad+20)*cos(face_angle);
    dat_nape_bottom_z = dat_nape_org_z-(head_min_rad+20)*sin(face_angle);

    dat_neckring_bottom_y = dat_nape_bottom_y-neckring_hgt*sin(face_angle);
    dat_neckring_bottom_z = dat_nape_bottom_z-neckring_hgt*cos(face_angle);
    
    *translate([0,dat_neckring_bottom_y,dat_neckring_bottom_z]) rotate([-face_angle,0,0]) translate([0,7.5,-5]) { 
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet E.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet C.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet B2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet A2.stl");
    }
    
    union() {
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet E.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet C.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet B2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Helmet/Mk 0 - Helmet/MA-3 Helmet A2.stl");
    }
}



module helmet_viewport() {
    translate([0,face_outset,0]) {
        sb_inc = $fn/2;
    
        //cutout sides
        for(ix=[0,1]) mirror([ix,0,0]) {
            for(j=[0:360/sb_inc:90-360/sb_inc]) hull() for(i=[j,j+360/sb_inc]) {
                for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,prime_r_in-0.1,0]) rotate([-90,0,0]) cylinder(r=0.01,h=20,$fn=8);
                    }
                }
            }
        }
        
        //bevel on sides
        for(ix=[0,1]) mirror([ix,0,0]) {
            //outside bevel
            *for(j=[0:360/sb_inc:90-360/sb_inc]) hull() for(i=[j,j+360/sb_inc]) {
                for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-2-1,0]) rotate([-90,0,0]) cylinder(r1=0,r2=20,h=20,$fn=8);
                    }
                }
            }
            
            //inside bevel
            for(j=[0:360/sb_inc:90-360/sb_inc]) hull() for(i=[j,j+360/sb_inc]) {
                for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,prime_r_in-20+1,0]) rotate([-90,0,0]) cylinder(r1=20,r2=0,h=20,$fn=8);
                    }
                }
            }
            
            //outside bevel (without seal recess)
            for(j=[0:360/sb_inc:90-360/sb_inc]) hull() for(i=[j,j+360/sb_inc]) {
                for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-1,0]) rotate([-90,0,0]) cylinder(r1=0,r2=20,h=20,$fn=8);
                    }
                }
            }
        }
        
        viewport_gsk_outset = 7.5;
        
        //seal recess on sides
        *for(ix=[0,1]) mirror([ix,0,0]) {
            for(j=[0:360/sb_inc:90-360/sb_inc]) hull() for(i=[j,j+360/sb_inc]) {
                for(iz=[face_bottom,face_top]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_gsk_outset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_gsk_outset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-2,0]) rotate([-90,0,0]) cylinder(r1=0,r2=20,h=20,$fn=8);
                    }
                }
            }
        }
        
        //gasket
        for(ix=[0,1]) mirror([ix,0,0]) for(iz=[face_bottom,face_top]) {
            for(j=[0:360/$fn:90-360/$fn]) hull() for(i=[j,j+360/$fn]) {
                translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset+5)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset+5)*sin(i))/(120*2*3.1415)*360]) {
                            translate([0,120,0]) rotate([-90,0,0]) sphere(r=oring_rad);
                            translate([0,120+10/cos(45),0]) rotate([-90,0,0]) sphere(r=oring_rad+10);
                        }
                    }
                }
            }
        }
        for(ix=[0,1]) mirror([ix,0,0]) hull() for(iz=[face_bottom,face_top]) {
            for(i=[90]) {
                translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset+5)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset+5)*sin(i))/(120*2*3.1415)*360]) {
                            translate([0,120,0]) rotate([-90,0,0]) sphere(r=oring_rad);
                            translate([0,120+10/cos(45),0]) rotate([-90,0,0]) sphere(r=oring_rad+10);
                        }
                    }
                }
            }
        }
        
        //cutout center
        rotate([0,0,(180-viewport_w_a)/2+viewport_crn_r/(120*2*3.1415)*360]) rotate_extrude(angle=viewport_w_a-2*viewport_crn_r/(120*2*3.1415)*360,$fn=$fn*2) {
            //cutout
            polygon([
                [(prime_r_in-0.02)+20,face_bottom-viewport_inset],
                [(prime_r_in-0.02),face_bottom-viewport_inset],
                [(prime_r_in-0.02),face_top+viewport_inset],
                [(prime_r_in-0.02)+20,face_top+viewport_inset],
            ]);
            //outside bevel
            *polygon([
                [(120-2-1)+20,face_bottom-viewport_inset-20],
                [(120-2-1),face_bottom-viewport_inset],
                [(120-2-1),face_top+viewport_inset],
                [(120-2-1)+20,face_top+viewport_inset+20],
            ]);
            //inside bevel
            polygon([
                [(prime_r_in+1)-20,face_bottom-viewport_inset-20],
                [(prime_r_in+1),face_bottom-viewport_inset],
                [(prime_r_in+1),face_top+viewport_inset],
                [(prime_r_in+1)-20,face_top+viewport_inset+20],
            ]);
            //seal recess
            *polygon([
                [(120-2)+50,face_bottom-viewport_gsk_outset-50],
                [(120-2),face_bottom-viewport_gsk_outset],
                [(120-2),face_top+viewport_gsk_outset],
                [(120-2)+50,face_top+viewport_gsk_outset+50],
            ]);
            //outside bevel (without seal recess)
            polygon([
                [(120-1)+20,face_bottom-viewport_inset-20],
                [(120-1),face_bottom-viewport_inset],
                [(120-1),face_top+viewport_inset],
                [(120-1)+20,face_top+viewport_inset+20],
            ]);
            
            for(iz=[face_top,face_bottom]+[2.5,-2.5]) hull() {
                $fn=$fn/2;
                translate([120,iz]) circle(r=oring_rad);
                translate([120+10/cos(45),iz]) circle(r=oring_rad+10);
            }
        }
    }
}


module support_leg_int(ia) rotate([0,0,ia]) {
    leg_len = 12;
    
    intersection() {
        translate([0,0,5+5]) hull() {
            translate([200,0,0]) cylinder(r=0.4,h=leg_len);
            translate([prime_r_in+2.4-4,0,0]) cylinder(r=0.4,h=leg_len);
        }
        cylinder(r=prime_r_in+2.4+0.5,h=50);
    }
    
    hull() {
        intersection() {
            translate([0,0,5+5]) hull() {
                translate([200,0,0]) cylinder(r=0.4,h=leg_len);
                translate([prime_r_in+2.4-4,0,0]) cylinder(r=0.4,h=leg_len);
            }
            cylinder(r=prime_r_in+2.4-0.4,h=50);
        }
        intersection() {
            translate([0,0,5+5]) hull() {
                translate([200,0,0]) cylinder(r=1.2,h=leg_len);
                translate([prime_r_in+2.4-4,0,0]) cylinder(r=1.2,h=leg_len);
                translate([prime_r_in+2.4-4-leg_len,0,0]) cylinder(r=1.2,h=0.2);
            }
            cylinder(r=prime_r_in+2.4-1.2,h=50);
        }
    }
}

module support_leg(ia) {
    leg_len = 18;

    difference() {
        rotate([0,0,ia]) translate([0,0,5+5]) hull() {
            translate([0,0,0]) cylinder(r=0.4,h=leg_len);
            translate([prime_r+4,0,0]) cylinder(r=0.4,h=leg_len);
        }
        translate([0,0,-0.01]) put_on_ring() helmet_shape(-0.4);
    }

    hull() {
        difference() {
            rotate([0,0,ia]) translate([0,0,5+5]) hull() {
                translate([0,0,0]) cylinder(r=0.4,h=leg_len);
                translate([prime_r+4,0,0]) cylinder(r=0.4,h=leg_len);
                translate([prime_r+4+leg_len,0,0]) cylinder(r=0.4,h=0.2);
            }
            translate([0,0,-0.01]) put_on_ring() helmet_shape(0.4);
        }
        difference() {
            rotate([0,0,ia]) translate([0,0,5+5]) hull() {
                translate([0,0,0]) cylinder(r=1.2,h=leg_len);
                translate([prime_r+4,0,0]) cylinder(r=1.2,h=leg_len);
                translate([prime_r+4+leg_len,0,0]) cylinder(r=1.2,h=0.2);
            }
            translate([0,0,-0.01]) put_on_ring() helmet_shape(1.2);
        }
    }
}



module boule(inset=0,xor=0,tor_a=360) rotate([0,90,0]) {
    rotate_extrude(angle=tor_a) {
        intersection() {
            translate([xor,0]) circle(r=prime_r+inset);
            translate([0,-prime_r]) square([500,2*prime_r]);
        }
        if(xor>0) translate([0,-(prime_r+inset)]) square([xor,2*(prime_r+inset)]);
    }
}



module cylinder_oh_opt(radius,height,oh=false,rotate=0) hull() {
    cylinder(r=radius,h=height);
        
    if(oh) rotate([0,0,rotate]) {
        translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
    }
}

module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}