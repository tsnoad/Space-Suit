$fn = 72;


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

bev_l = 0.8;
bev_s = 0.4;
bev_xs = 0.2;

clr_h = 0.4;

ret_tab_r = 120+4; //tabs on base ring to limit rotation of lock ring



rotate([0,0,180]) translate([0,0,15]) union() {
    rotate([0,0,0]) {
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
    
    union() {
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet A2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet B2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet C.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet E.stl");
    }
}

*rotate([-15,0,0]) translate([0,15,5]) difference() {
    union() {
        translate([0,0,-5-10]) cylinder(r=120+7.5+2.5,h=5+5);
        translate([0,0,-10]) cylinder(r=120+7.5+7.5,h=5+10+5);
    }
    translate([0,0,-50]) cylinder(r=120-8,h=100);
    translate([0,0,0]) cylinder(r=120+7.5,h=100);
}

*sphere(r=25);
*for(i=[0,1]) mirror([i,0,0]) difference() {
    rotate([0,20,0]) hull() {
        rotate([0,90,0]) cylinder(r=25,h=250);
        rotate([30,0,0]) translate([0,0,-100+25]) intersection() {
            rotate([0,90,0]) cylinder(r=100,h=250);
            mirror([0,1,0]) cube([250,100,100]);
        }
        rotate([-30,0,0]) translate([0,25,0]) {
            rotate([0,90,0]) cylinder(r=25,h=250);
            rotate([-30+7.5,0,0]) translate([0,0,-150+25]) intersection() {
                rotate([0,90,0]) cylinder(r=150,h=250);
                mirror([0,0,0]) cube([250,150,150]);
            }
        }
    }
    translate([-400,-200,-400]) cube([400,400,400]);
}

!rotate([0,0,45]) ring_quarter() locking_ring_bottom();

*union() {
    locked = 0;
    *rotate([0,0,22.5*locked]) rotate([0,0,45]) {
        *ring_quarter() translate([0,0,5+0.4]) locking_ring_top();
        for(i=[0]) rotate([0,0,-45+i])!ring_quarter() translate([0,0,-10]) locking_ring_bottom();
    }
    for(i=[0/*:90:270*/]) rotate([0,0,22.5+i]) {
        ring_quarter() translate([0,0,-5]) base_ring_top();
        rotate([0,0,45]) !ring_quarter() translate([0,0,-5-10]) base_ring_bottom();
    }
}



*for(j=[0,1]) mirror([0,j,0]) {
for(i=[0,1]) mirror([i,0,0]) {
    translate([(120-8/2)*cos(90*1/8),0,0]) {
        translate([0,(120-8/2)*sin(90*1/8),0]) hull() {
            translate([0,0,0]) sphere(r=10);
            translate([0,0,-10]) sphere(r=10);
        }
    }
    hull() {
        translate([(120-8/2)*cos(90*1/8),0,0]) {
            translate([0,(120-8/2)*sin(90*1/8),0]) hull() {
                translate([0,0,-10]) sphere(r=10);
            }
        }
        translate([(120-8/2)*cos(90*5/8),0,0]) {
            translate([0,(120-8/2)*sin(90*5/8),0]) hull() {
                translate([0,0,-40]) sphere(r=10);
            }
        }
    }
    translate([(120-8/2)*cos(90*5/8),0,0]) {
        translate([0,(120-8/2)*sin(90*5/8),0]) hull() {
            translate([0,0,0]) sphere(r=10);
            translate([0,0,-40]) sphere(r=10);
        }
    }
}
}



module yoke_frontback(yoke_fb_l) {
    corner_r = 37.5;
    corner_a = 22.5;
    
    difference() {
        union() {
            translate([0,0,0.1]) cylinder(r=10,h=yoke_fb_l-0.1);
            
            translate([0,0,yoke_fb_l]) {
                
                sphere(r=10);
                
                rotate([0,0,90]) rotate([90,0,0]) translate([-corner_r,0,0]) rotate_extrude(angle=90-corner_a) translate([corner_r,0]) circle(r=10);
                
                rotate([0,-90,0]) translate([-(yoke_x-corner_r)/tan(corner_a),-(yoke_x),0]) {
                    rotate_extrude(angle=corner_a,$fn=$fn*4) {
                        $fn=$fn/4;
                        translate([(yoke_x-corner_r)/sin(corner_a)+corner_r,0]) circle(r=10);
                    }
                    
                    translate([(yoke_x-corner_r)/sin(corner_a)+corner_r,0,0]) sphere(r=10);
                    rotate([0,0,corner_a]) translate([(yoke_x-corner_r)/sin(corner_a)+corner_r,0,0]) sphere(r=10);
                }
            }
        }
        hull() for(iz=[0,200]) {
            translate([10+10*cos(45),50,iz]) rotate([90,0,0]) cylinder(r=10,h=200);
        }
        hull() for(iz=[0,200]) {
            translate([50,10+10*cos(45),iz]) rotate([0,-90,0]) cylinder(r=10,h=200);
        }
        translate([-50,-1,1]) rotate([0,90,0]) rotate_extrude(angle=90) translate([1-0.1,0]) square([50,200]);
        
        hull() for(iz=[0,20-1]) for(ix=[1,50]) {
            translate([50,ix,iz]) rotate([0,-90,0]) cylinder(r=1+0.1,h=200);
        }
        for(iz=[5,15]) {
            translate([0,0,iz]) rotate([90,0,0]) rotate([0,0,90]) {
                translate([0,0,-50]) hull() cylinder_oh(1.5+0.1,200);
                translate([0,0,2.5]) hull() cylinder_oh(3,200);
            }
        }
    }
}


yoke_x = (120-8/2)*cos(90*3/8);

*!for(ix=[0,1]) mirror([0,ix,0]) translate([0,yoke_x,0]) yoke_frontback(25);

module yoke_sideseg(yoke_fb_a, yoke_fb_r) {
    translate([0,0,-yoke_fb_r]) rotate([0,-90,0]) {
        rotate_extrude(angle=yoke_fb_a,$fn=$fn*4) translate([yoke_fb_r,0]) circle(r=10,$fn=$fn/4);
        rotate([0,0,yoke_fb_a]) translate([yoke_fb_r,0,0]) rotate([0,90,0]) {
            children();
        }
    }
}
module yoke_sideseg_proj(yoke_fb_a, yoke_fb_r) {
    translate([0,0,-yoke_fb_r]) rotate([0,-90,0]) {
        rotate_extrude(angle=yoke_fb_a,$fn=$fn*4) translate([yoke_fb_r,0]) {
            circle(r=10,$fn=$fn/4);
            translate([0,-10]) square([100,2*10]);
        }
        rotate([0,0,yoke_fb_a]) translate([yoke_fb_r,0,0]) rotate([0,90,0]) {
            children();
        }
    }
}
module yoke_sideseg_pos(yoke_fb_a, yoke_fb_r) {
    translate([0,0,-yoke_fb_r]) rotate([0,-90,0]) {
        rotate([0,0,yoke_fb_a]) translate([yoke_fb_r,0,0]) rotate([0,90,0]) {
            children();
        }
    }
}

module yoke_sideendseg() {
    difference() {
        cylinder(r=10,h=20);
        
        translate([-50,1,20+0.1-1]) rotate([180,0,0]) rotate([0,90,0]) rotate_extrude(angle=90) translate([1-0.1,0]) square([50,200]);
        
        hull() for(iz=[1,20]) for(ix=[1,50]) {
            translate([50,-ix,iz]) rotate([0,-90,0]) cylinder(r=1+0.1,h=200);
        }
        
        for(iz=[5,15]) {
            translate([0,0,iz]) rotate([90,0,0]) rotate([0,0,90]) {
                translate([0,0,-50]) cylinder(r=1.5+0.1,h=200);
                
                translate([0,0,-50-2]) {
                    hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),0]) {
                        cylinder(r=0.2,h=50-2);
                        cylinder(r=0.2+0.2,h=50-2-1);
                    }
                    hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),0]) cylinder(r=0.2,h=50);
                    hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,2.75/cos(30),0.2]) cylinder(r=0.2,h=50); 
                }
            }
        }
    }
}

