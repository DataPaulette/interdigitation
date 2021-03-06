
class Sensor {

  //characteristics
  int spikeWidth; //The width of the spike (high number ==> blunt spike ==> not many spikes fit, low number ==> pointy spike ==> lots of spikes fit)
  int spikeRatio; //0% ==> the strip has zero spike to it, 100% ==> the strip is all spike
  float pointSize; //the size of the touch point as a unit of center to centre of strips. (1 reaches from center of strip one to centre of strip two, 
  //2 reaches from centre of strip one, completely coveres strip two and reachs centre of strip three)
  // Pressure 0 ==> low pressure, 1 ==> high pressure

  int pressureLevels;
  int xPositions;
  int yPositions;
  int stripNumber;

  //data
  float[][][][] data;               //data - [pressure(2)][strip(7)][x(71)][y(11)]
  //  For example, the third strip at the coordinate (20/5) for high pressure will be at data[1][20][5][2]



  Sensor(String filename) { //constructor

    pressureLevels = 2;
    xPositions = 71;
    yPositions = 11;
    stripNumber = 7;

    String[] proporties = parseFileName(filename); //replace the letters in filename, and split it

    spikeWidth = int(proporties[0]); //assign data properties
    spikeRatio = int(proporties[1]);
    pointSize = int(proporties[2])/100f;

    println("spikeWidth: " +spikeWidth + ", spikeRatio: " + spikeRatio + ", pointSize: " + pointSize); //for debug

    data = parseFile(filename); //parse files as described above
  }


  //////////////////////////////////
  /////////quarying methods/////////
  //////////////////////////////////


  boolean spikeWidthIs(int targetSW) {
    if (targetSW == spikeWidth) {
      return true;
    } else {
      return false;
    }
  }

  boolean spikeRatioIs(int targetSR) {
    if (targetSR == spikeRatio) {
      return true;
    } else {
      return false;
    }
  }

  boolean pointSizeIs(float targetPS) {
    if (targetPS == pointSize) {
      return true;
    } else {
      return false;
    }
  }

  //////////////////////////////////
  ///////visualizing methods////////
  //////////////////////////////////


  void drawStripData(int pressure, int strip, int xScale, int yScale) { // <-- ToDo: Add a Type Parameter
    // draws all data of one strip

    xScale = xScale / xPositions;

    for (int i = 0; i <xPositions-1; i++) {
      //do this at all x positions
      for (int y = 0; y <yPositions; y++) {
        //do this at all y positions
        line(i*xScale, yScale- data[pressure][strip][i][y]*yScale, (i+1)*xScale, yScale - data[pressure][strip][i+1][y]*yScale); //<-- needs to be uncommented for showing only the dots. 
        fill(255);
        ellipse(i*xScale, yScale- data[pressure][strip][i][y]*yScale, 3, 3);
        if (i == xPositions-2) {
          ellipse(70*xScale, yScale- data[pressure][strip][70][y]*yScale, 3, 3); //last dot
        }
      }
      //do this at all x positions
    }
  }

  void drawStripAtY(int pressure, int y, int strip, int xScale, float yScale) { // <-- ToDo: Add a Type Parameter
    //draws all data of one swipe

    xScale = xScale / xPositions;
    for (int i = 0; i <xPositions-1; i++) {

      line(i*xScale, yScale-data[pressure][strip][i][y]*yScale, (i+1)*xScale, yScale-data[pressure][strip][i+1][y]*yScale); //<-- needs to be uncommented for showing only the dots. 
      fill(255);
      ellipse(i*xScale, yScale-data[pressure][strip][i][y]*yScale, 3, 3);
      if (i == xPositions-2) {
        ellipse(70*xScale, yScale-data[pressure][strip][70][y]*yScale, 3, 3); //last dot
        println(data[pressure][strip][70][y]);
      }
      //do this at all x positions
    }
  }

