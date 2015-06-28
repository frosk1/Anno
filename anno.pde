import java.io.File;
PrintWriter output;
String dir ;
File textnamen2;
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
IntList reihenfolge = new IntList();

void setup() {
  size(1400,850);
  output = createWriter("Ergebnisse.txt");
  
}
 
void draw() {
  if (status == "willkommen"){
    
    text("Text-Annotation",500,100);
    text("Drücken sie SPACE und wählen sie den Ordner mit den Textdateien aus"
    +"\n"+"Der Ordner muss alle Textdateien enthalten (erlaubt sind .txt Dateien)"
    +"\n"+"Sie werden danach die Anleitung zur Annotation sehen.",500,150);
  }
  
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
    selectFolder("Textordner für Annotation auswählen:", "folderSelected");
    
    background(255);
    fill(0);
    text("Anleitung",600,100);
    text("Sie werden in dieser Annotation immer genau 3 Text paare sehen, den Text A , den Text B und den Text C."
    +"\n"+"Sie müssen nun auswählen ob sie den Text B oder den Text C für qualitativ besser empfinden gegeben den Text A"
    +"\n"+"Lesen Sie sich in Ruhe alle Texte durch und entscheiden sie sich dann für den Text B mit der Taste 'b'"
   +"\n"+"und für den Text C mit der Taste 'c'" ,200,200);
    text("Mit 'l' werden die Texte eingelesen",600,400);
    status = "anleitung";    
  }

  
  
  // Status Anleitung
  if ((key == 'l') && (status == "anleitung")){
    for(int i=0;i<texte.size();i++){ // Reihenfolge_alt wird mit Zahlen gefüllt.
      reihenfolge_alt.append(i);     // Zahlen werden aufgereit entsprechend Anzahl der Texte.
    }
    size = reihenfolge_alt.size(); // "size" ist die Größe der Liste, Anzahl aller Texte
    
    size2= reihenfolge_alt.size()-2; // "size2" bestimmt die Lauflänge der X Schleife
                                     // Bsp: [0,1,2,3] -> x 1.durchlauf [1,2,3] y 1.durchlauf [2,3]
                                     //                   x 2.durchlauf [2,3]   y 2.durchlauf [3]
    
    for(int i=2;i<=size-1;i++){                // "wiederholungen" ist die Anzahl an Wiederholungen
      wiederholungen= wiederholungen+(size-i); // pro fester Zahl (unten erklärt)
    }
    
  // #####################################################################################
  // Algorithmus zur Bestimmung der Reihenfolge von triple Paaren
  // Bei 3 texten: [0,1,2] -> 0,1,2 ; 1,0,2 ; 2,0,1
  // size = 3 und wiederholungen ist: (3-2) = 1
  // in reihenfolge stehen am Ende die Reihenfolgen der Texte für die Annotation
    for(int i=0;i<size;i++){
      //println("alt",reihenfolge_alt);
      wert1 = reihenfolge_alt.get(i);
      //println("wert1:",wert1);
      reihenfolge_alt.remove(i); 
      //println(reihenfolge_alt);
      counter2 =counter2+ 1; // counter für anzahl der enthaltenen Texte
                             // ( gibt es 4 texte insgesamt, muss es 4 feste zahlen geben)
      for(int x=0;x<size2;x++){
        counti = counti +1;
        //println("countix",counti);
        //println("xschleife",reihenfolge_alt);
        wert2 = reihenfolge_alt.get(0);
        reihenfolge_alt.remove(0);
        for(int y=0;y<reihenfolge_alt.size();y++){
          wert3 = reihenfolge_alt.get(y);
          reihenfolge.append(wert1);
          reihenfolge.append(wert2);
          reihenfolge.append(wert3);
          counter = counter +1; //counter für die anzahl an wiederholungen pro fester zahl
          //println("counter",counter);                      // (0:1,2 --> 0 ist hier als erstes feste zahl)
                                // bei 4 festen zahlen gibt es (4-2)+(4-3)=3 wiederholungen
                                // bei 5 festen zahlen : (5-2)+(5-3)+(5-4)=6 wiederholungen
        }
      }
      //println("c2",counter2);
      //println("c",counter);
      if((counter%wiederholungen==0)&&(counter2<size)){
        //println("runde vorbei");
        reihenfolge_alt.clear();
        for(int u=0;u<texte.size();u++){
          reihenfolge_alt.append(u);
      }
     }
    }
    //###################################################################################
    
    // ####Test ob der algorithmus korrekt funktioniert####
    //for(int i=0; i<reihenfolge.size(); i++){
      //println(reihenfolge.get(i));
    //}
    //println("größe",reihenfolge.size());
    // ##################################################
    text("#################"+
    "\n"+"Texte wurden eingelesen"+
    "\n"+"#################",900,400);
    text("Drücken Sie 'a' zum Starten der Annotation",900,500);
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
void folderSelected(File selection) {
  // Textdateien einlesen per Ordner auswählen ###############
  
  // speicher den Pfad des ausgewählten Ordnes in der Variable dir.
  if (selection == null) {
    text("Sie haben keinen Ordner ausgewählt, bitte wählen sie einen Textordner aus",800,800);
    selectFolder("Textordner für Annotation auswählen:", "folderSelected");
  } else {
    dir = selection.getAbsolutePath();
    //println(dir);
    textnamen2 = new File(dir); // textname 2 wird neues Objekt vom Typ File
    // dateinamen werden mit der methode .list() eingelesen
    // Im Ordner dürfen sich bloß .txt dateien befinden
    String regex = ".*.txt";
    for(int i =0;i<textnamen2.list().length;i++){ 
      if(textnamen2.list()[i].matches(regex)){
        println(textnamen2.list()[i]);
        fileNames2.append(textnamen2.list()[i]);
        fileNames2pfad.append(dir+"/"+textnamen2.list()[i]); 
        //!!!!! Linux dateisystem benutzt / und windows benutzt \ !!!!!!
      }
    }
    //println(fileNames2pfad);
    
    // .txt dateien werden eingelesen in einer StringList und rating dic wird erstellt
   
    for(int i=0;i<fileNames2.size();i++){
      rating.set(fileNames2.get(i),0);
      String[] myText = loadStrings (fileNames2pfad.get(i));
      for (int u=0; u < myText.length; u++) {
        textstring += myText[u] + "\n";
      }
      texte.append(textstring);
      textstring = "";
    }
    //println(texte);
  }
}
// #################################################################
