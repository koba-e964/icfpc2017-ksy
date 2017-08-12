Visualizer v;
StatusOnMouse box;
float centerX = 0.0f, centerY = 0.0f;
float lengthX, lengthY;
float globalScale = 1.0f;

ColorPallet bgColor;

//mouse control
float prevX = 0.0f, prevY = 0.0f;
float draggedX = 0.0f, draggedY = 0.0f;
boolean isReleased = true;
boolean showBox = true;

void setup(){
  background(255);
  size(1280, 720);
  
  bgColor = new ColorPallet();
  JSONLoader loader = new JSONLoader("same.json");

  Site[] sites;
  int[][] rivers;
  int[][] moves;
  int[][] evals;
  int playerNum;
  
  playerNum = loader.playerNumber();
  
  sites = loader.loadSites();
  
  lengthX = loader.maxX - loader.minX;
  lengthY = loader.maxY - loader.minY;

  float scaleX = (width * 0.9f) / lengthX, scaleY = (height * 0.9f) / lengthY;
  
  for(int i = 0; i < sites.length; i++){
    sites[i].posX *= scaleX;
    sites[i].posY *= scaleY;
  }
  
  centerX = (width / 2.0f) - (loader.minX + loader.maxX) * scaleX / 2.0f;
  centerY = (height / 2.0f) - (loader.minY + loader.maxY) * scaleY / 2.0f;
  
  rivers = loader.loadRivers();
  
  for(int n: loader.loadMineArray()){
    sites[n].setMine();
  }
  
  moves = loader.loadMoves();
  evals = loader.loadEvals();
  
  v = new Visualizer(playerNum, sites, rivers, moves, evals);
  box = new StatusOnMouse(playerNum, 16, 5.0f, 5.0f, v);
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      v.initMap();
    } else if(keyCode == DOWN) {
      v.finalResult();
    } else if(keyCode == RIGHT){
      v.moveForward();
    } else if(keyCode == LEFT){
      v.moveBackward();
    }
  } else if(key == '['){
    globalScale *= 1.1f;
  } else if(key == ']'){
    globalScale /= 1.1f;
  } else if(key == 'r'){
    globalScale = 1.0f;
  }
}

void mousePressed(){
  if(mouseButton == LEFT){
    showBox = !showBox;
  }
}

void mouseDragged(){
  if(isReleased){
    isReleased = false;
    prevX = mouseX;
    prevY = mouseY;
  }
  if(mouseX - prevX != 0 || mouseY - prevY != 0){
    draggedX += mouseX - prevX;
    draggedY += mouseY - prevY;
  }
  prevX = mouseX;
  prevY = mouseY;
}

void mouseReleased(){
  isReleased = true;
}

void draw(){
  background(bgColor.bgColor);
  scale(globalScale);
  translate(centerX + draggedX, centerY + draggedY);
  v.drawMap();
  translate(-centerX - draggedX, -centerY - draggedY);
  scale(1.0f / globalScale);

  if(showBox){
    box.drawStatusBox();
  }
}