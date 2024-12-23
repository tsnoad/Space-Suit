module neck_spacer_shape(rad=120+5,co=false) {
    cylinder(r=rad,h=5+2+(co?0.01:0),$fn=$fn*2);
    
    translate([0,-40+75,0]) rotate([0,-90,0]) rotate([0,0,90]) rotate_extrude(angle=15+(co?0.01:0),$fn=$fn*2) intersection() {
        translate([0,-rad]) square([200,2*rad]);
        translate([40-75,0]) circle(r=rad);
    }
    
    translate([0,-40,0]) rotate([0,90,0]) rotate([0,0,-90]) {
        rotate_extrude(angle=15+(co?0.01:0),$fn=$fn*2) intersection() {
            translate([0,-rad]) square([200,2*rad]);
            translate([-40,0]) circle(r=rad);
        }
        *rotate([0,0,15]) translate([25,0,0]) rotate_extrude(angle=15+(co?0.01:0),$fn=$fn*2) intersection() {
            translate([0,-rad]) square([200,2*rad]);
            translate([-(40+25),0]) circle(r=rad);
        }
    }
    
    translate([0,-40-25*cos(15),-25*sin(15)]) rotate([15,0,0]) rotate([0,90,0]) rotate([0,0,-90]) rotate_extrude(angle=15+(co?0.01:0),$fn=$fn*2) intersection() {
        translate([0,-rad]) square([200,2*rad]);
        translate([(-40-25),0]) circle(r=rad);
    }
}

module trans1() {
     intersection() {
        translate([0,0,-200]) children();
            
        translate([0,-40+75,0]) rotate([-15,0,0]) {
            translate([0,-(-40+75),-200]) children();
        }
        
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,40,-200]) children();
        }
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                translate([0,40,-200]) children();
            }
        }
    }
}

module neck_space_mag_co(only_index=undef,rot_radial=false) {
    mag_is = (8+5)/2-0.75;
    mag_rad = (120-8+mag_is);
    mag_hgt = (120+5-mag_rad)*tan(25);
    
    //front two screws on forward slope section
    a_index = [0,1];
    a_ia = [15,45];
    translate([0,-40+75,0]) {
        for(i=[0,1]) if(only_index==undef || only_index==a_index[i]) if(a_ia[i]<acos((-40+75)/mag_rad)) translate([mag_rad*sin(a_ia[i]),0,0]) {
            rotate([-15+asin(mag_hgt/(mag_rad*cos(a_ia[i])+(40-75))),0,0]) translate([0,mag_rad*cos(a_ia[i])+(40-75),0]) {
                //neck_space_mag_screw_co(a_ia[i]);
                rotate([0,0,(rot_radial?-a_ia[i]:0)]) children();
            }
        }
    }
    
    //middle two screws on flat section
    b_index = [2,3];
    b_ia = [75,105];
    translate([0,0,0]) {
        for(i=[0,1]) if(only_index==undef || only_index==b_index[i]) translate([mag_rad*sin(b_ia[i]),0,0]) {
            translate([0,mag_rad*cos(b_ia[i]),mag_hgt]) {
                //neck_space_mag_screw_co(b_ia[i]);
                rotate([0,0,(rot_radial?-b_ia[i]:0)]) children();
            }
        }
    }
    
    //nothing on the first backward slope
    /*translate([0,-40,0]) {
        for(ia=[75]) translate([mag_rad*sin(ia),0,0]) {
            rotate([15-asin(mag_hgt/(mag_rad*cos(ia)+(-40)))*0,0,0]) translate([0,-(mag_rad*cos(ia)+(-40)),0]) {
                neck_space_mag_screw_co(ia);
            }
        }
    }*/
    
    //back two screws on backward slope section
    c_index = [4,5];
    c_ia = [135,165];
    translate([0,-40-25*cos(15),-25*sin(15)]) {
        for(i=[0,1]) if(only_index==undef || only_index==c_index[i]) translate([mag_rad*sin(c_ia[i]),0,0]) {
            rotate([15+15+asin(mag_hgt/(mag_rad*cos(c_ia[i])-(-40-25))),0,0]) translate([0,mag_rad*cos(c_ia[i])-(-40-25),0]) {
                //neck_space_mag_screw_co(c_ia[i]);
                rotate([0,0,(rot_radial?-c_ia[i]:0)]) children();
            }
        }
    }
}

module neck_space_mag_screw_co(ia=0) {
    translate([0,0,-50]) rotate([0,0,90]) hull() cylinder_oh(1.5+0.15,50+10);
    translate([0,0,-5-50]) rotate([0,0,90]) hull() cylinder_oh(3,50);
    
    *translate([0,0,5]) rotate([0,0,-ia]) hull() for(j=[0,-20]) translate([0,j,0]) {
        cylinder(r=0.01,h=5+3/cos(30));
        for(i=[0:5]) rotate([0,0,i*60]) translate([0,3/cos(30),0]) {
            cylinder(r=0.15,h=5);
        }
    }
}


module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}