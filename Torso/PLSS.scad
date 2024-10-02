

$fn = 144;


use <PLSS Torso Shared Modules.scad>;
//include <Torso Mk 3.scad>;


//Oring seal parameters
oring_rad = 1.5;
oring_area = 3.14159*pow(oring_rad,2);

oring_gland_wid = 2;
oring_gland_dep = oring_area/oring_gland_wid;

oring_tongue_hgt = oring_area/oring_gland_wid*0.25;

//echo(oring_gland_dep);
//echo(oring_tongue_hgt);

oring_gland_rad = sqrt((0.9*oring_area)/3.14159); //compress to 90%

trans_id = [[1,1,0],[1,-1,0],[-1,-1,0],[-1,1,0]];
outset_id = [[1,0,0],[0,1,0],[0,0,1]];

//clearance parameters
bev_s = 0.4;
bev_xs = 0.2;



/*union() {
    //origin is crest of shoulder
    should_rad = 30; //radius of crest
    should_ang = 25; //downward slope of shoulders to side
    should_wid_true = 120+5;
    should_widh = should_wid_true - 8*sin(should_ang); //width of torso at shoulders. this is the x dimension where the topline of the shoulder crosses the z axis

    back_dep = 95; //max depth in y axis of back
    back_hgt = 140; //location in z axis of max depth
    back_hgt2 = back_hgt/cos(should_ang); //hypotenuse of back height
    back_rad = (pow(back_dep,2) + pow(back_hgt2-should_rad,2) - pow(should_rad,2)) / (2 * (back_dep - should_rad));

    outset = 7.5;

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
    
    translate([0,0,--8*cos(should_ang)]) { 
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 4 D.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 4 CR.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 4 B.stl");
        import("/Users/tsnoad/Desktop/3d Parts/MA-3 Helmet/Torso/Torso Mk 4 A.stl");
    }
}*/



use <../PLSS Components/Gas Bottle.scad>;
use <../PLSS Components/PLSS Scrubber.scad>;
use <../PLSS Components/Heat Exchanger.scad>;


//component layouts
translate([0,-100,-150-20]) {
    rotate([0,0,180]) {
        translate([-130,80,112.5]) bottle_reg();
        #translate([-150,100,-230]) flowvalve();
    }
    *translate([-25,-10,0]) rotate([90,0,0]) assmb();

    *translate([-125,-75,-215]) {
        clr_h = 0.4;
        scrub_hgt = 300;
        scrub_box_dims = [70,70,0]*0.5 + [0,0,2+5+scrub_hgt];
        pump_box_dims = [70,70,0]*0.5 + [0,0,100+20];
    
        translate([0,0,20+scrub_box_dims[2]]) top_plenum();
        translate([0,0,20]) {
            body();
            *difference() {
                translate([0,0,2+5]) cylinder(r=55.8/2,h=scrub_hgt);
                cylinder(r=51.4/2,h=200);
            }
        }
        bottom_plenum();
        translate([scrub_box_dims[0]+clr_h+pump_box_dims[0],0,0]) translate([0,0,20]) {
            pump_housing();
            pump_mount();
        }
    }
}



corn_rad = 50; //radius of conrners
corn_bev = 40; //as well as radius corners have a diagonal section
corn_bev_btm = 10; //which is smaller on the bottom

pack_widh = 360/2;
pack_hgth = 500/2;
pack_thk = 125;

//seg_hgth = 105/pack_hgth; 
//seam_y = seg_hgth*(pack_hgth-corn_bev-corn_rad); //location of horizontal seam
seam_y = 67.2; //location of horizontal seam
seam_y_btm = seam_y+30; //longer on the bottom

seam_y_bev0 = (pack_hgth-corn_bev-corn_rad);
seam_x_bev0 = (pack_widh-corn_bev-corn_rad); //location of most common vertical seam - at the start of the diagonal bevel


//scallop cutout in back for better fit
scal_widh = pack_widh-10-20 - 40;
scal_dep = 20;
scal_rad = (pow(scal_widh,2) + pow(scal_dep,2)) / (2*scal_dep);
    





show_segments = [
    //top right
    0, //A
    0, //B
    0, //C
    
    //top left
    0, //D
    0, //E
    1, //F
    
    //left side
    0, //G
    
    //bottom left
    0, //A (H)
    0, //B (I)
    0, //C (J)
    
    //bottom right
    0, //D (K)
    0, //E (L)
    0, //F (M)
    
    //right side
    0, //G (N)
];
//show_segments = [1,1,1,1,1,1,1,1,1,1,1,1,1,1];



