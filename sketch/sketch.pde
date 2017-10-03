import java.util.*;
import hypermedia.net.*;
import peasy.*;

final int
  PILLAR_LEDS_LENGTH = 90,

  // mm
  PILLAR_LEDS_THICKNESS = 3,
  PILLAR_PITCH  = 500 / 3,
  PILLAR_WIDTH = 30,
  PILLAR_THICKNESS = 10,
  PILLAR_HEIGHT = 1500,
  PILLAR_OFFY = 200,
  LEDS_PITCH = ((PILLAR_HEIGHT / PILLAR_LEDS_LENGTH) + 2);

boolean SHOW_GRID = true;

// -------------------------------------------------------------------------

PeasyCam cam;
Stratum stratum;

void settings () {
  size(800, 600, P3D);
  // fullScreen(P3D, 2);
}

void setup () {
  float fov = PI / 3.0;
  float cameraZ = (height) / tan(fov / 2.0);
  perspective(fov, float(width) / float(height), cameraZ / 100.0, cameraZ * 100.0);
  cam = new PeasyCam(this, cameraZ);
  stratum = new Stratum(this, loadImage("8x8.png"));
  stratum.connect(3737);
}

void draw () {
  background(#222222);
  rotateX(radians(90));
  rotateZ(radians(90));
  rotateY(radians(22.5));
  translate(stratum.origin.x, stratum.origin.y, stratum.origin.z);

  stratum.draw();
  stratum.drawFloor(SHOW_GRID);
  fpsMeter();
}

void keyPressed () {
  switch (key) {
    case 'g' : SHOW_GRID = !SHOW_GRID; break;
  }
}

void fpsMeter () { fpsMeter(""); }
void fpsMeter (String suffix) {
  cam.beginHUD();
  fill(255);
  textAlign(LEFT, BOTTOM);
  text(int(frameRate) + " fps" + "\n" + suffix, 20, height - 20);
  cam.endHUD();
}