  void drawStripAverage(int pressure, int strip, int xScale, int yScale) {
    //draws the average measures of all swipes for a strip
    xScale = xScale / xPositions;

    float average;
    float nextAverage;
    for (int i = 0; i <xPositions-1; i++) {
      //do this at all x positions
      average = mean(data[pressure][strip][i]);
      nextAverage = mean(data[pressure][strip][i+1]);
      line(i*xScale, yScale-average*yScale, (i+1)*xScale, yScale-nextAverage*yScale);
    }
  }


  void drawStripConfidence(int pressure, int strip, float interval, String type, int xScale, int yScale) {
    //this draws the confidence intervals per location per strip
    //interval: 99% == 2.58 95% == 1.96, 90% = 1.65 68% == 1
    xScale = xScale / xPositions; // get the spacing between all positions on x axis
    //get the average & SD
    float average;
    float deviation;
    float nextAverage;
    float nextDeviation;
    float spacing = 0.5;
    float ci;


    for (int i = 0; i <xPositions; i++) {

      average = mean(data[pressure][strip][i]);
      deviation = standardDeviation(data[pressure][strip][i]);
      ci = confidenceInterval(data[pressure][strip][i], interval);
      print("mean: " + average);
      println(" SD: " + deviation);

      if (type.equals("CURVE")) { //visualize as continuous area
        if (i < xPositions -1) {
          nextAverage = mean(data[pressure][strip][i+1]);
          nextDeviation = standardDeviation(data[pressure][strip][i+1]);
          quad(i*xScale, average*yScale+ci*yScale, 
            (i+1)*xScale, nextAverage*yScale+ci*yScale, 
            (i+1)*xScale, nextAverage*yScale-ci*yScale, 
            i*15, average*yScale-ci*yScale);
        }
      } else if (type.equals("BLOCKS")) { //display as discrete blocks

        quad(i*xScale-xScale/2+spacing, yScale-(average*yScale)+(ci*yScale), 
          i*xScale+xScale/2-spacing, yScale-(average*yScale)+(ci*yScale), 
          i*xScale+xScale/2-spacing, yScale-(average*yScale)-(ci*yScale), 
          i*xScale-xScale/2+spacing, yScale-(average*yScale)-(ci*yScale));
        println(average*yScale-(deviation*interval)*yScale);
        println("deviation: " + deviation);
        println(average);
      } else {
        println("Error, unknown VIZ type for CI");
      }
    }
  }

  void drawStripDelta(int pressure, int strip, int xScale, int yScale) { // draw how much change there is from reading to reading
   xScale = xScale / xPositions; // get the spacing between all positions on x axis
    pushMatrix();
    translate(xScale, yScale);

    float average;
    float nextAverage;
    float delta;
    float nextDelta;
    float sd;
    float nextSd;
    float max = 0;


    for (int i = 0; i <xPositions-1; i++) { //find maximum for normalization
      average = mean(data[pressure][strip][i]);
      nextAverage = mean(data[pressure][strip][i+1]);
      delta = abs(average-nextAverage);
      if (delta > max) {
        max = delta;
      }
    }

    for (int i = 0; i <xPositions-2; i++) { //draw maximum

      average = mean(data[pressure][strip][i]);
      nextAverage = mean(data[pressure][strip][i+1]);
      delta = -abs(average-nextAverage);
      average = mean(data[pressure][strip][i+1]);
      nextAverage = mean(data[pressure][strip][i+2]);
      nextDelta = -abs(average-nextAverage);

      line(i*xScale, (delta/max)*yScale, (i+1)*xScale, (nextDelta/max)*yScale);

      //  sd = -standardDeviation(data[pressure][strip][i]);       //display relative to SD? probably not...
      //  nextSd = -standardDeviation(data[pressure][strip][i+1]);
      //  line(i*15, sd*2, (i+1)*15, nextSd*2);
    }

    for (int i = 0; i <xPositions-2; i++) { //draw area (this should work in a single loop, but I want the color formatting to be outside, so maybe not...

      average = mean(data[pressure][strip][i]);
      nextAverage = mean(data[pressure][strip][i+1]);
      delta = -abs(average-nextAverage);
      average = mean(data[pressure][strip][i+1]);
      nextAverage = mean(data[pressure][strip][i+2]);
      nextDelta = -abs(average-nextAverage);

      noStroke();

      quad(i*xScale, (delta/max)*yScale, (i+1)*xScale, (nextDelta/max)*yScale, (i+1)*xScale, 0, i*xScale, 0);
    }
    popMatrix();
  }


