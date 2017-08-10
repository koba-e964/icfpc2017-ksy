public class ColorPallet{
  /* this class defines color for each player up to 16 */
  int[] colors;
  int bgColor;
  ColorPallet() {
    colors = new int[]{
      0xFF2121, //red
      0x5221DB, //blue
      0x20D333, //green
      0xF5ED00, //yellow
      0xE230FA, //purple
      0x4BFAFF, //pale blue
      0xB7FF4D, //pale green
      0xFAA7D9, //pink
      0xFF7C24, //orange
      0x17FFAC, //emerald
      0x348990, //something blue
      0x908C37, //dark yellow
      0x396C23, //dark green
      0x9B3037, //brown
      0x742370, //dark purple
      0xCDCCCE, //gray
    };
    bgColor = 0xFFF2F2;
  }

  public void setColor(int id){
    stroke(colors[id]);
    strokeWeight(3);
  }
}