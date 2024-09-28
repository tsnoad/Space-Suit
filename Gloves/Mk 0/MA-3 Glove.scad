$fn = 36;


cuff_c1 = 2*140;
cuff_c2 = 2*127;
cuff_c12h = 50;

cuff_r1 = cuff_c1/3.14159/2;
cuff_r2 = cuff_c2/3.14159/2;
cuff_a = atan((cuff_r2-cuff_r1)/cuff_c12h);
echo(cuff_r1+3+2.4);

clamp_h = 30-10+2;
clamp_r2 = cuff_r1+clamp_h*tan(cuff_a);


passage_r = cuff_r1-4;

lug_inner_r = 50;
lug_outer_r = lug_inner_r + 5;
lug_hgt = 5;

lug_num = 6;
//lug_widh = 20;
lug_widh = 3.14159*2*((lug_outer_r-lug_inner_r)/2+lug_inner_r)/lug_num/4;


lring_top_hgt = 3; //thickness of top flange (with the lug cutouts) of the locking ring
lring_outer_r = lug_outer_r + 10; //outside radius of the locking ring
lring_btm_hgt = 3; //thickness of bottom flange of the locking ring

bring_top_hgt = 2;
bring_btm_hgt = 5; //thickness of the base
//bring_inner_r = ;
//bring_intrm_r = ;
bring_outer_r = lug_outer_r+2.5;

limtab_r = lug_inner_r + 4;
limtab_num = 3;
limtab_a_trav = 360/limtab_num/4;
limtab_a_offs = 360/limtab_num/4;
limtab_widh = 3.14159*2*limtab_r/limtab_num/8;
//limtab_widh = 7.5;

include <../Modular Locking Ring.scad>;

/*union() {
    suit_cuff_c1 = 2*172;
    suit_cuff_c2 = 2*139;
    suit_cuff_c12h = 103;

    suit_cuff_r1 = suit_cuff_c1/3.14159/2;
    suit_cuff_r2 = suit_cuff_c2/3.14159/2;
    suit_cuff_a = atan((suit_cuff_r2-suit_cuff_r1)/suit_cuff_c12h);
    
    cylinder(r1=suit_cuff_r1,r2=suit_cuff_r2,h=suit_cuff_c12h);
}*/

*translate([0,0,10]) difference() {
    hull() {
        cylinder(r=lug_inner_r-bev_l,h=clamp_h);
        translate([0,0,bev_l]) cylinder(r=lug_inner_r,h=clamp_h-2*bev_l);
    }
    
    translate([0,0,-0.01]) cylinder(r1=cuff_r1,r2=clamp_r2,h=clamp_h+2*0.01);
    translate([0,0,-0.01]) cylinder(r1=cuff_r1+bev_s,r2=cuff_r1+bev_s-5,h=5);
    translate([0,0,clamp_h-5+0.01]) cylinder(r1=clamp_r2+bev_s-5,r2=clamp_r2+bev_s,h=5);
    
    for(ia=[0:60:360-60]) rotate([0,0,ia]) translate([cuff_r1+1.5,0,0]) {
        translate([0,0,-0.01]) cylinder(r=1.75,h=50);
        
        translate([0,0,-0.01]) hull() {
            for(ix=[0,-20]) translate([ix,0,0]) cylinder(r=1.75,h=clamp_h-3-2);
        }
        
        translate([0,0,clamp_h-2]) hull() {
            for(ix=[-10,20]) translate([ix,0,0]) cylinder(r=3,h=50);
        }
        translate([0,0,clamp_h]) hull() {
            for(ix=[-10,20]) translate([ix,0,-bev_s+0.01]) cylinder(r1=3,r2=3+bev_s,h=bev_s);
        }
    }
}

