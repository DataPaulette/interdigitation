# Pressure Sensor Matrix Optimization Ressources

## This material is best understood in the context of our research paper.

![raw readings of all strokes on all sensors visualized at once](https://raw.githubusercontent.com/DataPaulette/interdigitation/master/all_data_purpleHIGH_redLOW.PNG)


## a) Content of the repo:

* **00 - Raw Original Files**: As output from the data collection process
* **01 - Cleaned Files**: Replaced faulty readings, fixed formatting
* **02 - Simplefied Files**: Removed data not relevant to analysis (using the **data_cleaner** processing sketch)
* **03 - Normalized Data**: Remapped values to fit the range 0 to 1, removed noise floor, applied low-pass filter (using the **data_scaling** processing sketch)
* **PapeFigures**: Sketches for making the barcharts found in the paper
* **data_cleaner**: Reorganizes the raw data, removes things irrelevant for this analysis
* **data_scaling**: Removes noise floor, maps to a range from 0 to 1
* **data_visualizer**: Code for visualization of raw data
* **spss_misc**: Output and spss files used for this paper *(to-do: double check that these are the most recent)*
* **touch_visualizer**: Like the data visualizer, just here the touch-positions are used for creating images
* **interpolation_methods**: Functions evaluated in the paper (This code will not run as is, to see them in action, check the touch_visualizer sketch).

## b) Other material:

Pattern Generator: [github.com/fkeel/patternGenerator](https://github.com/fkeel/patternGenerator)

(Alternative approach: [github.com/DataPaulette/stripPatternGenerator](https://github.com/DataPaulette/stripPatternGenerator))

CNC Control Code: [github.com/fkeel/CNC-Sensor-Tester](https://github.com/fkeel/CNC-Sensor-Tester)

Touch Simulation tool: [github.com/DataPaulette/InterdigitationSimulator](https://github.com/DataPaulette/InterdigitationSimulator)

