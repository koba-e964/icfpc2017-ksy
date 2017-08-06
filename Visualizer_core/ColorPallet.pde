public class ColorPallet{
  /* this class defines color for each player up to 16 */
  int[] colors;
  ColorPallet() {
    colors = new int[]{
      #FF2121, //red
      #5221DB, //blue
      #20D333, //green
      #FEFF29, //yellow
      #E230FA, //purple
      #4BFAFF, //pale blue
      #B7FF4D, //pale green
      #FAA7D9, //pink
      #FF7C24, //orange
      #17FFAC, //emerald
      #348990, //something blue
      #908C37, //dark yellow
      #396C23, //dark green
      #9B3037, //brown
      #742370, //dark purple
      #CDCCCE, //gray
    };
  }

  public void setColor(int id){
    stroke(colors[id]);
    strokeWeight(3);
  }
}