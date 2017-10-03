public class Pillar {

  private PShape pillarShape, ledsShape;

  public int i, j;
  public float distNorm = 0;
  public int[][] leds;

  Pillar (int i, int j) {
    this.i = i;
    this.j = j;
    this.leds = new color[PILLAR_LEDS_LENGTH][3];
    for (int[] l : this.leds) {
      l = new int[3];
      for (int a : l) a = 0;
    }

    this.createShapes();
  }

  private void createShapes () {
    this.pillarShape = createShape(BOX, PILLAR_THICKNESS, PILLAR_WIDTH, PILLAR_HEIGHT + PILLAR_OFFY);
    this.pillarShape.setStroke(false);
    this.pillarShape.setFill(color(30));
    this.pillarShape.translate(0, 0, (PILLAR_HEIGHT + PILLAR_OFFY) / 2);

    this.ledsShape = createShape(GROUP);
    float ledHeight = (PILLAR_HEIGHT / PILLAR_LEDS_LENGTH);
    for (int i = 0; i < PILLAR_LEDS_LENGTH; i++) {
      float y = map(i, 0, PILLAR_LEDS_LENGTH, 0, PILLAR_HEIGHT);

      PShape led = createShape(BOX, PILLAR_LEDS_THICKNESS, ledHeight, ledHeight);
      led.setStroke(color(0));
      led.translate(PILLAR_THICKNESS - PILLAR_LEDS_THICKNESS, 0, y + PILLAR_OFFY);
      this.ledsShape.addChild(led);
    }
    // this.ledsShape.setStroke(false);
  }

  // -------------------------------------------------------------------------

  public void draw () {
    pushMatrix();
    translate(i * PILLAR_PITCH, j * PILLAR_PITCH);
    shape(this.pillarShape);

    for (int i = 0, len = this.ledsShape.getChildCount(); i < len; i++) {
      PShape led = this.ledsShape.getChild(i);
      color c = color(this.leds[i][0], this.leds[i][1], this.leds[i][2]);
      led.setFill(c);
    }

    shape(this.ledsShape);
    popMatrix();
  }
}
