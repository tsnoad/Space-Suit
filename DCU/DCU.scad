$fn = 72;

function list_sum(v, i = 0, r = 0) = i < len(v) ? list_sum(v, i + 1, r + v[i]) : r;
function list_partial(list,start,end) = [for (i = [start:end]) list[i]];

dcu_wid = 200;
dcu_hgt = 120;
dcu_dep = 32;

dcu_lid_dep = 4;

crn_rad = 5;

switch_pkt_wid = 18;
switch_pkt_hgt = 18; //depth of pocket in X axis
switch_pkt_dep = dcu_lid_dep+2+2*6+4; //depth of pocket in Z axis
switch_pkt_sw_dep = dcu_lid_dep+2+6; //location of switch in z axis (subtracted from dcu_dep)

switch_pkt_wall_wid = 4; //width of wall
switch_pkt_sep_wid = 2.4; //width of sperators between switches
switch_pkt_rad = 2; //radius of pocket fillets

side_switch_pkt_wid = [
    [switch_pkt_wid,switch_pkt_wid,switch_pkt_wid],
    [switch_pkt_wid+4,switch_pkt_wid],
];

side_switch_pkt_hgt = [
    [switch_pkt_hgt,switch_pkt_hgt,switch_pkt_hgt],
    [switch_pkt_hgt-2,switch_pkt_hgt],
];

/*echo(max(side_switch_pkt_wid[0]));
echo(max(side_switch_pkt_wid[1]));
echo(len(side_switch_pkt_wid[0]));
echo(len(side_switch_pkt_wid[1]));
echo(list_sum(side_switch_pkt_wid[0]));
echo(list_sum(side_switch_pkt_wid[1]));*/


cable_pkt_wid = 30;
//cable_pkt_hgt = 30; //depth of pocket in X axis
cable_pkt_dep = dcu_dep-2; //depth of pocket in Z axis
cable_pkt_cab_dep = dcu_lid_dep+(cable_pkt_dep-dcu_lid_dep-switch_pkt_rad)/2; //location of switch in z axis (subtracted from dcu_dep)
//echo(dcu_lid_dep);

side_cable_pkt_wid = [cable_pkt_wid,cable_pkt_wid];
side_cable_pkt_hgt = [20,30];

phone_wid = 160.5;
phone_hgt = 82.5;
phone_thk = 9.6;
phone_thk_cam = 11.2;
phone_wid_cam = 35;
phone_crn_r = 10;
phone_bev_r = 2;
phone_clr = 1;
dcu_phone_holder_hgt = phone_thk_cam+2*phone_clr+1.6;

*dcu_base();
*dcu_phone_holder();
!dcu_body();
*dcu_face();

translate([0,0,dcu_phone_holder_hgt]) for(ixm=[1]) cable_pocket_cent_loc(ixm) {
    translate([0,side_cable_pkt_hgt[ixm],dcu_dep-cable_pkt_cab_dep]) {
        translate([0,4,0]) rotate([-90,0,0]) u174_bracket();
    }
}

*mirror([0,0,1]) union() {
    dcu_base();
    dcu_phone_holder();
}

module dcu_base() mirror([0,0,1]) difference() {
    mag_rad = 8/2+0.2;
    mag_hgt = 2;
    
    base_dep = 4;
    mag_boss_dep = base_dep+5;
    
    union() {
        dcu_shape(base_dep,0,0.2,2);
        
        //magnet bosses
        for(ix=[-1.5:1:1.5]) for(iy=[-0.5:1:0.5]) translate([ix*45,iy*60,0]) {
            hull() rotate_extrude() {
                translate([5,mag_boss_dep-2]) circle(r=2);
                translate([5+(mag_boss_dep-2*2),2]) circle(r=2);
            }
        }
    }
    
    //magnet cutouts
    for(ix=[-1.5:1:1.5]) for(iy=[-0.5:1:0.5]) translate([ix*45,iy*60,-0.01]) {
        hull() {
            cylinder(r=mag_rad-0.2,h=mag_boss_dep-0.4);
            cylinder(r=mag_rad,h=mag_boss_dep-0.4-0.2);
        }
        hull() {
            cylinder(r=mag_rad+0.8,h=mag_boss_dep-0.4-mag_hgt-0.8);
            cylinder(r=mag_rad,h=mag_boss_dep-0.4-mag_hgt);
        }
        translate([0,0,-0.01]) hull() {
            cylinder(r1=mag_rad+0.8+0.4,r2=mag_rad+0.8,h=0.4);
        }
    }
    
