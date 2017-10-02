import hypermedia.net.*;
import java.nio.charset.StandardCharsets;

UDP udp;
Node node;

void setup() {
  udp = new UDP(this, 6000);
  udp.log(true);
  udp.listen(true);

  node = new Node("fakeNode" + frameCount).connect("localhost", 3737);
}

void draw() {;}

void keyPressed () {
  node = new Node("fakeNode" + frameCount).connect("localhost", 3737);
}
