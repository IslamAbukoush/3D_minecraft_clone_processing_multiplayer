class OtherPlayer {
  int id;
  PVector position;      // Current position (rendered)
  float r;               // Current rotation (rendered)
  PVector targetPosition; // The position received from the server
  float targetR;         // Target rotation received from the server
  PVector size;
  Skin avatar;
  float lerpSpeed = 0.13; // Adjust this for smoother/slower interpolation
  
  OtherPlayer(int id, float x, float y, float z, float r) {
    this.id = id;
    this.position = new PVector(x, y, z);
    this.targetPosition = new PVector(x, y, z);
    this.r = r;
    this.targetR = r;
    this.size = new PVector(25, 80, 25);
    avatar = new Skin(x, y, z, 2.5, r);
  }
  
  void updatePosition(float x, float y, float z, float r) {
    targetPosition.set(x, y, z); // Update target position based on server data
    targetR = r;
  }

  void update() {
    // Smoothly move current position and rotation towards targets
    position.lerp(targetPosition, lerpSpeed);
    r = lerp(r, targetR, lerpSpeed); // Smoothly interpolate rotation
  }

  void draw() {
    update(); // Ensure the position and rotation are updated before drawing
    avatar.position.x = position.x;
    avatar.position.y = position.y - size.y / 3;
    avatar.position.z = position.z;
    avatar.rotation = r; // Assuming Skin supports a rotation property
    avatar.draw();
  }
}
