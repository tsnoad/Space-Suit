
include <Torso Mk 3.scad>;

$fn = 72;


//translate([-15,-20,-780]) {
*intersection() {
    translate([0,55,27.5]) {
        translate([0,50,-550]) rotate([0,0,-5]) scale(1000) rotate([90,0,0]) import("/Users/tsnoad/Downloads/Untitled_Scan_13_20_19.stl", convexity=10);
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


pack_widh = 320/2;
pack_hgth = 450/2;
pack_thk = 100;
seg_hgth = 2/5;

corn_rad = 50;
corn_bev = 25;

    scal_widh = pack_widh-corn_rad-corn_bev;
    scal_dep = 25;
    scal_rad = (pow(scal_widh,2) + pow(scal_dep,2)) / (2*scal_dep);
    

echo(2*seg_hgth*pack_hgth+15)
echo((1-seg_hgth)*pack_hgth+(corn_rad-5)*sin(45)+15/sin(45));

echo(seg_hgth*pack_hgth + (1-seg_hgth)*pack_hgth+(corn_rad-5)*sin(45)+15/sin(45));



*plss_segment([1],[-1]);


//show_segments = [1,1,1,0,0,1,1,0,0,0,0,0,1,1];
//show_segments = [1,1,1,1,1,1,1,1,1,1,1,1,1,1];
//show_segments = [1,0,1,0,1,0,1,0,1,0,1,0,1,0];
//show_segments = [0,0,0,0,0,0,0,0,0,0,0,0,0,1];
show_segments = [0,0,0,0,0,0,0,0,0,0,0,0,1,0];

translate([0,-100,-150]) rotate([90,0,0]) difference() {
    union() {
        difference() {
            union() {
                difference() {
                    intersection() {
                        plss_shape_pos(0);
                        segment_intersect(show_segments);
                    }
                    plss_shape_pos(-5,-5);
                    plss_back_co();
                }
                
                intersection() {
                    plss_scal_co(-5);
                    plss_shape_pos(0);
                    segment_intersect(show_segments);
                }
            }
            plss_scal_co(0);
        }
        
        intersection() {
            rotate([-90,0,0]) translate([0,100,150]) plss_torso_studs();
            plss_scal_co(-5);
            segment_intersect(show_segments);
        }
            
        flange_segment_intersect(show_segments);
    }
    
    flange_screw_segment();
    
    rotate([-90,0,0]) translate([0,100,150]) torso_stud_cos();
    
    
}



module plss_torso_stud_location() {
    for(ix=[-75,75]) translate([ix,0,-250]) children();
}

module plss_datum_from_torso() {
}

module torso_datum_from_plss() {
}
    
module segment_intersect(include_segs=[1,1,1,1,1,1,1,1,1,1,1,1,1,1],btm_inset=0,top_inset=0) {
    translate([0,0,-50]) linear_extrude(height=200,convexity=10) for(ia=[0,7]) rotate([0,0,(ia/7)*180]) {
        //A
        if(include_segs[0+ia]) polygon([
            [(pack_widh-corn_bev-corn_rad),seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [pack_widh,seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [pack_widh,(pack_hgth-corn_bev-corn_rad)+corn_rad*tan(45)],
            [(pack_widh-corn_bev-corn_rad),(pack_hgth-corn_bev-corn_rad)-corn_bev*tan(45)],
        ]);
        
        //B
        if(include_segs[1+ia]) polygon([
            [(pack_widh-corn_bev-corn_rad),(pack_hgth-corn_bev-corn_rad)-corn_bev*tan(45)],
            [pack_widh,(pack_hgth-corn_bev-corn_rad)+corn_rad*tan(45)],
            [pack_widh,pack_hgth],
            [(pack_widh-corn_bev-corn_rad),pack_hgth],
        ]);
        
        //C
        if(include_segs[2+ia]) polygon([
            [0,seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [(pack_widh-corn_bev-corn_rad),seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [(pack_widh-corn_bev-corn_rad),pack_hgth],
            [0,pack_hgth],
        ]);
        
        //D
        if(include_segs[3+ia]) polygon([
            [-((pack_widh-corn_bev-corn_rad))+corn_bev*tan(45),(pack_hgth-corn_bev-corn_rad)],
            [0,(pack_hgth-corn_bev-corn_rad)],
            [0,pack_hgth],
            [-((pack_widh-corn_bev-corn_rad))-corn_rad*tan(45),pack_hgth],
        ]);
        
        //E
        if(include_segs[4+ia]) polygon([
            [-pack_widh,(pack_hgth-corn_bev-corn_rad)],
            [-((pack_widh-corn_bev-corn_rad))+corn_bev*tan(45),(pack_hgth-corn_bev-corn_rad)],
            [-((pack_widh-corn_bev-corn_rad))-corn_rad*tan(45),pack_hgth],
            [-pack_widh,pack_hgth],
        ]);
        
        //F
        if(include_segs[5+ia]) polygon([
            [-pack_widh,seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [0,seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [0,(pack_hgth-corn_bev-corn_rad)],
            [-pack_widh,(pack_hgth-corn_bev-corn_rad)],
        ]);
        
        //G
        if(include_segs[6+ia]) polygon([
            [-pack_widh,-seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [0,-seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [0,seg_hgth*(pack_hgth-corn_bev-corn_rad)],
            [-pack_widh,seg_hgth*(pack_hgth-corn_bev-corn_rad)],
        ]);
    }
}

module flange_segment_intersect(include_segs=[1,1,1,1,1,1,1,1,1,1,1,1,1,1]) difference() {
    intersection() {
        for(ia=[0,7]) rotate([0,0,(ia/7)*180]) {
            if(include_segs[0+ia]) flange_int_shape([(pack_widh-corn_rad),(pack_hgth-corn_bev-corn_rad),0],45,corn_bev/cos(45),true);
            
            if(include_segs[1+ia]) flange_int_shape([(pack_widh-corn_bev-corn_rad),(pack_hgth-corn_rad),0],90,(corn_bev+corn_bev),true);
            
            if(include_segs[2+ia]) flange_int_shape([0,(pack_hgth-corn_rad),0],90,(1-seg_hgth)*(pack_hgth-corn_bev-corn_rad)+corn_bev);
            
            if(include_segs[3+ia]) flange_int_shape([-(pack_widh-corn_bev-corn_rad),(pack_hgth-corn_rad),0],135,corn_bev/cos(45),true);
            
            if(include_segs[4+ia]) flange_int_shape([-(pack_widh-corn_rad),(pack_hgth-corn_bev-corn_rad),0],180,(corn_bev+corn_bev),true);
            
            if(include_segs[5+ia]) flange_int_shape([-(pack_widh-corn_rad),seg_hgth*(pack_hgth-corn_bev-corn_rad),0],180,pack_widh-corn_rad);
            
            if(include_segs[6+ia]) flange_int_shape([-(pack_widh-corn_rad),-seg_hgth*(pack_hgth-corn_bev-corn_rad),0],180,pack_widh-corn_rad);
        }
        
        plss_shape_pos(-5+0.01);
    }
    plss_scal_co(-5+0.01);
    
}

module flange_int_shape(flange_cent=[0,0,0],flange_rot=0,flange_len=pack_widh-corn_rad,flange_crn_diag=false) {
    flange_y = [-5+5,15-5];
    
        
    hull() {
        intersection() {
            translate(flange_cent) rotate([0,0,flange_rot]) {
                hull() for(iy=flange_y) {
                    for(ix=[-(flange_len-5-15),corn_rad]) translate([ix+(flange_crn_diag?1:0)*(ix!=corn_rad?1:0)*((iy==flange_y[1]?flange_y[1]:1)+(5-5*cos(45))),iy,0]) {
                        cylinder(r=5,h=50);
                    }
                }
            }
            plss_scal_co(-5-2.5);
        }
        intersection() {
            translate(flange_cent) rotate([0,0,flange_rot]) {
                hull() for(iy=flange_y) {
                    for(ix=[-(flange_len-5-15),corn_rad]) translate([ix+(flange_crn_diag?1:0)*(ix!=corn_rad?1:0)*((iy==flange_y[1]?flange_y[1]:1)+(5-5*cos(45))),iy,0]) {
                        if(iy==flange_y[0]) translate([0,-2.5/tan(22.5),0]) cylinder(r=5,h=50);
                    }
                }
            }
            plss_scal_co(-5);
        }
    }
        
    translate(flange_cent) rotate([0,0,flange_rot]) {
        hull() for(iy=flange_y) {
            for(ix=[-(flange_len-5-15),corn_rad]) translate([ix+(flange_crn_diag?1:0)*(ix!=corn_rad?1:0)*((iy==flange_y[1]?flange_y[1]:1)+(5-5*cos(45))),iy,0]) {
                cylinder(r=5,h=5+2.5);
                if(iy==flange_y[0]) translate([0,-2.5/tan(22.5),0]) cylinder(r=5,h=5);
            }
        }
        hull() for(iy=flange_y) {
            for(iz=[0,75]) translate([corn_rad,iy,iz]) {
                rotate([0,-90,0]) cylinder(r=5,h=5+2.5);
                if(iy==flange_y[0]) translate([0,-2.5/tan(22.5),0]) rotate([0,-90,0]) cylinder(r=5,h=5);
            }
        }
        hull() for(iy=flange_y) translate([corn_rad,iy,0]) {
            rotate([0,-45,0]) for(ix=[-25,25]) translate([ix,0,0]) {
                cylinder(r=5,h=(5+2.5)*sqrt(2)+2.5);
                if(iy==flange_y[0]) translate([0,-2.5/tan(22.5),0]) cylinder(r=(5+2.5)*sqrt(2),h=5);
            }
        }
    }
}

module flange_screw_segment() {
    for(ia=[0,1]) rotate([0,0,ia*180]) {
        translate([(pack_widh-corn_rad),(pack_hgth-corn_bev-corn_rad),0]) rotate([0,0,45]) flange_screws(-45,0);
        
        translate([(pack_widh-corn_bev-corn_rad),(pack_hgth-corn_rad),0]) rotate([0,0,90]) flange_screws(-45,0);
        
        translate([0,(pack_hgth-corn_rad),0]) rotate([0,0,90]) {
            flange_screws(0,0);
            for(iy=[
                seg_hgth*(pack_hgth-corn_bev-corn_rad)+((pack_hgth-corn_bev-corn_rad)-seg_hgth*(pack_hgth-corn_bev-corn_rad))/2,
                //pack_hgth-(corn_bev+corn_rad)*3/4
            ]) {
                iy2 = iy-70;
                
                translate([-(pack_hgth-corn_rad)+70,0,-(scal_rad-scal_dep)]) {
                    rotate([0,0,atan(7.5/iy2)]) {
                        translate([min(iy2,40),0,0]) rotate([0,asin(sqrt(pow(7.5,2)+pow(max(0,iy2-40),2))/(scal_rad+5))]) translate([0,0,scal_rad+5]) rotate([0,0,-atan(7.5/iy2)]) flange_screw_co(0,90);
                    }
                }
            }
        }
        
        translate([-(pack_widh-corn_bev-corn_rad),(pack_hgth-corn_rad),0]) rotate([0,0,135]) flange_screws(-45,0);
        
        translate([-(pack_widh-corn_rad),(pack_hgth-corn_bev-corn_rad),0]) rotate([0,0,180]) flange_screws(-45,0);
        
        translate([-(pack_widh-corn_rad),seg_hgth*(pack_hgth-corn_bev-corn_rad),0]) rotate([0,0,180]) {
            flange_screws(-45,0);
            translate([-(pack_widh-corn_rad)+40,7.5,-(scal_rad-scal_dep)]) rotate([0,asin((75-40)/(scal_rad+5))]) translate([0,0,scal_rad+5])flange_screw_co(0,0);
        }
        
        translate([-(pack_widh-corn_rad),-seg_hgth*(pack_hgth-corn_bev-corn_rad),0]) rotate([0,0,180]) {
            flange_screws(-45,0);
            for(ix=[(pack_widh-corn_bev-corn_rad)/2/*,pack_widh-(corn_bev+corn_rad)/2*/]) {
                translate([-(pack_widh-corn_rad)+40,7.5,-(scal_rad-scal_dep)]) {
                    rotate([0,asin((ix-40)/(scal_rad+5))]) translate([0,0,scal_rad+5])flange_screw_co(0,0);
                }
            }
        }
    }
}

module flange_screws(outer_rot=0,inner_rot=0) {
    translate([corn_rad-25,7.5,5]) flange_screw_co(outer_rot,inner_rot);
    
    translate([corn_rad-5,7.5,75-12.5]) rotate([0,-90,0]) flange_screw_co(0,0);
}

module flange_screw_co(outer_rot=0,inner_rot=0) {
    screw_len=6;
    screw_dep=5-1.6;
    
    translate([0,0,-screw_dep]) hull() {
        cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
        translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
        translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
    }
    
    translate([0,0,-0.01]) cylinder_oh_opt(1.5+0.15,20,true,outer_rot);
    
    translate([0,0,screw_len-screw_dep]) hull() {
        cylinder_oh_opt(3,20,true,outer_rot);
        translate([0,0,-3]) cylinder(r=0.01,h=20);
    }
}

module torso_stud_cos() {
    plss_torso_stud_location() {
        rotate([90,0,0]) hull() cylinder_oh(3+0.2,200);
        
        torso_plss_stud_plane(false) {
            rotate([90,0,0]) hull() {
                for(ia=[0,1,2,3,4,5]*60) rotate([0,0,ia]) translate([5/cos(30),0,10+5/cos(45)-5]) rotate([0,0,-ia]) {
                    translate([0,0,0.2]) cylinder_oh(0.2,200);
                    cylinder_oh(0.01,200);
                }
            }
        }
           
        hull() for(ib=[0,0.5]) intersection() {
            rotate([90,0,0]) hull() {
                for(ia=[0,1,2,3,4,5]*60) rotate([0,0,ia]) translate([5/cos(30),0,0]) rotate([0,0,-ia]) cylinder_oh(0.2+ib,200);
            }
            torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200-10-5/cos(45)+(0.5-ib),200]);
        }
        
        hull() for(ib=[0,0.5]) difference() {
            rotate([90,0,0]) cylinder_oh(3+0.2+ib,200);
            torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200-(0.5-ib),200]);
        }
        
        hull() for(ib=[0,50]) intersection() {
            rotate([90,0,0]) cylinder_oh(10+ib+10,200);
            torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200-10-5/cos(45)-50+(50-ib),200]);
        }
    }
}


module plss_torso_studs() {
    plss_torso_stud_location() {
        hull() for(ia=[0:7.5:45]) {
            intersection() {
                rotate([90,0,0]) cylinder(r=10+5*sin(ia)+(ia==45?50:0),h=100+100);
                torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200-(5-5*cos(ia)+(ia==45?50:0)),200]);
            }
        }
    }
    
    
    hull() {
        for(ix=[-25,25]) for(iz=[-50,-75]) translate([ix,-100-(scal_dep-10),iz]) {
            rotate([90,0,0]) cylinder(r1=10+10,r2=10+10+50,h=50);
        }
        /*difference() {
            for(ix=[-25,25]) for(iz=[-50,-75]) translate([ix,0,iz]) {
                rotate([90,0,0]) cylinder(r=10,h=100+100);
            }
            translate([0,(back_rad-back_dep),-back_hgt]) rotate([acos((back_hgt-67.5)/(back_rad+outset)),0,0]) cylinder(r=150,h=back_rad+outset+10);
        }
        difference() {
            for(ix=[-25,25]) for(iz=[-50,-75]) translate([ix,0,iz]) {
                rotate([90,0,0]) cylinder(r=10+75,h=100+100);
            }
            translate([0,(back_rad-back_dep)-75,-back_hgt]) rotate([acos((back_hgt-67.5)/(back_rad+outset)),0,0]) cylinder(r=200,h=back_rad+outset+10);
        }*/
    }
}


module plss_shape_pos(inset=0,inset_back=0) hull() for(ix=[-1,1]*(pack_widh-corn_rad)) for(iy=[-1,1]*(pack_hgth-corn_rad)) for(ib=[0,corn_bev]) {
    translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev-ib),0]) {
        *cylinder(r=corn_rad-10,h=pack_thk);
        *translate([0,0,10]) cylinder(r=corn_rad,h=pack_thk-2*10);
        
        ins_adj_1 = (5+inset<0 ? 2.5 : 0);
        ins_adj_2 = (5+inset<0 ? 2.5*tan(22.5) : 0);
        
        rotate_extrude($fn=$fn*2) hull() {
            $fn=$fn/2;
            for(iy=[10+ins_adj_2,pack_thk-10+inset_back-ins_adj_2]) translate([corn_rad-5-ins_adj_1,iy]) circle(r=max(0.01,5+inset));
            for(iy=[5+ins_adj_1,pack_thk-5+inset_back-ins_adj_1]) translate([corn_rad-10-ins_adj_2,iy]) circle(r=max(0.01,5+inset));
        }
    }
}


