//Body ship;
Body [] bullet;
Body ship;
Body [] asteroid;

//number of asteroids
int a = 9;

//number of shots
float maxshot = 3000;
int shot = 0;
int initshot = 0;

int screenx = 1280;
int screeny = 720;

//wait interval (equal to 1/60th of second
int wait = 0;
int initwait = 1;

boolean step = true;
boolean debug = true;

//Audio Setup


void setup() {
  if(debug){
    step = false;
    screenx = screenx / 2;
    screeny = screeny / 2;
    if(a>2){
      a = 2;
    }
  }
  bullet = new Body[(int)maxshot];
  ship = new Body(true);
  asteroid = new Body[a];
  
  
  //build map
  size(screenx, screeny);
  Map map = new Map(width, height);
  background(0);
  
    //build asteroids
    for(int i=0;i<a;i++){
      int size = (int)random(40, 100);
      asteroid[i] = new Body();
      asteroid[i].setName("asteroid"+i);
      asteroid[i].sethealth(1);
  asteroid[i].setAvatar("basicasteroid.png");
  asteroid[i].setsize(size, size);
  asteroid[i].mapx = map.width;
  asteroid[i].mapy = map.height;
  asteroid[i].setwrap(true);
  asteroid[i].setpos(random(width / (a - i), width * a / (i + 1)), random(height / (a - i), height * a / (1 + i)));
  asteroid[i].setspeed(random(0,1),random(0,1));
  asteroid[i].setmass(size);
  asteroid[i].setshape("circle");
   }
   
   for( int i = initshot; i < shot; i ++){
      bullet[i] = new Body();
      bullet[i].setName("bullet"+i);
      bullet[i].setAvatar("basiclaser.png");
      bullet[i].setsize(10,10);
      bullet[i].sethealth(1);
      bullet[i].setwrap(false);
      bullet[i].setpos(ship.x, ship.y);
      bullet[i].setspeed(0,0);
      bullet[i].applyforce(ship.vx, ship.vy);
      bullet[i].setmass(1);
      bullet[i].setshape("circle");
   }
  
  //build ship
  ship.setAvatar("basicship.png");
  ship.setName("Ship");
  ship.sethealth(3);
  ship.setsize(50,50);
  ship.mapx = map.width;
  ship.mapy = map.height;
  ship.setwrap(true);
  ship.setpos(width/2,height/2);
  ship.setspeed(2,-1);
  ship.setmass(25);
  ship.applyforce(0,0);
  ship.setshape("circle");
  

  
  println("Start");
}

void draw(){
  if(step){
  background(0);
  
  // }
   //graphics delay
    if(wait == 0){
  for(int i=1;i<a;i++){
    collisiondetect(asteroid[i], asteroid[i-1], initwait, debug);
  }
  for(int j=0;j<a;j++){
    collisiondetect(ship, asteroid[j], initwait, debug);
    for(int k = initshot; k < shot; k ++){
      if(collisiondetect(bullet[k], asteroid[j], initwait, debug) == 1){
        bullet[k].health = 0;
        asteroid[j].health = 0;
        bullet[k] = null;
      }
    }
  }
  wait = initwait;
}
wait = wait - 1;
  for(int i = initshot; i < shot; i ++){
    bullet[i].draw(debug);
    if(bullet[i].x > bullet[i].mapx || bullet[i].y > bullet[i].mapy || bullet[i].x < 0 || bullet[i].y < 0){
      bullet[i].sethealth(0);
      initshot += 1;
    }
  }
  ship.draw(debug);
  for(int i = 0; i < a; i ++){
  asteroid[i].draw(debug);
  }
 if(debug){
   step = false;
 }
}}



void mouseDragged(){
  ship.fx = mouseX - pmouseX;
  ship.fy = mouseY - pmouseY;
}

void mouseClicked(){
  step = true;
  if(dist(mouseX, mouseY, ship.x, ship.y) < ship.width &&
     dist(mouseX, mouseY, ship.x, ship.y) < ship.height){
       shot = shoot(shot, debug);
       //gun
       int i = shot - 1;
      bullet[i] = new Body();
      bullet[i].setName("bullet"+i);
      bullet[i].setsize(10,10);
      bullet[i].setAvatar("basiclaser.png");
      bullet[i].setwrap(true);
      bullet[i].sethealth(1);
      bullet[i].mapx = width;
      bullet[i].mapy = height;
      bullet[i].setpos(ship.x, ship.y);
      bullet[i].setspeed(4 * ship.vx, 4 * ship.vy);
      bullet[i].setmass(1);
      bullet[i].setshape("circle");
      bullet[i].setvmax(50);
      bullet[i].bullet = true;
     
}
     
}

