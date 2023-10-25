

class Game {
  
  HighscoreDatabase db = new HighscoreDatabase("game2.txt");

  private final int MAXDIST = 2000;

  private String[] names = new String[] {
    "Paris",
    "Helsinki",
    "Berlin",
    "Prag",
    "Warschau",
    "Rom",
    "Barcelona",
    "Hamburg",
    "Wien",
    "München",
    "Brüssel",
    "Kiew",
    "Lissabon",
    "Athen",
    "Amsterdam",
    "Budapest",
    "London",
    "Madrid",
    "Moskau",
    "Kopenhagen",
    "Monaco",
  };

  private int[][] citys = new int[][] {
    {799, 695}, // Paris
    {1110, 412}, // Helsinki
    {972, 618}, // Berlin
    {994, 680}, // Prag
    {1084, 612}, // Warschau
    {961, 867}, // Rom
    {782, 876}, // Barcelona
    {924, 597}, // Hamburg
    {1021, 719}, // Wien
    {950, 721}, // München
    {837, 657}, // Brüssel
    {1236, 623}, // Kiew
    {567, 908}, // Lissabon
    {1181, 943}, // Athen
    {850, 620}, // Amsterdam
    {1068, 731}, // Budapest
    {769, 630}, // London
    {677, 888}, // Madrid
    {1276, 495}, // Moskau
    {954, 541}, // Kopenhagen
    {876, 827}, // Monaco
  };

  private int[] last = new int[5];

  private PImage background, submitBG, saveBG, pick, cross;
  private PImage[][] imgs = new PImage[citys.length][4];

  private int city, cityImg, score, addToScore, vicinity, guesses, animationFrame;
  private float pickX, pickY;

  private boolean mouseDown = true;
  private boolean picked = false;
  private boolean keyDown = false;

  private String state = "home"; // home | play
  private String mode = "guess"; // guess | submit | finish
  private String user;
  private String cursor = "ARROW";

  public Game () {

    background = loadImage("../game2_img/background.png");
    submitBG = loadImage("../game2_img/background2.png");
    saveBG = loadImage("../game2_img/background3.png");
    cross = loadImage("../game2_img/cross.png");
    pick = loadImage("../game2_img/pick.png");

    for (int s = 0; s < imgs.length; s++) {
      for (int i = 0; i < 4; i++) {
        imgs[s][i] = loadImage("../game2_img/stadt/" + str(s) + "-" + str(i) + ".png");
        imgs[s][i].resize(509, 509);
      }
    }
  }

  // getter for game state
  public boolean on() {
    return state == "play";
  }

  public void start() {
    reset();
    state = "play";
    mode = "guess";
  }

  private void reset() {
    
    db.LoadDatabase();
    
    mouseDown = true;
    animationFrame = 0;
    guesses = -1; // wird auf 0 gesetzt durch nextCity()
    user = "noname";
    city = -9999; // -9999 existiert nicht
    score = 0;
    nextCity();

    // initialise last
    for (int i = 0; i < last.length; i++) {
      last[i] = -1;
    }
  }

  private boolean inHistory() {
    for (int i = 0; i < last.length; i++) {
      if (last[i] == city) {
        return true;
      }
    }
    return false;
  }

  private boolean inBox(float x, float y, float w, float h) {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  private void nextCity() {

    for (int i = last.length-1; i > 0; i--) {
      last[i] = last[i-1];
    }
    last[0] = city;

    int stop = 0;
    while (inHistory() && stop < 100) {
      city = int(random(0, names.length));
      stop++;
    }
    cityImg = 0;
    mode = "guess";
    picked = false;
    addToScore = 0;
    vicinity = 0;

    guesses++;
    if (guesses == 5) { // ANZAHL AN SPIELEN
      mode = "finish";
    }
  }

  private void nextImg() {
    cityImg++;
    if (cityImg > 3) {
      cityImg = 0;
    }
    println("next");
  }

  private void prevImg() {
    cityImg--;
    if (cityImg < 0) {
      cityImg = 3;
    }
    println("prev");
  }

  private void submit() {
    mode = "submit";

    int dist = round(dist(pickX, pickY, citys[city][0], citys[city][1]));
    vicinity = round(dist * 4.59);
    addToScore = max(0, MAXDIST - (dist*5));
    score += addToScore;
    
  }

  private void home() {
    state = "home";
  }

  private void saveToLB() {

    db.AddEntry(user, score);
    db.SaveDatabase();

    home();
  }

  private String removeLastCharacter(String str) {
    String result = "";
    if ((str != "") && (str.length() > 0)) {
      result = str.substring(0, str.length() - 1);
    }
    return result;
  }

  public void run() {
    if (state != "home") {
      update();
      draw();
    }
  }

  private void update() {
    cursor = "ARROW";

    if (!mousePressed) {
      mouseDown = false;
    }

    if (!keyPressed) {
      keyDown = false;
    }

    if (mode == "finish") {

      animationFrame++;

      // back to home
      if (inBox(26, 20, 85, 85)) {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          home();
        }
      }

      // save to leaderboard
      if (inBox(315, 700, 650, 106)) {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          saveToLB();
        }
      }

      // clear user
      if (inBox(1022, 421, 63, 63)) {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          user = "";
        }
      }

