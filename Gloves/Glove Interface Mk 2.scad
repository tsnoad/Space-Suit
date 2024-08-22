$fn = 72;



/*bev_xl = 2;
bev_l = 0.8;
bev_s = 0.4;
bev_xs = 0.2;*/

sleeve_c1 = 2*172;
sleeve_c2 = 2*139;
sleeve_c12h = 103;

sleeve_r1 = sleeve_c1/3.14159/2;
sleeve_r2 = sleeve_c2/3.14159/2;
sleeve_a = abs(atan((sleeve_r2-sleeve_r1)/sleeve_c12h));

glove_c1 = 2*140;
glove_c2 = 2*127;
glove_c12h = 50;

glove_r1 = glove_c1/3.14159/2;
glove_r2 = glove_c2/3.14159/2;
glove_a = abs(atan((glove_r2-glove_r1)/glove_c12h));

oring_rad = 1.5;
oring_area = 3.14159*pow(oring_rad,2);

oring_gland_wid = 2;
oring_gland_dep = oring_area/oring_gland_wid;

oring_fol_hgt = oring_area/oring_gland_wid*0.25;

echo(oring_gland_dep);
echo(oring_fol_hgt);



*union() {
    translate([0,0,-sleeve_c12h]) union() {
        cylinder(r1=sleeve_r1,r2=sleeve_r2,h=sleeve_c12h);
    }
    
    translate([0,0,0]) union() {
        cylinder(r1=glove_r1,r2=glove_r2,h=glove_c12h);
    }
}


*translate([0,0,(-(bring_btm_hgt+lring_btm_hgt)-bring_top_hgt)-(25+2.75+5)]) {
    sleeve_mandril();
    sleeve_collar();
}

*difference() {
    union() {
        glove_mandril();
        glove_collar();
    }
    translate([0,0,-0.01]) cube([200,200,200]);
}



clr_h = 0.4;
clr_v = 0.4;


//passage_r = 40.5;
passage_r = 37.5;

lug_inner_r = passage_r+5;
lug_outer_r = lug_inner_r + 5;
lug_hgt = 5;

lug_num = 6;
//lug_widh = 20;
lug_widh = 3.14159*2*((lug_outer_r-lug_inner_r)/2+lug_inner_r)/lug_num/4;


lring_top_hgt = 5; //thickness of top flange (with the lug cutouts) of the locking ring
lring_outer_r = lug_outer_r + 5; //outside radius of the locking ring
lring_btm_hgt = 5; //thickness of bottom flange of the locking ring

bring_top_hgt = 5;
bring_btm_hgt = 5; //thickness of the base
//bring_inner_r = ;
//bring_intrm_r = ;
bring_outer_r = lug_outer_r+0;

limtab_r = lug_inner_r + 2.5;
limtab_num = 3;
limtab_a_trav = 360/limtab_num/4;
limtab_a_offs = 360/limtab_num/4;
limtab_widh = 3.14159*2*limtab_r/limtab_num/8;
//limtab_widh = 7.5;

latch_prot_outer_r = lring_outer_r + 5;
latch_piv_r = lug_outer_r+clr_h + (latch_prot_outer_r - (lug_outer_r+clr_h))/2;

latch_tab_r = r_intrm1 - 2.5;

latch_mid_r = 2*latch_piv_r*sin(30/2);
latch_inner_r = latch_mid_r-5;
latch_outer_r = latch_mid_r+5;