  /*********************THIS NEEDS THINKING***********************/

  void drawStripQuality(int pressure, int strip, float yScale) { 
    pushMatrix();
    translate(0, 1000*yScale);

    float average;
    float nextAverage;
    float delta;
    float nextDelta;
    float sd;
    float nextSd;


    for (int i = 0; i <xPositions-2; i++) {
      stroke(0, 125, 0);
      strokeWeight(2);
      average = mean(data[pressure][strip][i]);
      nextAverage = mean(data[pressure][strip][i+1]);
      delta = -abs(average-nextAverage);
      average = mean(data[pressure][strip][i+1]);
      nextAverage = mean(data[pressure][strip][i+2]);
      nextDelta = -abs(average-nextAverage);
      // line(i*15, delta, (i+1)*15, nextDelta);
      stroke(255, 125, 0);
      sd = -standardDeviation(data[pressure][strip][i]);
      nextSd = -standardDeviation(data[pressure][strip][i+1]);
      //  line(i*15, sd, (i+1)*15, nextSd);
      noStroke();
      if (abs(delta)>abs(sd*1.645)) {
        //   if (abs(delta)>abs(sd*1.96)) {
        quad(i*15, 0, i*15, -1000*yScale, (i)*15+8, -1000*yScale, (i)*15+8, 0);
        println(delta);
      }
    }

    for (int i = xPositions-1; i > 1; i--) {
      stroke(0, 125, 0);
      strokeWeight(2);
      average = mean(data[pressure][strip][i]);
      nextAverage = mean(data[pressure][strip][i-1]);
      delta = -abs(average-nextAverage);
      average = mean(data[pressure][strip][i-1]);
      nextAverage = mean(data[pressure][strip][i-2]);
      nextDelta = -abs(average-nextAverage);
      // line(i*15, delta, (i+1)*15, nextDelta);
      stroke(255, 125, 0);
      sd = -standardDeviation(data[pressure][strip][i]);
      nextSd = -standardDeviation(data[pressure][strip][i-1]);
      //  line(i*15, sd, (i+1)*15, nextSd);
      noStroke();
      if (abs(delta)>abs(sd*1.645)) {
        //   if (abs(delta)>abs(sd*1.96)) {
        quad(i*15, 0, i*15, -1000*yScale, (i)*15-7, -1000*yScale, (i)*15-7, 0);
        println(delta);
      }
    }




    popMatrix();
  }

  //////////////////////////////////
  ///////Calculation methods////////
  //////////////////////////////////









  //maybe these should not be used









  //don't use, remove these eventually










  //mean
  float[] getStripAverages(int pressure, int strip) {
    float[] averages = new float [xPositions];
    for (int i = 0; i <xPositions; i++) {
      //do this at all x positions
      for (int y = 0; y <yPositions; y++) {
        //do this at all y positions
        //   averages[i] = averages[i] + data[pressure][i][y][strip];
      }
      averages[i] = averages[i]/yPositions;
      //do this at all x positions
    }
    return averages;
  }

  //standard deviation
  float[] getStandardDeviations(int pressure, int strip) {
    float[] averages = getStripAverages(pressure, strip);
    float[] totals = new float[averages.length];  
    float[] variances = new float[averages.length];  
    float[] sds = new float[averages.length];  

    for (int i = 0; i <xPositions; i++) {
      //do this at all x positions
      for (int y = 0; y <yPositions; y++) {
        //do this at all y positions
        //     totals[i] = totals[i] + sq(data[pressure][i][y][strip]-averages[i]);
      }
    }

    for (int i = 0; i <xPositions; i++) {
      variances[i] = totals[i] / yPositions;
      sds[i] = sqrt(variances[i]);
    }
    return sds;
  }
}