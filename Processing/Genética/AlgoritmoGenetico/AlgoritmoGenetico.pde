//Array das imagens

PGraphics[] triangulo = new PGraphics[9];

//Posição cartesiana

float[][] x1 = new float[9][125];
float[][] y1 = new float[9][125];
float[][] x2 = new float[9][125];
float[][] y2 = new float[9][125];
float[][] x3 = new float[9][125];
float[][] y3 = new float[9][125];

//Variáveis do fill

float[][] huef = new float[9][125];
float[][] satf = new float[9][125];
float[][] brightf = new float[9][125];
float[][] opacityf = new float[9][125];

float[]votos = new float[9]; 
float[]lista_fim = new float[9]; 
//float[][] x1, float[][] y1, float[][] x2, float[][] y2, float[][] x3, float[][] y3, float[][] huef, float[][] satf, float[][] brightf, float[][] opacityf 
//float[][] x1, float[][] y1, float[][] x2, float[][] y2, float[][] x3, float[][] y3, float[][] huef, float[][] satf, float[][] brightf, float[][] opacityf 

//Variáveis de contagem

int i = 0;
int j = 0;


// tira a media de uma lista
float med (float[] lista){
  int d = 1, a;
  float somat = 0, med;
  for (a = 1; a < lista.length && lista[a] > -9000; a = a + 1){
    somat = somat + lista[a]; 
    d = d + 1;
  }
  med = somat/d;
  
  return med;
}


// essa funcao faz uma lista de medias com base em uma lista de uma lista de listas
float[] medl (float[][] lista){
  int b; 
  float[] medl = new float[lista.length];
  
  for (b = 0; b < lista.length; b = b + 1)
    medl[b] = med (lista [b]); 
  
  return medl;
}


// essa funcao da a lista do quadrado da porcentagem do desvio com base no maior valor.
float[] quadrado (float[] lista){
  float []dif = new float [lista.length +1];
  int a;
  
  //tira a diferencia 
  for (a = 0; a < lista.length; a = a + 1)
    if (lista[a] < med(lista))
      dif[a] = (med(lista) - lista[a]);
    else
      dif[a] = (lista[a] - med(lista));
      
  //deixa o resultado como um numero entre 0 e 1    
  for (a = 0; a < lista.length; a = a + 1)
    dif[a] = dif[a]/max(lista);
    dif[a] = sq(dif[a]);
    
  return dif;
}


//essa funcao calcula a "distancia"/diferenca de cada imagem e formatar o resultado em uma lista
float []distancia_quad (float[][] x1, float[][] y1, float[][] x2, float[][] y2, float[][] x3, float[][] y3, float[][] huef, float[][] satf, float[][] brightf, float[][] opacityf ){
  //float xl, yl, Widthl, Heightl, huel, satl, brigthl, opacityl, b; 
  int a;
  float []distancia = new float [x1.length];
  for (a = 0; a < x1.length; a = a + 1)
    distancia[a] = sqrt(quadrado (medl(x1))[a] + quadrado (medl(y1))[a] +quadrado (medl(x2))[a] + quadrado (medl(y2))[a] + quadrado (medl(x3))[a] +
    quadrado (medl(y3))[a] + quadrado (medl(huef))[a] + quadrado (medl(satf))[a] + quadrado (medl(brightf))[a] + quadrado (medl(opacityf))[a]);
    
  return distancia;
}


float [] distancia_final (float []distancia_lista, float []votos){
   float []distancia_final = new float [votos.length];
   int a;   
   
   for (a = 0; a < votos.length; a = a + 1)
     //distancia_final[a] = sqrt( sq(1 - d_l[a]) + sq(1 - votos[a]/max));  
     distancia_final[a] = sqrt( sq(distancia_lista[a]) + sq(votos[a]/max(votos))); //As distâncias serão baseadas tanto na diversidade das imagens quanto na porcentagem da votação
  return distancia_final;
}



//devolve uma lista crescente do ranking
int []rank (float []lista) {
    int a, b = 0, d, e;
    double c = 0;
    int [] rank = new int [lista.length];
    double []var = new double [lista.length];
    for (e = 0; e < lista.length; e = e + 1)
      var[e] = lista[e]; 

    for (a = 0; a < lista.length; a = a + 1){     
      for (c = 0, d = 0; d < lista.length; d = d + 1){
        if (var[d] > c){
          c = var[d];
          b = d;
        }
      }  
      rank[rank.length - 1 - a] = b;
      var[b] = 0;
    }
    
  return rank;
}

