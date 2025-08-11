//<DATA MOSH LAB v0.1.0b>//

/* HSB and RGB sorts, data paintbrush(NOT YET IMPLEMENTED), some filters
 
 lots of stolen functions, so feel free to steal this too :D
 
 shoutouts to Peter Lager for the GUI library, the coding train for endless fun projects (and the fs dither present here) and tim rodenbröker for the rasterizer idea!
 and massive thanks to everyone that posts on the processing forum, i got to resolve lots of issues just surfing through there :D
 
 mnkrnk - 2023 - 2025 */


/* PENDINGS AND STUFF
 
 ADD THE ASCII THINGY IN THIS FFS!!1!1!!!!!!1111111111 WOULD GO HARD AS FUCK
 
 GUI --> in process
 add missing functionalities (the other masks, mask summing)
 about mask summing... how the FUCK can i make a mask-sort matrix?
 
 text alpha knob or slider
 compensate font size on centering
 
 implement the data paintbrush (code not here i think) -> transform pimages into pgraphs to allow copy function to work on the currently sorted image
 
 implement missing masks (mostly rectangle and elliptical ones)
 
 photo size slider/field/whatever
 
 */

import processing.net.*;
import java.io.*;
import g4p_controls.*;

//all photos will be rescaled to the value (in pixels) below:
int pxSize = 1000; //you can use this value later to make filters scale up and down automatically (img.height or img.width will also work once the image is resized)

//select the font you want to use copying the filename to this variable: (this will 100% be replaced by a dropdown menu that reads fonts from the font folder, just like it should be)
String selectedFont = "ModeSevenBETAVHS2021.ttf";


//these can be left as they are
int pxMaskSize = round(pxSize / 4);
int minBright, maxBright, ditherAmt, rasterTiles, posterAmt, arrayThresh, textSize, xText, yText, textAlpha, idxUndo;
PImage imgOrigen, imgSorted, imgMask1, imgMask2, imgMask3, imgMaskDraw, imageText;
PFont font;

boolean dualDisplay, sort, filter, saveImg, text, prev, next, stroke, rasterize, events = false;
boolean centerText, delete;

int photoNumber = 0; //input photo index

String screenText, filePath, fileName, dateTime;

float rad = radians(90);

File[] tempFiles, inputFiles;
String[] fontNames;


void setup() {
  frameRate(30);
  size(1, 1);
  colorMode(HSB);

  inputFiles = getFiles("data", "jpg");
  if (inputFiles.length == 0) {
    throw new RuntimeException("No photos in data folder, program stopped.");
  }

  java.io.File fontFolder = new java.io.File(sketchPath("data/fonts"));
  fontNames = fontFolder.list();


  imgOrigen = loadImage(inputFiles[photoNumber].getAbsolutePath());

  if (imgOrigen.width > imgOrigen.height) {
    imgOrigen.resize(pxSize, 0);
  } else {
    imgOrigen.resize(0, pxSize);
  }

  imgSorted = createImage(imgOrigen.width, imgOrigen.height, HSB);
  imgSorted = imgOrigen.get();
  imgMask1 = createImage(imgOrigen.width, imgOrigen.height, HSB);
  imgMask2 = imgMask1.copy();
  imgMask3 = imgMask1.copy();
  imgMaskDraw = imgMask1.copy();

  surface.setResizable(true);//???????¿¿¿¿¿¿¿¿¿¿¿
  if (dualDisplay) {
    surface.setSize(imgSorted.width * 2, imgSorted.height);
  } else {
    surface.setSize(imgSorted.width, imgSorted.height);
  }
  surface.setResizable(false);//???????¿¿¿¿¿¿¿¿¿¿¿

  idxUndo = 0;
  delete = true;


  //GUI related setups
  createGUI();

  sortButton.addEventHandler(this, "handleButton");
  saveButton.addEventHandler(this, "handleButton");
  resetButton.addEventHandler(this, "handleButton");
  filterButton.addEventHandler(this, "handleButton");
  textButton.addEventHandler(this, "handleButton");
  undoButton.addEventHandler(this, "handleButton");
  prevButton.addEventHandler(this, "handleButton");
  nextButton.addEventHandler(this, "handleButton");

  horizontalCheckbox.addEventHandler(this, "handleCheckbox");
  verticalCheckbox.addEventHandler(this, "handleCheckbox");
  hsbCheckbox.addEventHandler(this, "handleCheckbox");
  rgbCheckbox.addEventHandler(this, "handleCheckbox");
  maskCheckbox.addEventHandler(this, "handleCheckbox");
  threshCheckbox.addEventHandler(this, "handleCheckbox");
  eventsCheckbox.addEventHandler(this, "handleCheckbox");
  randThreshCheckbox.addEventHandler(this, "handleCheckbox");
  centerTextCheckbox.addEventHandler(this, "handleCheckbox");

  fontCombo.setItems(fontNames, 0);
}

