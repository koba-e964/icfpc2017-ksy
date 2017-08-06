Site s, t, u, v;
Site[] sites;
int[][] rivers;
Map testMap;

JSONObject gameMapJSON;

void setup(){
  background(255);
  size(640, 480);

  //Test section for implemented classes
  //s = new Site(0, true, 20.0, 30.0);
  //t = new Site(1, false, 50.0, 100.0);
  //u = new Site(2, false, 100.0, 30.0); 
  //v = new Site(3, true, 75.0, 80.0);

  //sites = new Site[]{s,t,u,v};
  
  //rivers = new int[][]{{1,2,-1},{2,3,1},{3,0,2},{0,1,0}};
    
  gameMapJSON = loadJSONObject("sample.json");
  JSONArray siteArray = gameMapJSON.getJSONArray("sites");
  JSONArray riverArray = gameMapJSON.getJSONArray("rivers");
  JSONArray mineArray = gameMapJSON.getJSONArray("mines");
  
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
    rivers[i] = new int[]{source, target, 2};
  }
  
  for(int n: mineArray.getIntArray()){
    sites[n].setMine();
  }
  testMap = new Map(sites, rivers);
}

void draw(){
  translate(width/2, height/2);
  testMap.drawRivers();
  testMap.drawSites();
}