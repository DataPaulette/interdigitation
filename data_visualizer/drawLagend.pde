
//draws the legend, needs a second version for the deltas

void drawLegend() {
  for (int i = 0; i < 6; i++) {
    strokeWeight(1);
    stroke(180);
    fill(255);
    line(-15, i*200*0.4, 71*15, i*200*0.4);
    ellipse(-15, i*200*0.4, 5, 5);
    fill(120);
    text(1000 - int(i*200), -10, i*200*0.4-4);
  }
  
    for (int i = 1; i < 15; i++) {
    strokeWeight(1);
    stroke(180);
    fill(255);
    line(i*75, 0, i*75, 1000*0.4+15);
    ellipse(i*75, 1000*0.4+15, 5, 5);
    fill(120);
    text(int(i*10)+"mm", i*75+5, 1000*0.4+15);
  }
  
}