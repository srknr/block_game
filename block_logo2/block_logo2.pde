PImage img;         //read image file
PImage img2;
PGraphics[][] LogoBlock;
final int COL=9;
final int ROW=30;
int ww, hh, ww2, hh2;
color back_color = color(0,0,0,0);

// ブロックのパラメータ

int[] blockX = new int[ROW * COL];  // ブロックのx座標格納用の配列
int[] blockY = new int[ROW * COL];  // ブロックのy座標格納用の配列
color[] blockColor = new int[ROW * COL];
int first_block_x = 0;    // 最初のブロックのx座標
int first_block_y = 0;    // 最初のブロックのy座標
int block_width = 600/COL;      // ブロックの幅: 使いたい画像の幅/ブロックの行数
int block_height = 700/ROW;     // ブロックの高さ: 使いたい画像の高さ/ブロックの列数
int block_interval_x = (600/COL)+1; // ブロックの間隔(x方向)
int block_interval_y = (700/ROW)+1; // ブロックの間隔(y方向)

color block_color = 255;
color none_block  = color(0,255,255,0);//透明化
block[] blockList = new block[ROW * COL]; // ブロック描画用オブジェクトの宣言

// バーのパラメータ
int bar_width = 150; // バーの幅
int bar_height = 15;// バーの高さ
int bar_x = 200;    // バーのx座標
int bar_y = 800;    // バーのy座標
color bar_color = color(150, 0, 100); // バーの色

// ボールのパラメータ
float ball_dia = 12;                 // ボールの直径
float ball_x = bar_x + bar_width/2;  // ボールのx座標
float ball_y = bar_y - ball_dia/2;   // ボールのy座標
float vx = random(random(-4, -3),random(5, 3)); // ボールの速さ(x方向)
float vy = -5.5;  // ボールの速さ(y方向)

boolean start_click = false;
int score;

class ball{
  float x, y, r;
  color rgb;
  float vx, vy;
  
  ball(float ball_x,float ball_y, float ball_r){
    x=ball_x;
    y=ball_y;
    r=ball_r;
    rgb = color(255,0,0);
    vx=0;
    vy=0;
  }
}

class block{
  int x, y, w, h;
  color rgb;
  PImage bgImg;
  boolean visible;
  boolean blockType;
  color[] colorNum = {color(#ffffff), color(#000000)};
  int colorIndex = int(random(colorNum.length));
  int color_block = colorNum[colorIndex];
  
  
  block(int block_x, int block_y, int block_width, int block_height, color rgb_color, boolean block_type){
    x = block_x;
    y = block_y;
    w = block_width;
    h = block_height;
    rgb = rgb_color;
    visible = true;
    blockType = block_type;
    if(blockType){
      bgImg = img2.get(x,y,w,h);
    }
  }
  
  void check(){
    float r = ball_dia/2;
    if((x < ball_x+r && ball_x-r < x+w) && (y < ball_y+r && ball_y-r < y+h)){
      if(ball_x+r < x+vx || x+w+vx < ball_x-r){
        vx *= -1;
      }
      if(ball_y+r < y+vy || y+h+vy < ball_y-r){
        vy *= -1;
      }
      visible = false;
      score += 10;
    }
  }
  
  void show(){
    noStroke();  
    if(blockType){
      fill(color(255,255,255,255));
      rect(x, y, w, h);
      image(bgImg,x,y);
    }
    else{
      fill(colorNum[colorIndex]);
      rect(x,y,w,h);
    }
  }
}

void setup() {
  size(600, 890);
  img=loadImage("tree-illustration.jpg");
  img2=loadImage("Mobingi_logo_horizontal.png");
  img.resize(600, 890);
  img2.resize(600, 120);
  ww=img.width/COL;//ブロックの幅, 600/11
  hh=img.height/ROW;//ブロックの高さ, 120/10

  //for(int i=0; i<blockColor.length; i++){
  //  blockColor[i] = block_color;
  //}
  for(int y=0; y<ROW; y++){
   for(int x=0; x<COL; x++){
      int i = x + (y * COL);
      if(i<45){
        blockList[i] = new block(block_interval_x * x,block_interval_y * y,ww,hh,blockColor[i],true);
      }
      else{
        blockList[i] = new block(block_interval_x * x,block_interval_y * y,ww,hh,blockColor[i],false);
      }
    }
  }

}//end of set up


void draw(){
  background(0);
  image(img, 0, 0);
  
  for (int i=0; i<blockList.length; i++){
    if(blockList[i].visible){
      blockList[i].show();
      blockList[i].check();
    }
  }

 // バーの描画
  fill(200,155,155);  
  rect(bar_x, bar_y, bar_width, bar_height);
  bar_x = mouseX - bar_width/2;
 // bar_x = int(ball_x) - bar_width/2;//デバッグ用
  
  // バーが画面外にある場合の処理
  if(bar_x > width - bar_width){
    bar_x = width - bar_width;
  }
  if(bar_x < 0){
    bar_x = 0;
  }
  
   // ボールの描画
  fill(200, 0, 0);
  ellipse(ball_x, ball_y, ball_dia, ball_dia);
  // ボールの移動(速度分)
  if(start_click){
    ball_x += vx;
    ball_y += vy;
  }
  // ボールの処理(壁と衝突後)
  if( ball_x > width || ball_x < 0){
    vx *= random(-1,-1);
  }
  if( ball_y < 0){
    vy *= -1;
  }
  // ボールがバーより下ならゲームオーバー
  if( ball_y > height){
    text("Game Over", width/2 , height/2);
    text("Your Score:"+score, width/2 , height/2 + 30);
  }
  
    // バーにボールが衝突した場合の処理
  if(ball_x > bar_x-5 && ball_x < bar_x + bar_width+5){
    if(ball_y > bar_y && ball_y < bar_y + 6){
      vx += random(0.5,0.7);
      vy *= -1.01;
    }
  }
  
  text("Score: " + score, 500, 880);
  if(score == 2700){
   vx = 0;
   vy =0;
   text("FINISH!!! HAPPY NEW YEAR!!!", width/2, height/2);
  }
}

void mousePressed(){
  start_click = !start_click;
}
