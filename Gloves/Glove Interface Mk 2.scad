/*
 * Spacesuit Glove Interface Mk 2
 * Licenced under CC BY-NC-SA 4.0
 * By: TSnoad
 * https://github.com/tsnoad/TBC
 * https://hackaday.io/project/TBC
 */

$fn = 36;


//params for immersion suit
//this is based on measuring the flat width of sleeve
sleeve_c1 = 2*172; //circumerference higher up the sleeve
sleeve_c2 = 2*139; //circumference at the end of the sleeve
sleeve_c12h = 103; //distance between the two measurement points

sleeve_r1 = sleeve_c1/3.14159/2; //convert to radius
sleeve_r2 = sleeve_c2/3.14159/2;
sleeve_a = abs(atan((sleeve_r2-sleeve_r1)/sleeve_c12h)); //and angle

sleeve_seam_a = [0,360-(22+87)/sleeve_c2*360 % 360] + [1,1]*45; //location of seams, based on right hand, a=0 is bottom/back of sleeve
sleeve_seam_widh = 20/2;

sleeve_fab_thk = 0.8; //thickness of the fabric

//params for glove
glove_c1 = 2*140;
glove_c2 = 2*127;
glove_c12h = 50;

glove_r1 = glove_c1/3.14159/2;
glove_r2 = glove_c2/3.14159/2;
glove_a = abs(atan((glove_r2-glove_r1)/glove_c12h));

//params for o-ring/gasket material
//using 3mm diameter EPDM sponge gasket
oring_rad = 1.5;
oring_area = 3.14159*pow(oring_rad,2); //cross sectional area

oring_gland_wid = 2; //width of the gland/recess that the o-ring will be stuffed into
oring_gland_dep = oring_area/oring_gland_wid; //how deep does the gland/recess have to be
oring_fol_hgt = oring_area/oring_gland_wid*0.25; //the o-ring is compressed with a protrusion/follower. The amount of compression should be 25% to get a good seal, so we need to work out the height of the follower, based on that


//params for the modular locking ring

//horizontal and vertical clearances
clr_h = 0.4;
clr_v = 0.4;

passage_r = 37.5; //width of the hole that our hand has to go through. This is the basis for all further sizing

lug_inner_r = passage_r+5; //radius of the root of the lugs
lug_outer_r = lug_inner_r + 5; //outer radius of the lugs
lug_hgt = 5; //height of the lugs

lug_num = 6; //how many
//lug_widh = 20; //if we want to specify the half width in absolute term
lug_widh = 3.14159*2*((lug_outer_r-lug_inner_r)/2+lug_inner_r)/lug_num/4 - 2;

lring_top_hgt = 5; //thickness of top flange (with the lug cutouts) of the locking ring
lring_outer_r = lug_outer_r + 5; //outside radius of the locking ring
lring_btm_hgt = 5; //thickness of bottom flange of the locking ring

bring_top_hgt = 5;
bring_btm_hgt = 5; //thickness of the base
bring_outer_r = lug_outer_r+0;

limtab_r = lug_inner_r + 2.5; //the outer radius of the lugs that limit rotation of the locking ring
limtab_num = 3; //number of limiting lugs
limtab_a_trav = 360/limtab_num/4; //how much travel is allowed - this is based on number of lugs, but the number used is smaller because of the way the model is put together
limtab_a_offs = 360/limtab_num/4; //offset in case we need to put screws in a particular place
limtab_widh = 3.14159*2*limtab_r/limtab_num/8; //how wide is each tab
//limtab_widh = 7.5; //or if we want to specify the tab width absolutely

//latch parameters
latch_prot_outer_r = lring_outer_r + 5; //outer radius of the locking ring protrusion that houses the latch
latch_piv_r = lug_outer_r+clr_h + (latch_prot_outer_r - (lug_outer_r+clr_h))/2; //where is the pivot point
latch_tab_r = lug_inner_r+clr_h + 2.4 + clr_h; //what is the radius of the tab/pawl of the latch. This is set so the wall thickness in the base ring top is 2.4mm thick (3 wall thicknesses)
latch_button_outer_r = latch_prot_outer_r + 5; //outer radius of the latch button from the origin, ie how for does the button protrude
latch_mid_r = 2*latch_piv_r*sin(30/2); //how long is the latch in terms of radius from the pivot
latch_inner_r = latch_mid_r-5;
latch_outer_r = latch_mid_r+5;


