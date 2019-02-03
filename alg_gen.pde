PImage base, best;
PGraphics candidata;

int grabar_cada = 50;

int dist_base_cand, dist_base_best;
int generacion = 1, sin_mejora = 0;
float timer = 0;
PVector esc_imagen;

String garabato = "garabato_01";

String[] alternativas = {
  "garabato_09", "garabato_10", 
  "garabato_13", "garabato_14", 
};



void setup() {

  size(1000, 550);
  background(0);
  noStroke();
  fill(0);
  textSize(16);

  base = loadImage("caballero.png"); 
  best = createImage(base.width, base.height, RGB);

  candidata = createGraphics(base.width, base.height);
  candidata.beginDraw();
  candidata.rectMode(CENTER);
  candidata.endDraw();

  escala_imagen();

  best = createImage(base.width, base.height, RGB);

  for (int f = 0; f<base.width*base.height; f++) {
    best.pixels[f] = 0x65614d;
    //best.pixels[f] = 0xdee4e8;
    //best.pixels[f] = 0x6cbbff;
  }

  dist_base_best = 0x7FFFFFFF;
}



void draw() {

  //-- GARABATEAR ---------------------------------------------------------------
  candidata.beginDraw();
  candidata.image(best.get(), 0, 0);
  method(garabato);
  candidata.endDraw();
  //-----------------------------------------------------------------------------


  //-- CALCULAR PARECIDO --------------------------------------------------------
  dist_base_cand = imgdist(base, candidata);
  //-----------------------------------------------------------------------------


  //-- DESCARTAR O SUSTITUIR ----------------------------------------------------
  if (dist_base_cand < dist_base_best) {

    //Si la imagen candidata es mejor que best, actualizamos best
    //y lo mismo la grabamos en disco
    best.copy(candidata.get(), 0, 0, base.width, base.height, 0, 0, base.width, base.height);
    dist_base_best = dist_base_cand;

    if (generacion%grabar_cada==0) {
      best.save(garabato + "_"+nf(generacion/grabar_cada, 4)+".png");
    }

    generacion++;
    sin_mejora = 0;
  } else {

    sin_mejora++;
  }
  //-----------------------------------------------------------------------------


  //-- ACTUALIZAR INTERFACE -----------------------------------------------------
  image(candidata, 0, 0, esc_imagen.x, esc_imagen.y);
  image(best, 500, 0, esc_imagen.x, esc_imagen.y);

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

void escala_imagen() {
  float proporcion;
  proporcion = (float)base.height/base.width;
  if (proporcion>1) {
    esc_imagen = new PVector(500/proporcion, 500);
  } else {
    esc_imagen = new PVector(500, 500*proporcion);
  }
}

//Círculos
void garabato_01() {
  for (int f=0; f<15; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    int r = (int)random(5, 150);
    color c = base.get(x, y);
    candidata.noStroke();
    candidata.fill(c);
    candidata.ellipse(x, y, r, r);
  }
}


//Círculos con transparencia
void garabato_02() {
  for (int f=0; f<10; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    int r = (int)random(5, 50);
    color c = base.get(x, y);
    candidata.noStroke();
    candidata.fill(c, 50);
    candidata.ellipse(x, y, r, r);
  }
}

//Círculos más grandes con más transparencia (feo a la larga)
void garabato_03() {
  for (int f=0; f<10; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    int r = (int)random(5, 400);
    color c = base.get(x, y);
    candidata.noStroke();
    candidata.fill(c, 8);
    candidata.ellipse(x, y, r, r);
  }
}

//Círculos grises con transparencia
void garabato_04() {
  for (int f=0; f<10; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    int r = (int)random(5, 200);
    color c = (int)random(255);
    candidata.noStroke();
    candidata.fill(c, 128);
    candidata.ellipse(x, y, r, r);
  }
}

//Círculos grises sin transparencia. Tarda mucho en converger.
void garabato_05() {
  for (int f=0; f<10; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    int r = (int)random(5, 50);
    color c = (int)random(255);
    candidata.noStroke();
    candidata.fill(c);
    candidata.ellipse(x, y, r, r);
  }
}

//Círculos grises con poca transparencia. tarda un poco menos en converger.
void garabato_06() {
  for (int f=0; f<10; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    int r = (int)random(5, 50);
    color c = (int)random(255);
    candidata.noStroke();
    candidata.fill(c, 200);
    candidata.ellipse(x, y, r, r);
  }
}

int r = (int)random(5, 1500.0/(frameCount/500.0));

//Rectángulos rellenos. Sin transparencia no converge.
void garabato_07() {
  for (int f=0; f<10; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(base.width/2);
    int y2 = (int)random(base.height/2);
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c, 120);
    candidata.rect(x1, y1, x2, y2);
  }
}