    //recess to make phone easier to access
    hull() for(iy=[0,-40]) translate([0,(dcu_hgt/2)+iy,0]) cylinder(r=25/2+0.5,h=10);
    hull() for(iy=[0,-40]) translate([0,(dcu_hgt/2)+iy,-0.01]) cylinder(r1=25/2+0.5+0.2,r2=25/2+0.5,h=0.2);
    hull() for(iy=[0,-40]) translate([0,(dcu_hgt/2)+iy,base_dep]) {
        cylinder(r=25/2+0.5+2,h=10);
        translate([0,0,-2]) cylinder(r=25/2+0.5,h=10);
    }
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        bev_r = 10;
        translate([25/2+0.5+bev_r,(dcu_hgt/2)-bev_r,0]) rotate([0,0,90]) rotate_extrude(angle=90) polygon([
            [bev_r*sqrt(2)+1,-0.01],
            [bev_r*sqrt(2)+1,base_dep+0.01],
            [bev_r-2,base_dep+0.01],
            [bev_r,base_dep-2],
            [bev_r,0.2],
            [bev_r-0.2,0],
        ]);
    }
    
    screw_loc_base_holder() translate([0,0,0]) screw_co(8,4);
    
    
    //cut down printing time
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        hull() for(ix=[25,75]) for(iy=[-1,1]*10) translate([ix,iy,-0.01]) cylinder(r=5,h=50);
    }
}


module screw_loc_base_holder() for(ixm=[0,1]) mirror([ixm,0,0]) {
    for(iy=[-20,5]) translate([(dcu_wid/2)-10+(1.5+0.15)+2.4,iy,0]) children();
    translate([40,-((dcu_hgt/2)-10+(1.5+0.15)+2.4),0]) children();
}

//phone holder
module dcu_phone_holder() difference() {
    holder_hgt = dcu_phone_holder_hgt;
    
    union() {
        difference() {
            dcu_shape(holder_hgt,0,0.2,0.2);
        
            translate([(dcu_wid-phone_wid)/2-10,-(dcu_hgt-phone_hgt)/2+5+10,0]) {
                hull() for(ix=[-1,1]*200) {
                    for(iy=[1,0]*(phone_hgt/2)+[1,0]*5+[-10,200]) {
                        translate([ix,iy,-0.01]) {
                            cylinder(r=5-0.4-1,h=phone_thk_cam+2*phone_clr+1);
                            cylinder(r=5,h=phone_thk_cam+2*phone_clr-0.4);
                        }
                    }
                }
            }
        }
        translate([0,0,phone_thk_cam+2*phone_clr]) dcu_shape((dcu_phone_holder_hgt-(phone_thk_cam+2*phone_clr)),0,0.4,0.2);
    }
    
