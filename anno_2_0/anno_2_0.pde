import java.io.File;
import controlP5.*;
import java.util.regex.*;
import java.util.regex.MatchResult;

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

// neue Variablen
StringDict korpus = new StringDict();
File korpusdatei;
File ergebnissdatei;
int start_text = 0;
int end_text = 0;
ControlP5 cp5;
RadioButton r;
boolean regular = false;
boolean counts = false;
IntList reihenfolge = new IntList();
StringDict texto = new StringDict();
IntList annoergebniss = new IntList();
IntList annoergebnisse2 = new IntList();
IntList anno2texte = new IntList();


//kappa variablen
int gemeinsamrelevant = 0;
int a1_1 = 0;
int a1_0 = 0;
int a2_1 = 0;
int a2_0 = 0;
float pa;
float pe;
float kappa;
void setup() {
  size(1900,800);
  PFont font = createFont("arial",20);
  cp5 = new ControlP5(this);
  output = createWriter("Ergebnisse.txt");
    text("Anno 2.0",500,100);
    text("Korpus-Annotations-Tool",500,150);
    text("Drücken sie o und wählen sie die Korpus.txt Datei aus."
    +"\n"+"Die Korpsudatei muss alle Texte entahlten, die zu annotieren sind"
    +"\n"+"Sie werden danach die Anleitung zur Annotation sehen.",500,200);
  
}
 
