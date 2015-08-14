import java.io.File;
import controlP5.*;
import java.util.regex.*;
import java.util.regex.MatchResult;
import java.util.Collections;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

PrintWriter output;
String dir ;

String[]fileNames;
StringList fileNames2 = new StringList();
StringList fileNames2pfad = new StringList();
IntDict rating = new IntDict();

String status = "willkommen"; 
int count = 0;
int zaehler = 0;
String typing = "";
int counti = 0;
int counter = 0;
int counter2 = 0;
String textstring = "";
int textanzahl;
int t1 = 0;
int t2 = 1;

int size = 0;
int size2 = 0;
int wiederholungen = 0;
int wert1;
int wert2;
int wert3;
StringList texte = new StringList();
StringList texte2 = new StringList();
StringList textnamen = new StringList();
StringList anno = new StringList();
IntList reihenfolge_alt = new IntList();
int anzahlpaare_end;

// neue Variablen
ArrayList<Ergpaar> ergebnisse1 = new ArrayList<Ergpaar>();
ArrayList<Ergpaar> ergebnisse2 = new ArrayList<Ergpaar>();
int day = day();
int month = month(); 
int year = year(); 
String strday = String.valueOf(day);
String strmonth = String.valueOf(month);
StringDict korpus = new StringDict();
File korpusdatei;
File ergebnissdatei;
int start_text = 0;
int end_text = 0;
ControlP5 cp5;
RadioButton r;
boolean regular = false;
boolean counts = false;
//IntList reihenfolge = new IntList();
ArrayList<Tuple> reihenfolge = new ArrayList<Tuple>();
StringDict texto = new StringDict();
IntList annoergebniss = new IntList();
IntList annoergebnisse2 = new IntList();
IntList anno2texte = new IntList();
Tuple tupeltext = new Tuple();


//kappa variablen
int gemeinsamrelevant = 0;
int a1_1 = 0;
int a1_0 = 0;
int a2_1 = 0;
int a2_0 = 0;
float pa;
float pe;
float kappa;

// Modi-variablen
String modus = "";
int anzahlshuffletexte;
IntList textliste = new IntList();
ArrayList<Tuple> newreihe;
PrintWriter listendatei;

void setup() {
  size(1300,800);
  PFont font = createFont("arial",20);
  cp5 = new ControlP5(this);
  
  
    background(0);
    rect(400,20,500,20);
    rect(400,200,500,20);
    textSize(27);
    text("Anno 2.0",590,100);
    text("Korpus-Annotations-Tool",490,150);
    textSize(15);
    text("Drücken sie 'o' und wählen sie die Korpus.txt Datei aus."
    +"\n"+"Die Korpsudatei muss alle Texte enthalten, die zu annotieren sind."
    +"\n"+"Sie werden danach die Anleitung zur Annotation sehen.",450,400);
  
}
 
void draw() {
  
  if (status == "Annotation"){
    cp5.hide();
    background(255);
    if(modus == "regular"){
      text("Textpaar : "+(count+1)+"/"+anzahlpaare_end,600,500);
      } 
    if(modus == "shuffle"){
      text("Textpaar : "+(count+1)+"/"+anzahlshuffletexte,600,500);
    }
      text("TextA",230,150);
      text(korpus.get(str(reihenfolge.get(t1).get0())),60,200);
      text("TextB",950,150);
      text(korpus.get(str(reihenfolge.get(t1).get1())),770,200);
      text("Drücken sie 'a' für TextA oder 'b' für TextB",500,70);
      status = "gedrückt";
  } 

  if (status == "Ende"){
    background(0);
    //println(rating);
    fill(255);
    textSize(15);
    text("Annotatins-Ende",570,300);
    rating.sortValuesReverse();
    textSize(13);
    text("Drücken sie ' f ' um die Annotations zu beenden und die Ergebnisse zu speichern.",430,400);
    status = "speichern";
  }
  if (status =="EndeAnno"){
    background(255);
    fill(0);
    text("Um den Cohens-Kappa Wert mit anderen Ergebnissen zu überprüfen bitte 'o' drücken"
    +"\n"+" und die entsprechende Ergebnissdatei einlesen"
    +"\n"+"\n"+"Um die Annoatation zu beenden drücken Sie 'e'."
    +"\n"+"Die Ergebnissdatei finden Sie im entpsrechenden Ordner",500,500);
  }

} 

