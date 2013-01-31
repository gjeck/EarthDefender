/* EarthDefender
   Processing Version
   Written by Greg Jeckell 2013
     Adapted from Java originally written by Greg Jeckell & Yervant Bastikian 2012
*/

class Stars {
  int radius;
  int xPos;
  int yPos;
  int re;
  int bl;
  int gr;
  int brightness = 100;
  int brightFactor = 256 - brightness;
  
  Stars() {
    int rndm = int(random(brightFactor));
    radius = rndm%4;
    re = brightness + rndm;
    bl = brightness + rndm;
    gr = brightness + rndm;
    
    xPos = int(random(width - 20));
    yPos = int(random(height - 20));
  }
  
  void update() {
    int rndm = int(random(brightFactor));
    
    //Make stars flicker randomly
    if(radius <=2) {
      if(rndm == 13) {
      re = 0;
      bl = 0;
      gr = 0;
      }
      else {
        re = brightness + rndm;
        bl = brightness + rndm;
        gr = brightness + rndm;
      }
    }
  }
  
  void draw() {
    fill(re, bl, gr);
    noStroke();
    ellipseMode(CENTER);
    ellipse(xPos, yPos, radius, radius);
  }
  
}
