$fn = 32;

!union() {
    helmet_shape();
    
    
    *difference() {
        hull() rotate([15,0,0]) {
        translate([0,-20,0]) rotate([0,90,0]) rotate_extrude() {
            intersection() {
                translate([-20,0]) circle(r=120+20);
                translate([0,-200]) square([400,400]);
            }
        }
        translate([0,-20,-50]) rotate([0,90,0]) rotate_extrude() {
            intersection() {
                translate([-20,0]) circle(r=120+20);
                translate([0,-200]) square([400,400]);
            }
        }
    }
    }   
    
    *intersection() {
        sphere(r=120+20);
        translate([0,-200,-200]) cube([200,200,200]);
        
        
    }
    
    *translate([20,0]) {
        circle(r=120);
    
        rotate([0,0,-32.5]) translate([0,120+50]) {circle(r=50);
            #square([20+50,sqrt(pow(h3,2)-pow(20+50,2))]);
        }
        
        a1 = atan((-20+40)/(120+27.5-20));
        h1 = sqrt(pow(-20+40,2)+pow(120+27.5-20,2));
        a2 = 32.5;
        h2 = 120+50;
        
        
        a3 = a2-a1;
        h3 = sqrt(pow(h1,2)+pow(h2,2)-2*h1*h2*cos(a3));
        
        theta = acos((20+50)/h3);

        #translate([-20+40,120+27.5-20]) {
            circle(r=20);
            rotate([0,0,90-a2]) translate([0,-sqrt(pow(h3,2)-pow(20+50,2))]) square([20+50,sqrt(pow(h3,2)-pow(20+50,2))]);
        }
    
        *#polygon([
            [0,0],
            [0,120+27.5],
            [-20+40,120+27.5],
            [-20+40,120+27.5-20],
            [-20+40+20*cos(theta),120+27.5-20+20*sin(theta)],
            [(120+50)*sin(32.5),(120+50)*cos(32.5)],
        ]);
    }
    
    /*
    r2 = 20;
    a = 120+27.5;
    b = 120+20;
    theta = 2*atan(b-r2);
    r1 = (a-r2)/sin(theta)+r2;
    
    echo(theta);
    echo(r1-(r1-r2)*cos(180-theta));
    echo((r1-r2)*sin(theta)+r2);
    
    rotate([neck_angle,0,0]) {
        translate([0,-head_maj_rad-120+r1,-neck_hgt]) {
            cylinder(r=r1,h=neck_hgt);
            #rotate([0,0,180-theta]) translate([0,-r1+r2,0]) cylinder(r=r2,h=neck_hgt);
        }
    }*/
    
    *hull() {
        translate([0,0,-20]) rotate([0,90,0]) {
            cylinder(r=40,h=120+2.5+25);
            rotate([0,0,270]) intersection() {
                cylinder(r=40+2.5+25,h=120);
                cube([200,200,200]);
            }
            
            *translate([0,0,120+2.5+25-20]) rotate([0,0,270]) {
                rotate_extrude(angle=90) translate([40,0]) circle(r=20);
                translate([40,0,0]) sphere(r=20);
                rotate([0,0,90]) translate([40,0,0]) sphere(r=20);
            }
        }
        
        //rotate_extrude() translate([120-20,0]) circle(r=20);
        *translate([0,-20,0]) rotate_extrude() translate([sqrt(pow(120-20,2)-pow(20,2)),-20]) circle(r=20);
        
        *translate([0,-20,0]) sphere(r=120);
        *rotate([15,0,0]) {
            translate([0,-20,0]) sphere(r=120);
            translate([0,-20,-50]) sphere(r=120);
        }
    }
}


module plug(cutout=true,screwangles) translate([0,0,120-8]) {
    if (cutout) {
        translate([0,0,-20+1.2]) {
            //cylinder(r1=20+20,r2=20,h=20);
            hull() for(i=screwangles) rotate([0,0,i]) translate([10/sin(45),0,0]) {
                cylinder(r1=5+20,r2=5,h=20);
            }
        }
        
        for(i=screwangles) rotate([0,0,i]) translate([10/sin(45),0,-20+8-0.8]) cylinder(r=1.25,h=20);
            
    } else {
        difference() {
            
            hull() for(i=screwangles) rotate([0,0,i]) translate([10/sin(45),0,0]) {
                translate([0,0,0]) cylinder(r=5,h=1.2);
                translate([0,0,-2]) cylinder(r=5+2,h=1.2);
            }
            
            for(i=screwangles) rotate([0,0,i]) translate([10/sin(45),0,-20+8-0.8]) cylinder(r=1.75,h=20);
            for(i=screwangles) rotate([0,0,i]) translate([10/sin(45),0,-20+8-0.8]) cylinder(r=3,h=20);
        }
    }
    
}

