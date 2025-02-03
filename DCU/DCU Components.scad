
module u174_bracket(co=false,screw_co=false) {
    bev_s = 0.2;
    bev_m = 0.4;
    
    if(!co && !screw_co) difference() {
        union() {
            difference() {
                hull() {
                    cylinder(r=24/2-0.2,h=-4+0.8+6);
                    translate([0,0,0.2]) cylinder(r=24/2,h=-4+0.8+6-2*0.2);
                    
                    for(ia=[0,180]) rotate([0,0,ia]) translate([sqrt(pow(r_2+(1.5+0.15)+2.4,2)-pow(24/2-(1.5+0.15)-2.4,2)),24/2-(1.5+0.15)-2.4,0]) {
                        cylinder(r=(1.5+0.15)+2.4-0.2,h=-4+0.8+6);
                        translate([0,0,0.2]) cylinder(r=(1.5+0.15)+2.4,h=-4+0.8+6-2*0.2);
                    }
                }
                
                u174_bracket(true);
            }
            
            for(ia=[0:90:360-90]) rotate([0,0,ia]) {
                hull() for(ix=[-1,1]*(5/2-0.2)-[-1,1]*0.4) for(iy=[max(14/2,17.7/2-3)+0.2,10]-[-1,0]*0.4) translate([ix,iy,0]) {
                    cylinder(r=0.4-0.2,h=-4+0.8+6);
                    translate([0,0,0.2]) cylinder(r=0.4,h=-4+0.8+6-2*0.2);
                }
            }
        }
            
        u174_bracket(false,true);
    }
    
    r_1 = 15.9/2+0.2; //radius of jack at threads
    r_2 = 17.7/2+0.2; //radius of jack at lip
    r_3 = r_2-1.6; //radius of cutout
    r_4 = max(r_3+2,15.6/2+0.4); //radius of plug rebate
    
    if(co) translate([0,0,-1]) {
        //wall cutout
        translate([0,0,1-4]) {
            hull() cylinder_oh(r_3,4);
            //outer rebate
            translate([0,0,-0.01]) hull() {
                cylinder_oh(r_4-bev_m,4-1-1.6);
                cylinder_oh(r_4,4-1-1.6-bev_m);
            }
            //outer bevel
            translate([0,0,4-1-1.6-0.01]) hull() {
                cylinder_oh(r_3,bev_s);
                translate([0,0,-0.01]) cylinder_oh(r_3+bev_s,0.01);
            }
            hull() {
                cylinder_oh(r_4,bev_m);
                translate([0,0,-0.01]) cylinder_oh(r_4+bev_m,0.01);
            }
            //inner bevel
            translate([0,0,4-1]) hull() {
                cylinder_oh(r_3+bev_s,0.01);
                translate([0,0,-bev_s]) cylinder_oh(r_3,bev_s);
            }
        }
        
        //socket flange
        hull() {
            cylinder_oh(r_2-bev_s,1);
            translate([0,0,bev_s]) cylinder_oh(r_2,1-bev_s);
        }
        translate([0,0,1]) hull() {
            cylinder_oh(r_2+bev_m,0.01);
            translate([0,0,-bev_m]) cylinder_oh(r_2,bev_m);
        }
        
        intersection() {
            union() {
                cylinder(r=r_1,h=5);
            }
            translate([-sqrt(pow(r_1,2)-pow(5/2,2)),-sqrt(pow(r_1,2)-pow(5/2,2)),0]) cube([2*sqrt(pow(r_1,2)-pow(5/2,2)),2*sqrt(pow(r_1,2)-pow(5/2,2)),20]);
        }
        
        /*intersection() {
            cylinder(r=14.8/2+0.2,h=8);
            translate([-sqrt(pow(14.8/2+0.2,2)-pow(5/2,2)),-sqrt(pow(14.8/2+0.2,2)-pow(5/2,2)),0]) cube([2*sqrt(pow(14.8/2+0.2,2)-pow(5/2,2)),2*sqrt(pow(14.8/2+0.2,2)-pow(5/2,2)),20]);
        }*/
    }
    
