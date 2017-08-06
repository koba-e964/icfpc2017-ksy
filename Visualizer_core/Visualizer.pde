public class Visualizer{
  Map G;
  int cur;
  int moves[][];//{id, source, target}
  int last;
  
  public Visualizer(Site[] sites, int[][] rivers, int[][] moves){
    this.G = new Map(sites, rivers);
    this.cur = 0;
    this.moves = new int[moves.length][];
    this.last = this.moves.length;
    for(int i = 0; i < moves.length; i++){
      this.moves[i] = new int[3];
      System.arraycopy(moves[i], 0, this.moves[i], 0, 3);
      println(moves[i][0], moves[i][1], moves[i][2]);
    }
  }
  
  public void initMap(){
    int n = this.G.riverNum();
    for(int i = 0; i < n; i++){
      this.G.resetOwner(i);
    }
    this.cur = 0;
  }
  
  public void finalResult(){
    for(int i = 0; i < this.moves.length; i++){
      if(this.moves[i][0] != -1){
        int id = this.G.findRiver(this.moves[i][1], this.moves[i][2]);
        this.G.setOwner(id, moves[i][0]);
      }
    }
    this.cur = this.last;
  }
  
  public void moveForward(){
    if(this.cur == last){
      return;
    }
    if(this.moves[cur][0] != -1){
      int id = this.G.findRiver(this.moves[this.cur][1], this.moves[this.cur][2]);
      this.G.setOwner(id, moves[cur][0]);
    }
    this.cur++;
  }
  
  public void moveBackward(){
    if(this.cur == 0){
      return;
    }
    this.cur--;
    if(this.moves[this.cur][0] != -1){
      int id = this.G.findRiver(this.moves[this.cur][1], this.moves[this.cur][2]);
      this.G.resetOwner(id);
    }
  }

  public void drawMap(){
    this.G.drawRivers();
    this.G.drawSites();
  }
}