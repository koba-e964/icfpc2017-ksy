Visualizer v;
StatusOnMouse box;
float centerX = 0.0, centerY = 0.0;
float lengthX, lengthY;
float globalScale = 1.0;

//mouse control
float prevX = 0.0, prevY = 0.0;
float draggedX = 0.0, draggedY = 0.0;
boolean isReleased = true;
boolean showBox = true;

void setup(){
  background(255);
  size(1280, 720);

  Site[] sites;
  int[][] rivers;
  int[][] moves;
  int[][] evals;
  int playerNum;
  
  float minX = 100000000.0, maxX = -100000000.0, minY = 10000000.0, maxY = -10000000.0;

  JSONObject gameJSON = loadJSONObject("../log/sample_with_eval.json");

  JSONObject mapJSON = gameJSON.getJSONObject("map");
  JSONArray moveJSON = gameJSON.getJSONArray("moves");
  JSONArray evalJSON = gameJSON.getJSONArray("evals");
  playerNum = 2;//gameJSON.getInt("punters");
  
  JSONArray siteArray = mapJSON.getJSONArray("sites");
  JSONArray riverArray = mapJSON.getJSONArray("rivers");
  JSONArray mineArray = mapJSON.getJSONArray("mines");
  
  sites = new Site[siteArray.size()];
  for(int i = 0; i < siteArray.size(); i++){
    JSONObject siteJSON = siteArray.getJSONObject(i);
    int id = siteJSON.getInt("id");
    float x = siteJSON.getFloat("x");
    float y = siteJSON.getFloat("y");
    sites[i] = new Site(id, false, x, y);
    
    // calc. boundary of the map
    minX = min(minX, x);
    maxX = max(maxX, x);
    minY = min(minY, y);
    maxY = max(maxY, y);
  }
  
  lengthX = maxX - minX;
  lengthY = maxY - minY;

  float scaleX = (width * 0.9) / lengthX, scaleY = (height * 0.9) / lengthY;
  
  for(int i = 0; i < siteArray.size(); i++){
    sites[i].posX *= scaleX;
    sites[i].posY *= scaleY;
  }
  
  centerX = (width / 2) - (minX + maxX) * scaleX / 2;
  centerY = (height / 2) - (minY + maxY) * scaleY / 2;
  
  rivers = new int[riverArray.size()][];
  for(int i = 0; i < riverArray.size(); i++){
    JSONObject riverJSON = riverArray.getJSONObject(i);
    int source = riverJSON.getInt("source");
    int target = riverJSON.getInt("target");
    rivers[i] = new int[]{source, target, -1};
  }
  
  for(int n: mineArray.getIntArray()){
    sites[n].setMine();
  }
  
  moves = new int[moveJSON.size()][];
  for(int i = 0; i < moveJSON.size(); i++){
    if(moveJSON.getJSONObject(i).hasKey("pass")){
      moves[i] = new int[]{-1,-1,-1};
    } else {
      JSONObject claim = moveJSON.getJSONObject(i).getJSONObject("claim");
      int id, source, target;
      id = claim.getInt("punter");
      source = claim.getInt("source");
      target = claim.getInt("target");
      moves[i] = new int[]{id, source, target};
    }
  }
  
  evals = new int[evalJSON.size()][];
  for(int i = 0; i < evalJSON.size(); i++){
    JSONObject eval = evalJSON.getJSONObject(i);
    int id, score;
    id = eval.getInt("punter");
    score = eval.getInt("eval");
    evals[i] = new int[]{id, score};
  }
  
  v = new Visualizer(playerNum, sites, rivers, moves, evals);
  box = new StatusOnMouse(playerNum, 16, 5.0, 5.0, v);
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
    globalScale *= 1.1;
  } else if(key == ']'){
    globalScale /= 1.1;
  } else if(key == 'r'){
    globalScale = 1.0;
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
  background(255);
  scale(globalScale);
  translate(centerX + draggedX, centerY + draggedY);
  v.drawMap();
  translate(-centerX - draggedX, -centerY - draggedY);
  scale(1.0 / globalScale);

  if(showBox){
    box.drawStatusBox();
  }
}