*mirror([0,0,0]) intersection() {
    scale([1000,1000,1000]) translate([-0.31,0.4,0.16]) rotate([0,-5,0]) rotate([0,0,45]) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_19_20_17.stl",convexity=10);
    translate([-100,0,0]) rotate([0,-90,0]) cylinder(r=400,h=20);
}

*rotate([-15,0,0]) {
for(ix=[0,1]) mirror([ix,0,0]) translate([yoke_x,0,0]) {
    yoke_fr_a = -15+60;
    yoke_fr_r = 75;
    yoke_fr_l = 25;
    
    yoke_fr_cr_r = 37.5;
    yoke_fr_cr_a = 22.5;
    
    yoke_bk_a = 15+45;
    yoke_bk_r = 50;
    yoke_bk_l = 25;
    
    translate([0,0,-5]) difference() {
        union() {
            for(iy=[0,1]) mirror([0,iy,0]) {
                hull() {
                    cylinder(r=10-bev_s,h=5);
                    translate([0,0,bev_s]) cylinder(r=10,h=5-2*bev_s);
                    
                    translate([0,(120-8/2)*sin(90*3/8),0]) {
                        cylinder(r=10-bev_s,h=5);
                        translate([0,0,bev_s]) cylinder(r=10,h=5-2*bev_s);
                    }
                }
                difference() {
                    hull() {
                        translate([-yoke_x,0,0]) cylinder(r=10,h=5);
                        cylinder(r=10-bev_s,h=5);
                        translate([0,0,bev_s]) cylinder(r=10,h=5-2*bev_s);
                        translate([0,(120-8/2)*sin(90*3/8),0]) {
                            cylinder(r=10-bev_s,h=5);
                            translate([0,0,bev_s]) cylinder(r=10,h=5-2*bev_s);
                            rotate([0,0,90*4/8]) translate([0,(120-8/2)*sin(90*2/8),0]) {
                                cylinder(r=10-bev_s,h=5);
                                translate([0,0,bev_s]) cylinder(r=10,h=5-2*bev_s);
                            }
                        }
                    }
                    translate([-yoke_x,0,-10]) {
                        cylinder(r=120-8/2-10,h=50,$fn=$fn*2);
                        translate([0,0,10-0.01]) cylinder(r1=120-8/2-10+bev_s,r2=120-8/2-10,h=bev_s,$fn=$fn*2);
                        translate([0,0,10+5+0.01-bev_s]) cylinder(r1=120-8/2-10,r2=120-8/2-10+bev_s,h=bev_s,$fn=$fn*2);
                        
                        linear_extrude(height=50) polygon([
                            [0,0],
                            [200*sin(90*3/8),200*cos(90*3/8)],
                            [-200*sin(90*3/8),200*cos(90*3/8)],
                        ]);
                    }
                }
                translate([0,(120-8/2)*sin(90*3/8),0]) {
                    rotate([0,0,90*4/8]) translate([0,(120-8/2)*sin(90*2/8),0]) hull() {
                        cylinder(r=10-bev_s,h=5);
                        translate([0,0,bev_s]) cylinder(r=10,h=5-2*bev_s);
                    }
                }
            }
            *hull() for(iy=[-25,37.5]) {
                translate([0,iy,-100]) cylinder(r=10,h=100);
            }
        }
        
        for(iy=[0,1]) mirror([0,iy,0]) {
            *translate([0,(120-8/2)*sin(90*3/8),-10]) {
                hull() rotate([0,0,90]) cylinder_oh(1.75,50);
                hull() {
                    rotate([0,0,90]) cylinder_oh(3,10+1);
                    rotate([0,0,90]) cylinder_oh(3+1,10);
                }
            }
            
            translate([-yoke_x,0,0]) translate([(120-8/2)*cos(90*5/8),(120-8/2)*sin(90*5/8),-10]) {
                hull() rotate([0,0,90]) cylinder_oh(1.75,50);
                hull() {
                    rotate([0,0,90]) cylinder_oh(3,10+1);
                    rotate([0,0,90]) cylinder_oh(3+1,10);
                }
            }
        }
        hull() for(iy=[-200,200]) {
            translate([(10+10*cos(45)),iy,-100]) cylinder(r=10,h=200);
        }
    }
    
    
    translate([0,-15,-5]) intersection() {
        difference() {
            union() {
                yoke_sideseg_proj(10,50) {
                    yoke_sideseg_proj(asin(50/250),250) {
                        yoke_sideseg_proj(10,100);
                    }
                }
                mirror([0,1,0]) yoke_sideseg_proj(30,90) {
                    yoke_sideseg_proj(22.5, 50);
                }
            }
            hull() for(iy=[-200,200]) {
                translate([(10+10*cos(45)),iy,-100]) cylinder(r=10,h=200);
            }
        }
        hull() for(iy=[-45,60]) {
            translate([0,iy,-100]) cylinder(r=10,h=100+5-bev_s);
        }
    }
    
    translate([0,-15,-5]) difference() {
        union() {
            yoke_sideseg(10,50) {
                yoke_sideseg(asin(50/250),250) {
                    yoke_sideseg(10,100) {
                        rotate([-90,0,0]) rotate([0,0,-90]) {
                            yoke_sideendseg();
                            yoke_frontback(25);
                        }
                    }
                }
            }
            mirror([0,1,0]) yoke_sideseg(30,90) {
                yoke_sideseg(22.5, 50) {
                    rotate([-90,0,0]) rotate([0,0,-90]) {
                        yoke_sideendseg();
                        *yoke_frontback(25);
                    }
                }
            }
        }
        
        
        yoke_sideseg_pos(10,50) {
            yoke_sideseg_pos(asin(50/250),250) {
                yoke_sideseg_pos(10,100) {
                    hull() for(iy=[0,20]) {
                        translate([-50,iy,10+10*cos(45)]) rotate([0,90,0]) {
                            cylinder(r=10,h=200);
                        }
                    }
                }
            }
        }
        mirror([0,1,0]) yoke_sideseg_pos(30,90) {
            yoke_sideseg_pos(22.5, 50) {
                hull() for(iy=[0,20]) {
                    translate([-50,iy,10+10*cos(45)]) rotate([0,90,0]) {
                        cylinder(r=10,h=200);
                    }
                }
            }
        }
        
        hull() for(iy=[-200,200]) {
            translate([(10+10*cos(45)),iy,-100]) cylinder(r=10,h=200);
        }
        translate([0,0,5]) cylinder(r=200,h=200);
    }
}


*translate([(120-8/2)*cos(90*3/8),0,0]) {
    for(j=[-1:0.25:1-0.25]) {
        hull() for(i=[j,j+0.25]) {
            translate([0,i*(120-8/2)*sin(90*3/8),0]) {
                translate([0,0,-20-100+sqrt(pow(100,2)-pow(i*(120-8/2)*sin(90*3/8)+5,2))])  {
                    sphere(r=10);
                }
            }
        }
    }
    *for(i=[-1,1]) hull() {
        translate([0,i*(120-8/2)*sin(90*3/8),0]) {
            translate([0,0,0]) sphere(r=10);
            translate([0,0,-20-100+sqrt(pow(100,2)-pow(i*(120-8/2)*sin(90*3/8)+10,2))])  {
                sphere(r=10);
            }
        }
    }
}

translate([0,0,15]) union() {
    rotate([0,0,0]) {
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
    
    union() {
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet A2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet B2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet C.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet E.stl");
    }
}
}

module ring_quarter() intersection() {
    children();
    translate([0.2,0.2,-50]) cube([200,200,100]);
}



module locking_ring_screws() {
    for(i=[45/8,45-45/8,45+45/8,90-45/8]) rotate([0,0,i]) {
        translate([120+7.5+1.75+0.4,0,0]) children();
    }
}

module ring_tabs() {
    for(i=[6,7]) rotate([0,0,(i+0.5)*360/8]) {
        for(j=[0,1]) mirror([j,0,0]) {
            children();
        }
    }
}


module base_ring_screws() {
    for(i=[45/8,45-45/8,45+45/8,90-45/8]) rotate([0,0,i]) {
        translate([120-1.75,0,0]) children();
    }
}

module locking_ring_top() union() {
    difference() {
        hull() {
            cylinder(r=120+7.5+7.5-bev_xs,h=5-0.4-bev_l,$fn=$fn*2);
            translate([0,0,bev_xs]) {
                cylinder(r=120+7.5+7.5,h=5-0.4-bev_l-bev_xs,$fn=$fn*2);
                cylinder(r=120+7.5+7.5-bev_l,h=5-0.4-bev_xs,$fn=$fn*2);
            }
        }
            
        intersection() {
            union() {
                translate([0,0,-1]) linear_extrude(height=10,convexity=10) {
                    ring_tabs() {
                        polygon([
                            [-0.01,0.01],
                            [-0.01,200],
                            [20-2,200],
                            [20-2,sqrt(pow(120+7.5-2,2)-pow(20-2,2))],
                            //[20,sqrt(pow(120+7.5-2,2)-pow(20-2,2))],
                            //[20,sqrt(pow(120+2,2)-pow(20+2,2))],
                            [20+2,sqrt(pow(120+2,2)-pow(20+2,2))],
                        ]);
                    }
                }
                
                ring_tabs() {
                    translate([20-2,sqrt(pow(120+7.5-2,2)-pow(20-2,2)),0]) {
                        //circle(r=2+0.4);
                        hull() for(i=[0,-50]) translate([0,i,-1]) cylinder(r=2+0.4,h=50);
                        hull() for(i=[0,-50]) translate([0,i,-1]) cylinder(r1=2+0.4+1+0.4,r2=2+0.4,h=1+0.4);
                        hull() for(i=[0,-50]) translate([0,i,5-0.4-0.4]) cylinder(r1=2+0.4,r2=2+0.4+1+0.4,h=1+0.4);
                    }
                }
            }
            union() {
                translate([0,0,-1]) cylinder(r=120+7.5+clr_h,h=50,$fn=$fn*2);
                translate([0,0,-1]) cylinder(r1=120+7.5+clr_h+1+bev_xs,r2=120+7.5+clr_h,h=1+bev_xs,$fn=$fn*2);
                translate([0,0,5-0.4-0.4]) cylinder(r1=120+7.5+clr_h,r2=120+7.5+clr_h+1+bev_s,h=1+bev_s,$fn=$fn*2);
            }
        }
        
        translate([0,0,-1]) {
            cylinder(r=120+0.4,h=50,$fn=$fn*2);
            hull() {
                cylinder(r=120+0.4+0.4,h=1,$fn=$fn*2);
                cylinder(r=120+0.4,h=1+0.4,$fn=$fn*2);
            }
        }
        translate([0,0,5-0.4]) {
            hull() {
                cylinder(r=120+0.4+0.4,h=50,$fn=$fn*2);
                translate([0,0,-0.4]) cylinder(r=120+0.4,h=50,$fn=$fn*2);
            }
        }
        
        locking_ring_screws() {
            translate([0,0,-1]) cylinder(r=1.75,h=50);
            
            translate([0,0,5-0.4-bev_s]) cylinder(r1=3,r2=3+50,h=50);
            
            translate([0,0,1]) cylinder(r=3,h=50);
        }
    }
    
    ring_tabs() {
        hull() for(i=[sqrt(pow(120+2,2)-pow(20+2,2)),sqrt(pow(120+8.5-2,2)-pow(20+2,2))]) translate([20+2,i,0]) {
            cylinder(r=2-0.4-0.4,h=5-0.4);
            translate([0,0,0.4]) cylinder(r=2-0.4,h=5-0.4-2*0.4);
        }
    }
}

//locking ring bottom
module locking_ring_bottom() union() {
    difference() {
        hull() {
            cylinder(r=120+7.5+7.5-bev_l,h=5+10+0.4,$fn=$fn*2);
            translate([0,0,bev_l]) {
                cylinder(r=120+7.5+7.5,h=5+10+0.4-bev_l-bev_xs,$fn=$fn*2);
                cylinder(r=120+7.5+7.5-bev_xs,h=5+10+0.4-bev_l,$fn=$fn*2);
            }
        }
        
        rotate([0,0,-22.5-22.5/2]) intersection() {
            union() {
                translate([0,0,-1]) linear_extrude(height=10,convexity=10) {
                    for(i=[7.5]) rotate([0,0,(i+0)*360/8]) {
                        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,-22.5/2]) {
                            polygon([
                                [-0.01*tan(22.5/2),0.01],
                                [-200*tan(22.5/2),200],
                                [20-2,200],
                                [20-2,sqrt(pow(ret_tab_r-2,2)-pow(20-2,2))],
                                //[20,sqrt(pow(ret_tab_r-2,2)-pow(20-2,2))],
                                //[20,sqrt(pow(120+2,2)-pow(20+2,2))],
                                [20+2,sqrt(pow(120+2,2)-pow(20+2,2))],
                            ]);
                        }
                    }
                }
                    
                for(i=[7.5]) rotate([0,0,(i+0)*360/8]) {
                    for(j=[0,1]) mirror([j,0,0]) rotate([0,0,-22.5/2]) {
                        translate([20-2,sqrt(pow(ret_tab_r-2,2)-pow(20-2,2)),0]) {
                            //circle(r=2+0.4);
                            hull() for(i=[0,-50]) translate([0,i,-1]) cylinder(r=2+clr_h,h=50);
                            hull() for(i=[0,-50]) translate([0,i,-1]) cylinder(r1=2+clr_h+1+bev_s,r2=2+clr_h,h=1+bev_s);
                            hull() for(i=[0,-50]) translate([0,i,5-clr_h-bev_s]) cylinder(r1=2+clr_h,r2=2+clr_h+1+bev_s,h=1+bev_s);
                        }
                    }
                }
                
            }
            
            union() {
                translate([0,0,-1]) cylinder(r=ret_tab_r+clr_h,h=50,$fn=$fn*2);
                translate([0,0,-1]) cylinder(r1=ret_tab_r+clr_h+1+bev_s,r2=ret_tab_r+clr_h,h=1+bev_s,$fn=$fn*2);
                translate([0,0,5-0.4-0.4]) cylinder(r1=ret_tab_r+clr_h,r2=ret_tab_r+clr_h+1+bev_s,h=1+bev_s,$fn=$fn*2);
            }
        }
        
        hull() {
            translate([0,0,5-0.4]) cylinder(r=120+7.5+clr_h-bev_s,h=50,$fn=$fn*2);
            translate([0,0,5-0.4+bev_s]) cylinder(r=120+7.5+clr_h,h=50,$fn=$fn*2);
        }
        
        translate([0,0,-1]) cylinder(r=120+clr_h,h=50,$fn=$fn*2);
        
        translate([0,0,-1]) cylinder(r1=120+clr_h+1+bev_s,r2=120+clr_h,h=1+bev_s,$fn=$fn*2);
        translate([0,0,5-0.4-0.4]) cylinder(r1=120+clr_h,r2=120+clr_h+1+bev_s,h=1+bev_s,$fn=$fn*2);
        
        locking_ring_screws() {
            translate([0,0,-1]) cylinder(r=1.75,h=50);
            hull() {
                translate([-50,0,5-0.4]) cylinder(r=1.75,h=50);
                translate([0,0,5-0.4]) cylinder(r=1.75,h=50);
            }
            hull() for(i=[0,1]) mirror([0,i,0]) {
                translate([-1.75,bev_s,5-0.4]) cylinder(r=1.75,h=50,$fn=4);
                translate([-10,bev_s,5-0.4]) cylinder(r=1.75,h=50,$fn=4);
            }
        
            hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) {
                cylinder(r=0.2,h=1+5-0.4-1-2);
                cylinder(r=0.2+0.2,h=1+5-0.4-1-2-1);
            }
            hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1);
            hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1+0.2); 
        }
        
        
        rotate([0,0,-22.5-15+0.625]) difference() {
            mirror([1,0,0]) linear_extrude(height=50,convexity=10) {
                polygon([
                    [0,0],
                    [5-1,sqrt(pow(120+7.5+1+clr_h,2)-pow(5-1,2))],
                    [5-1,sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2))],
                
                    [200*sin(atan((5-1)/sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2)))),200*cos(atan((5-1)/sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2))))],
                    [200*sin(atan((5+10+1)/sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2))))*cos(-22.5)-200*cos(atan((5-1)/sqrt(pow(120+7.5+7.5-1,2)-pow(5+10+1,2))))*sin(-22.5),200*cos(atan((5-1)/sqrt(pow(120+7.5+7.5-1,2)-pow(5+10+1,2))))*cos(-22.5)+200*sin(atan((5+10+1)/sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2))))*sin(-22.5)],
                
                    [(5+10+1)*cos(-22.5)-sqrt(pow(120+7.5+7.5-1,2)-pow(5+10+1,2))*sin(-22.5),sqrt(pow(120+7.5+7.5-1,2)-pow(5+10+1,2))*cos(-22.5)+(5+10+1)*sin(-22.5)],
                    [(5+10+1)*cos(-22.5)-sqrt(pow(120+7.5+1+clr_h,2)-pow(5+10+1,2))*sin(-22.5),sqrt(pow(120+7.5+1+clr_h,2)-pow(5+10+1,2))*cos(-22.5)+(5+10+1)*sin(-22.5)],
                ]);
            }
            hull() {
                cylinder(r=120+7.5+7.5-bev_s,h=5-0.4,$fn=$fn*2);
                cylinder(r=120+7.5+7.5,h=5-0.4-bev_s,$fn=$fn*2);
            }
        }
    }
    
    rotate([0,0,-22.5-15+0.625]) mirror([1,0,0]) intersection() {
        hull() {
            cylinder(r=120+7.5+7.5-bev_l,h=5+10+0.4,$fn=$fn*2);
            translate([0,0,bev_l]) {
                cylinder(r=120+7.5+7.5,h=5+10+0.4-bev_l-bev_xs,$fn=$fn*2);
                cylinder(r=120+7.5+7.5-bev_xs,h=5+10+0.4-bev_l,$fn=$fn*2);
            }
        }
        
        translate([5-1-0.01,0,5-0.4-1]) cube([200,200,200]);
        rotate([0,0,-22.5]) translate([-200+(5+10+1)+0.01,0,5-0.4-1]) cube([200,200,200]);
        
        union() {
            hull() {
                translate([5-1,sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2)),0]) {
                    cylinder(r=1,h=5+10+0.4);
                }
                translate([5-1,sqrt(pow(120+7.5+1+clr_h,2)-pow(5-1,2)),0]) {
                    cylinder(r=1,h=5+10+0.4);
                }
            }
            hull() for(i=[sqrt(pow(120+7.5+7.5-1,2)-pow(5-1,2)),sqrt(pow(120+7.5+1+clr_h,2)-pow(5-1,2))]) {
                translate([5-1,i,0]) {
                    cylinder(r=1+bev_s+1,h=5-0.4-1);
                    cylinder(r=1,h=5-0.4+bev_s);
                }
            }
            rotate([0,0,-22.5]) hull() {
                translate([5+10+1,sqrt(pow(120+7.5+7.5-1,2)-pow(5+10+1,2)),0]) {
                    cylinder(r=1,h=5+10+0.4);
                }
                translate([5+10+1,sqrt(pow(120+7.5+1+clr_h,2)-pow(5+10+1,2)),0]) {
                    cylinder(r=1,h=5+10+0.4);
                }
            }
            rotate([0,0,-22.5]) hull() for(i=[sqrt(pow(120+7.5+7.5-1,2)-pow(5+10+1,2)),sqrt(pow(120+7.5+1+clr_h,2)-pow(5+10+1,2))]) {
                translate([5+10+1,i,0]) {
                    cylinder(r=1+bev_s+1,h=5-0.4-1);
                    cylinder(r=1,h=5-0.4+bev_s);
                }
            }
        }
    }
        
    
    rotate([0,0,-22.5-22.5/2]) for(i=[7.5]) rotate([0,0,(i+0)*360/8]) {
        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,-22.5/2]) {
            hull() for(i=[sqrt(pow(120+2,2)-pow(20+2,2)),sqrt(pow(120+8.5-2,2)-pow(20+2,2))]) translate([20+2,i,0]) {
                cylinder(r=2-clr_h-bev_s,h=5-0.4);
                translate([0,0,bev_s]) cylinder(r=2-clr_h,h=5-0.4-2*bev_s);
            }
        }
    }
    
    rotate([0,0,-22.5-15+0.625]) difference() {
        tab_w = 30;
        tab_l = 15;
        ring_or = 120+7.5+7.5;
        
        intersection() {
            union() {
                linear_extrude(height=5+10+0.4,convexity=10) {
                    polygon([
                        [0,0],
                        [clr_h+2,50],
                        [clr_h+2,sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2))],
                        [200*sin(atan((clr_h+2)/(ring_or+tab_l-2))),200*cos(atan((clr_h+2)/(ring_or+tab_l-2)))],
                        [200*sin(atan((tab_w-5-2)/(ring_or+tab_l-2))),200*cos(atan((tab_w-5-2)/(ring_or+tab_l-2)))],
                        [tab_w-5-2,sqrt(pow(ring_or+tab_l-2,2)-pow(tab_w-5-2,2))],
                        [tab_w-2,sqrt(pow(ring_or+tab_l-2,2)-pow(tab_w-5-2,2))-5],
                        [tab_w-2,sqrt(pow(ring_or+2,2)-pow(tab_w+2,2))],
                        [tab_w+2,sqrt(pow(ring_or+2,2)-pow(tab_w+2,2))],
                    ]);
                }
                hull() for(i=[50,sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2))]) {
                    translate([clr_h+2,i,0]) {
                        cylinder(r=2-bev_l,h=5+10+0.4);
                        translate([0,0,bev_l]) cylinder(r=2,h=5+10+0.4-2*bev_l);
                    }
                }
                hull() {
                    translate([tab_w-5-2,sqrt(pow(ring_or+tab_l-2,2)-pow(tab_w-5-2,2)),0]) hull() {
                        cylinder(r=2-bev_l,h=5+10+0.4);
                        translate([0,0,bev_l]) cylinder(r=2,h=5+10+0.4-2*bev_l);
                    }
                    for(i=[sqrt(pow(ring_or+tab_l-2,2)-pow(tab_w-5-2,2))-5,sqrt(pow(ring_or+2,2)-pow(tab_w-2,2))-5]) {
                        translate([tab_w-2,i,0]) hull() {
                            cylinder(r=2-bev_l,h=5+10+0.4);
                            translate([0,0,bev_l]) cylinder(r=2,h=5+10+0.4-2*bev_l);
                        }
                    }
                }
            }
            
            hull() {
                cylinder(r=ring_or+tab_l-bev_l,h=5+10+0.4,$fn=$fn*2);
                translate([0,0,bev_l]) cylinder(r=ring_or+tab_l,h=5+10+0.4-2*bev_l,$fn=$fn*2);
            }
        }
        translate([0,0,-0.01]) {
            cylinder(r=ring_or-1,h=50,$fn=$fn*2);
        }
        translate([tab_w+2,sqrt(pow(ring_or+2,2)-pow(tab_w+2,2)),-0.01]) {
            cylinder(r=2,h=50);
            cylinder(r1=2+bev_l,r2=2,h=bev_l);
            translate([0,0,5+10+0.4-bev_l+2*0.01]) cylinder(r1=2,r2=2+bev_l,h=bev_l);
        }
    }
}

