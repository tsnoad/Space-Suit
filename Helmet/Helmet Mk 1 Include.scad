prime_r = 120;
wall_thk = 8;
prime_r_in = prime_r-wall_thk;

inset = 0;

head_min_rad = prime_r;
head_maj_rad = 20;

face_outset = 45;
face_top = 25-5;
face_bottom = -100-5;

scnd_rad = prime_r+17.5;
tert_rad = 192.5;

flange_wid = 15;
flange_clr_int = 0.2;
flange_clr_ext = 0.1;

    
clr_h = 0.4;
clr_h_s = 0.2;
clr_v = 0.2;
bev_xs = 0.2;
bev_s = 0.4;
bev_xl = 4;


viewport_crn_r = 40;
viewport_w_a = 120+22.5;
viewport_crv_d = (head_min_rad*2*3.1415);
viewport_crn_w_a = viewport_crn_r/viewport_crv_d*360;
viewport_inset = -2.5;
    
    
    
//head_min_rad = 120;
//head_maj_rad = 20;

face_angle = 15;
//face_outset = 45;
//face_top = 25;
//face_bottom = -100;

neckring_angle = 30;
neckring_hgt = 20;

neck_hgt = 50;
neck_angle = neckring_angle-face_angle;


dat_neck_bottom_y = -head_maj_rad*cos(neck_angle)+neck_hgt*sin(neck_angle);
dat_neck_bottom_z = -head_maj_rad*sin(neck_angle)-neck_hgt*cos(neck_angle);

dat_nape_org_y = dat_neck_bottom_y-(head_min_rad+20)*cos(neck_angle);
dat_nape_org_z = dat_neck_bottom_z-(head_min_rad+20)*sin(neck_angle);

dat_nape_bottom_y = dat_nape_org_y+(head_min_rad+20)*cos(face_angle);
dat_nape_bottom_z = dat_nape_org_z-(head_min_rad+20)*sin(face_angle);

dat_neckring_bottom_y = dat_nape_bottom_y-neckring_hgt*sin(face_angle);
dat_neckring_bottom_z = dat_nape_bottom_z-neckring_hgt*cos(face_angle);



oring_rad = sqrt((pow(1.5,2)*0.9)); //o-ring radius when compressed to 90%