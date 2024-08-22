$fn = 36;


*difference() {
    //foo();
    
    rotate([-15,0,0]) rotate([0,0,0]) rotate([15,0,0]) intersection() {
        scale(940) translate([0.045,0.040,-0.530]) rotate([0,0,0]) rotate([0,0,30]) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_09_47_19.stl",convexity=10);
        //translate([-100,0,0]) rotate([0,-90,0]) cylinder(r=400,h=20);
    }
    *translate([0,-500,-500]) cube([1000,1000,1000]);
    *translate([-500,-500,-1000-350]) cube([1000,1000,1000]);
}

*translate([0,-150,0]) {
    difference() {
        hull() for(ix=[0,1]) mirror([ix,0,0]) {
            for(iz=[50,-350]) {
                translate([125,0,iz]) for(ib=[0,25]) {
                    translate([-ib,0,-sign(iz)*(25-ib)]) rotate([90,0,0]) {
                        translate([0,0,5]) cylinder(r=40,h=125-2*5);
                        cylinder(r=40-5,h=125);
                    }
                }
            }
        }
        translate([0,(pow(125,2)+pow(37.5,2))/(2*37.5)-37.5,-500]) cylinder(r=(pow(125,2)+pow(37.5,2))/(2*37.5),h=1000);
    }
    
    hull() for(ix=[0,1]) mirror([ix,0,0])  {
        for(iz=[-75,-25]) {
            translate([50,0,iz]) rotate([90,0,0]) cylinder(r=15,h=125);
        }
    }
    for(ix=[0,1]) mirror([ix,0,0])  {
        for(iz=[-275]) {
            translate([100,0,iz]) rotate([90,0,0]) cylinder(r=25,h=125);
        }
    }
}

*int2();