    translate([-(dcu_wid-phone_wid)/2+12.5+10,-(dcu_hgt-phone_hgt)/2+5+10,0]) {
        //phone body
        hull() for(ix=[-1,1]*(phone_wid/2)-[-1,1]*(phone_crn_r)) {
            for(iy=[-1,1]*(phone_hgt/2)-[-1,1]*(phone_crn_r)+[0,50]) {
                for(iz=[0,phone_thk+phone_clr]-[0,1]*phone_bev_r) translate([ix,iy,iz]) {
                    rotate_extrude() translate([phone_crn_r-phone_bev_r,0]) circle(r=phone_bev_r+phone_clr);
                }
            }
        }
        //top bevel
        hull() for(ix=[-1,1]*(phone_wid/2)-[-1,1]*(phone_bev_r)) {
            for(iz=[0,phone_thk+phone_clr]-[0,1]*phone_bev_r) {
                translate([ix,(phone_hgt/2)-0.4+0.01-10,iz]) {
                    rotate([-90,0,0]) cylinder(r1=phone_bev_r+phone_clr,r2=phone_bev_r+phone_clr+0.4,h=0.4);
                }
            }
        }
        
        //camera protrusion
        hull() for(ix=[1,1]*(phone_wid/2)+[-1,0]*phone_wid_cam-[-1,1]*(phone_crn_r)) {
            for(iy=[-1,1]*(phone_hgt/2)-[-1,1]*(phone_crn_r)+[0,50]) {
                for(iz=[0,phone_thk_cam+phone_clr]-[0,1]*phone_bev_r) translate([ix,iy,iz]) {
                    rotate_extrude() translate([phone_crn_r-phone_bev_r,0]) circle(r=phone_bev_r+phone_clr);
                }
            }
        }
        //top bevel
        intersection() {
            hull() for(ix=[1,1]*(phone_wid/2)+[-1,0]*phone_wid_cam-[-1,1]*(phone_bev_r)) {
                for(iz=[0,phone_thk_cam+phone_clr]-[0,1]*phone_bev_r) {
                    translate([ix,(phone_hgt/2)-0.4+0.01-10,iz]) {
                        rotate([-90,0,0]) cylinder(r1=phone_bev_r+phone_clr,r2=phone_bev_r+phone_clr+0.4+1,h=0.4+1);
                    }
                }
            }
            translate([-200,-200,0]) cube([400,400,phone_thk_cam+2*phone_clr]); 
        }
        
        //cutout for plug
        hull() for(ix=[-1,0]*(phone_wid/2+12.5)-[-1,0]*5) {
            for(iy=[-1,1]*(phone_hgt/2)-[-1,1]*10-[-1,1]*5+[0,50]) {
                translate([ix,iy,-0.01]) {
                    cylinder(r=5-0.4,h=phone_thk+2*phone_clr-1);
                    cylinder(r=5,h=phone_thk+2*phone_clr-1-0.4);
                }
            }
        }
        //bevel
        hull() for(ix=[-1,0]*(phone_wid/2+12.5)) {
            for(iz=[0,phone_thk+2*phone_clr-1]) {
                translate([ix,(phone_hgt/2)-10-0.4+0.01,iz]) {
                    if(ix!=0 && iz!=0) {
                        translate([0,0,-0.4]) rotate([-90,0,0]) cylinder(r1=0,r2=0.4,h=0.4);
                        translate([0.4,0,0]) rotate([-90,0,0]) cylinder(r1=0,r2=0.4,h=0.4);
                    } else {
                        rotate([-90,0,0]) cylinder(r1=0,r2=0.4,h=0.4);
                    }
                }
            }
        }
        
        //cutout for cable
        hull() for(ix=[-1,1]*(phone_wid/2)-[-1,1]*5+[-1,-1]*10) {
            for(iy=[-1,1]*(phone_hgt/2)-[-1,1]*5+[-5,0]+[0,50]) {
                translate([ix,iy,-0.01]) {
                    cylinder(r=5-0.4,h=5);
                    cylinder(r=5,h=5-0.4);
                }
            }
        }
        //bevel
        intersection() {
            hull() for(ix=[-1,1]*(phone_wid/2)-[-1,1]*5+[-1,-1]*10) {
                for(iy=[-1,1]*(phone_hgt/2)-[-1,1]*5+[-5,0]+[0,50]) {
                    translate([ix,iy,-0.01]) {
                        cylinder(r=5,h=50);
                    }
                }
            }
            hull() for(ix=[-1,1]*(phone_wid/2)-[-1,1]*(phone_crn_r)) {
                for(iy=[-1,1]*(phone_hgt/2)-[-1,1]*(phone_crn_r)+[0,50]) {
                    translate([ix,iy,0]) {
                        cylinder(r=phone_crn_r+phone_clr+0.8,h=5);
                        cylinder(r=phone_crn_r+phone_clr,h=5+0.8);
                    }
                }
            }
        }
        
        //cutout to route cable
        hull() for(ix=[1,1]*(phone_wid/2)-[1,1]*5+[-1,-1]*10+[0,-25]) {
            for(iy=[-1]*(phone_hgt/2)-[-1]*5+[-5]) {
                translate([ix,iy,-0.01]) {
                    cylinder(r=5,h=50);
                }
            }
        }
        //bevel
        hull() for(ix=[1,1]*(phone_wid/2)-[1,1]*5+[-1,-1]*10+[0,-25]) {
            for(iy=[-1]*(phone_hgt/2)-[-1]*5+[-5]) {
                translate([ix,iy,holder_hgt-0.4+0.01]) {
                    cylinder(r1=5,r2=5+0.4,h=0.4);
                }
            }
        }
    }
    
