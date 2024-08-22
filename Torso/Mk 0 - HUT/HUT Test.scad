$fn = 36;

bev_l = 0.8;
bev_s = 0.4;
bev_xs = 0.2;

!union() {
    //for(i=[0,1]) rotate([0,0,i*180]) translate([0,-50+1.25,0]) mirror([i,0,0]) rotate([0,0,2])  hud_fitting_armhole();
    mirror([1,0,0]) rotate([0,0,45]) hud_fitting_armhole();
}

!union() mirror([1,0,0]) {
    translate([0,0,10]) rotate([180,0,0]) hut_fitting_clav();
    translate([60,20,0]) hud_fitting_shoulder();
    translate([60,-40,0]) mirror([1,0,0]) hud_fitting_shoulder();
}

translate([0,0,0]) rotate([-15,0,0]) {
    *neckring_mockup();
    
    for(ix=[0,1]) mirror([ix,0,0]) translate([10,-20,-10]) {
        hut_fitting_clav();
        
        translate([0,10,(5-2)]) rotate([15,0,0]) translate([0,-10,-(5-2)]) translate([0,0,-5]) {
            translate([(120-8/2)*cos(360/16/2),0,0]) {
                !hud_fitting_shoulder();
                
                *rotate([0,0,180+30]) {
                   rotate([0,-90+30,0]) translate([-(100+10-5*tan(30)),0,-15]) translate([0,0,0]) for(ia=[0,120,240]) rotate([0,0,-90+ia]) hud_fitting_armhole();
               }
           }
       }
   }
}


module hud_fitting_armhole() {
    armh_r = 120;
    armh_a = 30-7.5;
    
    ring_r_outer = armh_r+10;
    attach_r = ring_r_outer-5*tan(30);
    
    difference() {
        union() {
            intersection() {
                difference() {
                    cylinder(r=armh_r+10,h=10,$fn=$fn*2);
                    translate([0,attach_r+5*tan(armh_a),0]) rotate([-90,0,0]) cylinder(r=50,h=50);
                }
                translate([0,0,-0.01]) rotate([0,0,60]) ring_tabs(armh_r+10,true);
            }
            
            intersection() {
                hull() {
                    difference() {
                        union() {
                            cylinder(r=armh_r+10,h=10,$fn=$fn*2);
                            cylinder(r=armh_r+10-20*tan(30),h=30,$fn=$fn*2);
                        }
                        translate([0,attach_r+5*tan(armh_a),0]) rotate([-90,0,0]) cylinder(r=50,h=50);
                        translate([0,attach_r,15]) rotate([-90+armh_a,0,0]) cylinder(r=50,h=50);
                    }
                    
                    for(ix=[-25,25]) {
                        translate([ix,attach_r-5+5*tan(armh_a),0]) cylinder(r=5,h=10);
                        translate([ix,attach_r-5-15*tan(armh_a),0]) cylinder(r=5,h=30);
                    }
                }
                translate([0,0,-0.01]) rotate([0,0,-60]) {
                    ring_tabs(armh_r+10,false);
                    rotate([0,0,120]) translate([10+0.1,0,0]) cube([200,200,50]);
                }
            }
            
        }
        
        
        for(i=[-1,1]) for(i2=[-60,60]) rotate([0,0,90+i2-i*asin(5/ring_r_outer)]) {
            translate([ring_r_outer-10+6,0,5]) rotate([0,90,0]) rotate([0,0,90]) mount_screw_co_oh(4,4-1);
        }
        
        translate([0,attach_r,10+5]) rotate([armh_a,0,0]) {
            for(ia=[-7.5,30-7.5]) rotate([0,ia,0]) {
                for(ix=[-20,20]) translate([ix,0,0]) rotate([-90,0,0]) rotate([0,0,-ia]) mirror([0,0,1]) mount_screw_co_oh(50,3);
            }
        }
            
        translate([0,0,-0.01]) hull() {
            cylinder(r1=armh_r+10-7.5,r2=armh_r+10-7.5-20*tan(30),h=20,$fn=$fn*2);
            
            for(ix=[-25,25]) {
                translate([ix,attach_r-7.5-5+5*tan(armh_a),0]) cylinder(r=5,h=0.01);
                translate([ix,attach_r-7.5-5-15*tan(armh_a),0]) cylinder(r=5,h=20);
            }
        }
        hull() {
            cylinder(r=armh_r+10-7.5-20*tan(30),h=30+0.01,$fn=$fn*2);
            
            for(ix=[-25,25]) translate([ix,attach_r-7.5-5-15*tan(armh_a),0]) {
                cylinder(r=5,h=30+0.01);
            }
        }
    }
}

