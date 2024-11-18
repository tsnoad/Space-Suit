/*
 * Spacesuit Neck Ring Interface Mk 1
 * Licenced under CC BY-NC-SA 4.0
 * By: TSnoad
 * https://github.com/tsnoad/TBC
 * https://hackaday.io/project/TBC
 */

$fn = 144;

include <../Torso/Neckring Torso Shared Modules.scad>;

include <Neck Ring Mk 1 Include.scad>;

/*translate([0,-40,-2-5]) rotate([15,0,0]) translate([0,0,-7.5]) {
    import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Neckring Interface C.stl");
    import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Neckring Interface B.stl");
    import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Neckring Interface A.stl");
}*/


//used by make script
*/* make 'Neck Ring Mk 1 A.stl' */ neck_base_ring_bottom() int_neck_base_ring_bottom([0]);
*/* make 'Neck Ring Mk 1 B.stl' */ neck_base_ring_bottom() int_neck_base_ring_bottom([1]);
*/* make 'Neck Ring Mk 1 C.stl' */ neck_base_ring_bottom() int_neck_base_ring_bottom([2]);
*/* make 'Neck Ring Mk 1 D.stl' */ neck_base_ring_bottom() int_neck_base_ring_bottom([3]);

*/* make 'Neck Ring Mk 1 E.stl' */ neck_base_ring_top() int_neck_base_ring_top([0]);
*/* make 'Neck Ring Mk 1 F.stl' */ neck_base_ring_top() int_neck_base_ring_top([1]);
*/* make 'Neck Ring Mk 1 G.stl' */ neck_base_ring_top() int_neck_base_ring_top([2]);
!/* make 'Neck Ring Mk 1 H.stl' */ neck_base_ring_top() int_neck_base_ring_top([3]);

//assembled view
neck_base_ring_bottom() int_neck_base_ring_bottom([2]);

translate([0,0,bring_btm_hgt+lring_btm_hgt]) neck_base_ring_top() int_neck_base_ring_top([2]);

*latch();

