public class Map {
  int[][] rivers; // -1 for unclaimed {source, target, id}
  Site[] map;
  
  public Map(Site[] sites, int[][] rivers){
    int siteN = sites.length;
    int riverN = rivers.length;
    this.map = new Site[siteN];
    for(int i = 0; i < siteN; i++){
      this.map[i] = sites[i].clone();
    }
    
    this.rivers = new int[riverN][];
    for(int i = 0; i < riverN; i++){
      this.rivers[i] = new int[3];
      System.arraycopy(rivers[i], 0, this.rivers[i], 0, 3);
    }
  }
  
  int mapSize(){
    return this.map.length;
  }
  
  int riverNum(){
    return this.rivers.length;
  }
  
  public void drawRivers(int id){
    for(int i = 0; i < this.riverNum(); i++){
      Site source = map[this.rivers[i][0]];
      if(rivers[i][2] >= 0){
        if(i == id){
          source.drawPathToSiteBold(map[this.rivers[i][1]], rivers[i][2]);
        } else {
          source.drawPathToSite(map[this.rivers[i][1]], rivers[i][2]);
        }
      } else {
        source.drawPathToSite(map[this.rivers[i][1]]);
      }
    }
  }
  
  public void drawSites(){
    for(int i = 0; i < this.mapSize(); i++){
      this.map[i].drawSite();
    }
  }
  
  public void setOwner(int riverId, int ownerId){
    this.rivers[riverId][2] = ownerId;
  }
  
  public void resetOwner(int riverId){
    this.rivers[riverId][2] = -1;
  }
  
  public int findRiver(int source, int target){
    for(int i = 0; i < rivers.length; i++){
      if(rivers[i][0] == source && rivers[i][1] == target){
        return i;
      }
    }
    return -1;//failed to find such a river
  }
}