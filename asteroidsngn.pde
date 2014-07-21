///////////////////////////////////////////////////
///// Building my Engine for Asteroids ////////////
///// Built by Charles J. Mizikar IV //////////////
///// Use free with acknowledgment ////////////////
///////////////////////////////////////////////////

//setup the map
public class Map {
  //Map has Size
  public int width;
  public int height;
  
  public Map(int w, int h){
    width = w;
    height = h;
  }
}

//A basic body in space
public class Body{
  //Has boundary
  public int mapx;
  public int mapy;
  
  //wraps map or bounces
  boolean wrap;
  
  //Body has size
  public int width;
  public int height;
  
  //Body has avatar
  PImage avatar;
  
  //Body has name
  String name;
  
  //Body has position
  public float x;
  public float y;
  
  //Body has Speed
  public float vx;
  public float vy;
  public float vmax = 4;
  
  //Has angle
  public float angle;
  
  //Body has mass
  public float mass;
  
  //Force applied
  public float fx;
  public float fy;
  
  //health
  public int health;
  
  //Player Character?
  boolean player;
  
  //Bullet?
  boolean bullet;
  
  //Body has shape
  public String shape;
  
  //Set Constructors
  public Body(){
    player = false;
    wrap = true;
  }
  
  public Body(boolean initplayer){
    player = initplayer;
    wrap = true;
  }
  
  public void setAvatar(String navatar){
    avatar = loadImage(navatar);
  }
  
  public void setName(String initname){
    name = initname;
  }
  
  public void sethealth(int nhealth){
    health = nhealth;
  }
  
  public void setsize(int w,int h){
    width = w;
    height = h;
  }
  
  public void setwrap(boolean newWrap){
    wrap = newWrap;
  }
  
  public void setpos(float newX, float newY){
    x = newX;
    y = newY;
  }
  
  public void setspeed(float newVX, float newVY){
    vx = newVX;
    vy = newVY;
  }
  
  public void changespeed(float accelX, float accelY){
    vx += accelX;
    vy += accelY;
  }
  
  public void setvmax(float nvmax){
    vmax = nvmax;
  }
  
  public void setmass(float newMass){
    mass = newMass;
  }
  
  public void applyforce(float newFx, float newFy){
    fx = newFx;
    fy = newFy;
  }
  
  public void setshape(String newShape){
    shape = newShape;
  }
  
  public void draw(boolean debug){
    if(health > 0){
    imageMode(CENTER);
     
    x += vx;
    y += vy;
    vx += fx/mass;
    if(vx > vmax){
      vx = vmax;
    }
    if(vx < -vmax){
      vx = -vmax;
    }
    vy += fy/mass;
    if(vy > vmax){
      vy = vmax;
    }
    if(vy < -vmax){
      vy = -vmax;
    }
    if(vx != 0){
      angle = atan(vy/vx);
    }
    if(vx == 0 && vy > 0)
    {
      angle = -PI;
    }
    
    if(vx == 0 && vy < 0){
      angle = 0;
    }
    
    if(wrap){
      if((x - width/2) > mapx && vx > 0){
        x = 0 - width/2;
      }
      
      if((x + width/2) < 0 && vx < 0){
        x = mapx + width/2;
      }
    
      if((y - height/2) > mapy && vy > 0){
        y = 0 - height/2;
      }
    
      if((y + height/2) < 0 && vy < 0){
        y = mapy + height/2;
      }
    }
    
    if(!wrap){
      if((x + width/2) > mapx && vx > 0){
        vx = -vx;
      }
      
      if((x - width/2) < 0 && vx < 0){
        vx = -vx;
      }
    
      if((y + height/2) > mapy && vy > 0){
        vy = -vy;
      }
    
      if((y - height/2) < 0 && vy < 0){
        vy = -vy;
      }
    }
    if(!(-PI <= angle || angle <= PI )){
      angle = 0;
    }
    
    if(!(-vmax <= vx || vx <= vmax)){
      vx = 0;
    }
    
    if(!(-vmax <= vy || vy <= vmax)){
      vy = 0;
    }
    
    if(!(0 <= x || x <= mapx)){
      x = mapx/2;
    }
    
    if(!(0 <= y || y <= mapy)){
      x = mapy/2;
    }
    pushMatrix();
    translate(x,y);
    if(vx>0){
      rotate(HALF_PI + angle);
    }
    if(vx<0){
      rotate(-HALF_PI + angle);
    }
    if(vx == 0){
      rotate(angle);
    }
    image(avatar,0,0,width,height);
    popMatrix();
    //}
    fx = 0;
    fy = 0;
  }
    
    //debug
    if(debug){
      text(name, x, y);
      println("Object: " + name);
      println("X: " + x + " Y: " + y);
      println("VX: " + vx + " VY: " + vy);
      println("FX: " + fx + " FY: " + fy);
      println("Angle: " + angle);
      println("Health: " + health);
      println(" \n ");
    }
}
}

