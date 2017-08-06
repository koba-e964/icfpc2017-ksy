public class Site implements Cloneable{
  int id;
  boolean isMine;
  float posX;
  float posY;
  
  Site(int id, boolean isMine, float posX, float posY){
    this.id = id;
    this.isMine = isMine;
    this.posX = posX;
    this.posY = posY;
  }
  
  @Override
  public Site clone(){
    Site cloned_site;
    try {
      cloned_site = (Site)super.clone();
    } catch (CloneNotSupportedException e){
      throw new RuntimeException();
    }
    return cloned_site;
  }
  
  public void drawSite(){
    float r;
    if(this.isMine){
      fill(255);
      r = 20.0;
    } else {
      //debug this so that it shows the circle red
      fill(100, 100, 100);
      r = 5.0;
    }
    ellipse(this.posX, this.posY, r, r);
  }
  
  public void drawPathToSite(Site t){
    line(this.posX, this.posY, t.posX, t.posY);
  }
}