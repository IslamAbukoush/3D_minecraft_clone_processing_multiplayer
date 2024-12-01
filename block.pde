int ids = 6;
int selectedBlockId = 0;
float[][] facesPos = {{0,blockSize,0}, {0,-blockSize,0}, {blockSize,0,0}, {-blockSize,0,0}, {0,0,-blockSize}, {0,0,blockSize}};
List<PImage[]> textures;

void blocksSetup() {
  String[] paths = {"wood.png", "cobble.png", "stone.png", "brick.png", "wool.png", "log.png", "glass.png", "leaves.png", "grass.png"};
  textures = new ArrayList<PImage[]>();
  for(String path : paths) {
    if(path == "log.png") {
      PImage top = loadImage(path);
      PImage side = loadImage("log_side.png");
      textures.add(new PImage[]{top, top, side, side, side, side});
      continue;
    }
    if(path == "grass.png") {
      PImage top = loadImage(path);
      PImage bottom = loadImage("dirt.png");
      PImage side = loadImage("grass_side.png");
      textures.add(new PImage[]{bottom, top, side, side, side, side});
      continue;
    }
    PImage img = loadImage(path);
    textures.add(new PImage[]{img, img, img, img, img, img});
  }
  blocks = new ArrayList<Block>();
  newBlocks = new ArrayList<Block>();
}

class Block {
  PVector position;
  float size;
  color id;
  List<Integer> colorsId;
  int selectedFace;
  int type;
  PImage[] texture;
  boolean transparent;
  boolean remove = false;
  Block(float x, float y, float z, float size, int tex, int id) {
    position = new PVector(x,y,z);
    this.size = size;
    this.transparent = (tex == 6 || tex == 7);
    if(transparent) this.size-= 0.03;
    this.type = tex;
    this.texture = textures.get(tex);
    this.id = intToColor(id);
    this.colorsId = new ArrayList<Integer>();
    for(int i = 0; i < 6; i++) {
      colorsId.add(intToColor(id+i));
    }
    ids+=6;
  }
  void draw(boolean pick) {
    if (!isInFrustum(plr.cameraPosition, plr.yaw, plr.pitch, 1.5*PI, (float) width / height, plr.renderDistance)) {
        return; // Skip rendering if not in view
    }
    int res = colorToInt(selectedBlockId);
    selectedFace = res%6;
    color selectedId = intToColor(res-selectedFace);
    if(selectedId == this.id && !pick && this.position.dist(plr.cameraPosition) < 250) {
      stroke(0);
      detectClick(this);
    } else {
      noStroke();
    }
    pushMatrix();
    fill(255);
    translate(position.x, position.y, position.z);
    
    // bottom face
    beginShape();
    if(!pick) texture(texture[0]);
    else fill(colorsId.get(0));
    vertex(size/2,size/2,size/2, 0, 0);
    vertex(size/2,size/2,-size/2, 0, 16);
    vertex(-size/2,size/2,-size/2, 16, 16);
    vertex(-size/2,size/2,size/2, 16, 0);
    endShape(CLOSE);
    
    // top face
    beginShape();
    if(!pick) texture(texture[1]);
    else fill(colorsId.get(1));
    vertex(size/2,-size/2,size/2, 0, 0);
    vertex(size/2,-size/2,-size/2, 0, 16);
    vertex(-size/2,-size/2,-size/2, 16, 16);
    vertex(-size/2,-size/2,size/2, 16, 0);
    endShape(CLOSE);
    
    // right face
    beginShape();
    if(!pick) texture(texture[2]);
    else fill(colorsId.get(2));
    vertex(size/2,-size/2,size/2, 16, 0);
    vertex(size/2,-size/2,-size/2, 0, 0);
    vertex(size/2,size/2,-size/2, 0, 16);
    vertex(size/2,size/2,size/2, 16, 16);
    endShape(CLOSE);
    
    // left face
    beginShape();
    if(!pick) texture(texture[3]);
    else fill(colorsId.get(3));
    vertex(-size/2,-size/2,size/2, 16, 0);
    vertex(-size/2,-size/2,-size/2, 0, 0);
    vertex(-size/2,size/2,-size/2, 0, 16);
    vertex(-size/2,size/2,size/2, 16, 16);
    endShape(CLOSE);
    
    // back face
    beginShape();
    if(!pick) texture(texture[4]);
    else fill(colorsId.get(4));
    vertex(size/2,size/2,-size/2, 16, 16);
    vertex(size/2,-size/2,-size/2, 16, 0);
    vertex(-size/2,-size/2,-size/2, 0, 0);
    vertex(-size/2,size/2,-size/2, 0, 16);
    endShape(CLOSE);
    
    
    // front face
    beginShape();
    if(!pick) texture(texture[5]);
    else fill(colorsId.get(5));
    vertex(size/2,size/2,size/2, 16, 16);
    vertex(size/2,-size/2,size/2, 16, 0);
    vertex(-size/2,-size/2,size/2, 0, 0);
    vertex(-size/2,size/2,size/2, 0, 16);
    endShape(CLOSE);
    popMatrix();
  }
  void setSelectedFace(int face) {
    this.selectedFace = face;
  }
  int getSelectedFace() {
    return this.selectedFace;
  }
  