translate([0,-100,-150-20]) rotate([90,0,0]) !difference() {
    for(is=[0:13]) if(show_segments[is]) {
        difference() {
            union() {
                difference() {
                    //body positive
                    hull() for(ib=[0,0.4]) intersection() {
                        plss_shape_pos(-(0.4-ib));
                        segment_intersect(is,ib,ib);
                    }
                    //cutout internal
                    plss_shape_pos(-5,-5);
                    //bottom bevels on inside cutout
                    hull() for(ib=[0,0.4]) intersection() {
                        plss_shape_pos(-5+(0.4-ib),-5);
                        segment_btm_bev_intersect(is,ib-0.01);
                    }
                    //top bevels on inside cutout
                    hull() for(ib=[0,0.4]) intersection() {
                        plss_shape_pos(-5+(0.4-ib),-5);
                        segment_top_bev_intersect(is,ib-0.01);
                    }
                    
                    /*intersection() {
                        plss_shape_pos(-5,-5);
                        segment_intersect(show_segments,-0.01,ib);
                    }*/
                    
                    //recess for back lid plate
                    plss_back_co();
                }
                
                //PLSS-torso interface - internal
                intersection() {
                    translate([0,0,scal_dep+5+2.4]) rotate([-90,0,0]) translate([0,0,150+20]) port_interface_int();
                    segment_intersect(is);
                }
                
                //mounting stud grid
                intersection() {
                    union() {
                        mnt_grid(is) cylinder(r1=7.5+25,r2=7.5,h=25);
                    }
                    hull() for(ib=[0,0.4]) intersection() {
                        plss_shape_pos(-(0.4-ib));
                        segment_intersect(is,ib,ib);
                    }
                }
                
                //scallop - positive
                hull() for(ib=[0,0.4]) intersection() {
                    plss_scal_co(-5+(0.4-ib));
                    plss_shape_pos(-(0.4-ib));
                    segment_intersect(is,ib,ib);
                }
            }
            
            //cutout the scallop
            plss_scal_co(0);
            //bottom bevel on outside
            hull() for(ib=[0,0.4]) intersection() {
                plss_scal_co(-(0.4-ib));
                segment_btm_bev_intersect(is,ib-0.01);
            }
            //top bevel on outside
            hull() for(ib=[0,0.4]) intersection() {
                plss_scal_co(-(0.4-ib));
                segment_top_bev_intersect(is,ib-0.01);
            }
            
            //translate([0,0,50]) cylinder(r=1000,h=1000);
        }
        
        //PLSS-torso interface positives
        intersection() {
            rotate([-90,0,0]) translate([0,100,150+20]) plss_torso_studs();
            hull() for(ib=[0,0.4]) intersection() {
                plss_scal_co(-5+(0.4-ib));
                segment_intersect(is,ib,ib);
            }
        }
        
        //flanges
        difference() {
            flange_segment_intersect(is);
            plss_scal_co(0);
            hull() for(ib=[0,0.4]) intersection() {
                plss_scal_co(-(0.4-ib));
                segment_top_bev_intersect(is,ib-0.01);
            }
        }
    }
    
    //cutout for flange screws
    flange_screw_segment();
    
    //cutout for mounting stud grid screws
    for(is=[0:13]) if(show_segments[is]) mnt_grid(is) grid_screw_co();
    
    //PLSS-torso interface cutouts for screws, ports, nuts, etc
    rotate([-90,0,0]) translate([0,100,150+20]) torso_stud_cos();
    
    
    //cutouts for heatset nuts to attach back lid plate
    union() {
        //A
        translate([pack_widh-10-5-5,seam_y+(seam_y_bev0-(seam_y))/2,0]) rotate([0,0,0]) back_heatset_co();
        //B
        translate([seam_x_bev0+corn_bev/2+(corn_rad-10-5-5)*cos(45),seam_y_bev0+corn_bev/2+(corn_rad-10-5-5)*cos(45),0]) rotate([0,0,45]) back_heatset_co();
        //C
        translate([seam_x_bev0/2,pack_hgth-10-5-5,0]) rotate([0,0,90]) back_heatset_co();
        //D
        translate([-seam_x_bev0/2,pack_hgth-10-5-5,0]) rotate([0,0,90]) back_heatset_co();
        //E
        translate([-(seam_x_bev0+corn_bev/2+(corn_rad-10-5-5)*cos(45)),seam_y_bev0+corn_bev/2+(corn_rad-10-5-5)*cos(45),0]) rotate([0,0,-45]) back_heatset_co();
        //F
        translate([-(pack_widh-10-5-5),seam_y+(seam_y_bev0-(seam_y))/2,0]) rotate([0,0,0]) back_heatset_co();
    }
}

module back_heatset_co() {
    translate([0,0,pack_thk-20]) {
        hull() rotate([0,0,90]) cylinder_oh(2.5-0.15,50);
        translate([0,0,20-5]) hull() {
            cylinder_oh(2.5-0.15+bev_s,50);
            translate([0,0,-bev_s]) cylinder_oh(2.5-0.15,50);
        }
    }
}

module mnt_grid(only_index=undef) {
    for(ia=[0,7]) rotate([0,0,(ia/7)*180]) {
        //A
        if(show_segments[0+ia]) {
            for(iy=[120]) for(ix=[120]) translate([ix,iy,(ix>=120?-5:0)]) children();
        }
        //B
        if(show_segments[1+ia]) {
            for(iy=[200]) for(ix=[120]) translate([ix,iy,(iy>=200?-10:(ix>=120?-5:0))]) rotate([0,0,45]) children();
        }
        //C
        if(show_segments[2+ia]) {
            for(iy=[160,200]) for(ix=[40]) translate([ix,iy,(iy>=200?-10:0)]) rotate([0,0,90]) children();
        }
        //F
        if(show_segments[5+ia]) {
            for(iy=[120]) for(ix=[80,120,160]) translate([-ix,iy,(ix>=120?-5:0)]) rotate([0,0,0]) children();
        }
        //G
        if(show_segments[6+ia]) {
            for(iy=[-80,-40,0]) for(ix=[40,80,120,160]) translate([-ix,iy,(ix>=120?-5:0)]) children();
        }
    }
}

module grid_screw_co() translate([0,0,25]) {
        screw_len=8;
        screw_dep=5;
        inner_rot = 0;
        
        translate([0,0,-screw_dep]) hull() {
            cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
            translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
            translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
        }
        
