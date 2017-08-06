class Map {
  int[][] rivers;
  Site[] map;
  
  Map(Site[] sites){
    int n = sites.length;
    rivers = new int[n][];
    map = new Site[n];
    for(int i = 0; i < n; i++){
      rivers[i] = new int[2];
      map[i] = sites[i].clone();
    }
  }
}