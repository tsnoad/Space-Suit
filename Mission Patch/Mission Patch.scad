$fn = 144;

patch_w = 40; //total width of triangular patch

noz_d = 0.4;
wall_s = 2*noz_d;
wall_m = 2*2*noz_d;
wall_l = 3*2*noz_d;

wall_sh = wall_s/2;
wall_mh = wall_m/2;
wall_lh = wall_l/2;

lay_hgt = 0.4;

tri_r = (patch_w/2-2*wall_m)/cos(30);

cres_hgt = 11.296 / 40*patch_w;
plan_hgt = 9.878 / 40*patch_w;

planet_r = (cres_hgt - tri_r - tri_r*sin(30)) / (1 - 1/sin(30));
cres_a = acos((planet_r-cres_hgt+wall_sh)/planet_r);

*/* make 'Mission Patch A' */ color("#2635CD") for(ix=[-1,1]*(patch_w/2+1)) translate([ix,0,0]) linear_extrude(height=lay_hgt) {
    base_triangle();
}
*/* make 'Mission Patch B' */ color("#373838") for(ix=[-1,1]*(patch_w/2+1)) translate([ix,0,lay_hgt]) linear_extrude(height=lay_hgt) {
    border_triangle();
    stars();
    trail_inner();
    trail_outer();
    planet();
}
*/* make 'Mission Patch C' */ color("#C4402B") for(ix=[-1,1]*(patch_w/2+1)) translate([ix,0,2*lay_hgt]) linear_extrude(height=lay_hgt) {
    stars();
    trail_inner();
    trail_outer();
    planet_crescent();
}
!/* make 'Mission Patch D' */ color("#E1E4E7") for(ix=[-1,1]*(patch_w/2+1)) translate([ix,0,3*lay_hgt]) linear_extrude(height=lay_hgt) {
    stars();
    trail_inner();
    planet_crescent();
}

module planet() {
    hull() for(ia=[-1:1/($fn/2):1]) {
        translate([0,-tri_r*sin(30)-planet_r+cres_hgt]) {
            translate([sin(ia*cres_a),cos(ia*cres_a),0]*(planet_r-wall_sh)) circle(r=wall_sh);
        }
    }
}

module planet_crescent() {
    for(ia_out=[-1:1/($fn/2):1-1/($fn/2)]) hull() for(ia=[ia_out,ia_out+1/($fn/2)]) {
        //cres_thk_r = wall_sh + (wall_lh - wall_sh) * (1 - abs(ia));
        cres_thk_r = wall_sh + (max(wall_mh, round((cres_hgt-plan_hgt)/2/noz_d)*noz_d) - wall_sh) * (sin(ia*180+90)/2+0.5);
        
        iy = -tri_r*sin(30)-planet_r+cres_hgt + cos(ia*cres_a)*(planet_r-cres_thk_r);
        iy_in = 1 - (iy + (tri_r*sin(30)-wall_sh)) / ((tri_r*sin(30)-wall_sh) + 14.155 / 40*patch_w);
        ix = pow(iy_in,4) * 8.299/2 / 40*patch_w + wall_s;
        echo(ix);
        
        if(abs(sin(ia*cres_a)*(planet_r-cres_thk_r)) - cres_thk_r > ix) {
            translate([0,-tri_r*sin(30)-planet_r+cres_hgt]) {
                translate([sin(ia*cres_a),cos(ia*cres_a),0]*(planet_r-cres_thk_r)) circle(r=cres_thk_r);
            }
        }
    }
}

module trail_outer() {
    for(iy_out=[0:1/($fn/2):1-1/($fn/2)]) hull() for(iy_in=[iy_out,iy_out+1/($fn/2)]) {
        iy = (1 - iy_in) * ((tri_r*sin(30)-wall_sh) + 14.155 / 40*patch_w) - (tri_r*sin(30)-wall_sh);
        ix = pow(iy_in,4) * 8.299/2 / 40*patch_w + wall_s;
        
        translate([ix,iy]) circle(r=wall_sh);
        translate([-ix,iy]) circle(r=wall_sh);
    }
}

module trail_inner() {
    for(iy_out=[0:1/($fn/2):1-1/($fn/2)]) hull() for(iy_in=[iy_out,iy_out+1/($fn/2)]) {
        iy = (1 - iy_in) * ((tri_r*sin(30)-wall_sh) + 14.155 / 40*patch_w) - (tri_r*sin(30)-wall_sh);
        ix = pow(iy_in,4) * 3.470/2 / 40*patch_w;
        
        translate([ix,iy]) circle(r=wall_sh);
        translate([-ix,iy]) circle(r=wall_sh);
    }
}

module stars() {
    translate([0,14.155/40*patch_w]) star(5.792/2/40*patch_w);
    
    for(it=[
        [3.015,4.683],
        [-2.603,7.691],
    ]/40*patch_w) translate(it) star(2.446/2/40*patch_w);
    
    for(it=[
        [2.257,11.178],
        [4.432,10.225],
        [6.901,4.603],
        [5.826,2.745],
        [-1.874,11.569],
        [-8.156,4.188],
        [-6.322,3.283],
        [-8.865,1.303],
    ]/40*patch_w) translate(it) star(1.730/2/40*patch_w);
}

module star(arm_len=5,crn_r=wall_sh/*,arm_thk=0.2*/) {
    /*for(iy_out=[0:1/($fn/2):1-1/($fn/2)]) hull() for(iy_in=[iy_out,iy_out+1/($fn/2)]) {
        iy = (1 - iy_in) * arm_len;
        ix = pow(iy_in,2) * arm_thk * arm_len;
        
        translate([ix,iy]) circle(r=crn_r);
        translate([-ix,iy]) circle(r=crn_r);
        translate([ix,-iy]) circle(r=crn_r);
        translate([-ix,-iy]) circle(r=crn_r);
    }*/
    
    for(ia=[0,90]) rotate([0,0,ia]) hull() {
        translate([0,arm_len]) circle(r=crn_r);
        translate([0,-arm_len]) circle(r=crn_r);
        translate([arm_len*0.2,0]) circle(r=crn_r);
        translate([-arm_len*0.2,0]) circle(r=crn_r);
    }
}

module base_triangle() difference() {
    hull() for(ia=[0:120:360-120]) rotate([0,0,ia]) translate([0,tri_r]) circle(r=2*wall_m);
}

module border_triangle() difference() {
    hull() for(ia=[0:120:360-120]) rotate([0,0,ia]) translate([0,tri_r]) circle(r=2*wall_m);
    
    hull() for(ia=[0:120:360-120]) rotate([0,0,ia]) translate([0,tri_r]) circle(r=wall_m);
}

