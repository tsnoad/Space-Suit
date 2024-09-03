
use <PLSS.scad>;

$fn = 72;

//translate([-15,-20,-780]) {
*intersection() {
    translate([0,55-15,27.5-5]) {
        rotate([0,-2.5,0]) translate([0,50,-550]) rotate([0,0,-12.5]) scale(1000) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_13_20_19.stl", convexity=10);
    }
    
    *translate([-120,-250,0]) rotate([0,-25,0]) translate([0,0,-400]) cube([40,500,500]);
}

*union() {
    translate([0,0,outset+5]) rotate([-(180+15),0,0]) {
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 A.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 B.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 C.stl");
    }
    for(im=[0,1]) mirror([im,0,0]) rotate([0,-(90+25),0]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 D.stl");
    rotate([-(15+15),0,0]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 E.stl");
    rotate([--15,0,0]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 F.stl");
    
    
    rotate([-(180+asin(75/back_rad)),0,0]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 G.stl");
    rotate([--15,0,0]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 H.stl");
    rotate([-(-90-15),0,0]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 3 I.stl");
}

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
outset = 7.5; //thickness of shoulder straps
bev_s = 0.5; //bevel

//assembly
*neck_spacer([0,120,240]);
*neck_spacer([0]);

shoulder_yoke();
*mirror([1,0,0]) shoulder_yoke();
*neck_spacer_front();
*neck_spacer_back();

back_upper2();
*back_upper();
*back_mid();
*back_lower();
*chest_plate();


//shape of torso
*union() {
    for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
        translate([0,0,0]) linear_extrude(height=(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(0); 
    }
    
    for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
        *translate([should_rad,0,0]) rotate([0,0,-clav_ang]) hull() {
            cylinder(r=should_rad,h=strap_wid);
            translate([0,clav_dep,0]) cylinder(r=should_rad,h=strap_wid);
        }
        //translate([should_rad,0,0]) sphere(r=30);
        *hull() translate([should_rad,0,-100]) {
            sphere(r=30);
            translate([0,0,100+strap_wid]) sphere(r=30);
            translate([100*tan(25),0,100]) sphere(r=30+100*tan(25));
        }
    }
    
    translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
        rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(0); 
        translate([0,-250]) square([500,500]);
    }
    
    outset = 0;
    
    
    acromion_x = 150;
    acromion_y = 0;
    acromion_z = -should_rad*cos(25)-(-120+should_rad*sin(25))*tan(25)-acromion_x*tan(25);
    medial_x = 75;
    medial_y = 85;
    medial_z = -should_rad-45;
    
    
    hull() for(ix=[0,1]) mirror([ix,0,0]) {
        translate([medial_x,0,-should_rad*cos(25)-(-120+should_rad*sin(25)+medial_x)*tan(25)]) sphere(r=should_rad+outset);
        translate([medial_x,acromion_x*tan(5),-should_rad*cos(25)-(-120+should_rad*sin(25)+medial_x)*tan(25)]) sphere(r=should_rad+outset);
        
        translate([acromion_x,acromion_y,acromion_z]) sphere(r=should_rad+outset);
        
        translate([medial_x,medial_y,medial_z]) sphere(r=should_rad+outset);
        
        translate([medial_x+0,medial_y+25,medial_z-50]) sphere(r=should_rad+outset);
    }
}

//printable
*rotate([180+15,0,0]) neck_spacer([0]);
*rotate([180+15,0,0]) neck_spacer([120]);
*rotate([180+15,0,0]) neck_spacer([240]);

*rotate([0,90+25,0]) shoulder_yoke();
*rotate([15+15,0,0]) neck_spacer_front();
*rotate([-15,0,0]) neck_spacer_back();

!rotate([asin(75/back_rad),0,0]) back_upper2();
*rotate([180+asin(75/back_rad),0,0]) back_upper();
*rotate([-15,0,0]) back_mid();
*rotate([-90-15,0,0]) back_lower();
*rotate([90,0,0]) chest_plate();

*for(im=[0,1]) mirror([0,im,0]) {
    translate([0,10,0]) web_mount(40,[-0.5,-1/6,1/6,0.5]);
    translate([50,10,0]) web_mount(strap_wid-2*7.5,[-0.5,0,0.5]);
}

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

module torso_plss_port_pos() {
    intersection() {
        hull() for(ia=[0:7.5:45]) {
            intersection() {
                plss_torso_portcrn_location(false) rotate([90,0,0]) cylinder(r=7.5+5*sin(ia)+(ia==45?50:0),h=200);
                torso_plss_port_plane() translate([0,0,-100-(5-5*cos(ia)+(ia==45?50:0))]) cylinder(r=150,h=100);
            }
        }
        
        intersection_for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,-200,strap_wid-20]) cube([200,200,200]);
        }
    }
}

module torso_plss_port_neg() {
    plss_torso_portcrn_location(false) {
        rotate([90,0,0]) hull() cylinder_oh(3+0.2,200);
    }
    
    for(ix=[-1,1]*(20+15)) for(iz=[-1,1]*15) translate([ix,0,0]) {
        torso_plss_port_plane(false,iz) translate([0,0,-100-5]) hull() {
            cylinder_oh(3+0.2,100);
            cylinder_oh(6+0.2,100-3);
        }
    }
    
    for(ix=[-1,1]*(20+15)) for(iz=[-1,1]*15-[1,1]*60) hull() {
        intersection() {
            translate([ix,0,iz]) rotate([90,0,0]) cylinder_oh(3+0.2,200);
            torso_plss_port_plane() translate([0,0,-0.5]) cylinder(r=150,h=100);
        }
        intersection() {
            translate([ix,0,iz]) rotate([90,0,0]) cylinder_oh(3+0.2+0.5,200);
            torso_plss_port_plane() translate([0,0,0]) cylinder(r=150,h=100);
        }
    }
    
    plss_torso_port_location(false) {
        rotate([90,0,0]) hull() cylinder_oh(12.5,200);
    }
    
    for(ix=[-20,20]) for(iz=[-60]) hull() {
        intersection() {
            translate([ix,0,iz]) rotate([90,0,0]) cylinder_oh(12.5,200);
            torso_plss_port_plane() translate([0,0,-0.5]) cylinder(r=150,h=100);
        }
        intersection() {
            translate([ix,0,iz]) rotate([90,0,0]) cylinder_oh(12.5+0.5,200);
            torso_plss_port_plane() translate([0,0,0]) cylinder(r=150,h=100);
        }
    }
    
    hull() for(ib=[0,outset/2]) intersection() {
        hull() plss_torso_portcrn_location(false) {
            rotate([90,0,0]) hull() cylinder_oh(12.5+(outset/2-ib),200);
        }
        
        union() {
            translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
                rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(ib); 
                translate([0,-250]) square([500,500]);
            }
                
            for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                translate([0,0,strap_wid-20-100]) linear_extrude(height=-(strap_wid-20-100-0.01)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(ib);
            }
        }
    }
}


module back_upper() intersection() {
    difference() {
        union() {
            difference() {
                union() {
                    torso_plss_port_pos();
                    
                    translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
                        rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(outset); 
                        translate([0,-250]) square([500,500]);
                    }
                    
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                        translate([0,0,strap_wid-20]) linear_extrude(height=-(strap_wid-20)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(outset); 
                    }
                }
                for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                    translate([back_hgt2,(back_rad-back_dep),0]) rotate([0,0,-(25/(back_rad*2*3.14159))*360]) translate([0,-(back_rad+50),0]) {
                        cube([250,back_rad+50,strap_wid]);
                        translate([0,0,strap_wid]) rotate([0,25,0]) cube([250,250,40]);
                    }
                }
            }
            difference() {
                union() {
                    translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
                        rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(outset/2); 
                        translate([0,-250]) square([500,500]);
                    }
                    
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                        translate([0,0,strap_wid-20]) linear_extrude(height=-(strap_wid-20)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(outset/2-0.01); 
                    }
                }
                for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                    translate([back_hgt2,(back_rad-back_dep),0]) rotate([0,0,-(25/(back_rad*2*3.14159))*360*0]) translate([0,-(back_rad+50),0]) {
                        cube([250,back_rad+50,strap_wid]);
                        translate([0,0,strap_wid]) rotate([0,25,0]) cube([250,250,40]);
                    }
                }
            }
        }
        
        translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
            rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(0); 
            translate([0,-250]) square([500,500]);
        }
            
        for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,0,strap_wid-20-100]) linear_extrude(height=-(strap_wid-20-100-0.01)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(0);
        }
        
        for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,0,strap_wid-20-100]) linear_extrude(height=strap_wid-20+100) back_upper_cs(outset/2); 
        }
    
        torso_plss_port_neg();
        
        for(ix=[0,1]) mirror([ix,0,0])translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([back_hgt2,(back_rad-back_dep),strap_wid-10]) {
                for(iz=[50,87.5]) rotate([0,0,-asin(iz/back_rad)]) rotate([90,0,0]) rotate([0,0,90-25]) {
                    hull() cylinder_oh(1.75,200);
                    translate([0,0,back_rad+outset]) hull() {
                        cylinder_oh(3,200);
                        translate([0,0,-3]) cylinder_oh(0.01,200);
                    }
                }
            }
        }
    }
    
    translate([0,-((back_rad-back_dep)+outset)+250,-back_hgt]) translate([-250,-(250+50),0]) cube([500,250+50,250]);
    
    /*translate([0,-((back_rad-back_dep)+outset)+250,-back_hgt]) rotate([-asin(75/back_rad),0,0]) hull() {
        translate([-140/2,-(250+50),-250]) cube([140,250+50,250]);
        translate([-140/2-50,-(250+50),-250]) cube([140+2*50,250+50,250-50]);
    }*/
    
    translate([0,-((back_rad-back_dep)+outset)+250,-back_hgt]) rotate([-asin(75/back_rad),0,0]) hull() {
        translate([-140/2-50,-(250+50),-250]) cube([140+2*50,250+50,250]);
    }
    
    translate([-250,-500,-250]) cube([500,500,500]);
}

