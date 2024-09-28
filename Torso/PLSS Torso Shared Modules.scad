//origin is crest of shoulder
should_rad = 30;
should_ang = 25; //downward slope of shoulders to side

back_dep = 95;
back_hgt = 140;
back_hgt2 = back_hgt/cos(should_ang);
back_rad = (pow(back_dep,2) + pow(back_hgt2-should_rad,2) - pow(should_rad,2)) / (2 * (back_dep - should_rad));

clav_ang = 25;
clav_dep = 70;

strap_wid = 40; //width of shoulder straps
outset = 8; //thickness of shoulder straps
bev_s = 0.5; //bevel

module torso_plss_stud_plane(inc_rot=true) {
    translate([0,-(back_dep-5),0]) rotate([(inc_rot?1:0)*15,0,0]) children();
}

module torso_plss_port_plane(inc_rot=true,z_offset=0) {
    //crit_angle = 90 - (atan((back_hgt2-should_rad)/(back_rad-back_dep)) - asin(30/back_rad) + acos(back_rad/(back_rad+5))); //this is the angle of the flat section of the back (from the -y axis)
    
    //plane_angle = min(crit_angle, asin((back_hgt-60)/(back_rad+outset)));
    plane_angle = asin((back_hgt-strap_wid*sin(25)-60+z_offset)/(back_rad+outset+10));
    
    
    plane_y = (back_rad-back_dep) - (back_rad+outset+10)*cos(plane_angle);
    plane_z = -back_hgt + strap_wid*sin(25) + (back_rad+outset+10)*sin(plane_angle);
    
    translate([0,plane_y,plane_z]) {
        rotate([90-(inc_rot?1:0)*plane_angle,0,0]) children();
    }
}

module plss_torso_stud_location(inc_mirror=true) {
    for(ix=(inc_mirror?[-1,1]:[1])) translate([ix*75,0,-250]) children();
}
module plss_torso_portcrn_location(inc_rot=true) {
    translate([0,0,-60]) for(ix2=[-1,1]*(20+15)) translate([ix2,0,0]) {
        for(ix=[-15,15]) for(iz=[-15,15]) translate([ix,0,iz]) {
            rotate([0,(ix>0?90:0)*(inc_rot?1:0)*0,0]) children();
        }
    }
}
module plss_torso_port_location(inc_rot=true) {
    translate([0,0,-60]) for(ix2=[-1,1]*(20+15)) translate([ix2,0,0]) {
        rotate([0,(ix2>0?90:0)*(inc_rot?1:0)*0,0]) children();
    }
}


module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}