        translate([0,0,-0.01]) hull() {
            translate([0,0,-(1.5+0.15-1.25)]) cylinder_oh_opt(1.25,20,true,inner_rot);
            cylinder_oh_opt(1.5+0.15,20,true,inner_rot);
        }
}



module plss_datum_from_torso() {
}

module torso_datum_from_plss() {
}
    
module segment_intersect(only_index=undef,btm_inset=0,top_inset=0) {
    /*translate([0,0,-50]) linear_extrude(height=200,convexity=10) for(ia=[0,7]) rotate([0,0,(ia/7)*180]) {
        //D
        if(include_segs[3+ia]) polygon([
            [-(seam_x_bev0)+corn_bev,seam_y_bev0],
            [0,seam_y_bev0],
            [0,pack_hgth],
            [-(seam_x_bev0)-corn_rad,pack_hgth],
        ]);
        
        //E
        if(include_segs[4+ia]) polygon([
            [-pack_widh,seam_y_bev0],
            [-(seam_x_bev0)+corn_bev,seam_y_bev0],
            [-(seam_x_bev0)-corn_rad,pack_hgth],
            [-pack_widh,pack_hgth],
        ]);
    }*/
        
    rotate([0,0,(only_index>6?180:0)]) {
        //A
        if(search(only_index,0*[1,1]+[0,7])) intersection() {
            translate([seam_x_bev0,seam_y+btm_inset,-50]) cube([(corn_bev+corn_rad),200,200]);
            
            translate([seam_x_bev0,seam_y_bev0-corn_bev,-50]) rotate([0,0,45]) translate([-100,-200-top_inset,0]) cube([400,200,200]);
        }
        
        //B
        if(search(only_index,1*[1,1]+[0,7])) intersection() {
            translate([seam_x_bev0,seam_y_bev0-corn_bev,-50]) rotate([0,0,45]) translate([-100,btm_inset,0]) cube([400,200,200]);
            
            translate([seam_x_bev0+top_inset,seam_y_bev0-corn_bev,-50]) cube([(corn_bev+corn_rad)-btm_inset-top_inset,200,200]);
        }
        
        //C
        if(search(only_index,2*[1,1]+[0,7])) {
            translate([top_inset,seam_y,-50]) cube([seam_x_bev0-btm_inset-top_inset,pack_hgth-seam_y,200]);
        }
        
        //D
        if(search(only_index,3*[1,1]+[0,7])) intersection() {
            translate([-pack_widh,seam_y_bev0,-50]) cube([pack_widh-btm_inset,pack_hgth-seam_y_bev0,200]);
            
            translate([-seam_x_bev0+corn_bev,seam_y_bev0,-50]) rotate([0,0,45]) translate([top_inset,-100,0]) cube([200,400,200]);
        }
        
        //E
        if(search(only_index,4*[1,1]+[0,7])) intersection() {
            translate([-seam_x_bev0+corn_bev,seam_y_bev0,-50]) rotate([0,0,45]) translate([-200-btm_inset,-100,0]) cube([200,400,200]);
            translate([-pack_widh,seam_y_bev0+top_inset,-50]) cube([pack_widh-(seam_x_bev0-corn_bev),pack_hgth-seam_y_bev0-top_inset,200]);
        }
        
        //F
        if(search(only_index,5*[1,1]+[0,7])) {
            translate([-pack_widh,seam_y+top_inset,-50]) cube([pack_widh,seam_y_bev0-seam_y-btm_inset-top_inset,200]);
        }
        
        //G
        if(search(only_index,6*[1,1]+[0,7])) {
            translate([-pack_widh,-(only_index<7?seam_y_btm:seam_y)+top_inset,-50]) cube([pack_widh,seam_y+seam_y_btm-btm_inset-top_inset,200]);
        }
    }
}
    