module back_upper2() intersection() {
    difference() {
        union() {
            difference() {
                union() {
                    torso_plss_port_pos();
                    
                    translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
                        rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(outset); 
                        translate([0,-250]) square([500,500]);
                    }
                    
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                        translate([0,0,strap_wid-20]) linear_extrude(height=-(strap_wid-20)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(outset); 
                    }
                }
                for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                    translate([back_hgt2,(back_rad-back_dep),0]) rotate([0,0,-(25/(back_rad*2*3.14159))*360]) translate([0,-(back_rad+50),0]) {
                        cube([250,back_rad+50,strap_wid]);
                        translate([0,0,strap_wid]) rotate([0,25,0]) cube([250,250,40]);
                    }
                }
            }
            *difference() {
                union() {
                    translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
                        rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(outset/2); 
                        translate([0,-250]) square([500,500]);
                    }
                    
                    for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                        translate([0,0,strap_wid-20]) linear_extrude(height=-(strap_wid-20)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(outset/2-0.01); 
                    }
                }
                for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
                    translate([back_hgt2,(back_rad-back_dep),0]) rotate([0,0,-(25/(back_rad*2*3.14159))*360*0]) translate([0,-(back_rad+50),0]) {
                        cube([250,back_rad+50,strap_wid]);
                        translate([0,0,strap_wid]) rotate([0,25,0]) cube([250,250,40]);
                    }
                }
            }
            
            intersection() {
                translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                    trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
                }
                translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                    trans1() cylinder(r1=120+5+200*tan(15),r2=120+5-50*tan(15),h=200+50,$fn=$fn*2);
                }
                *translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                    trans1() cylinder(r=200,h=200+(8+5-1)*tan(25),$fn=$fn*2);
                }
                
                for(i=[0,1]) mirror([i,0,0]) {
                    translate([-120,0,0]) rotate([0,-25,0]) translate([20,-250,-250]) cube([100,500,500]);
                }
            }
            
            //tube hump
            difference() {
                translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([0,90,0]) {
                    translate([-back_hgt2,(back_rad-back_dep)+outset]) {
                        translate([back_hgt2,(back_rad-back_dep)]) hull() {
                            rotate([0,0,180-(-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad))]) rotate_extrude(angle=90+(-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)),$fn=$fn*4) hull() for(iy=[-1,1]) {
                                $fn=$fn/4;
                                translate([back_rad+outset+5-5,iy*15]) {
                                    circle(r=5);
                                    translate([-50,iy*50]) circle(r=5);
                                }
                            }
                            
                            rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50)]) rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) rotate_extrude($fn=$fn*2) hull() for(iy=[-1,1]) {
                                $fn=$fn/2;
                                translate([50+5+outset+5-5,iy*15]) {
                                    circle(r=5);
                                    translate([-25,iy*25]) circle(r=5);
                                }
                            }
                        }
                    
                    }
                }
                //translate([0,-250]) square([500,500]);
            }
        }
        
        torso_plss_port_neg();
        
        //tube channel
        translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([0,90,0]) {
            translate([-back_hgt2,(back_rad-back_dep)+outset]) {
                translate([back_hgt2,(back_rad-back_dep)]) hull() {
                    rotate([0,0,180-(-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad))]) rotate_extrude(angle=90+(-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)),$fn=$fn*4) hull() for(iy=[-1,1]) {
                        $fn=$fn/4;
                        translate([back_rad+outset*0+5-5,iy*15]) {
                            circle(r=5);
                            translate([-50,iy*50]) circle(r=5);
                        }
                    }
                    
                    rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50)]) rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) rotate_extrude($fn=$fn*2) hull() for(iy=[-1,1]) {
                        $fn=$fn/2;
                        translate([50+5+outset*0+5-5,iy*15]) {
                            circle(r=5);
                            translate([-25,iy*25]) circle(r=5);
                        }
                    }
                }
            
            }
            //translate([0,-250]) square([500,500]);
        }
        
        translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) neck_space_mag_co();
        
        translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
            trans1() cylinder(r=120-8,h=200+0.01,$fn=$fn*2);
        }
        translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) {
            neck_spacer_shape(120-8,true);
        }
        
        
        translate([0,-((back_rad-back_dep)+outset),-back_hgt+(120-back_hgt2*sin(25))*tan(25)]) rotate([90,0,0]) rotate([0,0,90-25]) rotate_extrude(angle=2*25) intersection() {
            rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(0); 
            translate([0,-250]) square([500,500]);
        }
            
        for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,0,strap_wid-20-100]) linear_extrude(height=-(strap_wid-20-100-0.01)+(120-back_hgt2*sin(25))/cos(25)) back_upper_cs(0);
        }
        
        for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,0,strap_wid-20-100]) linear_extrude(height=strap_wid-20+100) back_upper_cs(outset/2); 
        }
        
        *#for(ix=[0,1]) mirror([ix,0,0])translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([back_hgt2,(back_rad-back_dep),strap_wid-10]) {
                for(iz=[50,87.5]) rotate([0,0,-asin(iz/back_rad)]) rotate([90,0,0]) rotate([0,0,90-25]) {
                    hull() cylinder_oh(1.75,200);
                    translate([0,0,back_rad+outset]) hull() {
                        cylinder_oh(3,200);
                        translate([0,0,-3]) cylinder_oh(0.01,200);
                    }
                }
            }
        }
        
        
    
        for(ix=[0,1]) mirror([ix,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([back_hgt2,(back_rad-back_dep),0]) {
                rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),strap_wid-20/2]) rotate([0,0,asin(15/(50+5+outset))]) {
                    rotate([90,0,0]) {
                        hull() cylinder_oh(1.25,50+5+outset/2);
                        translate([0,0,50+5+outset/2-0.01]) cylinder(r=1.75,h=50);
                        translate([0,0,50+5+outset]) hull() {
                            cylinder(r=3,h=50);
                            translate([0,0,-3]) cylinder(r=0.01,h=50);
                        }
                    }
                }
            }
        }
    }
    
    translate([0,-((back_rad-back_dep)+outset)+250,-back_hgt]) rotate([-asin(110/back_rad),0,0]) hull() {
        translate([-140/2-50,-(250+50),-250]) cube([140+2*50,250+50,250]);
    }
    
    translate([0,-((back_rad-back_dep)+outset)+250,-back_hgt]) rotate([-asin(75/back_rad),0,0]) hull() {
        translate([-140/2-50,-(250+50),0]) cube([140+2*50,250+50,250]);
    }
    
    translate([-250,-500,-250]) cube([500,500,500]);
}

//cross section of back profile
module back_upper_cs(outset=0) hull() {
    //outset = 0;
    translate([30,0]) circle(r=30+outset);
    
    translate([back_hgt2,(back_rad-back_dep)]) {
        intersection() {
            circle(r=back_rad+outset,$fn=$fn*4);
            translate([-(back_hgt2+outset-10),-(back_rad-back_dep)-500]) square([back_hgt2+outset-10,500]);
        }
    
        rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50)]) rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) {
            circle(r=50+5+outset,$fn=$fn*4);
        }
    }
}

module neck_spacer_front() translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) difference() {
    intersection() {
        translate([0,-40+75,0]) rotate([-15,0,0]) {
            translate([0,-(-40+75),-10]) {
                cylinder(r=120+5,h=10+50,$fn=$fn*2);
            }
        }
        
        hull() {
            trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
        }
        for(i=[0,1]) mirror([i,0,0]) translate([0,-40,0]) rotate([--15,0,0]) translate([0,0,-outset]) {
            translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-250]) cube([strap_wid+100,500,500]);
        }
        
        translate([0,-40+75,0]) rotate([-15,0,0]) {
            translate([0,-(-40+75),-10]) {
                rotate([0,0,90-90/2-25/(2*(120+5-(8+5)/2)*3.14159)*360]) rotate_extrude(angle=90+2*25/(2*(120+5-(8+5)/2)*3.14159)*360,$fn=$fn*2) translate([120-8,0]) square([200,100]);
            }
        }
    }
    
    neck_space_mag_co();
    
    translate([0,-40+75,0]) rotate([-15,0,0]) {
        translate([0,-(-40+75),-10]) for(ix=[0,1]) mirror([ix,0,0]) {
            for(iy=[0.25,0.75]*25) rotate([0,0,90-90/2+iy/(2*(120+5-(8+5)/2)*3.14159)*360]) translate([0,120+5-(5+8)/2,0]) rotate([0,0,-(-90/2+iy/(2*(120+5-(8+5)/2)*3.14159)*360)]) {
                translate([0,0,-10]) hull() cylinder_oh(1.25,100);
                translate([0,0,0]) cylinder(r=1.75,h=100);
                translate([0,0,3.75]) hull() {
                    cylinder(r=3,h=100);
                    translate([0,0,-3]) cylinder(r=0.01,h=100);
                }
            }
        }
    }
}