//Bordes de rectángulos.
void garabato_08() {
  for (int f=0; f<10; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(base.width/2);
    int y2 = (int)random(base.height/2);
    color c = base.get(x1, y1);
    candidata.stroke(c);
    candidata.noFill();
    candidata.rect(x1, y1, x2, y2);
  }
}

//Rectángulos rellenos muy apaisados.
void garabato_09() {
  for (int f=0; f<15; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(base.width/2);
    int y2 = (int)random(base.height/20);
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c);
    candidata.rect(x1, y1, x2, y2);
  }
}

//Rectángulos rellenos muy verticales.
void garabato_10() {
  for (int f=0; f<15; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(base.width/20);
    int y2 = (int)random(base.height/2);
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c);
    candidata.rect(x1, y1, x2, y2);
  }
}

//Rectángulos con rotación.
void garabato_11() {
  for (int f=0; f<25; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(300);
    int y2 = (int)random(50);
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c);
    candidata.pushMatrix();
    candidata.translate(x1, y1);
    candidata.rotate(random(TWO_PI));
    candidata.rect(0, 0, x2, y2);
    candidata.popMatrix();
  }
}

//Rectángulos con rotación fija.
void garabato_12() {
  for (int f=0; f<25; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(300);
    int y2 = (int)random(50);
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c);
    candidata.pushMatrix();
    candidata.translate(x1, y1);
    candidata.rotate(timer);
    candidata.rect(0, 0, x2, y2);
    candidata.popMatrix();
  }
  timer += PI/3;
}

//Rectángulos de tamaño fijo con rotación fija.
void garabato_13() {
  for (int f=0; f<10; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = 10;
    int y2 = 250;
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c);
    candidata.pushMatrix();
    candidata.translate(x1, y1);
    candidata.rotate(timer);
    candidata.rect(0, 0, x2, y2);
    candidata.popMatrix();
  }
  timer += PI/3;
}

//Rectángulos gruesos con rotación fija y transparencia.
void garabato_14() {
  for (int f=0; f<10; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = 75;
    int y2 = (int)random(500);
    color c = base.get(x1, y1);
    candidata.noStroke();
    candidata.fill(c, 150);
    candidata.pushMatrix();
    candidata.translate(x1, y1);
    candidata.rotate(timer);
    candidata.rect(0, 0, x2, y2);
    candidata.popMatrix();
  }
  timer += PI/3;
}

//Líneas de dimensiones fijas
void garabato_15() {
  for (int f=0; f<5; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    PVector p = PVector.fromAngle(timer).setMag(base.width/2);
    color c = base.get(x, y);
    candidata.stroke(c);
    candidata.strokeWeight(2);
    candidata.line(x-p.x/2, y-p.y/2, x+p.x/2, y+p.y/2);
  }
  timer += 0.01;
}

//Líneas perpendiculares
void garabato_16() {
  for (int f=0; f<25; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    PVector p = PVector.fromAngle(timer).setMag(random(100, 300));
    color c = base.get(x, y);
    candidata.stroke(c);
    candidata.strokeWeight(2);
    candidata.line(x-p.x/2, y-p.y/2, x+p.x/2, y+p.y/2);
  }
  timer += PI/2;
}

//Líneas al tuntún
void garabato_17() {
  for (int f=0; f<25; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    PVector p = PVector.fromAngle(random(TWO_PI)).setMag(random(100, 500));
    color c = base.get(x, y);
    candidata.stroke(c);
    candidata.strokeWeight(5);
    candidata.line(x-p.x/2, y-p.y/2, x+p.x/2, y+p.y/2);
  }
}

