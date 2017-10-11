import java.util.*;
import hypermedia.net.*;
import peasy.*;

final int
  PILLAR_LEDS_LENGTH = 90,

  // mm
  PILLAR_LEDS_THICKNESS = 3,
  PILLAR_PITCH  = 500,
  PILLAR_WIDTH = 30,
  PILLAR_THICKNESS = 10,
  PILLAR_HEIGHT = 1500,
  PILLAR_OFFY = 200,
  LEDS_PITCH = ((PILLAR_HEIGHT / PILLAR_LEDS_LENGTH) + 2);

boolean
  SHOW_GRID = true,
  SHOW_GRID_LIGHT = false,
  SHOW_PILLARS = true;

// -------------------------------------------------------------------------

PeasyCam cam;
Stratum stratum;

void settings () { size(1200, 800, P3D); }
void setup () {
  surface.setResizable(true);
  surface.setTitle("stratum-viewer");

  float fov = PI / 3.0;
  float cameraZ = (height * 2) / tan(fov / 2.0);
  perspective(fov, float(width) / float(height), cameraZ / 100.0, cameraZ * 1000.0);
  cam = new PeasyCam(this, cameraZ);
  stratum = new Stratum(this, loadImage("lyon_trimmed.png"));
  stratum.connect(3737);
}

void draw () {
  background(#222222);
  rotateX(radians(90));
  rotateZ(radians(90));
  rotateY(radians(22.5));
  translate(stratum.origin.x, stratum.origin.y, stratum.origin.z);

  stratum.draw(SHOW_PILLARS);
  stratum.drawFloor(SHOW_GRID, SHOW_GRID_LIGHT);
  fpsMeter();
}

void keyPressed () {
  switch (key) {
    case 'l' : SHOW_GRID_LIGHT = !SHOW_GRID_LIGHT; break;
    case 'h' : SHOW_PILLARS = !SHOW_PILLARS; break;
    case 'g' : SHOW_GRID = !SHOW_GRID; break;
    case 'p' : stratum.printNodesMapping(); break;
  }
}

void fpsMeter () {
  cam.beginHUD();
  fill(255);
  textAlign(LEFT, BOTTOM);
  text(int(frameRate) + " fps", 20, height - 20);
  cam.endHUD();
}