module neck_spacer_back() translate([0,0,outset+5]) rotate([-15,0,0]) translate([0,40,0]) difference() {
    intersection() {
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,40,-200-5]) hull() {
                //cylinder(r=120+5,h=10,$fn=$fn*2);
                
                cylinder(r=120+5-0.5,h=200+5,$fn=$fn*2);
                cylinder(r=120+5,h=200+5-0.5,$fn=$fn*2);
                //cylinder(r=120+5+5*tan(15),h=10-0.5-5,$fn=$fn*2);
            }
        }
        
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                translate([0,40,-5]) hull() {
                    //cylinder(r=120+5,h=10,$fn=$fn*2);
                    
                    cylinder(r=120+5-0.5,h=5,$fn=$fn*2);
                    cylinder(r=120+5,h=5-0.5,$fn=$fn*2);
                    //cylinder(r=120+5+5*tan(15),h=10-0.5-5,$fn=$fn*2);
                }
            }
        }
        
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                translate([0,40,-5]) {
                    rotate([0,0,-90-90/2-25/(2*(120+5-(8+5)/2)*3.14159)*360]) rotate_extrude(angle=90+2*25/(2*(120+5-(8+5)/2)*3.14159)*360,$fn=$fn*2) translate([120-8,0]) hull() {
                        translate([2.5,0]) square([200,100]);
                        translate([0,2.5]) square([200,100]);
                    }
                }
            }
        }
    }
    
    neck_space_mag_co();
    
    translate([0,-40,0]) rotate([15,0,0]) {
        translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
            translate([0,40,-5]) for(ix=[0,1]) mirror([ix,0,0]) {
                for(iy=[0.25,0.75]*25) rotate([0,0,-90-90/2+iy/(2*(120+5-(8+5)/2)*3.14159)*360]) translate([0,120+5-(5+8)/2,0]) rotate([0,0,-(-90/2+iy/(2*(120+5-(8+5)/2)*3.14159)*360)]) {
                    translate([0,0,-10]) hull() cylinder_oh(1.25,100);
                    translate([0,0,0]) cylinder(r=1.75,h=100);
                    translate([0,0,3.75]) hull() {
                        cylinder(r=3,h=100);
                        translate([0,0,-3]) cylinder(r=0.01,h=100);
                    }
                }
            }
        }
    }
}





module neck_spacer_shape(rad=120+5,co=false) {
    cylinder(r=rad,h=5+2,$fn=$fn*2);
    
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

module neck_spacer(segments = [120]) translate([0,0,outset]) rotate([-15,0,0]) difference() {
    translate([0,40,0]) union() {
        intersection() {
            neck_spacer_shape(120+5);
            translate([0,0,-100]) for(ia=segments) rotate([0,0,ia+-90+10/(2*(120+5)*3.14159)*360]) rotate_extrude(angle=120-20/(2*(120+5)*3.14159)*360) square([200,150]);
        }
        intersection() {
            neck_spacer_shape(120-8+3.75);
            translate([0,0,-100]) for(ia=segments) rotate([0,0,ia+-90+10/(2*(120+5)*3.14159)*360]) rotate_extrude(angle=120) square([200,150]);
        }
        difference() {
            intersection() {
                neck_spacer_shape(120+5);
                translate([0,0,-100]) for(ia=segments) rotate([0,0,ia+-90-10/(2*(120+5)*3.14159)*360]) rotate_extrude(angle=120) square([200,150]);
            }
            neck_spacer_shape(120-8+3.75,true);
        }
    }
    
    translate([0,40,0]) hull() {
        trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
    }
                
    translate([0,40,0]) neck_spacer_shape(120-8,true);
    
    
    //add_z = (120-pow(120,2)/sqrt(pow(120,2)+pow(40,2)))*tan(25+5);
    //translate([0,0,-30+outset/cos(25+5)+add_z]) {
    //flange_shape() flange_cone();
    
    
    translate([0,40,0]) {
        //top magnets
        translate([0,0,5+2]) {
            for(ia=[0,45,135,225,315]) rotate([0,0,ia]) {
                translate([0,120-8+(5+8)/2,0]) {
                    translate([0,0,-3]) hull() {
                        cylinder(r=4+0.1,h=6);
                        translate([0,0,-4-0.1]) cylinder(r=0.01,h=6);
                    }
                    hull() {
                        translate([0,0,-0.25]) cylinder(r=4+0.1,h=2*0.25);
                        translate([0,0,0]) cylinder(r=4+0.1+0.25,h=0.01);
                    }
                }
            }
        }
        
        //side screws
        translate([0,-40+75,5+2-3]) rotate([0,0,0]) translate([0,-(-40+75),0]) {
           for(ia=[-60,60]) rotate([0,0,180+ia]) {
                rotate([90,0,0]) {
                    hull() {
                        cylinder_oh(1.25,120-8+8-0.5);
                        cylinder_oh(1.25-0.5,120-8+8);
                    }
                    hull() cylinder_oh(1.75,120-8+3.75+0.01);
                    hull() {
                        cylinder_oh(3,120-8);
                        cylinder_oh(0.01,120-8+3);
                    }
                }
            }
        }
        
        //back screws
        translate([0,-40,0]) {
            rotate([15*1/4*0,0,0]) translate([0,40,0]) {
                rotate([90,0,0]) {
                    hull() {
                        cylinder_oh(1.25,120-8+8-0.5);
                        cylinder_oh(1.25-0.5,120-8+8);
                    }
                    hull() cylinder_oh(1.75,120-8+3.75+0.01);
                    hull() {
                        cylinder_oh(3,120-8);
                        cylinder_oh(0.01,120-8+3);
                    }
                }
            }
            
            rotate([15,0,0]) translate([0,-25,0]) rotate([15*0,0,0]) translate([0,25,0]) translate([0,40,0]) {
                rotate([90,0,0]) {
                    hull() {
                        cylinder_oh(1.25,120-8+8-0.5);
                        cylinder_oh(1.25-0.5,120-8+8);
                    }
                    hull() cylinder_oh(1.75,120-8+3.75+0.01);
                    hull() {
                        cylinder_oh(3,120-8);
                        cylinder_oh(0.01,120-8+3);
                    }
                }
            }
        }
    }
        
        
    translate([0,40,0]) {
        neck_space_mag_co();
    }
}

module neck_space_mag_co() {
    mag_is = (8+5)/2-0.75;
    mag_rad = (120-8+mag_is);
    mag_hgt = (120+5-mag_rad)*tan(25);
    
    
    /*rotate([neck_angle,0,0]) {
        translate([0,-head_maj_rad,-50/2]) {
            rotate([0,0,22.5]) {
                rotate([90,0,0]) {
                    rotate([0,0,-atan(sin(22.5)/tan(90-neckring_angle))]) {
                    }
                }
            }
        }
    }*/
    
    translate([0,-40+75,0]) {
        for(ia=[-30,-10,10,30]) translate([mag_rad*sin(ia),0,0]) {
            *rotate([0,-90,0]) cylinder(r=mag_rad*cos(ia)+(40-75),h=0.1);
            
            rotate([-15+asin(mag_hgt/(mag_rad*cos(ia)+(40-75))),0,0]) translate([0,mag_rad*cos(ia)+(40-75),0]) {
                translate([0,0,-50]) cylinder(r=1.75,h=50+10);
                translate([0,0,-6-50]) {
                    cylinder(r=3,h=50);
                    translate([-1.75,-1.75,0]) cube([2*1.75,2*1.75,50+0.4]);
                    translate([-sqrt(pow(3,2)-pow(1.75,2)),-1.75,0]) cube([2*sqrt(pow(3,2)-pow(1.75,2)),2*1.75,50+0.2]);
                }
                translate([0,0,5]) rotate([0,0,-ia]) hull() for(j=[0,-20]) translate([0,j,0]) {
                    cylinder(r=0.01,h=5+2.75/cos(30));
                    for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),0]) {
                        cylinder(r=0.2,h=5);
                    }
                }
                
