/* EarthDefender
   Processing Version
   Written by Greg Jeckell 2013
     Adapted from Java originally written by Greg Jeckell & Yervant Bastikian 2012
*/
//Game running handlers
int level = 0;
int leveler = 0;
PFont f;
Stats gameStats;
PImage imgPaused;
PImage imgGameOver;

//Ship and ammo
Player spaceShip;
Ammo[] bullets;
final int BULLET_TOTAL = 20;
int bulletCount;

//Asteroids
Asteroid[] asteroids;
final int ASTEROIDS_TOTAL = 50;

//Eath and stars
Earth earth;
Stars[] stars;
final int STARS_TOTAL = 500;

void setup() {
  size(460, 680);
  background(0);
  f = createFont("Arial",11,true);
  imgPaused = loadImage("EarthDefender.png");
  imgGameOver = loadImage("GameOver.png");
  
  //Create EarthDefender stats
  gameStats = new Stats();
  
  //Create ship and ammo
  spaceShip = new Player(width/2, height/2);
  bullets = new Ammo[BULLET_TOTAL];
  for(int i=0; i < bullets.length; i++) {
    bullets[i] = new Ammo(-400, 0, 4, 120);
    bulletCount++;
  }
  
  //Create asteroids
  asteroids = new Asteroid[ASTEROIDS_TOTAL];
  for(int i=0; i < asteroids.length; i++) {
    asteroids[i] = new Asteroid(25+i*3);
  }
  
  //Create the Earth and background stars.
  earth = new Earth();
  stars = new Stars[STARS_TOTAL];
  for(int i=0; i < stars.length; i++) {
    stars[i] = new Stars();
  }
  
  //Start game
  level = 1;
  gameStats.asteroidCount = 5;
  gameStats.isPaused = true;
  spawn(gameStats.asteroidCount, asteroids);
}

void draw() {
  background(0);
  
  //Handle levels and spawn new asteroids
  if(gameStats.asteroidCount <= 0) {
    leveler++;
    if(leveler%150 == 0) {
      level++;
      leveler = 0;
      gameStats.asteroidCount = 5 + 2 * level;
      spawn(gameStats.asteroidCount, asteroids);
    }
  }
  
  //Draw and update stars
  for(int i=0; i < stars.length; i++) {
    stars[i].update();
    stars[i].draw();
  }
  
  //Draw and update ship and ammo
  spaceShip.update(gameStats, earth);
  spaceShip.draw();
  for(int i=0; i < bullets.length; i++) {
    bullets[i].update(gameStats, asteroids);
    bullets[i].draw();
  }
  
  //Draw and update asteroids
  for(int i=0; i < asteroids.length; i++) {
    asteroids[i].update(gameStats, spaceShip);
    asteroids[i].draw();
  }
  
  //Draw and update Earth
  earth.update(gameStats, asteroids);
  earth.draw();
  
  //Update scores and lives
  fill(255);
  textAlign(LEFT);
  text("Lives: " + spaceShip.lives, 20, 40);
  text("Score: " + gameStats.score, 20, 55);
  text("Asteroid Count: " + gameStats.asteroidCount, 20, 70);
  text("Level: " + level, 20, 85);
  
  //Handle pause and game over images
  imageMode(CENTER);
  if(gameStats.isPaused && gameStats.gameOver != true) {
    image(imgPaused, width/2, height/2-70);
    textAlign(CENTER);
    text("Press P to play.\n W=up A=left S=down D=right mouseClick=fire", width/2, height/2-30);
  }
    
  if(gameStats.gameOver == true)
    image(imgGameOver, width/2, height/2-70);
}

void spawn(int numAsteroids, Asteroid[] a) {
  for(int i=0; i < numAsteroids; i++) {
    int randX = int(random(width));
    int randY = -1 * int(random(150));
    a[i].active = true;
    a[i].currentHealth = a[i].totalHealth;
    a[i].pX = randX;
    a[i].pY = randY;
    a[i].vY = randY %6;
    a[i].vX = (randX%2)*pow(-1, randX);
  }
}

public void resumeGame() { gameStats.isPaused = false; }
    
public void pauseGame() { gameStats.isPaused = true; }

public void stopGame() { gameStats.running = false; }

void keyPressed() {
    switch(keyCode) {
        case 65 : spaceShip.left = true;
            break;
        case 68 : spaceShip.right = true;
            break;
        case 87 : spaceShip.up = true;
            break;
        case 83 : spaceShip.down = true;
            break;
        case 80 : 
            if(gameStats.isPaused == false)
                pauseGame();
            else resumeGame();
            break;
    }
}

void keyReleased() {
    switch(keyCode) {
        case 65 : spaceShip.left = false;
            break;
        case 68 : spaceShip.right = false;
            break;
        case 87 : spaceShip.up = false;
            break;
        case 83 : spaceShip.down = false;
            break;
    }
}

void mousePressed() { 
    if(bulletCount > 0) {
        int x = mouseX;
        int y = mouseY;
        int curX = spaceShip.pX;
        int curY = spaceShip.pY;
        bullets[bulletCount-1].fire(curX, curY, x, y);
        bulletCount--; 
    }
    if(bulletCount == 0) {
        bulletCount = BULLET_TOTAL;
    }
}

class Stats {
  boolean running = false;
  boolean isPaused = false;
  boolean gameOver = false;
  int score = 0;
  int asteroidCount;
  
  void decrementAsteroidCount() { asteroidCount -= 1; }
  
  public void gameOver() {
    gameOver = true;
    isPaused = true;
  }
}