void draw() {

  if (status == "Annotation"){
    cp5.hide();
    background(255);
   
    text("TextA",300,150);
    text(korpus.get(str(reihenfolge.get(t1))),20,200);
    text("TextB",1200,150);
    text(korpus.get(str(reihenfolge.get(t2))),880,200);
    text("Drücken sie 'a' für TextA oder 'b' für TextB",600,700);
    status = "gedrückt";
  } 
  if (status == "Ende"){
    background(0);
    //println(rating);
    fill(255);
    text("Annotatins-Ende",500,500);
    rating.sortValuesReverse();
    text("Drücken sie f um die Annotations zu beenden und die Ergebnisse zu speichern",700,500);
    status = "speichern";
  }
  if (status =="EndeAnno"){
    background(255);
    fill(0);
    text("Um den Cohens-Kappa Wert mit anderen Ergebnissen zu überprüfen bitte o drücken"
    +"\n"+" und die entsprechende Ergebnissdatei einlesen"
    +"\n"+"Um die Annoatation zu beenden drücken Sie e."
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
    text("Anleitung",600,100);
    text("Sie werden in dieser Annotation immer genau 2 Textpaare sehen, den Text A und den Text B."
    +"\n"+"Sie müssen nun auswählen ob sie den Text A oder den Text B für qualitativ besser empfinden."
    +"\n"+"Lesen Sie sich in Ruhe alle Texte durch und entscheiden sie sich dann für den Text A mit der Taste 'a'"
   +"\n"+"und für den Text B mit der Taste 'b'" ,200,200);
   text("Bitte geben Sie den Bereich der Texte für die Annotation an und"
   +"\n"+"bestätigen Sie mit ENTER."
   +"\n"+"Beispiel: 1-10 oder 3-5",200,350);
   text("Anzahl der Texte im Korpus: "+(korpus.size()-1),200,450);
      cp5.addTextfield("input")
     .setPosition(200,500)
     .setSize(200,40)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
//       r = cp5.addRadioButton("radioButton")
//         .setPosition(700,500)
//         .setSize(40,20)
//         .setColorForeground(color(120))
//         .setColorActive(color(100))
//         .setColorLabel(color(100))
//         .setItemsPerRow(2)
//         .setSpacingColumn(50)
//         .addItem("regulaer",1)
//         .addItem("bestimmte Anzahl",2)
//         ;
//    switch(key) {
//    case('0'): r.deactivateAll(); break;
//    case('1'): r.activate(0); break;
//    case('2'): r.activate(1); break;
//    }
   status = "anleitungfertig";
  text("Drücken Sie 'l' zum Starten der Annotation",900,500); 
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
          reihenfolge.append(wert1);
          reihenfolge.append(wert2);
        }
      }
      for(int i=0;i<reihenfolge.size();i++){
        println("i."+reihenfolge.get(i));
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
     println(rating);
     println(korpus);
     println(korpus.get(str(reihenfolge.get(3))));
      status = "Annotation";
    }
  }
  

  if ((key == 'a') && (status == "gedrückt")){
    //println("gedrückt");
    count = count +1;
    //println("ccc",count);
    rating.add(texto.get(str(reihenfolge.get(t1))),1);
    anno.append(texto.get(str(reihenfolge.get(t1)))); // a drücken =  1. Text wird ausgewählt
    anno.append(texto.get(str(reihenfolge.get(t2))));
    annoergebniss.append(0);
    if(count==(reihenfolge.size()/2)){
      status = "Ende";
    }
    else{
    t1 = t1 +2;
    t2 = t2 +2;
    println("t1 "+t1,"t2 "+t2);
    status = "Annotation";
    }
  }
  
  if ((key == 'b') && (status == "gedrückt")){
    //println("gedrückt");
    count = count +1;
    //println("ccc",count);
    rating.add(texto.get(str(reihenfolge.get(t2))),1);
    anno.append(texto.get(str(reihenfolge.get(t1))));
    anno.append(texto.get(str(reihenfolge.get(t2)))); // b drücken =  2. Text wird ausgwählt
    annoergebniss.append(1);
    if(count==(reihenfolge.size()/2)){
      status = "Ende";
      
    }
    else{
    t1 = t1 +2;
    t2 = t2 +2; 
    println("t1 "+t1,"t2 "+t2);
    status = "Annotation";
    }
  }
  if ((key == 'f') && (status == "speichern")){
    output.println("Annotations-Ergebnisse");
    output.println(" ");
    for(int i =start_text;i<=end_text;i++){
      output.println("Text "+i+": "+rating.get(texto.get(str(i))));
    }
    output.println(" ");
    output.println("Textpaare");
    output.println(" ");
    int annotation = 0;
    for(int i=0;i<anno.size();i= i+2){
      
      output.print(anno.get(i)+", "+anno.get(i+1)+"\t"+"\t"+annoergebniss.get(annotation));
      output.println(" ");
      annotation = annotation +1;
  }
    println(anno.size());
    println(annoergebniss);
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
      for(int i =start_text; i<=end_text;i++){
        if(anno2texte.get(i)!= i){
          gleicheTexte = false;
          break;
        }
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
          if(annoergebniss.get(i)==annoergebnisse2.get(i)){
            gemeinsamrelevant = gemeinsamrelevant +1;
          }
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
      println(myErgebnissText[u]);
      Matcher matcher = Pattern.compile("Text \\d, Text \\d\\t\\t(\\d)").matcher(myErgebnissText[u]);
      if(matcher.find()){
      //println("matcher group ### "+matcher.group(1));
      annoergebnisse2.append(int(matcher.group(1)));
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
   String regex = "\\d+";
   String zahl = "";
   String text = "";
    String[] myText = loadStrings (korpusdatei);
    for (int u=0; u < myText.length; u++) {
      if(myText[u].matches(regex)){
        korpus.set(zahl,text);
        zahl = myText[u];
        text ="";
      }
      else{
        text+= myText[u]+"\n";
      }
      korpus.set(zahl,text); // ein letzes mal hinzufügen, für den letzen Text im Korpus,
                             // dieser wird nicht in der for schleife gefüllt
//      String[] splitResult = myText[u].split("\t");
//      korpus.set(splitResult[0],splitResult[1]);
//      println(splitResult[0]);
    }
    //println(korpus.get("0"));
    //println(korpus.get("1"));
    //println(korpus.size());
    text("Korpusdatei erfolgreich eingelesen",600,600);
    text("drücken Sie SPACE um zur Anleitung zu gelangen",600,610);
    //println(korpus.get("0"));
  }
}
 // automatically receives results from controller input
public void input(String theText) {
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
  rect(200,670,200,70);
  fill(0);
  text("Sie Annotieren die Texte: "+start_text+" - "+end_text,210,710);
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
  text("Anzahl der Textpaare: "+anzahlpaare2,210,730);
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