    if(screw_co) for(ia=[0,180]) rotate([0,0,ia]) translate([sqrt(pow(r_2+(1.5+0.15)+2.4,2)-pow(24/2-(1.5+0.15)-2.4,2)),24/2-(1.5+0.15)-2.4,-4+0.8+6]) {
        translate([0,0,-6]) hull() {
            cylinder(r=1.25-0.5,h=20);
            translate([0,0,0.5]) cylinder(r=1.25,h=20);
        }
        translate([0,0,-(-4+0.8+6)]) hull() {
            cylinder(r=(1.5+0.15),h=20);
            translate([0,0,-(1.5+0.15)]) cylinder(r=0.01,h=20);
        }
        hull() {
            cylinder(r=3,h=20);
            translate([0,0,-3]) cylinder(r=0.01,h=20);
        }
    }
}

/* Parameters for oled display */
oled_t = 2.6+0.2;
oledbrk_hgt = oled_t+0.8;

oled_active_size = [22.384,5.584,0];

//offset of the glass part (from bottom left of pcb)
//oled_glass_offset = [5,0.25,0]; //this is according to all the data sheets I could find
oled_glass_offset = [6,0.5,0]; //this is based on the measurements of the OLED I recieved
//offset of the active area (from bottom left of pcb)
oled_active_offset = oled_glass_offset+[2.1,11.5-2.1-oled_active_size[1],0];


//oled_screw_ix = [0];
//oled_screw_iy = [-1,1]*(12/2+0.4+2.4+(1.5+0.15));
//oled_disp_ix = [1,1]*38/2+[1,1]*(-7.51-22.38/2)+[-1,1]/2*22.38+[-1,1]*1;
//oled_disp_iy = -[1,1]*12/2+[1,1]*(11.5/2)+[-1,1]/2*5.58+[-1,1]*1;

oled_screw_ix = [0];
oled_screw_iy = [-1,1]*(20/2+1.5+0.15);
oled_disp_ix = [-1,1]*oled_active_size[0]/2+[-1,1]*1;
oled_disp_iy = [-1,1]*oled_active_size[1]/2+[-1,1]*1;

module oled_trans() translate(face_rcs_trans+face_oled_trans) children();

module oled_co(co_plate=false) {
    clr_h = 0.25;
    clr_h2 = 0.4;
    
    //align to bottom left of active area
    translate(-oled_active_size/2) {
        //align to bottom left of pcb
        translate(-oled_active_offset+[0,0,-oled_t]) {
            //pcb
            hull() for(ix=[0,38]) for(iy=[0,12]) translate([ix,iy,0]) cylinder(r=clr_h,h=oled_t);
            hull() for(ix=[0,38+1.1]) for(iy=[0,9.7]) translate([ix,iy,0]) cylinder(r=clr_h,h=oled_t);
            
            //pins
            hull() for(ix=[1,1]*1.5+[-1,1]*2.54/2) for(iy=[1,1]*12/2+[-2,2]*2.54) translate([ix,iy,0]) cylinder(r=clr_h,h=oled_t+1);
            hull() for(ix=[-1.8,4]) for(iy=[0,12]+[-1,1]*0.2) translate([ix,iy,-5]) cylinder(r=clr_h2,h=5+oled_t);
            
            //components
            hull() {
                for(ix=[12+(2*clr_h)+2.4,27]) for(iy=[0,12]) translate([ix,iy,-2]) cylinder(r=clr_h,h=2+oled_t);
                for(ix=[12+(2*clr_h)+2.4-3,27]) for(iy=[3,12]) translate([ix,iy,-2]) cylinder(r=clr_h,h=2+oled_t);
            }
            hull() for(ix=[4+2.4,27]) for(iy=[3,12]) translate([ix,iy,-2]) cylinder(r=clr_h,h=2+oled_t);
        }
    }
        
    //display
    //hull() for(ix=oled_disp_ix) for(iy=oled_disp_iy) translate([ix,iy,0]) cylinder(r=clr_h,h=50);
    