//assembled
difference() {
    union() {
        *union() {
            sleeve_mandril();
            sleeve_wedge();
            sleeve_collar();
        }
        
        translate([0,0,25+5]) {
            *sleeve_base_ring_bottom();
            translate([0,0,bring_btm_hgt+lring_btm_hgt]) sleeve_base_ring_top();
            
            rotate([0,0,1*30]) {
                *translate([0,0,bring_btm_hgt+lring_btm_hgt]) sleeve_latch();
            
                *translate([0,0,bring_btm_hgt]) sleeve_locking_ring_bottom();
                
                translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v]) sleeve_locking_ring_top();
            }
        }
        
        translate([0,0,25+5+bring_btm_hgt+lring_btm_hgt+bring_top_hgt]) { 
            glove_mandril();
            *glove_collar();
        }
    }
    *rotate([0,0,sleeve_seam_a[0]]) cube([100,100,100]);
}


module sleeve_base_ring_bottom() {
    base_ring_bottom() {
        hgt1 = bring_btm_hgt-clr_v;
        hgt2 = bring_btm_hgt+lring_btm_hgt;

        for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,(ia%120==0?(passage_r+(limtab_r-passage_r)/2):(lug_inner_r-(1.5+0.15))),0]) {
            cylinder_neg_bev(1.5+0.15,hgt2,bev_xs,bev_xs);
            
            if (ia%120!=0) {
                translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,10]);
                
            translate([0,(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia+180]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
            }
        }
    }
}

module sleeve_base_ring_top() {
    base_ring_top() {
        for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,(ia%120==0?(passage_r+(limtab_r-passage_r)/2):(lug_inner_r-(1.5+0.15))),0]) {
            cylinder_bev(1.25,bring_top_hgt-0.6,0,0.25);
            cylinder_bev(1.25+bev_xs,0.01+bev_xs,0,bev_xs);
        }
    }
}

module sleeve_latch() {
    rotate([0,0,-30]) latch();
}

module sleeve_locking_ring_bottom() {
    locking_ring_bottom() {
        hgt1 = lring_btm_hgt-clr_v;
        hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;

        for(ia=[0,1,2,3,5]*60) rotate([0,0,ia]) translate([0,lug_outer_r+clr_h+(1.5+0.15),0]) {
            cylinder_neg_bev(1.5+0.15,hgt2,(3-(1.5+0.15)),0);
            translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
            translate([0,-(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
        }
    }
}

module sleeve_locking_ring_top() {
    locking_ring_top() {
        for(ia=[0,1,2,3,5]*60) rotate([0,0,ia]) translate([0,lug_outer_r+clr_h+(1.5+0.15),0]) {
            cylinder_bev(1.25,lring_top_hgt-0.6,0,0.25);
            cylinder_bev(1.25+bev_xs,0.01+bev_xs,0,bev_xs);
        }
    }
}



include <../Modular Locking Ring.scad>;



module sleeve_mandril() difference() {
    mand_hgt = 25;
    rib_hgt = /*mand_hgt/2*/ 10;
    
    mand_r0 = sleeve_r2-sleeve_fab_thk/2*cos(sleeve_a);
    
    rotate_extrude($fn=$fn*2) {
        difference() {
            polygon([
                [passage_r,bev_s+((mand_r0-bev_s-1.6-bev_s)-(passage_r))/tan(15)],
                [mand_r0-bev_s-1.6-bev_s,bev_s],
                [mand_r0-bev_s-1.6,0],
                
                [mand_r0-bev_s,0],
                [mand_r0-bev_s*tan(sleeve_a),bev_s],
                
                [mand_r0+mand_hgt*tan(sleeve_a),mand_hgt],
                [mand_r0+mand_hgt*tan(sleeve_a),mand_hgt+5],
                
                [passage_r+bev_xs,mand_hgt+5],
                [passage_r,mand_hgt+5-bev_xs],
            ]);
            
            translate([mand_r0+rib_hgt*tan(sleeve_a),rib_hgt]) rotate([0,0,-sleeve_a]) translate([0,0]) {
                step_h0 = 2.5;
                step_h1 = step_h0 + 1.5;
                step_l = 4;
                
                mirror([1,0]) {
                    translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2,2+sleeve_fab_thk);
                    translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2,2+sleeve_fab_thk);
                }
            }
        }
    }
        
    screw_z = mand_hgt+5 + (bring_btm_hgt+lring_btm_hgt) + (bring_top_hgt-0.6) - 18;
    
    translate([0,0,screw_z]) intersection() {
        translate([0,0,-10]) rotate_extrude($fn=$fn*2) round_step(passage_r,max((passage_r+(limtab_r-passage_r)/2),(lug_inner_r-(1.5+0.15))),10,1,5);
        
        hull() {
            translate([0,0,-25]) cylinder(r=max((passage_r+(limtab_r-passage_r)/2),(lug_inner_r-(1.5+0.15)))-bev_s,h=25,$fn=$fn*2);
            translate([0,0,-25]) cylinder(r=max((passage_r+(limtab_r-passage_r)/2),(lug_inner_r-(1.5+0.15))),h=25-bev_s,$fn=$fn*2);
        }
    }
            
    translate([0,0,screw_z]) intersection() {
        hull() for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,(ia%120==0?(passage_r+(limtab_r-passage_r)/2):(lug_inner_r-(1.5+0.15))),0]) {
            translate([0,-3,0]) {
                rotate([0,90,0]) rotate([0,0,90]) rotate_extrude(angle=-22.5) {
                    translate([3,0]) circle(r=3);
                    translate([0,-3]) square([3,2*3]);
                }
                rotate([-22.5,0,0]) translate([0,3,-50]) cylinder(r=3,h=50);
            }
        }
        
