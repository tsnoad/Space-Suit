$fn = 72;

ltr_hgt = 14; //height of letter
ltr_line_wh = 2.4/2; //line width of letter

sqr_widh = (ltr_hgt/2+ltr_line_wh);

tag_r = sqr_widh/cos(45)+ltr_line_wh+1.6; //radius of tag
echo(tag_r);

tag_positions = [
    "CDR",
    "PLT",
    "MS1",
    "MS2",
];

tag_colors = [
    "#C4402B", //red
    "#C99B27", //yellow (gold)
    "#47BFD7", //blue (light blue)
    "#A1DA7D", //green (peak green)
];

tag_letters = [
    "A",
    "B",
    "C",
    "D",
];


/*tag_position_i = 1;
//tag_position = "PLT";
tag_color = tag_colors[tag_position_i];
tag_letter = tag_letters[tag_position_i];*/

tag_color = "#C99B27";
tag_letter = "A";

hole_r = 2.2; //radius of hole for shoelaces

tag_h1 = 0.8+2*hole_r+0.8; //hight of circle
tag_h2 = tag_h1+0.4; //height of square
tag_h3 = tag_h2+0.4; //height of letter

/* Set up parts for export using the makefile */
*/* make 'Crewmember Identification Tag A' */ union() {
    for(ix=[-1,1]*(tag_r+1.5)) translate([ix,0,0]) tag_circle();
    rotate_extrude(angle=90+15) translate([35,0]) square([1.6,tag_h1]);
}
*/* make 'Crewmember Identification Tag B' */ union() {
    for(ix=[-1,1]*(tag_r+1.5)) translate([ix,0,0]) tag_square();
    rotate_extrude(angle=90+15) translate([35,tag_h1]) square([1.6,tag_h2-tag_h1]);
}
!/* make 'Crewmember Identification Tag C' */ union() {
    for(ix=[-1,1]*(tag_r+1.5)) translate([ix,0,0]) tag_letter();
    rotate_extrude(angle=90+15) translate([35,tag_h2]) square([1.6,tag_h3-tag_h2]);
}

//assembled view
for(ix=[-1,1]*(tag_r+1.5)) translate([ix,0,0]) {
    tag_circle();
    tag_square();
    tag_letter();
}

module tag_circle() color(tag_color) difference() {
    hull() {
        bev = 0.2;
        cylinder(r=tag_r-bev,h=tag_h1,$fn=$fn*2);
        translate([0,0,bev]) cylinder(r=tag_r,h=tag_h1-2*bev,$fn=$fn*2);
    }
    
    for(ia=[-1,1]*22.5) rotate([0,0,ia]) {
    //for(iy=[-1,1]*5) translate([0,iy,0]) {
        translate([-tag_r,0,tag_h1/2]) rotate([0,90,0]) hull() rotate([0,0,90]) cylinder_oh(hole_r,2*tag_r);
        for(ixm=[0,1]) mirror([ixm,0,0]) translate([-tag_r,0,tag_h1/2]) rotate([0,90,0]) hull() {
            bev = 0.6;
            rotate([0,0,90]) cylinder_oh(hole_r+bev,0.01);
            rotate([0,0,90]) cylinder_oh(hole_r,bev);
        }
    }
    
    rotate_extrude() {
        bev = 0.4;
        co_r = 5;
        
        translate([co_r,tag_h1/2]) circle(r=hole_r);
        polygon([
            [0,-0.01],
            [co_r+hole_r+bev,-0.01],
            [co_r+hole_r,bev],
            [co_r+hole_r,tag_h1/2],
            
            [co_r,tag_h1/2],
            [co_r+hole_r*sin(45),tag_h1/2+hole_r*cos(45)],
            [co_r+hole_r*tan(22.5),tag_h1/2+hole_r],
            
            
            [0,tag_h1/2+hole_r],
        ]);
    }
}

module tag_square() color("#111111") {
    hull() for(ix=[-1,1]*sqr_widh) for(iy=[-1,1]*sqr_widh) translate([ix,iy,tag_h1-0.01]) {
        bev = 0.2;
        cylinder(r=ltr_line_wh-bev,h=tag_h2-tag_h1);
        cylinder(r=ltr_line_wh,h=tag_h2-tag_h1-bev);
    }
}

