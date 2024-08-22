

//passage_r = ;

//lug_inner_r = ;
//lug_outer_r = ;
//lug_hgt = ;

//lug_num = 6;
////lug_widh = 20;
//lug_widh = 3.14159*2*((lug_outer_r-lug_inner_r)/2+lug_inner_r)/lug_num/4;

//lring_top_hgt = ;
//lring_outer_r = ;
//lring_btm_hgt = ;

//bring_hgt = ;
//bring_inner_r = ;
//bring_intrm_r = ;
//bring_outer_r = ;

crn_r = 2;

bev_xl = 2;
bev_l = 0.8;
bev_s = 0.4;
bev_xs = 0.2;

clr_h = 0.4;
clr_v = 0.4;



module screw_or_bolt_co(hgt_to_head,hgt_to_bev,dep_to_nut,dep_to_bev) {
    if(true) {
        screw_co(hgt_to_head,hgt_to_bev,dep_to_nut,dep_to_bev);
    } else {
        bolt_co(hgt_to_head,hgt_to_bev,dep_to_nut,dep_to_bev);
    }
}

module screw_co(hgt_to_head,hgt_to_bev,dep_to_nut,dep_to_bev) {
    translate([0,0,hgt_to_head]) {
        
        cylinder(r=1.75,h=50);
        
        if ((hgt_to_bev-hgt_to_head)<=1) {
            hull() {
                translate([0,0,hgt_to_bev-hgt_to_head]) cylinder(r=3+(hgt_to_bev-hgt_to_head),h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        } else {
            hull() {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
            translate([0,0,hgt_to_bev-hgt_to_head]) hull() {
                cylinder(r=3+bev_s,h=50);
                translate([0,0,-bev_s]) cylinder(r=3,h=50);
            }
        }
        
        translate([0,0,-6]) hull() {
            cylinder(r=1.25,h=50);
            translate([0,0,-(1.25-0.5)]) cylinder(r=0.5,h=50);
        }
    }
}

module bolt_co(hgt_to_head,hgt_to_bev,dep_to_nut,dep_to_bev) {
}

module cylinder_bev(rad,hgt,btm_bev=0,top_bev=0) {
    $fn=$fn*(rad>100?2:1);
    
    hull() {
        cylinder(r=rad-btm_bev,hgt-top_bev);
        
        translate([0,0,btm_bev]) {
            cylinder(r=rad,h=hgt-top_bev-btm_bev);
            cylinder(r=rad-top_bev,h=hgt-btm_bev);
        }
    }
}

module cylinder_neg_bev(rad,hgt,btm_bev=0,top_bev=0,iy=[0]) {
    $fn=$fn*(rad>100?2:1);
    
    
    hull() for(i=iy) translate([0,i,-0.01]) cylinder(r=rad,hgt+2*0.01);
    hull() for(i=iy) translate([0,i,-0.01]) cylinder(r1=rad+btm_bev,r2=rad,btm_bev);
    hull() for(i=iy) translate([0,i,hgt-top_bev+0.01]) cylinder(r1=rad,r2=rad+top_bev,top_bev);
}

module torus_bev(rad,hgt,btm_bev=0,top_bev=0) {
}

module round_step_on_rad(step_r0,step_r1,step_a,round_r0,round_r1,hgt,bev_btm=0,bev_top=0) {
    step_h0 = step_r0;
    step_l = step_r1*sin(step_a);
    step_h1 = step_r0+sqrt(pow(step_r1-round_r1,2)-pow(step_l,2))-step_r0+round_r1;
    

    t1_hyp = sqrt(pow(step_h1-step_h0-round_r0-round_r1,2)+pow(step_l,2));
    
    t1_theta = atan2(step_l,(step_h1-step_h0-round_r0-round_r1));
    
    t2_theta = acos((round_r0+round_r1)/t1_hyp);
    
    theta = 180 - (t1_theta + t2_theta);
    
    
    difference() {
        linear_extrude(height=hgt,convexity=10) polygon([
            [0,0],
            [step_h0+round_r0,0],
        
            [step_h0+round_r0-round_r0*cos(theta),round_r0*sin(theta)],
    
            [step_h1-round_r1+round_r1*cos(theta),step_l-round_r1*sin(theta)],
        
            [step_h1-round_r1,step_l],
            [0,step_l],
        ]);
        translate([step_h0+round_r0,0,0]) {
            translate([0,0,-0.01]) cylinder(r=round_r0,h=hgt+2*0.01);
            hull() for(i=[0,20]) rotate([0,0,-theta]) translate([0,i,-0.01]) cylinder(r1=round_r0+bev_btm,r2=round_r0,h=bev_btm);
            hull() for(i=[0,20]) rotate([0,0,-theta]) translate([0,i,hgt-bev_top+0.01]) cylinder(r1=round_r0,r2=round_r0+bev_top,h=bev_top);
        }
    }
    translate([step_h1-round_r1,step_l,0]) hull() {
        cylinder(r=round_r1-bev_btm,h=hgt-bev_top);
        translate([0,0,bev_btm]) {
            cylinder(r=round_r1,h=hgt-bev_btm-bev_top);
            cylinder(r=round_r1-bev_top,h=hgt-bev_btm);
        }
    }
}


module lug_ring() {
    r_inner = lug_inner_r;
    r_outer = lug_outer_r;
    hgt1 = lug_hgt;
    
    *hull() {
        translate([0,0,bev_l]) cylinder(r=r_inner,h=hgt1,$fn=$fn*4);
        cylinder(r=r_inner-bev_l,h=hgt1,$fn=$fn*4);
    }
    
    for(i=[0:lug_num-1]) rotate([0,0,(i+0.5)*360/lug_num]) {
        for(j=[0,1]) mirror([j,0,0]) {
            difference() {
                intersection() {
                    union() {
                        hull() {
                            translate([0,0,bev_l]) cylinder(r=r_outer,h=hgt1-2*bev_l,$fn=$fn*4);
                            cylinder(r=r_outer-bev_l,h=hgt1,$fn=$fn*4);
                        }
                        hull() {
                            cylinder(r=r_inner,h=hgt1+bev_s,$fn=$fn*4);
                            cylinder(r=r_inner+bev_s,h=hgt1,$fn=$fn*4);
                        }
                    }
                    linear_extrude(height=10,convexity=10) polygon([
                        [0,0],
                        [0,200],
                        [200*(lug_widh-crn_r)/sqrt(pow(r_outer-crn_r,2)-pow(lug_widh-crn_r,2)),200],
                        [lug_widh-crn_r,sqrt(pow(r_outer-crn_r,2)-pow(lug_widh-crn_r,2))],
                        [lug_widh,sqrt(pow(r_outer-crn_r,2)-pow(lug_widh-crn_r,2))],
                        [lug_widh,sqrt(pow(r_inner+crn_r,2)-pow(lug_widh+crn_r,2))],
                        [lug_widh+crn_r,sqrt(pow(r_inner+crn_r,2)-pow(lug_widh+crn_r,2))],
                    ]);
                }
                translate([lug_widh+crn_r,sqrt(pow(r_inner+crn_r,2)-pow(lug_widh+crn_r,2)),0]) {
                    translate([0,0,-1]) cylinder(r=crn_r,h=50);
                    
                    for(iz=[0,1]) mirror([0,0,iz]) translate([0,0,-iz*hgt1]) {
                        hull() for(iy=[0,50]) translate([0,0,-50]) {
                            translate([0,iy,bev_l]) cylinder(r=crn_r,h=50);
                            translate([0,iy,-bev_l]) cylinder(r=crn_r+2*bev_l,h=50);
                        }
                    }
                }
            }
            translate([lug_widh-crn_r,sqrt(pow(r_outer-crn_r,2)-pow(lug_widh-crn_r,2)),0]) hull() {
                translate([0,0,bev_l]) cylinder(r=crn_r,h=hgt1-2*bev_l);
                cylinder(r=max(0.01,crn_r-bev_l),h=hgt1);
            }
        }
    }
}

module locking_ring_top() union() {
    /*r_inner = 120+clr_h;
    r_intrm = 120+7.5+clr_h;
    r_outer = 120+7.5+7.5;
    hgt1 = 5-0.4;*/
    
    r_inner = lug_inner_r+clr_h;
    r_intrm = lug_outer_r+clr_h;
    r_outer = lring_outer_r;
    hgt1 = lring_top_hgt-clr_v;
    
    difference() {
        cylinder_bev(r_outer,hgt1,bev_xs,bev_l);
            
        intersection() {
            union() {
                translate([0,0,-1]) linear_extrude(height=10,convexity=10) {
                    for(i=[0:lug_num-1]) rotate([0,0,(i)*360/lug_num]) {
                        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,360/lug_num/2]) {
                            polygon([
                                [-0.01,0.01],
                                [-0.01,200],
                                [lug_widh-crn_r,200],
                                [lug_widh-crn_r,sqrt(pow(r_intrm-clr_h-crn_r,2)-pow(lug_widh-crn_r,2))],
                                [lug_widh+crn_r,sqrt(pow(r_inner-clr_h+crn_r,2)-pow(lug_widh+crn_r,2))],
                            ]);
                        }
                    }
                }
                
                for(i=[0:lug_num-1]) rotate([0,0,(i)*360/lug_num]) {
                    for(j=[0,1]) mirror([j,0,0]) rotate([0,0,360/lug_num/2]) {
                        translate([lug_widh-crn_r,sqrt(pow(r_intrm-clr_h-crn_r,2)-pow(lug_widh-crn_r,2)),0]) {
                            cylinder_neg_bev(crn_r+clr_h,hgt1,bev_s,bev_s,[0,-10]);
                        }
                    }
                }
            }
            cylinder_neg_bev(r_intrm,hgt1,bev_xs,bev_s);
        }
        
        cylinder_neg_bev(r_inner,hgt1,bev_s,bev_s);
        
        children();
        
        /*locking_ring_screws() {
            translate([0,0,-1]) cylinder(r=1.75,h=50);
            
            translate([0,0,5-0.4-bev_s]) cylinder(r1=3,r2=3+50,h=50);
            
            translate([0,0,1]) cylinder(r=3,h=50);
        }*/
    }
    
    for(i=[0:lug_num-1]) rotate([0,0,(i)*360/lug_num]) {
        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,360/lug_num/2]) {
            hull() for(i=[sqrt(pow(r_inner-clr_h+crn_r,2)-pow(lug_widh+crn_r,2)),sqrt(pow(r_intrm-clr_h-crn_r,2)-pow(lug_widh+crn_r,2))]) translate([lug_widh+crn_r,i,0]) {
                
                cylinder_bev(crn_r-clr_h,hgt1,bev_s,bev_s);
            }
        }
    }
}