        union() {
            hull() for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,(ia%120==0?(passage_r+(limtab_r-passage_r)/2):(lug_inner_r-(1.5+0.15))),-25]) {
                cylinder(r=3-bev_s,h=25);
                cylinder(r=3,h=25-bev_s);
            }
            for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,(ia%120==0?(passage_r+(limtab_r-passage_r)/2):(lug_inner_r-(1.5+0.15))),-25]) {
                cylinder(r=3,h=25);
            }
        }
        
        //translate([0,0,-25]) cylinder(r=100,h=25);
    }
       
    for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,(ia%120==0?(passage_r+(limtab_r-passage_r)/2):(lug_inner_r-(1.5+0.15))),screw_z-0.01]) {
        hull() for(i=[0,-10]) rotate([i,0,0]) cylinder(r=1.5+0.15,h=18);
        cylinder(r1=3,r2=0,h=3);
    }
}

module sleeve_wedge() {
    mand_hgt = 25;
    rib_hgt = /*mand_hgt/2*/ 10;
    
    wedge_r0 = sleeve_r2+sleeve_fab_thk/2*cos(sleeve_a);
    
    wedge_cr = 0.75;
    
    
    seam_widh_a = (sleeve_seam_widh+5+4)/(2*(wedge_r0-rib_hgt*tan(sleeve_a))*3.14159)*360;
    seam_rib_ar = [0,sleeve_seam_a[0]+seam_widh_a,sleeve_seam_a[1]+seam_widh_a];
    seam_rib_ae = [sleeve_seam_a[0]-seam_widh_a,sleeve_seam_a[1]-sleeve_seam_a[0]-2*seam_widh_a,360-sleeve_seam_a[1]-seam_widh_a];
    
