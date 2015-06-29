import java.io.File;
import controlP5.*;
import java.util.regex.*;

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
int t3 = 2;
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
int start_text = 0;
int end_text = 0;
ControlP5 cp5;
RadioButton r;
boolean regular = false;
boolean counts = false;
IntList reihenfolge = new IntList();

void setup() {
  size(1400,850);
  PFont font = createFont("arial",20);
  cp5 = new ControlP5(this);
  output = createWriter("Ergebnisse.txt");
    text("Anno 2.0",500,100);
    text("Korpus-Annotations-Tool",500,150);
    text("Drücken sie SPACE und wählen sie den Ordner mit den Textdateien aus"
    +"\n"+"Der Ordner muss alle Textdateien enthalten (erlaubt sind .txt Dateien)"
    +"\n"+"Sie werden danach die Anleitung zur Annotation sehen.",500,200);
  
}
 
void draw() {

  if (status == "Annotation2"){
    background(255);
    
    text("TextA",700,100);
    text(texte.get(reihenfolge.get(t1)),400,200);
    text("TextB",300,450);
    text(texte.get(reihenfolge.get(t2)),30,500);
    text("TextC",1000,450);
    text(texte.get(reihenfolge.get(t3)),720,500);
    text("Drücken sie 'b' für TextB oder 'c' für TextC",600,700);
    status = "gedrückt";
  } 
  if (status == "Ende"){
    background(0);
    //println(rating);
    fill(255);
    text("ENDE",500,500);
    rating.sortValuesReverse();
    text("Drücken sie f um die Annotations zu beendne und die Ergebnise zu speichern",700,500);
    status = "speichern";
  }
} 

void keyPressed() {
  // Status Willkommen
  if ((key == ' ') && (status == "willkommen")){
    selectInput("Korpusdatei auswählen :", "fileSelected");
    status = "anleitung";    
  }
  if ((key == 'n') && (status == "anleitung")){
        // nächster Frame kommt :
    background(255);
    fill(0);
    text("Anleitung",600,100);
    text("Sie werden in dieser Annotation immer genau 3 Text paare sehen, den Text A , den Text B und den Text C."
    +"\n"+"Sie müssen nun auswählen ob sie den Text B oder den Text C für qualitativ besser empfinden gegeben den Text A"
    +"\n"+"Lesen Sie sich in Ruhe alle Texte durch und entscheiden sie sich dann für den Text B mit der Taste 'b'"
   +"\n"+"und für den Text C mit der Taste 'c'" ,200,200);
   
      cp5.addTextfield("input")
     .setPosition(200,500)
     .setSize(200,40)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
       r = cp5.addRadioButton("radioButton")
         .setPosition(700,500)
         .setSize(40,20)
         .setColorForeground(color(120))
         .setColorActive(color(100))
         .setColorLabel(color(100))
         .setItemsPerRow(2)
         .setSpacingColumn(50)
         .addItem("regulaer",1)
         .addItem("bestimmte Anzahl",2)
         ;
    switch(key) {
    case('0'): r.deactivateAll(); break;
    case('1'): r.activate(0); break;
    case('2'): r.activate(1); break;
    }
   status = "anleitungfertig";
  text("Drücken Sie 'l' zum Starten der Annotation",900,500); 
  }
  
  
  // Status Anleitung
  if ((key == 'l') && (status == "anleitungfertig")){
    for(int i = start_text; i< end_text;i++){
      wert1 = i;
      for(int u = i+1; u<= end_text;u++){
        println(i);
        wert2 = u;
        reihenfolge.append(wert1);
        reihenfolge.append(wert2);
      }
    }
    for(int i=0;i<reihenfolge.size();i++){
      println("i."+reihenfolge.get(i));
    }
    
    status = "Annotation";
  }
  
  
  
  
  
  // Status Annotation
  if ((key == 'a') && (status == "Annotation")){
    status = "Annotation2";
  }
  
  if ((key == 'b') && (status == "gedrückt")){
    //println("gedrückt");
    zaehler = zaehler +1;
    count = count +1;
    //println("ccc",count);
    rating.add(fileNames2.get(reihenfolge.get(t2)),1);
    anno.append(fileNames2.get(reihenfolge.get(t1)));
    anno.append(fileNames2.get(reihenfolge.get(t2))+" #");
    anno.append(fileNames2.get(reihenfolge.get(t3)));
    if(count==(wiederholungen*size)){
      status = "Ende";
    }
    else{
    t1 = t1 +3;
    t2 = t2 +3;
    t3 = t3 +3; 
    status = "Annotation2";
    }
  }
  
  if ((key == 'c') && (status == "gedrückt")){
    //println("gedrückt");
    count = count +1;
    //println("ccc",count);
    rating.add(fileNames2.get(reihenfolge.get(t3)),1);
    anno.append(fileNames2.get(reihenfolge.get(t1)));
    anno.append(fileNames2.get(reihenfolge.get(t2)));
    anno.append(fileNames2.get(reihenfolge.get(t3))+" #");
    if(count==(wiederholungen*size)){
      status = "Ende";
      
    }
    else{
    t1 = t1 +3;
    t2 = t2 +3;
    t3 = t3 +3; 
    status = "Annotation2";
    }
  }
  if ((key == 'f') && (status == "speichern")){
    output.println("Annotations-Ergebnisse");
    output.println(" ");
    for(int i =0;i<fileNames2.size();i++){
      output.println(fileNames2.get(i)+": "+str(rating.get(fileNames2.get(i))));
    }
    output.println(" ");
    output.println("Tripel-Paare");
    output.println(" ");
    int triple = 0;
    for(int i=0;i<anno.size();i++){
      triple = triple +1;
      output.print(anno.get(i)+",");
      if(triple % 3 == 0){
        output.println(" ");
      }  
  }
    //println(anno);
    output.close();
    exit();
  
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
   
    String[] myText = loadStrings (korpusdatei);
    for (int u=0; u < myText.length; u++) {
      String[] splitResult = myText[u].split("\t");
      korpus.set(splitResult[0],splitResult[1]);
    }
    text("Korpusdatei erfolgreich eingelesen",600,600);
    text("drücken Sie n um zur Anleitung zu gelangen",600,610);
    println(korpus);
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
  println(start_text);
  println(end_text);
}
void controlEvent(ControlEvent theEvent) {
  if(theEvent.isFrom(r)) {
    print("got an event from "+theEvent.getName()+"\t");
    for(int i=0;i<theEvent.getGroup().getArrayValue().length;i++) {
      print(int(theEvent.getGroup().getArrayValue()[i]));
    }
    if (theEvent.getValue() == 1.0){
      regular = true;
      counts = false;
    }
    if (theEvent.getValue() == 2.0){
      counts = true;
      regular = false;
    }
    if (theEvent.getValue() == -1.0){
      counts = false;
      regular = false;
      text("bitte wählen Sie eine Option",800,800);
    }    
    println("\t "+ "regulaer :" +regular + " bestimme Zahl :" + counts);
  }
}