//base ring top
module base_ring_top() difference() {
    union() {
        hull() {
            cylinder(r=120+7.5-bev_s,h=5,$fn=$fn*2);
            translate([0,0,bev_s]) cylinder(r=120+7.5,h=5-2*bev_s,$fn=$fn*2);
        }
        
        intersection() {
            union() {
                linear_extrude(height=10,convexity=10) {
                    for(i=[6,7]) rotate([0,0,(i+0.5)*360/8]) {
                        for(j=[0,1]) mirror([j,0,0]) rotate([0,0,22.5]) {
                            polygon([
                                [0.01*tan(45/2),0.01],
                        
                                [200*tan(45/2),200],
                                [200*tan(45/4),200],
                                [20+2,sqrt(pow(120+7.5-2+clr_h,2)-pow(20+2,2))],
                                //[20,sqrt(pow(120+7.5-2,2)-pow(20,2))],
                                //[20,sqrt(pow(120+2,2)-pow(20,2))],
                                [20+2,sqrt(pow(120+2,2)-pow(20+2,2))],
                            ]);
                        }
                    }
                }
                for(i=[6,7]) rotate([0,0,(i+0.5)*360/8]) {
                    for(j=[0,1]) mirror([j,0,0]) rotate([0,0,22.5]) {
                        hull() {
                            translate([20+2,sqrt(pow(120+7.5-2+clr_h,2)-pow(20+2,2)),0]) {
                                cylinder(r=2-clr_h,h=10-bev_s);
                                cylinder(r=2-clr_h-bev_s,h=10);
                            }
                            translate([20+2,sqrt(pow(120+2,2)-pow(20+2,2)),0]) {
                                cylinder(r=2-clr_h,h=10-bev_s);
                                cylinder(r=2-clr_h-bev_s,h=10);
                            }
                        }
                        hull() {
                            translate([20+2,sqrt(pow(120+7.5-2+clr_h,2)-pow(20+2,2)),-bev_s]) {
                                cylinder(r=2-clr_h,h=5+2*bev_s);
                                cylinder(r=2-clr_h+2*bev_s,h=5);
                            }
                            translate([20+2,sqrt(pow(120+2,2)-pow(20+2,2)),-bev_s]) {
                                cylinder(r=2-clr_h,h=5+2*bev_s);
                                cylinder(r=2-clr_h+2*bev_s,h=5);
                            }
                        }
                    }
                }
            }
            hull() {
                cylinder(r=120+7.5-bev_s,h=10,$fn=$fn*2);
                translate([0,0,bev_s]) cylinder(r=120+7.5,h=10-2*bev_s,$fn=$fn*2);
            }
        }
        
        
        rotate([0,0,-22.5-15+0.625]) {
        
            tab_w = 10;
            tab_l = 7.5+15;
            ring_or = 120+7.5;
        
            mirror([1,0,0]) difference() {
                union() {
                    intersection() {
                        linear_extrude(height=50,convexity=10) {
                            polygon([
                                [0,0],
                        
                                [5-1,sqrt(pow(ring_or+1+clr_h,2)-pow(5-1,2))],
                                [5+clr_h,sqrt(pow(ring_or+1+clr_h,2)-pow(5-1,2))],
                        
                                [5+clr_h,sqrt(pow(ring_or+7.5-1,2)-pow(5-1,2))],
                                [5-1,sqrt(pow(ring_or+7.5-1,2)-pow(5-1,2))],
                        
                                [5-1,sqrt(pow(ring_or+7.5+clr_h+2,2)-pow(5-1,2))],
                                [clr_h+2,sqrt(pow(ring_or+7.5+clr_h+2,2)-pow(clr_h+2,2))],
                        
                                [clr_h+2,sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2))],
                        
                                [200*sin(atan((clr_h+2)/sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2)))),200*cos(atan((clr_h+2)/sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2))))],
                        
                                [200*sin(atan((5+tab_w-5-2-clr_h)/sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2)))),200*cos(atan((5+tab_w-5-2-clr_h)/sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2))))],
                                [5+tab_w-5-2-clr_h,sqrt(pow(ring_or+tab_l-2,2)-pow(5+tab_w-5-2-clr_h,2))],
                        
                                [5+tab_w-2-clr_h,sqrt(pow(ring_or+tab_l-2,2)-pow(5+tab_w-5-2-clr_h,2))-5],
                        
                        
                                [5+tab_w-2-clr_h,sqrt(pow(ring_or+1+clr_h,2)-pow(5+tab_w+1,2))],
                                [5+tab_w+1,sqrt(pow(ring_or+1+clr_h,2)-pow(5+tab_w+1,2))],
                                
                                //[5+tab_w-2-clr_h,50],
                            ]);
                        }
                        hull() {
                            cylinder(r=ring_or+tab_l-bev_l,h=10,$fn=$fn*2);
                            translate([0,0,bev_l]) cylinder(r=ring_or+tab_l,h=10-2*bev_l,$fn=$fn*2);
                        }
                    }
                    
                    hull() {
                        translate([5-1,sqrt(pow(ring_or+7.5+2+clr_h,2)-pow(5-1,2))]) {
                            cylinder(r=2-bev_l,h=10);
                            translate([0,0,bev_l]) cylinder(r=2,h=10-2*bev_l);
                            
                        }
                        translate([clr_h+2,sqrt(pow(ring_or+7.5+2+clr_h,2)-pow(clr_h+2,2))]) {
                            cylinder(r=2-bev_l,h=10);
                            translate([0,0,bev_l]) cylinder(r=2,h=10-2*bev_l);
                        }
                        translate([clr_h+2,sqrt(pow(ring_or+tab_l-2,2)-pow(clr_h+2,2))]) {
                            cylinder(r=2-bev_l,h=10);
                            translate([0,0,bev_l]) cylinder(r=2,h=10-2*bev_l);
                        }
                    }
                    
                    hull() {
                        for(i=[50,sqrt(pow(ring_or+tab_l-2,2)-pow(5+tab_w-5-2-clr_h,2))-5]) {
                            translate([5+tab_w-clr_h-2,i,0]) {
                            cylinder(r=2-bev_l,h=10);
                            translate([0,0,bev_l]) cylinder(r=2,h=10-2*bev_l);
                            }
                        }
                        translate([5+tab_w-5-clr_h-2,sqrt(pow(ring_or+tab_l-2,2)-pow(5+tab_w-5-2-clr_h,2)),0]) {
                            cylinder(r=2-bev_l,h=10);
                            translate([0,0,bev_l]) cylinder(r=2,h=10-2*bev_l);
                        }
                    }
                }
                    
                translate([0,0,-1]) cylinder(r=ring_or-2.5,h=50,$fn=$fn*2);
                
                hull() for(i=[sqrt(pow(ring_or+7.5-1,2)-pow(5-1,2)),sqrt(pow(ring_or+1+clr_h,2)-pow(5-1,2))]) {
                    translate([5-1,i,-0.01]) {
                        cylinder(r=1+clr_h,h=50);
                    }
                }
                hull() for(i=[sqrt(pow(ring_or+7.5-1,2)-pow(5-1,2)),sqrt(pow(ring_or+1+clr_h,2)-pow(5-1,2))]) {
                    translate([5-1,i,-0.01]) {
                        cylinder(r1=1+clr_h+bev_l,r2=1+clr_h,h=bev_l);
                    }
                }
                hull() for(i=[sqrt(pow(ring_or+7.5-1,2)-pow(5-1,2)),sqrt(pow(ring_or+1+clr_h,2)-pow(5-1,2))]) {
                    translate([5-1,i,-0.01]) {
                        translate([0,0,10-bev_l+2*0.01]) cylinder(r1=1+clr_h,r2=1+clr_h+bev_l,h=bev_l);
                    }
                }
                translate([5+tab_w+1,sqrt(pow(ring_or+1+clr_h,2)-pow(5+tab_w+1,2)),-0.01]) {
                    cylinder(r=1+clr_h,h=50);
                    cylinder(r1=1+clr_h+bev_l,r2=1+clr_h,h=bev_l);
                    translate([0,0,10-bev_l+2*0.01]) cylinder(r1=1+clr_h,r2=1+clr_h+bev_l,h=bev_l);
                }
            }
        }
    }
    
    base_ring_screws() {
        translate([0,0,-1]) cylinder(r=1.75,h=50);
        translate([0,0,1]) cylinder(r=3,h=50);
        translate([0,0,5-bev_s]) cylinder(r1=3,r2=3+50,h=50);
    }
    
    hull() {
        translate([0,0,5]) cylinder(r=120+clr_h-bev_s,h=50,$fn=$fn*2);
        translate([0,0,5+bev_s]) cylinder(r=120+clr_h,h=50,$fn=$fn*2);
    }
    translate([0,0,10-bev_s]) cylinder(r1=120+clr_h,r2=120+clr_h+50,h=50,$fn=$fn*2);
    
    
    translate([0,0,-1]) cylinder(r=120-8,h=50,$fn=$fn*2);
    translate([0,0,5-1]) cylinder(r1=120-8,r2=120-8+5,h=5,$fn=$fn*2);
    translate([0,0,-0.01]) cylinder(r1=120-8+bev_xs,r2=120-8,h=bev_xs,$fn=$fn*2);
}