module locking_ring_bottom() union() {
    /*r_inner = 120+clr_h;
    r_intrm1 = 120+7.5+clr_h;
    r_intrm2 = 120+4;
    r_outer = 120+7.5+7.5;
    hgt1 = 5-0.4;
    hgt2 = 5+10+0.4;
    

    limtab_num = 4;
    limtab_a_trav = 22.5;
    limtab_a_offs = 22.5;
    limtab_widh = 20;*/
    
    r_inner = lug_inner_r+clr_h;
    r_intrm1 = lug_outer_r+clr_h;
    r_intrm2 = limtab_r;
    r_outer = lring_outer_r;
    hgt1 = lring_btm_hgt-clr_v;
    hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;
    
    difference() {
        union() {
            cylinder_bev(r_outer,hgt2,bev_l,bev_xs);
            locking_ring_bottom_latch_prot_pos();
        }
        
        rotate([0,0,-limtab_a_offs-limtab_a_trav/2]) intersection() {
            union() {
                translate([0,0,-1]) linear_extrude(height=10,convexity=10) {
                    for(i=[0:limtab_num-1]) rotate([0,0,(i)*360/limtab_num]) {
                        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,-limtab_a_trav/2]) {
                            polygon([
                                [-0.01*tan(limtab_a_trav/2),0.01],
                                [-200*tan(limtab_a_trav/2),200],
                                [limtab_widh-crn_r,200],
                                [limtab_widh-crn_r,sqrt(pow(r_intrm2-crn_r,2)-pow(limtab_widh-crn_r,2))],
                                //[limtab_widh,sqrt(pow(r_intrm2-crn_r,2)-pow(limtab_widh-crn_r,2))],
                                //[limtab_widh,sqrt(pow(r_inner-clr_h+crn_r,2)-pow(limtab_widh+crn_r,2))],
                                [limtab_widh+crn_r,sqrt(pow(r_inner-clr_h+crn_r,2)-pow(limtab_widh+crn_r,2))],
                            ]);
                        }
                    }
                }
                    
                for(i=[0:limtab_num-1]) rotate([0,0,(i)*360/limtab_num]) {
                    for(j=[0,1]) mirror([j,0,0]) rotate([0,0,-limtab_a_trav/2]) {
                        translate([limtab_widh-crn_r,sqrt(pow(r_intrm2-crn_r,2)-pow(limtab_widh-crn_r,2)),0]) {
                            cylinder_neg_bev(crn_r+clr_h,hgt1,bev_s,bev_s,[0,-20]);
                        }
                    }
                }
            }
            
