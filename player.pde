
class Player {
  //player
  PVector position;
  PVector size;
  int inv = 0;
  PImage skin;
  float walk = 5;
  float sprint = 10;
  float speed = walk;
  
  boolean flying = true;
  float verticalVelocity = 0;
  float gravity = 1;
  float jumpPower = 12;
  boolean canJump = false;
  float groundLevel = 0;
  boolean isGrounded = false;
  boolean isCeiled = false;
  boolean isWalking = false;

  //camera
  int renderDistance = 100000;
  PVector targetPosition;
  PVector cameraPosition;
  float pitch = 0;
  float yaw = 0;
  float sensitivity = 0.6;
  float targetYaw = 0;
  float targetPitch = 0;
  float lerpFactor = 0.6;
  int oldX = width/2;
  int oldY = height/2;
  int olderX = oldX;
  int olderY = oldY;
  boolean changed = false;
  Robot robot;
  
  //hand
  float time = 0;
  PImage handTop;
  PImage handRight;
  
  //server
  int lastSendTime = 0;
  int threshold = 150;
  
  Player() {
    size = new PVector(25,80,25);
    position = new PVector(n * blockSize / 2,-1000,n * blockSize / 2);
    skin = loadImage("steve.png");
    targetPosition = new PVector();
    cameraPosition = new PVector(position.x, position.y, position.z);
    handTop = skin.get(48, 20, 51, 31);
    handRight = skin.get(52, 20, 55, 31);
  }
  
  void setupCamera() {
    float fov = PI/2;
    float cameraZ = (height/2.0) / tan(fov/2.0);
    float nearClippingDistance = 0.01;
    perspective(fov, float(width)/float(height), nearClippingDistance, cameraZ*10.0);
  }
  