void keyPressed() {
  // Status Willkommen
  if ((key == 'o') && (status == "willkommen")){
    selectInput("Korpusdatei auswählen :", "fileSelected");
    status = "anleitung";    
  }
  if ((key == ' ') && (status == "anleitung")){
    cp5.show();
        // nächster Frame kommt :
    background(255);
    
    fill(0);
    textSize(17);
    text("Annotation zur Textqualität",515,50);
    textSize(12);
    text("Anleitung",200,140);
    text("Richtlinien zur Annotation",900,140);
    text("Sie werden immer Textpaare zu sehen bekommen. Einen Text A und"
    +"\n"+"einen Text B. Ihre Aufgabe ist es zu entscheiden, welchen Text Sie für"
    +"\n"+"qualitativ hochwertiger halten. Um Ihre Entscheidung zu bestätigen,"
    +"\n"+"drücken Sie die Taste 'a' für den Text A und 'b' für den Text B.",60,200);
    text("Lesen Sie sich die beiden Texte in Ruhe durch und entscheiden Sie erst dann. Zur leichteren"
    +"\n"+ "Entscheidungsfindung, sollten sie auf Merkmale wie Lesbarkeit und Verständlichkeit achten.",700,200);

    text("Beispielsätze :"+"\n"+"\n"+"'Dieser Tag ist Rudolf.'"
   +"\n"+"Obwohl dieser Satz grammatikalisch korrekt gebildet wurde, ist seine Verständlichkeit sehr schlecht."
   +"\n"+"\n"+"'Heute ist Freitag. Darüber freue ich mich.'"
   +"\n"+"Dieser Satz liefert eine gute Verständlichkeit. Das Pronominaladverb darüber verbindet die beiden" 
   +"\n"+"Sätze miteinander und trägt positiv zum Verständnis bei."
   +"\n"+"\n"+"'Ich weiß, dass ich nichts weiß.'"
   +"\n"+"In diesem Satz spielt ein Konnektor eine positive Rolle, im Bezug auf die Verständlichkeit."
   +"\n"+"\n"+"'Er hat das im Laufe der Jahre stark heruntergekommene Fahrrad, das er damals zur Kommunion"
   +"\n"+"geschenkt bekommen hatte, dem Kind gegeben.'"
   +"\n"+"'Ihr solltet jetzt wegfahren, weil ihr, wenn ihr noch lange wartet, im Stau stehen werdet'"
   +"\n"+"Die beiden Sätze spiegeln unnötig komplizierte Wort- und Satzstellungen wieder. Erschwert die"
   +"\n"+"Lesbarkeit und verringert das Verständnis."
   +"\n"+"\n"+"'Wer das behauptet, lügt. vs Er lügt.'"
   +"\n"+"1. Satz komplexer Aufbau, 2. Satz einfacher Aufbau. Der Einfache Aufbau führt zu mehr Lesbarkeit"
   +"\n"+"und zu mehr Verständniss.",700,250);
  line(700,325,1280,325);
  line(700,400,1280,400);
  line(700,455,1280,455);
  line(700,570,1280,570); 
  line(700,650,1280,650);
  line(60,300,500,300); 
  text("Auswahl des Textbereichs",200,335);
  text("Anzahl der Texte im Korpus: "+(korpus.size()),60,380); 
  text("Bitte geben Sie den Bereich der Texte für die Annotation an"
   +"\n"+"und bestätigen Sie mit ENTER."
   +"\n"+"Beispiel: 1-10 oder 3-5",60,420);
 
     cp5.addTextfield("input")
     .setPosition(60,470)
     .setSize(200,40)
     .setFocus(true)
     .setColor(color(255,0,0));
      
     cp5.addTextfield("input2")
     .setPosition(60,520)
     .setSize(200,40)
     .setFocus(true)
     .setColor(color(255,0,0));
     
     r = cp5.addRadioButton("radioButton")
       .setPosition(300,470)
       .setSize(40,20)
       .setItemHeight(40)
       .setSpacingRow(10) 
       .setColorForeground(color(120))
       .setColorActive(color(100))
       .setColorLabel(color(100))
       .setItemsPerRow(1)
       .addItem("regular",1)
       .addItem("shuffle",2)
       .addItem("shuffle mit Liste",3);
       

       
         
//    switch(key) {
//    case('0'): r.deactivateAll(); break;
//    case('1'): r.activate(0); break;
//    case('2'): r.activate(1); break;
//    }
   status = "anleitungfertig";
  
  }
  
  
  // Status Annotation
  
  // reihenfolge der Textpaare wird festgelegt
  if ((key == 'l') && (status == "anleitungfertig")){
    // werte werden neu initialisiert für jeden Durchgang,
    // damit die benötigetn variablen wieder auf 0 gesetzt werden.
    gemeinsamrelevant = 0;
    a1_0 = 0;
    a1_1 = 0;
    a2_0 = 0;
    a2_1 = 0;
    reihenfolge.clear();
    anno.clear();
    rating.clear();
    annoergebniss.clear();
    annoergebnisse2.clear();
    t1=0;
    t2=1;
    count = 0;
    textliste.clear();
    if(modus=="regular"){
      if(start_text == 0 && end_text ==0){
        text("Bitte geben Sie zuerst einen korrekten Bereich im Zahlenfeld an"+
        "\n"+"bevor Sie die Annotation starten",200,570);
       
      }
      else{
        for(int i = start_text; i< end_text;i++){
          wert1 = i;
          for(int u = i+1; u<= end_text;u++){
            //println(i);
            wert2 = u;
            Tuple tupeltexte = new Tuple(wert1,wert2);
            reihenfolge.add(tupeltexte);
            
          }
        //
        //Die Liste Reihenfolge, in der alle Tupelpaare stehen, (also die Textpaare)
        // wird hier zufällig durchgemischt, damit die Reihenfolge, in der die Annotierenden
        // die Textpaare sehen werden, rein zufällig ist.
        }
        Collections.shuffle(reihenfolge);
        for(int i=0;i<reihenfolge.size();i++){
         println("Tupelpaar "+i+": "+reihenfolge.get(i).get0()+","+reihenfolge.get(i).get1());
        }
     // textnamen werden festgelegt
       for(int i = start_text; i<= end_text; i++){
         texto.set(str(i),"Text "+str(i)); 
       }
       println(texto);
    // rating dic wird initialisiert
       for(int i = start_text; i<=end_text;i++){
         rating.set(texto.get(str(i)),0);
       }
       println("rating"+rating);
       println(korpus);
       //println(korpus.get(str(reihenfolge.get(3))));
        status = "Annotation";
      }
    }
    if(modus=="shuffle"){
      for(int i = 0; i< korpus.size();i++){
          wert1 = i;
          for(int u = i+1; u<= korpus.size();u++){
            //println(i);
            wert2 = u;
            Tuple tupeltexte = new Tuple(wert1,wert2);
            reihenfolge.add(tupeltexte);
            
          }
        }
         //
        //Die Liste Reihenfolge, in der alle Tupelpaare stehen, (also die Textpaare)
        // wird hier zufällig durchgemischt, damit die Reihenfolge, in der die Annotierenden
        // die Textpaare sehen werden, rein zufällig ist.
       Collections.shuffle(reihenfolge);

     // textnamen werden festgelegt, sowie das Rating dic gefüllt, das passiert hier ein wenig anders als oben
     // im regular modus, anschließend wird die Reihenfolgeliste neu gefüllt, damit sie bloß die Paare enthaellt,
     // die auch annotiert werden sollen.
       
       println(anzahlshuffletexte);
       
       for(int i=0;i<anzahlshuffletexte;i++){
         println("text: " +reihenfolge.get(i).get0()+"text: "+reihenfolge.get(i).get1());
         if(!textliste.hasValue(reihenfolge.get(i).get0())){
           textliste.append(reihenfolge.get(i).get0());
         }
         if(!textliste.hasValue(reihenfolge.get(i).get1())){
           textliste.append(reihenfolge.get(i).get1());
         }
       }
       println(textliste);
       
       for(int i = 0; i< textliste.size(); i++){
         texto.set(str(textliste.get(i)),"Text "+str(textliste.get(i)));
         rating.set("Text "+str(textliste.get(i)),0);
       }
       
       //reihenfolge wird geleert und neu eingelesen mti den TUpelpaaren, die annotiert werden sollen
       // zu erst wird eine exakte Kopie der Liste angestellt, bakcup für Listendatei
       newreihe = new ArrayList<Tuple>(reihenfolge);
       println("reihenfolge size old"+reihenfolge.size());
       reihenfolge.clear();
       println("newreihe size"+newreihe.size());
       println("reihenfolge size"+reihenfolge.size());
       
       for(int i = 0; i< (textliste.size()-1);i = i+2){
         Tuple tupeltexte = new Tuple(textliste.get(i),textliste.get(i+1));
         reihenfolge.add(tupeltexte);
       }
       
       // Print Befehl der neuen Reihenfolge liste
       for(int i=0;i<reihenfolge.size();i++){
         println("Tupelpaar "+i+": "+reihenfolge.get(i).get0()+","+reihenfolge.get(i).get1());
        }
       println("texto: "+texto);
       
    // rating dic wird initialisiert
//       for(int i = 0; i<= textliste.size();i++){
//         rating.set(texto.get(str(i)),0);
//       }
       println("rating: "+rating);
       //println(korpus);
       //println(korpus.get(str(reihenfolge.get(3))));
        status = "Annotation";
      
      
    }
  }
  

  if ((key == 'a') && (status == "gedrückt")){
    //println("gedrückt");
    count = count +1;
    //println("ccc",count);
    rating.add(texto.get(str(reihenfolge.get(t1).get0())),1);
    anno.append(texto.get(str(reihenfolge.get(t1).get0()))); // a drücken =  1. Text wird ausgewählt
    anno.append(texto.get(str(reihenfolge.get(t1).get1())));
    annoergebniss.append(0);
    //if(count==(reihenfolge.size()/2)){
    if(count==reihenfolge.size()){
      status = "Ende";
    }
    else{
      t1 = t1 +1;
    //t1 = t1 +2;
    //t2 = t2 +2;
    println("t1 "+t1);
    status = "Annotation";
    }
  }
  
  if ((key == 'b') && (status == "gedrückt")){
    //println("gedrückt");
    count = count +1;
    //println("ccc",count);
    rating.add(texto.get(str(reihenfolge.get(t1).get1())),1);
    anno.append(texto.get(str(reihenfolge.get(t1).get0())));
    anno.append(texto.get(str(reihenfolge.get(t1).get1()))); // b drücken =  2. Text wird ausgwählt
    annoergebniss.append(1);
    //if(count==(reihenfolge.size()/2)){
    if(count==reihenfolge.size()){  
      status = "Ende";
      
    }
    else{
    t1 = t1 +1;
    //t1 = t1 +2;
    //t2 = t2 +2; 
    println("t1 "+t1);
    status = "Annotation";
    }
  }
  if ((key == 'f') && (status == "speichern")){
    if(day<10){
      strday = "0"+strday;
    }
    if(month<10){
      strmonth = "0"+strmonth;
    }
    if(modus == "regular"){
      output = createWriter(strday+strmonth+String.valueOf(year)+"_"+"Annotation"+"_Jan_"+start_text+"_"+end_text+".txt");
      output.println("Annotations-Ergebnisse");
      output.println(" ");
      for(int i =start_text;i<=end_text;i++){
        output.println("Text "+i+": "+rating.get(texto.get(str(i))));
      }  
    }
    println("new rating"+rating);
    if(modus == "shuffle"){
      //Listendatei schreiben : alle Tupelpaare die noch nciht annotiert wurden
      listendatei = createWriter(strday+strmonth+String.valueOf(year)+"_Listendatei.txt");
      for(Tuple i : reihenfolge){
        for(int u= 0; u< newreihe.size();u++){
          if(i.get0()==newreihe.get(u).get0()&&i.get1()==newreihe.get(u).get1()){
            newreihe.remove(u);
          }
        }
      }
      println(newreihe.size());
      //println("last 0 "+newreihe.get(113044).get0()+"last 1 "+newreihe.get(113044).get1());
      for(int i=0; i<newreihe.size();i++){
        listendatei.println("(Text "+str(newreihe.get(i).get0())+" -- Text "+str(newreihe.get(i).get1())+")");
        //println("(Text "+str(newreihe.get(i).get0())+" -- Text "+str(newreihe.get(i).get1())+")");
      }
      listendatei.flush();
      listendatei.close();
      
      output = createWriter(strday+strmonth+String.valueOf(year)+"_"+"Annotation"+"_Jan.txt");
      output.println("Annotations-Ergebnisse");
      output.println(" ");
      for(String i : rating.keys()){
        output.println(i+": "+rating.get(i));
      }
    }
    
    output.println(" ");
    output.println("Textpaare");
    output.println(" ");
    int annotation = 0;
    for(int i=0;i<anno.size();i= i+2){
      Matcher matcher = Pattern.compile("Text (\\d+)").matcher(anno.get(i));
      Matcher matcher1 = Pattern.compile("Text (\\d+)").matcher(anno.get(i+1));
      if(matcher.find()&& matcher1.find()){
        //println("#########");
        //println("text1: "+matcher.group(1)+" text2: "+matcher1.group(1)+ "   "+annoergebniss.get(annotation));
        Ergpaar paar = new Ergpaar(int(matcher.group(1)),int(matcher1.group(1)),annoergebniss.get(annotation));
        ergebnisse1.add(paar);
      }
      output.print(anno.get(i)+", "+anno.get(i+1)+"\t"+"\t"+annoergebniss.get(annotation));
      output.println(" ");
      annotation = annotation +1;
  }
    //println("#########opopo"+ergebnisse1);
    //println(anno.size());
    //println(annoergebniss);
    output.close();
    status = "EndeAnno";
  
  }
    if ((key == 'e') && (status == "EndeAnno")){
    exit();
    
  }
  if ((key == 'o') && (status == "EndeAnno")){
    selectInput("Ergebnissdatei auswählen :", "fileSelected2");
    status = "Kappa";
    
  }
    if ((key == 'k') && (status == "Kappa")){
      boolean gleicheTexte = true;
      int laufvar = 0;
      println("anno2texte"+anno2texte);
      println(annoergebniss);
      println(annoergebnisse2);
      for(int i =start_text; i<=end_text;i++){
        println("laufvar"+laufvar);
        if(anno2texte.get(laufvar)!= i){
          println("######ungleich####");
          gleicheTexte = false;
          break;
        }
        laufvar = laufvar +1 ;
      }
      if((annoergebniss.size()!=annoergebnisse2.size()|gleicheTexte == false)){
        text("Die Ergebnissdatei enthällt falsche Annotationen",500,30);
        selectInput("Ergebnissdatei auswählen :", "fileSelected2");
        //status = "EndeAnno";
      }
      else{
        println(annoergebniss);
        println(annoergebnisse2);
        for(int i =0;i<annoergebniss.size();i++){
          int t1 = ergebnisse1.get(i).gett1();
          int t2 = ergebnisse1.get(i).gett2();
          int erg = ergebnisse1.get(i).geterg();
          for(Ergpaar k:ergebnisse2){
            if(t1 == k.gett1() && t2 == k.gett2() && erg == k.geterg()){
              gemeinsamrelevant = gemeinsamrelevant+1;
              println(gemeinsamrelevant);
            }
          }
        
          //if(annoergebniss.get(i)==annoergebnisse2.get(i)){
            //gemeinsamrelevant = gemeinsamrelevant +1;
         
          if(annoergebniss.get(i)== 1){
            a1_1 = a1_1 +1;
          }
          if(annoergebniss.get(i)== 0){
            a1_0 = a1_0 +1;
          }
          if(annoergebnisse2.get(i)== 0){
            a2_0 = a2_0 +1;
          }
          if(annoergebnisse2.get(i)== 1){
            a2_1 = a2_1 +1;
          }
        }
        println("gemeinsam ", gemeinsamrelevant);
        println("a1_1 ", a1_1);
        println("a1_0 ", a1_0);
        println("a2_1 ", a2_1);
        println("a2_0 ", a2_0);
        pa = float(gemeinsamrelevant)/float(annoergebniss.size());
        println("pa "+pa);
        pe = ((float(a1_1)/float(annoergebniss.size()))*(float(a2_1)/float(annoergebniss.size())))
            +((float(a1_0)/float(annoergebniss.size()))*(float(a2_0)/float(annoergebniss.size())));
            println("pe "+pe);
        kappa = (pa-pe)/(1-pe);
        println("kappa "+kappa);
        text("Der Kappa-Wert beträgt: "+kappa,600,600);
        if(kappa<=0.80){
            text("Kappa wert zu niedrig bitt erneut annotieren",650,650);
            text("Dafür Space drücken",670,670);
            status= "anleitung";
        }
      }
    }  
}
void fileSelected2(File selection) {
  if (selection == null) {
    text("Sie haben keine Ergebnissdatei ausgewählt, bitte wählen sie eine Ergebniss.txt-Datei aus",800,800);
    selectInput("Korpusdatei auswählen :", "fileSelected");
  } else {
    
    dir = selection.getAbsolutePath();
    ergebnissdatei = new File(dir);
    String[] myErgebnissText = loadStrings (ergebnissdatei);
    for (int u=0; u < myErgebnissText.length; u++) {
      println("myergebnisse"+myErgebnissText[u]);
      Matcher matcher = Pattern.compile("Text (\\d+), Text (\\d+)\\t\\t(\\d)").matcher(myErgebnissText[u]);
      if(matcher.find()){
      println("text: "+matcher.group(1));
      println("text2: "+matcher.group(2));
      println("ergebniss "+matcher.group(3));
      Ergpaar paar = new Ergpaar(int(matcher.group(1)),int(matcher.group(2)),int(matcher.group(3)));
      ergebnisse2.add(paar);
      annoergebnisse2.append(int(matcher.group(3)));
      }
      Matcher matcher2 = Pattern.compile("Text (\\d+): \\d+").matcher(myErgebnissText[u]);
      if(matcher2.find()){
      println("matcher group ### "+matcher2.group(1));
      anno2texte.append(int(matcher2.group(1)));
      }
    }
    text("Ergebnissdatei eingelesen, bitte k drücken um cohens Kappa wert auszurechnen",200,200);
    //println(annoergebnisse2);
  }
}
void fileSelected(File selection) {
  // Korpusdatei auswählen und einlesen
  
  // speicher den Pfad der ausgewählten Datei in der Variable dir.
  if (selection == null) {
    text("Sie haben keine Korpusdatei ausgewählt, bitte wählen sie eine .txt-Datei aus",800,800);
    selectInput("Korpusdatei auswählen :", "fileSelected");
  } else {
    dir = selection.getAbsolutePath();
    println(dir);
    korpusdatei = new File(dir); // korpusdatei wird neues Objekt vom Typ File

    // korpus datei wird eingelesen und in ein String Dic geschrieben
    // "ID" : "Text"
    // Der Text wird noch mit Zeilenumbrüchen versehen,
    // damit er besser dargestellt wird.
   String regex2 = "\\t\\t";
   String text = "";
   String[] myText = loadStrings (korpusdatei);
   //println("len"+myText.length);
    for (int u=0; u < myText.length; u++) {
      String [] splitresult = myText[u].split(regex2);
      int textid = int(splitresult[0]);
      String [] wordlist = splitresult[1].split(" ");
      for(int k=0;k<wordlist.length;k++){
        text += wordlist[k]+" ";
        if(k!=0&&k%10==0){
          text += "\n";
        }
      }
      
      korpus.set(str(textid),text);
      text = "";
  //  println(korpus);

    }
    //println(korpus.get("0"));
    //println(korpus.get("1"));
    //println("#####sizes"+korpus.size());
    text("Korpusdatei erfolgreich eingelesen",550,600);
    text("drücken Sie 'SPACE' um zur Anleitung zu gelangen",500,620);
    //println(korpus.get("0"));
  }
}
 // automatically receives results from controller input