    intersection() {
        difference() {
            union() {
                rotate_extrude($fn=$fn*2) {
                    polygon([
                        [wedge_r0+bev_s*tan(sleeve_a),bev_s],
                        [wedge_r0+bev_s,0],
                        
                        [wedge_r0+2*mand_hgt*tan(sleeve_a)-bev_s,0],
                        [wedge_r0+2*mand_hgt*tan(sleeve_a)-bev_s*tan(sleeve_a),bev_s],
                        
                        [wedge_r0+mand_hgt*tan(sleeve_a)+wedge_cr*cos(sleeve_a),mand_hgt-wedge_cr/sin(sleeve_a)+wedge_cr*sin(sleeve_a)],
                        [wedge_r0+mand_hgt*tan(sleeve_a),mand_hgt-wedge_cr/sin(sleeve_a)],
                        [wedge_r0+mand_hgt*tan(sleeve_a)-wedge_cr*cos(sleeve_a),mand_hgt-wedge_cr/sin(sleeve_a)+wedge_cr*sin(sleeve_a)],
                    ]);
                    
                    translate([wedge_r0+mand_hgt*tan(sleeve_a),mand_hgt-wedge_cr/sin(sleeve_a)]) circle(r=wedge_cr);
                }
            
                for(i=[0,1,2]) rotate([0,0,seam_rib_ar[i]]) {
                    rotate_extrude(angle=seam_rib_ae[i],$fn=$fn*2) {
                        translate([wedge_r0+rib_hgt*tan(sleeve_a),rib_hgt]) rotate([0,0,-sleeve_a]) translate([0,0]) {
                            step_h0 = 1;
                            step_h1 = step_h0 + 1.5;
                            step_l = 4;
                            
                            mirror([1,0]) {
                                translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2+sleeve_fab_thk,2);
                                translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2+sleeve_fab_thk,2);
                            }
                        }
                    }
                }
                for(j=sleeve_seam_a) for(i=[j-seam_widh_a,j+seam_widh_a]) rotate([0,0,i]) {
                    translate([wedge_r0+rib_hgt*tan(sleeve_a),0,rib_hgt]) rotate([0,-90+sleeve_a,0]) {
                        step_h0 = 1;
                        step_h1 = step_h0 + 1.5;
                        step_l = 4;
                        
                        rotate_extrude() intersection() {
                            rotate([0,0,90]) translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2+sleeve_fab_thk,2);
                            translate([0,-step_h0]) square([step_l,step_h1]);
                        }
                    }
                }
            }
            
            for(ia=sleeve_seam_a) rotate([0,0,ia]) {
                for(j=[0:1/8:1-1/8]) hull() for(i=[j,j+1/8]) {
                    extra_wh = i*5;
                    extra_r = sleeve_fab_thk/2 * (1-(sin((i-0.5)*180)+1)/2);
                    
                    echo(extra_wh);
                    
                    intersection() {
                        translate([0,-(sleeve_seam_widh+extra_wh),0]) cube([100,2*(sleeve_seam_widh+extra_wh),100]);
                        
                        rotate_extrude($fn=$fn*2) polygon([
                            [0,0],
                            [wedge_r0+extra_r,0],
                            [wedge_r0+mand_hgt*tan(sleeve_a)+extra_r,mand_hgt],
                            [0,mand_hgt],
                        ]);
                    }
                }
            }
            
            rotate_extrude($fn=$fn*2) translate([wedge_r0+2*mand_hgt*tan(sleeve_a)-rib_hgt*tan(sleeve_a),rib_hgt]) rotate([0,0,sleeve_a]) {
                step_h0 = 1;
                step_h1 = step_h0 + 1.5;
                step_l = 4;
                
                mirror([1,0]) {
                    translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2,2+sleeve_fab_thk);
                    translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2,2+sleeve_fab_thk);
                }
            }
        }
        
        
        rotate([0,0,180]) union() {
            translate([-200+25,-100,-50]) cube([200,200,200]);
            for(iy=[0,1]) mirror([0,iy,0]) rotate([90,0,0]) {
                hull() for(iz=[-bev_s,50]) translate([0,0,1.5+bev_s+iz]) linear_extrude(height=50) {
                
                    translate([wedge_r0+mand_hgt*tan(sleeve_a),mand_hgt-wedge_cr/sin(sleeve_a)]) circle(r=max(0.01,wedge_cr+iz));
                    
                    translate([wedge_r0+bev_s*tan(sleeve_a)+bev_s*cos((90-sleeve_a)/2),bev_s*sin((90-sleeve_a)/2)]) circle(r=max(0.01,iz));
                    translate([wedge_r0+2*mand_hgt*tan(sleeve_a)-bev_s*cos((90-sleeve_a)/2),bev_s*sin((90-sleeve_a)/2)]) circle(r=max(0.01,iz));
                }
            }
        }
    }
}