module ring_tabs(ring_r_outer,right_hand_side=true) {
    //ring_r_outer = armh_r+10;
    tab_r = 4;
    tab_wh = 10;
    
    $fn = $fn*4;
    
    if(right_hand_side) {
        difference() {
            union() {
                linear_extrude(height=50,convexity=10) polygon([
                    [0,0],
                    [tab_wh+0.1,20],
                    [tab_wh+0.1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    [tab_wh-0.1-1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    [200*tan(atan((tab_wh-0.1-1)/(ring_r_outer-tab_r-(1+0.1)))),200],
                    [200,200],
                    [200,0],
                ]);
                difference() {
                    linear_extrude(height=50,convexity=10) polygon([
                        [0,0],
                        [tab_wh-0.1-1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                        [200*tan(atan((tab_wh-0.1-1)/(ring_r_outer-tab_r-(1+0.1)))),200],
                        [-(tab_wh-0.1),200],
                        [-(tab_wh-0.1),sqrt(pow(ring_r_outer-tab_r+(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                        [-(tab_wh-0.1-1),sqrt(pow(ring_r_outer-tab_r+(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    ]);
                    cylinder(r=ring_r_outer-tab_r+0.1,h=50);
                }
                translate([-(tab_wh-0.1-1),sqrt(pow(ring_r_outer-tab_r+(1+0.1),2)-pow(tab_wh-0.1-1,2)),0]) cylinder(r=1,h=50);
            }
            translate([tab_wh-0.1-1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2)),0]) cylinder(r=1+0.2,h=50);
        }
    } else {
        union() {
            intersection() {
                linear_extrude(height=50,convexity=10) polygon([
                    [0,0],
                    [tab_wh-0.1,20],
                    [tab_wh-0.1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    [tab_wh-0.1-1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    [200*tan(atan((tab_wh-0.1-1)/(ring_r_outer-tab_r-(1+0.1)))),200],
                    [-(tab_wh+0.1),200],
                    [-(tab_wh+0.1),20],
                ]);
                cylinder(r=ring_r_outer-tab_r-0.1,h=50);
            }
            translate([tab_wh-0.1-1,sqrt(pow(ring_r_outer-tab_r-(1+0.1),2)-pow(tab_wh-0.1-1,2)),0]) cylinder(r=1,h=50);
            difference() {
                linear_extrude(height=50,convexity=10) polygon([
                    [0,0],
                    [-(tab_wh-0.1-1),sqrt(pow(ring_r_outer-tab_r+(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    [-(tab_wh+0.1),sqrt(pow(ring_r_outer-tab_r+(1+0.1),2)-pow(tab_wh-0.1-1,2))],
                    [-(tab_wh+0.1),200],
                    [-200,200],
                    [-200,0],
                ]);
                translate([-(tab_wh-0.1-1),sqrt(pow(ring_r_outer-tab_r+(1+0.1),2)-pow(tab_wh-0.1-1,2)),0]) cylinder(r=1+0.2,h=50);
            }
        }
    }
}

module hud_fitting_shoulder() {
    difference() {
        hull(){
            translate([0,0,0]) cylinder(r=25,h=6);
            translate([25-5,10,0]) cylinder(r=5,h=6);
            translate([-(25-5),10,0]) cylinder(r=5,h=6);
        }
        
            translate([0,0,-0.01]) cylinder(r=15,h=50);
        
        translate([0,0,6]) {
            translate([-50,10,5-2]) {
                rotate([0,90,0]) cylinder(r=5+0.2,h=100);
            }
            
            translate([0,10,5-2]) for(ix=[-20,20]) {
                rotate([(ix==0?15:-15),0,0]) translate([ix,0,-5]) mirror([0,0,1]) mount_screw_co_oh(10,0.2+1.4);
            }
        }
        
        for(ia=[30-7.5,30+7.5]) rotate([0,0,ia]) for(iy=[-1,1]) translate([0,20*iy,0]) rotate([0,0,-ia]) mirror([0,0,1]) mount_screw_co(10,false);
    }
}


module hut_fitting_clav() mirror([0,1,0]) {
    difference() {
        union() {
            intersection() {
                hull() {
                    for(ix=[-10,10]) for(iy=[-20,0]) translate([ix,iy,-10]) {
                        translate([(120-8/2)*cos(360/16/2),-(120-8/2)*sin(360/16/2),0]) cylinder(r=5,h=50);
                        translate([(120-8/2)*cos(360/16/2),(120-8/2)*sin(360/16/2),0]) cylinder(r=5,h=50);
                    }
                    
                    for(ix=[-20,20]) translate([(120-8/2)*cos(360/16/2)+ix,-10,-10]) {
                        cylinder(r=5,h=50);
                    }
                }
            
                
                translate([0,-10,5-2]) {
                    rotate([0,90,0]) cylinder(r=5,h=200);
                }
            }
                
            intersection() {
                hull() {
                    for(ix=[-10,10]) for(iy=[-20,0]) translate([ix,iy,0]) {
                        translate([(120-8/2)*cos(360/16/2),-(120-8/2)*sin(360/16/2),0]) cylinder(r=5,h=50);
                        translate([(120-8/2)*cos(360/16/2),(120-8/2)*sin(360/16/2),0]) cylinder(r=5,h=50);
                    }
                    
                    for(ix=[-20,20]) translate([(120-8/2)*cos(360/16/2)+ix,-10,0]) {
                        cylinder(r=5,h=50);
                    }
                }
                translate([0,-200,0]) {
                    hull() {
                        cube([200,200+5,10]);
                        translate([0,0,10-5]) cube([200,200+5+7.5,5]);
                    }
                    translate([0,0,10-5]) cube([200,200+200,5]);
                }
                translate([0,-10,-(5-2)]) rotate([-15,0,0]) translate([0,10,5-2]) {
                    translate([0,-200,0]) cube([200,400,50]);
                    translate([0,-200-(25+25)*(1-sin(30)),-5]) cube([200,200,50]);
                }
                translate([0,-10,-(5-2)]) rotate([-15,0,0]) translate([0,10,5-2]) {
                    translate([0,-200,0]) cube([200,400,50]);
                    translate([(120-8/2)*cos(360/16/2),0,-5]) rotate_extrude() translate([25+5,0]) square([100,50]);
                }
            }
        }
        
        translate([(120-8/2)*cos(360/16/2)-10-5-10,-10,5-2]) for(ix=[0,40]) for(ia=[0]) {
            rotate([ia,0,0]) translate([5+ix,0,-5]) {
                mirror([0,0,1]) mount_screw_co(10,false);
                cylinder(r1=1.75+0.5,r2=1.25,h=1.75-1.25+0.5);
            }
        }
        
        for(ix=[-10:10:10]) for(iy=[-20:10:0]) translate([ix,iy,10]) {
            translate([(120-8/2)*cos(360/16/2),-(120-8/2)*sin(360/16/2),0]) mirror([0,0,1]) mount_screw_co(10,false);
            translate([(120-8/2)*cos(360/16/2),(120-8/2)*sin(360/16/2),0]) mirror([0,0,1]) mount_screw_co(10,false);
        }
    }
}




module neckring_mockup() translate([0,0,15]) rotate([0,0,180*0]) union() {
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
    
    *union() {
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet A2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet B2.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet C.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/MA-3 Helmet E.stl");
    }
}

module mount_screw_co(hgt_to_bevel,head_oh=false) {
    translate([0,0,-8]) hull() {
        cylinder(r=1.25,h=20);
        translate([0,0,-1.25]) cylinder(r=0.01,h=20);
    }
            
    translate([0,0,-0.01]) cylinder(r=1.75,h=20);
    translate([0,0,2]) {
        cylinder(r=3,h=20);
        
        if(head_oh) {
            translate([-1.75,-sqrt(pow(3,2)-pow(1.75,2)),-0.2]) cube([2*1.75,2*sqrt(pow(3,2)-pow(1.75,2)),20]);
            translate([-1.75,-1.75,-0.4]) cube([2*1.75,2*1.75,20]);
        }
    }
    
    translate([0,0,hgt_to_bevel]) hull() {
        translate([0,0,-bev_s]) cylinder(r=3,h=50);
        cylinder(r=3+bev_s,h=50);
    }
}

module mount_screw_co_oh(hgt_to_bevel,hgt_to_head) {
    translate([0,0,-8]) hull() {
        cylinder_oh(1.25,20);
        translate([0,0,-1.25]) cylinder(r=0.01,h=20);
    }
            
    translate([0,0,-0.01]) hull() cylinder_oh(1.75,20);
    translate([0,0,hgt_to_head]) hull() cylinder_oh(3,20);
    
    translate([0,0,hgt_to_bevel]) hull() {
        translate([0,0,-bev_s]) cylinder_oh(3,50);
        cylinder_oh(3+bev_s,50);
    }
}
  

module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}