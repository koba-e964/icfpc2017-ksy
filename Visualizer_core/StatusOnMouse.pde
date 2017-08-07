public class StatusOnMouse {
  float merginX;
  float merginY;
  int tSize;
  int playerNum;
  int maxTextLength = 6;
  Visualizer v;
  float dx = 10.0;
  float dy = 20.0;
  
  public StatusOnMouse(int playerNum, int tSize, float merginX, float merginY, Visualizer v){
    this.playerNum = playerNum;
    this.tSize = tSize;
    this.merginX = merginX;
    this.merginY = merginY;
    this.v = v; //shallow copy
  }
  
  private int maxTextLength(){
    this.maxTextLength = 5 + String.valueOf(this.v.currentTurn()).length();
    for(int i = 0; i < this.playerNum; i++){
      int evalTextLength = 2 + String.valueOf(this.v.evals[this.v.cur][i]).length();
      this.maxTextLength = max(this.maxTextLength, evalTextLength);
    }
    return this.maxTextLength;
  }

  public void drawStatusBox(){
    float lengthX = this.tSize * (this.maxTextLength * 3.0 / 5.0) + this.merginX * 2;
    float lengthY = this.tSize * (this.playerNum + 1) + this.merginY * 2;

    this.maxTextLength = maxTextLength();
    fill(255);
    strokeWeight(1);
    stroke(0);
    rect(mouseX+dx, mouseY+dy, lengthX, lengthY); // mouse+10, mouseY+20 are magic numbers
  
    fill(0);
    textSize(this.tSize);
    textAlign(CENTER);
    text("Turn:" + this.v.currentTurn(), mouseX+dx+lengthX/2, mouseY+dy+this.merginY+this.tSize);
    
    for(int i = 0; i < this.playerNum; i++){
      text("" + i + ":" + this.v.evals[this.v.cur][i], mouseX+dx+lengthX/2, mouseY+dy+this.merginY+(i+1)*this.tSize+this.tSize);
    }
  }
}