// Holder for E3D Chimera+ & Cyclops+ for Tricklaser effector
// Part of Ashwood open source 3D-printer project
// Original author: Artem Grunichev aka Renha
// Distributed under CC-BY-NC-SA

fnx= 256;
fnh= 128;
fnm= 64;
fnl= 32;

$fn= fnm;

// Printer nozzle (or line) width
printer_nozzle_d= .35;
// Printer imperfection dimension compensation, for perfect printing return dimension
function compensate(dimension) = dimension * 1.016 + .528; 

aqua_h= 20;
aqua_w= compensate(30);
aqua_a= compensate(21);
aqua_p= 6;// + (compensate(21)-21)/2;

aqua_mount_z= 10;
aqua_mount_xy= 9;

aqua_mount_d= compensate(3);
aqua_mount_head_d= compensate(5.5);

aqua_mountain= 6;

less= 0.02;

aqua_mount_c= 0;

module aqua_radiator()
{
    difference()
    {
        hull()
        {
            translate([-aqua_p, -aqua_w/2])
                cube([aqua_p+5, aqua_w, aqua_h]);
            translate([-aqua_p, -aqua_mountain/2])
                cube([aqua_a, aqua_mountain, aqua_h]);
        }
    }
    
}


holder_h= aqua_h;


much= 1000;


base_r= 18;
base_mount_d= compensate(3);
base_mount_wall= 2.1;

base_mount_hat_d= compensate(5.5);
base_mount_hat_h= 4;

aqua_mount_hat_d= compensate(5.5);
aqua_mount_hat_h= 4;

base_mount_hat_front_h= 4+5;

hot_adjusters_z= [3,3+8];
hot_adjusters_d= compensate(3);

base_wall= (base_mount_hat_d-base_mount_d)/2;
//echo(base_wall);

outer_r= base_r+base_mount_d/2+base_wall + 1.5;
echo(outer_r);

base_ends= 3*2;
base_full= false;

safe_d= printer_nozzle_d*4;

inner_airhole_z_r= base_r - 6 - base_mount_wall - (outer_r-base_r);
inner_airhole_x_r= holder_h/2;

module aqua_holder()
{     
    difference()
    {
        if (base_ends)
        {
            if (base_full)
            {
                hull() for(ai= [0:360/base_ends:360-360/base_ends]) rotate(ai)
                translate([base_r, 0])
                    cylinder(r= outer_r-base_r, h= holder_h);
            }
            else
            {
                union()
                {
                    cylinder(d= aqua_a, h= holder_h);
                    for(mi=[0,1]) mirror([0,mi,0]) hull() for(ai= [0:360/base_ends:180-less]) rotate(ai)
                        translate([base_r, 0]) cylinder(r= outer_r-base_r, h= holder_h);
                }
                
            }
        }
        else
            cylinder(r= outer_r, h= holder_h, $fn= fnh);

        
        rotate(180)
        {
            difference()
            {
                hull() for(yi=[-1,1]) translate([-6-base_mount_wall,yi*(aqua_w/2 - inner_airhole_z_r),-less])
                    cylinder(r= inner_airhole_z_r, h= much, $fn= fnh);
                cube([2*(6+base_mount_wall), aqua_w, much], center= true);
            }
            hull() for(yi=[-1,1]) translate([-6-base_mount_wall,yi*(aqua_w/2 - inner_airhole_x_r)])
                rotate([0,-90,0])cylinder(r= inner_airhole_x_r, h= much, $fn= fnh);

            scale([1,1,2]) translate([0,0,-holder_h/4]) hull() aqua_radiator();
            
            for (ai=[-90,0,90]) rotate(ai) translate([base_r-3,0,-less])
                if(ai) cylinder(d= 5, h= much);
                else   cylinder(d= 6, h= much);

            translate([-much, 0, holder_h/2])
                for (i= [-1,1]/2, j= [-1,1]/2)
                    translate([-less, i*aqua_mount_xy, j*aqua_mount_z])
                        rotate([0,90,0])
                        {
                            cylinder(d= aqua_mount_d, h= much, $fn= fnl);
                            if(j>0) translate([0,0,-6-base_mount_wall])
                                cylinder(d= aqua_mount_hat_d, h= much);
                        }
        }
        
        for(ai=[120,240]) rotate(ai)
        {
            translate([0,0,-less]) hull()
            {
                cylinder(d= base_mount_hat_d, h= base_mount_hat_h+less);
                if (outer_r - base_r - base_mount_hat_d/2 < safe_d)
                {
                    translate([2*base_r,0,-less])
                        cylinder(d= base_mount_hat_d, h= base_mount_hat_h+less);
                } else {
                    translate([1*base_r,0,-less])
                        cylinder(d= base_mount_hat_d, h= base_mount_hat_h+less);
                }
            }
            translate([base_r,0,-less])
                cylinder(d= base_mount_d, h= holder_h+2*less, $fn= fnl);
        }
        
        hull()
        {
            translate([-much+aqua_p,-much/2,-less]) cube([much,much,less]);
            translate([-much,-much/2]) cube([much-5,much,holder_h/2]);
        }
        
        hull()
        {
            translate([aqua_p+base_mount_wall,-much/2,-less]) cube([much,much,less]);
            translate([base_r,-much/2]) cube([much,much,holder_h/2]);
        }
        
        for(zi= hot_adjusters_z) translate([0,0,zi]) rotate([90,0,0])
            cylinder(d= hot_adjusters_d, h= much, center= true, $fn= fnl);
        
        translate([base_r,0,-less])
            cylinder(d= base_mount_d, h= holder_h+2*less, $fn= fnl);
    }
}


//% rotate(180) aqua_radiator();
translate([0,0,aqua_h]) rotate([180,0,0]) aqua_holder();