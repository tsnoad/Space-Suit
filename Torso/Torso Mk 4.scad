
use <PLSS Torso Shared Modules.scad>;
//use <PLSS.scad>;

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
outset = 7.5; //thickness of shoulder straps
bev_s = 0.5; //bevel

flange_wid = 15;


//torso_assmbly();

//torso_assmbly() int_a_segment();
//torso_assmbly() int_b_segment();
torso_assmbly() int_c_segment();

module torso_assmbly() difference() {
    intersection() {
        union() {
            translate([0,0,-8*cos(should_ang)]) hull() {
                intersection() {
                    torso_shape(8-0.8,false,0);
                    torso_shape_intersect(0);
                }
                intersection() {
                    torso_shape(8,false,0.8);
                    torso_shape_intersect(0.8);
                }
            }
            
            //conical flange
            translate([0,0,/*(sqrt(pow(120+5,2)+pow(40,2))-(120+5))*/7.5]) {
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
            
            //plss upper interface
            
            //plss lower interface
            *intersection() {
                plss_torso_stud_location() {
                    hull() for(ia=[0:7.5:45]) {
                        difference() {
                            rotate([90,0,0]) cylinder(r=10+5*sin(ia)+(ia==45?50:0),h=100+100);
                            torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200+(5-5*cos(ia)+(ia==45?50:0)),200]);
                        }
                    }
                }
                translate([0,0,-8*cos(should_ang)]) torso_shape_intersect();
            }
        }
        
        translate([0,0,-8*cos(should_ang)]) torso_shape_intersect();
        
        //intersections to create segments
        children();
    }
    
    //cutout the inside
    translate([0,0,-8*cos(should_ang)]) torso_shape(0,true);
    
    //inside bevel on sides
    for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-8*cos(should_ang)]) hull() {
        intersection() {
            torso_shape(0,true,0);
            translate([should_wid_true-1,-500,-500]) cube([500,1000,1000]);
        }
        intersection() {
            torso_shape(1,true,-1);
            translate([should_wid_true,-500,-500]) cube([500,1000,1000]);
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
            neck_space_mag_co();
        }
    }
    
    
    //cutout recesses for tabs joining lateral sides
    union() {
        //tab recess in A segment
        hull() for(ib=[0,2.4]) intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape((2.4-ib));
            hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-8*cos(should_ang)]) rotate([-75,0,0]) {
                for(iz=[0,-35]) translate([7.5,85+25*tan(30)+40+iz,-50]) rotate([0,0,90]) cylinder_oh(7.5+ib,250);
            }
        }
        
        //tab recess in C segment
        hull() for(ib=[0,2.4]) intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape((2.4-ib));
            hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-8*cos(should_ang)]) translate([0,(back_rad-back_dep),-back_hgt]) {
                rotate([-30,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,250);
                rotate([asin((-8*cos(should_ang)-15-7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,250);
            }
        }
        
        //tab recess in D segment
        hull() for(ib=[0,2.4]) intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape((2.4-ib));
            hull() for(ixm=[0,1]) mirror([ixm,0,0]) translate([0,0,-8*cos(should_ang)]) translate([0,(back_rad-back_dep),-back_hgt]) {
                rotate([asin((-8*cos(should_ang)+15+15+7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,200);
                rotate([15,0,0]) translate([7.5,0,-100]) rotate([90,0,0]) rotate([0,0,90]) cylinder_oh(7.5+ib,200);
            }
        }
    }
    
    
    //backpack stud bolt cutouts
    *union() {
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
            translate([0,0,-8*cos(should_ang)]) torso_shape((bev_s-ib));
            plss_torso_stud_location(false) {
                rotate([90,0,0]) rotate([0,0,90]) hull() cylinder_oh(6+0.2+ib,100+100);
            }
        }
    }
    
    //cutout screw holes
    for(ixm=[0,1]) mirror([ixm,0,0]) union() {
        intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape(8-1.6);
            for(ii=[0,1,2,3]) screw_locations(ii) hull() cylinder_oh(1.25,250);
        }
        intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape(2.4+0.01);
            for(ii=[0:14]) screw_locations(ii) hull() cylinder_oh(1.5+0.15,250);
        }
        for(ii=[0:14]) hull() {
            intersection() {
                translate([0,0,-8*cos(should_ang)]) torso_shape(0);
                screw_locations(ii) cylinder_oh(3,250);
            }
            intersection() {
                translate([0,0,-8*cos(should_ang)]) torso_shape(3-0.5);
                screw_locations(ii) cylinder_oh(0.5,250);
            }
        }
    }
}


module int_a_segment() {
    //A segment
    trans_ab_seam() translate([0,flange_wid/2,-200]) cube([1000,200,250]);
    
    //fillet
    hull() for(ib=[0,bev_s]) intersection() {
        translate([0,0,-8*cos(should_ang)]) torso_shape(2.4+(bev_s-ib));
        
        trans_ab_seam() translate([0,flange_wid/2-ib,-200]) cube([1000,200,250]);
    }
    
    intersection() {
        translate([0,0,-8*cos(should_ang)]) torso_shape(2.4);
        
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
            translate([0,0,-8*cos(should_ang)]) torso_shape((2.4-ib));
            trans_ab_seam() translate([0,-flange_wid/2-ib,-200]) cube([1000,200,250]);
        }
        
