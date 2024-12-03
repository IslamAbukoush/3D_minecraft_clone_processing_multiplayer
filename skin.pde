class Skin {
  PVector position;
  float yaw, pitch;
  float scale;
  float speed = 0;
  
  PImage skin;
  
  PImage headFront;
  PImage headBack;
  PImage headTop;
  PImage headBottom;
  PImage headRight;
  PImage headLeft;
  
  PImage bodyFront;
  PImage bodyBack;
  PImage bodyTop;
  PImage bodyBottom;
  PImage bodyRight;
  PImage bodyLeft;
  
  PImage leftArmFront;
  PImage leftArmBack;
  PImage leftArmTop;
  PImage leftArmBottom;
  PImage leftArmRight;
  PImage leftArmLeft;
  
  PImage rightArmFront;
  PImage rightArmBack;
  PImage rightArmTop;
  PImage rightArmBottom;
  PImage rightArmRight;
  PImage rightArmLeft;
  
  PImage leftLegFront;
  PImage leftLegBack;
  PImage leftLegTop;
  PImage leftLegBottom;
  PImage leftLegRight;
  PImage leftLegLeft;
  
  PImage rightLegFront;
  PImage rightLegBack;
  PImage rightLegTop;
  PImage rightLegBottom;
  PImage rightLegRight;
  PImage rightLegLeft;
  
  Skin(float x, float y, float z, float scale, float yaw, float pitch) {
    position = new PVector(x,y,z);
    this.scale = scale;
    this.yaw = yaw;
    this.pitch = pitch;
    
    //skin
    skin = loadImage("steve.png");
    
    //head
    headTop = skin.get(8,0,16,8);
    headFront = skin.get(8,8,16,16);
    headBottom = skin.get(16,0,24,8);
    headBack = skin.get(24,8,32,16);
    headRight = skin.get(16,8,24,16);
    headLeft = skin.get(0,8,8,16);
    
    //body
    bodyTop = skin.get(20,16,28,20);
    bodyFront = skin.get(20,20,28,32);
    bodyBottom = skin.get(28,16,32,20);
    bodyBack = skin.get(32,20,40,32);
    bodyRight = skin.get(28,20,32,32);
    bodyLeft = skin.get(16,20,20,32);
    
    //left arm
    leftArmTop = skin.get(44,16,48,20);
    leftArmFront = skin.get(44,20,48,32);
    leftArmBottom = skin.get(48,16,52,20);
    leftArmBack = skin.get(52,20,56,32);
    leftArmRight = skin.get(48,20,52,32);
    leftArmLeft = skin.get(40,20,44,32);
    
    //left arm
    rightArmTop = skin.get(36,48,40,52);
    rightArmFront = skin.get(36,52,40,64);
    rightArmBottom = skin.get(40,48,44,52);
    rightArmBack = skin.get(44,52,48,64);
    rightArmRight = skin.get(40,52,44,64);
    rightArmLeft = skin.get(32,52,36,64);
    
    //left leg
    leftLegTop = skin.get(4,16,8,20);
    leftLegFront = skin.get(4,20,8,32);
    leftLegBottom = skin.get(8,16,12,20);
    leftLegBack = skin.get(12,20,16,32);
    leftLegRight = skin.get(8,20,12,32);
    leftLegLeft = skin.get(0,20,4,32);
    
    //right leg
    rightLegTop = skin.get(20,48,24,52);
    rightLegFront = skin.get(20,52,24,64);
    rightLegBottom = skin.get(24,48,28,52);
    rightLegBack = skin.get(28,52,32,64);
    rightLegRight = skin.get(24,52,28,64);
    rightLegLeft = skin.get(16,52,20,64);
  }
  
  float time = 0;
  float dt = 0.1;
  
  void draw() {
    noStroke();
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(HALF_PI-yaw);
    scale(scale);
    
    pushMatrix();
    translate(0, 2*scale, 0);
    rotateX(pitch);
    translate(0, -2*scale, 0);
    drawHead();
    popMatrix();
    
    drawBody();
    
    pushMatrix();
    translate(0, 2*scale, 0);
    rotateX(-time);
    translate(0, -2*scale, 0);
    drawLeftArm();
    popMatrix();
    
    pushMatrix();
    translate(0, 2*scale, 0);
    rotateX(time);
    translate(0, -2*scale, 0);
    drawRightArm();
    popMatrix();
    
    pushMatrix();
    translate(0, 6*scale, 0);
    rotateX(time);
    translate(0, -6*scale, 0);
    drawLeftLeg();
    popMatrix();
    
    pushMatrix();
    translate(0, 6*scale, 0);
    rotateX(-time);
    translate(0, -6*scale, 0);
    drawRightLeg();
    popMatrix();

    popMatrix();
  }
  
  void animate() {
    time += dt;
    if(abs(time) >= HALF_PI/2) dt *= -1;
  }
  
  void idle() {
    time = lerp(time, 0, 0.1);
  }
  
  
  void drawHead() {
    //front
    beginShape();
    texture(headFront);
    vertex(4,4,4, 8,8);
    vertex(-4,4,4, 0,8);
    vertex(-4,-4,4, 0,0);
    vertex(4,-4,4, 8,0);
    endShape(CLOSE);
    //back
    beginShape();
    texture(headBack);
    vertex(4,4,-4, 0,8);
    vertex(-4,4,-4, 8,8);
    vertex(-4,-4,-4, 8,0);
    vertex(4,-4,-4, 0,0);
    endShape(CLOSE);
    //top
    beginShape();
    texture(headTop);
    vertex(-4,-4,4, 0,8);
    vertex(-4,-4,-4, 0,0);
    vertex(4,-4,-4, 8,0);
    vertex(4,-4,4, 8,8);
    endShape(CLOSE);
    //bottom
    beginShape();
    texture(headBottom);
    vertex(-4,4,4, 0,0);
    vertex(-4,4,-4, 8,0);
    vertex(4,4,-4, 8,8);
    vertex(4,4,4, 0,8);
    endShape(CLOSE);
    //right
    beginShape();
    texture(headRight);
    vertex(4,4,4, 0,8);
    vertex(4,-4,4, 0,0);
    vertex(4,-4,-4, 8,0);
    vertex(4,4,-4, 8,8);
    endShape(CLOSE);
    //left
    beginShape();
    texture(headLeft);
    vertex(-4,4,4, 8,8);
    vertex(-4,-4,4, 8,0);
    vertex(-4,-4,-4, 0,0);
    vertex(-4,4,-4, 0,8);
    endShape(CLOSE);
  }
  
  void drawBody() {
    //front
    beginShape();
    texture(bodyFront);
    vertex(4,16, 2, 8,12); 
    vertex(-4,16,2, 0,12);
    vertex(-4,4,2, 0,0); 
    vertex(4,4,2, 8,0);
    endShape(CLOSE);
    //back
    beginShape();
    texture(bodyBack);
    vertex(4,16,-2, 0,12);
    vertex(-4,16,-2, 8,12);
    vertex(-4,4,-2, 8,0);
    vertex(4,4,-2, 0,0);
    endShape(CLOSE);
    //top
    beginShape();
    texture(bodyTop);
    vertex(-4,4,2, 0,4);
    vertex(-4,4,-2, 0,0);
    vertex(4,4,-2, 8,0);
    vertex(4,4,2, 8,4);
    endShape(CLOSE);
    //bottom
    beginShape();
    texture(bodyBottom);
    vertex(-4,16,2, 0,0);
    vertex(-4,16,-2, 8,0);
    vertex(4,16,-2, 8,4);
    vertex(4,16,2, 0,4);
    endShape(CLOSE);
    //right
    beginShape();
    texture(bodyRight);
    vertex(4,16,2, 4,12);
    vertex(4,4,2, 4,0);
    vertex(4,4,-2, 0,0);
    vertex(4,16,-2, 0,12);
    endShape(CLOSE);
    //left
    beginShape();
    texture(bodyLeft);
    vertex(-4,16,2, 4,12);
    vertex(-4,4,2, 4,0);
    vertex(-4,4,-2, 0,0);
    vertex(-4,16,-2, 0,12);
    endShape(CLOSE);
  }
  
  void drawLeftArm() {
    //front
    beginShape();
    texture(leftArmFront);
    vertex(2-6,16, 2, 4,12); 
    vertex(-2-6,16,2, 0,12);
    vertex(-2-6,4,2, 0,0); 
    vertex(2-6,4,2, 4,0);
    endShape(CLOSE);
    //back
    beginShape();
    texture(leftArmBack);
    vertex(2-6,16,-2, 0,12);
    vertex(-2-6,16,-2, 4,12);
    vertex(-2-6,4,-2, 4,0);
    vertex(2-6,4,-2, 0,0);
    endShape(CLOSE);
    //top
    beginShape();
    texture(leftArmTop);
    vertex(-2-6,4,2, 0,4);
    vertex(-2-6,4,-2, 0,0);
    vertex(2-6,4,-2, 4,0);
    vertex(2-6,4,2, 4,4);
    endShape(CLOSE);
    //bottom
    beginShape();
    texture(leftArmBottom);
    vertex(-2-6,16,2, 0,4);
    vertex(-2-6,16,-2, 0,0);
    vertex(2-6,16,-2, 4,0);
    vertex(2-6,16,2, 4,4);
    endShape(CLOSE);
    //right
    beginShape();
    texture(leftArmRight);
    vertex(2-6,16,2, 4,12);
    vertex(2-6,4,2, 4,0);
    vertex(2-6,4,-2, 0,0);
    vertex(2-6,16,-2, 0,12);
    endShape(CLOSE);
    //left
    beginShape();
    texture(leftArmLeft);
    vertex(-2-6,16,2, 4,12);
    vertex(-2-6,4,2, 4,0);
    vertex(-2-6,4,-2, 0,0);
    vertex(-2-6,16,-2, 0,12);
    endShape(CLOSE);
  }
  
  void drawRightArm() {
    //front
    beginShape();
    texture(rightArmFront);
    vertex(2+6,16, 2, 4,12); 
    vertex(-2+6,16,2, 0,12);
    vertex(-2+6,4,2, 0,0); 
    vertex(2+6,4,2, 4,0);
    endShape(CLOSE);
    //back
    beginShape();
    texture(rightArmBack);
    vertex(2+6,16,-2, 0,12);
    vertex(-2+6,16,-2, 4,12);
    vertex(-2+6,4,-2, 4,0);
    vertex(2+6,4,-2, 0,0);
    endShape(CLOSE);
    //top
    beginShape();
    texture(rightArmTop);
    vertex(-2+6,4,2, 0,4);
    vertex(-2+6,4,-2, 0,0);
    vertex(2+6,4,-2, 4,0);
    vertex(2+6,4,2, 4,4);
    endShape(CLOSE);
    //bottom
    beginShape();
    texture(rightArmBottom);
    vertex(-2+6,16,2, 0,4);
    vertex(-2+6,16,-2, 0,0);
    vertex(2+6,16,-2, 4,0);
    vertex(2+6,16,2, 4,4);
    endShape(CLOSE);
    //right
    beginShape();
    texture(rightArmRight);
    vertex(2+6,16,2, 0,12);
    vertex(2+6,4,2, 0,0);
    vertex(2+6,4,-2, 4,0);
    vertex(2+6,16,-2, 4,12);
    endShape(CLOSE);
    //left
    beginShape();
    texture(rightArmLeft);
    vertex(-2+6,16,2, 0,12);
    vertex(-2+6,4,2, 0,0);
    vertex(-2+6,4,-2, 4,0);
    vertex(-2+6,16,-2, 4,12);
    endShape(CLOSE);
  }
  
  void drawLeftLeg() {
    //front
    beginShape();
    texture(leftLegFront);
    vertex(2-2,16+12, 2, 4,12); 
    vertex(-2-2,16+12,2, 0,12);
    vertex(-2-2,4+12,2, 0,0); 
    vertex(2-2,4+12,2, 4,0);
    endShape(CLOSE);
    //back
    beginShape();
    texture(leftLegBack);
    vertex(2-2,16+12,-2, 0,12);
    vertex(-2-2,16+12,-2, 4,12);
    vertex(-2-2,4+12,-2, 4,0);
    vertex(2-2,4+12,-2, 0,0);
    endShape(CLOSE);
    //top
    beginShape();
    texture(leftLegTop);
    vertex(-2-2,4+12,2, 0,4);
    vertex(-2-2,4+12,-2, 0,0);
    vertex(2-2,4+12,-2, 4,0);
    vertex(2-2,4+12,2, 4,4);
    endShape(CLOSE);
    //bottom
    beginShape();
    texture(leftLegBottom);
    vertex(-2-2,16+12,2, 0,4);
    vertex(-2-2,16+12,-2, 0,0);
    vertex(2-2,16+12,-2, 4,0);
    vertex(2-2,16+12,2, 4,4);
    endShape(CLOSE);
    //right
    beginShape();
    texture(leftLegRight);
    vertex(2-2,16+12,2, 4,12);
    vertex(2-2,4+12,2, 4,0);
    vertex(2-2,4+12,-2, 0,0);
    vertex(2-2,16+12,-2, 0,12);
    endShape(CLOSE);
    //left
    beginShape();
    texture(leftLegLeft);
    vertex(-2-2,16+12,2, 4,12);
    vertex(-2-2,4+12,2, 4,0);
    vertex(-2-2,4+12,-2, 0,0);
    vertex(-2-2,16+12,-2, 0,12);
    endShape(CLOSE);
  }
  
  void drawRightLeg() {
    //front
    beginShape();
    texture(rightLegFront);
    vertex(2+2,16+12, 2, 4,12); 
    vertex(-2+2,16+12,2, 0,12);
    vertex(-2+2,4+12,2, 0,0); 
    vertex(2+2,4+12,2, 4,0);
    endShape(CLOSE);
    //back
    beginShape();
    texture(rightLegBack);
    vertex(2+2,16+12,-2, 0,12);
    vertex(-2+2,16+12,-2, 4,12);
    vertex(-2+2,4+12,-2, 4,0);
    vertex(2+2,4+12,-2, 0,0);
    endShape(CLOSE);
    //top
    beginShape();
    texture(rightLegTop);
    vertex(-2+2,4+12,2, 0,4);
    vertex(-2+2,4+12,-2, 0,0);
    vertex(2+2,4+12,-2, 4,0);
    vertex(2+2,4+12,2, 4,4);
    endShape(CLOSE);
    //bottom
    beginShape();
    texture(rightLegBottom);
    vertex(-2+2,16+12,2, 0,4);
    vertex(-2+2,16+12,-2, 0,0);
    vertex(2+2,16+12,-2, 4,0);
    vertex(2+2,16+12,2, 4,4);
    endShape(CLOSE);
    //right
    beginShape();
    texture(rightLegRight);
    vertex(2+2,16+12,2, 0,12);
    vertex(2+2,4+12,2, 0,0);
    vertex(2+2,4+12,-2, 4,0);
    vertex(2+2,16+12,-2, 4,12);
    endShape(CLOSE);
    //left
    beginShape();
    texture(rightLegLeft);
    vertex(-2+2,16+12,2, 0,12);
    vertex(-2+2,4+12,2, 0,0);
    vertex(-2+2,4+12,-2, 4,0);
    vertex(-2+2,16+12,-2, 4,12);
    endShape(CLOSE);
  }
}
