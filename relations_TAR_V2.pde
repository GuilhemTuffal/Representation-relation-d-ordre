int n=5;
int[] nb={1, 1, 3, 19, 219, 4231, 130023};
PGraphics big;
float cote=50;
float fleche=cote/25.0;
int pos_x=0;
int pos_y=0;
int numero=0;
float[][] position;
boolean graphique=true;
boolean matrice=false;
boolean double_f=false;
int[] totaux;
int start=millis();
int nb_=n*(n-1)/2;//longueur de la relation
boolean[][] relation_;
int[] nb_rat;//nombre de relation à tester
int nb_afficher=0;
int num_global=0;

int pos(int a, int b) {
  return nb_-(n-a)*(n-1-a)/2+b-a-1;
}

int anti_pos0(int i) {
  int res=0;
  while (i>=nb_-(n-res)*(n-1-res)/2) {
    res++;
  }
  res--;
  if (relation_[i][1]) {
    return res;
  }
  return i-nb_+(n-res)*(n-res-1)/2+1+res;
}

int anti_pos1(int i) {
  int res=0;
  while (i>=nb_-(n-res)*(n-1-res)/2) {
    res++;
  }
  res--;
  if (relation_[i][1]) {
    return i-nb_+(n-res)*(n-res-1)/2+1+res;
  }
  return res;
}

void nombre_(float x, float y, boolean un) {
  big.stroke(0);
  big.fill(0);
  big.textSize(24);
  big.text(un?"1":"0", x, y);
}

void ligne(float x, float y, float x_, float y_) {
  big.pushMatrix();
  float x1=x*0.9+x_*0.1;
  float x2=x*0.1+x_*0.9;
  float y1=y*0.9+y_*0.1;
  float y2=y*0.1+y_*0.9;
  PVector vec =new PVector(x2-x1, y2-y1);
  float len =sqrt(pow((x_-x)*0.8, 2)+pow((y_-y)*0.8, 2));
  big.translate(x1, y1);
  big.rotate(vec.heading());
  big.line(0, 0, len, 0);
  big.line(len, 0, len - fleche, -fleche);
  big.line(len, 0, len - fleche, fleche);
  big.popMatrix();
}

void doubleligne(float x, float y, float x_, float y_) {
  big.pushMatrix();
  float x1=x*0.9+x_*0.1;
  float x2=x*0.1+x_*0.9;
  float y1=y*0.9+y_*0.1;
  float y2=y*0.1+y_*0.9;
  PVector vec =new PVector(x2-x1, y2-y1);
  float len =sqrt(pow((x_-x)*0.8, 2)+pow((y_-y)*0.8, 2));
  big.translate(x1, y1);
  big.rotate(vec.heading());
  big.line(0, 0, len, 0);
  big.line(len, 0, len - 8, -8);
  big.line(len, 0, len - 8, 8);
  big.popMatrix();
  big.pushMatrix();
  big.translate(x2, y2);
  vec=new PVector(x1-x2, y1-y2);
  big.rotate(vec.heading());
  big.line(len, 0, len - 8, -8);
  big.line(len, 0, len - 8, 8);
  big.popMatrix();
}

void dessine_g() {//dessine les graphes pour les relations antisymétrique ou total
  for (int i=0; i<n; i++) {
    position[i][0]=cos(TAU*float(i)/float(n))*3.0*cote/8.0+pos_x*cote;
    position[i][1]=sin(TAU*float(i)/float(n))*3.0*cote/8.0+pos_y*cote;
    croix(cos(TAU*float(i)/float(n))*3.0*cote/8.0+pos_x*cote, sin(TAU*float(i)/float(n))*3.0*cote/8.0+pos_y*cote);
  }
  for (int i=0; i<nb_; i++) {
    if (relation_[i][0]) {
      ligne(position[anti_pos0(i)][0], position[anti_pos0(i)][1], position[anti_pos1(i)][0], position[anti_pos1(i)][1]);
    } else if (double_f) {
      doubleligne(position[anti_pos0(i)][0], position[anti_pos0(i)][1], position[anti_pos1(i)][0], position[anti_pos1(i)][1]);
    }
  }
}