difference() {
    translate([0,0,-(bring_btm_hgt+lring_btm_hgt)-bring_top_hgt]) {
        *base_ring_bottom() {
            for(ia=[0:120:360-120]) rotate([0,0,ia]) translate([lug_inner_r-(1.5+0.15),0,0]) {
                translate([0,0,-0.01]) cylinder(r=(1.5+0.15),h=100);
                translate([0,0,bring_btm_hgt-clr_v]) hull() {
                    cylinder(r=(1.5+0.15),h=100);
                    translate([50,0,0]) cylinder(r=(1.5+0.15),h=100);
                }
            }
            for(ia=[60:120:60+360-120]) rotate([0,0,ia]) translate([passage_r+(limtab_r-passage_r)/2,0,0]) {
                translate([0,0,-0.01]) cylinder(r=(1.5+0.15),h=100);
            }
        }
        translate([0,0,bring_btm_hgt+lring_btm_hgt]) {
            base_ring_top();
           
            *rotate_extrude() polygon([
                [lug_inner_r-2.4-2/2-1.6/2,0],
                [lug_inner_r-2.4-2/2-1.6/2,bring_top_hgt+oring_fol_hgt-bev_xs],
                [lug_inner_r-2.4-2/2-1.6/2+bev_xs,bring_top_hgt+oring_fol_hgt],
                [lug_inner_r-2.4-2/2+1.6/2-bev_xs,bring_top_hgt+oring_fol_hgt],
                [lug_inner_r-2.4-2/2+1.6/2,bring_top_hgt+oring_fol_hgt-bev_xs],
                [lug_inner_r-2.4-2/2+1.6/2,bring_top_hgt+bev_xs],
                [lug_inner_r-2.4-2/2+1.6/2+bev_xs,bring_top_hgt],
                [lug_inner_r-2.4-2/2+1.6/2+bev_xs,0],
            ]);
            
            latch();
        }
        rotate([0,0,0]) {
            translate([0,0,bring_btm_hgt]) locking_ring_bottom() {
                for(ia=[60:60:360-60]) rotate([0,0,ia]) translate([lug_outer_r+clr_h+(1.5+0.15),0,0]) {
                    translate([0,0,-0.01]) cylinder(r=(1.5+0.15),h=100);
                    translate([0,0,-0.01]) hull() {
                        cylinder(r=3,h=0.01);
                        cylinder(r=0.01,h=3);
                    }
                    translate([0,0,lring_btm_hgt-clr_v]) hull() {
                        cylinder(r=(1.5+0.15),h=100);
                        translate([-50,0,0]) cylinder(r=(1.5+0.15),h=100);
                    }
                }
                for(ia=[0]) rotate([0,0,ia]) translate([lring_outer_r,0,0]) {
                    translate([0,0,-0.01]) cylinder(r=(1.5+0.15),h=100);
                }
            }
            *translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v]) locking_ring_top();
        }
    }
    *translate([0,0,-50]) cube([200,200,200]);
}


*translate([0,0,0*103+10]) { 
import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Gloves/MA-3 Glove C.stl");
import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Gloves/MA-3 Glove D.stl");
*import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Gloves/MA-3 Glove E.stl");
import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Gloves/MA-3 Glove F.stl");
}


include <../Modular Locking Ring.scad>;

module glove_collar() translate([0,0,10+2]) difference() {
    fab_thk = 0.5;
    r1 = glove_r1 - 25*tan(glove_a);
    col_h = 25;
    
    col_thk = 3.75;
    col_thk2 = col_thk+3.75;
    
        
    intersection() {
        union() {
            rotate_extrude(convexity=10,$fn=$fn*2) {
                polygon([
                    [r1+bev_s*tan(glove_a)+bev_s,0],
                    [r1+bev_s*tan(glove_a),bev_s],
                
                    [r1-col_h*tan(glove_a)+bev_l*tan(glove_a),col_h-bev_l],
                    [r1-col_h*tan(glove_a)+bev_l*tan(glove_a)+bev_l,col_h],
                
                    [r1+col_thk-bev_l,col_h],
                    [r1+col_thk,col_h-bev_l],
                
                    [r1+col_thk,bev_s],
                    [r1+col_thk-bev_s,0],
                ]);
                
                        
                translate([r1,0]) rotate([0,0,glove_a]) translate([0,col_h/2/cos(glove_a)]) {
                    step_h0 = 2.5;
                    step_h1 = step_h0 + 1.5;
                    step_l = 4;
                    
                    mirror([1,0]) {
                        translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2+fab_thk,2);
                        translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2+fab_thk,2);
                    }
                }
            }
            
