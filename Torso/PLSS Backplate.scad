
plate_widh = pack_widh-10-5;
plate_hgth = pack_hgth-10-5;

plate_seam_y = [-plate_hgth*1/3,plate_hgth*1/3];
//plate_seam_y = [-100,100];

module backplate_segment_a() {
    backplate_segment() {
        backplate_segment_a_corners() cylinder(r=0.4,h=200);
    }
}

module backplate_segment_b() {
    backplate_segment() {
        backplate_segment_b_corners() cylinder(r=0.4,h=200);
    }
}

module backplate_segment_c() {
    backplate_segment() {
        backplate_segment_c_corners() cylinder(r=0.4,h=200);
    }
}

module backplate_segment_corners() {
    backplate_segment_a_corners() children();
    backplate_segment_b_corners() children();
    backplate_segment_c_corners() children();
}

module backplate_segment_a_corners() {
    hull() for(ix=[0.2,plate_widh-0.5]-[-1,1]*0.4) {
        for(iy=[plate_seam_y[1]+0.2,plate_hgth-0.5]-[-1,1]*0.4) {
            translate([ix,iy,0]) children();
        }
    }
}

module backplate_segment_b_corners() {
    hull() for(ix=[0.2,plate_widh-0.5]-[-1,1]*0.4) {
        for(iy=[plate_seam_y[0]+0.2,plate_seam_y[1]-0.2]-[-1,1]*0.4) {
            translate([ix,iy,0]) children();
        }
    }
}

module backplate_segment_c_corners() {
    hull() for(ix=[0.2,plate_widh-0.5]-[-1,1]*0.4) {
        for(iy=[-plate_hgth+0.5,plate_seam_y[0]-0.2]-[-1,1]*0.4) {
            translate([ix,iy,0]) children();
        }
    }
}

module backplate_segment() difference() {
    union() {
        difference() {
            intersection() {
                hull() for(iy=[-1,1]*(pack_hgth-corn_rad)+[-1,0]*(corn_bev-corn_bev_btm)) {
                    corn_bev_act = (iy<0?corn_bev_btm:corn_bev);
                    corn_rad_act = (iy<0?corn_rad_btm:corn_rad);
                    
                    for(ix=[-1,1]*(pack_widh-corn_rad_act)) {
                        for(ib=[0,corn_bev_act]) {
                            translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev_act-ib),0]) {
                                translate([0,0,pack_thk-5]) cylinder(r=corn_rad_act-10-5-0.5-0.4,h=6);
                                translate([0,0,pack_thk-5+0.4]) cylinder(r=corn_rad_act-10-5-0.5,h=6-2*0.4);
                            }
                        }
                    }
                }
                
                backplate_segment_corners() translate([0,0,pack_thk-5]) {
                    cylinder(r=0.01,h=5+1);
                    translate([0,0,0.4]) cylinder(r=0.4,h=5+1-2*0.4);
                }
                
