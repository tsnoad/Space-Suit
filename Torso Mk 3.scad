$fn = 36;

//translate([-15,-20,-780]) {
*intersection() {
    translate([0,55,27.5]) {
        translate([0,50,-550]) rotate([0,0,-5]) scale(1000) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_13_20_19.stl", convexity=10);
    }
    
    *translate([-120,-250,0]) rotate([0,-25,0]) translate([0,0,-400]) cube([40,500,500]);
}

*for(i=[0,1]) mirror([i,0,0]) translate([60,0,0]) sphere(r=10);

*rotate([-15,0,0]) translate([0,30,-10]) difference() {
    cylinder(r=120+15,h=25);
    translate([0,0,-1]) cylinder(r=120-8,h=50);
}
    

//section_r120(0);

should_rad = 30;
should_ang = 25;

back_dep = 95;
back_hgt = 140;
back_hgt2 = back_hgt/cos(should_ang);
back_rad = (pow(back_dep,2) + pow(back_hgt2-should_rad,2) - pow(should_rad,2)) / (2 * (back_dep - should_rad));

clav_ang = 25;
clav_dep = 70;

strap_wid = 40;


echo(back_rad);

outset = 7.5;

bev_s = 0.5;

*hull() for(ix=[0,1]) mirror([ix,0,0]) translate([0,-100,0])  {
    translate([150-50,0,-300-50]) rotate([90,0,0]) cylinder(r=25,h=100);
    translate([150,0,-300]) rotate([90,0,0]) cylinder(r=25,h=100);
    translate([150,0,0]) rotate([90,0,0]) cylinder(r=25,h=100);
    translate([150-50,0,50]) rotate([90,0,0]) cylinder(r=25,h=100);
}

rotate([-15,0,0]) translate([0,20,15]) {


}

//assembly
rotate([-15,0,0]) translate([0,20,15]) {
    for(i=[0,1]) mirror([0,i,0]) ring_joiner();
    for(i=[0,1]) mirror([i,0,0]) ring(true,false);
    for(i=[0,1]) mirror([0,i,0]) ring(false,true);
}
shoulder_yoke();
mirror([1,0,0]) shoulder_yoke();
*back_curve();
*back_lower();
chest_plate();



//printable
*rotate([0,25,0]) shoulder_yoke();
*rotate([-15,0,0]) back_curve();