            difference() {
                union() {
                    boss_l1 = 5;
                    boss_l2 = 7.5;
                    rotate([0,0,-asin(boss_l1/(r1+col_thk))]) rotate_extrude(angle=2*asin(boss_l1/(r1+col_thk))) polygon([
                        [0,0],
                        [r1+col_thk2-bev_s,0],
                        [r1+col_thk2,bev_s],
                        [r1+col_thk2,col_h-bev_l],
                        [r1+col_thk2-bev_l,col_h],
                        [0,col_h],
                    ]);
                    for(iy=[0,1]) mirror([0,iy,0]) rotate([0,0,-asin((boss_l1+boss_l2)/(r1+col_thk))])  round_step_on_rad(r1+col_thk,r1+col_thk2,asin(boss_l2/(r1+col_thk)),5,5,col_h,bev_s,bev_l);
                }
                translate([0,0,-0.01]) cylinder(r=r1+col_thk-bev_l-0.01,h=50);
            }
        }
        
        union() {
            translate([-200+25,-100,-50]) cube([200,200,200]);
            for(iy=[0,1]) mirror([0,iy,0]) rotate([90,0,0]) {
                hull() for(iz=[-bev_l,50]) translate([0,0,1.5+bev_l+iz]) linear_extrude(height=50) hull() {
                    for(point=[
                        [r1-iz,-iz],
                        [r1-iz-col_h*tan(glove_a),col_h+iz],
                        [r1+iz+col_thk2,col_h+iz],
                        [r1+iz+col_thk2,-iz],
                    ]) {
                        translate(point) circle(r=0.01);
                    }
                }
            }
        }
    }
    
    for(iz=[0.25,0.75]*col_h) translate([r1+col_thk2/2,0,iz]) rotate([-90,0,0]) {
        translate([0,0,-50]) hull() cylinder_oh(1.5+0.15,100);
        
        hull() for(ib=[0,bev_xs]) translate([0,0,5+(bev_xs-ib)]) {
            cylinder(r=3-ib,h=100);
            translate([20,0,0]) cylinder(r=3-ib,h=100);
            translate([20,-20*tan(30),0]) cylinder(r=3-ib,h=100);
        }
        
        mirror([0,0,1]) hull() for(ib=[0,bev_xs]) translate([0,0,5+(bev_xs-ib)]) {
            for(ia=[0:60:360-60]) rotate([0,0,ia+30]) translate([2.75/cos(30),0,0]) {
                cylinder(r=max(0.01,0.2-ib),h=100);
            }
            
            translate([20,0,0]) cylinder(r=2.75/cos(30)+0.2-ib,h=100);
            translate([20,-20*tan(30),0]) cylinder(r=2.75/cos(30)+0.2-ib,h=100);
        }
    }
    
    /*
    hull() for(ix=[0,100]) translate([ix,0,-10]) cylinder(r=1.5,h=100);
        
    for(iz=[max_bolt_h,max_bolt_h-6]) translate([rc,0,iz]) rotate([-90,0,0]) {
        translate([0,0,-50]) hull() cylinder_oh(1.5+0.15,100);
    }
    hull() for(iz=[max_bolt_h,max_bolt_h-6]) translate([rc,0,iz]) rotate([-90,0,0]) {
        for(ib=[0,0.2]) translate([0,0,10+(0.2-ib)]) {
            cylinder(r=3-ib,h=100);
            translate([20,0,0]) cylinder(r=3-ib,h=100);
            translate([20,-20*tan(45),0]) cylinder(r=3-ib,h=100);
        }
    }
    mirror([0,1,0]) hull() for(iz=[max_bolt_h,max_bolt_h-6]) translate([rc,0,iz]) rotate([-90,0,0]) {
        for(ib=[0,0.2]) translate([0,0,10+(0.2-ib)]) {
            for(ia=[0:60:360-60]) rotate([0,0,ia]) translate([2.75/cos(30),0,0]) {
                cylinder(r=max(0.01,0.2-ib),h=100);
            }
            
            translate([20,0,0]) cylinder(r=2.75/cos(30)+0.2-ib,h=100);
            translate([20,-20*tan(45),0]) cylinder(r=2.75/cos(30)+0.2-ib,h=100);
        }
    }*/
}

module glove_mandril() difference() {
    fab_thk = 0.5;
    r1 = glove_r1 - 25*tan(glove_a) - fab_thk*cos(glove_a);
    col_h = 25;
    
    union() {
        cylinder_bev(lug_inner_r,10+0.01,bev_s,0,$fn=$fn*2);
        lug_ring();
        