/*for(ix=[0,1]) mirror([ix,0,0]) {
    translate([45,50,0]) rotate([-90,0,0]) translate([0,-(120-8+1.2),0]) rotate([0,0,90-asin((-(120+20)+(120+20)*cos(30-15)-50*sin(30-10))/(120))]) difference() {
        rotate([0,0,asin((-(120+20)+(120+20)*cos(30-15)-50*sin(30-10))/(120))]) {
            intersection() {
                rotate([0,0,-90]) rotate([-90,0,0]) difference() {
                    intersection() {
                        cylinder(r=50,h=120-8+1.2);
                        hull() plug_base_trans() translate([0,0,120+20-8-7.5+7.5]) {
                            cylinder(r1=7.5,r2=0,h=7.5);
                            translate([0,0,-50]) cylinder(r=7.5,h=50);
                        }
                    }
                    plug_base_trans() {
                        cylinder(r=1.75,h=200);
                        cylinder(r=3,h=120-1.25-0.8-8);
                    }
                }
                cylinder(r=200,h=100);
            }
                
        }
        place_on_ring() helmet_shape(-8,true);
        translate([0,0,-0.01]) cylinder(r=120-8,h=20+50);
    }
}*/
    
    
//side plugs
//*translate([45,50+40,0]) rotate([-90,0,0]) translate([0,-(120-8+1.2),0]) rotate([0,0,90]) !
*difference() {
    rotate([0,90,0]) difference() {     
        plug_rad = 120;
    
        intersection() {
            cylinder(r=50,h=plug_rad-8+1.2);
            translate([0,0,plug_rad-0.8-8]) cylinder(r=50,h=50);
            hull() plug_side_trans() translate([0,0,plug_rad-8-20+7.5-0.5]) cylinder(r1=20,r2=0,h=20);
            hull() plug_side_trans() cylinder(r=1.75+2.4,h=200);
        }
        plug_side_trans() {
            hull() {
                cylinder(r=1.75,h=plug_rad-0.625-0.8);
                cylinder(r=1.75-0.625,h=plug_rad-0.8);
            }
            cylinder(r1=3+plug_rad-0.8-8,r2=3,h=plug_rad-0.8-8);
        }
    }
    //helmet_shape(-8,true);
}

//front base
//*translate([0,20,0]) rotate([-90,0,0]) translate([0,-(120-8+1.2),0]) rotate([0,0,-180]) 
*difference() {
    rotate([-90,0,0]) difference() {      
        plug_rad = 120;
    
        intersection() {
            cylinder(r=50,h=plug_rad-8+1.2);
            translate([0,0,plug_rad-8+1.2-3.2]) cylinder(r=50,h=50);
            hull() plug_base_trans() translate([0,0,plug_rad-8-20+7.5-0.5]) cylinder(r1=20,r2=0,h=20);
            hull() plug_base_trans() cylinder(r=1.75+2.4,h=200);
        }
        plug_base_trans() {
            hull() {
                cylinder(r=1.75,h=plug_rad-0.625-0.8);
                cylinder(r=1.75-0.625,h=plug_rad-0.8);
            }
            cylinder(r1=3+plug_rad-0.8-8,r2=3,h=plug_rad-0.8-8);
        }
    }
    translate([0,0,-100]) cylinder(r=200,h=100);
    translate([0,0,-2]) place_on_ring() helmet_shape(-8-2);
    *translate([0,0,-0.01]) cylinder(r=120-8-1,h=20+50);
    translate([0,0,-0.01]) cylinder(r1=120-8+0.75,r2=120-8-10,h=0.75+10);
}

//back base
//translate([0,20,0]) rotate([-90,0,0]) translate([0,-(120-8+1.2),0]) rotate([0,0,-180]) 
*difference() {
    rotate([90,0,0]) difference() {      
        plug_rad = 120;
    
        intersection() {
            cylinder(r=50,h=plug_rad-8+1.2);
            translate([0,0,plug_rad-8+1.2-3.2]) cylinder(r=50,h=50);
            hull() plug_base_trans() translate([0,0,plug_rad-8-20+7.5-0.5]) cylinder(r1=20,r2=0,h=20);
            hull() plug_base_trans() cylinder(r=1.75+2.4,h=200);
        }
        plug_base_trans() {
            hull() {
                cylinder(r=1.75,h=plug_rad-0.625-0.8);
                cylinder(r=1.75-0.625,h=plug_rad-0.8);
            }
            cylinder(r1=3+plug_rad-0.8-8,r2=3,h=plug_rad-0.8-8);
        }
    }
    translate([0,0,-100]) cylinder(r=200,h=100);
    *place_on_ring() helmet_shape(-8-1,true);
    *translate([0,0,-0.01]) cylinder(r=120-8-1,h=20+50);
    translate([0,0,-0.01]) cylinder(r1=120-8+0.75,r2=120-8-10,h=0.75+10);
}

