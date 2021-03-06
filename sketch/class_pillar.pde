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
    this.ledsShape.setStroke(false);
  }

  // -------------------------------------------------------------------------

  public void draw () { this.draw(true); }
  public void draw (boolean drawPillar) {
    pushMatrix();
    translate(i * PILLAR_PITCH, j * PILLAR_PITCH);
    if (drawPillar) shape(this.pillarShape);

    for (int i = 0, len = this.ledsShape.getChildCount(); i < len; i++) {
      PShape led = this.ledsShape.getChild(i);
      color c = color(this.leds[i][0], this.leds[i][1], this.leds[i][2]);
      if (!drawPillar) c = color(red(c), green(c), blue(c), brightness(c));
      led.setFill(c);
    }

    shape(this.ledsShape);
    popMatrix();
  }

  public float getLightValue () {
    float sum = 0;
    for (int[] l : this.leds) {
      color c = color(l[0], l[1], l[2]);
      sum += brightness(c);
    }
    return (float) sum / PILLAR_LEDS_LENGTH;
  }

  public color getAverageColor () {
    float sum_r = 0;
    float sum_g = 0;
    float sum_b = 0;
    for (int[] l : this.leds) {
      sum_r += l[0];
      sum_g += l[1];
      sum_b += l[2];
    }
    return color(sum_r / PILLAR_LEDS_LENGTH, sum_g / PILLAR_LEDS_LENGTH, sum_b / PILLAR_LEDS_LENGTH);
  }
}