module segment_btm_bev_intersect(only_index=undef,btm_inset=0) {
    rotate([0,0,(only_index>6?180:0)]) {
        //A
        if(search(only_index,0*[1,1]+[0,7])) intersection() {
            translate([seam_x_bev0,seam_y+btm_inset,-50]) cube([(corn_bev+corn_rad),0.01,200]);
        }
        
        //B
        if(search(only_index,1*[1,1]+[0,7])) intersection() {
            translate([seam_x_bev0,seam_y_bev0-corn_bev,-50]) rotate([0,0,45]) translate([-100,btm_inset,0]) cube([400,0.01,200]);
        }
        
        //C
        if(search(only_index,2*[1,1]+[0,7])) {
            translate([seam_x_bev0-btm_inset,seam_y,-50]) cube([0.01,pack_hgth-seam_y,200]);
        }
        
        //D
        if(search(only_index,3*[1,1]+[0,7])) {
            translate([-btm_inset,seam_y_bev0,-50]) cube([0.01,pack_hgth-seam_y_bev0,200]);
        }
        
        //E
        if(search(only_index,4*[1,1]+[0,7])) intersection() {
            translate([-seam_x_bev0+corn_bev,seam_y_bev0,-50]) rotate([0,0,45]) translate([-btm_inset,-100,0]) cube([0.01,400,200]);
        }
        
        //F
        if(search(only_index,5*[1,1]+[0,7])) {
            translate([-pack_widh,seam_y_bev0-btm_inset,-50]) cube([pack_widh,0.01,200]);
        }
        
        //G
        if(search(only_index,6*[1,1]+[0,7])) {
            translate([-pack_widh,(only_index<7?seam_y:seam_y_btm)-btm_inset,-50]) cube([pack_widh,0.01,200]);
        }
    }
}
module segment_top_bev_intersect(only_index=undef,top_inset=0) {
    rotate([0,0,(only_index>6?180:0)]) {
        //A
        if(search(only_index,0*[1,1]+[0,7])) intersection() {
            translate([seam_x_bev0,seam_y_bev0-corn_bev,-50]) rotate([0,0,45]) translate([-100,0.01-top_inset,0]) cube([400,0.01,200]);
        }
        
        //B
        if(search(only_index,1*[1,1]+[0,7])) intersection() {
            translate([seam_x_bev0+top_inset,seam_y_bev0-corn_bev,-50]) cube([0.01,200,200]);
        }
        
        //C
        if(search(only_index,2*[1,1]+[0,7])) {
            translate([top_inset,seam_y,-50]) cube([0.01,pack_hgth-seam_y,200]);
        }
        
        //D
        if(search(only_index,3*[1,1]+[0,7])) {
            translate([-seam_x_bev0+corn_bev,seam_y_bev0,-50]) rotate([0,0,45]) translate([top_inset,-100,0]) cube([0.01,400,200]);
        }
        
        //E
        if(search(only_index,4*[1,1]+[0,7])) intersection() {
            translate([-pack_widh,seam_y_bev0+top_inset,-50]) cube([pack_widh-(seam_x_bev0-corn_bev),0.01,200]);
        }
        
        //F
        if(search(only_index,5*[1,1]+[0,7])) {
            translate([-pack_widh,seam_y+top_inset,-50]) cube([pack_widh,0.01,200]);
        }
        
        //G
        if(search(only_index,6*[1,1]+[0,7])) {
            translate([-pack_widh,-(only_index<7?seam_y_btm:seam_y)-top_inset,-50]) cube([pack_widh,0.01,200]);
        }
    }
}

module flange_segment_intersect(only_index=undef) difference() {
    intersection() {
        rotate([0,0,(only_index>6?180:0)]) {
            //A
            if(search(only_index,0*[1,1]+[0,7])) flange_int_shape([(pack_widh-corn_rad),seam_y_bev0,0],45,corn_bev/cos(45),true);
            
            //B
            if(search(only_index,1*[1,1]+[0,7])) flange_int_shape([seam_x_bev0,(pack_hgth-corn_rad),0],90,(corn_bev+corn_bev),true);
            
            //C
            if(search(only_index,2*[1,1]+[0,7])) flange_int_shape([0,(pack_hgth-corn_rad),0],90,seam_y_bev0-seam_y+corn_bev-65);
            
            //D
            if(search(only_index,3*[1,1]+[0,7])) flange_int_shape([-seam_x_bev0,(pack_hgth-corn_rad),0],135,corn_bev/cos(45),true);
            
            if(search(only_index,4*[1,1]+[0,7])) flange_int_shape([-(pack_widh-corn_rad),seam_y_bev0,0],180,(corn_bev+corn_bev),true);
            
            //F
            if(search(only_index,5*[1,1]+[0,7])) flange_int_shape([-(pack_widh-corn_rad),seam_y,0],180,pack_widh-corn_rad-55);
            
            //G
            if(search(only_index,6*[1,1]+[0,7])) {
                flange_int_shape([-(pack_widh-corn_rad),-(only_index<7?seam_y_btm:seam_y),0],180,pack_widh-corn_rad-55);
                
                //lateral flange
                flange_int_side_shape([0,seam_y,0],seam_y);
            }
        }
        
        union() {
            plss_shape_pos(-5+0.01);
            
            intersection() {
                plss_shape_pos(-5/2);
                segment_intersect(only_index);
            }
        }
    }
    
    plss_scal_co(-5/2);
        
    difference() {
        plss_scal_co(-5+0.01);
        segment_intersect(only_index);
    }
    
}

module flange_int_shape(flange_cent=[0,0,0],flange_rot=0,flange_len=pack_widh-corn_rad,flange_crn_diag=false) {
    flange_y = [-5+5,15-5];
    
