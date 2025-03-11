// adaptado y basado en el codigo trabajado en clase

import ddf.minim.*;
import ddf.minim.analysis.*;
import java.util.ArrayList;

Minim minim;
AudioPlayer player;
FFT fft;

ArrayList<Circle> circles = new ArrayList<Circle>(); // planear circulos

void setup() {
  fullScreen(P3D);
  background(255);
  frameRate(60);

  minim = new Minim(this); // cargar el archivo de audio
  player = minim.loadFile("dod.mp3", 1024);
  player.play();

  fft = new FFT(player.bufferSize(), player.sampleRate());
}

void draw() {
  float amplitude = player.mix.level(); // con ayuda de chatgpt obtuve esta linea pues no supe como hacer que identificara el silencio en la cancion

  if (amplitude < 0.005) { // sensibilidad para el silencio
    background(0); // cuando esta en silencio se apaga la pantalla
    return;
  } else { // si no esta en silencio la pantalla vuelve a ser blanca
    background(255);
  }

  fft.forward(player.mix);
  float level = fft.getBand(10);
  float rad = level * 10; // circulos tamano

  float x = random(width); // creacion aleatoria de los circulos en el canvas
  float y = random(height);
  float gray = random(0, 250); // colores de los circulos
  color c = color(gray);

  circles.add(new Circle(x, y, rad, c));

  for (int i = circles.size() - 1; i >= 0; i--) {
    Circle cObj = circles.get(i);
    cObj.update();
    cObj.display();
    
    if (cObj.alpha <= 0) {
      circles.remove(i); // borrar circulos para no aglomerarlos
    }
  }
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}

class Circle {
  float x, y, rad;
  color c;
  int alpha = 255; // ajuste de opacidad inicial

  Circle(float x, float y, float rad, color c) {
    this.x = x;
    this.y = y;
    this.rad = rad;
    this.c = c;
  }

  void update() {
    alpha -= 5; // graduación de la opacidad para que parezca que se desvanecen
  }

  void display() {
    noStroke();
    fill(c, alpha); // tonos de gris finales
    ellipse(x, y, rad, rad);
  }
}