*difference() {
    union() {
        hull() {
            cylinder(r=cuff_r1+bev_s,h=10);
            cylinder(r=cuff_r1,h=10+bev_s);
        }
        
        hull() {
            cylinder(r=cuff_r1,h=10);
            cylinder(r=clamp_r2-bev_s,h=10+clamp_h);
            cylinder(r=clamp_r2,h=10+clamp_h-bev_s);
        }
    
        hull() {
            translate([0,0,bev_l]) {
                cylinder(r=lug_inner_r,h=10-bev_l-bev_s,$fn=$fn*4);
                cylinder(r=lug_inner_r-bev_s,h=10-bev_l,$fn=$fn*4);
            }
            cylinder(r=lug_inner_r-bev_l,h=10-bev_s,$fn=$fn*4);
        }
        
        lug_ring();
    }
    
    hull() {
        translate([0,0,-0.01]) cylinder(r=cuff_r1-4,h=10);
        translate([0,0,10]) cylinder(r1=cuff_r1-4,r2=clamp_r2-4,h=clamp_h+0.01);
    }
    
    translate([0,0,-0.01]) cylinder(r1=cuff_r1-4+bev_s,r2=cuff_r1-4+bev_s-5,h=5);
    translate([0,0,10+clamp_h-5+0.01]) cylinder(r1=clamp_r2-4+bev_s-5,r2=clamp_r2-4+bev_s,h=5);
    
    for(ia=[0:60:360-60]) rotate([0,0,ia]) translate([cuff_r1+1.5,0,0]) {
        translate([0,0,-0.01]) cylinder(r=1.5,h=50);
        
        *translate([0,0,-0.01]) hull() {
            for(ix=[0,20]) translate([ix,0,0]) cylinder(r=1.5,h=50);
        }
        
        translate([0,0,-50+3]) { 
            hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),0]) {
                cylinder(r=0.2,h=50-2);
                cylinder(r=0.2+0.2,h=50-2-1);
            }
            hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),0]) cylinder(r=0.2,h=50);
            hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,2.75/cos(30),0.2]) cylinder(r=0.2,h=50); 
        }
    }
}

translate([0,0,-(bring_btm_hgt+lring_btm_hgt)-bring_top_hgt]) {
    base_ring_bottom() {
        hgt2 = bring_btm_hgt+lring_btm_hgt;
        
        for(i=[0:120:360-120]) rotate([0,0,i-limtab_a_offs]) {
            translate([0,passage_r+(limtab_r-passage_r)/2,hgt2]) {
                screw_co(1.5,lring_top_hgt,-5,-10);
            }
        }
    }
    !translate([0,0,bring_btm_hgt+lring_btm_hgt]) base_ring_top() {
        hgt1 = lring_top_hgt;
        
        for(i=[0:120:360-120]) rotate([0,0,i-limtab_a_offs]) {
            translate([0,passage_r+(limtab_r-passage_r)/2,0]) {
                screw_co(1.5,lring_top_hgt,-5,-10);
            }
        }
    }
    rotate([0,0,0]) {
        *translate([0,0,bring_btm_hgt]) locking_ring_bottom() {
            hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;
            
            for(i=[0:60:360-60]) rotate([0,0,i]) {
                translate([2*lring_outer_r*cos(15),0,0]) cylinder_neg_bev(lring_outer_r,hgt2,bev_l,bev_xs);
            }
            for(i=[0:120:360-120]) rotate([0,0,i]) {
                translate([0,lring_outer_r-(lring_outer_r-lug_outer_r)/2,hgt2]) {
                    screw_co(1.5,lring_top_hgt-clr_v,-5,-10);
                }
            }
        }
        *translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v]) locking_ring_top() {
            for(i=[0:60:360-60]) rotate([0,0,i]) {
                translate([2*lring_outer_r*cos(15),0,0]) cylinder_neg_bev(lring_outer_r,lring_top_hgt-clr_v,bev_xs,bev_l);
            }
            for(i=[0:120:360-120]) rotate([0,0,i]) {
                translate([0,lring_outer_r-(lring_outer_r-lug_outer_r)/2,0]) {
                    screw_co(1.5,lring_top_hgt-clr_v,-5,-10);
                }
            }
        }
    }
}