                rotate([0,0,-ia+atan(sin(-15)/tan(90-ia))]) rotate([-25,0,0]) {
                    translate([0,0,-3]) cylinder(r=4+0.05,h=6);
                    hull() {
                        translate([0,0,-0.5]) cylinder(r=4+0.05,h=2*0.5);
                        translate([0,0,-0.25]) cylinder(r=4+0.05+0.25,h=2*0.25);
                    }
                }
            }
        }
    }
    
    translate([0,-40,0]) {
        for(ia=[-1,1]*(90-asin((40+25*cos(25)/2)/mag_rad))) translate([mag_rad*sin(ia),0,0]) {
            *rotate([0,-90,0]) cylinder(r=mag_rad*cos(ia)+(-40),h=0.1);
            
            rotate([15-asin(mag_hgt/(mag_rad*cos(ia)+(-40))),0,0]) translate([0,-(mag_rad*cos(ia)+(-40)),0]) {
                rotate([0,0,ia-atan(sin(15)/tan(90-ia))]) rotate([25,0,0]) {
                    translate([0,0,-3]) cylinder(r=4+0.05,h=6);
                    hull() {
                        translate([0,0,-0.5]) cylinder(r=4+0.05,h=2*0.5);
                        translate([0,0,-0.25]) cylinder(r=4+0.05+0.25,h=2*0.25);
                    }
                }
            }
        }
    }
    
    translate([0,-40-25*cos(15),-25*sin(15)]) {
        for(ia=[-20,20]) translate([mag_rad*sin(ia),0,0]) {
            *rotate([0,-90,0]) cylinder(r=mag_rad*cos(ia)+(-40-25),h=0.1);
            
            rotate([15+15-asin(mag_hgt/(mag_rad*cos(ia)+(-40-25))),0,0]) translate([0,-(mag_rad*cos(ia)+(-40-25)),0]) {
            
                translate([0,0,-50]) cylinder(r=1.75,h=50+10);
                translate([0,0,-5-50]) cylinder(r=3,h=50);
                translate([0,0,5]) rotate([0,0,ia]) hull() for(j=[0,20]) translate([0,j,0]) {
                    cylinder(r=0.01,h=5+2.75/cos(30));
                    for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),0]) {
                        cylinder(r=0.2,h=5);
                    }
                }
            
                rotate([0,0,ia-atan(sin(15+15)/tan(90-ia))]) rotate([25,0,0]) {
                    translate([0,0,-3]) cylinder(r=4+0.05,h=6);
                    hull() {
                        translate([0,0,-0.5]) cylinder(r=4+0.05,h=2*0.5);
                        translate([0,0,-0.25]) cylinder(r=4+0.05+0.25,h=2*0.25);
                    }
                }
            }
        }
    }
    
    /*#translate([0,-40+75,0]) rotate([-15,0,0]) translate([0,-(-40+75),0]) {
       for(ia=[-30,-10,10,30]) rotate([0,0,ia]) {
            translate([0,120-8+(5+8)/2,0]) {
                translate([0,0,-3]) cylinder(r=4+0.05,h=6);
                hull() {
                    translate([0,0,-0.25]) cylinder(r=4+0.05,h=2*0.25);
                    translate([0,0,0]) cylinder(r=4+0.05+0.25,h=0.01);
                }
            }
        }
    }
    
    *#translate([0,-40,0]) rotate([15,0,0]) {
        translate([0,40,0]) {
            for(ia=[-1,1]*(90-asin((40+25/2)/(120+8-(8+5)/2)))) rotate([0,0,180+ia]) {
                translate([0,120-8+(5+8)/2,0]) {
                    translate([0,0,-3]) cylinder(r=4+0.05,h=6);
                    hull() {
                        translate([0,0,-0.25]) cylinder(r=4+0.05,h=2*0.25);
                        translate([0,0,0]) cylinder(r=4+0.05+0.25,h=0.01);
                    }
                }
            }
        }
        translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) translate([0,40,0]) {
            for(ia=[-20,20]) rotate([0,0,180+ia]) {
                translate([0,120-8+(5+8)/2,0]) {
                    translate([0,0,-3]) cylinder(r=4+0.05,h=6);
                    hull() {
                        translate([0,0,-0.25]) cylinder(r=4+0.05,h=2*0.25);
                        translate([0,0,0]) cylinder(r=4+0.05+0.25,h=0.01);
                    }
                }
            }
        }
    }*/
}

module chest_plate() translate([0,190,-220]) rotate([-90,0,0]) difference() {
    hull() for(ix2=[0,1]) mirror([ix2,0,0]) {
        rotate([0,0,-25]) for(ix=[-0.5,0.5]*25) translate([ix,-80,0]) {
            cylinder(r=7.5-bev_s,h=outset);
            translate([0,0,bev_s]) cylinder(r=7.5,h=outset-2*bev_s);
        }
        rotate([0,0,90+15]) for(ix=[-0.5,0.5]*25) translate([ix,-75,0]) {
            cylinder(r=7.5-bev_s,h=outset);
            translate([0,0,bev_s]) cylinder(r=7.5,h=outset-2*bev_s);
        }
    }
    
    hull() for(ix2=[0,1]) mirror([ix2,0,0]) {
        rotate([0,0,-25]) for(ix=[-0.5,0.5]*25) translate([ix,-80+15,-0.01]) {
            cylinder(r=5,h=outset+2*0.01);
        }
        rotate([0,0,90+15]) for(ix=([-0.5,0.5]*25)) translate([ix-(ix<0?0:7.5),-75+15,-0.01]) {
            cylinder(r=5,h=outset+2*0.01);
        }
    }
    hull() for(ix2=[0,1]) mirror([ix2,0,0]) {
        rotate([0,0,-25]) for(ix=[-0.5,0.5]*25) translate([ix,-80+15,-0.01]) {
            cylinder(r1=5+bev_s,r2=5,h=bev_s);
        }
        rotate([0,0,90+15]) for(ix=([-0.5,0.5]*25)) translate([ix-(ix<0?0:7.5),-75+15,-0.01]) {
            cylinder(r1=5+bev_s,r2=5,h=bev_s);
        }
    }
    hull() for(ix2=[0,1]) mirror([ix2,0,0]) {
        rotate([0,0,-25]) for(ix=[-0.5,0.5]*25) translate([ix,-80+15,-0.01]) {
            translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=5,r2=5+bev_s,h=bev_s);
        }
        rotate([0,0,90+15]) for(ix=([-0.5,0.5]*25)) translate([ix-(ix<0?0:7.5),-75+15,-0.01]) {
            translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=5,r2=5+bev_s,h=bev_s);
        }
    }
    
    for(ix2=[0,1]) mirror([ix2,0,0]) {
        rotate([0,0,-25]) {
            hull() for(ix=[-0.5,0.5]*25) translate([ix,-80,-0.01]) {
                cylinder(r=2.5,h=outset+2*0.01);
            }
            hull() for(ix=[-0.5,0.5]*25) translate([ix,-80,-0.01]) {
                cylinder(r1=2.5+bev_s,r2=2.5,h=bev_s);
            }
            hull() for(ix=[-0.5,0.5]*25) translate([ix,-80,-0.01]) {
                translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=2.5,r2=2.5+bev_s,h=bev_s);
            }
        }
        rotate([0,0,90+15]) {
            hull() for(ix=[-0.5,0.5]*25) translate([ix,-75,-0.01]) {
                cylinder(r=2.5,h=outset+2*0.01);
            }
            hull() for(ix=[-0.5,0.5]*25) translate([ix,-75,-0.01]) {
                cylinder(r1=2.5+bev_s,r2=2.5,h=bev_s);
            }
            hull() for(ix=[-0.5,0.5]*25) translate([ix,-75,-0.01]) {
                translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=2.5,r2=2.5+bev_s,h=bev_s);
            }
        }
    }
}

    

module web_mount(hole_dist,hole_spacing) difference() {  
    //hole_dist = strap_wid-2*7.5;
    //hole_spacing = [-0.5,0,0.5];
    //hole_dist = 40;
    //hole_spacing = [-0.5,-1/6,1/6,0.5];
    
    hull() {
        for(ix=[-0.5,0.5]*hole_dist) translate([ix,20,0]) {
            cylinder(r=7.5-bev_s,h=5);
            translate([0,0,bev_s]) cylinder(r=7.5,h=5-2*bev_s);
        }
        for(ix=[-12.5,12.5]) translate([ix,0,0]) {
            cylinder(r=7.5-bev_s,h=5);
            translate([0,0,bev_s]) cylinder(r=7.5,h=5-2*bev_s);
        }
    }
    
    for(ix=hole_spacing*hole_dist) translate([ix,20,-0.01]) cylinder(r=2.5,h=5+2*0.01);
    for(ix=hole_spacing*hole_dist) translate([ix,20,-0.01]) cylinder(r1=2.5+bev_s,r2=2.5,h=bev_s);
    for(ix=hole_spacing*hole_dist) translate([ix,20,5-bev_s+0.01]) cylinder(r1=2.5,r2=2.5+bev_s,h=bev_s);
        
    for(iy=[0,10]) translate([0,iy,0]) {
        hull() for(ix=[-0.5,0.5]*25) translate([ix,0,-0.01]) cylinder(r=2.5,h=5+2*0.01);
        hull() for(ix=[-0.5,0.5]*25) translate([ix,0,-0.01]) cylinder(r1=2.5+bev_s,r2=2.5,h=bev_s);
        hull() for(ix=[-0.5,0.5]*25) translate([ix,0,5-bev_s+0.01]) cylinder(r1=2.5,r2=2.5+bev_s,h=bev_s);
    }
}