//top
//*for(iy=[60,100]) translate([0,iy,0]) rotate([-90,0,0]) translate([0,-(120+20-8+1.2),0]) rotate([0,0,-180]) !
*difference() {
    rotate([90,0,0]) difference() {
        plug_rad = 120+20;
        
        intersection() {
            cylinder(r=50,h=plug_rad-8+1.2);
            translate([0,0,plug_rad-8+1.2-3.2]) cylinder(r=50,h=50);
            hull() plug_back_trans() translate([0,0,plug_rad-8-20+7.5-0.5]) cylinder(r1=20,r2=0,h=20);
            hull() plug_back_trans() cylinder(r=1.75+2.4,h=200);
        }
        plug_back_trans() {
            hull() {
                cylinder(r=1.75,h=plug_rad-0.625-0.8);
                cylinder(r=1.75-0.625,h=plug_rad-0.8);
            }
            cylinder(r1=3+plug_rad-0.8-8,r2=3,h=plug_rad-0.8-8);
        }
    }
    *helmet_shape(-8-1,true);
}

//top front
*difference() {
    rotate([90,0,0]) difference() {
        plug_rad = 120+50;
        
        intersection() {
            cylinder(r=50,h=plug_rad-8+1.2);
            translate([0,0,plug_rad-8+1.2-3.2]) cylinder(r=50,h=50);
            hull() plug_front_trans() translate([0,0,plug_rad-8-20+7.5-0.5]) cylinder(r1=20,r2=0,h=20);
            hull() plug_front_trans() translate([0,0,100]) cylinder(r=1.75+2.4,h=100);
        }
        plug_front_trans() {
            hull() {
                cylinder(r=1.75,h=plug_rad-0.625-0.8);
                cylinder(r=1.75-0.625,h=plug_rad-0.8);
            }
            cylinder(r1=3+plug_rad-0.8-8,r2=3,h=plug_rad-0.8-8);
        }
    }
    *helmet_shape(-8-1,true);
}

module plug_base_trans() {
    for(iy=[-1,1]) rotate([0,iy*asin(10/(120-8)),0]) {
        for(iz=[-1,1]) translate([0,iz*10,0]) children();
    }
}
module plug_back_trans() {
    for(iy=[-1,1]) rotate([0,iy*asin(10/(120-8)),0]) {
        for(iz=[-1,1]) rotate([iz*asin(10/(120+20-8)),0,0])  children();
    }
}
module plug_front_trans() {
    for(iy=[-1,1]) translate([0,0,50]) rotate([0,iy*asin(10/(120-8)),0]) translate([0,0,-50]) {
        for(iz=[-1,1]) rotate([iz*asin(10/(120+50-8)),0,0])  children();
    }
}
module plug_side_trans() {
    for(iz=[-1,1]) translate([10,iz*10,0]) children();
    for(ia=[-60,0,60]) rotate([0,0,ia]) translate([-10/sin(45),0,0]) children();
}

