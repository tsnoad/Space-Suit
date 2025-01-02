
include <Helmet Mk 1 Include.scad>;

$fn = 144;

comms_hgt = 10;

/* Modify this based on the speaker element you're using */
spk_r = 35.7/2; //radius of speaker
spk_h = 4.5; //height of speaker
spk_clr = 0.25; //clearance

rotate([0,180,0]) comms_housing_inner();
!comms_housing_outer();

difference() {
    translate([0,0,50]) comms_housing_inner();
    //translate([0,0,-1]) cube([100,100,100]);
}
difference() {
    color("orange") comms_housing_outer();
    //translate([0,0,-1]) cube([100,100,100]);
}

speaker();

module comms_housing_inner(co=false,screw_co=false) {
    inn_hgt = 1.6;
    
    if(co || (!co && !screw_co)) difference() {
        union() {
            translate([0,0,comms_hgt-inn_hgt]) hull() {
                cylinder(r=(35+7.5-3.75)+(co?0.2:0),h=(co?20:inn_hgt),$fn=$fn*2);
                mic_jack_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,-3.75-1.8/2,0]) {
                    cylinder(r=3.75+(co?0.2:0),h=(co?20:inn_hgt));
                }
                cable_clamp_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,0,0]) {
                    cylinder(r=3.75+(co?0.2:0),h=(co?20:inn_hgt));
                }
            }
            
            translate([0,0,0.4+spk_h]) cylinder(r=spk_r+(co?0.2:0),h=(co?20:comms_hgt-(0.4+spk_h)),$fn=$fn*2);
            
            if(co) translate([0,0,0.4+spk_h]) cylinder(r=30+(co?0.2:0),h=(co?20:comms_hgt-(0.4+spk_h)),$fn=$fn*2);
            
            translate([0,0,0.4+spk_h-1]) cylinder(r=spk_r+2.4+(co?0.2:0),h=(co?20:comms_hgt-(0.4+spk_h)),$fn=$fn*2);
            
            translate([0,0,comms_hgt-4]){
                hull() mic_jack_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,-3.75-1.8/2,0]) {
                    cylinder(r=3.75+(co?0.2:0),h=(co?20:4));
                }
                hull() cable_clamp_loc() for(ix=[-1,1]*(10/2+2.5)) for(iy=[0,(co?10:3.75)]) translate([ix,iy,0]) {
                    cylinder(r=3.75+(co?0.2:0),h=(co?20:4));
                }
            }
        }
        if(!co && !screw_co) {
            comms_housing_inner(false,true);
            
            translate([0,0,comms_hgt/2]) mirror([0,0,1]) mic_jack(true);
            translate([0,0,comms_hgt/2]) mirror([0,0,1]) cable_clamp(true);
            
            //cutouts for screws to mount to helmet
            comms_helmet_screw_co();
            
            speaker(true);
        }
    }
    
    if(screw_co) translate([0,0,comms_hgt-4]) {
        mic_jack_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,-3.75-1.8/2,0]) {
            translate([0,0,-8+4]) hull() {
                cylinder(r=1.25-0.5,h=20);
                translate([0,0,0.5]) cylinder(r=1.25,h=20);
            }
            translate([0,0,0]) hull() {
                cylinder(r=(1.5-0.15),h=20);
                translate([0,0,-(1.5-0.15)]) cylinder(r=0.01,h=20);
            }
            translate([0,0,4]) hull() {
                cylinder(r=3,h=20);
                translate([0,0,-3]) cylinder(r=0.01,h=20);
            }
        }
        cable_clamp_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,0,0]) {
            translate([0,0,-8+4]) hull() {
                cylinder(r=1.25-0.5,h=20);
                translate([0,0,0.5]) cylinder(r=1.25,h=20);
            }
            translate([0,0,0]) hull() {
                cylinder(r=(1.5-0.15),h=20);
                translate([0,0,-(1.5-0.15)]) cylinder(r=0.01,h=20);
            }
            translate([0,0,4]) hull() {
                cylinder(r=3,h=20);
                translate([0,0,-3]) cylinder(r=0.01,h=20);
            }
        }
    }
}

module comms_housing_outer() difference() {
    union() {
        hull() {
            //body
            cylinder(r=35+7.5-2,h=comms_hgt,$fn=$fn*2);
            translate([0,0,2]) cylinder(r=35+7.5,h=comms_hgt-2,$fn=$fn*2);
            
            mic_jack_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,0,-0.01]) {
                cylinder(r=7.5-2,h=comms_hgt);
                translate([0,0,2]) cylinder(r=7.5,h=comms_hgt-2);
            }
            cable_clamp_loc() for(ix=[-1,1]*(10/2+2.5)) translate([ix,0,-0.01]) {
                cylinder(r=7.5-2,h=comms_hgt);
                translate([0,0,2]) cylinder(r=7.5,h=comms_hgt-2);
            }
        }
        
    }
    
    //speaker cutout
    translate([0,0,0.01]) speaker(true);
    
    //cutout recess for inner plate
    comms_housing_inner(true,true);
    
    
    //cutout to mount 3.5mm jack for microphone
    translate([0,0,comms_hgt/2]) mic_jack(true);
    translate([0,0,comms_hgt/2]) cable_clamp(true);

    //cutouts for screws to mount to helmet
    comms_helmet_screw_co();
}

