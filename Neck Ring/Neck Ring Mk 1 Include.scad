/*
 * Spacesuit Neck Ring Interface Mk 1
 * Licenced under CC BY-NC-SA 4.0
 * By: TSnoad
 * https://github.com/tsnoad/TBC
 * https://hackaday.io/project/TBC
 */
 

//horizontal and vertical clearances
clr_h = 0.4;
clr_h_s = 0.2;
clr_v = 0.2;
 
//params for the modular locking ring

passage_r = 120-8; //width of the hole that our hand has to go through.

lug_inner_r = 120; //radius of the root of the lugs
lug_outer_r = lug_inner_r + 7.5; //outer radius of the lugs
lug_hgt = 5; //height of the lugs

lug_num = 8; //how many
//lug_widh = 20; //if we want to specify the half width in absolute term
lug_widh = 3.14159*2*((lug_outer_r-lug_inner_r)/2+lug_inner_r)/lug_num/4 - 2;

lring_top_hgt = 5; //thickness of top flange (with the lug cutouts) of the locking ring
//lring_outer_r = lug_outer_r + 5; //outside radius of the locking ring
lring_outer_r = lug_outer_r+clr_h+2*(1.5+0.15)+2.4;
//echo(lring_outer_r - (lug_outer_r + 5));
lring_btm_hgt = 5; //thickness of bottom flange of the locking ring

bring_top_hgt = 5;
bring_btm_hgt = 2.6; //thickness of the base
bring_outer_r = lug_inner_r + 5 + 5;

limtab_r = lug_inner_r + 5; //the outer radius of the lugs that limit rotation of the locking ring
limtab_num = 2; //number of limiting lugs
limtab_a_trav = 360/limtab_num/8; //how much travel is allowed - this is based on number of lugs, but the number used is smaller because of the way the model is put together
//limtab_a_offs = 360/limtab_num/3; //offset in case we need to put screws in a particular place
limtab_a_offs = 90;
//limtab_widh = 3.14159*2*limtab_r/limtab_num/8; //how wide is each tab
limtab_widh = 42.5; //or if we want to specify the tab width absolutely

//latch parameters
latch = true;
//latch_secondary_lock = true;
latch_prot_outer_r = lring_outer_r + 5; //outer radius of the locking ring protrusion that houses the latch
latch_piv_r = lug_outer_r+clr_h + (latch_prot_outer_r - (lug_outer_r+clr_h))/2; //where is the pivot point
latch_tab_r = lug_inner_r+clr_h + 2.4 + clr_h; //what is the radius of the tab/pawl of the latch. This is set so the wall thickness in the base ring top is 2.4mm thick (3 wall thicknesses)
latch_button_outer_r = latch_prot_outer_r + 5; //outer radius of the latch button from the origin, ie how for does the button protrude


//if you want the length of the latch to be based on lug_num
//latch_mid_a = 360/lug_num/2;
//latch_mid_r = sqrt(2*pow(latch_piv_r,2)-2*pow(latch_piv_r,2)*cos(latch_mid_a)); //how long is the latch in terms of radius from the pivot
//if you want the length of the latch to be fixed
latch_mid_r = 30; //how long is the latch in terms of radius from the pivot
latch_mid_a = acos((2*pow(latch_piv_r,2)-pow(latch_mid_r,2))/(2*pow(latch_piv_r,2)));

latch_inner_r = latch_mid_r-5;
latch_outer_r = latch_mid_r+5;

//set the position of the latch in terms of rotation around the axis. can also be used to mirror or have multiple latches
//the pivot of the latch is at x=latch_piv_r, and this function is used to apply rotation
//if latch_mid_r isn't based on a multiple of lug_num, additional rotation may also need to be applied here
module latch_pos() {
    //rotate so we're in the unlocked state by default
    rotate([0,0,-limtab_a_trav]) {
        for(ixm=[0,1]) mirror([ixm,0,0]) rotate([0,0,90-45]) mirror([0,1,0]) rotate([0,0,-latch_mid_a]) children();
    }
}

//params for o-ring/gasket material
//using 3mm diameter EPDM sponge gasket
oring = true;
oring_rad = 1.5;
oring_area = 3.14159*pow(oring_rad,2) * 0.9; //cross sectional area - pre-compress the gasket to 90%

oring_fol_wid = 1.6; //width of the follower - 4 wall thicknesses
oring_gland_wid = oring_fol_wid + 2*0.2; //width of the gland/recess that the o-ring will be stuffed into
oring_gland_dep = oring_area/oring_gland_wid; //how deep does the gland/recess have to be
oring_fol_hgt = oring_area/oring_gland_wid*0.25; //the o-ring is compressed with a protrusion/follower. The amount of compression should be 25% to get a good seal, so we need to work out the height of the follower, based on that

//sets the position of the gasket and follower
//oring_gland_rad = lug_inner_r-2.4-oring_gland_wid/2; //as close as possible to the outer wall - used for glove interface
oring_gland_rad = passage_r+1.6+oring_gland_wid/2; //as close as possible to the inner wall - used for neck ring

include <../Modular Locking Ring.scad>;

module base_ring_screw_pos(alt=false,alt2=false) {
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        if(!alt && !alt2) for(ia=[
            22.5-6.125,
            22.5+6.125,
            
            45+22.5-6.125,
            //45+22.5+6.125,
            
            //90+22.5-6.125,
            90+22.5+6.125,
            
            135+22.5-6.125,
            135+22.5+6.125,
        ]) rotate([0,0,ia]) translate([0,lug_inner_r-(1.5+0.15),0]) children();
        
        if(alt && !alt2) for(ia=[
            //45+22.5+6.125,
            //90+22.5-6.125,
            
            90,
        ]) rotate([0,0,ia]) translate([0,lug_inner_r-(1.5+0.15),0]) children();
        
        if(alt2) for(ia=[
            45+22.5+3.75,
            90+22.5-3.75,
        ]) rotate([0,0,ia]) translate([0,lug_inner_r-(1.5+0.15),0]) children();
    }
}