  boolean isInFrustum(PVector cameraPosition, float yaw, float pitch, float fov, float aspectRatio, float renderDistance) {
    // Approximate the camera's view direction
    float forwardX = cos(yaw) * cos(pitch);
    float forwardY = -sin(pitch);
    float forwardZ = sin(yaw) * cos(pitch);

    // Vector from camera to block
    float dx = position.x - cameraPosition.x;
    float dy = position.y - cameraPosition.y;
    float dz = position.z - cameraPosition.z;

    // Distance to the block
    float dist = sqrt(dx * dx + dy * dy + dz * dz);
    if (dist > renderDistance) return false; // Outside render distance

    // Normalize direction vector to block
    dx /= dist;
    dy /= dist;
    dz /= dist;

    // Dot product to check angle with camera's forward vector
    float dot = dx * forwardX + dy * forwardY + dz * forwardZ;
    float angle = acos(dot);

    // Horizontal and vertical FOV bounds
    float verticalFOV = fov / 2;
    float horizontalFOV = verticalFOV * aspectRatio;

    // Check if the block is within the FOV
    return abs(angle) <= horizontalFOV && abs(angle) <= verticalFOV;
  }
}

void placeBlock(float x, float y, float z, int type, int id) {
  Block newBlock = new Block(x, y, z, blockSize, type, id);
  newBlocks.add(newBlock);
}

void sendPlaceMessage(float x, float y, float z, int type) {
  boolean canPlace = !isInside(plr.position, plr.size, new PVector(x,y,z), new PVector(blockSize, blockSize, blockSize));
  if(canPlace) {
    JSONObject message = new JSONObject();
    message.setString("action", "place");
    message.setInt("type", type);
    message.setFloat("x", x);
    message.setFloat("y", y);
    message.setFloat("z", z);
    wsc.sendMessage(message.toString());
  };
}

void sendRemoveMessage(int id) {
  JSONObject message = new JSONObject();
  message.setString("action", "remove");
  message.setInt("id", id);
  wsc.sendMessage(message.toString());
}

void selectBlock() {
  background(0);
  renderBoxes(true);
  selectedBlockId = get(width/2, height/2);
}

void detectClick(Block selected) {
  if(selected  != null) {
     if(rightClicked && (plr.inv < textures.size())) {
      int f = selected.getSelectedFace();
      float x = selected.position.x+facesPos[f][0];
      float y = selected.position.y+facesPos[f][1];
      float z = selected.position.z+facesPos[f][2];
      sendPlaceMessage(x,y,z,plr.inv);
    } else if(clicked) {
      sendRemoveMessage(selected.id);
    } else if(middleClicked) {
      plr.inv = selected.type;
    }
  }
  rightClicked = false;
  middleClicked = false;
  clicked = false;
}

void removeBlock(int id) {
  for(Block b : blocks) {
    if(b.id == id) {
      b.remove = true;
    }
  }
}

void updateBlocks() {
  blocks.removeIf(b -> b.remove);
  blocks.addAll(newBlocks);
  newBlocks.clear();
}
