class UI {
  PImage skin;
  PImage itembarImg;
  PImage squareImg;
  UI() {
    skin = loadImage("steve.png");
    itembarImg = loadImage("itembar.png");
    squareImg = loadImage("square.png");
  }
  void draw() {
    hint(DISABLE_DEPTH_TEST);
    noTint();
    camera();
    noLights();
    fill(255);
    noStroke();
    rect(width/2,height/2,30,5);
    rect(width/2,height/2,5,30);
    image(itembarImg, width/2, height*1.2, 182*5, 22*5);
    for(int i = 0; i < textures.size(); i++) {
      image(textures.get(i)[0], width/2+i*5*20-4*5*20, height*1.2, 16*5, 16*5);
    }
    image(squareImg, width/2+20*5*plr.inv-4*5*20, height*1.2, 22*5, 22*5);
    hint(ENABLE_DEPTH_TEST);
  }
}
