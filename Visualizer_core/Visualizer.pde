public class Visualizer{
  Map G;
  int moves[][];//{id, source, target}
  int cur;
  int last;
  int curRiverId;
  int prevRiverId;
  
  public Visualizer(Site[] sites, int[][] rivers, int[][] moves){
    this.G = new Map(sites, rivers);
    this.cur = 0;
    this.curRiverId = 0;
    this.moves = new int[moves.length][];
    this.last = this.moves.length;
    for(int i = 0; i < moves.length; i++){
      this.moves[i] = new int[3];
      System.arraycopy(moves[i], 0, this.moves[i], 0, 3);
    }
  }
  
  public void initMap(){
    for(int i = this.cur; i > 0; i--){
      this.moveBackward();
    }
  }
  
  public void finalResult(){
    for(int i = cur; i < last; i++){
      this.moveForward();
    }
  }
  
  public void moveForward(){
    if(this.cur == last){
      return;
    }
    if(this.moves[cur][0] != -1){
      this.curRiverId = this.G.findRiver(this.moves[this.cur][1], this.moves[this.cur][2]);
      this.G.setOwner(this.curRiverId, this.moves[cur][0]);
    }
    this.cur++;
  }
  
  public void moveBackward(){
    if(this.cur == 0){
      return;
    }
    this.cur--;
    if(this.moves[this.cur][0] != -1){
      int Id = this.G.findRiver(this.moves[this.cur][1], this.moves[this.cur][2]);
      this.G.resetOwner(Id);
    }
    
    if(cur > 0){
      this.curRiverId = this.G.findRiver(this.moves[this.cur-1][1], this.moves[this.cur-1][2]);
    }
  }

  public void drawMap(){
    this.G.drawRivers(this.curRiverId);
    this.G.drawSites();
  }
  
  public int currentTurn(){
    return this.cur;
  }
}