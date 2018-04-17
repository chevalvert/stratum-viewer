import java.nio.charset.StandardCharsets;

public class Node {
  public String name, info;
  public ArrayList<Pillar> pillars;

  private UDP udp_tx, udp_rx;

  Node (PApplet parent, int id) {
    this.name = "fakenode_" + id;
    this.pillars = new ArrayList<Pillar>();

    int PORT_RX = 6000 + id;
    this.info = name + "//" + PORT_RX;

    this.udp_rx = new UDP(parent, PORT_RX);
    this.udp_rx.listen(true);
    this.udp_rx.setReceiveHandler("receiveHandler_" + id);
  }

  private void receive (byte[] buffer, String ip, int port) {
    if (buffer.length > 0) {
      println("receive: from " + ip + " on port " + port + " : " + buffer);
    }
  }

  public void register (Pillar p) { this.pillars.add(p); }

  public Node connect (UDP udp) {
    this.udp_tx = udp;
    this.sendInfo();
    return this;
  }

  public void update (byte[] incomingPacket) {
    // println("incomingPacket.length: "+incomingPacket.length);
    for (int x = 0; x < this.pillars.size(); x++) {
      Pillar p = this.pillars.get(x);
      if (p != null) {
        for (int i = 0; i < PILLAR_LEDS_LENGTH; i++) {
          for (int k = 0; k < 3; k++) {
            p.leds[i][k] = int(incomingPacket[(x * PILLAR_LEDS_LENGTH + i) * 3 + k]);
          }
        }
      }
    }

    this.sendInfo();
  }

  private void sendInfo () {
    if (this.udp_tx != null)
      this.udp_tx.send(this.info.getBytes(StandardCharsets.UTF_8));
  }
}