        hull() for(ib=[0,2.4]) intersection() {
            translate([0,0,-8*cos(should_ang)]) torso_shape((2.4-ib));
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
        translate([0,0,-8*cos(should_ang)]) torso_shape(2.4+(bev_s-ib));
        
        //B-C flange
        trans_bc_seam() translate([0,-200-flange_wid/2+ib,-200]) cube([1000,200,250]);
        
        //C-D flange
        trans_cd_seam() translate([0,-500,flange_wid/2-ib]) cube([1000,500,500]);
    }
    
    intersection() {
        translate([0,0,-8*cos(should_ang)]) torso_shape(2.4);
        
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
            translate([0,0,-8*cos(should_ang)]) torso_shape((2.4-ib));
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
    translate([0,0,-8*cos(should_ang)]) rotate([-75,0,0]) {
        for(i=[0,1]) if(only_index==undef || only_index==aa_index[i]) translate([7.5,85+25*tan(30)+40+aa_iz[i],-50]) rotate([0,0,90]) children();
    }
    
    //C-C screws
    cc_index = [9,10,11];
    translate([0,0,-8*cos(should_ang)]) translate([0,(back_rad-back_dep),-back_hgt]) {
        if(only_index==undef || only_index==cc_index[0]) rotate([-30,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==cc_index[1]) rotate([-15+asin((-8*cos(should_ang)-15-7.5)/back_rad)/2,0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==cc_index[2]) rotate([asin((-8*cos(should_ang)-15-7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
    }
    
    //D-D screws
    dd_index = [12,13,14];
    translate([0,0,-8*cos(should_ang)]) translate([0,(back_rad-back_dep),-back_hgt]) {
        if(only_index==undef || only_index==dd_index[0]) rotate([asin((-8*cos(should_ang)+15+15+7.5)/back_rad),0,0]) translate([7.5,0,0]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==dd_index[1]) rotate([15,0,0]) translate([7.5,0,-100+10]) rotate([90,0,0]) rotate([0,0,90]) children();
        if(only_index==undef || only_index==dd_index[2]) rotate([15,0,0]) translate([7.5,0,-50+15]) rotate([90,0,0]) rotate([0,0,90]) children();
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

module torso_shape_intersect(bev_inset=0) {
    //front
    hull() for(ix=[0,1]) mirror([ix,0,0]) rotate([-75,0,0]) {
        translate([should_wid_true-20,0,-50]) cylinder(r=20-bev_inset,h=250);
        translate([should_wid_true-20,125-20,-50]) cylinder(r=20-bev_inset,h=250);
        translate([should_wid_true-20-25,125-20+25*tan(30),-50]) cylinder(r=20-bev_inset,h=250);
    }
    //back - upper
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([should_wid_true-40,(back_rad-back_dep),-back_hgt]) {
        rotate([15,0,0]) for(iz=[50,200]) translate([0,0,iz]) rotate([90,0,0]) cylinder(r=40-bev_inset,h=200);
    }
    //back - lower
    hull() for(ix=[0,1]) mirror([ix,0,0]) translate([should_wid_true-40,(back_rad-back_dep),-back_hgt]) {
        rotate([15,0,0]) for(iz=[-100+40,200]) translate([0,-back_rad+50,iz]) rotate([90,0,0]) cylinder(r=40-bev_inset,h=200);
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
                rotate([15,0,0]) translate([0,0,-100]) cylinder(r=back_rad+outset,h=100,$fn=$fn*4);
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

module neck_space_mag_co() {
    mag_is = (8+5)/2-0.75;
    mag_rad = (120-8+mag_is);
    mag_hgt = (120+5-mag_rad)*tan(25);
    
    translate([0,-40+75,0]) {
        for(ia=[15,45]) if(ia<acos((-40+75)/mag_rad)) translate([mag_rad*sin(ia),0,0]) {
            rotate([-15+asin(mag_hgt/(mag_rad*cos(ia)+(40-75))),0,0]) translate([0,mag_rad*cos(ia)+(40-75),0]) {
                neck_space_mag_screw_co(ia);
            }
        }
    }
    
    translate([0,0,0]) {
        for(ia=[75,105]) translate([mag_rad*sin(ia),0,0]) {
            translate([0,mag_rad*cos(ia),mag_hgt]) {
                neck_space_mag_screw_co(ia);
            }
        }
    }
    
    *translate([0,-40,0]) {
        for(ia=[75]) translate([mag_rad*sin(ia),0,0]) {
            rotate([15-asin(mag_hgt/(mag_rad*cos(ia)+(-40)))*0,0,0]) translate([0,-(mag_rad*cos(ia)+(-40)),0]) {
                neck_space_mag_screw_co(ia);
            }
        }
    }
    
    translate([0,-40-25*cos(15),-25*sin(15)]) {
        for(ia=[135,165]) translate([mag_rad*sin(ia),0,0]) {
            rotate([15+15+asin(mag_hgt/(mag_rad*cos(ia)-(-40-25))),0,0]) translate([0,mag_rad*cos(ia)-(-40-25),0]) {
                neck_space_mag_screw_co(ia);
            }
        }
    }
}

module neck_space_mag_screw_co(ia) {
    translate([0,0,-50]) rotate([0,0,90]) hull() cylinder_oh(1.5+0.15,50+10);
    translate([0,0,-5-50]) rotate([0,0,90]) hull() cylinder_oh(3,50);
    
    translate([0,0,5]) rotate([0,0,-ia]) hull() for(j=[0,-20]) translate([0,j,0]) {
        cylinder(r=0.01,h=5+3/cos(30));
        for(i=[0:5]) rotate([0,0,i*60]) translate([0,3/cos(30),0]) {
            cylinder(r=0.15,h=5);
        }
    }
}
