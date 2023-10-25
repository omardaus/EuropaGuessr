

final int WIDTH = 1280;
final int HEIGHT = 1024;

PImage menu;

String mode = "menu";

boolean mouseDown = false;

Game game2;
String cursor = "ARROW";

  void settings() {
  size(1280, 1024);
}

void setup() {

  menu = loadImage("../game2_img/menu.png");

  game2 = new Game();
}



void draw() {
  if (mode == "menu") {

    cursor = "ARROW";

    if (!mousePressed) {
      mouseDown = false;
    }

    image(menu, 0, 0);

    if (inBox(299, 438, 682, 148)) {
      cursor = "HAND";
      if (mousePressed && !mouseDown) {
        mouseDown = true;
        mode = "game2";
        game2.start();
      }
    }

    if (cursor == "ARROW") {
      cursor(ARROW);
    } else if (cursor == "HAND") {
      cursor(HAND);
    } else if (cursor == "CROSS") {
      cursor(CROSS);
    }
  } else if (mode == "game2") {
    game2.run();
    if (!game2.on()) {
      mode = "menu";
    }
  }
}

boolean inBox(float x, float y, float w, float h) {
  return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
}