        translate([0,0,10+2]) rotate_extrude($fn=$fn*2) union() {
            difference() {
                polygon([
                    [0,-2],
                    [r1,-2],
                
                    [r1,0],
                
                    [r1-col_h*tan(glove_a)+bev_s*tan(glove_a),col_h-bev_s],
                    [r1-col_h*tan(glove_a)+bev_s*tan(glove_a)-bev_s,col_h],
                    [0,col_h],
                ]);
                
                
                translate([r1,0]) rotate([0,0,glove_a]) translate([0,col_h/2/cos(glove_a)]) {
                    step_h0 = 5;
                    step_h1 = step_h0 + 1.5;
                    step_l = 4;
                    
                    mirror([1,0]) {
                        translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2,2+fab_thk);
                        translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2,2+fab_thk);
                    }
                }
            }
            
            mirror([0,1]) round_step(r1,lug_inner_r,2,1,1);
        }
    }
    translate([0,0,20]) cylinder_neg_bev(passage_r,-20+10+2+col_h,0,bev_s,$fn=$fn*2);
    
    translate([0,0,-0.01]) rotate_extrude($fn=$fn*2) union() {
        
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
        
        polygon([
            [0,0],
            [lug_inner_r-2.4-oring_gland_wid-2.4+bev_s,0],
            [lug_inner_r-2.4-oring_gland_wid-2.4,bev_s],
            [lug_inner_r-2.4-oring_gland_wid-2.4,oring_gland_dep],
            [0,oring_gland_dep],
        ]);
        
        translate([0,oring_gland_dep]) round_step(lug_inner_r-2.4-oring_gland_wid-2.4,passage_r,5,2,2);
        translate([0,oring_gland_dep+5]) square([passage_r,50]);
    }
}









module sleeve_mandril() difference() {
    fab_thk = 1;
    rim_r = 2.75;
    col_h = 25;
    
    r1 = sleeve_r2;
    rc = r1 + rim_r/cos(sleeve_a) + col_h*tan(sleeve_a);
    r2 = max(rc, 37.5+10);
    r3 = 37.5;
    
    
    rotate_extrude($fn=$fn*2) difference() {
        polygon([
            [r3,bev_s],
            [r3+bev_s,0],
        
            [r1+bev_s*tan(sleeve_a)-bev_s,0],
            [r1+bev_s*tan(sleeve_a),bev_s],
        
            //[rc-rim_r*cos(sleeve_a),col_h+rim_r*sin(sleeve_a)],
            //[rc,col_h],
            //[rc,col_h+rim_r],
        
            //[r2-bev_s,col_h+rim_r],
            //[r2,col_h+rim_r+bev_s],
        
            //[r2,col_h+rim_r+5-bev_s],
            //[r2-bev_s,col_h+rim_r+5],
        
            [rc-rim_r*cos(sleeve_a),col_h+rim_r*sin(sleeve_a)],
        
            [rc-rim_r*cos(sleeve_a),col_h+rim_r+5-bev_s],
            [rc-rim_r*cos(sleeve_a)-bev_s,col_h+rim_r+5],
        
            [r3+bev_xs,col_h+rim_r+5],
            [r3,col_h+rim_r+5-bev_xs],
        ]);
        //translate([rc,col_h]) circle(r=rim_r,$fn=$fn/2);
        
        translate([r1,0]) rotate([0,0,-sleeve_a]) translate([0,col_h/2/cos(sleeve_a)]) {
            step_h0 = 5;
            step_h1 = step_h0 + 1.5;
            step_l = 4;
            
            mirror([1,0]) {
                translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2,2+fab_thk);
                translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2,2+fab_thk);
            }
        }
    }
    
    //translate([0,0,-0.01]) cube([200,200,200]);
    
    translate([0,0,col_h+rim_r+5]) {
        for(ia=[0:120:360-120]) rotate([0,0,ia]) translate([lug_inner_r-(1.5+0.15),0,0]) {
            sleeve_mandril_screw_co();
        }
        for(ia=[60:120:60+360-120]) rotate([0,0,ia]) translate([passage_r+(limtab_r-passage_r)/2,0,0]) {
            sleeve_mandril_screw_co();
        }
    }
}