  void drawCamera() {
    walk = delta/4;
    sprint = walk*2;
    gravity = (float)delta/23;
    boolean outOfBounds = mouseX < width/4 || mouseX > 3*width/4 || mouseY < height/4 || mouseY > 3*height/4;
    float dx, dy;
    if(oldX == width/2 && oldY == height/2 && outOfBounds) {
      dx = mouseX - olderX;
      dy = mouseY - olderY;
    } else {
      dx = mouseX - oldX;
      dy = mouseY - oldY;
    }
    oldX = mouseX;
    oldY = mouseY;
    float oldTargetYaw = targetYaw;
    targetYaw += dx * sensitivity * 0.01;
    targetPitch -= dy * sensitivity * 0.01;

    targetPitch = constrain(targetPitch, -PI / 2 + 0.01, PI / 2 - 0.01);

    yaw = lerp(yaw, targetYaw, lerpFactor);
    pitch = lerp(pitch, targetPitch, lerpFactor);

    if(outOfBounds) {
      try {
          if (robot == null) robot = new Robot();
          int[] windowPos = getWindowPosition();
          robot.mouseMove(windowPos[0] + width / 2, windowPos[1] + height / 2);
          if(oldX != width/2) olderX = oldX;
          if(oldY != height/2) olderY = oldY;
          oldX = width/2;
          oldY = height/2;
      } catch (AWTException e) {
          e.printStackTrace();
      }
    }

    float forwardX = cos(yaw) * cos(pitch);
    float forwardY = -sin(pitch);
    float forwardZ = sin(yaw) * cos(pitch);

    float rightX = cos(yaw - HALF_PI);
    float rightZ = sin(yaw - HALF_PI);
    float sumX = 0;
    float sumY = 0;
    float sumZ = 0;
      if (wPressed) {
          sumX += cos(yaw) * speed;
          sumZ += sin(yaw) * speed;
      }
      if (sPressed) {
          sumX -= cos(yaw) * speed;
          sumZ -= sin(yaw) * speed;
      }
      if (aPressed) {
          sumX += rightX * speed;
          sumZ += rightZ * speed;
      }
      if (dPressed) {
          sumX -= rightX * speed;
          sumZ -= rightZ * speed;
      }
      if(shiftPressed) {
        if(flying) {
          sumY += speed;
        } else {
          speed = sprint;
        }
      }
      if(ctrlPressed) {
        speed = sprint;
      } else if(!shiftPressed) {
        speed = walk;
      }
      if(spacePressed) {
        if(flying) {
          sumY -= speed;
        } else {
          if(canJump) verticalVelocity = -jumpPower;
        }
      }
      float oldX = position.x;
      float oldZ = position.z;
      float oldY = position.y;
      
      position.x += sumX;
      if(checkCollision(false)) position.x -= sumX;
      position.y += sumY;
      if(checkCollision(false)) position.y -= sumY;
      position.z += sumZ;
      if(checkCollision(false)) position.z -= sumZ;
      if(!flying) {
        position.y += verticalVelocity;
        if(checkCollision(true)) {
          verticalVelocity = 0;
          if(isGrounded) {position.y =groundLevel-0.01-size.y/2; canJump = true; }
          else if(isCeiled) {position.y =groundLevel+0.01+size.y/2;  verticalVelocity += gravity;}
          else {verticalVelocity += gravity; canJump = false;}
          
        } else {
           verticalVelocity += gravity;
           canJump = false;
        }
      }
      if((oldX != position.x || oldZ != position.z) && (position.y+size.y/2 >= groundLevel-0.02 && position.y+size.y/2 <= groundLevel+0.02)) {
        isWalking = true;
      } else {
        isWalking = false;
      }
    cameraPosition.x = position.x;
    cameraPosition.y = position.y-size.y/2.5;
    cameraPosition.z = position.z;
    // Update camera position and orientation
    targetPosition.x = cameraPosition.x + forwardX;
    targetPosition.y = cameraPosition.y + forwardY;
    targetPosition.z = cameraPosition.z + forwardZ;
    camera(
        cameraPosition.x, cameraPosition.y, cameraPosition.z,                     // Camera position
        targetPosition.x, targetPosition.y, targetPosition.z, // Look target
        0, 1, 0                              // Up direction
    );
    
    int currentSendTime = millis();
    if(currentSendTime - lastSendTime > threshold && (oldX != position.x || oldY != position.y || oldZ != position.z || oldTargetYaw != targetYaw)) { //
      sendPositionMsg();
      lastSendTime = currentSendTime;
    }

  }
  void renderHand() {
    pushMatrix();
    translate(cameraPosition.x, cameraPosition.y, cameraPosition.z);
    
    // Direction calculations
    float dirX = targetPosition.x - cameraPosition.x;
    float dirY = targetPosition.y - cameraPosition.y;
    float dirZ = targetPosition.z - cameraPosition.z;
    
    float magnitude = sqrt(dirX * dirX + dirY * dirY + dirZ * dirZ);
    dirX /= magnitude;
    dirY /= magnitude;
    dirZ /= magnitude;
    
    float yaw = atan2(dirX, dirZ);
    float pitch = asin(-dirY);
    
    rotateY(yaw);
    rotateX(pitch);
    
    // Add animation using sin() for a smooth back-and-forth movement
    float handOffsetZ = sin(time) * 0.5; // Adjust the multiplier for more or less movement
    float handOffsetY = abs(sin(time)) * 0.2; // Add a slight up-and-down bounce
    
    translate(-7, 3.5 + handOffsetY, 8 + handOffsetZ);
    rotateX(PI * 0.3);
    rotateY(-PI * 0.03);
    rotateZ(-PI * 0.05);
    
    // Render the hand
    float scale = 3;
    noStroke();
    ambientLight(50, 50, 50);
    
    beginShape();
    texture(handTop);
    vertex(scale / 2, -scale / 2, scale / 2, 4, 12);
    vertex(scale / 2, -scale / 2, -scale / 2 * 3, 4, 0);
    vertex(-scale / 2, -scale / 2, -scale / 2 * 3, 0, 0);
    vertex(-scale / 2, -scale / 2, scale / 2, 0, 12);
    endShape(CLOSE);
    
    beginShape();
    texture(handRight);
    vertex(scale / 2, -scale / 2, scale / 2, 4, 12);
    vertex(scale / 2, -scale / 2, -scale / 2 * 3, 4, 0);
    vertex(scale / 2, scale / 2, -scale / 2 * 3, 0, 0);
    vertex(scale / 2, scale / 2, scale / 2, 0, 12);
    endShape(CLOSE);
    
    popMatrix();
    if(isWalking) updateAnimation();
    else resetHandAnimation();
  }
  
  // Call this in the draw loop to update the animation
  void updateAnimation() {
    time += (float)speed/20; // Adjust speed of animation
    if (time > TWO_PI) {
      time -= TWO_PI; // Reset time to keep values manageable
    }
  }
  
  void resetHandAnimation() {
    time = lerp(time, 0, 0.1);
  }
  
  void toggleFly() {
    flying = !flying;
    verticalVelocity = 0;
  }
  
  boolean checkCollision(boolean ground) {
    for(Block b : blocks) {
      if(isInside(position, size, b.position, new PVector(blockSize, blockSize, blockSize))) {
        if(ground) {
          float newY = b.position.y;
          if(newY >= position.y) {
            plr.groundLevel = newY-blockSize/2;
            isGrounded = true;
            isCeiled = false;
          } else {
            plr.groundLevel = newY+blockSize/2;
            isGrounded = false;
            isCeiled = true;
          }
        }
        return true;
      }
    }
    return false;
  }
  
  void sendPositionMsg() {
    JSONObject message = new JSONObject();
      message.setString("action", "move");
      message.setFloat("x", position.x);
      message.setFloat("y", position.y);
      message.setFloat("z", position.z);
      message.setFloat("r", targetYaw);
      wsc.sendMessage(message.toString());
  }
}
