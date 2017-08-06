public class Visualizer{
  Map G;
  int cur;
  int moves[][];//{id, source, target}
  
  public Visualizer(Site[] sites, int[][] rivers, int[][] moves){
    this.G = new Map(sites, rivers);
    this.cur = 0;
    this.moves = new int[moves.length][];
    for(int i = 0; i < moves.length; i++){
      this.moves[i] = new int[3];
      System.arraycopy(moves[i], 0, this.moves[i], 0, 3);
      println(moves[i][0], moves[i][1], moves[i][2]);
    }
  }
  
  public void finalResult(){
    for(int i = 0; i < moves.length; i++){
      if(moves[i][0] != -1){
        int id = G.findRiver(moves[i][1], moves[i][2]);
        println("id: ", id);
        G.setOwner(id, moves[i][0]);
      }
    }
  }

  public void drawMap(){
    this.G.drawRivers();
    this.G.drawSites();
  }
}