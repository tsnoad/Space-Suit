/*
 * Spacesuit Glove Interface Mk 2
 * Licenced under CC BY-NC-SA 4.0
 * By: TSnoad
 * https://github.com/tsnoad/TBC
 * https://hackaday.io/project/TBC
 */

$fn = 36;



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
clr_h_s = 0.2;
clr_v = 0.2;

passage_r = 120-8; //width of the hole that our hand has to go through.

lug_inner_r = 120; //radius of the root of the lugs
lug_outer_r = lug_inner_r + 7.5; //outer radius of the lugs
lug_hgt = 5; //height of the lugs

lug_num = 9; //how many
//lug_widh = 20; //if we want to specify the half width in absolute term
lug_widh = 3.14159*2*((lug_outer_r-lug_inner_r)/2+lug_inner_r)/lug_num/4 - 2;

lring_top_hgt = 5; //thickness of top flange (with the lug cutouts) of the locking ring
//lring_outer_r = lug_outer_r + 5; //outside radius of the locking ring
lring_outer_r = lug_outer_r+clr_h+2*(1.5+0.15)+2.4;
//echo(lring_outer_r - (lug_outer_r + 5));
lring_btm_hgt = 5; //thickness of bottom flange of the locking ring

bring_top_hgt = 5;
bring_btm_hgt = 2; //thickness of the base
bring_outer_r = lug_outer_r + 5;

limtab_r = lug_inner_r + 2.5; //the outer radius of the lugs that limit rotation of the locking ring
limtab_num = 4; //number of limiting lugs
limtab_a_trav = 360/limtab_num/4; //how much travel is allowed - this is based on number of lugs, but the number used is smaller because of the way the model is put together
limtab_a_offs = 360/limtab_num/4; //offset in case we need to put screws in a particular place
limtab_widh = 3.14159*2*limtab_r/limtab_num/8; //how wide is each tab
//limtab_widh = 7.5; //or if we want to specify the tab width absolutely

//latch parameters
latch = false;
latch_prot_outer_r = lring_outer_r + 5; //outer radius of the locking ring protrusion that houses the latch
latch_piv_r = lug_outer_r+clr_h + (latch_prot_outer_r - (lug_outer_r+clr_h))/2; //where is the pivot point
latch_tab_r = lug_inner_r+clr_h + 2.4 + clr_h; //what is the radius of the tab/pawl of the latch. This is set so the wall thickness in the base ring top is 2.4mm thick (3 wall thicknesses)
latch_button_outer_r = latch_prot_outer_r + 5; //outer radius of the latch button from the origin, ie how for does the button protrude
latch_mid_r = 2*latch_piv_r*sin(30/2); //how long is the latch in terms of radius from the pivot
latch_inner_r = latch_mid_r-5;
latch_outer_r = latch_mid_r+5;

include <../Modular Locking Ring.scad>;


base_ring_bottom() {
    hgt1 = bring_btm_hgt-clr_v;
    hgt2 = bring_btm_hgt+lring_btm_hgt;
    
    base_ring_screw_pos() {
        cylinder_neg_bev(1.5+0.15,hgt2,bev_xs,bev_xs);
    }
    base_ring_screw_pos(true,false) {
        translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,10]);
            
        translate([0,(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia+180]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
    }
}



*translate([0,0,bring_btm_hgt+lring_btm_hgt]) base_ring_top() {
    base_ring_screw_pos() {
        cylinder_bev(1.25,bring_top_hgt-0.6,0,0.25);
        cylinder_bev(1.25+bev_xs,0.01+bev_xs,0,bev_xs);
    }
}

translate([0,0,bring_btm_hgt]) locking_ring_bottom() {
    hgt1 = lring_btm_hgt-clr_v;
    hgt2 = lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v;

    for(ia=[1:lug_num]) rotate([0,0,(ia+0)*360/lug_num]) translate([0,lug_outer_r+clr_h+(1.5+0.15),0]) {
        cylinder_neg_bev(1.5+0.15,hgt2,(3-(1.5+0.15)),0);
        translate([0,0,hgt1]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
        translate([0,-(1.5+0.15),hgt1]) for(ia=[-1,1]*45) rotate([0,0,ia]) cylinder_neg_bev(1.5+0.15,hgt2-hgt1,0,bev_xs,[0,-10]);
    }
}

!translate([0,0,bring_btm_hgt+lring_btm_hgt+bring_top_hgt+lug_hgt+clr_v]) intersection() {
    locking_ring_top() {
        for(ia=[1:lug_num]) rotate([0,0,(ia+0)*360/lug_num]) translate([0,lug_outer_r+clr_h+(1.5+0.15),0]) {
            cylinder_bev(1.25,lring_top_hgt-0.6,0,0.25);
            cylinder_bev(1.25+bev_xs,0.01+bev_xs,0,bev_xs);
        }
    }
    rotate([0,0,15]) union() {
        rotate([0,0,-30]) translate([0,0,-50]) cube([200,200,100]);
        rotate([0,0,0]) translate([0,0,-50]) cube([200,200,100]);
    }
}

*difference() {
    union() {
        cylinder_bev(lug_inner_r,10,bev_s,0,$fn=$fn*2);
        lug_ring();
    }
    cylinder_neg_bev(passage_r,10,bev_s,bev_s,$fn=$fn*2);
}


module base_ring_screw_pos(even=true,odd=true) {
    for(ia=[0:60:360-60]) rotate([0,0,ia-30]) translate([0,lug_inner_r-(1.5+0.15),0]) children();
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