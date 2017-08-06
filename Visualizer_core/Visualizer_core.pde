void setup(){
  background(255);
  size(640, 480);

  //file load test
  String lines[];
  lines = loadStrings("text.txt");
  for(String val:lines){
    println(val);
  }
}

void draw(){
  if(mousePressed){
    fill(0);
  } else {
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
}