    //screw cutouts
    screw_loc_base_holder() translate([0,0,0]) mirror([0,0,1]) screw_co(8,4);
    screw_loc_holder_body() translate([0,0,holder_hgt]) mirror([0,0,1]) screw_co(8,4);
    
    //cut down printing time
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        hull() for(ix=[15,60]) for(iy=[-1,1]*20) translate([ix,iy,-0.01]) cylinder(r=5,h=50);
    }
}

module screw_loc_holder_body() for(ixm=[0,1]) mirror([ixm,0,0]) {
    translate([(dcu_wid/2)-10/2,-7.5,0]) children();
    
    translate([50,(dcu_hgt/2)-10/2,4-(dcu_phone_holder_hgt-(phone_thk_cam+2*phone_clr))]) children();
    
    translate([50,-((dcu_hgt/2)-10/2),0]) children();
}

module dcu_body() translate([0,0,dcu_phone_holder_hgt]) difference() {
    union() {
        //body wall
        difference() {
            dcu_shape(dcu_dep-dcu_lid_dep,0,0.2,0.2);
            //cutout
            translate([0,0,-0.01]) dcu_shape(50,-4);
            //bevels
            translate([0,0,-50+0.2]) dcu_shape(50,-4+0.2,0,0.2);
            translate([0,0,dcu_dep-dcu_lid_dep-0.2]) dcu_shape(50,-4+0.2,0.2,0);
        }
        
        switch_pocket_pos();
        cable_pocket_pos();
        
        //screw bosses
        intersection() {
            screw_loc_body_face() {
                hull() for(i=[-1,0,1]) translate([(i==0?0:10),i*10]) {
                    cylinder(r=(1.5+0.15+2.4)-0.2,h=dcu_dep-dcu_lid_dep);
                    translate([0,0,0.2]) cylinder(r=(1.5+0.15+2.4),h=dcu_dep-dcu_lid_dep-2*0.2);
                }
            }
            dcu_shape(dcu_dep-dcu_lid_dep,0,0.2,0.2);
        }
        intersection() {
            for(ixm=[0,1]) mirror([ixm,0,0]) {
                hull() for(ix=[0,50]) for(iy=[-20,20]) translate([(dcu_wid/2)-10/2+ix,-7.5+iy,0]) {
                    cylinder(r=5-0.2,h=10);
                    translate([0,0,0.2]) cylinder(r=5,h=10-2*0.2);
                }
                hull() for(ix=[0,50]) for(iy=[0,10]) translate([50+ix,(dcu_hgt/2)-10/2+iy,0]) {
                    cylinder(r=5-0.2,h=10);
                    translate([0,0,0.2]) cylinder(r=5,h=10-2*0.2);
                }
                hull() for(ix=[0,50]) for(iy=[0,10]) translate([50+ix,-((dcu_hgt/2)-10/2+iy),0]) {
                    cylinder(r=5-0.2,h=10);
                    translate([0,0,0.2]) cylinder(r=5,h=10-2*0.2);
                }
            }
            dcu_shape(dcu_dep-dcu_lid_dep,0,0.2,0.2);
        }
    }
    
    switch_pocket_neg();
    cable_pocket_neg();
    
    //screw cutouts
    screw_loc_body_face() translate([0,0,dcu_dep-dcu_lid_dep]) screw_co(8,4);
    
    //screw cutouts
    screw_loc_holder_body() mirror([0,0,1]) screw_co(8,4);
}

module screw_loc_body_face() for(ixm=[0,1]) mirror([ixm,0,0]) {
    translate([(dcu_wid/2)-7.5,(ixm==0?-12.5:-5),0]) children();
    translate([30,(dcu_hgt/2)-7.5,0]) rotate([0,0,90]) children();
    translate([30,-((dcu_hgt/2)-7.5),0]) rotate([0,0,-90]) children();
}