      // handle key input
      if (keyPressed && !keyDown) {
        keyDown = true;
        int i = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(key);

        if (keyCode == 37) {
          user = removeLastCharacter(user);
        } else if (i > -1 && user.length() < 22) {
          user += key;
        }
      }
    } else {

      animationFrame = 0;

      // left arrow handler
      if (inBox(75, 712, 152, 82)) {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          prevImg();
        }
      }

      // right arrow handler
      if (inBox(308, 711, 155, 84)) {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          nextImg();
        }
      }

      // back to home
      if (inBox(26, 20, 85, 85)) {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          home();
        }
      }

      // position guess
      if (mouseX > 539 && mouseY > 125 && mode == "guess") {
        // PICK LOCATION
        cursor = "CROSS";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          picked = true;
          pickX = mouseX;
          pickY = mouseY;
        }
      }

      // SUBMIT
      if (inBox(154, 830, 230, 65) && mode == "guess") {
        cursor = "HAND";
        if (mousePressed && !mouseDown && picked) {
          mouseDown = true;
          submit();
        }
      }

      // NEXT
      if (inBox(181, 830, 177, 65) && mode == "submit") {
        cursor = "HAND";
        if (mousePressed && !mouseDown) {
          mouseDown = true;
          nextCity();
        }
      }
    }
    
    if (cursor == "ARROW") {
      cursor(ARROW);
    } else if (cursor == "HAND") {
      cursor(HAND);
    } else if (cursor == "CROSS") {
      cursor(CROSS);
    }  
  }

  private void draw() {
    if (mode == "guess") {
      image(background, 0, 0);
    } else if (mode == "submit") {
      image(submitBG, 0, 0);

      // line from pick to reality
      stroke(255, 0, 0);
      strokeWeight(3);
      line(pickX, pickY, citys[city][0], citys[city][1]);

      // mark real location
      image(cross, citys[city][0] - 19, citys[city][1] - 15);
    } else if (mode == "finish") {
      image(saveBG, 0, 0);

      // score
      fill(255);
      textSize(46);
      textAlign(LEFT, CENTER);
      text(str(score), 332, 600);

      // user
      fill(0);
      textSize(46);
      text(user.toUpperCase(), 204, 450);
      int x = int(204 + textWidth(user.toUpperCase()) + 9); // for typing indicator

      // user length
      fill(133);
      textSize(12);
      textAlign(RIGHT, CENTER);
      text(str(user.length()), 1080, 496);

      // typing indicator
      stroke(133);
      fill(133);
      strokeWeight(3);
      if ((animationFrame / 30) % 2 == 0) {
        line(x, 433, x, 487);
      }
      noStroke();
    }



    if (mode != "finish") {

      // city img
      image(imgs[city][cityImg], 15, 140);

      // stecknadel
      if (picked) {
        image(pick, pickX - (pick.width / 2), pickY - pick.height);
      }


      // render score
      fill(0);
      textSize(46);
      textAlign(LEFT, CENTER);
      if (mode == "submit") {
        text(str(score) + " (+" + str(addToScore) + ")", 185, 958);
        // render city
        textAlign(CENTER, CENTER);
        text(names[city], 264, 677);
        // render vicinity
        fill(255, 0, 0);
        textSize(22);
        textAlign(LEFT, CENTER);
        text(str(vicinity) + "km", 32, 913);
      } else if (mode == "guess") {
        text(str(score), 185, 958);
      }
    }
  }
}