    hull() {
        intersection() {
            translate(flange_cent) rotate([0,0,flange_rot]) {
                hull() for(iy=flange_y) {
                    for(ix=[-(flange_len-5-15),corn_rad]) translate([ix+(flange_crn_diag?1:0)*(ix!=corn_rad?1:0)*((iy==flange_y[1]?flange_y[1]-flange_y[0]:0)+(5+0.5)/cos(45)),iy,0]) {
                        cylinder(r=5,h=50);
                    }
                }
            }
            plss_scal_co(-5-2.5);
        }
        intersection() {
            translate(flange_cent) rotate([0,0,flange_rot]) {
                hull() for(iy=flange_y) {
                    for(ix=[-(flange_len-5-15),corn_rad]) translate([ix+(flange_crn_diag?1:0)*(ix!=corn_rad?1:0)*((iy==flange_y[1]?flange_y[1]-flange_y[0]:0)+(5+0.5)/cos(45)),iy,0]) {
                        if(iy==flange_y[0]) translate([0,-2.5/tan(22.5),0]) cylinder(r=5,h=50);
                    }
                }
            }
            plss_scal_co(-5);
        }
    }
    
    
    //not affected by the scallop
    translate(flange_cent) rotate([0,0,flange_rot]) {
        hull() for(iy=flange_y) {
            for(ix=[-(flange_len-5-15),corn_rad]) translate([ix+(flange_crn_diag?1:0)*(ix!=corn_rad?1:0)*((iy==flange_y[1]?flange_y[1]-flange_y[0]:0)+(5+0.5)/cos(45)),iy,0]) {
                cylinder(r=5,h=5+2.5);
                if(iy==flange_y[0]) translate([0,-2.5/tan(22.5),0]) cylinder(r=5,h=5);
            }
        }
        hull() for(iy=flange_y) {
            for(iz=[0,pack_thk-25]) translate([corn_rad,iy,iz]) {
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


module flange_int_side_shape(flange_cent=[0,0,0],flange_len) {
    flange_x = [-5+5,15-5];
    
    intersection() {
        translate(flange_cent) {
            hull() for(ix=flange_x-[0,5]) for(iy=[0,-(flange_len-5-5)]) {
                translate([ix,iy,0]) cylinder(r=5,h=50);
            }
            hull() for(ix=flange_x[1]*[1,1]-[0,5]) for(iy=[-(15-5),-15]) {
                if(ix!=flange_x[1] || iy==-15)  translate([ix,iy,0]) cylinder(r=5,h=50);
            }
            hull() for(ix=flange_x) for(iy=[0,-(flange_len-5-5)]-[15,0]) {
                translate([ix,iy,0]) cylinder(r=5,h=50);
            }
        }
        plss_scal_co(-5-2.5);
        translate(flange_cent+[-250,-500,0]) cube([500,500,500]);
    }
    
        
    hull() {
        intersection() {
            translate(flange_cent) {
                hull() for(ix=flange_x[0]) {
                    for(iy=[0,-(flange_len-5-5)]) translate([ix,iy,0]) {
                        cylinder(r=5,h=50);
                    }
                }
            }
            plss_scal_co(-5-2.5);
            translate(flange_cent+[-250,-500,0]) cube([500,500,500]);
        }
        intersection() {
            translate(flange_cent) {
                hull() for(ix=flange_x[0]) {
                    for(iy=[0,-(flange_len-5-5)]) translate([ix,iy,0]) {
                        if(ix==flange_x[0]) translate([-2.5/tan(45),0,0]) cylinder(r=5,h=50);
                    }
                }
            }
            plss_scal_co(-5);
            translate(flange_cent+[-250,-500,0]) cube([500,500,500]);
        }
    }
}

module position_screw_on_scal(screw_x,screw_y,inner_rot=0,outer_rot=0) {
    y_crit = (pack_hgth-pack_widh);
    x_crit = 40;

    if(abs(screw_y)<=y_crit) {
        if(abs(screw_x)<=x_crit) {
            translate([screw_x,screw_y,scal_dep+5]) flange_screw_co(inner_rot,outer_rot);
        } else {
            screw_x_frmtc = abs(screw_x)-x_crit;
            
            translate([0,screw_y,-(scal_rad-scal_dep)]) {
                translate([sign(screw_x)*x_crit,0,0]) rotate([0,sign(screw_x)*asin(screw_x_frmtc/(scal_rad+5))]) {
                    translate([0,0,scal_rad+5]) flange_screw_co(inner_rot,outer_rot);
                }
            }
        }
    } else {
        screw_y_frmtc = abs(screw_y)-y_crit;
        screw_hyp = sqrt(pow(screw_x,2)+pow(screw_y_frmtc,2));
    
        if(abs(screw_hyp)<=x_crit) {
            translate([screw_x,screw_y,scal_dep+5]) flange_screw_co(inner_rot,outer_rot);
        } else {
            screw_hyp_oncrv = screw_hyp-x_crit;
            
            translate([0,y_crit,-(scal_rad-scal_dep)]) rotate([0,0,atan2(sign(screw_y)*screw_y_frmtc,screw_x)]) { 
                translate([x_crit,0,0]) rotate([0,asin(screw_hyp_oncrv/(scal_rad+5))]) {
                    rotate([0,0,-atan2(sign(screw_y)*screw_y_frmtc,screw_x)]) {
                        translate([0,0,scal_rad+5]) flange_screw_co(inner_rot,outer_rot);
                    }
                }
            }
        }
    }
}

module flange_screw_segment() {
    for(ia=[0,1]) rotate([0,0,ia*180]) {
        //A
        translate([(pack_widh-corn_rad),seam_y_bev0,0]) rotate([0,0,45]) flange_screws(-45,0,-15);
        
        //B
        translate([seam_x_bev0,(pack_hgth-corn_rad),0]) rotate([0,0,90]) flange_screws(-45,0);
        //dont replace this, it doesnt line up with already printed parts
        translate([0,(pack_hgth-corn_rad),0]) rotate([0,0,90]) {
            for(iy=[pack_hgth-85]) {
                iy2 = iy-70;
                ix2 = 2*7.5-seam_x_bev0;
                
                translate([-(pack_hgth-corn_rad)+70,0,-(scal_rad-scal_dep)]) {
                    rotate([0,0,atan(ix2/iy2)]) {
                        translate([min(iy2,40),0,0]) rotate([0,asin(sqrt(pow(ix2,2)+pow(max(0,iy2-40),2))/(scal_rad+5))]) translate([0,0,scal_rad+5]) rotate([0,0,-atan(ix2/iy2)]) rotate([0,0,-45]) flange_screw_co(0,90);
                    }
                }
            }
        }
        //#position_screw_on_scal(seam_x_bev0-7.5,pack_hgth-85,90,90);
        
        //C
        translate([0,(pack_hgth-corn_rad),0]) rotate([0,0,90]) {
            flange_screws(0,0);
            //dont replace this, it doesnt line up with already printed parts
            for(iy=[
                //seam_y+(seam_y_bev0-seam_y)/2,
                //pack_hgth-(corn_bev+corn_rad)
                pack_hgth - 75,
            ]) {
                iy2 = iy-70;
                
                translate([-(pack_hgth-corn_rad)+70,0,-(scal_rad-scal_dep)]) {
                    rotate([0,0,atan(7.5/iy2)]) {
                        translate([min(iy2,40),0,0]) rotate([0,asin(sqrt(pow(7.5,2)+pow(max(0,iy2-40),2))/(scal_rad+5))]) translate([0,0,scal_rad+5]) rotate([0,0,-atan(7.5/iy2)]) flange_screw_co(0,0);
                    }
                }
            }
        }
        //position_screw_on_scal(-7.5,pack_hgth-75,90,90);
        
        //D
        translate([-seam_x_bev0,(pack_hgth-corn_rad),0]) rotate([0,0,135]) flange_screws(-45,0,-15);
        
        //E
        translate([-(pack_widh-corn_rad),seam_y_bev0,0]) rotate([0,0,180]) flange_screws(-45,0);
        position_screw_on_scal(-(pack_widh-80),seam_y_bev0-7.5,-45,0);
        
        //F
        translate([-(pack_widh-corn_rad),seam_y,0]) rotate([0,0,180]) flange_screws(0,0);
        position_screw_on_scal(-(ia==0?85:75),seam_y-7.5,0,0);
        
        //G
        translate([-(pack_widh-corn_rad),-(ia==0?seam_y_btm:seam_y),0]) rotate([0,0,180]) {
            flange_screws(0,0);
            for(ix=[
                (ia==0?seam_x_bev0/2:85),
                (ia==0?seam_x_bev0/2:105),
            ]) {
                translate([-(pack_widh-corn_rad)+40,7.5,-(scal_rad-scal_dep)]) {
                    rotate([0,asin((ix-40)/(scal_rad+5))]) translate([0,0,scal_rad+5])flange_screw_co(0,90);
                }
            }
        }
        
        //G - lateral flange screws
        translate([0,seam_y,0]) rotate([0,0,180]) {
            for(iy=[25]) {
                translate([-7.5,iy,-(scal_rad-scal_dep)]) {
                    translate([0,0,scal_rad+5])flange_screw_co(0,0);
                }
            }
        }
    }
}

module flange_screws(outer_rot=0,inner_rot=0,screw_a_inset=0) {
    translate([corn_rad-25+screw_a_inset,7.5,5]) flange_screw_co(outer_rot,inner_rot);
    
    translate([corn_rad-5,7.5,(pack_thk-25-7.5)/2]) rotate([0,-90,0]) flange_screw_co(0,0);
    
    translate([corn_rad-5,7.5,pack_thk-25-7.5]) rotate([0,-90,0]) flange_screw_co(0,0);
}

module flange_screw_co(outer_rot=0,inner_rot=0) {
    screw_len=6;
    screw_dep=5-1.6;
    
    translate([0,0,-screw_dep]) hull() {
        cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
        translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
        translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
    }
    
    hull() {
        cylinder_oh_opt(1.5+0.15,20,true,outer_rot);
        translate([0,0,-(1.5+0.15)]) cylinder_oh_opt(0.01,20,true,outer_rot);
    }
    
    translate([0,0,screw_len-screw_dep]) hull() {
        cylinder_oh_opt(3,20,true,outer_rot);
        translate([0,0,-3]) cylinder(r=0.01,h=20);
    }
}

module port_interface_int() {
    hull() for(ix2=[-1,1]*(20+15)) for(iz2=[-60]) translate([ix2,0,iz2]) {
        for(ix=[-1,1]*(25)) for(iz=[-1,1]*25) hull() {
            translate([ix,0,iz]) rotate([-90,0,0]) cylinder(r1=5,r2=5+50,h=50);
        }
    }
    for(ix2=[-1,1]*(20+15)) for(iz2=[-60]) translate([ix2,0,iz2]) {
        rotate([-90,0,0]) mirror([0,0,1]) gasket_tongue_pos([35,35,0]*0.5,0,7.5,-5);
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
        
        *hull() for(ib=[0,50]) intersection() {
            rotate([90,0,0]) cylinder_oh(10+ib+10,200);
            torso_plss_stud_plane() translate([-100,-200,-100]) cube([200,200-10-5/cos(45)-50+(50-ib),200]);
        }
    }
    
    //cutouts for upper mounting bolts
    plss_torso_portcrn_location() {
        rotate([90,0,0]) hull() cylinder_oh(3+0.2,200);
    }
    
    //cutouts for nuts
    for(ix=[-1,-1,1,1]*(20+15)+[-1,1,-1,1]*(15)) for(iz=[-1,1]*15) translate([ix,0,0]) {
        torso_plss_port_plane(false,iz) rotate([0,0,(ix>0?90:0)]) {
            hull() for(ia=[0,1,2,3,4,5]*60) rotate([0,0,ia]) translate([5/cos(30),0,10]) rotate([0,0,-ia]) {
                translate([0,0,0.2]) cylinder_oh(0.2,200);
                cylinder_oh(0.01,200);
            }
            translate([0,0,10+5]) hull() {
                cylinder_oh(5/cos(30)+0.2,200);
                translate([0,0,0.5]) cylinder_oh(5/cos(30)+0.2+0.5,200);
            }
        }
    }
    
    for(ix=[-1,-1,1,1]*(20+15)+[-1,1,-1,1]*(15)) for(iz=[-1,1]*15-[1,1]*60) hull() {
        intersection() {
            translate([ix,0,iz]) rotate([90,0,0]) rotate([0,0,(ix>0?90:0)]) cylinder_oh(3+0.2,200);
            torso_plss_port_plane() translate([0,0,-100+0.5]) cylinder(r=150,h=100);
        }
        intersection() {
            translate([ix,0,iz]) rotate([90,0,0]) rotate([0,0,(ix>0?90:0)]) cylinder_oh(3+0.2+0.5,200);
            torso_plss_port_plane() translate([0,0,-100]) cylinder(r=150,h=100);
        }
    }
    
    for(ix=[-1,1]*(20+15)) for(iz=[-60]) {
        translate([ix,0,iz]) rotate([90,0,0]) rotate([0,0,(ix>0?90:0)]) hull() cylinder_oh(12.5,200);
        
        translate([0,-100-(scal_dep+5+2.4)]) translate([ix,0,iz]) rotate([90,0,0]) rotate([0,0,(ix>0?90:0)]) hull() {
            cylinder_oh(12.5+0.4,200);
            translate([0,0,-0.4]) cylinder_oh(12.5,200);
        }
        
        //bevels
        hull() {
            intersection() {
                translate([ix,0,iz]) rotate([90,0,0]) rotate([0,0,(ix>0?90:0)]) cylinder_oh(12.5,200);
                torso_plss_port_plane() translate([0,0,-100+0.5]) cylinder(r=150,h=100);
            }
            intersection() {
                translate([ix,0,iz]) rotate([90,0,0]) rotate([0,0,(ix>0?90:0)]) cylinder_oh(12.5+0.5,200);
                torso_plss_port_plane() translate([0,0,-100]) cylinder(r=150,h=100);
            }
        }
        
        //screws for port internal side
        translate([0,-100-(scal_dep+5+2.4)]) translate([ix,0,iz]) rotate([90,0,0]) for(ia=[0:90:360-90]) rotate([0,0,ia]) translate([0,17.5,0]) rotate([0,0,(ix>0?90:0)-ia]) {
            screw_len=8;
            screw_dep=5;
            inner_rot = 0;
            
            translate([0,0,-screw_dep]) hull() {
                cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
                translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
                translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
            }
            
            translate([0,0,-0.01]) hull() {
                translate([0,0,-(1.5+0.15-1.25)]) cylinder_oh_opt(1.25,20,true,inner_rot);
                cylinder_oh_opt(1.5+0.15,20,true,inner_rot);
            }
        }
            
        translate([0,-100-(scal_dep+5+2.4)]) translate([ix,0,iz]) rotate([90,0,0]) for(ia=[0:90:360-90]) rotate([0,0,ia]) translate([25,25,0]) rotate([0,0,(ix>0?90:0)-ia]) {
            screw_len=8;
            screw_dep=5;
            inner_rot = 0;
            
            translate([0,0,-screw_dep]) hull() {
                cylinder_oh_opt(1.25-0.5,20,true,inner_rot);
                translate([0,0,0.5]) cylinder_oh_opt(1.25,20,true,inner_rot);
                translate([0,0,screw_dep]) cylinder_oh_opt(1.25+0.1,20,true,inner_rot);
            }
            
            translate([0,0,-0.01]) hull() {
                translate([0,0,-(1.5+0.15-1.25)]) cylinder_oh_opt(1.25,20,true,inner_rot);
                cylinder_oh_opt(1.5+0.15,20,true,inner_rot);
            }
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
    

    hull() for(ia=[0:7.5:45]) {
        intersection() {
            plss_torso_portcrn_location() rotate([90,0,0]) cylinder(r=7.5+5*sin(ia)+(ia==45?50:0),h=200);
            torso_plss_port_plane() translate([0,0,+(5-5*cos(ia)+(ia==45?50:0))]) cylinder(r=150,h=100);
        }
    }
}


module plss_shape_pos(inset=0,inset_back=0) hull() {
    for(ix=[-1,1]*(pack_widh-corn_rad)) {
        for(iy=[-1,1]*(pack_hgth-corn_rad)+[-1,0]*(corn_bev-corn_bev_btm)) {
            for(ib=[0,(iy>0?corn_bev:corn_bev_btm)]) {
                translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev-ib),0]) {
                    ins_adj_1 = (5+inset<0 ? 2.5 : 0);
                    ins_adj_2 = (5+inset<0 ? 2.5*tan(22.5) : 0);
                    
                    rotate_extrude($fn=$fn*2) hull() {
                        $fn=$fn/2;
                        for(iy=[10+ins_adj_2,pack_thk-10+inset_back-ins_adj_2]) translate([corn_rad-5-ins_adj_1,iy]) circle(r=max(0.01,5+inset));
                        for(iy=[5+ins_adj_1,pack_thk-5+inset_back-ins_adj_1]) translate([corn_rad-10-ins_adj_2,iy]) circle(r=max(0.01,5+inset));
                    }
                }
            }
        }
    }
}


module plss_back_co() {
    hull() for(ix=[-1,1]*(pack_widh-corn_rad)) {
        for(iy=[-1,1]*(pack_hgth-corn_rad)+[-1,0]*(corn_bev-corn_bev_btm)) {
            for(ib=[0,(iy>0?corn_bev:corn_bev_btm)]) {
                translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev-ib),0]) {
                    translate([0,0,pack_thk/2]) cylinder(r=corn_rad-10-5-10,h=100);
                }
            }
        }
    }
    hull() for(ix=[-1,1]*(pack_widh-corn_rad)) {
        for(iy=[-1,1]*(pack_hgth-corn_rad)+[-1,0]*(corn_bev-corn_bev_btm)) {
            for(ib=[0,(iy>0?corn_bev:corn_bev_btm)]) {
                translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev-ib),0]) {
                    translate([0,0,pack_thk-5]) cylinder(r=corn_rad-10-5,h=100);
                }
            }
        }
    }
}

