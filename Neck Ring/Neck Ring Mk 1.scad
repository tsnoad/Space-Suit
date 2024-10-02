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

*translate([0,-40,-2-5]) rotate([15,0,0]) translate([0,0,-7.5]) {
    import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Neckring Interface C.stl");
    import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Neckring Interface B.stl");
    import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Neckring Interface A.stl");
}


*intersection() {
    base_ring_bottom() {
        hgt1 = bring_btm_hgt-clr_v;
        hgt2 = bring_btm_hgt+lring_btm_hgt;
        
        base_ring_screw_pos() {
            cylinder_neg_bev(1.5+0.15,hgt2,bev_xs,bev_xs);
            
            translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,10]);
                
            translate([0,(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia+180]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
            
            
            //translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt-18]) cylinder_bev(1.25,50,0,0.25);
        }
        
        base_ring_screw_pos(true) {
            cylinder_neg_bev(1.25,1.25,bev_s,0);
            translate([0,0,bring_btm_hgt+lring_btm_hgt-1.8-8]) {
                cylinder_bev(1.25,8,0,0.25);
                translate([0,0,-50]) cylinder_bev(3,50+3,0,3-0.01);
            }
        }
        
        base_ring_screw_pos(false,true) {
            translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt-8]) cylinder_bev(1.25,50,0.25,0);
            translate([0,0,bring_btm_hgt+lring_btm_hgt-bev_s+0.01]) cylinder(r1=1.25,r2=1.25+bev_s,h=bev_s);
        }
        
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
    *for(ia=[270]) rotate([0,0,ia+22.5]) union() {
        translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
    }
}



*translate([0,0,bring_btm_hgt+lring_btm_hgt]) intersection() {
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
    for(ia=[180]) rotate([0,0,ia+22.5+45]) union() {
        translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
    }
}

*latch();

translate([0,0,bring_btm_hgt]) !rotate([0,0,limtab_a_trav*1]) intersection() {
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
    for(ia=[120]) rotate([0,0,ia+limtab_a_trav]) union() {
        rotate([0,0,-15]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
        rotate([0,0,+15]) translate([clr_h_s/2,clr_h_s/2,0]) cube([200,200,100]);
    }
}

translate([0,0,20+bring_btm_hgt+lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v]) rotate([0,0,limtab_a_trav*1]) intersection() {
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

*difference() {
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
}


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