//rotate([0,25-90,0]) 
rotate([0,15,0])
intersection() {
    difference() {
        union() {
            intersection() {
                int1();
                int2(10);
            }
    
            intersection() {
                hull() {
                    intersection() {
                        rotate([-15,0,0]) translate([0,10,0]) {
                            translate([0,0,-100]) cylinder(r=120+5,h=100+10);
                        }
                        int1();
                    }
                    intersection() {
                        rotate([-15,0,0]) translate([0,10,0]) {
                            translate([0,0,-100]) cylinder(r=120+5+10,h=100+10);
                        }
                        int1();
                        int2(10);
                    }
                }
                int1();
            }
        }
        
        int2();
        rotate([-15,0,0]) translate([0,10,10]) {
            translate([0,0,0]) cylinder(r=200,h=200);
            
            hull() {
                translate([0,5,-100]) cylinder(r=120-8-5,h=200);
                translate([0,-5,-100]) cylinder(r=120-8-5,h=200);
            }
        }
        
        hull() {
            intersection() {
                int2(5);
                rotate([-15,0,0]) translate([0,10,0]) translate([0,0,-100]) cylinder(r=200,h=100+10-2.5);
                rotate([-15,0,0]) translate([0,10,10]) hull() {
                    translate([0,5,-100]) cylinder(r=120-8-5,h=200);
                    translate([0,-5,-100]) cylinder(r=120-8-5,h=200);
                }
            }
            intersection() {
                int2();
                rotate([-15,0,0]) translate([0,10,0]) translate([0,0,-100]) cylinder(r=200,h=100);
                rotate([-15,0,0]) translate([0,10,10]) hull() {
                    translate([0,5,-100]) cylinder(r=120-8-5+5,h=200);
                    translate([0,-5,-100]) cylinder(r=120-8-5+5,h=200);
                }
            }
        }
        
        rotate([-15,0,0]) translate([0,10,10]) {
            for(i=[360/16/2:360/16:360]) rotate([0,0,i]) translate([120-8/2,0,0]) {
                rotate([0,0,-i+90]) {
                    echo(atan(sin(i)/tan(90-25)));
                    
                    translate([0,0,-50]) hull() cylinder_oh(1.75,50+20);
                    
                    translate([0,0,-50-1.6]) hull() {
                        cylinder_oh(3,50);
                        cylinder(r=0.01,h=50+3);
                    }
                    
                    *translate([0,0,-50-4]) hull() {
                        cylinder(r=3,h=50);
                        *for(ia=[-45,45]) rotate([0,0,ia]) translate([-50,0,0]) cylinder(r=3,h=50);
                        *translate([0,0,0]) sphere(r=3);
                        *translate([-50*tan(7.5),0,-50]) sphere(r=3);
                    }
                }
            }
        }
        
    }
    
    //uppper middle
    *union() {
        translate([-50,0,-50]) translate([0,-200,-37.5+25+(10-6)]) cube([100,400,400]);
        translate([-50,0,-50]) translate([0,0,-200]) cube([100,400,400]);
        hull() {
            intersection() {
                translate([-50,0,-50]) translate([0,-200,-37.5+25]) cube([100,400,400]);
                int2(6);
            }
            intersection() {
                translate([-50,0,-50]) translate([0,-200,-37.5+25+(10-6)]) cube([100,400,400]);
                int2(10);
            }
        }
        
        intersection() {
            translate([-50,0,-50]) translate([0,-200,-37.5]) cube([100,400,400]);
            
            int2(6);
        }
    }
    
    //wing
    union() {
        hull() {
            intersection() {
                translate([-50,0,-275]) {
                    rotate([0,-15,0]) rotate([0,0,90-22.5]) translate([-400,0,-37.5]) cube([400,400,75+50]);
                }
                int2(6);
            }
            intersection() {
                translate([-50,0,-275]) {
                    rotate([0,-15,0]) rotate([0,0,90-22.5]) translate([-400,10-6,-37.5]) cube([400,400,75+50]);
                }
                int2(10);
            }
        }
        intersection() {
            translate([-50,0,-275]) {
                rotate([0,-15,0]) rotate([0,0,90-22.5]) translate([-400,-25,-37.5]) cube([400,400,75+50]);
            }
            int2(6);
        }
    }
    
    //lower side
    *union() {
        difference() {
            translate([0,0,-50]) translate([-125,-200,-100-37.5]) cube([125,400,100+25]);
            hull() {
                intersection() {
                    translate([0,0,-50]) translate([-150-1,-200,-37.5]) cube([150+2,400,400]);
                    int2(6);
                }
                intersection() {
                    translate([0,0,-50]) translate([-150-1,-200,-37.5-6]) cube([150+2,400,400]);
                    int2(0);
                }
            }
        }
        
        
        difference() {
            union() {
                translate([-(50+37.5),-200,-275-37.5]) cube([50+37.5,400,200]);
                intersection() {
                    translate([-150,-200,-275-37.5-100]) cube([150,400,200]);
                    
                    translate([-50,0,-275]) {
                        rotate([0,-15,0]) rotate([0,0,90-22.5]) translate([-400,-400,-37.5]) cube([400,400,75+50]);
                    }
                }
            }
            
            hull() {
                intersection() {
                    translate([-50,0,-275]) {
                        rotate([0,-15,0]) rotate([0,0,90-22.5]) translate([-400,-25,-37.5-1]) cube([400,400,75+25]);
                    }
                    int2(6);
                }
                intersection() {
                    translate([-50,0,-275]) {
                        rotate([0,-15,0]) rotate([0,0,90-22.5]) translate([-400,-25-6,-37.5-1]) cube([400,400,75+25]);
                    }
                    int2(0);
                }
            }
        }
    }
    
    //upper side
    *union() {
        translate([-100,0,-50]) translate([-200,-200,-37.5+25+(10-6)]) cube([100+200-50,400,400]);
        translate([-100,0,-50]) translate([-200,0,-200]) cube([100+200-50,400,400]);
        hull() {
            intersection() {
                translate([-100,0,-50]) translate([-200,-200,-37.5+25]) cube([100+200-50,400,400]);
                int2(6);
            }
            intersection() {
                translate([-100,0,-50]) translate([-200,-200,-37.5+25+(10-6)]) cube([100+200-50,400,400]);
                int2(10);
            }
        }
        
        intersection() {
            translate([-100,0,-50]) translate([-200,-200,-37.5]) cube([100+200-50,400,400]);
            translate([-100,0,-50]) rotate([0,-25,0]) translate([-37.5,-200,-200]) cube([200,400,400]);
            
            int2(6);
        }
    }
}