//Sorteia uma item da lista com base em pesos
int sorteio (float []lista){
   float soma = 0,
   k,
   t = 0;
   int r = -1,
   p = 0;
   for (int i = 0; i < lista.length; i = i + 1)
    soma = soma + lista[i]; 
   
   k = random (soma);
   
   for (int i = 0; i < lista.length && p == 0; i = i + 1){
      t = t + lista[i];
       if (k < t){
         r = i;
         p = 1;
       }
   }

  return r;
}






float [][] child (float[]px1, float[]py1, float[] px2, float[]py2, float[]px3, float[] py3, float[] phuef, float[]psatf, float[] pbrightf, float[] popacityf,
float[]mx1, float[]my1, float[] mx2, float[]my2, float[]mx3, float[] my3, float[] mhuef, float[]msatf, float[] mbrightf, float[] mopacityf){
  
    float child [][] = new float [10][125];  
    float k, y,
    mutacao;
    float[] cx1 = new float[125];
    float[] cy1 = new float[125];
    float[] cx2 = new float[125];
    float[] cy2 = new float[125];
    float[] cx3 = new float[125];
    float[] cy3 = new float[125];
    float[] chuef = new float[125];
    float[] csatf = new float[125];
    float[] cbrightf = new float[125];
    float[] copacityf = new float[125];

    for (int i = 0; i < 125; i = i + 1){
      //A criança recebe cada círculo ou inteiramente da mãe ou inteiramente do pai
      k = random (2.2);
      if (k < 1) {  
        cx1[i] = px1[i];
        cy1[i] = py1[i];
        cx2[i] = px2[i];
        cy2[i] = py2[i];
        cx3[i] = px3 [i];
        cy3[i] = py3[i];
        chuef[i] = phuef [i];
        csatf[i] = psatf [i];
        cbrightf[i] = pbrightf [i];
        copacityf[i] = popacityf[i];
      }
      else if (k > 1 && k < 2){
        cx1[i] = mx1[i];
        cy1[i] = my1[i];
        cx2[i] = mx2[i];
        cy2[i] = my2[i];
        cx3[i] = mx3 [i];
        cy3[i] = my3[i];
        chuef[i] = mhuef [i];
        csatf[i] = msatf [i];
        cbrightf[i] = mbrightf [i];
        copacityf[i] = mopacityf[i]; 
      }
      else {
        //acrecentar novas caracteristicas
        cx1[i] = random(900) - 90;
        cy1[i] = random(900) - 90;
        cx2[i] = random(900) - 90;
        cy2[i] = random(900) - 90;
        cx3[i] = random(900) - 90;
        cy3[i] = random(900) - 90;
        chuef[i] = random(360);
        csatf[i] = random(360);
        if (csatf[i] > 15 && csatf[i] < 40) csatf[i] = csatf[i] + 50;
        cbrightf[i] = random(100);
        copacityf[i] = random(100);
        if (copacityf[i] < 25){
          copacityf[i] = 0;
          cx1[i] = -90900;
          cy1[i] = -90900;
          cx2[i] = -90900;
          cy2[i] = -90900;
          cx3[i] = -90900;
          cy3[i] = -90900;
          chuef [i] = -90900;
          csatf [i] = -90900;
          cbrightf [i] = -90900;  
        }
      }
     
     //mutacao
     y = random(100);
     if (y < 15){
       mutacao = random(-10,10);
       cx1[i] =+ mutacao;
       mutacao = random(-10,10);
       cy1[i]=+ mutacao;
       mutacao = random(-10,10);
       cx2[i]=+ mutacao;
       mutacao = random(-10,10);
       cy2[i]=+ mutacao;
       mutacao = random(-10,10);
       cx3[i]=+ mutacao;
       mutacao = random(-10,10);
       cy3[i]=+ mutacao;
       mutacao = random(-5,5);
       chuef [i]=+ mutacao;
       if (chuef[i] > 360)
         chuef[i] %= 360;
       mutacao = random(-5,5);
       csatf [i]=+ mutacao;
       if (csatf[i] > 100)
         csatf[i] %= 100;
       mutacao = random(-5,5);
       cbrightf [i]=+ mutacao;
       if (cbrightf [i] > 100)
         cbrightf [i] = 100;
       mutacao = random(-5,5);
       copacityf[i]=+ mutacao;
       if (copacityf[i] > 100)
         copacityf[i] = 100;
     }      
        
    }
    
    child[0] = cx1;
    child[1] = cy1;
    child[2] = cx2;
    child[3] = cy2; 
    child[4] = cx3;
    child[5] = cy3;
    child[6] = chuef;
    child[7] = csatf;
    child[8] = cbrightf; 
    child[9] = copacityf;
  return child;
}