//base ring bottom
//rotate([0,0,22.5+45]) translate([0,0,-5-10]) intersection() {
module base_ring_bottom() difference() {
    union() {
        hull() {
            cylinder(r=120+7.5+2.5-bev_s,h=5-0.4,$fn=$fn*2);
            translate([0,0,bev_s]) cylinder(r=120+7.5+2.5,h=5-0.4-2*bev_s,$fn=$fn*2);
        }
        
        cylinder(r=120,h=5+5,$fn=$fn*2);
        
        hull() {
            cylinder(r=120,h=5+0.4-0.4,$fn=$fn*2);
            cylinder(r=120+0.4,h=5-0.4,$fn=$fn*2);
        }
        
        intersection() {
            linear_extrude(height=10,convexity=10) {
                for(i=[7.5]) rotate([0,0,(i+0)*360/8]) {
                    for(j=[0,1]) mirror([j,0,0]) {
                        polygon([
                            [0,0],
                            [0,200],
                            [20-2,200],
                            [20-2,sqrt(pow(ret_tab_r-2,2)-pow(20-2,2))],
                            [20,sqrt(pow(ret_tab_r-2,2)-pow(20-2,2))],
                            [20,sqrt(pow(120+2,2)-pow(20+2,2))],
                            [20+2,sqrt(pow(120+2,2)-pow(20+2,2))],
                        ]);
                    }
                }
            }
            union() {
                cylinder(r=ret_tab_r,h=10,$fn=$fn*2);
                hull() {
                    cylinder(r=ret_tab_r+0.4,h=5-0.4,$fn=$fn*2);
                    cylinder(r=ret_tab_r,h=5-0.4+0.4,$fn=$fn*2);
                }
            }
        }
        