module sleeve_mandril_screw_co() {
    translate([0,0,-3]) {
        cylinder(r=1.75,h=100);
        hull() {
            cylinder(r=3,h=0.01);
            cylinder(r=0.01,h=3);
        }
        intersection() {
            rotate([0,10,0]) hull() {
                sphere(r=3);
                translate([0,0,-50]) {
                    cylinder(r=3,h=50);
                    for(ia2=[-1,1]*45) rotate([0,0,ia2]) translate([-15,0,0]) cylinder(r=3,h=50);
                }
            }
            translate([0,0,-50]) cylinder(r=50,h=50+0.01);
        }
    }
}




module sleeve_collar() difference() {
    fab_thk = 1;
    rim_r = 2.75-fab_thk;
    col_h = 25;

    r1 = sleeve_r2 + fab_thk*cos(sleeve_a);
    rc = r1 + rim_r/cos(sleeve_a) + col_h*tan(sleeve_a);

    max_bolt_h = ((rc-r1)-(1.5+0.15)-1.6)/tan(sleeve_a);
    
    intersection() {
        rotate_extrude($fn=$fn*2) {
            polygon([
                [r1,0],
                [rc-rim_r*cos(sleeve_a),col_h+rim_r*sin(sleeve_a)],
                [rc,col_h],
                [rc+rim_r*cos(sleeve_a),col_h+rim_r*sin(sleeve_a)],
                [rc+(rc-r1),0],
            ]);
            translate([rc,col_h]) circle(r=rim_r);
            
            hull() for(ix=[-1,1]*((rc-r1)-2*cos(sleeve_a))) translate([rc+ix,-2*sin(sleeve_a)]) circle_oh(2);
            
            translate([r1,0]) rotate([0,0,-sleeve_a]) translate([0,col_h/2/cos(sleeve_a)]) {
                step_h0 = 5;
                step_h1 = step_h0 + 1.5;
                step_l = 4;
                
                mirror([1,0]) { 
                    translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2+fab_thk,2);
                    translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2+fab_thk,2);
                }
            }
        }
        
        union() {
            translate([-200+25,-100,-50]) cube([200,200,200]);
            for(iy=[0,1]) mirror([0,iy,0]) rotate([90,0,0]) hull() {
                translate([0,0,1.5]) linear_extrude(height=50) hull() {
                    translate([rc,col_h]) circle(r=rim_r-bev_l);
                    
                    for(ix=[-1,1]*((rc-r1)-2*cos(sleeve_a))) translate([rc+ix,-2*sin(sleeve_a)]) circle_oh(2-bev_l);
                }
                translate([0,0,1.5+50]) linear_extrude(height=50) hull() {
                    translate([rc,col_h]) circle(r=rim_r-bev_l+50);
                    
                    for(ix=[-1,1]*((rc-r1)-2*cos(sleeve_a))) translate([rc+ix,-2*sin(sleeve_a)]) circle_oh(2-bev_l+50);
                }
            }
        }
    }
    
    //translate([0,0,-0.01]) cube([200,200,200]);
    
    hull() for(ix=[0,100]) translate([ix,0,-10]) cylinder(r=1.5,h=100);
        
    for(iz=[max_bolt_h,max_bolt_h-6]) translate([rc,0,iz]) rotate([-90,0,0]) {
        translate([0,0,-50]) hull() cylinder_oh(1.5+0.15,100);
    }
    hull() for(iz=[max_bolt_h,max_bolt_h-6]) translate([rc,0,iz]) rotate([-90,0,0]) {
        for(ib=[0,0.2]) translate([0,0,10+(0.2-ib)]) {
            cylinder(r=3-ib,h=100);
            translate([20,0,0]) cylinder(r=3-ib,h=100);
            translate([20,-20*tan(45),0]) cylinder(r=3-ib,h=100);
        }
    }
    mirror([0,1,0]) hull() for(iz=[max_bolt_h,max_bolt_h-6]) translate([rc,0,iz]) rotate([-90,0,0]) {
        for(ib=[0,0.2]) translate([0,0,10+(0.2-ib)]) {
            for(ia=[0:60:360-60]) rotate([0,0,ia]) translate([2.75/cos(30),0,0]) {
                cylinder(r=max(0.01,0.2-ib),h=100);
            }
            
            translate([20,0,0]) cylinder(r=2.75/cos(30)+0.2-ib,h=100);
            translate([20,-20*tan(45),0]) cylinder(r=2.75/cos(30)+0.2-ib,h=100);
        }
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