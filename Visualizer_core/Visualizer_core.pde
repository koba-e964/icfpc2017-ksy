Site s, t, u, v;
Site[] sites;
int[][] rivers;

Map testMap;

void setup(){
  background(255);
  size(640, 480);

  //file load test
  //String lines[];
  //lines = loadStrings("text.txt");
  //for(String val:lines){
  //  println(val);
  //}
  
  //Test section for implemented classes
  s = new Site(0, true, 20.0, 30.0);
  t = new Site(1, false, 50.0, 100.0);
  u = new Site(2, false, 100.0, 30.0); 
  v = new Site(3, true, 75.0, 80.0);

  sites = new Site[]{s,t,u,v};
  
  rivers = new int[][]{{1,2,-1},{2,3,1},{3,0,2},{0,1,0}};
  
  testMap = new Map(sites, rivers);
}

void draw(){
  testMap.drawRivers();
  testMap.drawSites();
}