        for(i=[7.5]) rotate([0,0,(i+0)*360/8]) {
            for(j=[0,1]) mirror([j,0,0]) {
                translate([20-2,sqrt(pow(ret_tab_r-2,2)-pow(20-2,2))]) {
                    hull() for(k=[0,-5]) translate([0,k,0]) cylinder(r=2,h=10);
                    hull() for(k=[0,-5]) translate([0,k,0]) {
                        cylinder(r=2+0.4,h=5-0.4);
                        cylinder(r=2,h=5-0.4+0.4);
                    }
                }
            }
        }
    }
    
    for(i=[7.5]) rotate([0,0,(i+0)*360/8]) {
        for(j=[0,1]) mirror([j,0,0]) {
            translate([20+2,sqrt(pow(120+2,2)-pow(20+2,2)),5-0.4]) {
                hull() {
                    cylinder(r=2-0.4,h=50);
                    translate([0,0,0.4]) cylinder(r=2,h=50);
                }
            }
        }
    }
    
    
    for(i=[360/8:360/8:360]) rotate([0,0,i+360/8/2]) translate([120-8+(8+5)/2,0,0]) {
        translate([0,0,-0.01]) {
            cylinder(r=2.5,h=20);
        }
        
        translate([0,0,0.4]) cylinder(r=4,h=20);
        translate([0,0,0.4+3]) hull() {
            cylinder(r=4,h=20);
            translate([0,0,0.2]) cylinder(r=4+0.2,h=20);
        }
        
        translate([0,0,5-0.4]) hull() {
            cylinder(r=4+0.2,h=20);
            translate([20,0,0]) cylinder(r=4+0.2,h=20);
        }
        translate([0,0,5+5-bev_xs+0.01]) hull() {
            cylinder(r1=4+0.2,r2=4+0.2+bev_xs,h=bev_xs);
            translate([20,0,0]) cylinder(r1=4+0.2,r2=4+0.2+bev_xs,h=bev_xs);
        }
    }
    
