$fn = 36;

//translate([-15,-20,-780]) {
*translate([0,0,0]) intersection() {
    translate([0,50,-550]) rotate([0,0,-5]) scale(1000) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_13_20_19.stl", convexity=10);
    
    translate([120,-250,-400]) cube([0.01,500,500]);
}

*for(i=[0,1]) mirror([i,0,0]) translate([60,0,0]) sphere(r=10);

*rotate([-15,0,0]) translate([0,30,-10]) difference() {
    cylinder(r=120+15,h=25);
    translate([0,0,-1]) cylinder(r=120-8,h=50);
}
    

//section_r120(0);
    
intersection() {
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