module plss_scal_co(inset=0) {
    
    /*translate([0,scal_rad-scal_dep,-pack_hgth-0.01]) cylinder(r=scal_rad-inset,h=pack_hgth*2+2*0.01,$fn=$fn*2);
    translate([0,scal_rad-scal_dep,-pack_hgth-0.01]) cylinder(r1=scal_rad-inset+10,r2=scal_rad-inset,h=10,$fn=$fn*2);
    translate([0,scal_rad-scal_dep,pack_hgth-10+0.01]) cylinder(r1=scal_rad-inset,r2=scal_rad-inset+10,h=10,$fn=$fn*2);*/
    
    
    hull() for(iy=[-1,1]*(pack_hgth-pack_widh)) translate([0,iy,-(scal_rad-scal_dep)]) {
        rotate_extrude($fn=$fn*4) intersection() {
            translate([40,0]) circle(r=scal_rad-inset);
            translate([0,-500]) square([1000,1000]);
        }
            
    }
}





module box_pos(box_dims=[1,1,1],box_hgt=1,crn_r=5) {
    box_dims_id = xyz_to_id(box_dims);
    
    hull() for(it=trans_id) translate(it*box_dims_id - it*outset_id*crn_r) {
        cylinder(r=crn_r-bev_s,h=box_hgt);
        translate([0,0,bev_s]) cylinder(r=crn_r,h=box_hgt-2*bev_s);
    }
}