module dcu_face() translate([0,0,dcu_phone_holder_hgt+dcu_dep-dcu_lid_dep]) difference() {
    hull() {
        dcu_shape(dcu_lid_dep-2,-0.2);
        translate([0,0,0.2]) for(ib=[0,2]) dcu_shape(dcu_lid_dep-ib-0.2,-(2-ib));
    }
    
    //cutout for switch pocket positive lip
    for(ixm=[0,1]) switch_pocket_wall_loc(ixm) cylinder(r=switch_pkt_rad+2.4+0.4,h=50);
    for(ixm=[0,1]) switch_pocket_wall_loc(ixm) translate([0,0,-0.01]) cylinder(r1=switch_pkt_rad+2.4+0.4+0.2,r2=switch_pkt_rad+2.4+0.4,h=0.2);
    for(ixm=[0,1]) switch_pocket_wall_loc(ixm) translate([0,0,dcu_lid_dep-0.4+0.01]) cylinder(r1=switch_pkt_rad+2.4+0.4,r2=switch_pkt_rad+2.4+0.4+0.4,h=0.4);
    
    //cutout for cable pocket positive lip
    for(ixm=[0,1]) cable_pocket_wall_loc(ixm) translate([0,0,-0.01]) cylinder(r=switch_pkt_rad+2.4+0.4,h=50);
    for(ixm=[0,1]) cable_pocket_wall_loc(ixm) translate([0,0,-0.01]) cylinder(r1=switch_pkt_rad+2.4+0.4+0.2,r2=switch_pkt_rad+2.4+0.4,h=0.2);
    for(ixm=[0,1]) cable_pocket_wall_loc(ixm) translate([0,0,dcu_lid_dep-0.4+0.01]) cylinder(r1=switch_pkt_rad+2.4+0.4,r2=switch_pkt_rad+2.4+0.4+0.4,h=0.4);
    