module int2(outset=0) {
    //shoulders
    for(i=[0,1]) mirror([i,0,0]) translate([-100,0,-50]) hull() rotate([0,-25,0]) {
        rotate([0,0,-10]) {
            translate([0,-35,-15]) {
                rotate([0,-90,0]) translate([0,0,-100]) cylinder(r=75+outset,h=200);
                rotate([-45,0,0]) translate([0,100,0]) rotate([0,-90,0]) translate([0,0,0]) cylinder(r=75+outset,h=50);
            }
        }
    }

    //sides and back
    hull() for(i=[0,1]) mirror([i,0,0]) {
        translate([0,0,-275]) {
            translate([-55,0,0]) rotate([10,0,0]) {
                for(iy=[0,-20]) translate([0,iy,0]) rotate([0,-15,0]) {
                    translate([0,0,-100]) cylinder(r=110+outset,h=100+37.5);
                    translate([0,0,37.5]) sphere(r=110+outset);
                }
            }
        }
        translate([-75,-75,-200]) sphere(r=75+outset);
    }
    
    //shoulder blades and back
    hull() for(i=[0,1]) mirror([i,0,0]) {
        translate([-100,0,-50]) rotate([0,-25,0]) {
            rotate([0,0,-10]) {
                translate([0,-35,-15]) {
                    translate([-37.5,0,0]) sphere(r=75+outset);
                    translate([100,0,0]) sphere(r=75+outset);
                }
            }
        }
    
        translate([-75,-75,-100]) sphere(r=75+outset);
        translate([-75,-75,-200]) sphere(r=75+outset);
    }
}

module int1() {
    hull() for(i=[0,1]) mirror([i,0,0]) {
        translate([-50,0,-275]) {
            rotate([90,0,0]) cylinder(r=37.5,h=500);
        }
        translate([-50,0,-50]) {
            rotate([90,0,0]) cylinder(r=37.5,h=500);
        }
    }
        
    for(i=[0,1]) mirror([i,0,0]) translate([-100,0,-50]) rotate([0,-25,0]) hull() {
        rotate([90,0,0]) cylinder(r=37.5,h=500);
        rotate([-60,0,0]) {
            cylinder(r=37.5,h=500);
            translate([-37.5*tan(22.5),37.5,0]) cylinder(r=0.01,h=500);
            translate([-37.5,37.5*tan(22.5),0]) cylinder(r=0.01,h=500);
        }
    }
    
    hull() for(i=[0,1]) mirror([i,0,0]) translate([-100,0,-50]) rotate([0,-25,0]) {
        rotate([90,0,0]) cylinder(r=37.5,h=500);
        rotate([0,0,0]) cylinder(r=37.5,h=500);
    }
      
    hull() for(i=[0,1]) mirror([i,0,0]) translate([-100,0,-50]) {
        rotate([90,0,0]) cylinder(r=37.5,h=500);
        translate([(100-50),0,-(100-50)/tan(25)]) rotate([90,0,0]) cylinder(r=37.5,h=500);
    }
    
    for(i=[0,1]) mirror([i,0,0]) translate([-50,0,-275]) hull() {
        rotate([90,0,0]) cylinder(r=37.5,h=500);
        
        rotate([0,-15,0]) rotate([0,0,-90]) rotate([90,0,0]) {
            cylinder(r=37.5,h=500);
            translate([-37.5,-37.5*tan(22.5),0]) cylinder(r=0.01,h=500);
            translate([-37.5*tan(22.5),-37.5,0]) cylinder(r=0.01,h=500);
        }
    }
    