                children();
            }
            
            //slots for joining tabs
            backplate_tab_horiz_loc() {
                backplate_tab_horiz_corners() translate([0,0,pack_thk+1-2.4]) {
                    translate([0,0,-(5-1)+0.4]) cylinder(r=1,h=50);
                    translate([0,0,0.4]) cylinder(r=5,h=50);
                }
                backplate_tab_horiz_corners() translate([0,0,pack_thk+1]) {
                    cylinder(r=5+0.4,h=50);
                    translate([0,0,-0.4]) cylinder(r=5,h=50);
                }
            }
            
            backplate_tab_horizvert_loc() {
                backplate_tab_horizvert_corners() translate([0,0,pack_thk+1-2.4]) {
                    translate([0,0,-(5-1)+0.4]) cylinder(r=1,h=50);
                    translate([0,0,0.4]) cylinder(r=5,h=50);
                }
                backplate_tab_horizvert_corners() translate([0,0,pack_thk+1]) {
                    cylinder(r=5+0.4,h=50);
                    translate([0,0,-0.4]) cylinder(r=5,h=50);
                }
                translate([0,0,pack_thk+1-2.4]) for(ia=[0:3]) rotate([0,0,ia*90]) translate([-10-5,-10-5,0]) rotate_extrude(angle=90) polygon([
                    [5+5,0],
                    [5+5,50],
                    [5-0.4,50],
                    [5-0.4,2.4],
                    [5,2.4-0.4],
                    [5,0.4],
                    [5+0.4,0],
                ]);
            }
            
            backplate_tab_vert_loc() {
                backplate_tab_vert_corners() translate([0,0,pack_thk+1-2.4]) {
                    translate([0,0,-(5-1)+0.4]) cylinder(r=1,h=50);
                    translate([0,0,0.4]) cylinder(r=5,h=50);
                }
                backplate_tab_vert_corners() translate([0,0,pack_thk+1]) {
                    cylinder(r=5+0.4,h=50);
                    translate([0,0,-0.4]) cylinder(r=5,h=50);
                }
            }
        }
        intersection() {
            hull() for(iy=[-1,1]*(pack_hgth-corn_rad)+[-1,0]*(corn_bev-corn_bev_btm)) {
                corn_bev_act = (iy<0?corn_bev_btm:corn_bev);
                corn_rad_act = (iy<0?corn_rad_btm:corn_rad);
                
                for(ix=[-1,1]*(pack_widh-corn_rad_act)) {
                    for(ib=[0,corn_bev_act]) {
                        translate([ix-sign(ix)*ib,iy-sign(iy)*(corn_bev_act-ib),0]) {
                            translate([0,0,pack_thk-5]) cylinder(r=corn_rad_act-10-5-0.5-0.4,h=6);
                            translate([0,0,pack_thk-5+0.4]) cylinder(r=corn_rad_act-10-5-0.5,h=6-2*0.4);
                        }
                    }
                }
            }
            
            backplate_segment_corners() translate([0,0,pack_thk-5]) {
                cylinder(r=0.01,h=5+1-2.4);
                translate([0,0,0.4]) cylinder(r=0.4,h=5+1-2.4-2*0.4);
            }
            
            children();
        }
    }
    
    //screw holes for joining tabs
    backplate_tab_screws();
    
    //show corners
    *for(ixm=[0,1]) mirror([ixm,0,0]) hull() for(ix=[pack_widh-corn_rad-corn_bev+5,400]) for(iy=[pack_hgth-corn_rad-corn_bev+5,400]) translate([ix,iy,pack_thk]) cylinder(r=5,h=50);
    *for(ixm=[0,1]) mirror([ixm,0,0]) hull() for(ix=[pack_widh-corn_rad_btm-corn_bev_btm+5,400]) for(iy=[-(pack_hgth-corn_rad_btm-corn_bev_btm+5),-400]) translate([ix,iy,pack_thk]) cylinder(r=5,h=50);
    
    
    //holes for screws to attach to pack
    heatset_segment() {
        translate([0,0,pack_thk-5]) {
            cylinder(r=1.5+0.15,h=6+1);
            translate([0,0,-0.01]) cylinder(r1=1.5+0.15+0.4,r2=1.5+0.15,h=0.4);
            translate([0,0,3-0.4+0.01]) cylinder(r1=1.5+0.15,r2=1.5+0.15+0.4,h=0.4);
            
            //recess for screw heads
            translate([0,0,3]) hull() {
                cylinder(r=3-0.4,h=50);
                translate([0,0,0.4]) cylinder(r=3,h=50);
            }
            translate([0,0,5+1-0.4+0.01]) cylinder(r1=3,r2=3+0.4,h=0.4);
        }
    }
    
    //triangular grid cutout 
    trigrid_r = 2;
    trigrid_hh = 12.5;
    trigrid_wh = trigrid_hh*tan(30);
    for(ix=[-20:20]) for(iy=[-20:20]) translate([ix*2*trigrid_wh,iy*2*trigrid_hh,0]) {
        mirror([0,(floor(abs(ix)/2)*2==abs(ix)?0:1),0]) mirror([0,(floor(abs(iy)/2)*2==abs(iy)?0:1),0]) {
            //dont cutout the grid in these locations
            //side edge clearance
            if(abs(ix*2*trigrid_wh)>plate_widh-10-trigrid_wh) {
            //top/bottom edge clearance
            } else if(abs(iy*2*trigrid_hh)>plate_hgth-10-trigrid_hh) {
                
            //vert seam clearance
            } else if(abs(0-ix*2*trigrid_wh)<10+5+trigrid_wh) {
            //horiz seam clearance
            } else if(abs(plate_seam_y[0]-iy*2*trigrid_hh)<10+5+trigrid_hh) {
            } else if(abs(plate_seam_y[1]-iy*2*trigrid_hh)<10+5+trigrid_hh) {
            
            //top corner clearance
            } else if(abs(ix*2*trigrid_wh)>plate_widh-corn_rad-corn_bev-5-trigrid_wh && iy*2*trigrid_hh>plate_hgth-corn_rad-corn_bev-5-trigrid_hh) {
            //bottom corner clearance
            } else if(abs(ix*2*trigrid_wh)>plate_widh-corn_rad_btm-corn_bev_btm-5-trigrid_wh && -iy*2*trigrid_hh>plate_hgth-corn_rad_btm-corn_bev_btm-5+trigrid_hh) {
            
            } else {
                //cutout each triangle in the grid
                translate([0,2*trigrid_wh/tan(60)-trigrid_hh,0]) {
                    hull() for(ia=[0:2]) rotate([0,0,ia*360/3]) translate([0,2*trigrid_wh/cos(30)-(1.2+trigrid_r)/sin(30),pack_thk-5]) cylinder(r=trigrid_r,h=6);
                    //bevel
                    hull() for(ia=[0:2]) rotate([0,0,ia*360/3]) translate([0,2*trigrid_wh/cos(30)-(1.2+trigrid_r)/sin(30),pack_thk-6-0.01]) cylinder(r1=trigrid_r+0.4,r2=trigrid_r,h=0.4);
                    hull() for(ia=[0:2]) rotate([0,0,ia*360/3]) translate([0,2*trigrid_wh/cos(30)-(1.2+trigrid_r)/sin(30),pack_thk-5+6-0.4+0.01]) cylinder(r1=trigrid_r,r2=trigrid_r+0.4,h=0.4);
                }
            }
        }
    }
}