            cylinder_neg_bev(r_intrm2+clr_h,hgt1,bev_s,bev_s);
        }
        
        
        translate([0,0,hgt1]) cylinder_bev(r_intrm1,50,bev_s,0);
        translate([0,0,hgt2-bev_xs]) cylinder_bev(r_intrm1+bev_xs,50,bev_xs,0);
        cylinder_neg_bev(r_inner,hgt1,bev_s,bev_s);
        
        locking_ring_bottom_latch_prot_neg(hgt1,r_intrm1);
        
        children();
        
        /*locking_ring_screws() {
            translate([0,0,-1]) cylinder(r=1.75,h=50);
            hull() {
                translate([-50,0,5-0.4]) cylinder(r=1.75,h=50);
                translate([0,0,5-0.4]) cylinder(r=1.75,h=50);
            }
            hull() for(i=[0,1]) mirror([0,i,0]) {
                translate([-1.75,bev_s,5-0.4]) cylinder(r=1.75,h=50,$fn=4);
                translate([-10,bev_s,5-0.4]) cylinder(r=1.75,h=50,$fn=4);
            }
        
            hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) {
                cylinder(r=0.2,h=1+5-0.4-1-2);
                cylinder(r=0.2+0.2,h=1+5-0.4-1-2-1);
            }
            hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1);
            hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1+0.2); 
        }*/
    }
    
    locking_ring_bottom_latch_prot_pos2();
        
    rotate([0,0,-limtab_a_offs-limtab_a_trav/2]) {
        for(i=[0:limtab_num-1]) rotate([0,0,(i)*360/limtab_num]) {
            for(j=[0,1]) mirror([j,0,0]) rotate([0,0,-limtab_a_trav/2]) {
                hull() for(i=[sqrt(pow(r_inner-clr_h+crn_r,2)-pow(limtab_widh+crn_r,2)),sqrt(pow(r_intrm1-clr_h-crn_r,2)-pow(limtab_widh+crn_r,2))]) translate([limtab_widh+crn_r,i,0]) {
                    cylinder_bev(crn_r-clr_h,hgt1,bev_s,bev_s);
                }
            }
        }
    }
}