module tag_letter() color("#E1E4E7") {
    translate([0,0,tag_h2-0.01]) letter(tag_letter,0.4);
}


module letter(ltr="A",hgt=0.4) {
    ltr_wid = ltr_hgt / 1.62;
    ltr_xhgt = ltr_hgt / 1.62;

    ltr_x = [-0.5,0.5]*ltr_wid;
    ltr_y = [-0.5,0.5]*ltr_hgt;

    ltr_y_xh = [-0.5,-0.5,0.5]*ltr_hgt+[0,1,0]*ltr_xhgt;

    if(ltr == "A") {
        for(ixm=[0,1]) mirror([ixm,0,0]) hull() {
            translate([0,ltr_hgt/2,0]) cylinder(r=ltr_line_wh,h=hgt);
            translate([ltr_wid/2,-ltr_hgt/2,0]) cylinder(r=ltr_line_wh,h=hgt);
        }
        hull() for(ixm=[0,1]) mirror([ixm,0,0]) {
            translate([ltr_wid/ltr_hgt*ltr_xhgt/2,ltr_hgt/2-ltr_xhgt,0]) cylinder(r=ltr_line_wh,h=hgt);
        }
    }

    if(ltr == "B") {
        hull() for(ix=[ltr_x[0]]) for(iy=ltr_y) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        
        translate([0,-ltr_hgt/2+ltr_xhgt/2,0]) rotate([0,0,-90]) rotate_extrude(angle=180) translate([ltr_xhgt/2-ltr_line_wh,0]) square([2*ltr_line_wh,hgt]);
        
        translate([0,ltr_hgt/2-(ltr_hgt-ltr_xhgt)/2,0]) rotate([0,0,-90]) rotate_extrude(angle=180) translate([(ltr_hgt-ltr_xhgt)/2-ltr_line_wh,0]) square([2*ltr_line_wh,hgt]);
        
        
        for(iy=ltr_y_xh) hull() for(ix=[ltr_x[0],0]) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
    }

    if(ltr == "C") {
        for(iym=[0,1]) mirror([0,iym,0]) translate([0,ltr_hgt/2-ltr_wid/2,0]) rotate([0,0,15]) rotate_extrude(angle=180-15) translate([ltr_wid/2-ltr_line_wh,0]) square([2*ltr_line_wh,hgt]);
        
        hull() for(ix=[ltr_x[0]]) for(iy=[-1,1]*(ltr_hgt/2-ltr_wid/2)) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        
        for(ix=[0]) for(iy=[-1,1]*(ltr_hgt/2-ltr_wid/2)) translate([ix,iy,0]) rotate([0,0,sign(iy)*15]) translate([ltr_wid/2,0,0]) cylinder(r=ltr_line_wh,h=hgt);
    }

    if(ltr == "D") {
        for(iym=[0,1]) mirror([0,iym,0]) translate([0,ltr_hgt/2-ltr_wid/2,0]) rotate([0,0,0]) rotate_extrude(angle=90) translate([ltr_wid/2-ltr_line_wh,0]) square([2*ltr_line_wh,hgt]);
        
        hull() for(ix=[ltr_x[0]]) for(iy=ltr_y) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        hull() for(ix=[ltr_x[1]]) for(iy=[-1,1]*(ltr_hgt/2-ltr_wid/2)) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        
        for(iy=ltr_y) hull() for(ix=[ltr_x[0],0]) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
    }

    if(ltr == "E") {
        hull() for(ix=[ltr_x[0]]) for(iy=ltr_y) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        
        for(iy=ltr_y) hull() for(ix=ltr_x) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        for(iy=[0]) hull() for(ix=ltr_x) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
    }

    if(ltr == "T") {
        hull() for(ix=ltr_x) for(iy=[ltr_y[1]]) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
        hull() for(ix=[0]) for(iy=ltr_y) translate([ix,iy,0]) cylinder(r=ltr_line_wh,h=hgt);
    }
}



module cylinder_oh(radius,height) {
    cylinder(r=radius,h=height);
    translate([-radius*tan(22.5),-radius,0]) cube([2*radius*tan(22.5),2*radius,height]);
}