module backplate_tab_horiz(single=false) intersection() {
    difference() {
        backplate_tab_horiz_loc(single) backplate_tab_horiz_corners() translate([0,0,pack_thk+1-2.4]) {
            cylinder(r=5-0.4-0.4,h=2.4);
            translate([0,0,0.4]) cylinder(r=5-0.4,h=2.4-2*0.4);
        }
        backplate_tab_screws();
    }
    hull() for(ixm=[0,1]) mirror([ixm,0,0]) backplate_segment_corners() translate([0,0,pack_thk+1-2.4]) {
        cylinder(r=0.01,h=2.4);
        translate([0,0,0.4]) cylinder(r=0.4,h=2.4-2*0.4);
    }
}

module backplate_tab_vert(single=false) intersection() {
    difference() {
        backplate_tab_vert_loc(single) backplate_tab_vert_corners() translate([0,0,pack_thk+1-2.4]) {
            cylinder(r=5-0.4-0.4,h=2.4);
            translate([0,0,0.4]) cylinder(r=5-0.4,h=2.4-2*0.4);
        }
        backplate_tab_screws();
    }
    hull() for(ixm=[0,1]) mirror([ixm,0,0]) backplate_segment_corners() translate([0,0,pack_thk+1-2.4]) {
        cylinder(r=0.01,h=2.4);
        translate([0,0,0.4]) cylinder(r=0.4,h=2.4-2*0.4);
    }
}