module locking_ring_bottom_latch_prot_pos() {
    hgt1 = lring_btm_hgt-clr_v;
    hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;
    
    intersection() {
        cylinder_bev(latch_prot_outer_r,hgt2,bev_l,bev_xs);
        rotate_extrude(angle=-30-2*asin(((5+clr_h)/2)/lring_outer_r)) square([100,50]);
    }
    
    for(ia=[-30-2*asin(((5+clr_h)/2)/lring_outer_r),0]) rotate([0,0,ia]) mirror([0,(ia<0?0:1),0]) {
        rotate([0,0,-7.5]) round_step_on_rad(lring_outer_r,latch_prot_outer_r,7.5,2,5,hgt2,bev_l,bev_xs);
    }
}

module locking_ring_bottom_latch_prot_neg(hgt1,r_intrm1) {
    hgt1 = lring_btm_hgt-clr_v;
    hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;
    
    r_intrm1 = lug_outer_r+clr_h;
    
    intersection() {
        union() {
            translate([latch_piv_r,0,hgt1]) cylinder_bev(latch_outer_r+clr_h,50,bev_s,0);
            translate([latch_piv_r,0,hgt2-bev_xs]) cylinder_bev(latch_outer_r+clr_h+bev_xs,50,bev_xs,0);
        }
        translate([0,0,hgt1]) union() {
            cube([200,200,200]);
            rotate_extrude() polygon([
                [200,0],
                [r_intrm1+2.5+bev_s,0],
                [r_intrm1+2.5,bev_s],
                [r_intrm1+2.5,hgt2-hgt1-bev_xs],
                [r_intrm1+2.5-bev_xs,hgt2-hgt1],
                [r_intrm1+2.5-bev_xs,200],
                [200,200],
            ]);
            translate([latch_piv_r,0,0]) rotate_extrude() polygon([
                [0,0],
                [latch_inner_r+clr_h-bev_s,0],
                [latch_inner_r+clr_h,bev_s],
                [latch_inner_r+clr_h,hgt2-hgt1-bev_xs],
                [latch_inner_r+clr_h+bev_xs,hgt2-hgt1],
                [latch_inner_r+clr_h+bev_xs,200],
                [0,200],
            ]);
        }
            
            
        union() {
            cube([200,200,200]);
            translate([latch_piv_r,0,0]) rotate_extrude(angle=-180) square([latch_outer_r+clr_h-1,50]);
            intersection() {
                translate([latch_piv_r,0,0]) rotate_extrude(angle=-180) square([latch_outer_r+clr_h+1,50]);
                rotate_extrude() translate([lug_outer_r+clr_h+2.5+1,0]) square([200,50]);
            }
        }
    }
    
