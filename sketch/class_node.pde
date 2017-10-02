public class Node {
  public JSONObject info;

  Node (String name) {
    this.info = new JSONObject();

    this.info.setString("name", name);
    this.info.setInt("processing", 0);
    this.info.setInt("dataRate", 10);
  }

  Node connect (String ip, int port) {
    udp.send(this.info.toString().getBytes(StandardCharsets.UTF_8), ip, port);
    return this;
  }
}
