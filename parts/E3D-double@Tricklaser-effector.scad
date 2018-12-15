// Holder for E3D Chimera+ & Cyclops+ for Tricklaser effector
// Part of Ashwood open source 3D-printer project
// Original author: Artem Grunichev aka Renha
// Distributed under CC-BY-NC-SA

fnh= 128;
fnm= 64;
fnl= 32;

$fn= fnm;

aqua_h= 20;
aqua_w= 30;
aqua_a= 21;

aqua_mount_z= 10;
aqua_mount_xy= 9;

aqua_mount_d= 3+0.4;
aqua_mount_head_d= 6+0.4;

aqua_mountain= 6;

less= 0.02;

aqua_mount_c= 0;

module aqua_radiator()
{
    difference()
    {
        hull()
        {
            translate([-6, -aqua_w/2])
                cube([6+5, aqua_w, aqua_h]);
            translate([-6, -aqua_mountain/2])
                cube([aqua_a
            , aqua_mountain, aqua_h]);
        }
        translate([-6, 0, aqua_h-0*aqua_mount_c])
            for (i= [-1,1]/2, j= [-1,1]/2)
                translate([-less, i*aqua_mount_xy, j*aqua_mount_z]) rotate([0,90,0])
                    cylinder(d= aqua_mount_d, h= 6 + less);
    }
    
}


holder_h= aqua_h;


much= 1000;


base_r= 18;
base_mount_d= 3;
base_mount_wall= 1.4;

base_mount_hat_d= 6;
base_mount_hat_h= 4;

aqua_mount_hat_d= 6;
aqua_mount_hat_h= 4;

base_mount_hat_front_h= 4+5;

hot_adjusters_z= [3,3+8];
hot_adjusters_d= 3 + .2;

base_wall= (base_mount_hat_d-base_mount_d)/2;
//echo(base_wall);

outer_r= base_r+base_mount_d/2+base_wall + 1.5;
echo(outer_r);

base_ends= 3*2;

nozzle_d= .35;

safe_d= nozzle_d*4;

inner_airhole_z_r= base_r - 6 - base_mount_wall - (outer_r-base_r);
inner_airhole_x_r= holder_h/2;

module aqua_holder()
{     
    difference()
    {
        if (base_ends)
        {
            hull() for(ai= [0:360/base_ends:360-360/base_ends]) rotate(ai)
            translate([base_r, 0])
                cylinder(r= outer_r-base_r, h= holder_h);
        }
        else
            cylinder(r= outer_r, h= holder_h, $fn= fnh);

        
        rotate(180)
        {
            difference()
            {
                hull() for(yi=[-1,1]) translate([-6-base_mount_wall,yi*(aqua_w/2 - inner_airhole_z_r), -less])
                    cylinder(r= inner_airhole_z_r, h= much, $fn= fnh);
                cube([2*(6+base_mount_wall), aqua_w, much], center= true);
            }
            hull() for(yi=[-1,1]) translate([-6-base_mount_wall,yi*(aqua_w/2 - inner_airhole_x_r), -less])
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
                            translate([0,0,-6-base_wall])
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
                cylinder(d= base_mount_d, h= holder_h+2*less, , $fn= fnl);
        }
        
        for(zi= hot_adjusters_z) translate([0,0,zi]) rotate([90,0,0])
            cylinder(d= hot_adjusters_d, h= much, center= true, $fn= fnl);
        
        translate([base_r,0,-less])
            cylinder(d= base_mount_d, h= holder_h+2*less, $fn= fnl);
    }
}


//% rotate(180) aqua_radiator();
translate([0,0,aqua_h]) rotate([180,0,0]) aqua_holder();