    intersection() {
        translate([latch_piv_r,0,hgt1]) rotate_extrude(angle=180) square([latch_outer_r+clr_h+1,50]);
        translate([0,0,hgt1]) rotate_extrude()  {
            square([lug_outer_r+clr_h+1,50]);
            translate([lring_outer_r-1,0]) square([50,50]);
        }
    }
    intersection() {
        translate([latch_piv_r,0,hgt1]) rotate_extrude(angle=-180) square([latch_inner_r+clr_h+1,50]);
        translate([0,0,hgt1]) rotate_extrude()  {
            square([lug_outer_r+clr_h+1,50]);
            translate([lug_outer_r+clr_h+2.5-1,0]) square([50,50]);
        }
    }
    intersection() {
        translate([latch_piv_r,0,hgt1]) rotate_extrude(angle=-180) square([latch_outer_r+clr_h+1,50]);
        translate([0,0,hgt1]) rotate_extrude()  {
            translate([latch_prot_outer_r-1,0]) square([50,50]);
        }
    }
}

module locking_ring_bottom_latch_prot_pos2() {
    hgt1 = lring_btm_hgt-clr_v;
    hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;
    r_outer = lring_outer_r;
    
    intersection() {
        union() {
            for(ix=[lug_outer_r+clr_h+1,lring_outer_r-1]) {
                rotate([0,0,acos((pow(ix,2)+pow(latch_piv_r,2)-pow(latch_outer_r+clr_h+1,2))/(2*ix*latch_piv_r))]) {
                    translate([ix,0,0]) {
                        cylinder_bev(1+bev_s,hgt1+bev_s,0,bev_s);
                        cylinder_bev(1,hgt2,0,bev_xs);
                    }
                }
            }
            
            for(ix=[lug_outer_r+clr_h+1,lug_outer_r+clr_h+2.5-1]) {
                rotate([0,0,-acos((pow(ix,2)+pow(latch_piv_r,2)-pow(latch_inner_r+clr_h+1,2))/(2*ix*latch_piv_r))]) {
                    translate([ix,0,0]) {
                        cylinder_bev(1+bev_s,hgt1+bev_s,0,bev_s);
                        cylinder_bev(1,hgt2,0,bev_xs);
                    }
                }
            }
            
            for(ix=[latch_prot_outer_r-1]) {
                rotate([0,0,-acos((pow(ix,2)+pow(latch_piv_r,2)-pow(latch_outer_r+clr_h+1,2))/(2*ix*latch_piv_r))]) {
                    translate([ix,0,0]) {
                        cylinder_bev(1+bev_s,hgt1+bev_s,0,bev_s);
                        cylinder_bev(1,hgt2,0,bev_xs);
                    }
                }
            }
        }
        union() {
            cylinder_bev(r_outer,hgt2,bev_l,bev_xs);
            locking_ring_bottom_latch_prot_pos();
        }
    }
}

