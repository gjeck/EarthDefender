/* EarthDefender
   Processing Version
   Written by Greg Jeckell 2013
     Adapted from Java originally written by Greg Jeckell & Yervant Bastikian 2012
*/

class Player {
  //Graphics area dimensions
  float pWidth;
  float pHeight;
  int radius;
  
  //Key flags
  boolean up, down, left, right;
  
  //Health and lives
  float totalHealth;
  float currentHealth;
  int lives;
  
  //Kinematics
  int pX, pY;
  float vX, vY, aX, aY, mass;
  
  Player(int x, int y) {
    pX = x;
    pY = y;
    vX = 0;
    vY = 0;
    aX = 0;
    aY = 0;
    radius = 10;
    pWidth = radius * 0.8;
    pHeight = radius * 0.8;
    mass = 100;
    totalHealth = 7000;
    currentHealth = totalHealth;
    lives = 3;
        
    up = false;
    down = false;
    right = false;
    left = false;
  }
  
  void moveRight() {
    if(vX+1 < 5)
      vX += 1;
    if(aX+0.5 < 2)
      aX += 0.5;
  }
  
  void moveLeft() {
    if(vX-1 > -5)
      vX -= 1;
    if(aX-0.5 > 2)
      aX -= 0.5;
  }
  
  void moveDown() {
    if(vY+1 < 5)
      vY += 1;
    if(aY+0.5 > 2)
      aY += 0.5;
  }
  
  void moveUp() {
    if(vY-1 > -5)
      vY -= 1;
    if(aY-0.5 > 2)
      aY -= 0.5;
  }
  
  void destroy() {
    lives--;
    currentHealth = totalHealth;
    pX = width / 2;
    pY = height / 2;
    vX = 0;
    vY = 0;
    aX = 0;
    aY = 0;
  }
  
  boolean isColliding(Earth a) {
    if (dist(pX, pY, a.pX, a.pY) < radius/2 + a.radius/2) {
      return true;
    } 
    else {
      return false;
    }
  }
  
  void update(Stats game, Earth e) {
    if(game.isPaused)
      return;
      
    //Update movements
    if(up)
        moveUp();
    if(down)
        moveDown();
    if(left)
        moveLeft();
    if(right)
        moveRight();
        
    //Handle collision with Earth.
    if(isColliding(e)) {
        vY = -vY * 0.5;
        vX = -1;
    }
        
    //Handle x-axis boundary
    if(pX + vX > width + radius + 1) {
        pX = -1 * radius - 1;
    }
    else if(pX + vX < 0 - radius) {
        pX = width + radius + 1;
    }
    else pX += vX + aX;
        
    //Handle y-axis boundary
    if(pY > height - radius - 1) {
        pY = height - radius - 1;
        vY = -vY * 0.5;
    }
    else if(pY + vY < 0 + radius) {
        pY = 0 + radius + 1;
        vY = -vY * 0.5;
    }
    else {
        pY += vY + aY;
    }
    
    //Handle death
    if(currentHealth <= 0)
        destroy();
        
    //Handle game end.
    if(lives <= 0)
        game.gameOver();
  }
  
  void draw() {
    //Paint player
    fill(255, 0, 0);
    stroke(255);
    ellipseMode(CENTER);
    ellipse(pX, pY, radius, radius);
    
    //Paint health bar
    float redBar = 80 * (currentHealth / totalHealth);
    rectMode(CORNER);
    stroke(255);
    fill(255);
    rect(20, 20, 80, 7);
    fill(255, 0, 0);
    rect(20, 20, int(redBar), 7);
    
  }
}
  
  
  
  