    hull() for(i=[0,1]) mirror([i,0,0]) translate([-50,0,-275]) {
        translate([0,0,30]) rotate([90,0,0]) cylinder(r=37.5,h=500);
        translate([-30*cos(15),0,-30*sin(15)]) rotate([90,0,0]) cylinder(r=37.5,h=500);
    }
}

/*
*translate([0,0,-500]) cylinder(r=150,h=500);


*rotate([-15,0,0]) difference() {
    cylinder(r=120+20,h=20);
    translate([0,0,-1]) cylinder(r=120,h=50);
}

*for(i=[0,1]) mirror([i,0,0]) translate([120,-20,-20]) rotate([0,0,22.5]) rotate([0,90-15,0]) translate([120,0,0]) difference() {
    cylinder(r=120+10,h=10);
    translate([0,0,-1]) cylinder(r=120,h=50);
}

module torso1a(outset=0) {
    hull() {
        intersection() {
            torso1(outset);
            rotate([-15,0,0]) translate([0,0,-100])  cylinder(r=120+10,h=100+20);
        }
        intersection() {
            torso1(outset+10);
            rotate([-15,0,0]) translate([0,0,-100])  cylinder(r=120,h=100+20);
        }
    }
}

module torso1(outset=0) {
    hull() {
        difference() {
            union() {
                sphere(r=50+outset);
                
                *rotate([-15,0,0]) translate([0,0,-20]) sphere(r=120);
                *rotate([-15,0,0]) translate([0,0,-20]) cylinder(r=120-8-outset,h=20+10);
                
                
                rotate([-15,0,0]) translate([0,0,0]) rotate_extrude() translate([120-20,0]) circle(r=5+outset);
                
                translate([0,-30,0]) {
                    for(ix=[0,1]) mirror([ix,0,0]) rotate([0,0,5]) rotate([0,25,0]) translate([100,0,0]) sphere(r=50+outset);
                }
            }
            translate([0,0,50]) cylinder(r=200,h=200);
        }
            
        translate([0,-30,0]) {
            for(ix=[0,1]) mirror([ix,0,0]) {
                
                translate([-90,80,-100]) sphere(r=50+outset);
                translate([-90,-50,-75]) sphere(r=50+outset);
            }
        }
    }
}

module torso2(outset=0) translate([0,-30,0]) hull() {
    sphere(r=50+outset);
    for(ix=[0,1]) mirror([ix,0,0]) rotate([0,0,5]) rotate([0,25,0]) translate([175,0,0]) sphere(r=50+outset);
        
    
    for(ix=[0,1]) mirror([ix,0,0]) {
        
        translate([-90,80,-100]) sphere(r=50+outset);
        
        translate([-90,100,-175]) sphere(r=50+outset);
        translate([-90,100,-200]) sphere(r=50+outset);
        
        translate([-25,50,-275]) sphere(r=100+outset);
        
        translate([-100,0,-150]) {
            sphere(r=100+outset);
            translate([150*tan(15),0,-150]) sphere(r=100+outset);
        }
        
        translate([-90,-50,-75]) sphere(r=50+outset);
        translate([-90,-50-20,-75-75]) sphere(r=50+outset);
        translate([-90,-50-20,-75-75-50]) sphere(r=50+outset);
    }
}


intersection() {
    difference() {
        union() {
            hull() {
                intersection() {
                    torso1(5+7.5+5);
                    rotate([-15,0,0]) translate([0,0,0]) sphere(r=120+2.5);
                }
                intersection() {
                    torso1(5+7.5);
                    rotate([-15,0,0]) translate([0,0,0]) sphere(r=120+2.5+5);
                }
            }
            
            rotate([-15,0,0]) translate([0,0,0])  cylinder(r=120+2.5,h=10);
            //torso1a(5+7.5);
            
            hull() {
                intersection() {
                    torso1(5+7.5+2.5);
                    torso2(5+7.5);
                }
                intersection() {
                    torso1(5+7.5);
                    torso2(5+7.5+2.5);
                }
            }
            
            torso1(5+7.5);
            torso2(5+7.5);
            
            *rotate([-15,0,0]) translate([0,0,-100])  cylinder(r=120,h=100+20);
        }
        
        rotate([-15,0,0]) translate([0,0,10]) {
            for(i=[360/16/2:360/16:360]) rotate([0,0,i]) translate([120-8/2,0,0]) {
                translate([0,0,-10]) cylinder(r=1.75,h=10);
                
                translate([0,0,-10-1.6]) hull() {
                    cylinder(r=3,h=10);
                    cylinder(r=0.01,h=10+3);
                }
                
                translate([0,0,-10-4]) hull() {
                    cylinder(r=3,h=10);
                    translate([-50,0,0]) cylinder(r=3,h=10);
                    translate([0,0,0]) sphere(r=3);
                    translate([-50*tan(7.5),0,-50]) sphere(r=3);
                }
            }
        }
        
        translate([0,-30,0]) {
            for(ix=[0,1]) mirror([ix,0,0]) {
                //shoulder screws
                rotate([0,0,5]) rotate([0,25,0]) {
                    for(ia=[15,-45]) rotate([ia,0,0]) mirror([0,(ia<0?1:0),0])  {
                        translate([137.5,0,50+5+7.5-3]) rotate([-90,0,0]) screw_co();
                    }
                }
                
                //front screws
                translate([-90,100,-175]) {
                    for(ia=[0,45]) rotate([0,0,ia]) translate([0,50+5+7.5-3,0]) rotate([0,0,180]) screw_co();
                }
                
                //back screws
                translate([-90,-50-20,-75-75]) {
                    for(ia=[-15]) rotate([0,0,ia]) translate([0,-(50+5+7.5-3),0]) screw_co();
                }
                translate([-100,0,-150]) {
                    for(ia=[-52.5]) rotate([0,0,ia]) translate([0,-(100+5+7.5-3),0]) screw_co();
                }
            }
                
            //front horizontal screw
            translate([0,100,-175]) {
                rotate([7.5,0,0]) translate([0,50+5+7.5-3,0]) rotate([00,90,0]) rotate([0,0,180]) screw_horiz_co();
            }
            //back horizontal screw
            translate([0,-50-20,-75-75]) {
                rotate([-7.5,0,0]) translate([0,-(50+5+7.5-3),0]) rotate([00,90,0]) mirror([0,1,0]) rotate([0,0,180]) screw_horiz_co();
            }
            translate([0,-50,-75]) {
                rotate([-7.5,0,0]) translate([0,-(50+5+7.5-3),0]) rotate([00,90,0]) mirror([0,1,0]) rotate([0,0,180]) screw_horiz_co();
            }
        }
        
        hull() {
            intersection() {
                torso1(5+5);
                rotate([-15,0,0]) translate([0,0,-100])  cylinder(r=120-8,h=100+5);
            }
            intersection() {
                torso1(5);
                rotate([-15,0,0]) translate([0,0,-100])  cylinder(r=120-8+5,h=100+5);
            }
        }
        
            
        hull() {
            intersection() {
                torso1(5+2.5);
                torso2(5);
            }
            intersection() {
                torso1(5);
                torso2(5+2.5);
            }
        }
        
        torso1(5);
        torso2(5);
        
        rotate([-15,0,0]) translate([0,0,10]) cylinder(r=200,h=200);
        rotate([-15,0,0]) translate([0,0,-50]) cylinder(r=120-8,h=200);
        
        
        for(ix=[0,1]) mirror([ix,0,0]) {
            arm_co(0);
            hull() {
                intersection() {
                    torso2(5);
                    arm_co(2.5);
                }
                intersection() {
                    torso2(5+2.5);
                    arm_co(0);
                }
            }
        }
        
        hull() for(ix=[0,1]) mirror([ix,0,0]) {
            translate([-75,-250,-300]) {
                rotate([-90,0,0]) cylinder(r=25,h=500);
                rotate([0,-15,0]) translate([-200,0,0]) rotate([-90,0,0]) cylinder(r=25,h=500);
                translate([-200,0,-200]) rotate([-90,0,0]) cylinder(r=25,h=500);
            }
        }
    }
    
    
        
    *translate([0,-30,0]) {
        rotate([0,0,5]) rotate([0,25,0]) intersection() {
            rotate([15,0,0]) translate([0,0,-100]) cube([200,200,200]);
            rotate([-45,0,0]) translate([0,-200,-100]) cube([200,200,200]);
        }
    }
    
     
    *translate([0,-30,0]) {
        intersection() {
            rotate([0,0,5]) rotate([0,25,0]) {
                rotate([-45,0,0]) translate([0,0,-250]) cube([500,500,500]);
            }
            translate([0,0,-175]) cube([500,500,500]);
        }
    }
    
    translate([0,-30,0]) {
        intersection() {
            rotate([0,0,5]) rotate([0,25,0]) {
                rotate([15,0,0]) translate([-500,-500,-250]) cube([1000,500,500]);
            }
            translate([0,-500,-75-75]) cube([500,500,500]);
        }
    }
}

*/