module base_ring_top() difference() {
    hgt1 = bring_top_hgt;
    hgt2 = bring_top_hgt + lug_hgt;
    
    union() {
        hull() {
            cylinder(r=lug_outer_r-bev_s,h=hgt1,$fn=$fn*2);
            translate([0,0,bev_s]) cylinder(r=lug_outer_r,h=hgt1-2*bev_s,$fn=$fn*2);
        }
        
        intersection() {
            union() {
                linear_extrude(height=hgt2,convexity=10) {
                    for(i=[0:lug_num-1]) rotate([0,0,(i)*360/lug_num]) {
                        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,360/lug_num/2]) {
                            polygon([
                                [0.01*tan(360/lug_num/2),0.01],
                        
                                [200*tan(360/lug_num/2),200],
                                [200*tan(360/lug_num/4),200],
                                [lug_widh+crn_r,sqrt(pow(lug_outer_r-crn_r+clr_h,2)-pow(lug_widh+crn_r,2))],
                                [lug_widh+crn_r,sqrt(pow(lug_inner_r+crn_r,2)-pow(lug_widh+crn_r,2))],
                            ]);
                        }
                    }
                }
                for(i=[0:lug_num-1]) rotate([0,0,(i)*360/lug_num]) {
                    for(j=[0,1]) mirror([j,0,0]) rotate([0,0,360/lug_num/2]) {
                        hull() {
                            translate([lug_widh+crn_r,sqrt(pow(lug_outer_r-crn_r+clr_h,2)-pow(lug_widh+crn_r,2)),0]) {
                                cylinder(r=crn_r-clr_h,h=hgt2-bev_s);
                                cylinder(r=crn_r-clr_h-bev_s,h=hgt2);
                            }
                            translate([lug_widh+crn_r,sqrt(pow(lug_inner_r+crn_r,2)-pow(lug_widh+crn_r,2)),0]) {
                                cylinder(r=crn_r-clr_h,h=hgt2-bev_s);
                                cylinder(r=crn_r-clr_h-bev_s,h=hgt2);
                            }
                        }
                        hull() {
                            translate([lug_widh+crn_r,sqrt(pow(lug_outer_r-crn_r+clr_h,2)-pow(lug_widh+crn_r,2)),-bev_s]) {
                                cylinder(r=crn_r-clr_h,h=hgt1+2*bev_s);
                                cylinder(r=crn_r-clr_h+2*bev_s,h=hgt1);
                            }
                            translate([lug_widh+crn_r,sqrt(pow(lug_inner_r+crn_r,2)-pow(lug_widh+crn_r,2)),-bev_s]) {
                                cylinder(r=crn_r-clr_h,h=hgt1+2*bev_s);
                                cylinder(r=crn_r-clr_h+2*bev_s,h=hgt1);
                            }
                        }
                    }
                }
            }
            hull() {
                cylinder(r=lug_outer_r-bev_s,h=hgt2,$fn=$fn*2);
                translate([0,0,bev_s]) cylinder(r=lug_outer_r,h=hgt2-2*bev_s,$fn=$fn*2);
            }
        }
    }
    
    hull() {
        translate([0,0,hgt1]) cylinder(r=lug_inner_r+clr_h-bev_s,h=50,$fn=$fn*2);
        translate([0,0,hgt1+bev_s]) cylinder(r=lug_inner_r+clr_h,h=50,$fn=$fn*2);
    }
    translate([0,0,hgt2-bev_s]) cylinder(r1=lug_inner_r+clr_h,r2=lug_inner_r+clr_h+50,h=50,$fn=$fn*2);
    
    
    cylinder_neg_bev(passage_r,hgt1,bev_xs,bev_l);
    
    children();
}


