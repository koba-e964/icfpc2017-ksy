public class Site{
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
  public Site clone(Site s){
    Site cloned_site = new Site(s.id, s.isMine, s.posX, s.posY);
    return cloned_site;
  }
}