module sleeve_collar() difference() {
    mand_hgt = 25;
    rib_hgt = /*mand_hgt/2*/ 10;
    col_r0 = sleeve_r2+sleeve_fab_thk/2*cos(sleeve_a)+2*mand_hgt*tan(sleeve_a)+sleeve_fab_thk*cos(sleeve_a);
    
    seam_widh_a = (sleeve_seam_widh+5+4)/(2*(col_r0-rib_hgt*tan(sleeve_a))*3.14159)*360;
    seam_rib_ar = [0,sleeve_seam_a[0]+seam_widh_a,sleeve_seam_a[1]+seam_widh_a];
    seam_rib_ae = [sleeve_seam_a[0]-seam_widh_a,sleeve_seam_a[1]-sleeve_seam_a[0]-2*seam_widh_a,360-sleeve_seam_a[1]-seam_widh_a];
    
    intersection() {
        union() {
            rotate_extrude($fn=$fn*2) {
                polygon([
                    [col_r0-bev_s*tan(sleeve_a),bev_s],
                    [col_r0+bev_s,0],
                    
                    [col_r0+3.75-bev_s,0],
                    [col_r0+3.75,bev_s],
                    
                    [col_r0+3.75,mand_hgt-bev_l],
                    [col_r0+3.75-bev_l,mand_hgt],
                    
                    [col_r0-mand_hgt*tan(sleeve_a)+bev_s,mand_hgt],
                    [col_r0-mand_hgt*tan(sleeve_a)+bev_s*tan(sleeve_a),mand_hgt-bev_s],
                ]);
            }
            for(i=[0,1,2]) rotate([0,0,seam_rib_ar[i]]) {
                rotate_extrude(angle=seam_rib_ae[i],$fn=$fn*2) {
                    translate([col_r0-rib_hgt*tan(sleeve_a),rib_hgt]) rotate([0,0,sleeve_a]) {
                        step_h0 = 1;
                        step_h1 = step_h0 + 1.5;
                        step_l = 4;
                        
                        mirror([1,0]) {
                            translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2+sleeve_fab_thk,2);
                            translate([-step_h0,step_l]) mirror([0,1]) round_step(step_h0,step_h1,step_l,2+sleeve_fab_thk,2);
                        }
                    }
                }
            }
            for(j=sleeve_seam_a) for(i=[j-seam_widh_a,j+seam_widh_a]) rotate([0,0,i]) {
                translate([col_r0-rib_hgt*tan(sleeve_a),0,rib_hgt]) rotate([0,-90-sleeve_a,0]) {
                    step_h0 = 1;
                    step_h1 = step_h0 + 1.5;
                    step_l = 4;
                    
                    rotate_extrude() intersection() {
                        rotate([0,0,90]) translate([-step_h0,-step_l]) round_step(step_h0,step_h1,step_l,2+sleeve_fab_thk,2);
                        translate([0,-step_h0]) square([step_l,step_h1]);
                    }
                }
            }
            
            difference() {
                r1 = col_r0;
                col_h = 25;
                
                col_thk = 3.75;
                col_thk2 = col_thk+3.75;
                
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
                
                    r1 = col_r0;
                    col_h = 25;
                    col_thk = 3.75;
                    col_thk2 = col_thk+3.75;
                
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
    
            
    for(ia=sleeve_seam_a) rotate([0,0,ia]) {
        for(j=[0:1/8:1-1/8]) hull() for(i=[j,j+1/8]) {
            extra_wh = i*5;
            extra_r = sleeve_fab_thk/2 * (1-(sin((i-0.5)*180)+1)/2);
            
            echo(extra_wh);
            
            intersection() {
                translate([0,-(sleeve_seam_widh+extra_wh),0]) cube([100,2*(sleeve_seam_widh+extra_wh),100]);
                
                rotate_extrude($fn=$fn*2) polygon([
                    [0,0],
                    [col_r0+extra_r,0],
                    [col_r0-mand_hgt*tan(sleeve_a)+extra_r,mand_hgt],
                    [0,mand_hgt],
                ]);
            }
        }
    }
    
    
    r1 = col_r0;
    col_h = 25;
    col_thk = 3.75;
    col_thk2 = col_thk+3.75;
                    
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
}

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