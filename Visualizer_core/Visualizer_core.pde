Site s, t;

void setup(){
  background(255);
  size(640, 480);

  //file load test
  String lines[];
  lines = loadStrings("text.txt");
  for(String val:lines){
    println(val);
  }
  
  //Test section for implemented classes
  s = new Site(1, true, 20.0, 30.0);
  t  =new Site(2, false, 50.0, 100.0);
  //Site c_site;
  //c_site = site.clone();
  
  //println(c_site.posX);
  //println(site.posX);
  //c_site.posX = 10.0;
  //println(c_site.posX);
  //println(site.posX);
}

void draw(){
  s.drawPathToSite(t);
  s.drawSite();
  t.drawSite();
}