module backplate_tab_horizvert(single=false) {
    difference() {
        backplate_tab_horizvert_loc(single) {
            backplate_tab_horizvert_corners() translate([0,0,pack_thk+1-2.4]) {
                cylinder(r=5-0.4-0.4,h=2.4);
                translate([0,0,0.4]) cylinder(r=5-0.4,h=2.4-2*0.4);
            }
            translate([0,0,pack_thk+1-2.4]) for(ia=[0:3]) rotate([0,0,ia*90]) translate([-10-5,-10-5,0]) rotate_extrude(angle=90) polygon([
                [5+5,0],
                [5+5,2.4],
                [5+0.4+0.4,2.4],
                [5+0.4,2.4-0.4],
                [5+0.4,0.4],
                [5+0.4+0.4,0],
            ]);
        }
        backplate_tab_screws();
    }
}

module backplate_tab_screws() {
    for(ix=[-1,0,1]*plate_widh) for(iy=[-1,0,0,1]*plate_hgth+[0,1,0,0]*plate_seam_y[0]+[0,0,1,0]*plate_seam_y[1]) translate([ix,iy,pack_thk-5]) {
        for(ixm=[0,1]) mirror([ixm,0,0]) for(iym=[0,1]) mirror([0,iym,0]) {
            if(abs(iy)!=plate_hgth) translate([30,5,0]) {
                cylinder(r=1.25,h=5+1-2.4);
                translate([0,0,-0.01]) cylinder(r1=1.25+0.4,r2=1.25,h=0.4);
                
                translate([0,0,5+1-2.4]) {
                    translate([0,0,-0.4+0.01]) cylinder(r1=1.25,r2=1.25+0.4,h=0.4);
                    
                    cylinder(r=1.5+0.15,h=20);
                    translate([0,0,-0.01]) cylinder(r1=1.5+0.15+0.4,r2=1.5+0.15,h=0.4);
                }
                translate([0,0,5+1]) hull() {
                    cylinder(r=3,h=20);
                    translate([0,0,-3]) cylinder(r=0.01,h=20);
                }
            }
            if(ix==0) translate([5,30,0]) {
                cylinder(r=1.25,h=5+1-2.4);
                translate([0,0,-0.01]) cylinder(r1=1.25+0.4,r2=1.25,h=0.4);
                
                translate([0,0,5+1-2.4]) {
                    translate([0,0,-0.4+0.01]) cylinder(r1=1.25,r2=1.25+0.4,h=0.4);
                    
                    cylinder(r=1.5+0.15,h=20);
                    translate([0,0,-0.01]) cylinder(r1=1.5+0.15+0.4,r2=1.5+0.15,h=0.4);
                }
                translate([0,0,5+1]) hull() {
                    cylinder(r=3,h=20);
                    translate([0,0,-3]) cylinder(r=0.01,h=20);
                }
            }
        }
    }
}

module backplate_tab_horiz_loc(single=false) {
    for(iy2=(single?[plate_seam_y[0]]:plate_seam_y)) translate([0,iy2,0]) {
        for(ixm=(single?[1]:[0,1])) mirror([ixm,0,0]) {
            children();
        }
    }
}

module backplate_tab_horizvert_loc(single=false) {
    for(iy2=(single?[plate_seam_y[0]]:plate_seam_y)) translate([0,iy2,0]) {
        children();
    }
}

module backplate_tab_vert_loc(single=false) {
    for(iym=(single?[0]:[0,1])) mirror([0,iym,0]) {
        children();
    }
}

module backplate_tab_horiz_corners() {
    hull() for(ix=[-plate_widh,-80-5-5/2]) for(iy=[-1,1]*5) translate([ix,iy,0]) {
        children();
    }
}

module backplate_tab_horizvert_corners() {
    hull() for(ix=[-1,1]*(80-5-5/2)) for(iy=[-1,1]*5) translate([ix,iy,0]) {
        children();
    }
    hull() for(ix=[-1,1]*5) for(iy=[-1,1]*(plate_hgth/3-5-5/2)) translate([ix,iy,0]) {
        children();
    }
}

module backplate_tab_vert_corners() {
    hull() for(iy=[plate_hgth,plate_hgth*2/3+5+5/2]) for(ix=[-1,1]*5) translate([ix,iy,0]) {
        children();
    }
}


module backplate_tab_corner_co() {
}