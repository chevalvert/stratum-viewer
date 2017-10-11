public class Stratum {
  private PApplet parent;
  public ArrayList<Node> nodes;
  public Pillar[][] pillars;
  public int width, height;
  public PVector origin;

  Stratum (PApplet parent, PImage map) {
    this.parent = parent;

    this.width = map.height;
    this.height = map.width;
    this.pillars = mapToPillars(map);
    this.origin = new PVector(-((this.width) * PILLAR_PITCH / 2),
                              -((this.height) * PILLAR_PITCH / 2),
                              -((PILLAR_HEIGHT) / 2));
    this.nodes = bundlePillars(this.pillars, 4);
  }

  private Pillar[][] mapToPillars (PImage map) {
    Pillar[][] pillars = new Pillar[this.width][this.height];

    map.loadPixels();
    for (int x = 0, w = this.width; x < w; x++) {
      for (int y = 0, h = this.height; y < h; y++) {
        int index = x + y * w;
        if (brightness(map.pixels[index]) < 127) {
          pillars[x][y] = new Pillar(x, y);
        }
      }
    }

    return pillars;
  }

  private ArrayList<Node> bundlePillars(Pillar[][] pillars, int bundleLength) {
    ArrayList<Node> nodes = new ArrayList<Node>();
    Node curNode = new Node(this.parent, 0);

    for (int i = 0; i < this.width; i++) {
      for (int j = 0; j < this.height; j++) {
        Pillar p = this.pillars[i][j];
        if (p != null) {
          if (curNode.pillars.size() + 1 > bundleLength) {
            nodes.add(curNode);
            curNode = new Node(this.parent, nodes.size());
          }
          curNode.register(this.pillars[i][j]);
        }
      }
    }

    if (!nodes.contains(curNode)) nodes.add(curNode);
    return nodes;
  }

  // -------------------------------------------------------------------------

  public void connect (int port) {
    UDP udp = new UDP(this.parent, port);
    for (Node n : this.nodes) n.connect(udp);
  }

  public void draw () { this.draw(true); }
  public void draw (boolean drawPillar) {
    for (Pillar[] rows : this.pillars) {
      for (Pillar p : rows) if (p != null) p.draw(drawPillar);
    }
  }

  public void drawFloor (boolean drawAsGrid, boolean showLight) {
    pushMatrix();
      pushStyle();
        translate(-PILLAR_PITCH / 2, -PILLAR_PITCH / 2);
        fill(10);
        noStroke();

        if (drawAsGrid) {
          noFill();
          stroke(255, 100);
          for (int i = 0; i < this.width; i++) line(i * PILLAR_PITCH, 0, i * PILLAR_PITCH, this.height * PILLAR_PITCH);
          for (int j = 0; j < this.height; j++) line(0, j * PILLAR_PITCH, this.width * PILLAR_PITCH, j * PILLAR_PITCH);
        }

        if (showLight) {
          pushStyle();
          noStroke();
          fill(30);
          pushMatrix();
          translate(0, 0, 2);
          for (int i = 0; i < this.width; i++) {
            for (int j = 0; j < this.height; j++) {
              Pillar p = this.get(i, j);
              if (p != null) {
                int o = int(p.getLightValue() * 255);
                pushStyle();
                noStroke();
                fill(255, o);
                rect(i * PILLAR_PITCH, j * PILLAR_PITCH, PILLAR_PITCH, PILLAR_PITCH);
                popStyle();
              }
            }
          }
          popMatrix();
          popStyle();
        }
        rect(0, 0, this.width * PILLAR_PITCH, this.height * PILLAR_PITCH);
      popStyle();
    popMatrix();
  }

  public Pillar get (int i, int j) {
    if (i >= 0 && i < this.width && j >= 0 && j < this.height) return this.pillars[i][j];
    else return null;
  }

  public void printNodesMapping () {
    JSONObject o = new JSONObject();
    for (Node node : this.nodes) {
      JSONArray pillars = new JSONArray();
      for (Pillar p : node.pillars) {
        IntList pos = new IntList();
        pos.append(p.i);
        pos.append(p.j);

        pillars.append(new JSONArray(pos));
      }
      o.setJSONArray(node.name, pillars);
    }

    println(o);
  }
}
