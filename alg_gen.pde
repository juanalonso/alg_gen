PImage base, best;
PGraphics candidata;

int dist_base_cand, dist_base_best;
int generacion = 1, sin_mejora = 0;

void setup() {

  size(1000, 550);
  noStroke();
  fill(0);
  textSize(16);

  base = loadImage("caballero.png"); 
  best = createImage(base.width, base.height, RGB);
  candidata = createGraphics(base.width, base.height);

  dist_base_best = 0x7FFFFFFF;
}




void draw() {

  //-- GARABATEAR ---------------------------------------------------------------
  candidata.beginDraw();
  
  candidata.image(best.get(), 0, 0);
  int x = (int)random(base.width);
  int y = (int)random(base.height);
  int r = (int)random(5, 150);
  color c = base.get(x, y);
  candidata.noStroke();
  candidata.fill(c);
  candidata.ellipse(x, y, r, r);
  
  candidata.endDraw();
  //-----------------------------------------------------------------------------


  //-- CALCULAR PARECIDO --------------------------------------------------------
  dist_base_cand = imgdist(base, candidata);
  //-----------------------------------------------------------------------------


  //-- DESCARTAR O SUSTITUIR ----------------------------------------------------
  if (dist_base_cand < dist_base_best) {

    best.copy(candidata.get(), 0, 0, base.width, base.height, 0, 0, base.width, base.height);
    dist_base_best = dist_base_cand;

    generacion++;
    sin_mejora = 0;
  } else {

    sin_mejora++;
  }
  //-----------------------------------------------------------------------------


  //-- ACTUALIZAR INTERFACE -----------------------------------------------------
  image(candidata, 0, 0, 500, 500);
  image(best, 500, 0, 500, 500);

  fill(0);
  rect(0, 500, width, 50);

  fill(255);
  text("Dist: " + dist_base_best, 10, 530);
  text("Iter: " + frameCount, 190, 530);
  text("Gen: " + generacion, 315, 530);
  text("Sin mejora: " + sin_mejora, 410, 530);
  //-----------------------------------------------------------------------------
}




int imgdist(PImage i1, PImage i2) {

  int counter = 0;
  for (int f = 0; f<base.width*base.height; f++) {
    counter += abs((i1.pixels[f]     & 0xff) - (i2.pixels[f]      & 0xff));
    counter += abs((i1.pixels[f]>>8  & 0xff) - (i2.pixels[f] >> 8 & 0xff));
    counter += abs((i1.pixels[f]>>16 & 0xff) - (i2.pixels[f] >>16 & 0xff));
  }
  return counter;
}