module gasket_gland_cs() translate([0,-oring_gland_rad]) {
    hull() {
        circle(r=oring_gland_rad);
        
        translate([-oring_gland_rad*tan(22.5),-oring_gland_rad]) square([2*oring_gland_rad*tan(22.5),2*oring_gland_rad]);
    }
    
    translate([-2/2,0]) square([2,50]);
    
    hull() {
        circle(r=0.2+0.2);
        for(ix=[-1,1]) translate([(oring_gland_rad+0.2)*ix,oring_gland_rad+0.2]) circle(r=0.2+0.2);
    }
}

module gasket_tongue_cs() {
    translate([1.6/2,oring_gland_rad]) hull() {
        circle(r=0.2);
        for(ix=[-1,1]) translate([(oring_gland_rad+0.2)*ix,-(oring_gland_rad+0.2)]) circle(r=0.2);
    }
}

function xyz_to_id(xyz=[1,1,1]) = [[xyz[0],0,0],[0,xyz[1],0],[xyz[2],0,0]];

module gland_co(box_dims=[1,1,1],box_hgt=1,crn_r=20,inset=5) {
    box_dims_id = xyz_to_id(box_dims);
    
    for(it=trans_id) translate(it*box_dims_id - it*outset_id*(crn_r+inset)) translate([0,0,box_hgt]) rotate([0,0,atan2(it[1],it[0])-45]) {
        rotate_extrude(angle=90) mirror([0,1]) translate([crn_r,0]) gasket_gland_cs();
        rotate([90,0,0]) linear_extrude(height=((atan2(it[1],it[0])-45)%180==0?box_dims[1]:box_dims[0])*2-2*(crn_r+inset)) mirror([0,1]) translate([crn_r,0]) gasket_gland_cs();
    }
}

