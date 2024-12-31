$fn = 72;

/*phone_wid = 163 + 3;
phone_hgt = 77.6 + 3.1;
phone_thk = 8.25 + 1.7;
phone_crn_r = 5;

!for(ix=[-1,1]*(phone_wid/2-phone_crn_r)) for(iy=[-1,1]*(phone_hgt/2-phone_crn_r)) translate([ix,iy,0]) cylinder(r=phone_crn_r,h=phone_thk);*/


dcu_wid = 190;
dcu_hgt = 120;
dcu_dep = 32;

dcu_lid_dep = 4;

crn_rad = 5;

switch_pkt_wid = 16;
switch_pkt_hgt = 20;
switch_pkt_dep = 2*6*2-4+2;

switch_pkt_wall_wid = 4;
switch_pkt_rad = 2;

side_switch_n = [2,3];
side_switch_sep = (switch_pkt_wid + 2.4)/2;
side_pkt_wid = [
    side_switch_n[0]*switch_pkt_wid+(side_switch_n[0]-1)*2.4,
    side_switch_n[1]*switch_pkt_wid+(side_switch_n[1]-1)*2.4,
];






difference() {
    union() {
        //switch pocket positives
        intersection() {
            for(ixm=[0,1]) mirror([ixm,0,0]) translate([(dcu_wid/2-crn_rad)-side_pkt_wid[ixm]/2*sin(30)+crn_rad*cos(30),(dcu_hgt/2-crn_rad)-side_pkt_wid[ixm]/2*cos(30)+crn_rad*sin(30),0]) rotate([0,0,90+30]) {
                //lip
                hull() for(ix=[-1,1]*(side_pkt_wid[ixm]/2-switch_pkt_rad)) for(iy=[-10,20-switch_pkt_rad])  translate([ix,iy,0]) cylinder(r=switch_pkt_rad+2.4,h=dcu_dep);
                
                //wall
                hull() for(ix=[-1,1]*(side_pkt_wid[ixm]/2-switch_pkt_rad)) for(iy=[-10,20-switch_pkt_rad])  translate([ix,iy,0]) cylinder(r=switch_pkt_wall_wid+switch_pkt_rad,h=dcu_dep-dcu_lid_dep);
            }
            //intersect with outer shape
            hull() for(ib=[0,2]) dcu_shape(dcu_dep-ib,-(2-ib));
        }
        
        //cable pocket positives
        intersection() {
            for(ixm=[0,1]) mirror([ixm,0,0]) translate([(dcu_wid/2-crn_rad)-30/2*sin(15)+crn_rad*cos(30),-(dcu_hgt/2-crn_rad)+30/2*cos(15)-crn_rad*sin(15),0]) rotate([0,0,90-15]) {
                //lip
                hull() for(ix=[-1,1]*(30/2-switch_pkt_rad)-[20,0]) for(iy=[-10,(ixm==0?30:40)-switch_pkt_rad]) translate([ix,iy,0]) cylinder(r=switch_pkt_rad+2.4,h=dcu_dep);
                
                //wall
                hull() for(ix=[-1,1]*(30/2-switch_pkt_rad)-[20,0]) for(iy=[-10,(ixm==0?30:40)-switch_pkt_rad]) translate([ix,iy,0]) cylinder(r=switch_pkt_wall_wid+switch_pkt_rad,h=dcu_dep-dcu_lid_dep);
            }
            //intersect with outer shape
            hull() for(ib=[0,2]) dcu_shape(dcu_dep-ib,-(2-ib));
        }
        
        //body wall
        difference() {
            dcu_shape(dcu_dep-dcu_lid_dep);
            translate([0,0,-0.01]) dcu_shape(50,-4);
        }
        
        //screw bosses
        for(ixm=[0,1]) mirror([ixm,0,0]) intersection() {
            union() {
                translate([(dcu_wid/2)-7.5,-7.5,0]) hull() for(i=[-1,0,1]) translate([(i==0?0:10),i*10]) cylinder(r=5,h=dcu_dep-dcu_lid_dep);
                
                translate([30,(dcu_hgt/2)-7.5,0]) rotate([0,0,90]) hull() for(i=[-1,0,1]) translate([(i==0?0:10),i*10]) cylinder(r=5,h=dcu_dep-dcu_lid_dep);
                
                mirror([0,1,0]) translate([30,(dcu_hgt/2)-7.5,0]) rotate([0,0,90]) hull() for(i=[-1,0,1]) translate([(i==0?0:10),i*10]) cylinder(r=5,h=dcu_dep-dcu_lid_dep);
            }
            dcu_shape(dcu_dep-dcu_lid_dep);
        }
    }
    
    for(ixm=[0,1]) mirror([ixm,0,0]) translate([(dcu_wid/2-crn_rad)-side_pkt_wid[ixm]/2*sin(30)+crn_rad*cos(30),(dcu_hgt/2-crn_rad)-side_pkt_wid[ixm]/2*cos(30)+crn_rad*sin(30),0]) rotate([0,0,90+30]) {
        for(ix2=[-(side_switch_n[ixm]-1)/2:1:(side_switch_n[ixm]-1)/2]) translate([ix2*2*side_switch_sep,0,0]) {
            //switch pocket cutouts
            hull() for(ix=[-1,1]*(switch_pkt_wid/2-switch_pkt_rad)) for(iy=[0,20-switch_pkt_rad]) translate([ix,iy,dcu_dep-switch_pkt_dep+switch_pkt_rad]) {
                sphere(r=switch_pkt_rad);
                cylinder(r=switch_pkt_rad,h=50);
                translate([0,-90,0]) cylinder(r=switch_pkt_rad,h=50);
            }
            //switch holes
            translate([0,20,dcu_dep-switch_pkt_dep/2]) {
                rotate([-90,0,0]) hull() cylinder_oh(6.2/2+0.2,4);
                translate([0,-0.01,0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(6.2/2+0.2+0.2,0.01);
                    cylinder_oh(6.2/2+0.2,0.2);
                }
                translate([0,2.4,0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(6.2/2+0.2+0.2,10);
                    translate([0,0,-0.2]) cylinder_oh(6.2/2+0.2,10);
                }
                
                translate([0,2.4,0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(6-0.2,10);
                    translate([0,0,0.2]) cylinder_oh(6,10);
                }
                translate([0,4,0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(6+0.2,10);
                    translate([0,0,-0.2]) cylinder_oh(6,10);
                }
                
                //divot for keyed washer
                for(iz=[-1]) translate([0,0,6*iz]) {
                    rotate([-90,0,0]) hull() {
                        cylinder_oh(1.4+0.2,0.01);
                        cylinder_oh(1.4,0.2);
                    }
                    rotate([-90,0,0]) hull() {
                        cylinder_oh(1.4-0.2,1.6);
                        cylinder_oh(1.4,1.6-0.2);
                    }
                }
            }
        }
    }
    
    
    for(ixm=[0,1]) mirror([ixm,0,0]) translate([(dcu_wid/2-crn_rad)-30/2*sin(15)+crn_rad*cos(30),-(dcu_hgt/2-crn_rad)+30/2*cos(15)-crn_rad*sin(15),0]) rotate([0,0,90-15]) {
        //cable pocket cutouts
        hull() for(ix=[-1,1]*(30/2-switch_pkt_rad)-[20,0]) for(iy=[-10,(ixm==0?30:40)-switch_pkt_rad]) translate([ix,iy,4+switch_pkt_rad]) {
            sphere(r=switch_pkt_rad);
            cylinder(r=switch_pkt_rad,h=50);
            translate([0,-90,0]) cylinder(r=switch_pkt_rad,h=50);
        }
        //cable holes
        translate([0,(ixm==0?30:40),dcu_dep/2]) {
            rotate([-90,0,0]) hull() cylinder_oh(16/2+0.2,4);
            translate([0,-0.01,0]) rotate([-90,0,0]) hull() {
                cylinder_oh(16/2+0.2+0.2,0.01);
                cylinder_oh(16/2+0.2,0.2);
            }
            translate([0,4,0]) rotate([-90,0,0]) hull() {
                cylinder_oh(16/2+0.2+0.2,10);
                translate([0,0,-0.2]) cylinder_oh(16/2+0.2,10);
            }
        }
    }
    
    //screw cutouts
    for(ixm=[0,1]) mirror([ixm,0,0]) for(iz=[0,1]) mirror([0,0,iz]) {
        translate([(dcu_wid/2)-7.5,-7.5,0]) translate([0,0,(iz==0?dcu_dep:4)]) {
            translate([0,0,-8]) hull() {
                cylinder(r=1.25-0.5,h=50);
                translate([0,0,0.5]) cylinder(r=1.25,h=50);
            }
            translate([0,0,-4]) hull() {
                cylinder(r=1.5+0.15,h=50);
                translate([0,0,-(1.5+0.15)]) cylinder(r=0.01,h=50);
            }
            hull() {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
        
        translate([30,(dcu_hgt/2)-7.5,0]) translate([0,0,(iz==0?dcu_dep:4)]) {
            translate([0,0,-8]) hull() {
                cylinder(r=1.25-0.5,h=50);
                translate([0,0,0.5]) cylinder(r=1.25,h=50);
            }
            translate([0,0,-4]) hull() {
                cylinder(r=1.5+0.15,h=50);
                translate([0,0,-(1.5+0.15)]) cylinder(r=0.01,h=50);
            }
            hull() {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
        
        mirror([0,1,0]) translate([30,(dcu_hgt/2)-7.5,0]) translate([0,0,(iz==0?dcu_dep:4)]) {
            translate([0,0,-8]) hull() {
                cylinder(r=1.25-0.5,h=50);
                translate([0,0,0.5]) cylinder(r=1.25,h=50);
            }
            translate([0,0,-4]) hull() {
                cylinder(r=1.5+0.15,h=50);
                translate([0,0,-(1.5+0.15)]) cylinder(r=0.01,h=50);
            }
            hull() {
                cylinder(r=3,h=50);
                translate([0,0,-3]) cylinder(r=0.01,h=50);
            }
        }
    }
}

module dcu_shape(hgt=dcu_dep,outset=0) {
    hull() for(ixm=[0,1]) mirror([ixm,0,0]) {
        translate([(dcu_wid/2-crn_rad)-side_pkt_wid[ixm]*sin(30),(dcu_hgt/2-crn_rad)-0*cos(30),0]) cylinder(r=crn_rad+outset,h=hgt);
        translate([(dcu_wid/2-crn_rad)-0*sin(30),(dcu_hgt/2-crn_rad)-side_pkt_wid[ixm]*cos(30),0]) cylinder(r=crn_rad+outset,h=hgt);
        
        
        translate([(dcu_wid/2-crn_rad)-30*sin(15),-(dcu_hgt/2-crn_rad)+0*cos(15),0]) cylinder(r=crn_rad+outset,h=hgt);
        translate([(dcu_wid/2-crn_rad)-0*sin(15),-(dcu_hgt/2-crn_rad)+30*cos(15),0]) cylinder(r=crn_rad+outset,h=hgt);
    }
}

/*crn_rad_s = 5;

switch_crn_a = 30;
umb_crn_a = 27.5;

umb_ins_x = 25;
umb_ins_y = 50;

t_rhs_b = [(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)];

t_rhs_t = [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)];
t_rhs_tc = [cos(switch_crn_a),sin(switch_crn_a)];

t_lhs_t = [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)];
t_lhs_tc = [-cos(switch_crn_a),sin(switch_crn_a)];

t_lhs_b = [-(dcu_wid/2-crn_rad_s),-(dcu_hgt/2-crn_rad_s)];
t_lhs_bc = [cos(umb_crn_a),sin(umb_crn_a)];

t_umb_b_a = [((40-2*crn_rad_s)*tan(umb_crn_a)+2*crn_rad_s*cos(umb_crn_a)),0];

wall_thk = 4;

bev_s = 0.4;

difference() {
    !union() {
        difference() {
            hull() {
                dcu_shape(-bev_s,dcu_dep);
                translate([0,0,bev_s]) dcu_shape(0,dcu_dep-2*bev_s);
            }
            translate([0,0,-0.01]) dcu_shape(-wall_thk,100);
            //dcu_neg();
        }
        intersection() {
            dcu_shape(0,dcu_dep);
            union() {
                translate(t_rhs_t+[0,-60*cos(switch_crn_a)]) rotate([0,0,switch_crn_a]){
                    hull() for(iy=[2,60-2]) {
                        translate([10-20,iy,0]) cylinder(r=4,h=100);
                        translate([10-20,iy,0]) rotate([0,0,(iy-2==0?-switch_crn_a:90-switch_crn_a)]) translate([50,0,0]) cylinder(r=4,h=100);
                    }
                }
                
                translate(t_lhs_t+[0,-40*cos(switch_crn_a)]) mirror([1,0,0]) rotate([0,0,switch_crn_a]){
                    hull() for(iy=[2,40-2]) {
                        translate([10-20,iy,0]) cylinder(r=4,h=100);
                        translate([10-20,iy,0]) rotate([0,0,(iy-2==0?-switch_crn_a:90-switch_crn_a)]) translate([50,0,0]) cylinder(r=4,h=100);
                    }
                }
                
                *#translate(t_lhs_b+[-crn_rad_s,-2*crn_rad_s]+[umb_ins_x,umb_ins_y]) mirror([1,0,0]) rotate([0,0,-umb_crn_a]) {
                    translate([-10,-10,4+(dcu_dep-4)/2]) rotate([0,90,0]) cylinder(r=8,h=100);
                    translate([-10,-30,4+(dcu_dep-4)/2]) rotate([0,90,0]) cylinder(r=8,h=100);
                }
            }
        }
    }
    union() {
        translate(t_rhs_t+[0,-60*cos(switch_crn_a)]) rotate([0,0,switch_crn_a]) for(is=[0,1,2]) {
            translate([10-20,is*20+2,4]) {
                cube([100,20-2*2,50]);
                translate([-10,20/2-2,(dcu_dep-4)/2]) rotate([0,90,0]) cylinder(r=2.5,h=100);
            }
        }
        
        translate(t_lhs_t+[0,-40*cos(switch_crn_a)]) mirror([1,0,0]) rotate([0,0,switch_crn_a]) for(is=[0,1]) {
            translate([10-20,is*20+2,4]) {
                cube([100,20-2*2,50]);
                translate([-10,20/2-2,(dcu_dep-4)/2]) rotate([0,90,0]) cylinder(r=2.5,h=100);
            }
        }
    }
}

module dcu_shape(outset=0,hgt=10) {
    difference() {
        crn_rad_ins = crn_rad + outset;
        crn_rad_s_ins = crn_rad_s + outset;
        
        union() {
            linear_extrude(height=hgt,convexity=10) polygon([
                t_rhs_b+[0,-crn_rad_ins],
                t_rhs_b,
                t_rhs_b+[crn_rad_ins,0],
                
                //RHS sitches
                t_rhs_t+[crn_rad_ins,0]+[0,-60*cos(switch_crn_a)],
                t_rhs_t+[0,-60*cos(switch_crn_a)],
                t_rhs_t+[0,-60*cos(switch_crn_a)]+crn_rad_ins*t_rhs_tc,
                
                t_rhs_t+[-60*sin(switch_crn_a),0]+crn_rad_ins*t_rhs_tc,
                t_rhs_t+[-60*sin(switch_crn_a),0],
                t_rhs_t+[0,crn_rad_ins]+[-60*sin(switch_crn_a),0],
                
                //LHS switches
                t_lhs_t+[0,crn_rad_ins]+[40*sin(switch_crn_a),0],
                t_lhs_t+[40*sin(switch_crn_a),0],
                t_lhs_t+[40*sin(switch_crn_a),0]+crn_rad_ins*t_lhs_tc,
                
                t_lhs_t+[0,-40*cos(switch_crn_a)]+crn_rad_ins*t_lhs_tc,
                t_lhs_t+[0,-40*cos(switch_crn_a)],
                t_lhs_t+[-crn_rad_ins,0]+[0,-40*cos(switch_crn_a)],
                
                //umbilical notch
                t_lhs_b+[-crn_rad_s_ins,0]+[0,umb_ins_y],
                t_lhs_b+[0,umb_ins_y],
                t_lhs_b+[0,-crn_rad_s_ins]+[0,umb_ins_y],
                
                t_lhs_b+[0,-crn_rad_s_ins]+[umb_ins_x,umb_ins_y],
                t_lhs_b+[0,-2*crn_rad_s]+[umb_ins_x,umb_ins_y],
                t_lhs_b+[0,-2*crn_rad_s]+[umb_ins_x,umb_ins_y]+(crn_rad_s-outset)*t_lhs_bc,
                
                t_lhs_b+[0,0]+[umb_ins_x,0]+t_umb_b_a-(crn_rad_s+outset)*t_lhs_bc,
                t_lhs_b+[0,0]+[umb_ins_x,0]+t_umb_b_a,
                t_lhs_b+[0,-crn_rad_s_ins]+[umb_ins_x,0]+t_umb_b_a,
            ]);
        
            for(it=[
                t_rhs_b,
                //RHS sitches
                t_rhs_t+[0,-60*cos(switch_crn_a)],
                t_rhs_t+[-60*sin(switch_crn_a),0],
                //LHS switches
                t_lhs_t+[40*sin(switch_crn_a),0],
                t_lhs_t+[0,-40*cos(switch_crn_a)],
            ]) translate(it) cylinder(r=crn_rad+outset,h=hgt);
        
            for(it=[
                //umbilical notch
                t_lhs_b+[0,umb_ins_y],
                t_lhs_b+[0,0]+[umb_ins_x,0]+t_umb_b_a,
            ]) translate(it) cylinder(r=crn_rad_s+outset,h=hgt);
        }
        for(it=[
            //umbilical notch
            t_lhs_b+[0,-2*crn_rad_s]+[umb_ins_x,umb_ins_y],
        ]) translate(it) translate([0,0,-0.01]) cylinder(r=crn_rad_s-outset,h=100);
    }
}

module dcu_neg() {
    difference() {
        union() {
            translate([0,0,-0.01]) linear_extrude(height=100,convexity=10) polygon([
                t_rhs_b+(crn_rad-4)*[0,-1],
                t_rhs_b,
                t_rhs_b+(crn_rad-4)*[1,0],
                
                //RHS sitches
                t_rhs_t+(crn_rad-4)*[1,0]+[0,-60*cos(switch_crn_a)],
                t_rhs_t+[0,-60*cos(switch_crn_a)],
                t_rhs_t+[0,-60*cos(switch_crn_a)]+(crn_rad-4)*t_rhs_tc,
                
                t_rhs_t+[-60*sin(switch_crn_a),0]+(crn_rad-4)*t_rhs_tc,
                t_rhs_t+[-60*sin(switch_crn_a),0],
                t_rhs_t+(crn_rad-4)*[0,1]+[-60*sin(switch_crn_a),0],
                
                //LHS switches
                t_lhs_t+(crn_rad-4)*[0,1]+[40*sin(switch_crn_a),0],
                t_lhs_t+[40*sin(switch_crn_a),0],
                t_lhs_t+[40*sin(switch_crn_a),0]+(crn_rad-4)*t_lhs_tc,
                
                t_lhs_t+[0,-40*cos(switch_crn_a)]+(crn_rad-4)*t_lhs_tc,
                t_lhs_t+[0,-40*cos(switch_crn_a)],
                t_lhs_t+(crn_rad-4)*[-1,0]+[0,-40*cos(switch_crn_a)],
                
                //umbilical notch
                t_lhs_b+[0,umb_ins_y],
                
                t_lhs_b+[-crn_rad_s,-crn_rad_s+4]+[umb_ins_x,umb_ins_y],
                t_lhs_b+[-crn_rad_s,-2*crn_rad_s]+[umb_ins_x,umb_ins_y],
                t_lhs_b+[-crn_rad_s,-2*crn_rad_s]+[umb_ins_x,umb_ins_y]+(crn_rad_s+4)*t_lhs_bc,
                
                t_lhs_b+[-crn_rad_s,0]+[umb_ins_x,0]+t_umb_b_a,
            ]);
        
            for(it=[
                t_rhs_b,
                //RHS sitches
                t_rhs_t+[0,-60*cos(switch_crn_a)],
                t_rhs_t+[-60*sin(switch_crn_a),0],
                //LHS switches
                t_lhs_t+[40*sin(switch_crn_a),0],
                t_lhs_t+[0,-40*cos(switch_crn_a)],
            ]) translate(it) translate([0,0,-0.01]) cylinder(r=crn_rad-4,h=100);
        }
        for(it=[
            //umbilical notch
            t_lhs_b+[-crn_rad_s,-2*crn_rad_s]+[umb_ins_x,umb_ins_y],
        ]) translate(it) translate([0,0,-2*0.01]) cylinder(r=crn_rad_s+4,h=200);
    }
}
*/
/*
difference() {
    union() {
        linear_extrude(height=dcu_dep,convexity=10) polygon([
            [(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)-crn_rad],
            [(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)],
            [(dcu_wid/2-crn_rad)+crn_rad,-(dcu_hgt/2-crn_rad)],
            
            //RHS sitches
            [(dcu_wid/2-crn_rad)+crn_rad,(dcu_hgt/2-crn_rad)]+[0,-60*cos(switch_crn_a)],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-60*cos(switch_crn_a)],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-60*cos(switch_crn_a)]+[crn_rad*cos(switch_crn_a),crn_rad*sin(switch_crn_a)],
            
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[-60*sin(switch_crn_a),0]+[crn_rad*cos(switch_crn_a),crn_rad*sin(switch_crn_a)],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[-60*sin(switch_crn_a),0],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)+crn_rad]+[-60*sin(switch_crn_a),0],
            
            //LHS switches
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)+crn_rad]+[40*sin(switch_crn_a),0],
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[40*sin(switch_crn_a),0],
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[40*sin(switch_crn_a),0]+[-crn_rad*cos(switch_crn_a),crn_rad*sin(switch_crn_a)],
            
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-40*cos(switch_crn_a)]+[-crn_rad*cos(switch_crn_a),crn_rad*sin(switch_crn_a)],
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-40*cos(switch_crn_a)],
            [-(dcu_wid/2-crn_rad)-crn_rad,(dcu_hgt/2-crn_rad)]+[0,-40*cos(switch_crn_a)],
            
            //umbilical notch
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)]+[0,40],
            [-(dcu_wid/2-crn_rad_s),-(dcu_hgt/2-crn_rad_s)]+[0,40],
            [-(dcu_wid/2-crn_rad_s),-(dcu_hgt/2-crn_rad_s)-crn_rad_s]+[0,40],
            
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-crn_rad_s]+[50,40],
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-2*crn_rad_s]+[50,40],
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-2*crn_rad_s]+[50,40]+[crn_rad_s*cos(umb_crn_a),crn_rad_s*sin(umb_crn_a)],
            
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)]+[50,0]+[((40-2*crn_rad_s)*tan(umb_crn_a)+2*crn_rad_s*cos(umb_crn_a)),0]+[-crn_rad_s*cos(umb_crn_a),-crn_rad_s*sin(umb_crn_a)],
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)]+[50,0]+[((40-2*crn_rad_s)*tan(umb_crn_a)+2*crn_rad_s*cos(umb_crn_a)),0],
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-crn_rad_s]+[50,0]+[((40-2*crn_rad_s)*tan(umb_crn_a)+2*crn_rad_s*cos(umb_crn_a)),0],
        ]);
        
        
        linear_extrude(height=dcu_dep,convexity=10) polygon([
            [(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)-(crn_rad-4)],
            [(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)],
            [(dcu_wid/2-crn_rad)+(crn_rad-4),-(dcu_hgt/2-crn_rad)],
            
            //RHS sitches
            [(dcu_wid/2-crn_rad)+(crn_rad-4),(dcu_hgt/2-crn_rad)]+[0,-60*cos(switch_crn_a)],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-60*cos(switch_crn_a)],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-60*cos(switch_crn_a)]+(crn_rad-4)*[cos(switch_crn_a),sin(switch_crn_a)],
            
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[-60*sin(switch_crn_a),0]+(crn_rad-4)*[cos(switch_crn_a),sin(switch_crn_a)],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[-60*sin(switch_crn_a),0],
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)+(crn_rad-4)]+[-60*sin(switch_crn_a),0],
            
            //LHS switches
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)+(crn_rad-4)]+[40*sin(switch_crn_a),0],
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[40*sin(switch_crn_a),0],
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[40*sin(switch_crn_a),0]+(crn_rad-4)*[-cos(switch_crn_a),sin(switch_crn_a)],
            
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-40*cos(switch_crn_a)]+(crn_rad-4)*[-cos(switch_crn_a),sin(switch_crn_a)],
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)]+[0,-40*cos(switch_crn_a)],
            [-(dcu_wid/2-crn_rad)-(crn_rad-4),(dcu_hgt/2-crn_rad)]+[0,-40*cos(switch_crn_a)],
            
            //umbilical notch
            [-(dcu_wid/2-crn_rad_s),-(dcu_hgt/2-crn_rad_s)]+[0,40],
            
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-crn_rad_s+4]+[50,40],
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-2*crn_rad_s]+[50,40],
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-2*crn_rad_s]+[50,40]+(crn_rad_s+4)*[cos(umb_crn_a),sin(umb_crn_a)],
            
            [-(dcu_wid/2-crn_rad_s)-crn_rad_s,-(dcu_hgt/2-crn_rad_s)]+[50,0]+[((40-2*crn_rad_s)*tan(umb_crn_a)+2*crn_rad_s*cos(umb_crn_a)),0],
        ]);
        
        for(it=[
            [(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)],
            
            [(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)-60*cos(switch_crn_a)],
            
            [(dcu_wid/2-crn_rad)-60*sin(switch_crn_a),(dcu_hgt/2-crn_rad)],
            
            [-(dcu_wid/2-crn_rad)+40*sin(switch_crn_a),(dcu_hgt/2-crn_rad)],
            
            [-(dcu_wid/2-crn_rad),(dcu_hgt/2-crn_rad)-40*cos(switch_crn_a)],
            
            //[-(dcu_wid/2-crn_rad),-(dcu_hgt/2-crn_rad)],
        ]) translate(it) cylinder(r=crn_rad,h=dcu_dep);
        
        for(it=[
            [-(dcu_wid/2-crn_rad_s),-(dcu_hgt/2-crn_rad_s)+40],
            [-(dcu_wid/2-crn_rad_s)+50+((40-2*crn_rad_s)*tan(umb_crn_a)+2*crn_rad_s*cos(umb_crn_a))-crn_rad_s,-(dcu_hgt/2-crn_rad_s)],
        ]) translate(it) cylinder(r=crn_rad_s,h=dcu_dep);
    }
    
    for(it=[
        [-(dcu_wid/2-crn_rad_s)+50-crn_rad_s,-(dcu_hgt/2-crn_rad_s)-2*crn_rad_s+40],
    ]) translate(it) translate([0,0,-0.01]) cylinder(r=crn_rad_s,h=100);
    
    for(ix=[-1]*(dcu_wid/2-crn_rad)) for(iy=[1]*(dcu_hgt/2-crn_rad)) translate([ix,iy,0]) {
        translate([40*sin(30),0,0]) rotate([0,0,90-30]) for(ix=[0,1]) {
            translate([-40+ix*20+2,10-20,4]) cube([20-2*2,100,50]);
        }
    }
    
    mirror([1,0,0]) for(ix=[-1]*(dcu_wid/2-crn_rad)) for(iy=[1]*(dcu_hgt/2-crn_rad)) translate([ix,iy,0]) {
        translate([60*sin(30),0,0]) rotate([0,0,90-30]) for(ix=[0,1,2]) {
            translate([-60+ix*20+2,10-20,4]) cube([20-2*2,100,50]);
        }
    }
}*/



module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}