module back_lower() difference() {
    seg_top = -25-12.5;
    seg_bot = -100-12.5;
    union() {
        translate([0,(back_rad-back_dep),-back_hgt]) rotate([15,0,0]) translate([0,-back_rad,0]) rotate([90,0,0]) {
            hull() for(ix=[-1,1]) for(iz=[-25,-5]) translate([ix*((120-back_hgt*tan(25))-5-10),iz,0]) {
                cylinder(r=5,h=outset/2);
            }
            intersection() {
                hull() for(ix=[-1,1]) {
                    translate([ix*((120-back_hgt*tan(25))-7.5),-25,0]) {
                        cylinder(r=7.5-bev_s,h=outset);
                        translate([0,0,bev_s]) cylinder(r=7.5,h=outset-2*bev_s);
                    }
                }
                translate([-250,-500-25,0]) cube([500,500,500]);
            }
            hull() for(ix=[-1,1]) {
                translate([ix*(100-7.5),seg_top-7.5,0]) {
                    cylinder(r=7.5-bev_s,h=outset);
                    translate([0,0,bev_s]) cylinder(r=7.5,h=outset-2*bev_s);
                }
                translate([ix*(100-7.5),seg_bot+7.5+40*cos(15),0]) {
                    cylinder(r=7.5-bev_s,h=outset);
                    translate([0,0,bev_s]) cylinder(r=7.5,h=outset-2*bev_s);
                }
                translate([ix*(100-7.5-40*sin(15)),seg_bot+7.5,0]) {
                    cylinder(r=7.5-bev_s,h=outset);
                    translate([0,0,bev_s]) cylinder(r=7.5,h=outset-2*bev_s);
                }
            }
            
            for(ix=[0,1]) mirror([ix,0,0]) translate([0,seg_top-5,0]) hull() {
                cube([(120-back_hgt*tan(25))+5+7.5,5+7.5,outset]);
                cube([(120-back_hgt*tan(25))+7.5,5+5+7.5,outset]);
            }
        }
        //backpack studs
        intersection() {
            plss_torso_stud_location() {
                /*rotate([90,0,0]) {
                    hull() rotate_extrude() {
                        translate([7.5+50,0]) circle(r=2.5);
                        translate([0,back_dep-5]) {
                            translate([7.5,-2.5]) circle(r=2.5);
                            translate([7.5+50,-2.5-50]) circle(r=2.5);
                        }
                    }
                }*/
            
                hull() for(ia=[0:7.5:45]) {
                    difference() {
                        rotate([90,0,0]) cylinder(r=10+5*sin(ia)+(ia==45?50:0),h=100+100);
                        torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200+(5-5*cos(ia)+(ia==45?50:0)),200]);
                    }
                }
            }
            
            
            translate([0,(back_rad-back_dep),-back_hgt]) rotate([15,0,0]) translate([0,-back_rad,0]) rotate([90,0,0]) {
                hull() for(ix=[-1,1]) {
                    translate([ix*(100-7.5),seg_top-7.5,0]) {
                        cylinder(r=7.5-bev_s,h=50);
                        translate([0,0,bev_s]) cylinder(r=7.5,h=50);
                    }
                    translate([ix*(100-7.5),seg_bot+7.5+40*cos(15),0]) {
                        cylinder(r=7.5-bev_s,h=50);
                        translate([0,0,bev_s]) cylinder(r=7.5,h=50);
                    }
                    translate([ix*(100-7.5-40*sin(15)),seg_bot+7.5,0]) {
                        cylinder(r=7.5-bev_s,h=50);
                        translate([0,0,bev_s]) cylinder(r=7.5,h=50);
                    }
                }
                *translate([-250,-500-25,0]) cube([500,500,500]);
            }
        }
    }
    
    
    //backpack stud bolt cutouts
    plss_torso_stud_location() {
        rotate([90,0,0]) cylinder(r=3+0.2,h=100+100);
        
        torso_plss_stud_plane(false) translate([0,100+5,0]) hull() {
            rotate([90,0,0]) cylinder(r=3+0.2,h=100);
            translate([0,6-3,0]) rotate([90,0,0]) cylinder(r=6+0.2,h=100);
        }
        
        hull() for(ib=[0,0.5]) difference() {
            rotate([90,0,0]) cylinder(r=3+0.2+ib,h=200);
            torso_plss_stud_plane() translate([-100,(0.5-ib),-100]) cube([200,200,200]);
        }
        
        hull() for(ib=[0,0.5]) difference() {
            rotate([90,0,0]) cylinder(r=6+0.2+ib,h=200);
            torso_plss_stud_plane() translate([-100,-200+10+7.5-(0.5-ib),-100]) cube([200,200,200]);
        }
    }
    
    /*for(ix=[-75,75]) translate([ix,0,-250]) rotate([90,0,0]) hull() {
        cylinder(r=3,h=200);
    }*/
    
    translate([0,(back_rad-back_dep),-back_hgt]) rotate([15,0,0]) {
        translate([0,-back_rad,0]) rotate([90,0,0]) {
            //corner fillets
            for(ix=[0,1]) mirror([ix,0,0]) translate([(120-back_hgt*tan(25))+7.5,seg_top+7.5,-0.01]) {
                hull() for(it=[[5,0,0],[0,5,0]]) {
                    translate(it) cylinder(r=7.5,h=outset+2*0.01);
                }
                hull() for(it=[[5,0,0],[0,5,0]]) {
                    translate(it) cylinder(r1=7.5+bev_s,r2=7.5,h=bev_s);
                }
                hull() for(it=[[5,0,0],[0,5,0]]) {
                    translate(it) translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=7.5,r2=7.5+bev_s,h=bev_s);
                }
            }
            
            //cord clearance co
            for(ix=[-1,1]) translate([ix*(100-7.5-40*sin(15)),seg_bot+7.5,outset]) {
                rotate([0,0,-ix*15]) hull() for(iz=[0,100]) translate([0,iz,0]) {
                    cylinder(r=7.5-bev_s,h=50);
                    translate([0,0,bev_s]) cylinder(r=7.5,h=50);
                }
            }
            
            for(ix=[-1,1]) translate([ix*(100-7.5-40*sin(15)),seg_bot+7.5,-0.01]) {
                rotate([0,0,-ix*15]) for(iz=[0,20,40]) translate([0,iz,0]) {
                    cylinder(r=2.5,h=outset+2*0.01);
                    cylinder(r1=2.5+bev_s,r2=2.5,h=bev_s);
                    translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=2.5,r2=2.5+bev_s,h=bev_s);
                }
            }
            
            hull() for(ix=[-1,1]) {
                for(iz=[-25-5-15-5,seg_bot+5+15+5]) translate([ix*((120-back_hgt*tan(25))-5-10),iz,-0.01]) {
                    cylinder(r=5,h=50);
                }
                for(iz=[-25-5-15,seg_bot+5+15]) translate([ix*((120-back_hgt*tan(25))-5-10-5),iz,-0.01]) {
                    cylinder(r=5,h=50);
                }
            }
            hull() for(ix=[-1,1]) {
                for(iz=[-25-5-15-5,seg_bot+5+15+5]) translate([ix*((120-back_hgt*tan(25))-5-10),iz,-0.01]) {
                    cylinder(r1=5+bev_s,r2=5,h=bev_s);
                }
                for(iz=[-25-5-15,seg_bot+5+15]) translate([ix*((120-back_hgt*tan(25))-5-10-5),iz,-0.01]) {
                    cylinder(r1=5+bev_s,r2=5,h=bev_s);
                }
            }
            hull() for(ix=[-1,1]) {
                for(iz=[-25-5-15-5,seg_bot+5+15+5]) translate([ix*((120-back_hgt*tan(25))-5-10),iz,-0.01]) {
                    translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=5,r2=5+bev_s,h=bev_s);
                }
                for(iz=[-25-5-15,seg_bot+5+15]) translate([ix*((120-back_hgt*tan(25))-5-10-5),iz,-0.01]) {
                    translate([0,0,outset-bev_s+2*0.01]) cylinder(r1=5,r2=5+bev_s,h=bev_s);
                }
            }
        }
        
        
        for(ix=[-1,0,1]) for(iz=[-25/2]) translate([ix*((120-back_hgt*tan(25))-5-10-7.5),0,iz]) {
            rotate([90,0,0]) cylinder(r=1.25,h=back_rad+outset/2);
            rotate([90,0,0]) translate([0,0,back_rad+outset/2-0.01]) hull() cylinder_oh(1.75,50);
            rotate([90,0,0]) translate([0,0,back_rad+outset]) hull() {
                cylinder_oh(3,50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
    }
}




module flange_trans(rot_ang=0,offset=0,offset_ang=0) {
    translate([0,0,-30]) {
        translate([0,-offset,0]) rotate([offset_ang,0,0]) translate([0,offset,0]) {
            rotate([rot_ang,0,0]) {
                translate([0,40,0]) {
                    children();
                }
            }
        }
    }
}

module flange_cone() {
    translate([0,0,-200+30]) cylinder(r1=120+200/tan(25+5),r2=120-50/tan(25+5),h=200+50,$fn=$fn*2);
}

module flange_shape() {
    intersection() {
        flange_trans(0,-75,-15) children();
        *flange_trans(0,-75,-10) children();
        *flange_trans(0,-75,-5) children();
        
        flange_trans(0) children();
        
        *flange_trans(5) mirror([0,1,0]) children();
        *flange_trans(10) mirror([0,1,0]) children();
        flange_trans(15) mirror([0,1,0]) children();
        
        *flange_trans(15,25,5) mirror([0,1,0]) children();
        *flange_trans(15,25,10) mirror([0,1,0]) children();
        flange_trans(15,25,15) mirror([0,1,0]) children();
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

module shoulder_yoke() difference() {
    union() {
        //interface to neck ring
        *difference() {
            intersection() {
                translate([0,0,outset+5]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                    trans1() cylinder(r=120+5-0.5,h=200,$fn=$fn*2);
                    trans1() cylinder(r=120+5,h=200-0.5,$fn=$fn*2);
                    trans1() cylinder(r=120+5+50*tan(15),h=200-0.5-50,$fn=$fn*2);
                }
                translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-250]) cube([strap_wid,500,500]);
                
                hull() {
                    intersection() {
                        translate([-120+0.5,0,0]) rotate([0,-25,0]) translate([0,-250,-250]) cube([strap_wid,500,500]);
                        translate([0,0,outset+5]) rotate([-15,0,0]) translate([0,40,0]) intersection() {
                            translate([0,0,-200]) cylinder(r=120+5,h=200,$fn=$fn*2);
                             
                            translate([0,-40+75,0]) rotate([-15,0,0]) {
                                translate([0,-(-40+75),-200]) cylinder(r=120+5,h=200,$fn=$fn*2);
                            }
                        }
                    }
                    intersection() {
                        translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-250]) cube([strap_wid,500,500]);
                        translate([0,0,outset+5]) rotate([-15,0,0]) translate([0,40,0]) intersection() {
                            translate([0,0,-200]) cylinder(r=120+5,h=200-0.5,$fn=$fn*2);
                             
                            translate([0,-40+75,0]) rotate([-15,0,0]) {
                                translate([0,-(-40+75),-200]) cylinder(r=120+5,h=200-0.5,$fn=$fn*2);
                            }
                        }
                    }
                }
                
                
                clav_hook_dep = 15;
                clav_hook_ang = 90-15;
                
                translate([-120,0,0]) rotate([0,-25,0]) translate([0,-500*0+clav_dep*0,-should_rad]) rotate([-clav_ang,0,0]) {
                    translate([0,clav_dep,0]) rotate([clav_ang-clav_hook_ang,0,0]) translate([0,-500+clav_hook_dep-2.5-5,should_rad+bev_s]) cube([strap_wid,500,500]);
                    translate([0,-250,should_rad+bev_s]) cube([strap_wid,500,500]);
                    translate([0,-250,-50]) cube([strap_wid,250+clav_dep,500]);
                    translate([0,-250-25,-250]) cube([strap_wid,250,500]);
                }
            }
            
    
            translate([0,0,outset+5]) rotate([-15,0,0]) translate([0,40,0]) { 
                translate([0,-40+75,0]) rotate([-15,0,0]) {
                    translate([0,-(-40+75),0]) {
                        translate([0,0,-100]) rotate([0,0,90-90/2]) rotate_extrude(angle=90) square([200,200]);
                    }
                }
                
                *translate([0,-40,0]) rotate([15,0,0]) {
                    translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                        translate([0,40,-100]) {
                            rotate([0,0,-90-90/2]) rotate_extrude(angle=90) square([200,200]);
                        }
                    }
                }
            }
        }
        
        //interface to neck ring (conical)
        difference() {
            intersection() {
                translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                    trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
                }
                translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                    trans1() cylinder(r=120+5,h=200+50,$fn=$fn*2);
                }
                //translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-250]) cube([strap_wid,500,500]);
                translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-back_hgt2+0.01]) cube([strap_wid,500,500]);
                
                translate([-120,0,0]) rotate([0,-25,0]) {
                    translate([0,-250,-250]) cube([strap_wid,250,500]);
                    
                    hull() {
                        translate([0,80-15,-100]) rotate([-45-10,0,0]) {
                            translate([5,0,0]) rotate([0,0,90]) cylinder_oh(5,200);
                            translate([strap_wid-5-17.5,0,0]) rotate([0,0,90]) cylinder_oh(5,200);
                            translate([strap_wid-5,0,0]) translate([0,-17.5,0]) rotate([0,0,90]) cylinder_oh(5,200);
                        }
                            
                        for(ix=[5,strap_wid-5]) translate([ix,0,-should_rad]) cylinder(r=5,h=200);
                    }
                }
            }
            
            translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) {
                translate([0,-40+75,0]) rotate([-15,0,0]) {
                    translate([0,-(-40+75),-10]) {
                        rotate([0,0,90-90/2-0*25/(2*(120+5-(8+5)/2)*3.14159)*360]) rotate_extrude(angle=90+0*25/(2*(120+5-(8+5)/2)*3.14159)*360,$fn=$fn*2) translate([120-8-50,0]) square([200,100]);
                    }
                }
            }
        }
        
        
        //shoulder strap pos
        intersection() {
            translate([-120,0,0]) rotate([0,90-25,0]) {
                union() {
                    //clavical strap
                    /*translate([should_rad,0,0]) rotate([0,0,-clav_ang]) translate([-should_rad-outset,0,0]) {
                        hull() {
                            translate([0,-0.01,bev_s]) cube([outset,clav_dep+2*0.01,strap_wid-2*bev_s]);
                            translate([bev_s,-0.01,0]) cube([outset-2*bev_s,clav_dep+2*0.01,strap_wid]);
                        }
                        translate([0,clav_dep,0]) translate([should_rad+outset,0,0]) {
                            rotate([0,0,180]) rotate_extrude(angle=-(90-clav_ang-15)) hull() {
                                square([should_rad+outset-bev_s,strap_wid]);
                                translate([0,bev_s]) square([should_rad+outset,strap_wid-2*bev_s]);
                            }
                            
                            clav_hook_dep = 15;
                            clav_hook_ang = 90-15;
                            
                            rotate([0,0,-(clav_hook_ang-clav_ang)]) translate([-(should_rad+outset),0,0]) {
                                hull() {
                                    translate([0,0,bev_s]) cube([outset,clav_hook_dep,strap_wid-2*bev_s]);
                                    translate([bev_s,0,0]) cube([outset-2*bev_s,clav_hook_dep,strap_wid]);
                                }
                                hull() for(iz=[0,strap_wid]) translate([0,clav_hook_dep,iz+(iz==0?5:-5)]) rotate([0,90,0]) rotate([0,0,90]) {
                                    cylinder_oh(5-bev_s,outset);
                                    translate([0,0,bev_s]) cylinder_oh(5,outset-2*bev_s);
                                }
                            }
                        }
                    }*/
                    
                        
                    hull() {
                        //shoulder
                        translate([should_rad,0,0]) rotate([0,0,180-clav_ang]) rotate_extrude(angle=90+clav_ang) {
                            square([should_rad+outset-bev_s,strap_wid]);
                            translate([0,bev_s]) square([should_rad+outset,strap_wid-2*bev_s]);
                        }
                        
                        //back
                        translate([back_hgt2,(back_rad-back_dep),0]) {
                            rotate([0,0,-90]) rotate_extrude(angle=-atan((back_hgt2-should_rad)/(back_rad-back_dep)),$fn=$fn*4) translate([-20+back_rad+outset,0]) {
                                square([20-bev_s,strap_wid]);
                                translate([0,bev_s]) square([20,strap_wid-2*bev_s]);
                            }
                            rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),0]) rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) rotate_extrude(angle=-90) translate([-20+50+5+outset,0]) {
                                square([20-bev_s,strap_wid]);
                                translate([0,bev_s]) square([20,strap_wid-2*bev_s]);
                            }
                        }
                    }
                }
            }
            
            //intersect with conical neck interface
            translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
            }

            translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-back_hgt2+0.01]) cube([strap_wid,500,500]);
        }
        
        
        //alt clavical
        intersection() {
            /*#hull() {
                translate([-120+should_rad*sin(25),0,-should_rad*cos(25)]) rotate([0,90-25,0]) sphere(r=should_rad+outset);
                
                translate([0,0,-should_rad*cos(25)-(-120+should_rad*sin(25))*tan(25)]) rotate([0,90-25,0]) sphere(r=should_rad+outset);
                
                translate([0,clav_dep*cos(clav_ang),-should_rad*cos(25)-clav_dep*sin(clav_ang)]) {
                    sphere(r=should_rad+outset);
                    translate([-120+should_rad*sin(25),0,0]) sphere(r=should_rad+outset);
                    translate([-120+should_rad*sin(25),0,0]) rotate([0,90,0]) cylinder(r=should_rad+outset,h=-(-120+should_rad*sin(25)));
                    
                    translate([0,50*cos(60),-50*sin(60)]) {
                        sphere(r=should_rad+outset);
                        translate([-120+should_rad*sin(25),0,0]) sphere(r=should_rad+outset);
                        translate([-120+should_rad*sin(25),0,0]) rotate([0,90,0]) cylinder(r=should_rad+outset,h=-(-120+should_rad*sin(25)));
                    }
                }
            }*/
            
            acromion_x = 150;
            acromion_y = 0;
            acromion_z = -should_rad*cos(25)-(-120+should_rad*sin(25))*tan(25)-acromion_x*tan(25);
            medial_x = 75;
            medial_y = 85;
            medial_z = -should_rad-45;
            
            
            hull() for(ix=[0,1]) mirror([ix,0,0]) {
                translate([medial_x,0,-should_rad*cos(25)-(-120+should_rad*sin(25)+medial_x)*tan(25)]) sphere(r=should_rad+outset);
                translate([medial_x,acromion_x*tan(5),-should_rad*cos(25)-(-120+should_rad*sin(25)+medial_x)*tan(25)]) sphere(r=should_rad+outset);
                
                translate([acromion_x,acromion_y,acromion_z]) sphere(r=should_rad+outset);
                
                translate([medial_x,medial_y,medial_z]) sphere(r=should_rad+outset);
                
                translate([medial_x+0,medial_y+25,medial_z-50]) sphere(r=should_rad+outset);
            }
            
            translate([-120,0,0]) rotate([0,-25,0]) {
                translate([0,-250,-250]) cube([strap_wid,250,500]);
                
                hull() {
                    translate([0,80-15,-100]) rotate([-45-10,0,0]) {
                        translate([5,0,0]) rotate([0,0,90]) cylinder_oh(5,200);
                        translate([strap_wid-5-17.5,0,0]) rotate([0,0,90]) cylinder_oh(5,200);
                        translate([strap_wid-5,0,0]) translate([0,-17.5,0]) rotate([0,0,90]) cylinder_oh(5,200);
                    }
                        
                    for(ix=[5,strap_wid-5]) translate([ix,0,-should_rad]) cylinder(r=5,h=200);
                }
            }
            
            //intersect with conical neck interface
            translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) hull() {
                trans1() cylinder(r1=120+5+200/tan(25),r2=120+5-50/tan(25),h=200+50,$fn=$fn*2);
            }
            
            translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-back_hgt2+0.01]) cube([strap_wid,500,500]);
        }
    }
    
    
    *translate([0,0,outset+5]) rotate([-15,0,0]) translate([0,40,0]) {
        translate([0,0,0]) rotate_extrude($fn=$fn*2) polygon([[200,0],[120-8-2.5,0],[120-8-2.5-50/tan(25+5),50],[200,50]]);
            
        *translate([0,-40+75,0]) rotate([-15,0,0]) {
            translate([0,-(-40+75),0]) {
                rotate_extrude($fn=$fn*2) polygon([[200,0],[120-8-2.5,0],[120-8-2.5-50/tan(25+5),50],[200,50]]);
            }
        }
        
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,40,0]) {
                rotate_extrude($fn=$fn*2) polygon([[200,0],[120-8-2.5,0],[120-8-2.5-50/tan(25+5),50],[200,50]]);
            }
        }
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                translate([0,40,0]) {
                    rotate_extrude($fn=$fn*2) polygon([[200,0],[120-8-2.5,0],[120-8-2.5-50/tan(25+5),50],[200,50]]);
                }
            }
        }
    }
    
    
    //cutouts for where the spacers will go
    translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) {
        translate([0,-40+75,0]) rotate([-15,0,0]) {
            translate([0,-(-40+75),-10]) {
                rotate([0,0,90-90/2-25/(2*(120+5-(8+5)/2)*3.14159)*360]) rotate_extrude(angle=90+2*25/(2*(120+5-(8+5)/2)*3.14159)*360,$fn=$fn*2) translate([120-8,0]) square([200,100]);
                
                for(iy=[0.25,0.75]*25) rotate([0,0,90-90/2+iy/(2*(120+5-(8+5)/2)*3.14159)*360]) translate([0,120+5-(5+8)/2,0]) rotate([0,0,-(-90/2+iy/(2*(120+5-(8+5)/2)*3.14159)*360)]) {
                    translate([0,0,-10]) hull() cylinder_oh(1.25,100);
                    translate([0,0,0]) cylinder(r=1.75,h=100);
                }

            }
        }
        *translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                translate([0,40,-5]) {
                    rotate([0,0,-90-90/2-25/(2*(120+5-(8+5)/2)*3.14159)*360]) rotate_extrude(angle=90+2*10/(2*(120+5-(8+5)/2)*3.14159)*360,$fn=$fn*2) translate([120-8,0]) hull() {
                        translate([2.5,0]) square([200,100]);
                        translate([0,2.5]) square([200,100]);
                    }
                    
                    for(iy=[0.25,0.75]*25) rotate([0,0,90+90/2-iy/(2*(120+5-(8+5)/2)*3.14159)*360]) translate([0,120+5-(5+8)/2,0]) rotate([0,0,-(90+90/2-iy/(2*(120+5-(8+5)/2)*3.14159)*360)]) {
                        translate([0,0,-10]) hull() cylinder_oh(1.25,100);
                        translate([0,0,0]) cylinder(r=1.75,h=100);
                    }
                }
            }
        }
    }
    
    //magnets!
    translate([0,0,outset]) rotate([-15,0,0]) translate([0,40,0]) {
        neck_space_mag_co();
    }
    
    //holes for shock cord
    translate([-120,0,0]) rotate([0,90-25,0]) {
        clav_hook_dep = 15;
        clav_hook_ang = 90-15;
    
        /*translate([should_rad,0,0]) rotate([0,0,-clav_ang]) translate([0,clav_dep,0]) rotate([0,0,clav_ang-clav_hook_ang]) translate([-should_rad-outset,0,0]) {
            for(iz=[0,strap_wid]) translate([-0.01,clav_hook_dep-2.5,iz+(iz==0?1:-1)*(5+2.5)]) rotate([0,90,0]) rotate([0,0,90]) {
                hull() cylinder_oh(2.5,outset+2*0.01);
                for(iy=[0,1]) translate([0,0,iy*(outset+2*0.01)]) mirror([0,0,iy]) hull() {
                    cylinder_oh(2.5,bev_s);
                    cylinder_oh(2.5+bev_s,0.01);
                }
            }
        }*/
    }
    
    translate([-120,0,0]) rotate([0,-25,0]) {
        translate([0,80-15,-100]) rotate([-45-10,0,0]) {
            translate([5,0,0]) rotate([0,0,90]) translate([-3,-3,0]) hull() cylinder_oh(3,200);
        }
    }
    
    //screws for interface with back_upper
    translate([-120,0,0]) rotate([0,90-25,0]) {
        translate([back_hgt2,(back_rad-back_dep),strap_wid-10]) {
            for(iz=[50,87.5]) rotate([0,0,-asin(iz/back_rad)]) rotate([90,0,0]) {
                hull() cylinder_oh(1.25,500);
                //translate([0,0,back_rad+outset/2-0.01]) cylinder(r=1.75,h=50);
            }
        }
    }
    
    //lip for interface with back upper
    difference() {
        translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,0,-50]) cylinder(r=200,h=50+50);
        }
        hull() {
            translate([-120,0,0]) rotate([0,90-25,0]) {
                translate([0,0,-50]) linear_extrude(height=50+strap_wid-20-outset/2) back_upper_cs(outset);
            }
            translate([-120,0,0]) rotate([0,90-25,0]) {
                translate([0,0,0]) linear_extrude(height=strap_wid-20) back_upper_cs(outset/2);
            }
        }
        translate([-120,0,0]) rotate([0,90-25,0]) {
            translate([0,0,-50]) linear_extrude(height=50+strap_wid+50) back_upper_cs(outset/2);
        }
        translate([0,-((back_rad-back_dep)+outset)+250,-back_hgt]) rotate([-asin(110/back_rad),0,0]) {
            translate([-140/2-50,-(250+50),0.4]) cube([140+2*50,250+50,250]);
        }
        translate([0,0,0]) {
            translate([-250,-(250+50)*0,-250]) cube([250,250+50,500]);
        }
    }
    
    //strap negative
    translate([-120,0,0]) rotate([0,90-25,0]) {
        hull() {
            translate([should_rad,0,-0.01]) {
                cylinder(r=should_rad,h=50);
                //rotate([0,0,-clav_ang]) translate([0,clav_dep,0]) cylinder(r=should_rad,h=50);
            }
            translate([back_hgt2,(back_rad-back_dep),-1]) {
                rotate([0,0,-90]) rotate_extrude(angle=-atan((back_hgt2-should_rad)/(back_rad-back_dep)),$fn=$fn*4) square([back_rad,50]);
                rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),0]) cylinder(r=50+5,h=50);
            }
        }
        for(iy=[0,1]) translate([0,0,iy*(strap_wid+2*0.01)]) mirror([0,0,iy]) hull() {
            translate([should_rad,0,-0.01]) {
                cylinder(r1=should_rad+bev_s,r2=should_rad,h=bev_s);
                //rotate([0,0,-clav_ang]) translate([0,clav_dep,0]) cylinder(r1=should_rad+bev_s,r2=should_rad,h=bev_s);
            }
            translate([back_hgt2,(back_rad-back_dep),-0.01]) {
                rotate([0,0,-90]) rotate_extrude(angle=-atan((back_hgt2-should_rad)/(back_rad-back_dep)),$fn=$fn*4) {
                    square([back_rad,bev_s]);
                    square([back_rad+bev_s,0.01]);
                }
                rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),0]) cylinder(r1=50+5+bev_s,r2=50+5,h=bev_s);
            }
        }
    }
    
    //clavical strap negative
    union() {
        acromion_x = 150;
        acromion_y = 0;
        acromion_z = -should_rad*cos(25)-(-120+should_rad*sin(25))*tan(25)-acromion_x*tan(25);
        medial_x = 75;
        medial_y = 85;
        medial_z = -should_rad-45;
        
        outset = 0;
        
        hull() for(ix=[0,1]) mirror([ix,0,0]) {
            translate([medial_x,0,-should_rad*cos(25)-(-120+should_rad*sin(25)+medial_x)*tan(25)]) sphere(r=should_rad+outset);
            translate([medial_x,acromion_x*tan(5),-should_rad*cos(25)-(-120+should_rad*sin(25)+medial_x)*tan(25)]) sphere(r=should_rad+outset);
            
            translate([acromion_x,acromion_y,acromion_z]) sphere(r=should_rad+outset);
            
            translate([medial_x,medial_y,medial_z]) sphere(r=should_rad+outset);
            
            translate([medial_x+0,medial_y+25,medial_z-50]) sphere(r=should_rad+outset);
        }
    }
    
    
    //screws for interface with back mid
    translate([-120,0,0]) rotate([0,90-25,0]) {
        for(ix=[strap_wid*0.25,strap_wid*0.75]) translate([back_hgt2,(back_rad-back_dep),ix]) {
            rotate([0,0,-(25/(back_rad*2*3.14159))*360/2]) rotate([90,0,0]) {
                hull() cylinder_oh(1.25,back_rad+outset/2);
                translate([0,0,back_rad+outset/2-0.01]) cylinder(r=1.75,h=50);
                translate([0,0,back_rad+outset]) hull() {
                    cylinder(r=3,h=50);
                    translate([0,0,-3]) cylinder(r=0.01,h=50);
                }
            }
        }
    }
    
    //lip for interface with back mid
    translate([-120,0,0]) rotate([0,90-25,0]) {
        translate([back_hgt2,(back_rad-back_dep),-1]) {
            rotate([0,0,-90]) rotate_extrude(angle=-(25/(back_rad*2*3.14159))*360,$fn=$fn*4) translate([back_rad+outset/2,0]) square([20,50]);
        }
    }
    
    translate([-120,0,0]) rotate([0,90-25,0]) {
        translate([back_hgt2,(back_rad-back_dep),0]) {
            rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),strap_wid-20/2]) rotate([0,0,asin(15/(50+5+outset))]) {
                rotate([90,0,0]) {
                    hull() cylinder_oh(1.25,50+5+outset/2);
                    translate([0,0,50+5+outset/2-0.01]) cylinder(r=1.75,h=50);
                    translate([0,0,50+5+outset]) hull() {
                        cylinder(r=3,h=50);
                        translate([0,0,-3]) cylinder(r=0.01,h=50);
                    }
                }
            }
        }
    }
}


