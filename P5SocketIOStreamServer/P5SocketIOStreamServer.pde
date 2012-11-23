/*
 * A processing sketch which acts as the server for 
 * broadcasting frames from kinect over http using WebSockets.
 *
 * The sketch encodes the binary data of each frame 
 * into a base64 string and sends it to an opened http port.
 * 
 * @author Hamzeen. H.
 * @created 11-23-2012
 */
import SimpleOpenNI.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import javax.imageio.ImageIO;

import muthesius.net.*;
import org.webbitserver.*;
import jcifs.util.Base64;

WebSocketP5 socket;
SimpleOpenNI kinect;
PImage frame;

void setup() {
   size(640,480);
   frameRate(9);
   socket = new WebSocketP5(this, 8080 );
   try {
      kinect = new SimpleOpenNI(this);
      kinect.start();
      kinect.enableDepth();
      kinect.enableRGB();
    } 
    catch (Throwable t) {
    }
}

void draw() {
  kinect.update();
  frame = kinect.rgbImage();
  BufferedImage buffimg = new BufferedImage( width, height, BufferedImage.TYPE_INT_RGB);
  buffimg.setRGB( 0, 0, width, height, frame.pixels, 0, width );
  ByteArrayOutputStream baos = new ByteArrayOutputStream();

  try {
    ImageIO.write( buffimg, "jpg", baos );
  } catch( IOException ioe ) {
  }
  String b64image = Base64.encode( baos.toByteArray() );
  socket.broadcast( b64image );
  image(frame, 0, 0);
}

void stop(){
	socket.stop();
}

void websocketOnMessage(WebSocketConnection con, String msg){
	println(msg);
}
void websocketOnOpen(WebSocketConnection con){}
void websocketOnClosed(WebSocketConnection con){}