    for(i=[360/16/2:360/16:360]) rotate([0,0,i]) translate([120-8/2,0,-0.01]) {
        hull() {
            cylinder(r=1.25,h=5);
            cylinder(r=0.5,h=5+(1.25-0.5));
        }
        cylinder(r1=1.75,r2=1.25,h=1.75-1.25);
    }
    
    base_ring_screws() {
        translate([0,0,-1]) cylinder(r=1.75,h=50);
        hull() translate([0,0,5-0.4]) {
            cylinder(r=1.75,h=50);
            translate([200,0,0]) cylinder(r=1.75,h=50);
        }
        hull() for(i=[0,1]) mirror([0,i,0]) {
            translate([1.75,bev_s,5-0.4]) cylinder(r=1.75,h=50,$fn=4);
        }
        
        hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) {
            cylinder(r=0.2,h=1+5-0.4-1-2);
            cylinder(r=0.2+0.2,h=1+5-0.4-1-2-1);
        }
        
        hull() for(i=[0:5]) rotate([0,0,i*60]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1);
        hull() for(i=[0:2]) rotate([0,0,i*120]) translate([0,2.75/cos(30),-1]) cylinder(r=0.2,h=1+5-0.4-1+0.2); 
    }
    
    translate([0,0,-0.01]) cylinder(r=120-8,h=20,$fn=$fn*2);
    
    translate([0,0,-0.01]) cylinder(r1=120-8+bev_l,r2=120-8,h=bev_l,$fn=$fn*2);
    translate([0,0,5+5-bev_xs]) cylinder(r1=120-8,r2=120-8+50,h=50,$fn=$fn*2);
}



module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}