module back_mid() difference() {
    intersection() {
        hull() {
            for(ix=[0,1]) mirror([ix,0,0]) translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
                rotate([0,-25,0]) rotate([0,90,0]) cylinder(r=back_rad+outset,h=strap_wid,$fn=$fn*2);
            }
            translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
                rotate([0,90,0]) cylinder(r=back_rad+outset,h=2*(120-back_hgt*tan(25)),$fn=$fn*2);
                rotate([15,0,0]) translate([0,0,-150]) rotate([0,90,0]) cylinder(r=back_rad+outset,h=2*(120-back_hgt*tan(25)),$fn=$fn*2);
            }
        }
        translate([-250,-500-50,-500]) cube([500,500,1000]);
    }
    
    hull() {
        for(ix=[0,1]) mirror([ix,0,0]) translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
            rotate([0,-25,0]) rotate([0,90,0]) cylinder(r=back_rad,h=strap_wid,$fn=$fn*2);
        }
        translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
            rotate([0,90,0]) cylinder(r=back_rad,h=2*(120-back_hgt*tan(25)),$fn=$fn*2);
            rotate([15,0,0]) translate([0,0,-150]) rotate([0,90,0]) cylinder(r=back_rad,h=2*(120-back_hgt*tan(25)),$fn=$fn*2);
        }
    }
    
    translate([0,(back_rad-back_dep),-back_hgt]) rotate([15,0,0]) translate([-250,-500,-500-25]) cube([500,500,500]);
    
    for(ix=[0,1]) mirror([ix,0,0]) translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) rotate([0,-25,0]) rotate([-(25/(back_rad*2*3.14159))*360,0,0]) translate([-250,-500,0]) cube([500,500,500]);
        
    translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) rotate([0,-25,0]) rotate([-(25/(back_rad*2*3.14159))*360,0,0]) translate([strap_wid,-500,0]) rotate([0,25,0]) cube([500,500,500]);
    
    intersection() {
        hull() {
            for(ix=[0,1]) mirror([ix,0,0]) translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
                rotate([0,-25,0]) rotate([0,90,0]) cylinder(r=back_rad+outset/2,h=strap_wid,$fn=$fn*2);
            }
            translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
                rotate([0,90,0]) cylinder(r=back_rad+outset/2,h=2*(120-back_hgt*tan(25)),$fn=$fn*2);
                rotate([15,0,0]) translate([0,0,-150]) rotate([0,90,0]) cylinder(r=back_rad+outset/2,h=2*(120-back_hgt*tan(25)),$fn=$fn*2);
            }
        }
        union() {
            for(ix=[0,1]) mirror([ix,0,0]) translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) rotate([0,-25,0]) translate([-250,-500,0]) cube([500,500,500]);
                
            translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) rotate([0,-25,0]) translate([strap_wid,-500,0]) rotate([0,25,0]) cube([500,500,500]);
        }
    }
    
    for(ix2=[0,1]) mirror([ix2,0,0]) translate([-120,0,0]) rotate([0,90-25,0]) {
        for(ix=[strap_wid*0.25,strap_wid*0.75]) translate([back_hgt2,(back_rad-back_dep),ix]) {
            rotate([0,0,-(25/(back_rad*2*3.14159))*360/2]) rotate([90,0,0]) {
                cylinder(r=1.25,h=back_rad+outset/2);
                rotate([0,0,90-25]) {
                    translate([0,0,back_rad+outset/2-1]) hull() cylinder_oh(1.75,50);
                    translate([0,0,back_rad+outset]) hull() {
                        cylinder_oh(3,50);
                        translate([0,0,-3]) cylinder(r=0.01,h=50);
                    }
                }
            }
        }
    }
    
    translate([0,(back_rad-back_dep),-back_hgt]) rotate([15,0,0]) {
        hull() for(ix=[-1,1]) for(iz=[-5,-25]) translate([ix*((120-back_hgt*tan(25))-5-10),0,iz]) {
            rotate([90,0,0]) {
                cylinder(r=5,h=back_rad+outset/2);
                cylinder(r=5+outset/2,h=back_rad);
            }
        }
        for(ix=[-1,0,1]) for(iz=[-25/2]) translate([ix*((120-back_hgt*tan(25))-5-10-7.5),0,iz]) {
            rotate([90,0,0]) cylinder(r=1.25,h=back_rad+outset/2);
            rotate([90,0,0]) translate([0,0,back_rad+outset/2-0.01]) hull() cylinder_oh(1.75,50);
            rotate([90,0,0]) translate([0,0,back_rad+outset]) hull() {
                cylinder_oh(3,50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
    }
    
    for(ix=[0,1]) mirror([ix,0,0]) translate([-(120-back_hgt*tan(25)),(back_rad-back_dep),-back_hgt]) {
        hull() {
            rotate([90,0,0]) cylinder(r=0.01,h=200);
            rotate([0,-25,0]) translate([0,0,500]) rotate([90,0,0]) cylinder(r=0.01,h=200);
            translate([0,0,-500]) rotate([90,0,0]) cylinder(r=0.01,h=200);
        }
        
        rotate([90,0,0]) cylinder(r=0.01,h=200);
        rotate([90,0,0]) hull() {
            cylinder(r=0.01+bev_s,h=back_rad);
            cylinder(r=0.01,h=back_rad+bev_s);
        }
        rotate([90,0,0]) translate([0,0,back_rad+outset]) hull() {
            cylinder(r=0.01+bev_s,h=50);
            translate([0,0,-bev_s]) cylinder(r=0.01,h=50);
        }
            
        rotate([0,90,0]) rotate([0,0,-90]) rotate_extrude(angle=15,$fn=$fn*4) {
            translate([0,-(0.01)]) square([200,2*(0.01)]);
            hull() {
                translate([0,-(0.01+bev_s)]) square([back_rad,2*(0.01+bev_s)]);
                translate([0,-(0.01)]) square([back_rad+bev_s,2*(0.01)]);
            }
            translate([back_rad+outset,0]) hull() {
                translate([0,-(0.01+bev_s)]) square([50,2*(0.01+bev_s)]);
                translate([-bev_s,-(0.01)]) square([50,2*(0.01)]);
            }
        }
        rotate([15,0,0]) rotate([0,0,-90]) translate([0,0,-50]) linear_extrude(height=50) {
            translate([0,-(0.01)]) square([200,2*(0.01)]);
            hull() {
                translate([0,-(0.01+bev_s)]) square([back_rad,2*(0.01+bev_s)]);
                translate([0,-(0.01)]) square([back_rad+bev_s,2*(0.01)]);
            }
            translate([back_rad+outset,0]) hull() {
                translate([0,-(0.01+bev_s)]) square([50,2*(0.01+bev_s)]);
                translate([-bev_s,-(0.01)]) square([50,2*(0.01)]);
            }
        }
        
        rotate([0,-25,0]) {
            rotate([0,90,0]) rotate([0,0,-90]) rotate_extrude(angle=-45,$fn=$fn*4) {
                translate([0,-(0.01)]) square([200,2*(0.01)]);
                hull() {
                    translate([0,-(0.01+bev_s)]) square([back_rad,2*(0.01+bev_s)]);
                    translate([0,-(0.01)]) square([back_rad+bev_s,2*(0.01)]);
                }
                translate([back_rad+outset,0]) hull() {
                    translate([0,-(0.01+bev_s)]) square([50,2*(0.01+bev_s)]);
                    translate([-bev_s,-(0.01)]) square([50,2*(0.01)]);
                }
            }
        }
    }
    
}




module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}