int collisiondetect(Body body1, Body body2, int rate, boolean debug){
  rate = rate / 60;
  
  boolean xcol = false;
  boolean ycol = false;
  
  if(
  dist(body1.x, body1.y, body2.x, body2.y) < body1.width ||
  dist(body1.x, body1.y, body2.x, body2.y) < body2.width
  ){
    xcol = true;
  }
  
  if(
  dist(body1.x, body1.y, body2.x, body2.y) < body1.height ||
  dist(body1.x, body1.y, body2.x, body2.y) < body2.height
  ){
    ycol = true;
  }
     
     if(ycol && xcol){
       if(debug){
         if(xcol){
       println("X Collision!: " + body1.name + ";" + body2.name);
         }
         if(ycol){
           println("Y Collision!: " + body1.name + ";" + body2.name);
         }
       }
       collision(body1, body2, rate, xcol, ycol, debug);
       return 1;
     }
  
  else{
    return 0;
  }
}

void collision(Body body1, Body body2, int rate, boolean xcol, boolean ycol, boolean debug){
  
  if(!body1.bullet){
  if(xcol && (
  body1.x < body2.x && body1.vx > 0 && body2.vx < 0 ||
  body2.x < body1.x && body1.vx < 0 && body2.vx > 0 )){
    body1.fx -= body2.vx * body2.mass / rate;
    body2.fx += body1.vx * body1.mass / rate;
    if(debug){
    println("path 1");
    }
  }
  if(xcol && (body1.x < body2.x && body1.vx > 0 && body2.vx > 0 )){
    body1.fx -= .5 * body2.vx * body2.mass / rate;
    if(debug){
    println("path 2");
    }
  }
  
  if(xcol && (body1.x > body2.x && body1.vx > 0 && body2.vx > 0)){
    body2.fx -= .5 * body1.vx * body1.mass / rate;
    if(debug){
      println("path 3");
    }
  }
  
  if(xcol && (body1.x < body2.x && body1.vx < 0 && body2.vx < 0 )){
    body2.fx += .5 * body1.vx * body1.mass / rate;
    if(debug){
      println("path 4");
    }
  }
  
  if(xcol && (body1.x > body2.x && body1.vx < 0 && body2.vx < 0)){
    body1.fx -= .5 * body2.vx * body2.mass / rate;
    if(debug){
      println("path 5");
    }
  }
  
  if(ycol && (
  body1.y < body2.y && body1.vy > 0 && body2.vy < 0 ||  
  body2.y < body1.y && body1.vy < 0 && body2.vy > 0)){
    body1.fy -= body2.vy * body2.mass / rate;
    body2.fy += body1.vy * body1.mass / rate;
    if(debug){
      println("path 6");
    }
  }
  }
  
  if(ycol && (body1.y > body1.y && body1.vy > 0 && body2.vy > 0)){
    body1.fy += 0.5 * body2.vy * body2.mass / rate;
    if(debug){
      println("path 7");
    }
  }
  
  if(body1.y < body2.y && body1.vy < 0 && body2.vy < 0){
    body1.fy -= 0.5 * body2.vy * body2.mass / rate;
    if(debug){
      println("path 8");
    }
  }
  
  if(ycol && (body1.y < body2.y && body1.vy > 0 && body2.vy > 0 )){
    body1.fy -= .5 * body2.vy * body2.mass / rate;
    if(debug){
    println("path 9");
    }
  }
    
    if(ycol && (body1.y > body2.y && body1.vy > 0 && body2.vy > 0)){
    body2.fy -= .5 * body1.vy * body1.mass / rate;
    if(debug){
      println("path 10");
    }
    }
    
    if(ycol && (body1.y < body2.y && body1.vy < 0 && body2.vy < 0 )){
    body2.fy += .5 * body1.vy * body1.mass / rate;
    if(debug){
      println("path 11");
    }
    }
      
      if(ycol && (body1.y > body2.y && body1.vy < 0 && body2.vy < 0)){
    body1.fy -= .5 * body2.vy * body2.mass / rate;
    if(debug){
      println("path 5");
    }
    
      }
}

int shoot(int shot, boolean debug){
  shot += 1;
  if(debug){
    println("Shot Fired!" + shot);
  }
  return shot;
}
  

