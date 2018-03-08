import processing.pdf.*; //for exporting visualizations
import java.io.BufferedWriter; //for logging lines
import java.io.FileWriter; //create files

String[] fileNames = loadFileNames(); //list of all names of data files (in the init_filenames tab)
Sensor[] textileSensors = new Sensor[fileNames.length]; //array of object for storing all the data


void setup() {

  for (int i = 0; i < fileNames.length; i++) { //loop through filename list and create object for each file
    textileSensors[i] = new Sensor(fileNames[i]);
  }


  //methods for checking sensor properties available
  //sensor.spikeWidthIs --> returns width of spike as int
  //sensor.spikeRatioIs --> returns ratio (height) of spike as int
  //sensor.pointSizeIs --> returns touch-point size as float
  //high & low pressure need to be specified by parameters

  //visualization methods available
  //sensor.drawData --> plot all data
  //sensor.drawMean --> plot average
  //sensor.drawConfidence --> plot 95% confidence interval
  //sensor.drawChange --> plot absolute difference difference between measures for consecutive touch positions
  //sensor.drawBaseline --> plot plot


  // general graphics settings
  size(1150, 1000); // for visualizing on screen
  // size(1150, 500, PDF, "Non-Interdigitated-Light-Pressure.pdf"); //for exporting to pdf
  // strokeCap(SQUARE); //this matters when you zoom in, not sure whats best
  background(255); //white background 
  translate(50, 50); //center stuff so it looks nice


  //legend
  fill(120);
  text("Non-Interdigitated Sensor TouchSize: 1.25, Light Pressure", 750, -4); //name of graph
  drawLegend(); //draw the legend (only correct units for measures, needs to be fixed to work with deltas


  //draw some graphs
  for (int i = 0; i < fileNames.length; i++) {            //loop through all the files and grab the data of the ones we want
    if (textileSensors[i].spikeWidthIs(55)) {             //filter according to spikeWidth
      if (textileSensors[i].spikeRatioIs(55)) {          //filter according to ratio
        if (textileSensors[i].pointSizeIs(1.25)) {        //filter according to point szie


          fill(255, 200, 0, 80);

          textileSensors[i].drawStripConfidence(1, 3, 1.98);
          stroke(120, 120);
          textileSensors[i].drawStripData(1, 3);
          stroke(255, 0, 0);
          textileSensors[i].drawStripAverage(1, 3);
        }
      }
    }
  }
}