void draw() {

  if (eventsCheckbox.isSelected()) {
    events = true;
  } else {
    events = false;
  }

  //this section here is responsible for the photo swap
  if (prev) { //previous photo button is pressed

    if (photoNumber == 0) { //clamping
      photoNumber = 0;
    } else {
      photoNumber = photoNumber - 1;
    }

    imgOrigen = loadImage(inputFiles[photoNumber].getAbsolutePath());

    if (imgOrigen.width > imgOrigen.height) {
      imgOrigen.resize(pxSize, 0);
    } else {
      imgOrigen.resize(0, pxSize);
    }

    imgSorted = createImage(imgOrigen.width, imgOrigen.height, HSB);
    imgSorted = imgOrigen.get();
    imgMask1 = createImage(imgOrigen.width, imgOrigen.height, HSB);
    imgMask2 = imgMask1.copy();
    imgMask3 = imgMask1.copy();

    //this comes from the first version of this program, i'm not sure i still need to prevent the img window to be resized but i don't really want to find out lmao
    surface.setResizable(true);//???????¿¿¿¿¿¿¿¿¿¿¿
    surface.setSize(imgSorted.width, imgSorted.height);
    surface.setResizable(false);//???????¿¿¿¿¿¿¿¿¿¿¿

    prev = false;
  } else if (next) { //next photo button is pressed
    photoNumber = photoNumber + 1;

    if (photoNumber >= inputFiles.length) { //clamping after increment to avoid going out of bounds
      photoNumber = inputFiles.length - 1;
    }

    imgOrigen = loadImage(inputFiles[photoNumber].getAbsolutePath());

    if (imgOrigen.width > imgOrigen.height) {
      imgOrigen.resize(pxSize, 0);
    } else {
      imgOrigen.resize(0, pxSize);
    }


    imgSorted = createImage(imgOrigen.width, imgOrigen.height, HSB);
    imgSorted = imgOrigen.get();
    imgMask1 = createImage(imgOrigen.width, imgOrigen.height, HSB);
    imgMask2 = imgMask1.copy();
    imgMask3 = imgMask1.copy();


    surface.setResizable(true);//???????¿¿¿¿¿¿¿¿¿¿¿
    surface.setSize(imgSorted.width, imgSorted.height);
    surface.setResizable(false);//???????¿¿¿¿¿¿¿¿¿¿¿

    next = false;
  }


  //PRE SORT -- just a simple loadPixels call
  imgSorted.loadPixels();


  //SORTING -- everything responds to its respective checkbox and slider (if any)
  if (sort) {
    minBright = int(minBrightSlider.getValueS());
    maxBright = int(maxBrightSlider.getValueS());

    //sorts
    if (horizontalCheckbox.isSelected()) {//direction

      if (maskCheckbox.isSelected()) {//mask

        if (threshCheckbox.isSelected()) {//threshold
          arrayThresh = int(threshSlider.getValueS());

          if (invertCheckbox.isSelected()) {//inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED INVERTED HORIZONTAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMISHT(imgSorted, imgMask1, true, true, true, arrayThresh);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED INVERTED HORIZONTAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMISHT(imgSorted, imgMask1, true, true, true, arrayThresh);
            }
          } else { //else inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED HORIZONTAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMSHT(imgSorted, imgMask1, true, true, true, arrayThresh);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED HORIZONTAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMSHT(imgSorted, imgMask1, true, true, true, arrayThresh);
            }
          } // end inverted
        } else {//else thresh

          if (invertCheckbox.isSelected()) {//inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED INVERTED HORIZONTAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMISH(imgSorted, imgMask1, true, true, true);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED INVERTED HORIZONTAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMISH(imgSorted, imgMask1, true, true, true);
            }
          } else { //else inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED HORIZONTAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMSH(imgSorted, imgMask1, true, true, true);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED HORIZONTAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMSH(imgSorted, imgMask1, true, true, true);
            }
          } // end inverted
        }
      } else {// else mask


        if (invertCheckbox.isSelected()) {//inverted

          if (rgbCheckbox.isSelected()) {//rgb?
            //INVERTED HORIZONTAL
            imgSorted = rgbIH(imgSorted, minBright, maxBright, true, true, true);
          } else if (hsbCheckbox.isSelected()) { //else if hsb
            //INVERTED HORIZONTAL
            imgSorted = hsbIH(imgSorted, minBright, maxBright, true, true, true);
          }
        } else { //else inverted

          if (rgbCheckbox.isSelected()) {//rgb?
            //HORIZONTAL
            imgSorted = rgbH(imgSorted, minBright, maxBright, true, true, true);
          } else if (hsbCheckbox.isSelected()) { //else if hsb
            //HORIZONTAL
            imgSorted = hsbH(imgSorted, minBright, maxBright, true, true, true);
          }
        } // end inverted
      }
    }//end horizontal


    if (verticalCheckbox.isSelected()) {//direction

      if (maskCheckbox.isSelected()) {//mask

        if (threshCheckbox.isSelected()) {//threshold
          arrayThresh = int(threshSlider.getValueS());

          if (invertCheckbox.isSelected()) {//inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED INVERTED VERTICAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMISVT(imgSorted, imgMask1, true, true, true, arrayThresh);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED INVERTED VERTICAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMISVT(imgSorted, imgMask1, true, true, true, arrayThresh);
            }
          } else { //else inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED VERTICAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMSVT(imgSorted, imgMask1, true, true, true, arrayThresh);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED VERTICAL THRESHOLD
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMSVT(imgSorted, imgMask1, true, true, true, arrayThresh);
            }
          } // end inverted
        } else {//else thresh

          if (invertCheckbox.isSelected()) {//inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED INVERTED VERTICAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMISV(imgSorted, imgMask1, true, true, true);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED INVERTED VERTICAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMISV(imgSorted, imgMask1, true, true, true);
            }
          } else { //else inverted

            if (rgbCheckbox.isSelected()) {//rgb?
              //MASKED VERTICAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = rgbMSV(imgSorted, imgMask1, true, true, true);
            } else if (hsbCheckbox.isSelected()) { //else if hsb
              //MASKED VERTICAL
              imgMask1 = contrastMask(imgSorted, minBright, maxBright);
              imgSorted = hsbMSV(imgSorted, imgMask1, true, true, true);
            }
          } // end inverted
        }
      } else {// else mask


        if (invertCheckbox.isSelected()) {//inverted

          if (rgbCheckbox.isSelected()) {//rgb?
            //INVERTED VERTICAL
            imgSorted = rgbIV(imgSorted, minBright, maxBright, true, true, true);
          } else if (hsbCheckbox.isSelected()) { //else if hsb
            //INVERTED VERTICAL
            imgSorted = hsbIV(imgSorted, minBright, maxBright, true, true, true);
          }
        } else { //else inverted

          if (rgbCheckbox.isSelected()) {//rgb?
            //VERTICAL
            imgSorted = rgbV(imgSorted, minBright, maxBright, true, true, true);
          } else if (hsbCheckbox.isSelected()) { //else if hsb
            //VERTICAL
            imgSorted = hsbV(imgSorted, minBright, maxBright, true, true, true);
          }
        } // end inverted
      }
    }//end vertical

    sort = false;
  }

  //FILTERING -- everything responds to its respective checkbox and slider (if any)
  if (filter) {
    if (ditherCheckbox.isSelected()) {
      ditherAmt = int(ditherSlider.getValueS());
      imgSorted = fsDither(imgSorted, ditherAmt);
    }

    if (rasterizeCheckbox.isSelected()) {
      rasterTiles = int(rasterizeSlider.getValueS());
      imgSorted = rasterizerFilter(imgSorted, rasterTiles, 3, false, false);
    }

    if (erodeCheckbox.isSelected()) {
      imgSorted.filter(ERODE);
    }

    if (dilateCheckbox.isSelected()) {
      imgSorted.filter(DILATE);
    }

    if (posterizeCheckbox.isSelected()) {
      posterAmt = int(posterizeSlider.getValueS());
      imgSorted.filter(POSTERIZE, posterAmt);
    }

    filter = false;
  }


  //END -- nothing important below
  imgSorted.updatePixels();
  background(0);
  image(imgSorted, 0, 0);

  if (rasterize) {
    imgSorted = rasterizerFilter(imgSorted, 50, 3, false, false);
    rasterize = false;
  }

  if (dualDisplay) {
    image(imgMaskDraw, imgSorted.width, 0);
  }

  if (text) {
    //size in pixels, x and y is for position, h and w height and width
    textSize = int(textSizeSlider.getValueS());
    centerText = centerTextCheckbox.isSelected();

    if (centerText) {
      textAlign(CENTER);
      xText = imgSorted.width/2;
      yText = imgSorted.height/2;
    } else {
      xText = int(map(int(textXSlider.getValueS()), 1, 10000, 1, imgSorted.width));
      yText = int(map(int(textYSlider.getValueS()), 1, 10000, 1, imgSorted.height));
      textAlign(xText, yText);//???????¿¿¿¿¿¿¿¿¿¿¿¿¿¿
    }

    textAlpha = int(alphaSlider.getValueS());


    selectedFont = fontCombo.getSelectedText();
    font = createFont("fonts/" + selectedFont, pxSize/10);

    textFont(font, textSize); //make font selectable from fonts folder (combo box?)



    fill(255);

    stroke = textOutlineCheckbox.isSelected();
    screenText = textInput.getText();

    strokeText(screenText, xText, yText, textAlpha, stroke);

    String filePath = "temp/temp.png";
    saveFrame(filePath); //save canvas in temp folder
    imgSorted = loadImage(filePath); //reopen created img as PÍmage

    text = false;
  }

  //save frame feature, will slap the current date time to the og file name and save it in the output folder
  if (saveImg) {
    fileName = inputFiles[photoNumber].getName();
    dateTime = nf(year(), 4) + nf(month(), 2) + nf(day(), 2) + "_" + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2); //chatgpt wrote this xdd
    saveFrame("output/" + fileName.substring(0, fileName.length() - 4) + "_" + dateTime + ".png");
  }

  //everytime we reset -and on startup- every png in the temp folder will be deleted (this is used for the undo feature, the rasterizer and the text function)
  if (delete) {
    tempFiles = getFiles("temp", "png");

    for (int i = 0; i < tempFiles.length; i++) {
      if (tempFiles[i].exists()) {
        tempFiles[i].delete();
      }
    }

    delete = false;
  }
}
