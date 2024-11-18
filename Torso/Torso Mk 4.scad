
use <PLSS Torso Shared Modules.scad>;
use <Neckring Torso Shared Modules.scad>;


$fn = 72;

//translate([-15,-20,-780]) {
*intersection() {
    translate([0,55-15,27.5-5]) {
        rotate([0,-2.5,0]) translate([0,50,-550]) rotate([0,0,-12.5]) scale(1000) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_13_20_19.stl", convexity=10);
    }
    
    *translate([-120,-250,0]) rotate([0,-25,0]) translate([0,0,-400]) cube([40,500,500]);
}

//origin is crest of shoulder
should_rad = 30; //radius of crest
should_ang = 25; //downward slope of shoulders to side
should_wid_true = 120+5;
should_widh = should_wid_true - 8*sin(should_ang); //width of torso at shoulders. this is the x dimension where the topline of the shoulder crosses the z axis

back_dep = 95; //max depth in y axis of back
back_hgt = 140; //location in z axis of max depth
back_hgt2 = back_hgt/cos(should_ang); //hypotenuse of back height
back_rad = (pow(back_dep,2) + pow(back_hgt2-should_rad,2) - pow(should_rad,2)) / (2 * (back_dep - should_rad));

//clav_ang = 25;
//clav_dep = 70;

strap_wid = 40; //width of shoulder straps
//outset = 7.5; //thickness of shoulder straps
bev_s = 0.5; //bevel

flange_wid = 15; //width of flange/tab used to join segments

//used by make script
*/* make 'Torso Mk 4 A.stl' */ torso_assmbly() translate([0,0,-8*cos(should_ang)]) int_a_segment();
*/* make 'Torso Mk 4 B.stl' */ torso_assmbly() translate([0,0,-8*cos(should_ang)]) int_b_segment();
*/* make 'Torso Mk 4 C.stl' */ torso_assmbly() translate([0,0,-8*cos(should_ang)]) int_c_segment();
*/* make 'Torso Mk 4 CL.stl' */ torso_assmbly() mirror([1,0,0]) translate([0,0,-8*cos(should_ang)]) int_c_segment();
*/* make 'Torso Mk 4 D.stl' */ torso_assmbly() translate([0,0,-8*cos(should_ang)]) int_d_segment();
*/* make 'Torso Mk 4 E.stl' */ lateral_joining_tab_a();
*/* make 'Torso Mk 4 F.stl' */ lateral_joining_tab_c();
*/* make 'Torso Mk 4 G.stl' */ lateral_joining_tab_d();
*/* make 'Torso Mk 4 H.stl' */ interface_plate();


//assembled view
torso_assmbly() translate([-500,-500,-500]) cube([1000,1000,1000]);
*lateral_joining_tab_a();
*lateral_joining_tab_c();
*lateral_joining_tab_d();
*translate([0,0,-8*cos(should_ang)]) interface_plate();