void croix(float x, float y) {
  big.point(x, y);
  big.point(x-1, y-1);
  big.point(x-1, y+1);
  big.point(x+1, y-1);
  big.point(x+1, y+1);
}

void dessine_m() {//dessine les graphes pour les relations antisymétrique ou total
  for (int i=0; i<n; i++) {
    position[i][0]=float(i-1)*cote/float(n+2)+pos_x*cote;
    position[i][1]=float(i-1)*cote/float(n+2)+pos_y*cote;
    nombre_(int(float(i-1)*cote/float(n+2)+pos_x*cote), int(float(i-1)*cote/float(n+2)+pos_y*cote), true);
  }
  for (int i=0; i<nb_; i++) {
    if (relation_[i][0]) {
      nombre_(position[anti_pos0(i)][0], position[anti_pos1(i)][1], true);
      nombre_(position[anti_pos1(i)][0], position[anti_pos0(i)][1], false);
    } else {
      nombre_(position[anti_pos1(i)][0], position[anti_pos0(i)][1], true);
      nombre_(position[anti_pos0(i)][0], position[anti_pos1(i)][1], true);
    }
  }
}

void graph() {
  if (graphique) {
    if (matrice) {
      dessine_m();
    } else {
      dessine_g();
    }
    pos_x++;
    if (pos_x>=ceil(sqrt(nb[n])) ||pos_x>=70) {
      pos_x=0;
      pos_y++;
    }
    if (pos_y>=70) {
      big.endDraw();
      big.save("resultat"+n+"/res"+numero);
      numero++;
      big = createGraphics(int(cote)*min(70, ceil(sqrt(nb[n]-4900*numero))), int(cote)*min(70, ceil(sqrt(nb[n]-4900*numero))));
      big.beginDraw();
      big.background(255);
      big.stroke(0);
      big.smooth();
      big.translate(cote/2, cote/2);
      pos_x=0;
      pos_y=0;
    }
  }
}
void augmente_T_A(int num, int k) {//Pour les relation totales ou antisymétriques
  if (!relation_[num][0]) {
    relation_[num][0]=true;
  } else if (!relation_[num][1]) {
    relation_[num][1]=true;
  } else {
    relation_[num][0]=false;
    relation_[num][1]=false;
    if (num+k<nb_ && nb_-(n-num_global)*(n-1-num_global)/2!=num) {
      augmente_T_A(num+k, k-1);
    }
  }
}

int i_v=0;
int j_v=0;
int k_v=0;
int i_j=0;
int j_k=0;
int i_k=0;

boolean verif_TAR(int max) {//Transitivité pour relation antisymetrique et reflexive
  for (i_v=0; i_v<max-1; i_v++) {
    for (j_v=i_v+1; j_v<max; j_v++) {
      i_j=nb_-(n-i_v)*(n-1-i_v)/2+j_v-i_v-1;
      k_v=max;
      j_k=nb_-(n-j_v)*(n-1-j_v)/2+k_v-j_v-1;
      i_k=nb_-(n-i_v)*(n-1-i_v)/2+k_v-i_v-1;
      if (relation_[i_j][0] & relation_[j_k][0] & relation_[j_k][1]==relation_[i_j][1] & (!relation_[i_k][0] | relation_[i_k][1]!=relation_[i_j][1])) {
        return false;
      } else if (relation_[i_k][0] & relation_[j_k][0] & relation_[i_k][1]!=relation_[j_k][1] & (!relation_[i_j][0] | relation_[i_j][1]!=relation_[i_k][1])) {
        return false;
      } else if (relation_[i_j][0] & relation_[i_k][0] & relation_[i_j][1]!=relation_[i_k][1] & (!relation_[j_k][0] | relation_[j_k][1]==relation_[i_j][1])) {
        return false;
      }
    }
  }
  return true;
}

