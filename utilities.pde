/*
SELF EXPLANATORY NAME IS SELF EXPLANATORY
 
 here's the sorting algorithms, the index calculator, mask summer, and other random functions
 */

//pixel index calculator. this shit is the fucking GOAT
int pxIndex(int x, int y, int imgWidth) {
  int index = x + y * imgWidth;
  return index;
}

//just a basic float array sorter
float[] sortFloatPxArr (float[] pxArr) {

  for (int i = 0; i < pxArr.length; i++) {
    int pxActual = 0;
    float pxMin = 999999999;
    for (int j = i; j < pxArr.length; j++) {
      if (pxArr[j] < pxMin) {
        pxActual = j;
        pxMin = pxArr[j];
      }
    }
    if (pxActual <= pxArr.length) {

      float pxTemp = pxArr[i];
      pxArr[i] = pxArr[pxActual];
      pxArr[pxActual] = pxTemp;
    }
  }
  return pxArr;
}

//another sorter but backwards, idk if it's even used anywhere xdd
float[] sortFloatPxArrInverted (float[] pxArr) {
  for (int i = 0; i < pxArr.length; i++) {
    int pxActual = 0;
    float pxMin = 0;
    for (int j = i; j < pxArr.length; j++) {
      if (pxArr[j] > pxMin) {
        pxActual = j;
        pxMin = pxArr[j];
      }
    }
    if (pxActual <= pxArr.length) {

      float pxTemp = pxArr[i];
      pxArr[i] = pxArr[pxActual];
      pxArr[pxActual] = pxTemp;
    }
  }
  return pxArr;
}

// for sorting pixels, we are gonna need a sorter for integers to avoid number conversion shenanigans
int[] sortIntPxArr (int[] pxArr) {

  int pxActual;
  int pxMin = 99999;

  for (int i = 0; i < pxArr.length; i++) {
    pxActual = 0;
    for (int j = i; j < pxArr.length; j++) {
      if (pxArr[j] < pxMin) {
        pxActual = j;
        pxMin = pxArr[j];
      }
    }
    if (pxActual < pxArr.length) {
      int pxTemp = pxArr[i];
      pxArr[i] = pxArr[pxActual];
      pxArr[pxActual] = pxTemp;
    }
  }
  return pxArr;
}

//outlined text, taken from the processing forum. ty jpkelly26 :D
void strokeText(String message, int x, int y, int alpha, boolean stroke)
{
  if (stroke){
  fill(0, alpha);
  text(message, x-1, y);
  text(message, x, y-1);
  text(message, x+1, y);
  text(message, x, y+1);

  fill(255, alpha);
  text(message, x, y);
  } else {
  fill(255, alpha);
  text(message, x-1, y);
  text(message, x, y-1);
  text(message, x+1, y);
  text(message, x, y+1);

  fill(255, alpha);
  text(message, x, y);
  }
}

PImage maskSum (PImage img1, PImage img2) {
  PImage imgSum = img1.copy();
  float briTemp;
  int pxIndex;
  for (int i = 0; i < img1.width; i++) {
    for (int j = 0; j < img1.height; j++) {
      pxIndex = pxIndex(i, j, img1.width);
      briTemp = brightness(img2.pixels[pxIndex]);
      if (briTemp == 255) {
        imgSum.pixels[pxIndex] = color(255, 255, 255);
      }
    }
  }
  return imgSum;
}

/*
// function for running Unix commands (like ffmpeg) inside Processing (jeffreythompson love ya :D)
void UnixCommand(String commandToRun) {
  File workingDir = new File(sketchPath(""));
  String returnedValues;
  try {
    Process p = Runtime.getRuntime().exec(commandToRun, null, workingDir);
    int i = p.waitFor();
    if (i == 0) {
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
      while ( (returnedValues = stdInput.readLine ()) != null) {
        // enable this option if you want to get updates when the process succeeds
        // println("  " + returnedValues);
      }
    } else {
      BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
      while ( (returnedValues = stdErr.readLine ()) != null) {
        // print information if there is an error or warning (like if a file already exists, etc)
        println("  " + returnedValues);
      }
    }
  }

  // if there is an error, let us know
  catch (Exception e) {
    println("Error running command: ");
    println("     " + e);
  }
}
*/

File[] getFiles(String dirPath, String extension) {
  File dir = new File(dirPath);
  if (!dir.isDirectory()) {
    println(dirPath + " is not a valid directory.");
  }
  
  return dir.listFiles(new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith("." + extension.toLowerCase());
    }
  });
}

//button handler, replaces old keyReleased implementation
public void handleButton(GButton button, GEvent event){
  if (button == sortButton){
    sort = true;
    
    idxUndo++;
    filePath = "temp/undo" + idxUndo + ".png";//save current frame for undo. this happens just before doing anything to the current canvas
    saveFrame(filePath);
  }
  if (button == filterButton){
    filter = true;
    
    idxUndo++;
    filePath = "temp/undo" + idxUndo + ".png";//save current frame for undo. this happens just before doing anything to the current canvas
    saveFrame(filePath);
  }
  if (button == resetButton){
    imgSorted = imgOrigen.get();
    saveImg = false;
    text = false;
    rasterize = false;
    delete = true;
    idxUndo = 0;
  }
  if (button == saveButton){
    saveFrame("output/" + photoNumber + "###.png");
  }
  if (button == textButton){
    text = true;
    
    idxUndo++;
    filePath = "temp/undo" + idxUndo + ".png";//save current frame for undo. this happens just before doing anything to the current canvas
    saveFrame(filePath);
  }
  if (button == undoButton){
    if (idxUndo != 0){
      filePath = "temp/undo" + idxUndo + ".png";
      imgSorted = loadImage(filePath);
      idxUndo--;
    }
  }
  if (button == prevButton){
    prev = true;
  }
  if (button == nextButton){
    next = true;
  }
}

public void handleCheckbox(GCheckbox checkbox, GEvent event){
  if (checkbox == hsbCheckbox){
    if (hsbCheckbox.isSelected()){
      rgbCheckbox.setSelected(false);
    }
  }
  if (checkbox == rgbCheckbox){
    if (rgbCheckbox.isSelected()){
      hsbCheckbox.setSelected(false);
    }
  }
  
  if (checkbox == horizontalCheckbox){
    if (horizontalCheckbox.isSelected()){
      //unselect vert checkbox
    }
  }
  if (checkbox == verticalCheckbox){
    if (verticalCheckbox.isSelected()){
      //unselect horiz checkbox
    }
  }
  
  if (checkbox == maskCheckbox){//if unselect mask, unselect threshold
    if (checkbox.isSelected() == false){
      threshCheckbox.setSelected(false);
    }
  }
  if (checkbox == threshCheckbox){//if threshold is selected, select mask
    if (checkbox.isSelected()){
      maskCheckbox.setSelected(true);
    }
  }
}
//old interface, it can be used as a hotkey thingy, just uncomment it
/*
void keyReleased() {
  switch (key) {
  case 't':
    if (text == true) {
      text = false;
    } else {
      text = true;
    }
    break;

  case 'd':
    if (saveImg == true) {
      saveImg = false;
    } else {
      saveImg = true;
    }
    break;
  case 's':
    saveFrame("output/" + photoNumber + "###.png");
    break;

  case 'r':
    imgSorted = imgOrigen.get();
    saveImg = false;
    text = false;
    rasterize = false;
    break;

  case 'a':
    sort = true;
    break;

  case 'f':
    filter = true;
    break;

  case 'n':
    prev = true;
    break;

  case 'm':
    next = true;
    break;
    
  case 'c':
    rasterize = true;
    break;
  }
}
*/
