class OtherPlayer {
  int id;
  PVector position;
  float yaw, pitch;
  PVector targetPosition;
  float targetYaw, targetPitch;
  PVector size;
  Skin avatar;
  float lerpSpeed = 0.13;
  
  OtherPlayer(int id, float x, float y, float z, float yaw, float pitch) {
    this.id = id;
    this.position = new PVector(x, y, z);
    this.targetPosition = new PVector(x, y, z);
    this.yaw = yaw;
    this.targetYaw = yaw;
    this.pitch = pitch;
    this.targetPitch = pitch;
    this.size = new PVector(25, 80, 25);
    avatar = new Skin(x, y, z, 2.5, yaw, pitch);
  }
  
  void updatePosition(float x, float y, float z, float yaw, float pitch) {
    targetPosition.set(x, y, z);
    targetYaw = yaw;
    targetPitch = pitch;
  }

  void update() {
    position.lerp(targetPosition, lerpSpeed);
    yaw = lerp(yaw, targetYaw, lerpSpeed);
    pitch = lerp(pitch, targetPitch, lerpSpeed);
  }

  void draw() {
    update();
    avatar.position.x = position.x;
    avatar.position.y = position.y - size.y / 3;
    avatar.position.z = position.z;
    avatar.yaw = yaw;
    avatar.pitch = pitch;
    avatar.draw();
  }
}