module torso_assmbly() difference() {
    intersection() {
        union() {
            translate([0,0,-8*cos(should_ang)]) {
                hull() {
                    intersection() {
                        torso_shape(8-0.8,false,0);
                        torso_shape_intersect(0);
                    }
                    intersection() {
                        torso_shape(8,false,0.8);
                        torso_shape_intersect(0.8);
                    }
                }
            
                //plss upper interface
                hull() for(ia=[0:7.5:45]) {
                    intersection() {
                        plss_torso_portcrn_location(false) rotate([90,0,0]) cylinder(r=10+5*sin(ia)+(ia==45?50:0),h=200);
                        torso_plss_port_plane() translate([0,0,-100-(5-5*cos(ia)+(ia==45?50:0))]) cylinder(r=150,h=100);
                    }
                }
                
                //PLSS upper - outer protrusions for ventilation tubes
                //inlet to helmet
                hull() for(ib=[0,10]) intersection() {
                    torso_shape((15-ib));
                    hull() for(iz=[0,60]) translate([20+15,0,-60+iz]) rotate([90,0,0]) cylinder(r=5+5*tan(22.5)+ib+5*tan(22.5),h=200);
                }
                //merge these protrusions to prevent ridges
                //protrusions to right
                for(ixm=[0,1]) hull() for(ib=[0,10]) intersection() {
                    torso_shape((15-ib));
                    hull() {
                        //inlet - starts on right
                        translate([20+15,0,-60-5]) rotate([0,17.5,0]) hull() for(ix=[0,200]) translate([ix,0,0]) rotate([90,0,0]) cylinder(r=5*tan(22.5)+ib+5*tan(22.5),h=200);
                        //outlet - starts on left
                        translate([-(20+15),0,-60]) mirror([0,0,0]) rotate([0,17.5,0]) hull() for(ix=[0,200]) translate([ix,0,0]) rotate([90,0,0]) cylinder(r=5+5*tan(22.5)+ib+5*tan(22.5),h=200);
                    }
                }
                //protrusions to left
                for(ixm=[0,1]) hull() for(ib=[0,10]) intersection() {
                    torso_shape((15-ib));
                    hull() {
                        //inlet - starts on right
                        translate([20+15,0,-60-5]) mirror([1,0,0]) rotate([0,17.5,0]) hull() for(ix=[0,200]) translate([ix,0,0]) rotate([90,0,0]) cylinder(r=5*tan(22.5)+ib+5*tan(22.5),h=200);
                        //outlet - starts on left
                        translate([-(20+15),0,-60]) mirror([1,0,0]) rotate([0,17.5,0]) hull() for(ix=[0,200]) translate([ix,0,0]) rotate([90,0,0]) cylinder(r=5+5*tan(22.5)+ib+5*tan(22.5),h=200);
                    }
                }
                    
            
                //plss lower interface
                intersection() {
                    plss_torso_stud_location() {
                        hull() for(ia=[0:7.5:45]) {
                            difference() {
                                rotate([90,0,0]) cylinder(r=10+5*sin(ia)+(ia==45?50:0),h=100+100);
                                torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200+(5-5*cos(ia)+(ia==45?50:0)),200]);
                            }
                        }
                    }
                    torso_shape_intersect();
                }
            }
        
            
            //conical flange
            hull() for(ib=[0,0.8]) intersection() {
                translate([0,0,/*(sqrt(pow(120+5,2)+pow(40,2))-(120+5))*/7.5-ib]) {
                    rotate([-15,0,0]) translate([0,40,0]) hull() {
                        trans1() cylinder(r1=120+5+200*tan(15),r2=120+5,h=200,$fn=$fn*2);
                        trans1() hull() {
                            cylinder(r=120+5,h=200,$fn=$fn*2);
                            cylinder(r=120+5-50/tan(25),h=200+50,$fn=$fn*2);
                        }
                        //extra fillet on sides of flange so we can print B segment in the required orientation
                        trans1() hull() {
                            cylinder(r1=120+5,r2=120+5,h=200,$fn=$fn*2);
                            translate([-200,0,0]) cylinder(r1=120+5,r2=120+5,h=0.01,$fn=$fn*2);
                            translate([200,0,0]) cylinder(r1=120+5,r2=120+5,h=0.01,$fn=$fn*2);
                        }
                    }
                }
                translate([-(should_wid_true-(0.8-ib)),-500,-500]) cube([2*(should_wid_true-(0.8-ib)),1000,1000]);
            }
        }
        
        
        translate([0,0,-8*cos(should_ang)]) torso_shape_intersect();
            
        //intersections to create segments
        children();
    }
    
    translate([0,0,-8*cos(should_ang)]) {
        //cutout the inside
        torso_shape(0,true);
        
        //inside bevel on sides
        for(ixm=[0,1]) mirror([ixm,0,0]) hull() {
            intersection() {
                torso_shape(0,true,0);
                translate([should_wid_true-1,-500,-500]) cube([500,1000,1000]);
            }
            intersection() {
                torso_shape(1,true,-1);
                translate([should_wid_true,-500,-500]) cube([500,1000,1000]);
            }
        }
        
        //cutout recesses for tabs joining lateral sides
        union() {
            //tab recess in A segment
            hull() for(ib=[0,2.4]) intersection() {
                torso_shape((2.4-ib));
                hull() for(ixm=[0,1]) mirror([ixm,0,0]) rotate([-75,0,0]) {
                    for(iz=[0,-35]) translate([7.5,135+iz,-50]) rotate([0,0,90]) cylinder_oh(7.5+ib,250);
                }
            }
            //tab recess in C segment
            hull() for(ib=[0,2.4]) intersection() {
                torso_shape((2.4-ib));
                hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,(back_rad-back_dep),-back_hgt]) {
                    rotate([-10,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,back_rad+8+10);
                    rotate([asin((-8*cos(should_ang)-7.5-7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,250);
                }
            }
            
            //tab recess in D segment
            hull() for(ib=[0,2.4]) intersection() {
                torso_shape((2.4-ib));
                hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,(back_rad-back_dep),-back_hgt]) {
                    rotate([asin((-8*cos(should_ang)+15+15+7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,200);
                    rotate([15,0,0]) translate([7.5,0,-125]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,200);
                }
            }
        }
        
        //PLSS lower stud bolt cutouts
        union() {
            plss_torso_stud_location() {
                rotate([90,0,0]) rotate([0,0,90]) hull() cylinder_oh(3+0.2,100+100);
                
                torso_plss_stud_plane(false) translate([0,100+5,0]) hull() {
                    rotate([90,0,0]) rotate([0,0,90]) hull() cylinder_oh(6+0.2-bev_s,100);
                    rotate([90,0,0]) translate([0,0,-bev_s]) rotate([0,0,90]) hull() cylinder_oh(6+0.2,100);
                }
                
                hull() for(ib=[0,0.5]) difference() {
                    rotate([90,0,0]) rotate([0,0,90]) hull() cylinder_oh(3+0.2+ib,200);
                    torso_plss_stud_plane() translate([-100,(0.5-ib),-100]) cube([200,200,200]);
                }
            }
            for(ixm=[0,1]) mirror([ixm,0,0]) hull() for(ib=[0,bev_s]) intersection() {
                torso_shape((bev_s-ib));
                plss_torso_stud_location(false) {
                    rotate([90,0,0]) rotate([0,0,90]) hull() cylinder_oh(6+0.2+ib,100+100);
                }
            }
        }
        
        //PLSS upper interface cutouts
        union() {
            //bolt holes
            plss_torso_portcrn_location(false) {
                rotate([90,0,0]) hull() rotate([0,0,90]) cylinder_oh(3+0.2,200);
            }
            //cutouts for nuts
            for(ix2=[-1,1]*(20+15)) translate([ix2,0,0]) {
                for(ix=[-15,15]) for(iz=[-15,15]) translate([ix,0,0]) {
                    torso_plss_port_plane(false,iz) translate([0,0,-100-5-2]) hull() rotate([0,0,90]) {
                        cylinder_oh(3+0.2,100+3);
                        cylinder_oh(6+0.2,100);
                    }
                }
            }
            
            //main port holes
            plss_torso_port_location(false) {
                rotate([90,0,0]) hull() rotate([0,0,90]) cylinder_oh(12.5,200);
            }  
            for(ix2=[-1,1]*(20+15)) hull() for(ib=[0,bev_s]) intersection() {
                translate([0,0,-60]) translate([ix2,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(12.5+ib,200);
                torso_plss_port_plane() translate([0,0,-100-5-2-2+(bev_s-ib)]) cylinder(r=150,h=100);
            }
            
            torso_plss_port_plane() {
                //recess for interface plate
                hull() for(iz=[0,-2]) for(ix=[-1,1]*(20+15+15+(2+iz))) for(iy=[-1,1]*15/cos(asin((back_hgt-strap_wid*sin(25)-60)/(back_rad+8+10)))) translate([ix,iy,iz]) cylinder(r=5+0.4+2.5,h=100);
                hull() for(iz=[0,-bev_s]) for(ix=[-1,1]*(20+15+15+2-bev_s)) for(iy=[-1,1]*15/cos(asin((back_hgt-strap_wid*sin(25)-60)/(back_rad+8+10)))) translate([ix,iy,iz]) cylinder(r=5+0.4+2.5+(bev_s+iz),h=100);
                
                //screw holes to mount interface plate
                #for(ix=[-1,1]*(7.5)) for(iy=[-1,1]*15) translate([ix,iy,0]) {
                    translate([0,0,-6]) hull() rotate([0,0,90]) {
                        cylinder_oh(1.25-0.5,50);
                        translate([0,0,0.5]) cylinder_oh(1.25,50);
                    }
                    translate([0,0,-2]) hull() rotate([0,0,90]) {
                        cylinder_oh(1.25+bev_s,50);
                        translate([0,0,-bev_s]) cylinder_oh(1.25,50);
                    }
                }
            }
                
            //interior recess
            hull() for(ia=[0:7.5:45]) {
                intersection() {
                    plss_torso_portcrn_location(false) rotate([90,0,0]) cylinder(r=5+5*sin(ia)+(ia==45?50:0)+5*tan(22.5),h=200);
                    torso_plss_port_plane() translate([0,0,-100-5-2-2-(5-5*cos(ia)+(ia==45?50:0))]) cylinder(r=150,h=100);
                }
            }
            
            //inlet to helmet
            hull() for(ib=[0,10]) intersection() {
                torso_shape((10-ib),true);
                hull() for(iz=[0,200]) translate([20+15,0,-60+iz]) rotate([90,0,0]) cylinder(r=5+5*tan(22.5)+ib,h=200);
                torso_plss_port_plane() translate([0,0,-100-5-2-2]) cylinder(r=150,h=100);
            }
            //inlet to sleeve
            for(ixm=[0,1]) hull() for(ib=[0,10]) intersection() {
                torso_shape((10-ib),true);
                translate([20+15,0,-60-5]) mirror([ixm,0,0]) rotate([0,17.5,0]) hull() for(ix=[0,200]) translate([ix,0,0]) rotate([90,0,0]) cylinder(r=5*tan(22.5)+ib,h=200);
                torso_plss_port_plane() translate([0,0,-100-5-2-2]) cylinder(r=150,h=100);
            }
            //outlets
            for(ixm=[0,1]) hull() for(ib=[0,10]) intersection() {
                torso_shape((10-ib),true);
                translate([-(20+15),0,-60]) mirror([ixm,0,0]) rotate([0,17.5,0]) hull() for(ix=[0,200]) translate([ix,0,0]) rotate([90,0,0]) cylinder(r=5+5*tan(22.5)+ib,h=200);
                torso_plss_port_plane() translate([0,0,-100-5-2-2]) cylinder(r=150,h=100);
            }
            //some holes for zip ties
            //inlet to helmet
            for(iz=[35]) for(ix2=[-10,10]) translate([20+15+ix2,0,-60+iz]) rotate([90,0,0]) hull() rotate([0,0,90]) cylinder_oh(2,200);
            //inlet to sleeve
            for(ixm=[0,1]) {
                translate([20+15,0,-60-5]) mirror([ixm,0,0]) rotate([0,17.5,0]) for(ix=[70]+[1]*ixm*2*(20+15)) for(ix2=[-5,5]) translate([ix,0,ix2]) rotate([90,0,0]) hull() rotate([0,0,90+17.5]) cylinder_oh(2,200);
            }
            //outlets
            for(ixm=[0,1]) {
                translate([-(20+15),0,-60]) mirror([ixm,0,0]) rotate([0,17.5,0]) for(ix=[60]+[1]*(1-ixm)*2*(20+15)) for(ix2=[-10,10]) translate([ix,0,ix2]) rotate([90,0,0]) hull() rotate([0,0,90+17.5]) cylinder_oh(2,200);
            }
        }
        
        //cutout screw holes
        union() {
            for(ixm=[0,1]) mirror([ixm,0,0]) union() {
                intersection() {
                    torso_shape(8-1.6);
                    for(ii=[0:14]) screw_locations(ii) hull() cylinder_oh(1.25,250);
                }
                intersection() {
                    torso_shape(2.4+0.01);
                    for(ii=[0:14]) screw_locations(ii) hull() cylinder_oh(1.5+0.15,250);
                }
                for(ii=[0:14]) hull() {
                    intersection() {
                        torso_shape(0);
                        screw_locations(ii) cylinder_oh(3,250);
                    }
                    intersection() {
                        torso_shape(3-0.5);
                        screw_locations(ii) cylinder_oh(0.5,250);
                    }
                }
            }
        }
        
        //cutout holes for shock cord on back
        for(ix=[0,1]) mirror([ix,0,0]) for(iz=[0,20,40]) {
            translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                    translate([-iz*sin(15),0,(40-iz)*cos(15)]) rotate([90,0,0]) hull() rotate([0,0,90]) cylinder_oh(3,200);
                }
            }
            
            //inside bevel
            hull() for(ib=[0,bev_s]) intersection() {
                torso_shape(2+(bev_s-ib));
                translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                    rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                        translate([-iz*sin(15),0,(40-iz)*cos(15)]) rotate([90,0,0]) hull() rotate([0,0,90]) cylinder_oh(3+ib,200);
                    }
                }
            }
            
            //outside bevel
            hull() for(ib=[0,bev_s]) difference() {
                translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                    rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                        translate([-iz*sin(15),0,(40-iz)*cos(15)]) rotate([90,0,0]) hull() rotate([0,0,90]) cylinder_oh(3+ib,200);
                    }
                }
                torso_shape(8-2-(bev_s-ib));
            }
            
            //inside recess for knot
            hull() for(ib=[0,2]) intersection() {
                torso_shape((2-ib));
                translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                    rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                        translate([-iz*sin(15),0,(40-iz)*cos(15)]) rotate([90,0,0]) cylinder(r=5+ib,h=200);
                    }
                }
            }
            
            //inside recess channels
            hull() for(ib=[0,2]) intersection() {
                torso_shape((2-ib));
                translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                    rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                        translate([-iz*sin(15),0,(40-iz)*cos(15)]) hull() for(ix2=[0,50]) rotate([0,15,0]) translate([ix2,0,0]) {
                            rotate([90,0,0]) cylinder(r=3+ib,h=200);
                        }
                    }
                }
            }
            
            //outside recess for knot
            difference() {
                hull() for(ib=[0,2]) difference() {
                    translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                        rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                            translate([-iz*sin(15),0,(40-iz)*cos(15)]) rotate([90,0,0]) cylinder(r=5+ib,h=200);
                        }
                    }
                    torso_shape(8-(2-ib));
                }
                torso_shape(8-2);
            }
            
            //outside recess channels
            difference() {
                hull() for(ib=[0,2]) difference() {
                    translate([should_wid_true-15,(back_rad-back_dep),-back_hgt]) {
                        rotate([15,0,0]) translate([0,-back_rad+50,-125+15]) {
                            translate([-iz*sin(15),0,(40-iz)*cos(15)]) hull() for(ix2=[0,15]) rotate([0,15,0]) translate([ix2,0,0]) {
                                rotate([90,0,0]) cylinder(r=3+ib,h=200);
                            }
                        }
                    }
                    torso_shape(8-(2-ib),false,-100);
                }
                torso_shape(8-2);
            }
        }
        
        //cutout holes for shock cord on chest
        for(ix=[0,1]) mirror([ix,0,0]) for(iz=[0,20,40]) {
            rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                translate([0,135-15,0]) {
                    translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) hull() rotate([0,0,90]) cylinder_oh(3,200);
                }
            }
            
            //inside bevel
            hull() for(ib=[0,bev_s]) intersection() {
                torso_shape(2+(bev_s-ib));
                rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                    translate([0,135-15,0]) {
                        translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) hull() rotate([0,0,90]) cylinder_oh(3+ib,200);
                    }
                }
            }
            
            //outside bevel
            hull() for(ib=[0,bev_s]) difference() {
                rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                    translate([0,135-15,0]) {
                        translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) hull() rotate([0,0,90]) cylinder_oh(3+ib,200);
                    }
                }
                torso_shape(8-2-(bev_s-ib));
            }
            
            //inside recess for knot
            hull() for(ib=[0,2]) intersection() {
                torso_shape((2-ib));
                rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                    translate([0,135-15,0]) {
                        translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) cylinder(r=5+ib,h=200);
                    }
                }
            }
            
            //inside recess channels
            hull() for(ib=[0,2]) intersection() {
                torso_shape((2-ib));
                rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                    translate([0,135-15,0]) {
                        translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) hull() for(ix2=[0,15]) rotate([0,0,90-22.5]) translate([ix2,0,0]) {
                            cylinder(r=5+ib,h=200);
                        }
                    }
                }
            }
            
            //outside recess for knot
            difference() {
                hull() for(ib=[0,2]) difference() {
                    rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                        translate([0,135-15,0]) {
                            translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) cylinder(r=5+ib,h=200);
                        }
                    }
                    torso_shape(8-(2-ib));
                }
                torso_shape(8-2);
            }
            
            //outside recess channels
            difference() {
                hull() for(ib=[0,2]) difference() {
                    rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
                        translate([0,135-15,0]) {
                            translate([-iz*cos(22.5),-(40-iz)*sin(22.5),0]) hull() for(ix2=[0,15]) rotate([0,0,90-22.5]) translate([ix2,0,0]) {
                                cylinder(r=5+ib,h=200);
                            }
                        }
                    }
                    torso_shape(8-(2-ib),false,-100);
                }
                torso_shape(8-2);
            }
        }
    }
    
    //cutout neck hole
    translate([0,0,7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) hull() {
            neck_spacer_shape(120-8,true);
            trans1() cylinder(r=120-8,h=200+0.01,$fn=$fn*2);
            cylinder(r=120-8,h=200,$fn=$fn*2);
        }
    }
    //bevel inside neck hole
    hull() {
        bev = 1.2;
        for(ib=[0,bev]) intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape((bev-ib));
            translate([0,0,7.5]) {
                rotate([-15,0,0]) translate([0,40,0]) {
                    trans1() cylinder(r=120-8+ib,h=200+100,$fn=$fn*2);
                }
            }
        }
    }
    
    //cutouts for screws for interface from torso to neckring spacer
    for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,7.5]) {
        rotate([-15,0,0]) translate([0,40,0]) {
            neck_space_mag_co(undef,false) neck_space_mag_screw_co();
        }
    }
            
    //prevent neck spacer mounting holes from creating an overhang in the tabs
    for(ixm=[0,1]) mirror([ixm,0,0]) for(in=[1,4]) intersection() {
        translate([0,0,-8*cos(should_ang)]) torso_shape(2.4+0.01);
        translate([0,0,-8*cos(should_ang)]) union() {
            trans_ab_seam() translate([0,-flange_wid/2-0.01,-200]) cube([1000,200,250]);
            trans_bc_seam() translate([0,-200+flange_wid/2+0.01,-200]) cube([1000,200,250]);
        }
        translate([0,0,7.5]) {
            rotate([-15,0,0]) translate([0,40,0]) {
                neck_space_mag_co(in) {
                    mirror([0,(in==4?1:0),0]) hull() {
                        translate([0,0,-5-50]) rotate([0,0,90]) hull() cylinder_oh(3,50);
                        for(ia=[-45,45]) rotate([0,0,ia]) translate([0,-25,-5-50]) rotate([0,0,90-ia]) hull() cylinder_oh(3,50);
                    }
                }
            }
        }
    }
}

