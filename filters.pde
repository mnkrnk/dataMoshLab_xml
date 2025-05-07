/*
MASKS AND FILTERS
 */

//the masking GOAT, given a certain range of brightness values, it will return an image of only black and white pixels. great for shape recognition
PImage contrastMask (PImage img, int minBright, int maxBright) {
  colorMode(RGB);
  PImage maskedImg = createImage(img.width, img.height, RGB);

  for (int i = 1; i < img.pixels.length; i++) {

    float bri = brightness(img.pixels[i]);

    if (bri >= minBright && bri <= maxBright) {
      maskedImg.pixels[i] = color(255, 255, 255);
    } else {
      maskedImg.pixels[i] = color(0, 0, 0);
    }
  }
  return maskedImg;
}

//another sort of contrast mask, but checks for hue values (i was just trying random shit at this point istg xdd)
PImage hueContrastMask (PImage img, int minBright, int maxBright, int minHue, int maxHue) {
  colorMode(RGB);
  PImage maskedImg = createImage(img.width, img.height, RGB);

  for (int i = 1; i < img.pixels.length; i++) {

    float hue = hue(img.pixels[i]);
    float bri = brightness(img.pixels[i]);

    if (hue >= minHue && hue <= maxHue && bri >= minBright && bri <= maxBright) {
      maskedImg.pixels[i] = color(255, 255, 255);
    } else {
      maskedImg.pixels[i] = color(0, 0, 0);
    }
  }
  return maskedImg;
}

//good for animated effects and slight "digi-blur" since sort arrays tend to be small
PImage randomMask (PImage img) {
  colorMode(RGB);
  PImage randomMask = createImage(img.width, img.height, RGB);

  for (int i = 0; i < randomMask.pixels.length; i++) {
    if (round(random(1)) == 1) {
      randomMask.pixels[i] = color(255, 255, 255);
    } else {
      randomMask.pixels[i] = color(0, 0, 0);
    }
  }
  return randomMask;
}

//rectangular mask. params are measured in pixels, being: size in x, size in y, offset from 0 in x and offset from 0 in y
PImage rectMask (PImage img, int x, int y, int xOffset, int yOffset) {
  if (x + xOffset > img.width) {
    x = 0;
    xOffset = 0;
  }
  if (y + yOffset > img.height) {
    y = 0;
    yOffset = 0;
  }

  colorMode(RGB);
  PImage rectMask = createImage(img.width, img.height, RGB);
  int index;

  for (int i = 0; i < x; i++) {
    for (int j = 0; j < y; j++) {
      index = pxIndex(i + xOffset, j + yOffset, img.width);
      rectMask.pixels[index] = color(255, 255, 255);
    }
  }
  return rectMask;
}

//elliptic mask, x and y define the center and the other 2 params would be both radiuses
PImage ellipticMask (PImage img, int x, int y, int xRad, int yRad) {
  if (x + xRad > img.width) { //it'd be nice to clap values here so that the ellipse gets cut sharply on the edge of images (probably clamping on each each x and y calc? idk what i'm even saying lmao)
    x = 0;
    xRad = 0;
  }
  if (y + yRad > img.height) {
    y = 0;
    yRad =0;
  }

  colorMode(RGB);
  PImage ellipticMask = createImage(img.width, img.height, RGB);
  int index;
  int jOffset;
  int jIdx;

  for (int i = x - xRad; i < x + xRad; i++) {
    //we calculate y for each x, and we use those 2 values to generate a pixel index that will equal to each white pixel we need
    jOffset = y - round(sqrt(pow(yRad, 2) * (1 - (pow(i-x, 2)/pow(xRad, 2)))));

    for (int j = 0; j < (y - jOffset)*2; j++) {
      jIdx = jOffset + j;
      index = pxIndex(i, jIdx, img.width);
      ellipticMask.pixels[index] = color(255, 255, 255);
    }
  }
  return ellipticMask;
}

//PIXELATOR, kinda works like shit xdd, input "px" should be amount of pixels but idk man
PImage pixelator (PImage img, int px) {
  colorMode(RGB);
  PImage pixelImg = createImage(img.width, img.height, RGB);
  pixelImg.loadPixels();
  img.resize(px, 0);

  for (int i = 0; i < img.width; i++) {//1st loop, og image
    for (int j = 0; j < img.height; j++) {
      int px_actual = pxIndex(i, j, img.width);
      color color_pxActual = img.pixels[px_actual];

      int hh = round(pixelImg.height / img.height);
      int ww = round(pixelImg.width / img.width);

      for (int x = 0; x < ww; x++) {//2do loop, for each square's width (resized pixel)
        for (int y = 0; y < hh; y++) {//resized pixel's height...
          int index = pxIndex((i*ww) + x, (j*hh) + y, pixelImg.width);
          pixelImg.pixels[index] = color_pxActual;
          pixelImg.updatePixels();
        }
      }
    }
  }
  return pixelImg;
}