public void input(String theText) {
  if(modus=="regular"){
  // Mit regulärem ausdruck die beiden Zahlen filtern aus dem Eingabefeld
  StringList inputs = new StringList();
  Matcher matcher = Pattern.compile("\\d+").matcher(theText);
  while (matcher.find()) {
    inputs.append(matcher.group());
  }
  start_text = int(inputs.get(0));
  end_text = int(inputs.get(1));
  //println("start: "+ start_text);
  //println("end: "+ end_text);
  fill(255);
  rect(60,620,240,50);
  fill(0);
  text("Sie Annotieren die Texte: "+start_text+" - "+end_text,65,660);
  int anzahltextanno = 0;
  for(int i = start_text; i <= end_text;i++){
    anzahltextanno = anzahltextanno + 1;
  }
  
  int anzahlpaare = 0;
  int anzahlpaare2 = 0;
  for(int i=1;i<=anzahltextanno-1;i++){
    anzahlpaare = anzahlpaare +1;
    anzahlpaare2 = anzahlpaare2+anzahlpaare;
  }
  anzahlpaare_end = anzahlpaare2;
  text("Anzahl der Textpaare: "+anzahlpaare2,65,640);
  }
}
public void input2(String theText) {
  fill(255);
  rect(60,620,240,50);
  fill(0);
  text("Anzahl Textpaare: "+theText,65,660);
  Matcher matcher = Pattern.compile("\\d+").matcher(theText);
  while (matcher.find()) {
    anzahlshuffletexte= int(matcher.group());
  }
}
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(r)&& theEvent.getValue()==1.0) {
    
    fill(255);
    rect(60,680,310,50);
    fill(0);
    modus = "regular";
    println(modus);
    text("Drücken Sie 'l' zum Starten der Annotation",62,700); 
  }
  if(theEvent.isFrom(r)&& theEvent.getValue()==2.0) {
    
    fill(255);
    rect(60,680,310,50);
    fill(0);
    modus = "shuffle";
    println(modus);
    text("Drücken Sie 'l' zum Starten der Annotation",62,700); 
  }
  if(theEvent.isFrom(r)&& theEvent.getValue()==3.0) {
    modus = "shuffle_liste";
    println(modus);
    fill(255);
    rect(60,680,310,50);
    fill(0);
    text("Drücken Sie 'o' um eine Annotationsliste einzulesen",62,700); 
    text("Danach drücken Sie 'l' zum Starten der Annotation",62,720); 
  }

}
class Tuple{ 
  public  int X; 
  public  int Y; 
  