module screw_co() {
    translate([0,0,-0.01]) cylinder(r=1.75,h=50);
    translate([0,0,-8]) cylinder(r=1.25,h=8);
    
    translate([0,0,1.6]) {
        hull() {
            cylinder(r=3,h=50);
            translate([0,0,-3]) cylinder(r=0.01,h=50);
        }
        hull() {
            cylinder(r=3,h=50);
            translate([0,-10,0]) cylinder(r=3,h=50);
        }
    }
}
module screw_horiz_co() {
    translate([0,0,-0.01]) cylinder(r=1.75,h=5);
    translate([0,0,-8]) cylinder(r=1.25,h=8);
    
    translate([0,0,1.6]) {
        hull() {
            cylinder(r=3,h=5);
            translate([0,0,-3]) cylinder(r=0.01,h=5);
        }
        hull() {
            cylinder(r=3,h=5);
            translate([0,-10,0]) cylinder(r=3,h=5);
            translate([10,-10,0]) cylinder(r=3,h=5);
            
            translate([0,0,5]) sphere(r=3);
            translate([0,-50*tan(7.5),5+50]) sphere(r=3);
            translate([50*tan(7.5),-50*tan(7.5),5+50]) sphere(r=3);
        }
    }
}

module arm_co(outset=0) {
    hull() for(iz=[0,-175]) translate([120+50+75,0,iz]) {
        translate([0,0,0]) sphere(r=75+outset);
        rotate([0,15,0]) {
            rotate([0,0,-0]) translate([0,200,0]) sphere(r=75+outset);
            rotate([0,0,30]) translate([200,0,0]) sphere(r=75+outset);
            rotate([0,0,0]) translate([200,0,0]) sphere(r=75+outset);
        }
    }
}

module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}

*union() rotate([-15,0,0]) translate([0,10,20+5]) {
    union() {
        locked = 0;
        rotate([0,0,locked*22.5]) {
            for(i=[0:3]) rotate([0,0,i*90]) rotate([0,0,45]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring A.stl");
                
            for(i=[0]) rotate([0,0,i*90]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring B2.stl");
            for(i=[1:3]) rotate([0,0,i*90]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring B.stl");
        }
    }
    rotate([0,0,45-22.5]) {
        for(i=[0]) rotate([0,0,i*90]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring C2.stl");
        *for(i=[1:3]) rotate([0,0,i*90]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring C.stl");
        
        for(i=[0:3]) rotate([0,0,i*90]) rotate([0,0,45]) import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Neck Ring D.stl");
    }
    
    *union() {
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet A2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet B2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet C.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet E.stl");
    }
}