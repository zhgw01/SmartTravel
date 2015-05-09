# SmartTravel

## How to simulate walking in IOS Simulator

* Get a gpx file
  * Refer to [gpx route tutorial](http://bedsforcyclists.co.uk/articles/2014/04/13/how-to-plan-a-route-in-google-maps-and-export-it-to-gpx-your-phone/)
  * Plan your route on google map, and get a url like this http://bedsforcyclists.co.uk/articles/2014/04/13/how-to-plan-a-route-in-google-maps-and-export-it-to-gpx-your-phone/
  * Open [GPS Visualizer](http://www.gpsvisualizer.com/), Select `Convert to GPX`, paste the above url, and click `convert` button, then you get the gpx file
* Copy the content of the gpx to default.gpx file
* Since we setup defaut.gpx as simulation location, when you debug, it will automatically read default.gpx and use the locations