//!translate([0,dat_neckring_bottom_y,dat_neckring_bottom_z]) rotate([-face_angle,0,0]) 
intersection() {
    difference() {
        union() {
            place_on_ring() helmet_shape();
            place_on_ring() helmet_ears();
            cylinder(r=120,h=20);
            
            
            for(i=[0:8-1]) rotate([0,0,(i+0.5)*360/8]) {
                $fn=$fn*4;
                
                for(j=[0,1]) mirror([j,0,0]) {
                    difference() {
                        intersection() {
                            union() {
                                hull() {
                                    cylinder(r=120+7.5,h=5-2);
                                    cylinder(r=120+7.5-2,h=5);
                                }
                                
                                hull() {
                                    cylinder(r=120,h=5+1);
                                    cylinder(r=120+1,h=5);
                                }
                            }
                            linear_extrude(height=10,convexity=10) polygon([
                                [0,0],
                                [0,200],
                                [20-2,200],
                                [20-2,sqrt(pow(120+7.5-2,2)-pow(20-2,2))],
                                [20,sqrt(pow(120+7.5-2,2)-pow(20-2,2))],
                                [20,sqrt(pow(120+2,2)-pow(20+2,2))],
                                [20+2,sqrt(pow(120+2,2)-pow(20+2,2))],
                            ]);
                        }
                        translate([20+2,sqrt(pow(120+2,2)-pow(20+2,2)),0]) {
                            translate([0,0,-1]) cylinder(r=2,h=50);
                            
                            hull() {
                                translate([0,0,5-2]) cylinder(r=2,h=50);
                                translate([0,0,5+1]) cylinder(r=2+2+1,h=50);
                                
                                translate([0,20,5-2]) cylinder(r=2,h=50);
                                translate([0,20,5+1]) cylinder(r=2+2+1,h=50);
                            }
                        }
                    }
                    translate([20-2,sqrt(pow(120+7.5-2,2)-pow(20-2,2)),0])hull() {
                        cylinder(r=2,h=5-2);
                        cylinder(r=0.01,h=5);
                    }
                }
            }
        }
        
        place_on_ring() helmet_shape(-8);
        place_on_ring() helmet_viewport();
        translate([0,0,-1]) cylinder(r=120-8,h=1+20+50);
        translate([0,0,-0.01]) cylinder(r1=120-8+0.75,r2=120-8,h=0.75);
        
        place_on_ring() for(ix=[0,1]) mirror([ix,0,0]) {
            //cable ports on back of neck
            rotate([neck_angle,0,0]) translate([0,-head_maj_rad,-50/2]) rotate([0,0,22.5]) rotate([90,0,0]) {
                rotate([0,0,-atan(sin(22.5)/tan(90-neckring_angle))]) {
                    hull() {
                        cylinder(r=10+0.5,h=200);
                        translate([-(10+0.5)*tan(22.5),0,0]) cube([2*(10+0.5)*tan(22.5),(10+0.5),200]);
                    }
                    hull() {
                        cylinder(r=10+0.5+0.5,h=head_min_rad+5-5);
                        translate([-(10+0.5+0.5)*tan(22.5),0,0]) cube([2*(10+0.5+0.5)*tan(22.5),(10+0.5+0.5),head_min_rad+5-5]);
                        
                        cylinder(r=10+0.5,h=head_min_rad+5-5+0.5);
                        translate([-(10+0.5)*tan(22.5),0,0]) cube([2*(10+0.5)*tan(22.5),(10+0.5),head_min_rad+5-5+0.5]);
                    }
                    translate([0,0,head_min_rad+5]) hull() {
                        translate([0,0,-1.6*cos(22.5)]) {
                            cylinder(r=10+0.5,h=200);
                            translate([-(10+0.5)*tan(22.5),0,0]) cube([2*(10+0.5)*tan(22.5),(10+0.5),200]);
                        }
                        
                        cylinder(r=10+0.5+1.6*sin(22.5),h=200);
                        translate([-(10+0.5+1.6*sin(22.5))*tan(22.5),0,0]) cube([2*(10+0.5+1.6*sin(22.5))*tan(22.5),(10+0.5+1.6*sin(22.5)),200]);
                    }
                }
                
                hull() {
                    cylinder(r=20-(8-5)/sin(45),h=head_min_rad+5-5);
                    cylinder(r=20-(8-5)/sin(45)+20,h=head_min_rad+5-5-20);
                }
            }
        
            //screws to mount visor pivot assembly
            translate([head_min_rad+5-8,0,-20]) {
                for(i=[0:2]) translate([0,0,0]) {
                    rotate([30+15,0,0]) translate([0,-20,0]) rotate([0,90,0]) cylinder(r=1.25,h=50);
                    rotate([30+120+5,0,0]) translate([0,-32.5,0]) rotate([0,90,0]) cylinder(r=1.25,h=50);
                    rotate([30+240+45,0,0]) translate([0,-25,0]) rotate([0,90,0]) cylinder(r=1.25,h=50);
                }
            }
                
            //cutout for clearance for visor moving parts
            translate([head_min_rad+5-5,0,-20]) {
                rotate([90,0,0]) rotate([0,90,0]) {
                    for(j=[0:1/($fn/2):1-1/($fn/2)]) {
                    
                        hull() for(i=[j,j+1/($fn/2)]) translate([i*7.5,0,0]) rotate([0,0,pow(i,4)*60]) {
                            translate([20,0,0]) cylinder(r1=4+0.4,r2=4+0.4+10,h=10);
                        }
                    }
                    hull() for(j=[0,1]) translate([j*7.5,0,0]) {
                        translate([0,0,0]) cylinder(r1=4+0.4,r2=4+0.4+10,h=10);
                    }
                }
            }
        }
         
    
        rotate([0,0,asin(-(dat_neckring_bottom_y*cos(face_angle)-dat_neckring_bottom_z*sin(face_angle))/120)]) {
            for(i=[0,1]) mirror([i,0,0]) {
                rotate([-face_angle*0,0,0]) rotate([0,0,0*asin((-(120+20)+(120+20)*cos(neck_angle)-50*sin(neck_angle))/(120))]) {
                    rotate([0,0,-90]) rotate([-90,0,0]) {
                        intersection() {
                            cylinder(r=50,h=120-8+1.2);
                            hull() plug_base_trans() translate([0,0,120-8-20+7.5]) cylinder(r1=20,r2=0,h=20);
                        }
                        plug_base_trans() {
                            cylinder(r=1.25,h=120-1.25-0.8);
                            translate([0,0,120-1.25-0.8]) sphere(r=1.25);
                        }
                    }
                }
            }
        }
        
        for(i=[0,180]) {
            rotate([0,0,i]) {
                rotate([-90,0,0]) {
                    intersection() {
                        cylinder(r=50,h=120-8+1.2);
                        hull() plug_base_trans() translate([0,0,120-8-20+7.5]) cylinder(r1=20,r2=0,h=20);
                    }
                    plug_base_trans() {
                        cylinder(r=1.25,h=120-1.25-0.8);
                        translate([0,0,120-1.25-0.8]) sphere(r=1.25);
                    }
                }
            }
        }
        
        place_on_ring() rotate([-face_angle,0,0]) {
            //back, top plug
            for(i=[30,90]) rotate([i,0,0]) {
                intersection() {
                    cylinder(r=50,h=120+20-8+1.2);
                    hull() plug_back_trans() translate([0,0,120+20-8-20+7.5]) cylinder(r1=20,r2=0,h=20);
                }
                plug_back_trans() {
                    cylinder(r=1.25,h=120+20-1.25-0.8);
                    translate([0,0,120+20-1.25-0.8]) sphere(r=1.25);
                }
            }
            
            //side plugs
            for(i=[0,1]) mirror([i,0,0]) rotate([0,90,0]) {
                intersection() {
                    cylinder(r=50,h=120-8+1.2);
                    hull() plug_side_trans() translate([0,0,120-8-20+7.5]) cylinder(r1=20,r2=0,h=20);
                }
                plug_side_trans() {
                    cylinder(r=1.25,h=120-1.25-0.8);
                    translate([0,0,120-1.25-0.8]) sphere(r=1.25);
                }
            }
        }
        
        place_on_ring() {
            //front plug
            translate([0,0,-(120+50)*0]) rotate([-asin(-(-20+50)*sin(180-30)/(120+20+(-20+50)))*0,0,0]) translate([0,0,-(-20+50)]) rotate([-(60-face_angle-asin(sin(180-(60-face_angle))*(-20+50)/(120+50))),0,0]) {
                intersection() {
                    cylinder(r=50,h=120+50-8+1.2);
                    hull() plug_front_trans() translate([0,0,120+50-8-20+7.5]) cylinder(r1=20,r2=0,h=20);
                }
                plug_front_trans() {
                    cylinder(r=1.25,h=120+50-1.25-0.8);
                    translate([0,0,120+50-1.25-0.8]) sphere(r=1.25);
                }
            }
        }
    }
    
    
    translate([0,0,00]) place_on_ring() rotate([-face_angle,0,0]) {
        *translate([0.2,0.2,-200-0.2]) cube([200,200,200]);
        
        *translate([0.2,-200-0.2,-200-0.2]) cube([200,200,200]);
        
        for(i=[/*0,60,120*/0]) rotate([i,0,0]) intersection() {
            translate([0.2,0.2,0.2]) cube([200,200,200]);
            rotate([-30,0,0]) translate([0.2,0.2,0.2]) cube([200,200,200]);
        }
    }
    
    //translate([0,-200,0]) cube([200,400,145]);
}