*for(im=[0,1]) mirror([0,im,0]) {
    translate([0,10,0]) web_mount(40,[-0.5,-1/6,1/6,0.5]);
    translate([50,10,0]) web_mount(strap_wid-2*7.5,[-0.5,0,0.5]);
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
            for(ix=[-75,75]) translate([ix,0,-250]) rotate([90,0,0]) {
                hull() rotate_extrude() {
                    translate([7.5+50,0]) circle(r=2.5);
                    translate([0,back_dep-5]) {
                        translate([7.5,-2.5]) circle(r=2.5);
                        translate([7.5+50,-2.5-50]) circle(r=2.5);
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
    
    for(ix=[-75,75]) translate([ix,0,-250]) rotate([90,0,0]) hull() {
        cylinder(r=3,h=200);
    }
    
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

module ring(side=true,frontback=false) difference() {
    intersection() {
        hull() {
            cylinder(r=120+5-0.25,h=5-1,$fn=$fn*4);
            translate([0,0,0.25]) {
                cylinder(r=120+5,h=5-0.25-1,$fn=$fn*4);
                cylinder(r=120+5-1,h=5-0.25,$fn=$fn*4);
            }
        }
        for(ia=[0]) rotate([0,0,ia]) union() {
            if(side) union() {
                rotate([0,0,-45-15]) translate([0.2,0.2,0]) cube([200,200,10]);
                rotate([0,0,-45+15]) translate([0.2,0.2,0]) cube([200,200,10]);
            }
            if(frontback) intersection() {
                rotate([0,0,45-15]) translate([0.2,0.2,0]) cube([200,200,10]);
                rotate([0,0,45+15]) translate([0.2,0.2,0]) cube([200,200,10]);
            }
        }
    }
    translate([0,0,-0.01]) cylinder(r=120-8,h=10,$fn=$fn*4);
    translate([0,0,-0.01]) cylinder(r1=120-8+0.25,r2=120-8,h=0.25,$fn=$fn*4);
    translate([0,0,5-0.25+0.01]) cylinder(r1=120-8,r2=120-8+0.25,h=0.25,$fn=$fn*4);
    
    for(i=[0:45:360-45]) rotate([0,0,i]) translate([120-8+2.5+4,0,-0.01]) {
        cylinder(r=2.5,h=10);
        cylinder(r=4,h=5-0.4);
        hull() {
            cylinder(r=4,h=5-3-0.4);
            cylinder(r=4+0.2,h=5-3-0.2-0.4);
        }
        cylinder(r1=4+0.2+0.25,r2=4+0.2,h=0.25);
    }
    
    for(ix=[0,1]) mirror([ix,0,0]) for(ia=[-60,60]) rotate([0,0,ia]) {
        for(iy=[-12.5,12.5]) translate([sqrt(pow(120-8/2,2)-pow(iy,2)),iy,-10]) {
            cylinder(r=1.25,h=50);
            translate([0,0,-50+0.01]) cylinder(r=1.75,h=50);
            translate([0,0,-50-5]) hull() {
                cylinder(r=3,h=50);
                cylinder(r=0.01,h=50+3);
            }
        }
    }
    
    for(j=[0,-10]) translate([0,j,0]) {
        for(i=[-1,0,7,8]) rotate([0,0,i*360/16+360/16/2]) translate([120-8/2,0,0]) rotate([0,0,90-(i*360/16+360/16/2)]){
            translate([0,0,-10]) cylinder(r=1.75,h=50);
            
            translate([0,0,5-2.5]) {
                hull() {
                    translate([0,0,0.25]) cylinder(r=3+0.25,h=50);
                    translate([0,0,-3]) cylinder(r=0.01,h=50+3);
                }
                hull() {
                    translate([0,0,0.25]) cylinder(r=3+0.25,h=50);
                    translate([0,10,0.25]) cylinder(r=3+0.25,h=50);
                }
            }
        }
    }
}

module ring_joiner() difference() {
    translate([0,0,-5+1.6]) union() {
        rotate([0,0,90-30-asin(12.5/(120-8/2))]) rotate_extrude(angle=2*(30+asin(12.5/(120-8/2))),$fn=$fn*4) translate([120-8,0]) hull() {
            translate([0.25,0]) square([8+5-2*0.25,5-1.6]);
            translate([0,0.25]) square([8+5,5-1.6-2*0.25]);
        }
        for(ia=[-1,1]) rotate([0,0,ia*(30+asin(12.5/(120-8/2)))]) translate([0,120-8+(8+5)/2,0]) hull() {
            cylinder(r=(8+5)/2-0.25,h=5-1.6);
            translate([0,0,0.25]) cylinder(r=(8+5)/2,h=5-1.6-2*0.25);
        }
    }
    for(ia=[-30,30]) rotate([0,0,ia]) for(iy=[-12.5,12.5]) translate([iy,sqrt(pow(120-8/2,2)-pow(iy,2)),0]) {
        cylinder(r=1.25,h=50);
        translate([0,0,-50+0.01]) cylinder(r=1.75,h=50);
        translate([0,0,-50-5+1.6]) hull() {
            translate([0,0,-0.5]) cylinder(r=3+0.5,h=50);
            cylinder(r=0.01,h=50+3);
        }
    }
}


module shoulder_yoke() difference() {
    union() {
        intersection() {
            //*rotate([-15,0,0]) translate([-250,10-(120-8/2)*sin(360/16/2)-10,-50]) cube([500,2*(120-8/2)*sin(360/16/2)+2*10+(30-10),50+15]);
            rotate([-15,0,0]) translate([-250,-40,-50]) cube([500,40+70,50+15]);
            rotate([-15,0,0]) translate([0,20,-50]) hull() {
                cylinder(r=120+2.5,h=50+15,$fn=$fn*2);
                *cylinder(r=120+2.5+20,h=50+15-20);
            }
            translate([-120,0,0]) rotate([0,-25,0]) translate([0,-250,-250]) cube([strap_wid,500,500]);
        }
        
        translate([-120,0,0]) rotate([0,90-25,0]) {
            union() {
                translate([should_rad,0,0]) rotate([0,0,-clav_ang]) translate([-should_rad-outset,0,0]) {
                    hull() {
                        translate([0,0,bev_s]) cube([outset,clav_dep,strap_wid-2*bev_s]);
                        translate([bev_s,0,0]) cube([outset-2*bev_s,clav_dep,strap_wid]);
                    }
                    hull() for(iz=[0,strap_wid]) translate([0,clav_dep,iz+(iz==0?5:-5)]) rotate([0,90,0]) rotate([0,0,90]) {
                        cylinder_oh(5-bev_s,outset);
                        translate([0,0,bev_s]) cylinder_oh(5,outset-2*bev_s);
                    }
                }
                hull() {
                    translate([should_rad,0,0]) rotate([0,0,180-clav_ang]) rotate_extrude(angle=90+clav_ang) {
                        square([should_rad+outset-bev_s,strap_wid]);
                        translate([0,bev_s]) square([should_rad+outset,strap_wid-2*bev_s]);
                    }
                    
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
    }
    
    translate([-120,0,0]) rotate([0,90-25,0]) {
        translate([should_rad,0,0]) rotate([0,0,-clav_ang]) translate([-should_rad-outset,0,0]) {
            for(iz=[0,strap_wid]) translate([-0.01,clav_dep-2.5,iz+(iz==0?1:-1)*(5+2.5)]) rotate([0,90,0]) rotate([0,0,90]) {
                hull() cylinder_oh(2.5,outset+2*0.01);
                for(iy=[0,1]) translate([0,0,iy*(outset+2*0.01)]) mirror([0,0,iy]) hull() {
                    cylinder_oh(2.5,bev_s);
                    cylinder_oh(2.5+bev_s,0.01);
                }
            }
        }
    }
    
    *rotate([-15,0,0]) translate([0,30,15]) rotate_extrude() translate([120-8-5,0]) square([50,50]);
    *rotate([-15,0,0]) translate([0,10,15]) rotate_extrude() translate([120-8-5,0]) square([50,50]);
    //rotate([-15,0,0]) translate([-(120-25-40+15),0,-50]) cylinder(r=25,h=100);
    
    rotate([-15,0,0]) for(j=[10,20,30]) translate([0,j,15]) {
        for(i=[-1,0,7,8]) rotate([0,0,i*360/16+360/16/2]) translate([120-8/2,0,0]) rotate([0,0,90-(i*360/16+360/16/2)]){
            translate([0,0,-10]) hull() cylinder_oh(1.25,50);
            
            *translate([0,0,-50-1.6]) hull() {
                cylinder_oh(3,50);
                cylinder_oh(0.01,50+3);
            }
        }
    }
        
    translate([-120,0,0]) rotate([0,90-25,0]) {
        hull() {
            translate([should_rad,0,-0.01]) {
                cylinder(r=should_rad,h=50);
                rotate([0,0,-clav_ang]) translate([0,clav_dep,0]) cylinder(r=should_rad,h=50);
            }
            translate([back_hgt2,(back_rad-back_dep),-1]) {
                rotate([0,0,-90]) rotate_extrude(angle=-atan((back_hgt2-should_rad)/(back_rad-back_dep)),$fn=$fn*4) square([back_rad,50]);
                rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),0]) cylinder(r=50+5,h=50);
            }
        }
        for(iy=[0,1]) translate([0,0,iy*(strap_wid+2*0.01)]) mirror([0,0,iy]) hull() {
            translate([should_rad,0,-0.01]) {
                cylinder(r1=should_rad+bev_s,r2=should_rad,h=bev_s);
                rotate([0,0,-clav_ang]) translate([0,clav_dep,0]) cylinder(r1=should_rad+bev_s,r2=should_rad,h=bev_s);
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
        
    translate([-120,0,0]) rotate([0,90-25,0]) {
        translate([back_hgt2,(back_rad-back_dep),-1]) {
            rotate([0,0,-90]) rotate_extrude(angle=-(25/(back_rad*2*3.14159))*360,$fn=$fn*4) translate([back_rad+outset/2,0]) square([20,50]);
        }
    }
}


module back_curve() difference() {
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

    
*intersection() {
    difference() {
        union() {
            intersection() {
                torso(10);
                union() {
                    //front panel
                    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([120-20,0,0]) {
                        rotate([-90,0,0]) cylinder(r=20,h=500);
                        translate([0,0,-(250-20)+50]) rotate([-90,0,0]) cylinder(r=20,h=500);
                        translate([-50*tan(22.5),0,-(250-20)]) rotate([-90,0,0]) cylinder(r=20,h=500);
                    }
                    //back panel
                    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([120-20,0,0]) {
                        rotate([90,0,0]) cylinder(r=20,h=500);
                        translate([0,0,-(350-20)+50]) rotate([90,0,0]) cylinder(r=20,h=500);
                        translate([-50*tan(22.5),0,-(350-20)]) rotate([90,0,0]) cylinder(r=20,h=500);
                    }
                }
            }
            
            hull() {
                rotate([-15,0,0]) {
                    translate([-120,70,-5]) rotate([0,90,0]) cylinder(r=5,h=240);
                    translate([-120,-20,-5]) rotate([0,90,0]) cylinder(r=5,h=240);
                }
                rotate([-15,0,0]) {
                    translate([-120,70+10,-5-50]) rotate([0,90,0]) cylinder(r=5,h=240);
                    translate([-120,-20,-5-50]) rotate([0,90,0]) cylinder(r=5,h=240);
                }
            }
        }
        torso(2.5);
        
        rotate([-15,0,0]) translate([0,30,0]) difference() {
            cylinder(r=200,h=50);
        }
        
        rotate([-15,0,0]) for(j=[10,20,30,40]) translate([0,j,0]) {
            for(i=[-1,0,7,8]) rotate([0,0,i*360/16+360/16/2]) translate([120-8/2,0,0]) rotate([0,0,90-(i*360/16+360/16/2)]){
                translate([0,0,-10]) hull() cylinder_oh(1.75,50);
                
                translate([0,0,-50-1.6]) hull() {
                    cylinder_oh(3,50);
                    cylinder_oh(0.01,50+3);
                }
            }
        }
        
        *translate([-(120-20),0,-5]) rotate([0,90,0]) cylinder(r=5,h=2*(120-20));
        
        *hull() {
            translate([-(120-20),0,-5]) rotate([0,90,0]) cylinder(r=5,h=2*(120-20));
            translate([-(120-20),-50*tan(30),-5+50]) rotate([0,90,0]) cylinder(r=5,h=2*(120-20));
            translate([-(120-20),50*tan(30),-5+50]) rotate([0,90,0]) cylinder(r=5,h=2*(120-20));
        }
        
        //front head co
        hull() for(ix=[0,1]) mirror([ix,0,0]) translate([90-20,-1,0]) {
            translate([0,0,50]) rotate([-90,0,0]) cylinder(r=20,h=500);
            translate([0,0,-(112.5-20)]) rotate([-90,0,0]) cylinder(r=20,h=500);
        }
        //back head co
        hull() for(ix=[0,1]) mirror([ix,0,0]) translate([90-20,1,0]) {
            translate([0,0,50]) rotate([90,0,0]) cylinder(r=20,h=500);
            translate([0,0,-(75-20)]) rotate([90,0,0]) cylinder(r=20,h=500);
        }
        
        *for(i=[-1:1]) translate([0,-93.5+i*3.2,-100+i*15]) rotate([-90,0,0]) rotate([0,0,90]) {
            translate([0,0,-10]) hull() cylinder_oh(1.75,50);
            
            translate([0,0,-50-1.6]) hull() {
                cylinder_oh(3,50);
                cylinder_oh(0.01,50+3);
            }
        }
        *for(i=[-1:1]) translate([0,147.2-i*8.3,-140+i*15]) rotate([90+22.5,0,0]) rotate([0,0,-90]) {
            translate([0,0,-10]) hull() cylinder_oh(1.75,50);
            
            translate([0,0,-50-1.6]) hull() {
                cylinder_oh(3,50);
                cylinder_oh(0.01,50+3);
            }
        }
    }
                
    
    *translate([-120,10,-82.5]) rotate([45-15,0,0]) translate([0,-190/2,-190/2]) cube([30,190,190]);
    #mirror([1,0,0]) translate([-120,20,-77.5]) rotate([45-15,0,0]) translate([0,-190/2,-190/2]) cube([30,190,190]);
    
    *union() {
        translate([-120,-0.01,-175]) cube([120-12.5-0.25,200,200]);
        translate([-120,-200+0.01,-125]) cube([120-12.5-0.25,200,200]);
        
        intersection() {
            union() {
                translate([-120,-0.01,-175]) cube([120+12.5,200,200]);
                translate([-120,-200+0.01,-125]) cube([120+12.5,200,200]);
            }
            torso(2.5+5);
        }
    }
}

module torso(outset=0) {
    translate([0,40,0]) {
        hull() {
            section_l120(outset);
            section_l80(outset);
        }   
        hull() {
            section_l80(outset);
            section_r80(outset);
        } 
        hull() {
            section_r80(outset);
            section_r120(outset);
        }
    }
}

module section_r120(outset=0) translate([120,0,0]) {
    translate([0,62.5,-335]) sphere(r=50+outset);
    translate([0,75,-240]) sphere(r=50+outset);
    translate([0,55,-145]) sphere(r=50+outset);
    translate([0,20,-122.5]) sphere(r=50+outset);
    *translate([0,10,-95]) sphere(r=30+outset);
    translate([0,-20,-77.5]) sphere(r=30+outset);
    translate([0,-30,-72.5]) sphere(r=30+outset);
    translate([0,-52.5,-80]) sphere(r=30+outset);
    translate([0,-60,-112.5]) sphere(r=50+outset);
    translate([0,-30,-200]) sphere(r=100+outset);
    translate([0,-25,-325]) sphere(r=75+outset);
}

module section_r80(outset=0) translate([80,0,0]) {
    translate([0,80,-335]) sphere(r=50+outset);
    translate([0,67.5,-245]) sphere(r=75+outset);
    **translate([0,32.5,-145]) sphere(r=50+outset);
    translate([0,50,-140]) sphere(r=50+outset);
    **translate([0,10,-95]) sphere(r=30+outset);
    translate([0,-25,-52.5]) sphere(r=30+outset);
    translate([0,-45,-50]) sphere(r=30+outset);
    translate([0,-60,-60]) sphere(r=30+outset);
    translate([0,-67.5,-110]) sphere(r=50+outset);
    translate([0,-32.5,-200]) sphere(r=100+outset);
    translate([0,-35,-325]) sphere(r=75+outset);
}
module section_l80(outset=0) translate([-80,0,0]) {
    translate([0,90,-335]) sphere(r=50+outset);
    translate([0,57.5,-235]) sphere(r=75+outset);
    *translate([0,32.5,-145]) sphere(r=50+outset);
    translate([0,20,-115]) sphere(r=50+outset);
    *translate([0,10,-95]) sphere(r=30+outset);
    translate([0,-30,-40]) sphere(r=30+outset);
    translate([0,-45,-37.5]) sphere(r=30+outset);
    translate([0,-75,-50]) sphere(r=30+outset);
    translate([0,-82.5,-95]) sphere(r=50+outset);
    translate([0,-50,-180]) sphere(r=100+outset);
    translate([0,-47.5,-325]) sphere(r=75+outset);
}

module section_l120(outset=0) translate([-120,0,0]) {
    translate([0,62.5,-335]) sphere(r=50+outset);
    translate([0,75,-240]) sphere(r=50+outset);
    translate([0,32.5,-145]) sphere(r=50+outset);
    translate([0,20,-130]) sphere(r=50+outset);
    translate([0,10,-95]) sphere(r=30+outset);
    translate([0,-30,-67]) sphere(r=30+outset);
    translate([0,-55,-55]) sphere(r=30+outset);
    translate([0,-75,-65]) sphere(r=30+outset);
    translate([0,-80,-95]) sphere(r=50+outset);
    translate([0,-50,-165]) sphere(r=100+outset);
    translate([0,-35,-325]) sphere(r=75+outset);
}


module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}