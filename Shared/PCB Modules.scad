
//clearance for PCB pins that extend below the PCB
module pcb_pin_co(pins_x=[0],pins_y=[0],co=true) {
    clr = 0.25;
   
    hull() {
        for(ix=[min(pins_x),max(pins_x)]*2.54+[-1,1]*2.54/2) {
            for(iy=[min(pins_y),max(pins_y)]*2.54+[-1,1]*2.54/2) {
                translate([ix,iy,-2.4]) {
                    cylinder(r=(co?clr:0.01),h=20);
                }
            }
        }
    }
}

//clearance for a JST-XH-2.5mm socket
module jstxh_socket_co(pins_x=[0],co=true) {
    clr = 0.4;
    
    hull() {
        //lets just pretend that JST-XH is 2.54mm pitch
        for(ix=[min(pins_x),max(pins_x)]*2.54+[-1,1]*2.5/2) {
            for(iy=[2,-5.7+2]) {
                translate([ix,iy,0]) {
                    cylinder(r=(co?clr:0.01),h=6.9+(co?10:0));
                }
            }
        }
    }
}

module pcb_screw_cap_co(th_hgt=0,screw_len=6) {
    translate([0,0,th_hgt-screw_len]) hull() {
        cylinder(r=1.25,h=20);
        translate([0,0,0.5]) cylinder(r=1.25-0.5,h=20);
    }
    hull() {
        cylinder(r=1.5+0.15,h=20);
        translate([0,0,-(1.5+0.15)]) cylinder(r=0.01,h=20);
    }
}

/*
 * Adafruit MCP23017 I2C GPIO expander
 * https://www.adafruit.com/product/5346
 */
module mcp23017(co=false,co_screw=false) {
    clr_h = 0.25;
    
    pcb_wh = 0.7*25.4/2; //why inches, adafruit?
    pcb_hh = 1.7*25.4/2;
    pcb_t = 1.6;
    crn_r = 2;
    
    if(!co_screw) difference() {
        hull() for(ix=[-1,1]*(pcb_wh-crn_r)) for(iy=[-1,1]*(pcb_hh-crn_r)) translate([ix,iy,-pcb_t]) cylinder(r=crn_r+(co?clr_h:0.01),h=(co?20:pcb_t));
        
        if(!co) mcp23017(false,true);
    }
    
    //pcb bevel
    if(co) hull() for(ix=[-1,1]*(pcb_wh-crn_r)) for(iy=[-1,1]*(pcb_hh-crn_r)) translate([ix,iy,-0.2+0.01]) cylinder(r1=crn_r+clr_h,r2=crn_r+clr_h+0.2,h=0.2+0.01);
    
    if(co) for(ixm=[0,1]) mirror([ixm,0,0]) {
        //clearance for pcb pins
        translate([pcb_wh-0.1*25.4,0,-pcb_t]) pcb_pin_co([0],[-6,6],true);
        translate([pcb_wh-0.1*25.4,0,-pcb_t]) pcb_pin_co([-1,0],[-6,1],true);
        
        //clearance for jst connector
    }
    
    if(co_screw) for(ix=[-1,1]*(pcb_wh-0.1*25.4)) for(iy=[-1,1]*(pcb_hh-0.1*25.4)) translate([ix,iy,-pcb_t]) pcb_screw_cap_co(pcb_t);
}

/*
 * Adafruit ADS7830 ADC
 * https://www.adafruit.com/product/5836
 */
module ads7830(co=false,co_screw=false) {
    clr_h = 0.25;
    
    pcb_wh = 0.7*25.4/2; //why inches, adafruit?
    pcb_hh = 1.2*25.4/2;
    pcb_t = 1.6;
    crn_r = 2;
    
    if(!co_screw) difference() {
        hull() for(ix=[-1,1]*(pcb_wh-crn_r)) for(iy=[-1,1]*(pcb_hh-crn_r)) translate([ix,iy,-pcb_t]) cylinder(r=crn_r+(co?clr_h:0.01),h=(co?20:pcb_t));
        
        if(!co) mcp23017(false,true);
    }
    
