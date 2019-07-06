import java.util.*;
import java.lang.reflect.Array; 

PImage background_img;
PrintWriter output;
ArrayList points = new ArrayList();
int previousX;
int previousY;
int point_count = 1;
float penstate = 0;

void setup() {
   size(400, 400);
   points.add(new float[]{0.0, 0.0, 0, 0.0});
   background(0);
   try {
     background_img = loadImage("background.jpg");
     image(background_img, 0, 0);
   } catch(NullPointerException e) {
     background(0);
   }
}

void draw(){
   
}

void mouseClicked() {
   if (mouseButton == LEFT) {
     points.add(new float[]{mouseX, mouseY, point_count, 1.0});
   } else if (mouseButton == RIGHT) {
     points.add(new float[]{mouseX, mouseY, point_count, 0.0});
   }
   
   if ((float)Array.get(points.get(point_count), 3) == 1.0) {
     stroke(255, 255, 255);
     line(previousX, previousY, mouseX, mouseY);
   }
   
   previousX = mouseX;
   previousY = mouseY;
   point_count ++;
}

void keyPressed() {
   output = createWriter("out.gcode");
   output.println("M300 S50");
   output.println("G00 X0.00 Y0.00");
   for (int i = 0; i < points.size(); i++) {
     if ((float)Array.get(points.get(i), 3) != penstate) {
       if (penstate == 0) {
         output.println("M300 S30");
         penstate = 1;
       } else {
         output.println("M300 S50");
         penstate = 0;
       }
     }
     output.print("G01 X");
     output.print((float)Array.get(points.get(i), 0) / 10);
     output.print(" Y");
     output.println(40 - ((float)Array.get(points.get(i), 1) / 10));
   }
   output.println("M300 S50");
   output.println("G00 X0.00 Y0.00");
   output.flush();
   output.close();
}