module boule(inset=0,xor=0,tor_a=360) rotate([0,90,0]) {
    rotate_extrude(angle=tor_a) {
        intersection() {
            translate([xor,0]) circle(r=120+inset);
            translate([0,-120]) square([500,2*120]);
        }
        if(xor>0) translate([0,-(120+inset)]) square([xor,2*(120+inset)]);
    }
}

module place_on_ring() {
    /*translate([0,-(120+20),--20]) 
        rotate([--30,0,0])
            translate([0,--(120+20),0])
                translate([0,--20,--50]) 
                    rotate([-(30-10),0,0]) children();*/
    
    rotate([face_angle,0,0]) translate([0,-dat_neckring_bottom_y,-dat_neckring_bottom_z]) children();
    
    *translate([0,-(dat_neckring_bottom_y*cos(face_angle)-dat_neckring_bottom_z*sin(face_angle)),-(dat_neckring_bottom_z*cos(face_angle)+dat_neckring_bottom_y*sin(face_angle))]) rotate([face_angle,0,0]) children();
}


head_min_rad = 120;
head_maj_rad = 20;

face_angle = 15;
face_outset = 40;
face_top = 25;
face_bottom = -100;

neckring_angle = 30;
neckring_hgt = 20;

neck_hgt = 50;
neck_angle = neckring_angle-face_angle;

dat_faceplate_bottom_y = face_outset;
dat_faceplate_bottom_z = face_bottom;