    /*if(co_plate) {
        translate([0,0,-oledbrk_hgt-6]) hull() {
            for(ix=[-1,1]*(38+1.1)/2) for(iy=[-1,1]*12/2) translate([ix,iy,0]) cylinder(r=clr_h+2.4+clr_h,h=50);
            for(ix=oled_screw_ix) for(iy=oled_screw_iy) translate([ix,iy,0]) cylinder(r=1.5+0.15+2.4+clr_h,h=50);
        }
    }*/
}
module oled_co_plate() oled_co(true);

module oled_screw_co() {
    for(ix=oled_screw_ix) for(iy=oled_screw_iy) translate([ix,iy,0]) {
        
        translate([0,0,-oledbrk_hgt-0.01]) cylinder(r1=3+0.2,r2=3,h=0.2);
        
        translate([0,0,-oledbrk_hgt]) hull() {
            cylinder(r=0.01,h=oledbrk_hgt+1.5+0.15);
            cylinder(r=1.5+0.15,h=oledbrk_hgt);
        }
        
        translate([0,0,-3.4]) {
            hull() {
                cylinder(r=1.25-0.5,h=6);
                cylinder(r=1.25,h=6-0.5);
            }
            translate([0,0,-10]) hull() {
                cylinder(r=0.01,h=10+3);
                cylinder(r=3,h=10);
            }
        }
    }
}

module oled_disp_co() {
    clr_h = 0.2;
    
    hull() for(ix=oled_disp_ix) for(iy=oled_disp_iy) translate([ix,iy,0]) cylinder(r1=clr_h,r2=clr_h+dcu_lid_dep*tan(30),h=dcu_lid_dep);
    
    hull() for(ix=oled_disp_ix) for(iy=oled_disp_iy) translate([ix,iy,-0.01]) cylinder(r1=clr_h+0.4,r2=clr_h,h=0.4);
    
    hull() for(ix=oled_disp_ix) for(iy=oled_disp_iy) translate([ix,iy,6-oledbrk_hgt+0.4-0.4+0.01]) cylinder(r1=clr_h+(6-oledbrk_hgt+0.4-0.4)*tan(30),r2=clr_h+(6-oledbrk_hgt+0.4-0.4)*tan(30)+0.4,h=0.4);
}

module oled_bracket() translate([0,0,0]) difference() {
    clr_h = 0.25;
    clr_h2 = 0.4;
    
    hull() {
        //align to bottom left of active area
        translate(-oled_active_size/2) {
            //align to bottom left of pcb
            translate(-oled_active_offset) {
                for(ix=[0,38+1.1]-[0,0.8]) for(iy=[0,12]) translate([ix,iy,-oledbrk_hgt]) {
                    cylinder(r=clr_h+2.4-0.2,h=oledbrk_hgt);
                    translate([0,0,0.2]) cylinder(r=clr_h+2.4,h=oledbrk_hgt-2*0.2);
                }
                for(ix=[0,38+1.1]) for(iy=[0,9.7]) translate([ix,iy,-oledbrk_hgt]) {
                    cylinder(r=clr_h+2.4-0.2,h=oledbrk_hgt);
                    translate([0,0,0.2]) cylinder(r=clr_h+2.4,h=oledbrk_hgt-2*0.2);
                }
                for(ix=[-1.8,4]) for(iy=[0,12]+[-1,1]*0.2) translate([ix,iy,-oledbrk_hgt]) {
                    cylinder(r=clr_h2+2.4-0.2,h=oledbrk_hgt);
                    translate([0,0,0.2]) cylinder(r=clr_h2+2.4,h=oledbrk_hgt-2*0.2);
                }
            }
        }
        
        for(ix=oled_screw_ix) for(iy=oled_screw_iy) translate([ix,iy,-oledbrk_hgt]) {
            cylinder(r=3+2.4-0.2,h=oledbrk_hgt);
            translate([0,0,0.2]) cylinder(r=3+2.4,h=oledbrk_hgt-2*0.2);
        }
    }
    
    translate([0,0,0.01]) oled_co();
    oled_screw_co();
}

