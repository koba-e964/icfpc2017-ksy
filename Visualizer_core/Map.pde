public class Map {
  int[][] rivers;
  Site[] map;
  ColorPallet c;
  
  public Map(Site[] sites, int[][] rivers){
    int siteN = sites.length;
    int riverN = rivers.length;
    this.map = new Site[siteN];
    for(int i = 0; i < siteN; i++){
      this.map[i] = sites[i].clone();
    }
    for(int i = 0; i < riverN; i++){
      this.rivers[i][0] = rivers[i][0];
      this.rivers[i][1] = rivers[i][1];
    }
  }
  
  int mapSize(){
    return this.map.length;
  }
  
  int riverNum(){
    return this.rivers.length;
  }
  
  public void drawRivers(){
    for(int i = 0; i < this.riverNum(); i++){
      Site source = map[this.rivers[i][0]];
      source.drawPathToSite(map[this.rivers[i][0]]);
    }
  }
  
  public void drawSites(){
    for(int i = 0; i < this.mapSize(); i++){
      this.map[i].drawSite();
    }
  }
}