module base_ring_bottom() difference() {
    /*r_inner = 120;
    r_intrm = 120+4;
    r_outer = 120+7.5+2.5;
    hgt1 = 5-0.4;
    hgt2 = 5+5;
    
    lug_num = 8;
    lug_widh = 20;*/
    
    r_inner = lug_inner_r;
    r_intrm = limtab_r;
    r_outer = bring_outer_r;
    hgt1 = bring_btm_hgt-clr_v;
    hgt2 = bring_btm_hgt+lring_btm_hgt;
    
    union() {
        cylinder_bev(r_outer,hgt1,bev_s,bev_s);
        cylinder_bev(r_inner,hgt2,0,0);
        cylinder_bev(r_inner+bev_s,hgt1+bev_s,0,bev_s);
        
        intersection() {
            linear_extrude(height=50,convexity=10) {
                for(i=[0:limtab_num-1]) rotate([0,0,(i)*360/limtab_num-limtab_a_offs]) {
                    for(j=[0,1]) mirror([j,0,0]) {
                        polygon([
                            [-0.01,0.01],
                            [-0.01,200],
                            [limtab_widh-crn_r,200],
                            [limtab_widh-crn_r,sqrt(pow(r_intrm-crn_r,2)-pow(limtab_widh-crn_r,2))],
                            [limtab_widh,sqrt(pow(r_intrm-crn_r,2)-pow(limtab_widh-crn_r,2))],
                            [limtab_widh,sqrt(pow(r_inner+crn_r,2)-pow(limtab_widh+crn_r,2))],
                            [limtab_widh+crn_r,sqrt(pow(r_inner+crn_r,2)-pow(limtab_widh+crn_r,2))],
                        ]);
                    }
                }
            }
            union() {
                cylinder_bev(r_intrm,hgt2,0,0);
                cylinder_bev(r_intrm+bev_s,hgt1+bev_s,0,bev_s);
            }
        }
        
        for(i=[0:limtab_num-1]) rotate([0,0,(i)*360/limtab_num-limtab_a_offs]) {
            for(j=[0,1]) mirror([j,0,0]) {
                translate([limtab_widh-crn_r,sqrt(pow(r_intrm-crn_r,2)-pow(limtab_widh-crn_r,2))]) {
                    hull() for(k=[0,-5]) translate([0,k,0]) cylinder_bev(crn_r,hgt2,0,0);
                    hull() for(k=[0,-5]) translate([0,k,0]) cylinder_bev(crn_r+bev_s,hgt1+bev_s,0,bev_s);
                }
            }
        }
    }
    
