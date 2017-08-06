public class Visualizer{
  Map G;
  
  public Visualizer(Map G){
    this.G = G;
  }
  
  public void drawMap(){
    this.G.drawRivers();
    this.G.drawSites();
  }
}