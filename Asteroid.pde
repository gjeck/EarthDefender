/* EarthDefender
   Processing Version
   Written by Greg Jeckell 2013
     Adapted from Java originally written by Greg Jeckell & Yervant Bastikian 2012
*/

class Asteroid {
  //Graphics area dimensions
  int radius;
  static final int OORT_CLOUD = 400;
  
  //Health
  float currentHealth, totalHealth;
  boolean active;
  
  //Kinematics
  int pX, pY;
  float vX, vY, aX, aY, mass;
  static final float GRAVITY = 0.03;
  
  //Color properties
  boolean hit;
  color asteroidColor;
  
  Asteroid(int r) {
    pX = width/2;
    pY = height+200;
    vX = 0;
    vY = 0;
    aX = 0;
    aY = 0;
    radius = r;
    mass = r*10;
    currentHealth = totalHealth = mass;
    active = false;
    hit = false;
    
    int rndm = int(random(100));
    asteroidColor = color(rndm+100, rndm+50, rndm);
  }
  
  void destroy() {
    pY = height+200;
    pX = width/2;
    vX = 0;
    vY = 0;
    aX = 0;
    aY = 0;
    currentHealth = totalHealth;
    active = false;
  }
  
  boolean isColliding(Player a) {
    if (dist(pX, pY, a.pX, a.pY) < radius/2 + a.radius/2) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  void update(Stats game, Player p) {
    if(game.isPaused || !active)
      return;
    
    //Handle x boundary.
    if(pX + vX > width + OORT_CLOUD + radius + 1) {
        destroy();
        game.decrementAsteroidCount();
    }
    else if(pX + vX < -500 - radius) {
        destroy();
        game.decrementAsteroidCount();
    }
    else pX += vX + aX;
        
    //Handle y boundary.
    if(pY > height + OORT_CLOUD) {
        destroy();
        game.decrementAsteroidCount();
    }
    else if(pY + vY < -OORT_CLOUD + radius) {
        destroy();
        game.decrementAsteroidCount();
    }
    else {
        vY += GRAVITY;
        pY += vY + aY * GRAVITY;
    }
    
    //Handle collision with Player.
    if(isColliding(p)) {
        if(p.pY < pY) {
          p.vY = -1;
          vY +=0.1;
        }
        else {
          p.vY = 1;
          vY -= 0.1;
        }
        if(p.pX < pX) {
          p.vX = -1;
          vX += 0.1;
        }
        else {
            p.vX = 1;
            vX -=0.1;
        }  
        p.currentHealth -= abs(p.vY + vY * mass);
        currentHealth -= abs(p.vY * p.mass);
    }
    
    //Handle health
    if(currentHealth <= 0) {
        destroy();
        game.decrementAsteroidCount();
    }
  }
  
  void draw() {
    if(!active)
      return;
    
    //Paint asteroid
    fill(asteroidColor);
    stroke(0);
    if(hit) {
      fill(255, 0, 0);
      hit = false;
    }
    ellipseMode(CENTER);
    ellipse(pX, pY, radius, radius);
    
    //Paint health bar
    float redBar = (radius)*(currentHealth/totalHealth);
    fill(255);
    rectMode(CORNER);
    rect(pX-radius/2, pY-radius/2-5, radius, 4);
    fill(255, 0, 0);
    rect(pX-radius/2, pY-radius/2-5, int(redBar), 4);
  }
}
