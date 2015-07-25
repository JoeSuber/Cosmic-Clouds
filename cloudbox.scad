// cloud chamber top box
// possible injection molding or laser cut
frontpane=200;
paneheight=120;
panethick=3;
icebase=80;
lip=2.33;
iceboxdepth = 30;
icebox=[frontpane+lip*2, icebase+lip*2, iceboxdepth];
ledstrip=12;
leddiam=5;
//windowpane();
//ledshape();
housing();


module windowpane (dims=[frontpane, paneheight, panethick]){
    translate([0,0,paneheight/2+iceboxdepth+ledstrip])
        rotate([90,0,0])
        cube(dims, center=true);
}

module metalbox (dims=icebox) {
    translate([0,0,dims[2]/2])
        cube(dims, center=true);
}

module ledshape(diam=leddiam, baseht=1, bodyht=6.3, legs=1.25, leght=27, basemult=1.19) {
    difference(){
        union(){
            cylinder(h=baseht, r=diam*basemult/2, center=false, $fn=16);
            translate([0,0,baseht])
                cylinder(h=bodyht, r=(diam+.1)/2, center=false, $fn=16);
            translate([0,0,baseht+bodyht])
                sphere(r=(diam+.1)/2, $fn=16);
            for (i=[1,-1]){
                translate([i*legs, 0, -(leght+i*2) / 2])
                    cylinder(h=leght+i*2, r=.25, $fn=4, center=true);
            }
        }
         translate([-diam/2 - (diam*basemult - diam)/2, -diam*basemult*0.5, 0])
            cube([(diam*basemult - diam)/2, diam*basemult, baseht*1.01]);
    }
}

module ledstrip(quant=28, space=frontpane-leddiam) {
    centers = space/quant;
    for (i=[leddiam/2:centers:space]){
        translate([i,0,0]) rotate([90,0,0])
            ledshape();
    }
}

module housing(cornerrad=9, lip=lip, windowlip=5){
    wallthickness = 9;
    inoutx = (frontpane+cornerrad-wallthickness*2)/ (frontpane+cornerrad);
    inouty = (icebase+cornerrad-wallthickness*2)/ (icebase+cornerrad);
    inoutz =  (paneheight+iceboxdepth+cornerrad-wallthickness*2)/ (paneheight+cornerrad+iceboxdepth);
    difference(){
            translate([0,0,(paneheight+iceboxdepth)/2+cornerrad])
            minkowski(){
                sphere(r=cornerrad, $fn=16);
                cube([frontpane, icebase, paneheight+iceboxdepth], center=true);
        }
            translate([0,0,((paneheight+iceboxdepth)/2+cornerrad)*inoutz])
            scale([inoutx,inouty,inoutz])
                minkowski(){
                    sphere(r=cornerrad, $fn=16);
                    cube([frontpane, icebase, paneheight+iceboxdepth], center=true);
        }
        metalbox();
        translate([0,icebase/2+cornerrad-panethick/2,0])
           windowpane();
         translate([0,icebase/2+panethick/2,0])
            windowpane(dims=[frontpane+lip*2, paneheight+lip*2, cornerrad+.1]);
        translate([-frontpane/2,icebase/2+4,iceboxdepth+ledstrip/2])
        #ledstrip(quant=28, space=frontpane);
        translate([0,0,iceboxdepth+ledstrip+paneheight-cornerrad-3]){
            #cube([frontpane-cornerrad*2,60,3], center=true);
            for(i=[1,-1], j=[1,-1]){
                translate([.54*frontpane*i/2, .54*icebase*j/2, 0]){
                    #cylinder(r=(25.4*.25/2), h=50, center=true, $fn=16);
                    translate([0,0,17])
                    #cylinder(r=6.4, h=5, center=true, $fn=6);
                }
            }
        }
    }
}