    for(i=[0:limtab_num-1]) rotate([0,0,(i)*360/limtab_num-limtab_a_offs]) {
        for(j=[0,1]) mirror([j,0,0]) {
            translate([limtab_widh+crn_r,sqrt(pow(r_inner+crn_r,2)-pow(limtab_widh+crn_r,2)),hgt1]) {
                cylinder_bev(crn_r,50,bev_s,0);
            }
        }
    }
    
    
    /*#for(i=[360/16/2:360/16:360]) rotate([0,0,i]) translate([120-8/2,0,-0.01]) {
        hull() {
            cylinder(r=1.25,h=5);
            cylinder(r=0.5,h=5+(1.25-0.5));
        }
        cylinder(r1=1.75,r2=1.25,h=1.75-1.25);
    }
    
    base_ring_screws() {
        translate([0,0,-1]) cylinder(r=1.75,h=50);
        hull() translate([0,0,5-0.4]) {
            cylinder(r=1.75,h=50);
            translate([200,0,0]) cylinder(r=1.75,h=50);
        }
        hull() for(i=[0,1]) mirror([0,i,0]) {
            translate([1.75,bev_s,5-0.4]) cylinder(r=1.75,h=50,$fn=4);
        }
        
        hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) {
            cylinder(r=0.2,h=1+5-0.4-1-2);
            cylinder(r=0.2+0.2,h=1+5-0.4-1-2-1);
        }
        
        hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1);
        hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1+0.2); 
    }*/
    
    cylinder_neg_bev(passage_r,hgt2,bev_l,bev_xs);
    
    children();
}

module latch_datum_from_origin() {
    translate([latch_piv_r,0,0]) children();
}

module origin_datum_from_latch() {
    translate([-latch_piv_r,0,0]) children();
}

module latch() latch_datum_from_origin() {
    hgt2 = bring_top_hgt + lug_hgt;
    r_intrm1 = lug_outer_r+clr_h;
    
    latch_unlck_rot = acos((pow(latch_piv_r,2)+pow(latch_inner_r,2)-pow(r_intrm1,2))/(2*latch_piv_r*latch_inner_r)) - acos((pow(latch_piv_r,2)+pow(latch_inner_r,2)-pow(latch_tab_r,2))/(2*latch_piv_r*latch_inner_r));
    
    //echo(latch_unlck_rot);
    
    //locking tab
    difference() {
        intersection() {
            cylinder_bev(latch_outer_r,hgt2,bev_s,bev_s);
            origin_datum_from_latch() cylinder_bev(lring_outer_r,hgt2,bev_s,bev_s);
            origin_datum_from_latch() cube([100,100,100]);
        }
        cylinder_neg_bev(latch_inner_r,hgt2,bev_s,bev_s);
        origin_datum_from_latch() cylinder_neg_bev(latch_tab_r,hgt2,bev_s,bev_s);
    }
    
    difference() {
        union() {
            //lever
            intersection() {
                cylinder_bev(latch_mid_r,hgt2,bev_s,bev_s);
                origin_datum_from_latch() union() {
                    cylinder_bev(lring_outer_r,hgt2,bev_s,bev_s);
                    locking_ring_bottom_latch_prot_pos();
                }
            }
            //button
            intersection() {
                cylinder_bev(latch_outer_r,hgt2,bev_s,bev_s);
                origin_datum_from_latch() cylinder_bev(latch_prot_outer_r+5,hgt2,bev_s,bev_s);
                origin_datum_from_latch() rotate([0,0,-acos((pow(latch_prot_outer_r+5,2)+pow(latch_piv_r,2)-pow(latch_outer_r,2))/(2*(latch_prot_outer_r+5)*latch_piv_r))+2*asin((15/2)/(latch_prot_outer_r+5))]) translate([0,-100,0]) cube([100,100,100]);
            }
        }
        for(ia=[0:0.5:1]) rotate([0,0,ia*latch_unlck_rot]) origin_datum_from_latch() cylinder_neg_bev(r_intrm1,hgt2,bev_s,bev_s);
        
        intersection() {
            rotate([0,0,latch_unlck_rot]) origin_datum_from_latch() cylinder_neg_bev(r_intrm1+2.5+clr_h,hgt2,bev_s,bev_s);
            rotate_extrude(angle=-180) translate([latch_inner_r+clr_h,0]) square([50,50]);
        }
        
        cylinder_neg_bev(1.5+0.15,hgt2,bev_s,bev_s);
    }
}