*translate([0,0,bring_btm_hgt]) !rotate([0,0,limtab_a_trav*1]) neck_locking_ring_bottom() {
    for(ia=[120]) rotate([0,0,ia+limtab_a_trav]) union() {
        rotate([0,0,-15]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
        rotate([0,0,+15]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
    }
}

*translate([0,0,20+bring_btm_hgt+lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v]) rotate([0,0,limtab_a_trav*1]) neck_locking_ring_top() {
    union() {
        *rotate([0,0,45]) {
            translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
            rotate([0,0,45]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
        }
        *rotate([0,0,45+90+45]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
        rotate([0,0,45]) mirror([0,1,0]) {
            translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
            rotate([0,0,45]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
        }
    }
}

module base_ring_bottom_duct(hgt1,hgt2) {
    rv = 2.5; //minor radius (how thick is the vent)
    rl = 120-8-0.2; //outside major radius
    a = 3*3.14159*pow(8/2,2); //area
    theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
    
    round_r0 = 4;
    round_r1 = rv+1.6+bev_l;
    
    step_r0 = rl-1.6-rv-round_r1;
    step_r1 = passage_r;
    step_a = asin(10/step_r1);
    theta2 = asin((step_r1*sin(theta) + 7.5)/step_r1);
    
    ia_inc = 1/($fn/2);
    v_outset = 0;
    
    linear_extrude(height=hgt2,convexity=10) rotate([0,0,theta+step_a]) difference() {
        intersection() {
            for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) {
                    circle(r=rv+1.6);
                    translate([0,50]) circle(r=rv+1.6+20);
                }
            }
            circle(r=rl+bev_xl);
        }
        
        for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
            rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) circle(r=rv+v_outset);
        }
    }
}

module neck_base_ring_bottom() intersection() {
    base_ring_bottom() {
        hgt1 = bring_btm_hgt-clr_v;
        hgt2 = bring_btm_hgt+lring_btm_hgt;
        
        base_ring_screw_pos() {
            cylinder_neg_bev(1.5+0.15,hgt2,bev_xs,bev_xs);
            
            translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,10]);
                
            translate([0,(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia+180]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
            
            
            //translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt-18]) cylinder_bev(1.25,50,0,0.25);
        }
        
        //engagment - screws joining base_ring_bottom to neckring interface
        base_ring_screw_pos(true) {
            cylinder_neg_bev(1.25,1.25,bev_s,0);
            translate([0,0,bring_btm_hgt+lring_btm_hgt-1.8-8]) {
                cylinder_bev(1.25,8,0,0.25);
                translate([0,0,-50]) cylinder_bev(3,50+3,0,3-0.01);
            }
        }
        
        //engagment - screws joining base_ring_bottom to base_ring_top
        base_ring_screw_pos(false,true) {
            translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt-8]) cylinder_bev(1.25,50,0.25,0);
            translate([0,0,bring_btm_hgt+lring_btm_hgt-bev_s+0.01]) cylinder(r1=1.25,r2=1.25+bev_s,h=bev_s);
        }
        
        //cutouts for bolts (and retained nuts) that join the neckring interface to the torso
        translate([0,-40,-2-5]) rotate([15,0,0]) translate([0,0,-7.5]) {
            for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,7.5]) {
                rotate([-15,0,0]) translate([0,40,0]) {
                    for(ii=[2,3]) neck_space_mag_co(ii,true) {
                        mag_is = (8+5)/2-0.75;
                        mag_rad = (120-8+mag_is);
                        mag_hgt = (120+5-mag_rad)*tan(25);
                
                        translate([0,0,0]) cylinder(r=1.5+0.15,h=50+10);
                        translate([0,0,-mag_hgt+5+2]) {
                            hull() for(i=[0:5]) rotate([0,0,i*60+30]) translate([0,3/cos(30),0]) {
                                translate([0,0,-0.01]) cylinder(r=0.15,h=2.6+0.01);
                            }
                            hull() for(i=[0:5]) rotate([0,0,i*60+30]) translate([0,3/cos(30),0]) {
                                translate([0,0,-0.01]) cylinder(r1=0.15+bev_s,r2=0.15,h=bev_s);
                            }
                            hull() for(i=[0:2]) rotate([0,0,i*120+30]) translate([0,3/cos(30),0]) {
                                translate([0,0,-0.01]) cylinder(r=0.15,h=2.6+0.2+0.01);
                            }
                        }
                    }
                }
            }
        }
    }
    children();
}

module int_neck_base_ring_bottom(int_segment_index=[0:3]) {
    for(ia=int_segment_index*90) rotate([0,0,ia+22.5]) union() {
        translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
    }
}

module base_ring_top_duct(hgt1,hgt2) {
    rv = 2.5; //minor radius (how thick is the vent)
    rl = 120-8-0.2; //outside major radius
    a = 3*3.14159*pow(8/2,2); //area
    theta = 360/(3.14159*(pow(rl,2)-pow(rl-2*rv,2)))*(a/2-3.14159*pow(rv,2)/2);
    
    round_r0 = 4;
    round_r1 = rv+1.6+bev_l;
    
    step_r0 = rl-1.6-rv-round_r1;
    step_r1 = passage_r;
    step_a = asin(10/step_r1);
    theta2 = asin((step_r1*sin(theta) + 7.5)/step_r1);
    
    ia_inc = 1/($fn/2);
    v_outset = 0;
    
    linear_extrude(height=hgt1,convexity=10) rotate([0,0,theta+step_a]) difference() {
        intersection() {
            for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
                rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) {
                    circle(r=rv+1.6);
                    translate([0,50]) circle(r=rv+1.6+20);
                }
            }
            circle(r=rl+bev_xl);
        }
        
        for(ia_ex=[0:ia_inc:1-ia_inc]) hull() for(ia=[ia_ex,ia_ex+ia_inc]) {
            rotate([0,0,180+(2*ia-1)*theta]) translate([0,rl-rv]) circle(r=rv+v_outset);
        }
    }
}

module int_neck_base_ring_top(int_segment_index=[0:3]) {
    for(ia=int_segment_index*90) rotate([0,0,ia+22.5+45]) union() {
        translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
    }
}

