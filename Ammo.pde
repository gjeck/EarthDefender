/* EarthDefender
   Processing Version
   Written by Greg Jeckell 2013
     Adapted from Java originally written by Greg Jeckell & Yervant Bastikian 2012
*/

class Ammo {
  //Graphics area dimensions
  int radius;
  color ammoColor = color(255, 240, 130);
  
  //Kinematics
  int pX, pY;
  float vX, vY, aX, aY, mass;
  int damage;
  
  Ammo(int x, int y, int r, float m) {
    pX = x;
    pY = y;
    vX = 0;
    vY = 0;
    aX = 0;
    aY = 0;
    radius = r;
    mass = m;
    damage = 100;
  }
  
  void fire(int curX, int curY, int clickX, int clickY) {
    pX = curX;
    pY = curY;
    
    float dx = clickX - curX;
    float dy = clickY - curY;
    double hypotenuse = Math.sqrt(dx*dx + dy*dy);
    if(Math.abs(hypotenuse) > 0) {
       dx /= hypotenuse;
       dy /= hypotenuse; 
    }
    
    vX = dx * 18;
    vY = dy * 18;
  }
  
  boolean isColliding(Asteroid a) {
    if (dist(pX, pY, a.pX, a.pY) < radius/2 + a.radius/2) {
      return true;
    } 
    else {
      return false;
    }
  }

  
  void update(Stats game, Asteroid[] a) {
    if(game.isPaused)
        return;
        
    //Handle asteroid collision
    for(int i=0; i < a.length; i++) {
      if(isColliding(a[i])) {
        a[i].vY += vY * (mass/ a[i].mass);
        a[i].aY += aY * (mass / a[i].mass);
        a[i].vX += vX * (mass / a[i].mass);
        a[i].currentHealth -= damage;
        
        //Reset bullet
        pX = width / 2;
        pY = height + 20;
        vX = 0;
        vY = 0;
        
        //Increase score
        game.score += 20;
        a[i].hit = true;
      }
    }
        
    //Move bullet.
    pX += vX;
    pY += vY;
    
    //Handle Y-boundary.
    if(pY > height)
    {
        //Reset bullet.
        pX = width / 2;
        pY = height + 20;
        vX = 0;
        vY = 0;
    }
  }
  
  void draw() {
    fill(ammoColor);
    noStroke();
    ellipseMode(CENTER);
    ellipse(pX, pY, radius, radius);
  }
}

    