//Triángulos que no convergen
void garabato_18() {
  for (int f=0; f<5; f++) {
    int x1 = (int)random(base.width);
    int y1 = (int)random(base.height);
    int x2 = (int)random(base.width);
    int y2 = (int)random(base.height);
    int x3 = (int)random(base.width);
    int y3 = (int)random(base.height);
    color c = base.get((x1+x2+x3)/3, (y1+y2+y3)/3);
    candidata.noStroke();
    candidata.fill(c, 150);
    candidata.triangle(x1, y1, x2, y2, x3, y3);
  }
}

//Triángulos hacia arriaba y hacia abajo
void garabato_19() {
  for (int f=0; f<1; f++) {
    int x = (int)random(base.width);
    int y = (int)random(base.height);
    float mag = random(5, 1500);
    int mult = random(1)>0.5?1:-1;
    PVector p1 = PVector.fromAngle(mult*PI/3).setMag(mag);
    PVector p2 = PVector.fromAngle(0).setMag(mag);
    color c = base.get(int(x+(p1.x+p2.x)/3), int(y+(p1.y+p2.y)/3));
    candidata.noStroke();
    candidata.fill(c);
    candidata.triangle(x, y, x+p1.x, y+p1.y, x+p2.x, y+p2.y);
  }
}


//Líneas de lado a lado
void garabato_20() {
  for (int f=0; f<10; f++) {
    PVector p1, p2;
    if (random(1)>0.5) {
      p1 = new PVector(random(base.width), 0);
      p2 = new PVector(random(base.width), base.height);
    } else {
      p1 = new PVector(0, random(base.height));
      p2 = new PVector(base.width, random(base.height));
    }
    color c = base.get((int)random(base.width), (int)(p1.y+p2.y)/2);
    candidata.stroke(c);
    candidata.line(p1.x, p1.y, p2.x, p2.y);
  }
}

//Líneas de lado a lado, perpendiculares
void garabato_21() {
  for (int f=0; f<10; f++) {
    PVector p1, p2;
    if (random(1)>0.5) {
      p1 = new PVector(random(base.width), 0);
      p2 = new PVector(p1.x, base.height);
    } else {
      p1 = new PVector(0, random(base.height));
      p2 = new PVector(base.width, p1.y);
    }
    color c = base.get((int)random(base.width), (int)random(base.height));
    candidata.stroke(c);
    candidata.line(p1.x, p1.y, p2.x, p2.y);
  }
}

//Líneas horizontales por columnas
//Realmente no es genético (cada pixel tiene un valor unívoco), pero me gusta el resultado
void garabato_22() {
  int numcols = 11;
  for (int f=0; f<20; f++) {
    int x = (int)random(numcols)*base.width/numcols;
    int y = (int)random(base.height);
    color c = base.get(x+base.width/numcols/2, y);
    candidata.stroke(c);
    candidata.line(x, y, x+base.width/numcols, y);
  }
}

//Curvas BN
void garabato_23() {
  for (int f=0; f<1; f++) {
    candidata.stroke(50*((int)random(6)), 150);
    candidata.noFill();
    candidata.beginShape();
    for (int i=0; i<4; i++) {
      candidata.curveVertex(random(base.width), random(base.height));
    }
    candidata.endShape();
  }
}

//Curvas color
void garabato_24() {
  for (int f=0; f<2; f++) {
    color c = base.get((int)random(base.width), (int)random(base.height));
    candidata.stroke(c);
    candidata.strokeWeight(1);
    candidata.noFill();
    candidata.beginShape();
    for (int i=0; i<4; i++) {
      candidata.curveVertex(random(base.width), random(base.height));
    }
    candidata.endShape();
  }
}

//Gurruños
void garabato_25() {
  PVector p = new PVector (random(base.width), random(base.height));
  color c = base.get((int)random(base.width), (int)random(base.height));
  candidata.stroke(c);
  candidata.noFill();
  candidata.beginShape();
  for (int i=0; i<15; i++) {
    candidata.curveVertex(p.x, p.y);
    p.add(PVector.random2D().setMag(random(500)));
  }
  candidata.endShape();
}


//Meta!!!
void garabato_30() {
  int index = (int)random(0, alternativas.length);
  method(alternativas[index]);
}