module neck_base_ring_top() intersection() {
    base_ring_top() {
        base_ring_screw_pos() {
            cylinder_neg_bev(1.5+0.15,50,bev_xs,0);
            translate([0,0,bring_top_hgt]) hull() {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
        base_ring_screw_pos(false,true) {
            cylinder_neg_bev(1.5+0.15,50,bev_xs,0);
            translate([0,0,bring_top_hgt]) hull() {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
    }
    children();
}

module neck_locking_ring_bottom() intersection() {
    locking_ring_bottom() {
        hgt1 = lring_btm_hgt-clr_v;
        hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;

        rotate([0,0,-limtab_a_trav]) for(ixm=[0,1]) mirror([ixm,0,0]) {
            for(ia2=[0:lug_num/2-1]) rotate([0,0,(ia2+0.5)*360/lug_num]) {
                for(ia=(ia2==1?[10]:[-10,10])*10) rotate([0,0,ia]) {
                    translate([0,lug_outer_r+clr_h+(1.5+0.15),0]) {
                        cylinder_neg_bev(1.5+0.15,hgt2,(3-(1.5+0.15)),0);
                        translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
                        translate([0,-(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
                    }
                }
            }
        }
    }
    children();
}

module neck_locking_ring_top() intersection() {
    locking_ring_top() {
        rotate([0,0,-limtab_a_trav]) for(ixm=[0,1]) mirror([ixm,0,0]) {
            for(ia2=[0:lug_num/2-1]) rotate([0,0,(ia2+0.5)*360/lug_num]) {
                for(ia=(ia2==1?[10]:[-10,10])*10) rotate([0,0,ia]) {
                    translate([0,lug_outer_r+clr_h+(1.5+0.15),0]) {
                        cylinder_bev(1.25,lring_top_hgt-0.6,0,0.25);
                        cylinder_bev(1.25+bev_xs,0.01+bev_xs,0,bev_xs);
                    }
                }
            }
        }
    }
}

/*difference() {
    union() {
        cylinder_bev(lug_inner_r,10,bev_s,0,$fn=$fn*2);
        lug_ring();
    }
    cylinder_neg_bev(passage_r,10,bev_s,bev_s,$fn=$fn*2);
    
    
    if(oring) translate([0,0,-0.01]) rotate_extrude($fn=$fn*2) union() {
        //cutout for the o-ring gland
        polygon([
            [lug_inner_r-2.4+bev_xs,0],
            [lug_inner_r-2.4,bev_xs],
            [lug_inner_r-2.4,oring_gland_dep-bev_s],
            [lug_inner_r-2.4-bev_s,oring_gland_dep],
            [lug_inner_r-2.4-oring_gland_wid+bev_s,oring_gland_dep],
            [lug_inner_r-2.4-oring_gland_wid,oring_gland_dep-bev_s],
            [lug_inner_r-2.4-oring_gland_wid,bev_xs],
            [lug_inner_r-2.4-oring_gland_wid-bev_xs,0],
        ]);
    }
}*/


module round_step(step_h0,step_h1,step_l,round_r0,round_r1) {
    t1_hyp = sqrt(pow(step_h1-step_h0-round_r0-round_r1,2)+pow(step_l,2));
    
    t1_theta = atan2(step_l,(step_h1-step_h0-round_r0-round_r1));
    
    t2_theta = acos((round_r0+round_r1)/t1_hyp);
    
    theta = 180 - (t1_theta + t2_theta);
    
    
    difference() {
        polygon([
            [0,0],
            [step_h0+round_r0,0],
        
            [step_h0+round_r0-round_r0*cos(theta),round_r0*sin(theta)],
    
            [step_h1-round_r1+round_r1*cos(theta),step_l-round_r1*sin(theta)],
        
            [step_h1-round_r1,step_l],
            [0,step_l],
        ]);
        translate([step_h0+round_r0,0]) circle(r=round_r0);
    }
    translate([step_h1-round_r1,step_l]) circle(r=round_r1);
}


module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}

module circle_oh(radius) {
    circle(r=radius);
    translate([-radius*tan(22.5),-radius]) square([2*radius*tan(22.5),2*radius]);
}