    //screw cutouts
    screw_loc_body_face() screw_co(8,4);
}


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
    
    if(co) translate([0,0,-1]) {
        
        //wall cutout
        translate([0,0,1-4]) {
            hull() cylinder_oh(r_3,4);
            hull() {
                cylinder_oh(r_3,bev_m);
                translate([0,0,-0.01]) cylinder_oh(r_3+bev_m,0.01);
            }
            translate([0,0,4-1]) hull() {
                cylinder_oh(r_3+bev_m,0.01);
                translate([0,0,-bev_m]) cylinder_oh(r_3,bev_m);
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


module switch_pocket_cent_loc(ixm=0) {
    mirror([ixm,0,0]) {
        total_pkt_wid = list_sum(side_switch_pkt_wid[ixm]) + (len(side_switch_pkt_wid[ixm])-1)*switch_pkt_sep_wid;
        
        translate([(dcu_wid/2-crn_rad)-total_pkt_wid/2*sin(30)+crn_rad*cos(30),(dcu_hgt/2-crn_rad)-total_pkt_wid/2*cos(30)+crn_rad*sin(30),0]) rotate([0,0,90+30]) {
            children();
        }
    }
}

module switch_pocket_wall_loc(ixm=0) {
    switch_pocket_cent_loc(ixm) {
        total_pkt_wid = list_sum(side_switch_pkt_wid[ixm]) + (len(side_switch_pkt_wid[ixm])-1)*switch_pkt_sep_wid;
        
        hull() for(ix=[-1,1]*(total_pkt_wid/2-switch_pkt_rad)) for(iy=[-10,switch_pkt_hgt-switch_pkt_rad]) translate([ix,iy,0]) {
            children();
            if(ix>0 && iy!=-10) rotate([0,0,-30]) translate([50,0,0]) children();
            if(ix<0 && iy!=-10) rotate([0,0,90-30]) translate([-50,0,0]) children();
        }
    }
}

module switch_pocket_pocket_loc(ixm=0,switch_i=0) {
    switch_pocket_cent_loc(ixm) {
        total_pkt_wid = list_sum(side_switch_pkt_wid[ixm]) + (len(side_switch_pkt_wid[ixm])-1)*switch_pkt_sep_wid;
        
        //echo(switch_i);
        //echo(side_switch_pkt_wid[ixm]);
        //echo(list_partial(side_switch_pkt_wid[ixm],0,switch_i));
        //echo(list_sum(list_partial(side_switch_pkt_wid[ixm],0,switch_i)));
        
        switch_cent_x =
            - total_pkt_wid/2
            + list_sum(list_partial(side_switch_pkt_wid[ixm],0,switch_i))
            + switch_i*switch_pkt_sep_wid
            - side_switch_pkt_wid[ixm][switch_i]/2;
        
        translate([switch_cent_x,0,0]) {
            children();
        }
    }
}


module switch_pocket_pos() {
    //lip
    intersection() {
        for(ixm=[0,1]) switch_pocket_wall_loc(ixm) {
            cylinder(r=switch_pkt_rad+2.4-0.4,h=dcu_dep);
            cylinder(r=switch_pkt_rad+2.4,h=dcu_dep-0.4);
        }
        //intersect with outer shape
        dcu_shape(dcu_dep,0,0.2,2);
    }
    //wall
    intersection() {
        for(ixm=[0,1]) switch_pocket_wall_loc(ixm) {
            cylinder(r=switch_pkt_wall_wid+switch_pkt_rad-0.2,h=dcu_dep-dcu_lid_dep);
            translate([0,0,0.2]) cylinder(r=switch_pkt_wall_wid+switch_pkt_rad,h=dcu_dep-dcu_lid_dep-2*0.2);
        }
        //intersect with outer shape
        dcu_shape(dcu_dep-dcu_lid_dep,0,0.2,0.2);
    }
}

module switch_pocket_co(wid,hgt,dep,outset=0) {
    hull() for(ix=[-1,1]*(wid/2-switch_pkt_rad)) for(iy=[0,hgt-switch_pkt_rad]) translate([ix,iy,dcu_dep-dep+switch_pkt_rad]) {
        sphere(r=switch_pkt_rad+outset);
        cylinder(r=switch_pkt_rad+outset,h=50);
        translate([0,-90,0]) cylinder(r=switch_pkt_rad+outset,h=50);
    }
}

module switch_pocket_neg() {
    for(ixm=[0,1]) for(switch_i=[0:len(side_switch_pkt_wid[ixm])-1]) {
        switch_pocket_pocket_loc(ixm,switch_i) {
            //switch pocket cutouts
            switch_pocket_co(side_switch_pkt_wid[ixm][switch_i],side_switch_pkt_hgt[ixm][switch_i],switch_pkt_dep);
            
            //switch holes
            translate([0,side_switch_pkt_hgt[ixm][switch_i],dcu_dep-switch_pkt_sw_dep]) {
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
                translate([0,4+switch_pkt_hgt-side_switch_pkt_hgt[ixm][switch_i],0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(6+0.2,10);
                    translate([0,0,-0.2]) cylinder_oh(6,10);
                }
                
                //divot for keyed washer
                for(iz=[-1,1]) translate([0,0,6*iz]) {
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
    
    //side bevels - switch pocket cutout
    for(ixm=[0,1]) for(switch_i=[0:len(side_switch_pkt_wid[ixm])-1]) hull() for(ib=[0,0.4]) difference() {
        switch_pocket_pocket_loc(ixm,switch_i) {
            switch_pocket_co(side_switch_pkt_wid[ixm][switch_i],side_switch_pkt_hgt[ixm][switch_i],switch_pkt_dep,ib);
        }
        dcu_shape(100,-(0.4-ib));
    }
    
    //top bevels - switch pocket cutout
    for(ixm=[0,1]) for(switch_i=[0:len(side_switch_pkt_wid[ixm])-1]) hull() for(ib=[0,0.4]) difference() {
        switch_pocket_pocket_loc(ixm,switch_i) {
            switch_pocket_co(side_switch_pkt_wid[ixm][switch_i],side_switch_pkt_hgt[ixm][switch_i],switch_pkt_dep,ib);
        }
        dcu_shape(dcu_dep-(0.4-ib),100);
    }
}

module cable_pocket_cent_loc(ixm=0) {
    mirror([ixm,0,0]) {
        total_pkt_wid = side_cable_pkt_wid[ixm];
        pkt_angle = 15;
        
        translate([(dcu_wid/2-crn_rad)-total_pkt_wid/2*sin(pkt_angle)+crn_rad*cos(pkt_angle),-(dcu_hgt/2-crn_rad)+total_pkt_wid/2*cos(pkt_angle)-crn_rad*sin(pkt_angle),0]) rotate([0,0,90-pkt_angle]) {
            children();
        }
    }
}

module cable_pocket_wall_loc(ixm=0) {
    cable_pocket_cent_loc(ixm) {
        total_pkt_wid = side_cable_pkt_wid[ixm];
        pkt_angle = 15;
        
        hull() for(ix=[-1,1]*(total_pkt_wid/2-switch_pkt_rad)-[50,0]) for(iy=[-10,side_cable_pkt_hgt[ixm]-switch_pkt_rad]) translate([ix,iy,0]) {
            children();
            if(ix>0 && iy!=-10) rotate([0,0,90+pkt_angle]) translate([-50,0,0]) children();
        }
    }
}

module cable_pocket_pos() {
    //lip
    intersection() {
        for(ixm=[0,1]) cable_pocket_wall_loc(ixm) {
            cylinder(r=switch_pkt_rad+2.4-0.4,h=dcu_dep);
            cylinder(r=switch_pkt_rad+2.4,h=dcu_dep-0.4);
        }
        //intersect with outer shape
        dcu_shape(dcu_dep,0,0.2,2);
    }
    //wall
    intersection() {
        for(ixm=[0,1]) cable_pocket_wall_loc(ixm) {
            cylinder(r=switch_pkt_wall_wid+switch_pkt_rad-0.2,h=dcu_dep-dcu_lid_dep);
            translate([0,0,0.2]) cylinder(r=switch_pkt_wall_wid+switch_pkt_rad,h=dcu_dep-dcu_lid_dep-2*0.2);
        }
        //intersect with outer shape
        dcu_shape(dcu_dep-dcu_lid_dep,0,0.2,0.2);
    }
}

module cable_pocket_co(wid,hgt,dep,outset=0) {
    hull() for(ix=[-1,1]*(wid/2-switch_pkt_rad)-[20,0]) for(iy=[-10,hgt-switch_pkt_rad]) translate([ix,iy,dcu_dep-dep+switch_pkt_rad]) {
        sphere(r=switch_pkt_rad+outset);
        cylinder(r=switch_pkt_rad+outset,h=50);
        translate([0,-90,0]) cylinder(r=switch_pkt_rad+outset,h=50);
    }
}

module cable_pocket_neg() {
    for(ixm=[0,1]) cable_pocket_cent_loc(ixm) {
        total_pkt_wid = side_cable_pkt_wid[ixm];
        
        //cable pocket cutouts
        cable_pocket_co(total_pkt_wid,side_cable_pkt_hgt[ixm],cable_pkt_dep,0);
        
        *hull() for(ix=[-1,1]*(total_pkt_wid/2-switch_pkt_rad)-[20,0]) for(iy=[-10,side_cable_pkt_hgt[ixm]-switch_pkt_rad]) translate([ix,iy,dcu_dep-cable_pkt_dep+switch_pkt_rad]) {
            sphere(r=switch_pkt_rad);
            cylinder(r=switch_pkt_rad,h=50);
            translate([0,-90,0]) cylinder(r=switch_pkt_rad,h=50);
        }
        
        //cable holes
        translate([0,side_cable_pkt_hgt[ixm],dcu_dep-cable_pkt_cab_dep]) {
            if(ixm==0) {
                rotate([-90,0,0]) hull() cylinder_oh(16/2+0.2,4);
                translate([0,-0.01,0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(16/2+0.2+0.2,0.01);
                    cylinder_oh(16/2+0.2,0.2);
                }
                translate([0,4,0]) rotate([-90,0,0]) hull() {
                    cylinder_oh(16/2+0.2+0.2,10);
                    translate([0,0,-0.2]) cylinder_oh(16/2+0.2,10);
                }
                %translate([0,-25,0]) rotate([-90,0,0]) cylinder(r=24/2,h=50);
            } else {
                translate([0,4,0]) rotate([-90,0,0]) u174_bracket(true,true);
            }
        }
    }
    
    //side bevels - cable pocket cutout
    for(ixm=[0,1]) for(switch_i=[0:len(side_switch_pkt_wid[ixm])-1]) hull() for(ib=[0,0.4]) intersection() {
        cable_pocket_cent_loc(ixm) cable_pocket_co(side_cable_pkt_wid[ixm],side_cable_pkt_hgt[ixm],cable_pkt_dep,ib);
        translate([-200,-200-dcu_hgt/2+(0.4-ib),0]) cube([400,200,200]);
    }
    for(ixm=[0,1]) for(switch_i=[0:len(side_switch_pkt_wid[ixm])-1]) hull() for(ib=[0,0.4]) intersection() {
        cable_pocket_cent_loc(ixm) cable_pocket_co(side_cable_pkt_wid[ixm],side_cable_pkt_hgt[ixm],cable_pkt_dep,ib);
        cable_pocket_cent_loc(ixm) translate([-200,-200+(0.4-ib),0]) cube([400,200,200]);
    }
    //side corner bevels - cable pocket cutout
    for(ixm=[0,1]) mirror([ixm,0,0]) {
        total_pkt_wid = side_cable_pkt_wid[ixm];
        pkt_angle = 15;
        
        #translate([(dcu_wid/2-crn_rad)-total_pkt_wid*sin(pkt_angle),-((dcu_hgt/2-crn_rad)-0*cos(pkt_angle)),0]) {
            rotate([0,0,270]) rotate_extrude(angle=90-pkt_angle) polygon([
                [crn_rad*sqrt(2)+1,-0.01],
                [crn_rad*sqrt(2)+1,dcu_dep-cable_pkt_dep+0.01],
                [crn_rad-0.4,dcu_dep-cable_pkt_dep+0.01],
                [crn_rad,dcu_dep-cable_pkt_dep-0.4],
                [crn_rad,0.2],
                [crn_rad+0.2,-0.01],
            ]);
        }
    }
    
    //top bevels - cable pocket cutout
    for(ixm=[0,1]) hull() for(ib=[0,0.4]) difference() {
        cable_pocket_cent_loc(ixm) cable_pocket_co(side_cable_pkt_wid[ixm],side_cable_pkt_hgt[ixm],cable_pkt_dep,ib);
        dcu_shape(dcu_dep-(0.4-ib),200);
    }
}



module screw_co(screw_len=8,screw_dep=4,head_bevel=undef) {
    translate([0,0,-screw_dep]) hull() {
        cylinder(r=1.25-0.5,h=50);
        translate([0,0,0.5]) cylinder(r=1.25,h=50);
    }
    hull() {
        cylinder(r=1.5+0.15,h=50);
        translate([0,0,-(1.5+0.15)]) cylinder(r=0.01,h=50);
    }
    translate([0,0,screw_len-screw_dep]) hull() {
        cylinder(r=3,h=50);
        translate([0,0,-3]) cylinder(r=0.01,h=50);
    }
}

module dcu_shape(hgt=dcu_dep,outset=0,bev_btm=0,bev_top=0) {
    hull() for(ixm=[0,1]) mirror([ixm,0,0]) {
        switch_total_pkt_wid = list_sum(side_switch_pkt_wid[ixm]) + (len(side_switch_pkt_wid[ixm])-1)*switch_pkt_sep_wid;
        cable_total_pkt_wid = side_cable_pkt_wid[ixm];
        
        for(iy=[-1,1]) {
            total_pkt_wid = (iy>0?switch_total_pkt_wid:cable_total_pkt_wid);
            pkt_angle = (iy>0?30:15);
            
            for(ix=[0,total_pkt_wid]) translate([(dcu_wid/2-crn_rad)-ix*sin(pkt_angle),iy*((dcu_hgt/2-crn_rad)-(total_pkt_wid-ix)*cos(pkt_angle)),0]) {
                if(bev_btm>0) cylinder(r=crn_rad+outset-bev_btm,h=hgt-bev_top);
                translate([0,0,bev_btm]) {
                    cylinder(r=crn_rad+outset,h=hgt-bev_btm-bev_top);
                    if(bev_top>0) cylinder(r=crn_rad+outset-bev_top,h=hgt-bev_btm);
                }
            }
        }
    }
}



module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}