module lateral_joining_tab_a() {
    int_lateral_joining_tab() {
        //tabs for A segments
        hull() for(ixm=[0,1]) mirror([ixm,0,0]) rotate([-75,0,0]) {
            for(iz=[0,-35]) translate([7.5,135+iz,-50]) rotate([0,0,90]) cylinder_oh(7.5-0.2,250);
        }
    }
}

module lateral_joining_tab_c() {
    int_lateral_joining_tab() {
        //tabs for C segments
        hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,(back_rad-back_dep),-back_hgt]) {
            rotate([-10,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5-0.2,250);
            rotate([asin((-8*cos(should_ang)-7.5-7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5-0.2,250);
        }
    }
}

module lateral_joining_tab_d() {
    int_lateral_joining_tab() {
        //tabs for D segments
        hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,(back_rad-back_dep),-back_hgt]) {
            rotate([asin((-8*cos(should_ang)+15+15+7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5-0.2,200);
            rotate([15,0,0]) translate([7.5,0,-125]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5-0.2,200);
        }
    }
}

module int_lateral_joining_tab() translate([0,0,-8*cos(should_ang)]) difference() {
    intersection() {
        torso_shape(2.4);
        torso_shape_intersect(0);
        
        //positive shape for tabs joining lateral sides
        children();
    }
    
    //cutout the inside
    torso_shape(0,true);
    
    //cutout screw holes
    union() {
        for(ixm=[0,1]) mirror([ixm,0,0]) union() {
            intersection() {
                torso_shape(8-1.6);
                for(ii=[0:14]) screw_locations(ii) hull() cylinder_oh(1.25,250);
            }
            intersection() {
                torso_shape(2.4+0.01);
                for(ii=[0:14]) screw_locations(ii) hull() cylinder_oh(1.5+0.15,250);
            }
            for(ii=[0:14]) hull() {
                intersection() {
                    torso_shape(0);
                    screw_locations(ii) cylinder_oh(3,250);
                }
                intersection() {
                    torso_shape(3-0.5);
                    screw_locations(ii) cylinder_oh(0.5,250);
                }
            }
        }
    }
}


module int_a_segment() {
    //A segment
    trans_ab_seam() translate([0,flange_wid/2,-200]) cube([1000,200,250]);
    
    //fillet
    hull() for(ib=[0,bev_s]) intersection() {
        torso_shape(2.4+(bev_s-ib));
        
        trans_ab_seam() translate([0,flange_wid/2-ib,-200]) cube([1000,200,250]);
    }
    
    intersection() {
        torso_shape(2.4);
        
        //A-B flange (positive)
        trans_ab_seam() translate([0,-flange_wid/2,-200]) cube([1000,200,250]);
    }
}

module trans_ab_seam() {
    rotate([-15,0,0]) translate([0,40,0]) {
        translate([0,-40+75,0]) rotate([-15,0,0]) {
            translate([0,-(-40+75),0]) translate([0,(120-8)*cos(37.5),0]) children();
        }
    }
}

module int_b_segment() {
    //B segment
    difference() {
        intersection() {
            trans_ab_seam() translate([0,-200+flange_wid/2-0.2,-200]) cube([1000,200,250]);
            trans_bc_seam() translate([0,0-flange_wid/2+0.2,-200]) cube([1000,200,250]);
        }
        
        hull() for(ib=[0,2.4]) intersection() {
            torso_shape((2.4-ib));
            trans_ab_seam() translate([0,-flange_wid/2-ib,-200]) cube([1000,200,250]);
        }
        
        hull() for(ib=[0,2.4]) intersection() {
            torso_shape((2.4-ib));
            trans_bc_seam() translate([0,-200+flange_wid/2+ib,-200]) cube([1000,200,250]);
        }
    }
}

module trans_bc_seam() {
    rotate([-15,0,0]) translate([0,40,0]) {
        translate([0,-40,0]) rotate([15,0,0]) {
            translate([0,-25,0]) rotate([15,0,0]) translate([0,25,0]) {
                translate([0,40,0]) translate([0,-(120-8)*cos(37.5),0]) children();
            }
        }
    }
}

module int_c_segment() {
    //C segment
    intersection() {
        trans_bc_seam() translate([0,-200-flange_wid/2,-200]) cube([1000,200,250]);
        trans_cd_seam() translate([0,-500,flange_wid/2]) cube([1000,500,500]);
    }
    
    //fillet
    hull() for(ib=[0,bev_s]) intersection() {
        torso_shape(2.4+(bev_s-ib));
        
        //B-C flange
        trans_bc_seam() translate([0,-200-flange_wid/2+ib,-200]) cube([1000,200,250]);
        
        //C-D flange
        trans_cd_seam() translate([0,-500,flange_wid/2-ib]) cube([1000,500,500]);
    }
    
    intersection() {
        torso_shape(2.4);
        
        //B-C flange
        trans_bc_seam() translate([0,-200+flange_wid/2,-200]) cube([1000,200,250]);
        //C-D flange
        trans_cd_seam() translate([0,-500,-flange_wid/2]) cube([1000,500,500]);
    }
}


module trans_cd_seam() {
    translate([0,0,-back_hgt]) children();
}

module int_d_segment() {         
    //D segment
    difference() {
        trans_cd_seam() translate([0,-500,-500+flange_wid/2-0.2]) cube([1000,500,500]);
        hull() for(ib=[0,2.4]) intersection() {
            torso_shape((2.4-ib));
            trans_cd_seam() translate([0,-500,-flange_wid/2-ib]) cube([1000,500,500]);
        }
    }
}

module screw_locations(only_index=undef) {
    //A-B screws
    ab_index = [0,1];
    ab_ix = [should_wid_true-5,should_wid_true-25];
    for(i=[0,1]) if(only_index==undef || only_index==ab_index[i]) {
        trans_ab_seam() translate([ab_ix[i],0,0]) rotate([0,25,0]) translate([0,0,-200]) rotate([0,0,90]) children();
    }
    
    //B-C screws
    bc_index = [2,3];
    bc_ix = [should_wid_true-5,should_wid_true-25];
    for(i=[0,1]) if(only_index==undef || only_index==bc_index[i]) {
        trans_bc_seam() translate([ab_ix[i],0,0]) rotate([0,25,0]) translate([0,0,-200]) rotate([0,0,90]) children();
    }
        
    //C-D screws
    cd_index = [4,5,6];
    cd_ix = [30,120+5-15,120+5-50];
    trans_cd_seam() translate([0,(back_rad-back_dep),0]) {
        x_crit = (should_widh-back_hgt*tan(should_ang));
    
        for(i=[0]) if(only_index==undef || only_index==cd_index[i]) if(cd_ix[i]<x_crit) translate([cd_ix[i],0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        for(i=[1,2]) if(only_index==undef || only_index==cd_index[i]) if(cd_ix[i]>x_crit) translate([x_crit,0,0]) rotate([0,0,asin((cd_ix[i]-x_crit)/back_rad)]) rotate([90,0,0]) rotate([0,0,90]) children();
    }
    
    //A-A screws
    aa_index = [7,8];
    aa_iz = [-10,-35];
    rotate([-75,0,0]) {
        for(i=[0,1]) if(only_index==undef || only_index==aa_index[i]) translate([7.5,135+aa_iz[i],-50]) rotate([0,0,90]) children();
    }
    
    //C-C screws
    cc_index = [9,10,11];
    translate([0,(back_rad-back_dep),-back_hgt]) {
        //if(only_index==undef || only_index==cc_index[0]) rotate([-30,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==cc_index[1]) rotate([-10,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==cc_index[2]) rotate([asin((-8*cos(should_ang)-7.5-7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
    }
    
    //D-D screws
    dd_index = [12,13,14];
    translate([0,(back_rad-back_dep),-back_hgt]) {
        if(only_index==undef || only_index==dd_index[0]) rotate([asin((-8*cos(should_ang)+15+15+7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==dd_index[1]) rotate([15,0,0]) translate([7.5,0,-125+10]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==dd_index[2]) rotate([15,0,0]) translate([7.5,0,-60+15]) rotate([90,0,0]) rotate([0,0,90]) children();
    }
}



module torso_shape_intersect(bev_inset=0) {
    //front
    hull() for(ix=[0,1]) mirror([ix,0,0]) rotate([-75,0,0]) translate([should_wid_true-15,0,-50]) {
        cylinder(r=15-bev_inset,h=250);
        translate([0,135-15,0]) {
            translate([0,0-40*sin(22.5),0]) cylinder(r=15-bev_inset,h=250);
            translate([-40*cos(22.5),0,0]) cylinder(r=15-bev_inset,h=250);
        }
    }
    //back - upper
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([should_wid_true-40,(back_rad-back_dep),-back_hgt]) {
        rotate([15,0,0]) for(iz=[50,200]) translate([0,0,iz]) rotate([90,0,0]) cylinder(r=40-bev_inset,h=200);
    }
    //back - lower
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([should_wid_true-20,(back_rad-back_dep),-back_hgt]) {
        rotate([15,0,0]) translate([0,-back_rad+50,0]) {
            translate([0,0,200]) rotate([90,0,0]) cylinder(r=20-bev_inset,h=200);
            translate([0,0,-125+20+40*cos(15)]) rotate([90,0,0]) cylinder(r=20-bev_inset,h=200);
            translate([-40*sin(15),0,-125+20]) rotate([90,0,0]) cylinder(r=20-bev_inset,h=200);
        }
    }
}

//shape of torso
module torso_shape(outset=0,co=false,bev_inset=0) hull() {
    //shoulder, collarbone and chest shape
    wid_extra = 120;
    intersection() {
        translate([0,0,-(-(-back_hgt+(should_widh-back_hgt2*sin(should_ang))*tan(should_ang))-back_hgt2+30)]) {
            rotate([0,0,0]) translate([0,0,-(-back_hgt+(should_widh-back_hgt2*sin(should_ang))*tan(should_ang))-back_hgt2+30]) {
                shoulder_hanger(outset,wid_extra);
            }
            translate([0,0,-150]) shoulder_hanger(outset,wid_extra);
            
            rotate([15,0,0]) translate([0,0,-(-back_hgt+(should_widh-back_hgt2*sin(should_ang))*tan(should_ang))-back_hgt2+30]) {
                shoulder_hanger(outset,wid_extra);
                
                translate([0,0,-30*cos(should_ang)-wid_extra/cos(should_ang)*sin(should_ang)]) {
                    rotate([-90-15,0,0]) translate([0,0,30*cos(should_ang)+wid_extra/cos(should_ang)*sin(should_ang)]) {
                        shoulder_hanger(outset,wid_extra);
                        translate([0,150,150*tan(15)]) shoulder_hanger(outset,wid_extra);
                    }
                }
            }
        }
        translate([-(should_wid_true+(co?0.01:0)-bev_inset),-0.01,-500]) cube([2*(should_wid_true+(co?0.01:0)-bev_inset),500,1000]);
    }
    
    //upper back shape
    intersection() {
        union() {
            for(ix=[0,1]) mirror([ix,0,0]) translate([-should_widh,0,0]) rotate([0,90-should_ang,0]) {
                translate([0,0,0]) linear_extrude(height=(should_widh-back_hgt2*sin(should_ang))/cos(should_ang)) back_upper_cs(outset); 
            }
            
            translate([0,-((back_rad-back_dep)+outset),-back_hgt+(should_widh-back_hgt2*sin(should_ang))*tan(should_ang)]) rotate([90,0,0]) rotate([0,0,90-should_ang]) rotate_extrude(angle=2*should_ang,$fn=$fn*4) intersection() {
                $fn=$fn/4;
                rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) back_upper_cs(outset); 
                translate([0,-250]) square([500,500]);
            }
            
            //triangle at base of upper back
            translate([0,(back_rad-back_dep),-back_hgt]) hull() {
                for(ix=[0,1]) mirror([ix,0,0]) translate([(should_widh-back_hgt*tan(should_ang)),0,0]) rotate([90,0,0]) cylinder(r1=20,r2=0,h=back_rad+outset);
                translate([0,0,(should_widh-back_hgt*tan(should_ang))*tan(should_ang)]) rotate([90,0,0]) cylinder(r1=20,r2=0,h=back_rad+outset);
            }
        }
        translate([-(should_wid_true+(co?0.01:0)-bev_inset),-500+0.01,-500]) cube([2*(should_wid_true+(co?0.01:0)-bev_inset),500,1000]);
    }
    
    //mid back shape
    intersection() {
        for(ix=[0,1]) mirror([ix,0,0]) {
            translate([-should_widh,0,0]) rotate([0,90-should_ang,0]) {
                //shoulder crest
                translate([30,0]) rotate_extrude() intersection() {
                    translate([-back_rad+30,0]) circle(r=back_rad+outset,$fn=$fn*4);
                    translate([0,-500]) square([500,500]);
                }
            
                translate([back_hgt2,(back_rad-back_dep)]) {
                    //main curve of the back
                    rotate([0,0,-90+15]) rotate_extrude(angle=-45-15,$fn=$fn*4) intersection() {
                        translate([back_rad-back_rad,0]) circle(r=back_rad+outset);
                        translate([0,-500]) square([500,500]);
                    }
        
                    //protrusion near top of shoulder blade
                    rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50),0]) rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) {
                        //cylinder(r=50+5+outset,h=500);
                        rotate_extrude($fn=$fn*4) intersection() {
                            translate([-back_rad+50+5,0]) circle(r=back_rad+outset);
                            translate([0,-500]) square([500,500]);
                        }
                    }
                }
            }
            translate([(should_widh-back_hgt*tan(should_ang)),(back_rad-back_dep),-back_hgt]) {
                rotate([15,0,0]) translate([0,0,-125]) cylinder(r=back_rad+outset,h=125,$fn=$fn*4);
            }
        }
        translate([-(should_wid_true+(co?0.01:0)-bev_inset),-500+0.01,-500]) cube([2*(should_wid_true+(co?0.01:0)-bev_inset),500,1000]);
    }
}

module shoulder_hanger(outset=0,wid_extra=0) {
    translate([0,-((back_rad-back_dep)+outset),-back_hgt+(should_widh-back_hgt2*sin(should_ang))*tan(should_ang)]) rotate([90,0,0]) rotate([0,0,90-should_ang]) rotate_extrude(angle=2*should_ang,$fn=$fn*4) intersection() {
        $fn=$fn/4;
        rotate([0,0,180]) translate([-back_hgt2,(back_rad-back_dep)+outset]) translate([30,0]) circle(r=30+outset);
    }
    
    for(ix=[0,1]) mirror([ix,0,0]) translate([-should_widh,0,0]) rotate([0,90-should_ang,0]) {
        translate([0,0,-wid_extra/cos(should_ang)]) {
            linear_extrude(height=(should_widh+wid_extra-back_hgt2*sin(should_ang))/cos(should_ang)) translate([30,0]) circle(r=30+outset);
            translate([30,0,0]) rotate([0,should_ang,0]) sphere(r=30+outset);
        }
    }
}


//cross section of back profile
module back_upper_cs(outset=0) hull() {
    //shoulder crest
    translate([30,0]) circle(r=30+outset);
    
    //origin is the midpoint of the back
    translate([back_hgt2,(back_rad-back_dep)]) {
        //main curve of the back
        intersection() {
            circle(r=back_rad+outset,$fn=$fn*4);
            translate([-(back_hgt2+outset-10),-(back_rad-back_dep)-500]) square([back_hgt2+outset-10,500]);
        }
    
        //protrusion near top of shoulder blade
        rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) translate([0,-(back_rad-50)]) rotate([0,0,-atan((back_hgt2-should_rad)/(back_rad-back_dep))+asin(30/back_rad)]) {
            circle(r=50+5+outset,$fn=$fn*4);
        }
    }
}


module interface_plate() difference() {
    bev_xs = 0.25;
    
    clr_h = 0.2;
    
    port_boss_or = 12.5-clr_h;
    port_boss_ir = port_boss_or-1.6;
    port_boss_h = 8;
    
    union() {
        torso_plss_port_plane() {
            //recess for interface plate
            hull() for(ix=[-1,1]*(20+15+15)) for(iy=[-1,1]*15/cos(asin((back_hgt-strap_wid*sin(25)-60)/(back_rad+8+10)))) translate([ix,iy,-2]) {
                cylinder(r=5+2.5-bev_s,h=2);
                translate([0,0,bev_s]) cylinder(r=5+2.5,h=2-2*bev_s);
            }
        }
        
        //main port bosses
        for(ix2=[-1,1]*(20+15)) hull() for(ib=[0,bev_s]) intersection() {
            translate([0,0,-60]) translate([ix2,0,0])rotate([90,0,0]) rotate([0,0,90]) cylinder(r=port_boss_or-ib,h=200);
            torso_plss_port_plane() translate([0,0,-2-port_boss_h+(bev_s-ib)]) cylinder(r=150,h=2+port_boss_h-(bev_s-ib));
        }
        //fillet
        for(ix2=[-1,1]*(20+15)) hull() for(ib=[0,bev_xs]) intersection() {
            translate([0,0,-60]) translate([ix2,0,0])rotate([90,0,0]) rotate([0,0,90]) cylinder(r=port_boss_or+ib,h=200);
            torso_plss_port_plane() translate([0,0,-(2+(bev_xs-ib))]) cylinder(r=150,h=2+(bev_xs-ib));
        }
    }
    
    //main port cutouts
    for(ix2=[-1,1]*(20+15)) {
        translate([0,0,-60]) translate([ix2,0,0])rotate([90,0,0]) rotate([0,0,90]) cylinder(r=port_boss_ir,h=200);
    }
    //outer bevel
    for(ix2=[-1,1]*(20+15)) hull() for(ib=[0,bev_s]) intersection() {
        translate([0,0,-60]) translate([ix2,0,0])rotate([90,0,0]) rotate([0,0,90]) cylinder(r=port_boss_ir+ib,h=200);
        torso_plss_port_plane() translate([0,0,-(bev_s-ib)]) cylinder(r=150,h=50);
    }
    
    //bolt holes
    for(ix2=[-1,1]*(20+15)) translate([ix2,0,0]) {
        for(ix=[-15,15]) for(iz=[-15,15]) translate([ix,0,0]) {
            torso_plss_port_plane(false,iz) translate([0,0,-100]) cylinder(r=3+0.2,h=200);
            
            //outer bevel
            hull() for(ib=[0,bev_s]) intersection() {
                torso_plss_port_plane(false,iz) translate([0,0,-100]) cylinder(r=3+0.2+ib,h=200);
                torso_plss_port_plane() translate([0,0,-(bev_s-ib)]) cylinder(r=150,h=50);
            }
            //inner bevel
            hull() for(ib=[0,bev_s]) intersection() {
                torso_plss_port_plane(false,iz) translate([0,0,-100]) cylinder(r=3+0.2+ib,h=200);
                torso_plss_port_plane() translate([0,0,-50-2+(bev_s-ib)]) cylinder(r=150,h=50);
            }
        }
    }
    
    torso_plss_port_plane() {
        //screw holes to mount interface plate
        for(ix=[-1,1]*(7.5)) for(iy=[-1,1]*15) translate([ix,iy,0]) {
            translate([0,0,0]) hull() rotate([0,0,90]) {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
            translate([0,0,-2]) hull() rotate([0,0,90]) {
                cylinder(r=1.25+bev_s,h=50);
                translate([0,0,-bev_s]) cylinder(r=1.25,h=50);
            }
        }
    }
}


