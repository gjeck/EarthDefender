/* EarthDefender
   Processing Version
   Written by Greg Jeckell 2013
     Adapted from Java originally written by Greg Jeckell & Yervant Bastikian 2012
*/

class Earth {
  int radius, pX, pY;
  float currentHealth, totalHealth;
  
  Earth() {
    radius = width + 150;
    pX = width/2;
    pY = height+220;
    currentHealth = totalHealth = 60000;
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
    //Handle asteroids collision.
    for(int i=0; i < a.length; i++) {
        if(isColliding(a[i]) && a[i].active) {
            currentHealth -= a[i].vY * a[i].mass;
            a[i].currentHealth = 0;
        }
    }
    
    //Handle death
    if(currentHealth <= 0) {
      game.gameOver();
    }
  }
  
  void draw() {
    //Paint earth
    fill(0, 0, 255);
    stroke(255);
    ellipseMode(CENTER);
    ellipse(pX, pY, radius, radius);
    
    //Paint health bar
    float redBar = 200 * (currentHealth / totalHealth);
    fill(255);
    rectMode(CORNER);
    rect(width/2-100, height-20, 200, 5);
    fill(255, 0, 0);
    rect(width/2-100, height-20, int(redBar), 5);
  }
}
    
  
  
