PImage g1; //First image
PImage g2; //Second image
PGraphics gg1; //PGraphic made from the first image
PGraphics gg2; //PGraphic made form the second image
int threshold = 150;
ArrayList<PVector> no1; //Container of first PGraphic's PVectors
ArrayList<PVector> no2; //Container of second PGraphic's PVectors

void setup(){
  size(640, 640);
  g2 = loadImage("213.jpg");
  g2.resize(639, 639);
  g1 = loadImage("typ.png"); 
  gg1 = createGraphics(639, 639);
  gg2 = createGraphics(639, 639);
  background(255);
  gg1 = shaper(g1, gg1, threshold);
  gg2 = shaper(g2, gg2, threshold);
  no1 = initializeVectors(gg1);
  no2 = initializeVectors(gg2);
}

//Function which converts PImage to transparent PGraphics, filled with black pixels based on brightness threshold
PGraphics shaper(PImage g, PGraphics gg, int t){
  g.loadPixels();
  gg.beginDraw();
  gg.loadPixels();
  for (int x = 0; x < g.width; x++) {
    for (int y = 0; y < g.height; y++ ) {
      int loc = x + y*g.width;
      if (!(brightness(g.pixels[loc]) < t)) {
        gg.pixels[loc]  = color(0);
      }
    }
  }
  gg.updatePixels();
  //gg.filter(BLUR, 1);
  gg.endDraw();
  
  return gg;
}

//Function adding PVectors from (0,0) to (x,y) of black pixels
ArrayList<PVector> initializeVectors(PGraphics gg){
  ArrayList<PVector> pvlist = new ArrayList<PVector>();
  gg.beginDraw();
  gg.loadPixels();
  for (int x = 0; x < gg.width; x++) {
    for (int y = 0; y < gg.height; y++ ) {
      int loc = x + y*gg.width;
      if (gg.pixels[loc] == color(0)) {
        pvlist.add(new PVector(x, y));
      }
    }
  }
  return pvlist;
}

void draw(){
  background(255);
  image(gg1, 0,0);
  
  //Morphing starts after some time in order to set the input image visible
  if(millis() > 2000){
    clear();
    background(255);
    //Quick workaround in order to not to get out of array boundary
    if(no1.size() > no2.size()) 
      for(int i = 0; i < no2.size(); i++){
        //Lerping from one PVector to another
        no1.get(i).lerp(no2.get(i), 0.35);
      }
    else
      for(int i = 0; i < no1.size(); i++){
        no1.get(i).lerp(no2.get(i), 0.35);
      }
    //Lerping visualisation, point by point
    // better performance to write directly to the pixel array
    
    loadPixels();
    color black = color(0);
    for(PVector v : no1){
      //curveVertex(v.x, v.y);
      int index = int(width * v.y + v.x);
      pixels[index] = black;
    }
    
    updatePixels();
  }
  saveFrame("asd/line-######.png");
}