module plss_back_co() {
    hull() for(ix=[-1,1]*(pack_widh-corn_rad)) for(iy=[-1,1]*(pack_hgth-corn_rad)) for(ib=[0,corn_bev]) {
        translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev-ib),0]) {
            translate([0,0,pack_thk/2]) cylinder(r=corn_rad-10-5-10,h=100);
        }
    }
    hull() for(ix=[-1,1]*(pack_widh-corn_rad)) for(iy=[-1,1]*(pack_hgth-corn_rad))for(ib=[0,corn_bev]) {
        translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev-ib),0]) {
            translate([0,0,pack_thk-5]) cylinder(r=corn_rad-10-5,h=100);
        }
    }
}

module plss_scal_co(inset=0) {
    
    /*translate([0,scal_rad-scal_dep,-pack_hgth-0.01]) cylinder(r=scal_rad-inset,h=pack_hgth*2+2*0.01,$fn=$fn*2);
    translate([0,scal_rad-scal_dep,-pack_hgth-0.01]) cylinder(r1=scal_rad-inset+10,r2=scal_rad-inset,h=10,$fn=$fn*2);
    translate([0,scal_rad-scal_dep,pack_hgth-10+0.01]) cylinder(r1=scal_rad-inset,r2=scal_rad-inset+10,h=10,$fn=$fn*2);*/
    
    
    hull() for(iy=[70,-70]) translate([0,iy,-(scal_rad-scal_dep)]) {
        rotate_extrude($fn=$fn*4) intersection() {
            translate([40,0]) circle(r=scal_rad-inset);
            translate([0,-250]) square([500,500]);
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