void setup() {
  size(720,720);
  
  while(i < 9){
    j = 0;
    while(j < 125){
    
      //Geração de variáveis aleatórias
    
      x1[i][j] = random(900) - 90;
      y1[i][j] = random(900) - 90;
      x2[i][j] = random(900) - 90;
      y2[i][j] = random(900) - 90;
      x3[i][j] = random(900) - 90;
      y3[i][j] = random(900) - 90;
      huef[i][j] = random(360);
      satf[i][j] = random(100);
      if (satf[i][j] > 15 && satf[i][j] < 40) satf[i][j] = satf[i][j] + 50;
      brightf[i][j] = random(100);
      opacityf[i][j] = random(100);
      if (opacityf[i][j] < 25) {
        opacityf[i][j] = 0;
        x1[i][j] = -90900;
        y1[i][j] = -90900;
        x2[i][j] = -90900;
        y2[i][j] = -90900;
        x3[i][j] = -90900;
        y3[i][j] = -90900;
        huef [i][j] = -90900;
        satf [i][j] = -90900;
        brightf [i][j] = -90900;  
      }
      
      
      j = j + 1;
    }
    i = i + 1;
  }

  int imagens = x1.length;
  
  for (int geracao = 0; geracao < 5; geracao++){
    i = 0;
    
    for (int k = 0; k < 9; k = k + 1)
      votos[k] = random (1000);
    
    while(i < 8){
      j = 0;
    
      //Gera imagens 720x720
      triangulo[i] = createGraphics(720,720,JAVA2D);
      triangulo[i].beginDraw();
    
      //Modo de Cor HSV
      triangulo[i].colorMode(HSB, 360, 100, 100, 100);
    
      //Background de cor aleatória
      triangulo[i].background(random(360), random(100), random(100), random(100));
    
      while (j < 125){  //Quantidade de triangulos
      
        triangulo[i].noStroke();
      
        //Desenha os triangulos
        triangulo[i].fill(huef[i][j], satf[i][j], brightf[i][j], opacityf[i][j]);
        triangulo[i].triangle(x1[i][j], y1[i][j], x2[i][j], y2[i][j], x3[i][j], y3[i][j]);
    
        j = j + 1;
      }
    
      triangulo[i].endDraw();
    
      //Salva as imagens
      triangulo[i].save("/Geracao" + geracao + "/Triangulos" + i + ".png");
    
      i = i + 1;
    }
    
    lista_fim = distancia_final(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf), votos); 
    int pai, mae,
    antpai = -1, antmae = -1;
    //println (lista_fim);
    for (int i = 0; i < imagens ; i = i + 1){
      float filho [][] = new float [10][125]; 
      //pai = sorteio(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf));
      pai = antpai;
      while (pai == antpai || pai == antmae){  
        pai = sorteio(lista_fim);
        //distancia_final(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf), votos)[pai] = 0.6*distancia_final(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf), votos)[pai];
        lista_fim[pai] = 0.7*lista_fim[pai];
      }
      mae = pai;
      
      //mae = sorteio(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf));
      while (mae == pai || mae == antpai || mae == antmae){
        //mae = sorteio(distancia_final(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf), votos));
        mae = sorteio(lista_fim);
        lista_fim[pai] = 0.7*lista_fim[pai];
      }
      
      filho = child(x1[pai], y1[pai], x2[pai], y2[pai], x3[pai], y3[pai], huef[pai], satf[pai], brightf[pai], opacityf[pai],
        x1[mae], y1[mae], x2[mae], y2[mae], x3[mae], y3[mae], huef[mae], satf[mae], brightf[mae], opacityf[mae]);
  
      x1[i] = filho[0];
      y1[i] = filho[1];
      x2[i] = filho[2];
      y2[i] = filho[3];
      x3[i] = filho[4];
      y3[i] = filho[5];
      huef [i] = filho[6];
      satf [i] = filho[7];
      brightf [i] = filho[8];
      opacityf[i] = filho[9];
      
      antpai = pai;
      antmae = mae;
      
      println (geracao + " pai = " + pai + " mae = " + mae);
      
    }
    
  }
  //Coloca a última imagem na janela
  image(triangulo[7], 0, 0);
}
  /*//println (rank(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf)));
  println (sorteio(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf)));
  println (sorteio(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf)));
  println (sorteio(distancia_quad (x1, y1, x2, y2, x3, y3, huef, satf, brightf, opacityf)));*/

        /*px1[]
        py1[]
        px2[]
        py2[]
        px3 []
        py3[]
        phuef []
        psatf []
        pbrightf []
        popacityf[]*/