module comms_helmet_screw_co() {
    translate([0,0,comms_hgt]) for(ia=[0:90:360-90]) rotate([0,0,ia+45]) translate([0,35,0]) mirror([0,0,1]) {
        translate([0,0,-8+3]) hull() {
            cylinder(r=1.25-0.5,h=20);
            translate([0,0,0.5]) cylinder(r=1.25,h=20);
        }
        translate([0,0,0]) hull() {
            cylinder(r=(1.5-0.15),h=20);
            translate([0,0,-(1.5-0.15)]) cylinder(r=0.01,h=20);
        }
        translate([0,0,3]) hull() {
            cylinder(r=3,h=20);
            translate([0,0,-3]) cylinder(r=0.01,h=20);
        }
        translate([0,0,comms_hgt-0.4+0.01]) {
            cylinder(r1=3,r2=3+0.4,h=0.4);
        }
    }
}

module speaker(co=false) {
    %if(!co) {
        translate([0,0,0.4]) cylinder(r=spk_r,h=spk_h);
    }
    
    if(co) {
        translate([0,0,0.4]) {
            cylinder(r=spk_r+spk_clr,h=spk_h);
            cylinder(r=spk_r+spk_clr-2.4,h=comms_hgt-0.4-2);
            
            rotate([0,0,-90]) intersection() {
                hull() for(ix=[0,20]) translate([ix,0,spk_h-1]) cylinder(r=10,h=20);
                cylinder(r=spk_r+spk_clr+2.4+0.01,h=comms_hgt-0.4-2);
            }
        }
    
        //speaker holes
        hole_r = 2;
        translate([0,0,-1]) cylinder(r=hole_r,h=2);
        for(ia=[0:60:360-60]) rotate([0,0,ia]) {
            translate([2*hole_r+2.4,0,-1]) cylinder(r=hole_r,h=2);
            translate([4*hole_r+2*2.4,0,-1]) cylinder(r=hole_r,h=2);
            translate([3*hole_r+1.5*2.4,(2*hole_r+2.4)*cos(30),-1]) cylinder(r=hole_r,h=2);
        }
    }
}

module mic_jack_loc() {
    rotate([0,0,15]) translate([0,50,0]) children();
}

module mic_jack(co=false) {
    r_1 = 10/2+0.1; //radius of flange
    r_2 = 8.8/2-0.25; //radius of threaded section
    
    //cutout to mount 3.5mm jack for microphone
    if(co) mic_jack_loc() {
        hull() for(ix=[-1,1]*r_1*sin(45)) for(iy=[-1,1]*1.8/2) translate([ix,iy,-comms_hgt/2-0.01]) cylinder(r=0.1,h=50);
        hull() for(iz=[0,50]) translate([0,1.8/2+0.1,iz]) rotate([90,0,0]) cylinder(r=r_1,h=1.8+2*0.1);
        
        #hull() for(ix=[-1,1]*7.9/2) for(iy=[1.8/2+0.1,50]) translate([ix,iy,-comms_hgt/2-0.01]) cylinder(r=0.2,h=50);
        
        hull() for(iz=[0,50]) translate([0,0,iz]) rotate([90,0,0]) {
            cylinder(r=r_2-0.4,h=26);
            cylinder(r=r_2,h=26-0.4);
        }
    }
}
module cable_clamp_loc() {
    rotate([0,0,180-15]) translate([0,39,0]) children();
}

module cable_clamp(co=false) {
    cable_r = 4/2;
    
    if(co) cable_clamp_loc() {
        hull() for(iz=[0,50]) translate([0,-3.75+0.2,iz]) {
            rotate([90,0,0]) cylinder(r=cable_r,h=12);
            translate([0,-0.4]) rotate([90,0,0]) cylinder(r=cable_r+0.4,h=12-2*0.4);
        }
        hull() for(iz=[0,50]) translate([0,-3.75,iz]) {
            rotate([-90,0,0]) cylinder(r=cable_r,h=20);
        }
        hull() for(iz=[0,50]) translate([0,7.5-0.8,iz]) {
            rotate([-90,0,0]) cylinder(r=cable_r,h=12);
            translate([0,0.8]) rotate([-90,0,0]) cylinder(r=cable_r+0.8,h=12);
        }
    }
}

module cylinder_oh_opt(radius,height,oh=false,rotate=0) hull() {
    cylinder(r=radius,h=height);
        
    if(oh) rotate([0,0,rotate]) {
        translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
    }
}

module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}