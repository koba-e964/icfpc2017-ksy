public class Visualizer{
  Map G;
  int moves[][]; //moves[curren move][{id, source, target}]
  int cur;
  int last;
  int curRiverId;
  int prevRiverId;
  int evals[][]; //evals[current move][player1 eval, player2 eval, ...]
  
  public Visualizer(int players, Site[] sites, int[][] rivers, int[][] moves, int[][] evals){
    //evals[current move][{id, eval}]
    this.G = new Map(sites, rivers);
    this.cur = 0;
    this.curRiverId = 0;
    this.moves = new int[moves.length][];
    this.last = this.moves.length;
    for(int i = 0; i < moves.length; i++){
      this.moves[i] = new int[3];
      System.arraycopy(moves[i], 0, this.moves[i], 0, 3);
    }
    
    this.evals = new int[evals.length+1][];
    this.evals[0] = new int[players];
    for(int i = 0; i < players; i++){
      this.evals[0][i] = 0;
    }
    for(int i = 0; i < evals.length; i++){
      this.evals[i+1] = new int[players];
      for(int j = 0; j < players; j++){
        if(j == evals[i][0]){
          this.evals[i+1][j] = evals[i][1];
        } else {
          this.evals[i+1][j] = this.evals[i][j];
        }
      }
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