module gasket_tongue_pos(box_dims=[1,1,1],box_hgt=1,crn_r=20,inset=5) {
    box_dims_id = xyz_to_id(box_dims);

    for(it=trans_id) translate(it*box_dims_id - it*outset_id*(crn_r+inset)) translate([0,0,box_hgt]) rotate([0,0,atan2(it[1],it[0])-45]) {
        rotate_extrude(angle=90) translate([crn_r,0]) gasket_tongue_cs();
        
        rotate([90,0,0]) linear_extrude(height=((atan2(it[1],it[0])-45)%180==0?box_dims[1]:box_dims[0])*2-2*(crn_r+inset)) mirror([0,0]) translate([crn_r,0]) gasket_tongue_cs();
    }
}








module round_step(step_h0,step_h1,step_l,round_r0,round_r1) {
    t1_hyp = sqrt(pow(step_h1-step_h0-round_r0-round_r1,2)+pow(step_l,2));
    
    t1_theta = atan2(step_l,(step_h1-step_h0-round_r0-round_r1));
    
    t2_theta = acos((round_r0+round_r1)/t1_hyp);
    
    theta = 180 - (t1_theta + t2_theta);
    
    
    difference() {
        polygon([
            [0,0],
            [step_h0+round_r0,0],
        
            [step_h0+round_r0-round_r0*cos(theta),round_r0*sin(theta)],
    
            [step_h1-round_r1+round_r1*cos(theta),step_l-round_r1*sin(theta)],
        
            [step_h1-round_r1,step_l],
            [0,step_l],
        ]);
        translate([step_h0+round_r0,0]) circle(r=round_r0);
    }
    translate([step_h1-round_r1,step_l]) circle(r=round_r1);
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