/*dat_chin_bottom_y = dat_faceplate_bottom_y-head_min_rad+head_min_rad*cos(face_angle);
dat_chin_bottom_z = dat_faceplate_bottom_z-head_min_rad*sin(face_angle);*/

dat_neck_bottom_y = -head_maj_rad*cos(neck_angle)+neck_hgt*sin(neck_angle);
dat_neck_bottom_z = -head_maj_rad*sin(neck_angle)-neck_hgt*cos(neck_angle);

dat_nape_org_y = dat_neck_bottom_y-(head_min_rad+20)*cos(neck_angle);
dat_nape_org_z = dat_neck_bottom_z-(head_min_rad+20)*sin(neck_angle);

dat_nape_bottom_y = dat_nape_org_y+(head_min_rad+20)*cos(face_angle);
dat_nape_bottom_z = dat_nape_org_z-(head_min_rad+20)*sin(face_angle);

dat_neckring_bottom_y = dat_nape_bottom_y-neckring_hgt*sin(face_angle);
dat_neckring_bottom_z = dat_nape_bottom_z-neckring_hgt*cos(face_angle);

module helmet_viewport() {
    viewport_crn_r = 40;
    viewport_w_a = 120+22.5;
    
    viewport_inset = -2.5;
    
    translate([0,40,0]) {
        for(ix=[0,1]) mirror([ix,0,0]) {
            for(j=[0:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
                for(iz=[-100,25]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-8-0.1,0]) rotate([-90,0,0]) cylinder(r=0.01,h=20,$fn=8);
                    }
                }
            }
        }
        
        for(ix=[0,1]) mirror([ix,0,0]) {
            for(j=[0:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
                for(iz=[-100,25]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-2-1,0]) rotate([-90,0,0]) cylinder(r1=0,r2=20,h=20,$fn=8);
                    }
                }
            }
            
            for(j=[0:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
                for(iz=[-100,25]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_inset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_inset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-8-20+1,0]) rotate([-90,0,0]) cylinder(r1=20,r2=0,h=20,$fn=8);
                    }
                }
            }
        }
        
        viewport_gsk_outset = 7.5;
        
        for(ix=[0,1]) mirror([ix,0,0]) {
            for(j=[0:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
                for(iz=[-100,25]) translate([0,0,iz]) mirror([0,0,(iz>0?1:0)]) {
                    translate([0,0,viewport_crn_r-(viewport_crn_r+viewport_gsk_outset)*cos(i)]) {
                        rotate([0,0,viewport_w_a/2+(-viewport_crn_r+(viewport_crn_r+viewport_gsk_outset)*sin(i))/(120*2*3.1415)*360]) translate([0,120-2,0]) rotate([-90,0,0]) cylinder(r1=0,r2=20,h=20,$fn=8);
                    }
                }
            }
        }
        
        rotate([0,0,(180-viewport_w_a)/2+viewport_crn_r/(120*2*3.1415)*360]) rotate_extrude(angle=viewport_w_a-2*viewport_crn_r/(120*2*3.1415)*360) {
            polygon([
                [(120-8-0.02)+20,-100-viewport_inset],
                [(120-8-0.02),-100-viewport_inset],
                [(120-8-0.02),25+viewport_inset],
                [(120-8-0.02)+20,25+viewport_inset],
            ]);
            polygon([
                [(120-2-1)+20,-100-viewport_inset-20],
                [(120-2-1),-100-viewport_inset],
                [(120-2-1),25+viewport_inset],
                [(120-2-1)+20,25+viewport_inset+20],
            ]);
            polygon([
                [(120-8+1)-20,-100-viewport_inset-20],
                [(120-8+1),-100-viewport_inset],
                [(120-8+1),25+viewport_inset],
                [(120-8+1)-20,25+viewport_inset+20],
            ]);
            polygon([
                [(120-2)+50,-100-viewport_gsk_outset-50],
                [(120-2),-100-viewport_gsk_outset],
                [(120-2),25+viewport_gsk_outset],
                [(120-2)+50,25+viewport_gsk_outset+50],
            ]);
        }
    }
}