//FLOYD-STEINBERG DITHER -- steps define the amount of cuts our color scale will have, and thus the amount of colors our image can have (ie 2 steps will give us 3 separate "shades" of each color)
//daniel shiffman more like GOATman, shoutout to the coding train
PImage fsDither (PImage img, int steps) {
  colorMode(RGB);
  for (int i = 1; i < img.width - 1; i++) {
    for (int j = 0; j < img.height - 1; j++) {

      int pxIndex = pxIndex(i, j, img.width);
      color pxColor = img.pixels[pxIndex];

      float currentRed = red(pxColor);
      float currentGreen = green(pxColor);
      float currentBlue = blue(pxColor);

      int quantRed = round(steps * currentRed / 255) * (255 / steps);
      int quantGreen = round(steps * currentGreen / 255) * (255 / steps);
      int quantBlue = round(steps * currentBlue / 255) * (255 / steps);

      float errRed = currentRed - quantRed;
      float errGreen = currentGreen - quantGreen;
      float errBlue = currentBlue - quantBlue;
      img.pixels[pxIndex] = color(quantRed, quantGreen, quantBlue);

      //once each corrected pixel is calculated, we have to recalculate the "spillage" for each near pixel
      int errIndex = pxIndex(i + 1, j, img.width); //1st order
      color tempColor = img.pixels[errIndex];
      float red = red(tempColor);
      float green = green(tempColor);
      float blue =  blue(tempColor);
      red = red + errRed * 7/16.0;
      green = green + errGreen * 7/16.0;
      blue = blue + errBlue * 7/16.0;
      img.pixels[errIndex] = color (red, green, blue);

      errIndex = pxIndex(i - 1, j + 1, img.width); //2nd order
      tempColor = img.pixels[errIndex];
      red = red(tempColor);
      green = green(tempColor);
      blue =  blue(tempColor);
      red = red + errRed * 3/16.0;
      green = green + errGreen * 3/16.0;
      blue = blue + errBlue * 3/16.0;
      img.pixels[errIndex] = color (red, green, blue);

      errIndex = pxIndex(i, j + 1, img.width); //3rd order
      tempColor = img.pixels[errIndex];
      red = red(tempColor);
      green = green(tempColor);
      blue =  blue(tempColor);
      red = red + errRed * 5/16.0;
      green = green + errGreen * 5/16.0;
      blue = blue + errBlue * 5/16.0;
      img.pixels[errIndex] = color (red, green, blue);

      errIndex = pxIndex(i + 1, j + 1, img.width); //4th order
      tempColor = img.pixels[errIndex];
      red = red(tempColor);
      green = green(tempColor);
      blue =  blue(tempColor);
      red = red + errRed * 1/16.0;
      green = green + errGreen * 1/16.0;
      blue = blue + errBlue * 1/16.0;
      img.pixels[errIndex] = color (red, green, blue);
    }
  }
  return img;
}

//rasterizer effect, with both a black and white and a color setting defined by the flag "mono"
//b&w should be used with milder settings to still appreciate the photo
//in b&w mode it can be used to create masks since the output is a PImage with only black and white pixels
PImage rasterizerFilter(PImage img, int tiles, float pow, boolean mono, boolean stroke) {
  PImage imgRaster;
  
  if (stroke){
    stroke(0);
  } else {
    noStroke();
  }
  
  float tileSizeX = img.width/tiles;
  float tilesY = (img.height * tiles)/img.width;
  float tileSizeY = img.height/tilesY;
  
  
  if (mono){
    background(255);
  } else {
    background(255); //i still don't know if i want to repaint the background or if i should keep the og photo printed below it xdd
  }

  for (int i = 0; i < img.width; i++){
    for (int j = 0; j < img.height; j++){
      
      color c = img.get(int(i*tileSizeX), int(j*tileSizeY)); //the brightness value we will compare and remap
      float sizeX = map(brightness(c), 0, 255, tileSizeX*pow, tileSizeX); //remapping of the brightness value, works like a threshold
      //float sizeY = map(brightness(c), 0, 255, tileSizeY*pow, tileSizeY); we only use one size value to have circles, this other size can be used to have different shaped ellipses
      
      if (mono){
        fill(0);
      } else {
        fill(c);
      }
      
      if (brightness(c) != 0){ //"we'll fix this later" type beat
        ellipse(i*tileSizeX, j*tileSizeY, sizeX, sizeX);
      }
    }
  }

  String filePath = "temp/temp.png";
  saveFrame(filePath); //save canvas in temp folder
  imgRaster = loadImage(filePath); //reopen created img as PÍmage

/* i mean we should be deleting the file, right? but idk why it won't fucking delete it, so by hardcoding the same image name we just keep overwriting it so it doesn't get too crazy xdd
  File f = new File(filePath); //delete temp file
  f.delete();
*/

  return imgRaster; //return said imgs
}