    //pcb bevel
    if(co) hull() for(ix=[-1,1]*(pcb_wh-crn_r)) for(iy=[-1,1]*(pcb_hh-crn_r)) translate([ix,iy,-0.2+0.01]) cylinder(r1=crn_r+clr_h,r2=crn_r+clr_h+0.2,h=0.2+0.01);
    
    if(co) for(ixm=[0,1]) mirror([ixm,0,0]) {
        //clearance for pcb pins
        translate([pcb_wh-0.1*25.4,0,-pcb_t]) pcb_pin_co([0],[-3.5,3.5],true);
        
        //clearance for jst connector
    }
    
    if(co_screw) for(ix=[-1,1]*(pcb_wh-0.1*25.4)) for(iy=[-1,1]*(pcb_hh-0.1*25.4)) translate([ix,iy,-pcb_t]) pcb_screw_cap_co(pcb_t);
}

/*
 * I2C expander
 * https://www.aliexpress.com/item/1005007565254884.html
 */
module i2c_expander(co=false,co_screw=false) {
    clr_h = 0.25;
    
    pcb_wh = 15/2;
    pcb_hh = 42/2;
    pcb_t = 1.6;
    
    if(!co_screw) difference() {
        hull() for(ix=[-1,1]*pcb_wh) for(iy=[-1,1]*pcb_hh) translate([ix,iy,-pcb_t]) cylinder(r=(co?clr_h:0.01),h=(co?20:1.6));
        
        if(!co) i2c_expander(false,true);
    }
    
    //pcb bevel
    if(co) hull() for(ix=[-1,1]*pcb_wh) for(iy=[-1,1]*pcb_hh) translate([ix,iy,-0.2+0.01]) cylinder(r1=clr_h,r2=clr_h+0.2,h=0.2+0.01);
    
    if(co) translate([0,pcb_hh-9.3,0]) {
        //clearance for pcb pins
        translate([0,0,-pcb_t]) pcb_pin_co([-1.5,1.5],[0,-10],true);
        
        //clearance for jst connector
        for(iy=[0,-3,-6,-9]) translate([0,iy*2.54,-0.01]) jstxh_socket_co([-1.5,1.5],true);
    }
    
    if(co_screw) for(ix=[-1,1]*(9.5/2)) for(iy=[-1,1]*(36.5/2)) translate([ix,iy,-pcb_t]) pcb_screw_cap_co(pcb_t);
}

/*
 * Sparkfun MCP4725 DaC/waveform generator
 * https://www.sparkfun.com/sparkfun-i2c-dac-breakout-mcp4725.html
 */
module mcp4725(co=false,co_screw=false) rotate([0,0,180]) {
    clr_h = 0.25;
    
    pcb_wh = 0.6*25.4/2; //why inches, sparkfun?
    pcb_hh = 0.6*25.4/2;
    pcb_t = 1.6;
    
    if(!co_screw) difference() {
        hull() for(ix=[-1,1]*pcb_wh) for(iy=[-1,1]*pcb_hh) translate([ix,iy,-pcb_t]) cylinder(r=(co?clr_h:0.01),h=(co?20:pcb_t));
        
        if(!co) mcp4725(false,true);
    }
    
    //pcb bevel
    if(co) hull() for(ix=[-1,1]*pcb_wh) for(iy=[-1,1]*pcb_hh) translate([ix,iy,-0.2+0.01]) cylinder(r1=clr_h,r2=clr_h+0.2,h=0.2+0.01);
    
    if(co) translate([-pcb_wh+0.5*2.54,0,0]) {
        //clearance for pcb pins
        translate([0,0,-pcb_t]) pcb_pin_co([0],[-2.5,2.5],true);
        //clearance for jst connector
        translate([0,0,-0.01]) rotate([0,0,-90]) jstxh_socket_co([-2.5,2.5],true);
    }
    
    if(co_screw) for(ix=[pcb_wh-0.075*25.4]) for(iy=[-1,1]*pcb_hh-[-1,1]*0.075*25.4) translate([ix,iy,-pcb_t]) pcb_screw_cap_co(pcb_t);
}