module helmet_ears() {
    for(j=[45:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
        intersection() {
            translate([-200,0,-20]) rotate([0,90,0]) cylinder(r=40+(5/(sqrt(2)-1))-(5*sqrt(2)/(sqrt(2)-1))*cos(i),h=400);
            helmet_shape((5*sqrt(2)/(sqrt(2)-1))-(5*sqrt(2)/(sqrt(2)-1))*sin(i));
        }
        if (i==45) translate([-(head_min_rad+5),0,-20]) rotate([0,90,0]) cylinder(r=40,h=2*(head_min_rad+5));
    }
    
    for(ix=[0,1]) mirror([ix,0,0]) for(j=[45:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
        intersection() {
            rotate([neck_angle,0,0]) translate([0,-head_maj_rad,-50/2]) rotate([0,0,22.5]) rotate([90,0,0]) cylinder(r=20+(5/(sqrt(2)-1))-(5*sqrt(2)/(sqrt(2)-1))*cos(i),h=400);
            helmet_shape((5*sqrt(2)/(sqrt(2)-1))-(5*sqrt(2)/(sqrt(2)-1))*sin(i),true);
        }
        if (i==45) rotate([neck_angle,0,0]) translate([0,-head_maj_rad,-50/2]) rotate([0,0,22.5]) rotate([90,0,0]) cylinder(r=20,h=head_min_rad+5);
    }
    
    for(k=[15,15-45]) rotate([-20+k,0,0]) for(j=[45:360/($fn/2):90-360/($fn/2)]) hull() for(i=[j,j+360/($fn/2)]) {
        intersection() {
            hull() for(ix=[0,1]) mirror([ix,0,0]) translate([0,-head_maj_rad,0]) rotate([0,0,(k==15?45:60)]) rotate([90,0,0]) cylinder(r=5+(5/(sqrt(2)-1))-(5*sqrt(2)/(sqrt(2)-1))*cos(i),h=400);
            
            helmet_shape((5*sqrt(2)/(sqrt(2)-1))-(5*sqrt(2)/(sqrt(2)-1))*sin(i),true);
        }
        *if (i==45) hull() for(ix=[0,1]) mirror([ix,0,0]) translate([0,-head_maj_rad,0]) rotate([0,0,22.5]) rotate([90,0,0]) cylinder(r=5,h=head_min_rad+5);
    }
}

module helmet_shape(inset=0,simplified=false) {
    
    face_outset = 20;
    face_angle = 15+0;
    neck_angle = 15;
    neckring_angle = face_angle+neck_angle;
    
    //main datum is the origin of the main toroid
    hull() {
        //main toroid - this is the base shape of the helmet
        rotate([-90,0,0]) boule(inset,head_maj_rad,180);
        translate([0,-20,0]) sphere(r=head_min_rad);
        
        //back of the neck - extends down from the torus (on the major rad) towards the neck ring
        rotate([neck_angle,0,0]) {
            translate([0,-head_maj_rad,-neck_hgt]) cylinder(r=head_min_rad+inset,h=neck_hgt);
        }
        
        //brow that softens the edge of the faceplate
        translate([0,face_outset,face_top]) rotate_extrude() {
            translate([head_min_rad-30,0]) circle(r=30+inset);
        }
        translate([0,face_outset,face_bottom]) rotate_extrude() {
            translate([head_min_rad-30,0]) circle(r=30+inset);
        }
        *rotate([neck_angle,0,0]) translate([0,-head_maj_rad,-neck_hgt]) rotate_extrude() {
            translate([head_min_rad-30,0]) circle(r=30+inset);
        }
        
        //forehead to smooth transition from faceplate to head
        translate([0,face_outset+head_min_rad-50,25]) boule(inset,-head_min_rad+50);
        
        //top of the head for more smoothing in transition from forehead
        //adjust the major rad of this torus as needed
        *translate([0,0,head_maj_rad-50]) mirror([0,1,0]) rotate([180,0,0]) boule(inset,50,45+5);
        translate([0,-20,-75]) mirror([0,1,0]) rotate([180,0,0]) difference() {
            boule(inset,75,45-15);
            rotate([0,90,0]) translate([0,0,-200]) cylinder(r=75,h=400);
        }
    }
    
    
    *rotate([neck_angle,0,0]) {
        translate([0,-head_maj_rad,-neck_hgt]) {
            translate([0,-(head_min_rad+head_maj_rad),0]) rotate([-neckring_angle,0,0]) translate([0,(head_min_rad+head_maj_rad),-neckring_hgt+0.01]) {
                cylinder(r=head_min_rad+inset,h=neckring_hgt+10);
            }
        }
    }
    
    delta_z = dat_faceplate_bottom_z-dat_neckring_bottom_z;
    delta_y = dat_faceplate_bottom_y-dat_neckring_bottom_y;
    
    hyp = sqrt(pow(delta_z,2)+pow(delta_y,2));
    
    theta = atan((delta_z)/(delta_y));
    //echo(theta);
    
    csr = hyp/sin(90+45)*sin(90-face_angle-theta);
    
    csr2 = hyp/sin(90+45)*sin(180-135-(90-face_angle-theta));
    
    //echo(csr2);
    
    
    
    *translate([0,dat_faceplate_bottom_y,dat_faceplate_bottom_z]) {
        sphere(r=10);
        //rotate([0,0,0]) cylinder(r=120,h=20);
    }
    *translate([0,dat_neckring_bottom_y,dat_neckring_bottom_z]) {
        sphere(r=10);
        //#rotate([-10,0,0]) cylinder(r=120,h=20);
        
        rotate([-10,0,0]) {
            cylinder(r=10,h=csr2);
            translate([0,0,csr2]) {
                rotate([-45,0,0]) {
                    cylinder(r=10,h=csr);
                }
            }
        }
        
        rotate([-90+theta,0,0]) cylinder(r=10,h=hyp);
    }
    
    //csr2 = sqrt()
    
    intersection() {
        union() {
            hull() for(iy=[0,200]) translate([0,iy,0]) boule(inset,head_maj_rad);
            rotate([neck_angle,0,0]) translate([0,-head_maj_rad,-neck_hgt]) {
                //back of the neck
                translate([0,0,-0.01]) {
                    hull() for(iy=[0,200]) translate([0,iy,0]) cylinder(r=head_min_rad+inset,h=neck_hgt);
                }
            
                //nape of the neck - transition from the neck to the neckring
                rotate([0,0,90]) translate([-(head_min_rad+20),0,0]) rotate([90,0,0]) rotate_extrude(angle=-neckring_angle) {
                    hull() for(iy=[0,200]) translate([(head_min_rad+20)+iy,0]) circle(r=head_min_rad+inset);
                }
                
                //neck ring axis - aligns with the neck ring
                translate([0,-(head_min_rad+head_maj_rad),0]) rotate([-neckring_angle,0,0]) translate([0,(head_min_rad+head_maj_rad),-neckring_hgt+0.01]) {
                    hull() for(iy=[0,200]) translate([0,iy,0]) cylinder(r=head_min_rad+inset,h=neckring_hgt);
                }
            }
        }
        
        if(!simplified) union() translate([0,face_outset,face_bottom]) {
            //face plate
            translate([0,0,-0.01]) {
                hull() for(iy=[0,-200]) translate([0,iy,0]) cylinder(r=head_min_rad+inset,h=-face_bottom);
            }
            
            //chin to match the angle of the neckring
            rotate([90,0,0]) mirror([0,1,0]) boule(inset,0,face_angle);
            
            
            union() rotate([-face_angle,0,0]) {
                //nbr1 = 15;
                //nbr2 = 5;
                
                nbr1 = 25;
                nbr2 = 25;
                
                csr_l = csr-nbr1*tan(45/2)-nbr2*tan(45/2);
                
                for(j=[0:360/($fn):45-360/($fn)]) hull() for(iy=[0,-200]) for(i=[j,j+360/($fn)]) {
                    translate([0,iy-(nbr1+inset)+(nbr1+inset)*cos(i),-(nbr1+inset)*sin(i)]) cylinder(r=head_min_rad+inset,h=0.01);
                }
                
                hull() for(iy=[0,-200]) {
                    translate([0,iy-(nbr1+inset)+(nbr1+inset)*cos(45),-(nbr1+inset)*sin(45)]) {
                        cylinder(r=head_min_rad+inset,h=0.01);
                        translate([0,-csr_l*cos(45),-csr_l*sin(45)]) cylinder(r=head_min_rad+inset,h=0.01);
                    }
                }
                
                translate([0,-(nbr1+inset)+(nbr1+inset)*cos(45),-(nbr1+inset)*sin(45)]) {
                    translate([0,-csr_l*cos(45),-csr_l*sin(45)]) {
                        translate([0,(nbr2-inset)*cos(45),-(nbr2-inset)*sin(45)]) {
                            for(j=[0:360/($fn):45-360/($fn)]) hull() for(iy=[0,-200]) for(i=[j,j+360/($fn)]) {
                                translate([0,iy-(nbr2-inset)*cos(i),(nbr2-inset)*sin(i)]) cylinder(r=head_min_rad+inset,h=0.01);
                            }
                        }
                    }
                }
                
                /*translate([0,-csr*cos(45)-10+10*cos(45),-csr*sin(45)-2*10*sin(45)]) {
                    for(j=[0:360/($fn):45-360/($fn)]) hull() for(i=[j,j+360/($fn)]) {
                        translate([0,-10*cos(i),10*sin(i)]) cylinder(r=head_min_rad,h=0.01);
                    }
                    
                }*/
                /**rotate_extrude() {
                    translate([head_min_rad-15,0]) circle(r=15+inset);
                }
                *translate([0,-50*tan(45+10),-50]) rotate_extrude() {
                    translate([head_min_rad-20,0]) circle(r=20+inset);
                }*/
            }
        }
    }
    
    //translate([0,40,-100]) cylinder(r=120+inset,h=100+25);
}

module cornerplate_co(screw_angles=[0,90,180,270]) {
    cylinder(r1=25,r2=25+20,h=20);
    for(i=screw_angles) rotate([0,0,i]) translate([10,10,-10]) cylinder(r=1.25,h=20);
}
