public class Site implements Cloneable{
  int id;
  boolean isMine;
  float posX;
  float posY;
  ColorPallet pallet;
  
  Site(int id, boolean isMine, float posX, float posY){
    this.id = id;
    this.isMine = isMine;
    this.posX = posX;
    this.posY = posY;
    this.pallet = new ColorPallet();
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
    strokeWeight(1);
    stroke(0);
    if(this.isMine){
      //debug this so that it shows the circle red
      fill(255, 0, 0);
      r = 10.0;
    } else {
      fill(255);
      r = 5.0;
    }
    ellipse(this.posX, this.posY, r, r);
  }
  
  public void drawPathToSite(Site t){
    stroke(0);
    strokeWeight(1);
    line(this.posX, this.posY, t.posX, t.posY);
  }
  
  public void drawPathToSite(Site t, int id){
    pallet.setColor(id);
    line(this.posX, this.posY, t.posX, t.posY);
  }
  
  public void setMine(){
    this.isMine = true;
  }
}