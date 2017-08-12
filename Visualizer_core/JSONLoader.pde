public class JSONLoader{
  JSONObject json;

  JSONObject mapJSON;
  
  JSONArray moveArray;
  JSONArray evalArray;

  int playerNum;

  JSONArray siteArray;
  JSONArray riverArray;
  JSONArray mineArray;
  
  float minX = 100000000.0f, maxX = -100000000.0f, minY = 10000000.0f, maxY = -10000000.0f;

  public JSONLoader(String fileName){
    json = loadJSONObject(fileName);
    mapJSON = this.json.getJSONObject("map");
    
    moveArray = this.json.getJSONArray("moves");
    evalArray = this.json.getJSONArray("evals");
    
    playerNum = this.json.getInt("punters");
    
    siteArray = this.mapJSON.getJSONArray("sites");
    riverArray = this.mapJSON.getJSONArray("rivers");
    mineArray = this.mapJSON.getJSONArray("mines");
  }
  
  public Site[] loadSites(){
    Site[] sites = new Site[this.siteArray.size()];
    
    for(int i = 0; i < siteArray.size(); i++){
      JSONObject siteJSON = siteArray.getJSONObject(i);
      int id = siteJSON.getInt("id");
      float x = siteJSON.getFloat("x");
      float y = siteJSON.getFloat("y");
      sites[i] = new Site(id, false, x, y);
      // calc. boundary of the map
      this.minX = min(this.minX, x);
      this.maxX = max(this.maxX, x);
      this.minY = min(this.minY, y);
      this.maxY = max(this.maxY, y);
    }
    
    return sites;
  }
  
  public int[][] loadRivers(){
    int[][] rivers = new int[riverArray.size()][];
    
    for(int i = 0; i < riverArray.size(); i++){
      JSONObject riverJSON = this.riverArray.getJSONObject(i);
      int source = riverJSON.getInt("source");
      int target = riverJSON.getInt("target");
      rivers[i] = new int[]{source, target, -1};
    }
    return rivers;
  }
  
  public int[] loadMineArray(){
    return this.mineArray.getIntArray();
  }
  
  public int[][] loadMoves(){
    int[][] moves = new int[this.moveArray.size()][];
    
    for(int i = 0; i < this.moveArray.size(); i++){
      if(this.moveArray.getJSONObject(i).hasKey("pass")){
        moves[i] = new int[]{-1,-1,-1};
      } else {
        JSONObject claim = this.moveArray.getJSONObject(i).getJSONObject("claim");
        int id, source, target;
        id = claim.getInt("punter");
        source = claim.getInt("source");
        target = claim.getInt("target");
        moves[i] = new int[]{id, source, target};
      }
    }
    return moves;
  }
  
  public int[][] loadEvals(){
    int[][] evals = new int[this.evalArray.size()][];
    for(int i = 0; i < this.evalArray.size(); i++){
      JSONObject eval = this.evalArray.getJSONObject(i);
      int id, score;
      id = eval.getInt("punter");
      score = eval.getInt("eval");
      evals[i] = new int[]{id, score};
    }
    return evals;
  }
  
  public int playerNumber(){
    return this.playerNum;
  }
}