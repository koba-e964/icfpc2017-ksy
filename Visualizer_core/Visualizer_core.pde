Site[] sites;
int[][] rivers;
int[][] moves;
Visualizer v;

void setup(){
  background(255);
  size(640, 480);
    
  JSONObject gameJSON = loadJSONObject("sample_log.json");

  JSONObject mapJSON = gameJSON.getJSONObject("map");
  JSONArray moveJSON = gameJSON.getJSONArray("moves");
  
  JSONArray siteArray = mapJSON.getJSONArray("sites");
  JSONArray riverArray = mapJSON.getJSONArray("rivers");
  JSONArray mineArray = mapJSON.getJSONArray("mines");
  
  sites = new Site[siteArray.size()];
  for(int i = 0; i < siteArray.size(); i++){
    JSONObject siteJSON = siteArray.getJSONObject(i);
    int id = siteJSON.getInt("id");
    float x = siteJSON.getFloat("x") * 100;
    float y = siteJSON.getFloat("y") * 100;
    sites[i] = new Site(id, false, x, y);
  }
  
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
  v = new Visualizer(sites, rivers, moves);
  v.finalResult();
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      v.initMap();
    } else if(keyCode == DOWN) {
      v.finalResult();
    } else if(keyCode == RIGHT){
      v.moveForward();
      println("right");
    } else if(keyCode == LEFT){
      v.moveBackward();
    }
  }
}

void draw(){
  background(255);
  translate(width/2, height/2);
  v.drawMap();
}