  public Tuple(int x, int y) { 
    this.X = x; 
    this.Y = y; 
  }
   public Tuple() { 
  }
  public void set0(int x){
    this.X = x;
  }
  public void set1(int y){
    this.Y = y;
  }
  public int get0(){
    return this.X;
  }
  public int get1(){
    return this.Y;
  }
}
class Ergpaar{
  int t1 = 0;
  int t2 = 0;
  int erg = 0;
  
  public Ergpaar(int t1, int t2, int erg){
    this.t1 = t1;
    this.t2 = t2;
    this.erg = erg;
  }
  public Ergpaar(){
  }
  public void sett1(int t1){
    this.t1 = t1;
  }
  public void sett2(int t2){
    this.t2 = t2;
  }
  public void seterg(int erg){
    this.erg = erg;
  }
  public int gett1(){
    return this.t1;
  }
  public int gett2(){
    return this.t2;
  }
  public int geterg(){
    return this.erg;
  }
}
//void controlEvent(ControlEvent theEvent) {
//  if(theEvent.isFrom(r)) {
//    print("got an event from "+theEvent.getName()+"\t");
//    for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
//      print(int(theEvent.getGroup().getArrayValue()[i]));
//    }
//    if (theEvent.getValue() == 1.0){
//      regular = true;
//      counts = false;
//    }
//    if (theEvent.getValue() == 2.0){
//      counts = true;
//      regular = false;
//    }
//    if (theEvent.getValue() == -1.0){
//      counts = false;
//      regular = false;
//      text("bitte wählen Sie eine Option",800,800);
//    }    
//    println("\t "+ "regulaer :" +regular + " bestimme Zahl :" + counts);
//  }
//}oo
