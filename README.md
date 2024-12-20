# Minecraft Clone - Multiplayer Version

A simple Minecraft-like clone built using Processing, now enhanced with multiplayer functionality via WebSockets.  

If you'd like to try the single-player version, check it out [here](https://github.com/IslamAbukoush/3D_minecraft_clone_processing_singleplayer).

![in game screenshot](https://github.com/IslamAbukoush/3D_minecraft_clone_processing_singleplayer/blob/main/screenshot.png?raw=true)

---

## 🛠 How to Run

### 1. Set Up the Node.js Server
- Clone and set up the server from the [Node.js WebSocket Server repository](https://github.com/IslamAbukoush/nodeJS_websocket).
- Follow the instructions provided there to get it running.

### 2. Configure the Game Sketch
- Have the [Processing IDE](https://processing.org/download/) downloaded.
- Open any `.pde` sketch and locate the IP address configuration.  
- Replace the current IP with:
  - **Localhost**: `ws://localhost:3000/craft`
  - **LAN Multiplayer**: Obtain the IPv4 address of the host machine:
    - Run `ipconfig` (Windows) or an equivalent command on your OS.
    - Use the IPv4 address of the host as the WebSocket server address.
    - In the sketch (blocksWS.pde) paste the IPv4 address in the following format: `ws://[IPv4 HERE]:3000/craft`, e.g. `ws://192.168.0.1:3000/craft`.

### 3. Install Required Libraries
You might need to install some libraries for the sketch to work, such as the `websockets` library.

To install a library:
1. Open Processing.
2. Navigate to **Sketch** -> **Import Library...** -> **Manage Libraries...**.
3. Search for the required library (e.g., `websockets`) and click **Install**.

### 4. Gameplay
**Controls**
   - **W/A/S/D**: Move around.
   - **Mouse**: Look around.
   - **Right Click**: Place a block.
   - **Left Click**: Remove a block.
   - **Space**: Jump/fly upwards.
   - **Double Jump**: Toggle fly.
   - **Shift**: sprint/fly downwards.
   - **Ctrl**: sprint (not recommended because going forward with "W" and pressing "Ctrl" will close the sketch.
   - **Mouse Wheel/Numbers 1-9**: Change blocks in item bar.
   - **Middle Click**: Equip the block the player's currently looking at.