boolean verif_TAR_N(int max) {//Transitivité pour relation antisymetrique et reflexive
  for (i_v=0; i_v<max-2; i_v++) {
    for (j_v=i_v+1; j_v<max-1; j_v++) {
      i_j=nb_-(n-i_v)*(n-1-i_v)/2+j_v-i_v-1;
      for (k_v=j_v+1; k_v<max; k_v++) {
        j_k=nb_-(n-j_v)*(n-1-j_v)/2+k_v-j_v-1;
        i_k=nb_-(n-i_v)*(n-1-i_v)/2+k_v-i_v-1;
        if (relation_[i_j][0] & relation_[j_k][0] & relation_[j_k][1]==relation_[i_j][1] & (!relation_[i_k][0] | relation_[i_k][1]!=relation_[i_j][1])) {
          return false;
        } else if (relation_[i_k][0] & relation_[j_k][0] & relation_[i_k][1]!=relation_[j_k][1] & (!relation_[i_j][0] | relation_[i_j][1]!=relation_[i_k][1])) {
          return false;
        } else if (relation_[i_j][0] & relation_[i_k][0] & relation_[i_j][1]!=relation_[i_k][1] & (!relation_[j_k][0] | relation_[j_k][1]==relation_[i_j][1])) {
          return false;
        }
      }
    }
  }
  return true;
}
void affiche() {
  if (nb_afficher<50) {
    for (int i=0; i<nb_; i++) {
      print(relation_[i][0], ',', relation_[i][1], "; ");
    }
    println("");
    nb_afficher++;
  }
}
void affiche_temp(int temp) {
  if (temp==1) {
    print(temp, " ");
    for (int i=0; i<nb_; i++) {
      print(relation_[i][0]?( relation_[i][1]?2:1):0, "; ");
    }
    println("");
    nb_afficher++;
  }
}

void init() {
  nb_rat=new int[n];
  for (int i=0; i<n; i++) {
    nb_rat[i]=int(pow(3, i+1));
  }
  printArray(nb_rat);
  totaux=new int[n];
  totaux[0]=1;
  pos_x=0;
  pos_y=0;
  if (graphique) {
    big = createGraphics(int(cote)*min(70, ceil(sqrt(nb[n]))), int(cote)*min(70, ceil(sqrt(nb[n]))));
    big.beginDraw();
    big.background(255);
    big.stroke(0);
    big.smooth();
    big.translate(cote/2, cote/2);
  }
  position=new float[n][2];
  relation_=new boolean[nb_][2];
}


void affiche_T() {
  println(" ");
  for (int i=0; i<totaux.length-1; i++) {
    print(totaux[i], ',');
  }
  println(totaux[totaux.length-1]);
}

void fin() {
  if (graphique) {
    big.endDraw();
    big.save("resultat"+n+"/res"+(matrice?"m":(double_f?"":"f")));
  }
  affiche_T();
  println(millis()-start);
  exit();
}

void milieu_TAR(int num_) {
  if (num_==0) {
    for (int i=0; i<nb_rat[num_]; i++) {
      if (verif_TAR(num_+2)) {
        totaux[num_+1]++;
        milieu_TAR(num_+1);
      }
      num_global=num_;
      augmente_T_A(num_, n-2);
    }
  } else if (num_!=n-2) {
    for (int i=0; i<nb_rat[num_]; i++) {
      if (verif_TAR(num_+1)) {
        totaux[num_+1]++;
        milieu_TAR(num_+1);
      }
      num_global=num_;
      augmente_T_A(num_, n-2);
    }
  } else {
    for (int i=0; i<nb_rat[num_]; i++) {
      if (verif_TAR(n-1)) {
        totaux[num_+1]++;
        graph();
      }
      num_global=num_;
      augmente_T_A(num_, n-2);
    }
  }
}

void setup() {
  init();
  milieu_TAR(0);
  fin();
}
