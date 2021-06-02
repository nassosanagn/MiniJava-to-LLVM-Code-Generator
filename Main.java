import syntaxtree.*;
import visitor.*;

import java.util.*;

import java.io.FileWriter;  
import java.io.IOException; 

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.Method;

public class Main {
    public static void main(String[] args) throws Exception {
        if(args.length < 1){
            System.err.println("Usage: java Main <inputFile>");
            System.exit(1);
        }

        FileInputStream fis = null;
        try{

            FileWriter myFile = new FileWriter("testFile.ll");
            for (int file = 0; file < args.length; file++){

                fis = new FileInputStream(args[file]);
                MiniJavaParser parser = new MiniJavaParser(fis);
                
                Goal root = parser.Goal();
                System.out.println("\nFile: " + args[file] + "\n");

                MyVisitor dataCollector  = new MyVisitor(false, myFile);        /* Call MyVisitor for the 1st time to create the Symbol Table List */      
                MyVisitor typeCheck = new MyVisitor(true, myFile);         /* Call MyVisitor for the 2nd time to do the typechecking */
                
                root.accept(dataCollector, null);

                dataCollector.createVTables();
                dataCollector.printVTables();

                root.accept(typeCheck, null);
                

                /* Print offsets for this file => If there are no errors */
                //System.out.println("-------------------- Output -------------------- \n");
                //typeCheck.output();        
                typeCheck.deleteSymbolTables();
            }
            myFile.close();
        }
        catch(ParseException ex){
            System.out.println(ex.getMessage());
        }
        catch(FileNotFoundException ex){
            System.err.println(ex.getMessage());
        }
        finally{
            try{
                if(fis != null) fis.close();
            }
            catch(IOException ex){
                System.err.println(ex.getMessage());
            }
        }
    }
}

class Function{

    String funName;
    String funType;                             /* The return type of the function */
    int numOfArgs;                              /* Τhe number of arguments in the function */
    Map<String,String> argsArray;               /* A map with function arguments as keys and argument types as values */
    Map<String,String> varArray;                /* A map with function variables as keys and variable types as values */

    public Function(String funName, String funType, int numOfArgs){

        this.funName = funName;
        this.funType = funType;
        this.numOfArgs = numOfArgs;
        this.argsArray = new LinkedHashMap<String,String>(); 
        this.varArray = new LinkedHashMap<String,String>(); 
    }
}

class VTFunction{

    String className;
    String funName;
    String funType;                             /* The return type of the function */
    int numOfArgs;                              /* Τhe number of arguments in the function */
    int offset;
    Map<String,String> argsArray;               /* A map with function arguments as keys and argument types as values */

    public VTFunction(String className, String funName, String funType, int offset, int numOfArgs){

        this.className = className;
        this.funName = funName;
        this.funType = funType;
        this.numOfArgs = numOfArgs;
        this.offset = offset;
        this.argsArray = new LinkedHashMap<String,String>(); 
        //this.varArray = new LinkedHashMap<String,String>(); 
    }
}


class Class{
    
    String className;
    Map <String,String> classVarArray;      /* A map with class variables as keys and variable types as values */          
    List <Function> funList;                /* A list with the class functions */
    
    public Class(String className){
        this.className = className;
        this.classVarArray = new LinkedHashMap<String,String>();
        this.funList = new ArrayList<Function>();  
    }
}

class VTable{
    String className;
    List<VTFunction> funList;

    public VTable(String className){
        this.className = className;
        this.funList = new ArrayList<VTFunction>();  
    }
}

class SymbolTable{

    List <Class> classList;                             /* A list with all the classes */
    
    /* Create the Symbol Table */
    public SymbolTable(String className){
        this.classList = new ArrayList<Class>();
        this.classList.add(new Class(className));  
    }

    /* Add a new class on the list */
    public void enter(String className){
        this.classList.add(new Class(className));
    }

    /* Insert the variable "varName" in the class with index "currClassIndex" */
    public void insertVarInClass(String varName, String varType, int currClassIndex){
        (this.classList.get(currClassIndex)).classVarArray.put(varName, varType);        
    }

    /* Insert the function "functionName" in the class with index "currClassIndex" */
    public void insertMethodInClass(String functionName, String returnType, int numOfArgs, int currClassIndex){
        (this.classList.get(currClassIndex)).funList.add(new Function(functionName, returnType, numOfArgs));
        
    }

    /* Insert a new argument "arguName" in the function "functionName" in the class with index "currClassIndex" */
    public void inserArguInMethod(String functionName, String arguName, String arguType, int currClassIndex){
        
        int funIndex = 0;
        for (int j = 0; j < this.classList.get(currClassIndex).funList.size(); j++) 
            if (((this.classList.get(currClassIndex)).funList.get(j).funName).equals(functionName))
                funIndex = j;
            
        (this.classList.get(currClassIndex)).funList.get(funIndex).argsArray.put(arguName, arguType);   
    }

    /* Insert a new variable "varName" in the function "functionName" in the class with index "currClassIndex" */
    public void inserVarInMethod(String functionName, String varName, String varType, int currClassIndex){

        int funIndex = 0;
        for (int j = 0; j < this.classList.get(currClassIndex).funList.size(); j++)
            if (((this.classList.get(currClassIndex)).funList.get(j).funName).equals(functionName))
                funIndex = j;
            
        (this.classList.get(currClassIndex)).funList.get(funIndex).varArray.put(varName, varType);
    }

    /* Returns first occurrence of variable "varName" used inside the function "functionName" => Return null if var doesn't exist in the Symbol Table  */
    public String lookup(String varName, String functionName, int currClassIndex){
        
        String varType;
        for (int i = currClassIndex; i >= 0; i--){                               /* For every class in this symbol table */

            for (int j = 0; j < this.classList.get(i).funList.size(); j++){                 /* For every function in the class with index i */
                
                if ((this.classList.get(i).funList.get(j).funName).equals(functionName)){       /* Find the function called "functionName" */
                    
                    /* Check function's local variables to find "varName" */
                    varType =  this.classList.get(i).funList.get(j).varArray.get(varName);

                    if (varType != null)    /* If we find the variable in the map => return the variable's type */
                        return varType;

                    /* Check function's arguments to find "varName" */
                    varType =  this.classList.get(i).funList.get(j).argsArray.get(varName);

                    if (varType != null)
                        return varType;
                }
            }
            
            /* If the variable isn't in function's local variables or on function's arguments => Search the class variables */
            varType = this.classList.get(i).classVarArray.get(varName);

            if (varType != null)
                return varType;     
        }
        return null;        /* The variable called "varName" wasn't found in the Symbol Table => return null */
    }

    public String lookup2(String varName, String functionName, int currClassIndex, String mainClassName){
        
        String varType;
        for (int i = currClassIndex; i >= 0; i--){                               /* For every class in this symbol table */

            for (int j = 0; j < this.classList.get(i).funList.size(); j++){                 /* For every function in the class with index i */
                
                if ((this.classList.get(i).funList.get(j).funName).equals(functionName)){       /* Find the function called "functionName" */
                    
                    /* Check function's local variables to find "varName" */
                    varType =  this.classList.get(i).funList.get(j).varArray.get(varName);

                    if (varType != null)    /* If we find the variable in the map => return the variable's type */
                        return varType;

                    /* Check function's arguments to find "varName" */
                    varType =  this.classList.get(i).funList.get(j).argsArray.get(varName);

                    if (varType != null)
                        return varType;
                }
            }  

            if (this.classList.get(i).className.equals(mainClassName)){
                /* If the variable isn't in function's local variables or on function's arguments => Search the class variables */
                varType = this.classList.get(i).classVarArray.get(varName);

                if (varType != null)
                    return varType;
            }
        }
        return null;        /* The variable called "varName" wasn't found in the Symbol Table => return null */
    }

    /* Check if class called "className" exists in this Symbol Table => return "false" if it doesn't */
    public boolean findClassName(String className){

        for (int i = this.classList.size() - 1; i >= 0; i--){                   /* For every class in the classList */
            if ((this.classList.get(i).className).equals(className))
                return true;
        }

        return false;
    }

    /* Return the number of arguments of function called "functionName" or -1 if "functionName" doesn't exist */
    public int getNumOfArguments(String functionName){

        for (int i = this.classList.size() - 1; i >= 0; i--){                      /* For every class in this symbol table */
            for (int j = 0; j < this.classList.get(i).funList.size(); j++) {            /* For every function in the class */

                if ((this.classList.get(i).funList.get(j).funName).equals(functionName))
                    return this.classList.get(i).funList.get(j).numOfArgs;
            }
        }   
        return -1;
    }

    /* Function to search for a variable "varName" in function's called "functionName" arguments and local variables */
    public String funVarReDeclaration(String varName, String functionName, int currClassIndex){     

        String type;

        for (int j = 0; j < this.classList.get(currClassIndex).funList.size(); j++){                 /* Check every function in the class with index i */
            
            if ((this.classList.get(currClassIndex).funList.get(j).funName).equals(functionName)){       /* Find the function called "functionName" */
            
                type =  this.classList.get(currClassIndex).funList.get(j).argsArray.get(varName);        /* Check function's parameters to find "varName" */

                if (type != null)
                    return type;

                type = this.classList.get(currClassIndex).funList.get(j).varArray.get(varName);

                if (type != null)
                    return type;
            }
        }
        return null;        /* The variable called "varName" wasn't found => return null */
    }

    /* Function to search for a variable "varName" only in function's called "functionName" arguments */
    public String funArguReDeclaration(String varName, String functionName, int currClassIndex){     

        for (int j = 0; j < this.classList.get(currClassIndex).funList.size(); j++){                 /* Check every function in the class with index i */
            
            if ((this.classList.get(currClassIndex).funList.get(j).funName).equals(functionName)){       /* Find the function called "functionName" */
            
                String type =  this.classList.get(currClassIndex).funList.get(j).argsArray.get(varName);        /* Check function's parameters to find "varName" */

                if (type != null)
                    return type;
            }
        }
        return null;        /* The variable called "varName" wasn't found => return null */
    }

     /* Function to search for a variable "varName" only in function's called "functionName" arguments */
     public String classVarReDeclaration(String varName, int currClassIndex){     
        return this.classList.get(currClassIndex).classVarArray.get(varName);
    }

    /* Return the class name of the class with index "currClassIndex" */
    public String getClassName(int currClassIndex){
        return this.classList.get(currClassIndex).className;
    }

    /* Search for the function called "functionName" only inside the class called "className" => Return function's type if it exists */
    public String findFunName(String functionName, String className){

        for (int i = this.classList.size() - 1 ; i >= 0; i--){                               /* For every class in this symbol table */

            if (this.classList.get(i).className.equals(className)){
                for (int j = 0; j < this.classList.get(i).funList.size(); j++){                 /* Check every function in the class with index i */
                    if ((this.classList.get(i).funList.get(j).funName).equals(functionName))       /* Find the function called "functionName" */
                        return this.classList.get(i).funList.get(j).funType;
                }
            }
        }
        return null;
    }

    /* Search for the function called "functionName" in all the classes of this Symbol Table => Return function's type if it exists */
    public String findFunName(String functionName){

        for (int i = this.classList.size() - 1 ; i >= 0; i--){                               /* For every class in this symbol table */

            for (int j = 0; j < this.classList.get(i).funList.size(); j++){                 /* Check every function in the class with index i */
                
                if ((this.classList.get(i).funList.get(j).funName).equals(functionName))       /* Find the function called "functionName" */
                    return this.classList.get(i).funList.get(j).funType;
            }
        }
        return null;
    }

    public String findFunName2(String functionName, int currClass){

        for (int i = currClass ; i >= 0; i--){                               /* For every class in this symbol table */

            for (int j = 0; j < this.classList.get(i).funList.size(); j++){                 /* Check every function in the class with index i */
                
                if ((this.classList.get(i).funList.get(j).funName).equals(functionName))       /* Find the function called "functionName" */
                    return this.classList.get(i).className;
            }
        }
        return null;
    }

    /* Check if there is a method with the same name in a parent (only for classExtendsDeclaration) => if there is it must have the same arguments and the same return type*/
    public void sameFunDefinition(String functionName, String argsList, String methodsType){
        
        for (int i = this.classList.size() - 1 ; i >= 0; i--){      /* For every class in this symbol table */

            for (int j = 0; j < this.classList.get(i).funList.size(); j++){       /* Check every function in the class with index i */

                if ((this.classList.get(i).funList.get(j).funName).equals(functionName)){  /* Find if there is a function called "functionName" */

                    String funType = this.classList.get(i).funList.get(j).funType;

                    /* Both methods should have the same return type */
                    if (methodsType.equals(funType) == false){                   /* args[y] = argumentsType */   
                        System.err.println("error: in method overriding function called: " + functionName);
                        System.exit(1);
                    }

                    /* Both arguments should have the same arguments (types and number) */
                    String[] temp = argsList.split(", |,");
                    
                    for (int x = 0; x < temp.length ; x++){     /* Check if the function arguments match */

                        String[] args = temp[x].split(" ");

                        for (int y = 0; y < args.length - 1; y+=2){
                            
                            /* args[y+1] = argumentsName */
                            String argumentsType = this.classList.get(i).funList.get(j).argsArray.get(args[y+1]);

                            /* If argument doesn't exist or if arguments type doesn't match */
                            if ((argumentsType == null) || (argumentsType.equals(args[y]) == false)){                   /* args[y] = argumentsType */   
                                System.err.println("error: in method overriding function called: " + functionName);
                                System.exit(1);
                            }
                        }
                    }
                }
            }
        }
    }

    /* Prints the Symbol Table and the offsets if there are no errors after typechecking */
    public void PrintOffsets(){

        int offset = 0;         /* offset for variables */
        int methodOffset = 0;   /* offset for functions */

        for (int i = 0; i < this.classList.size(); i++){

            System.out.println(" ------------- Class " + this.classList.get(i).className + " ------------- ");
            System.out.println(" --- Variables --- ");

            for (Map.Entry<String, String> entry : this.classList.get(i).classVarArray.entrySet()) {            /* For every variable in the class */

                if (entry.getValue().equals("String[]"))           /* Don't print the main's arguments type "String[]" */
                    continue;
                
                System.out.println(this.classList.get(i).className + "." + entry.getKey() + " : " + offset);

                if (entry.getValue().equals("boolean"))     /* Booleans are stored in 1 byte */
                    offset += 1;
                else if (entry.getValue().equals("int"))        /* Ints are stored in 4 bytes */
                    offset += 4;
                else                                /* Pointers are stored in 8 bytes */
                    offset +=8;
            }
            
            System.out.println(" --- Methods --- ");
            for (int j = 0; j < this.classList.get(i).funList.size(); j++){       /* For every function in the class */
                
                boolean flag = false;

                for (int z = 0; z < i; z++){

                    for (int k = 0; k < this.classList.get(z).funList.size(); k++){     /* For every function in parent class */

                        /* If function already exists in class parent => dont print the address again */
                        if (this.classList.get(i).funList.get(j).funName.equals(this.classList.get(z).funList.get(k).funName)){
                            flag = true;
                            break;
                        }
                    }
                    if (flag)
                        break;
                }

                if (flag)       /* Function exists in parent class => dont print => continue to the next function */
                    continue;

                System.out.println(this.classList.get(i).className + "." + this.classList.get(i).funList.get(j).funName + " : " + methodOffset);
                methodOffset+=8;    /* we consider functions as pointers => 8 bytes */
            }
        }
    }
}

class OffsetTable{

    VTable vtable;
    Map <String,Integer> variableOffsets;
    int maxOffset;

    public OffsetTable(String className, SymbolTable tempST, VTable tempVTable){
        
        this.vtable = tempVTable;
        this.variableOffsets = new LinkedHashMap<String,Integer>();
        int offset = 0;
        int index = 0;
      
        
        for (int i = 0; i < tempST.classList.size(); i++){

            if (tempST.classList.get(i).className.equals(className)){
                index = i;
                break;
            }
        }

        for (int j = index; j >= 0; j--){
            
            for (Map.Entry<String, String> entry : tempST.classList.get(j).classVarArray.entrySet()) {            /* For every variable in the class */
    
                if (entry.getValue().equals("String[]"))           /* Don't print the main's arguments type "String[]" */
                    continue;
                
                this.variableOffsets.put(entry.getKey(),offset);
                //System.out.println(tempClass.className + "." + entry.getKey() + " : " + offset);
    
                if (entry.getValue().equals("boolean"))     /* Booleans are stored in 1 byte */
                    offset += 1;
                else if (entry.getValue().equals("int"))        /* Ints are stored in 4 bytes */
                    offset += 4;
                else                                /* Pointers are stored in 8 bytes */
                    offset +=8;
            }
        }

        this.maxOffset = offset;
        
    }

}

class MyVisitor extends GJDepthFirst<String,String>{

    static List <SymbolTable> st = new ArrayList<SymbolTable>();     /* The list with the SymbolTables */
    int currSymbolTable;                                             /* currSymbolTable = current ST index => We have a new Symbol table everytime we have a new ClassDeclaration */
    int currClass;                                                   /* currClass = current class index inside of this ST => We have a new Class in the classList everytime we have a new ClassExtendsDeclaration */
    boolean typeCheck;                                               /* If flag typecheck == true, it's the second time we call MyVisitor to check the variables */
    String mainClassName;

    FileWriter myFile;
    int registerCounter = 0;
    int ifCounter = -1;
    int expResCounter = 0;
    int nszCounter = 0;
    int oobCounter = 0;
    int loopCounter = 0;
    boolean mathFlag = false;
    
    static List <VTable> vt = new ArrayList<VTable>();     /* The list with the SymbolTables */
    int currVTable;

    /* Initialize MyVisitor variables */
    public MyVisitor(boolean typeCheck, FileWriter myFile){
        this.typeCheck = typeCheck;
        this.currSymbolTable = 0;    
        this.currClass = 0;
        this.currVTable = 0;
        this.myFile = myFile;
    }

    public int createVTables(){

        int vTablesCounter = 0;
        int offset = 0;
       
        for (int i = 0; i < st.size(); i++){                        /* For every symbol table */  

            for (int j = 0; j < st.get(i).classList.size(); j++){                      /* For every class in the symbol table */

                vt.add(new VTable(st.get(i).classList.get(j).className));           /* Create a new VTable for each class */                            

                int numOfMethods = st.get(i).classList.get(j).funList.size();

                String functionName;
                String className;
                
                for (int z = 0; z < numOfMethods; z++){                 /* For every method in the class */

                    className    = st.get(i).classList.get(j).className;
                    functionName = st.get(i).classList.get(j).funList.get(z).funName;
                    String returnType   = st.get(i).classList.get(j).funList.get(z).funType;
                    int numOfArgs       = st.get(i).classList.get(j).funList.get(z).numOfArgs;
                    
                    vt.get(vTablesCounter).funList.add(new VTFunction(className,functionName, returnType, offset,numOfArgs));
                    offset += 8;

                    for (Map.Entry<String, String> entry : st.get(i).classList.get(j).funList.get(z).argsArray.entrySet()){
                        vt.get(vTablesCounter).funList.get(z).argsArray.put(entry.getKey(), entry.getValue());
                    }
                }

                if (j > 0){                 /* It's a class extension */ 
                
                    for (int k = 0; k <st.get(i).classList.get(j-1).funList.size(); k++){        /* For every function in parent class */
                        
                        /* for every function in this class */
                        boolean found = false;

                        for (int l = 0; l < st.get(i).classList.get(j).funList.size(); l++){

                            if (st.get(i).classList.get(j).funList.get(l).funName.equals(st.get(i).classList.get(j-1).funList.get(k).funName)){
                                found = true;
                            }
                        }

                        /* If function from parent class does not exist in this class => insert it */
                        if (!found) {

                            className           = st.get(i).classList.get(j-1).className;
                            functionName        = st.get(i).classList.get(j-1).funList.get(k).funName;
                            String returnType   = st.get(i).classList.get(j-1).funList.get(k).funType;
                            int numOfArgs       = st.get(i).classList.get(j-1).funList.get(k).numOfArgs;
                            
                            vt.get(vTablesCounter).funList.add(new VTFunction(className,functionName, returnType, offset, numOfArgs));
                            offset += 8;

                            for (Map.Entry<String, String> entry : st.get(i).classList.get(j-1).funList.get(k).argsArray.entrySet()){
                                vt.get(vTablesCounter).funList.get(k).argsArray.put(entry.getKey(), entry.getValue());
                            }
                        }
                    }
                }

            offset = 0;
            vTablesCounter++;
            }

        }

        return 0;
    }

    public int printVTables() throws IOException {

        for (int i = 0; i < vt.size(); i++){

            int numOfFunctions = vt.get(i).funList.size();

            myFile.write("@." + vt.get(i).className + "_vtable = global [" + numOfFunctions + " x i8*] [");
          
            if (numOfFunctions == 0){
                myFile.write("]\n\n");
            
            }else{

                for (int j = 0; j < numOfFunctions; j++){

                    myFile.write("\n\ti8* bitcast (");

                    if (vt.get(i).funList.get(j).funType.equals("int"))
                        myFile.write("i32");
                    else if (vt.get(i).funList.get(j).funType.equals("boolean"))
                        myFile.write("i1");
                    else
                        myFile.write("i8*");

                    myFile.write(" (i8*");

                    for (Map.Entry<String, String> entry : vt.get(i).funList.get(j).argsArray.entrySet()){
                        
                        if (entry.getValue().equals("int"))
                            myFile.write(",i32");
                        else if (entry.getValue().equals("boolean"))
                            myFile.write(",i1");
                        else
                            myFile.write(",i8*");
                    }

                    myFile.write(")*");
                    myFile.write(" @" + vt.get(i).funList.get(j).className + "." + vt.get(i).funList.get(j).funName + " to i8*)");

                    if (j == numOfFunctions - 1){
                        myFile.write("\n]\n\n");
                    }else{
                        myFile.write(",");
                    }

                }
            }
        
        }

        return 0;
    }

    /* Find the index of the Symbol Table that contains the class called "className" => Return -1 if it doesn't exist */
    public int findSTindex(String className){

        /* For every symbol table */         
        for (int i = 0; i < st.size(); i++){

            /* If you find the "className" return the st index */
            if (st.get(i).findClassName(className)) 
                return i;
        }
        return -1;
    }

    public int findVTindex(String className){

        /* For every symbol table */         
        for (int i = 0; i < vt.size(); i++){

            /* If you find the "className" return the st index */
            if (vt.get(i).className.equals(className)) 
                return i;
        }
        return -1;
    }

    /* Delete the list with the symbol tables */
    public void deleteSymbolTables(){
        st.clear();
    }

    /* Function to print the offsets for every symbol table */
    public void output(){

        /* Print every symbolTable */
        for (int i = 0; i < st.size(); i++)
            st.get(i).PrintOffsets();
    }

    public String iBits(String varType){

        if (varType.equals("int"))
            return "i32";

        else if (varType.equals("boolean"))
            return "i1";

        else if (varType.equals("int[]"))
            return "i32*";

        else
            return "i8*";
    }

    /* Check if a string is numeric or not */
    public boolean isNumeric(String str) { 
        try{  
            Integer.parseInt(str);  
            return true;
        } catch(NumberFormatException e){  
            return false;  
        }  
    }

    public void checkFunArguments(String functionName, ArrayList<String> argsTypeList, int currST){

        for (int i = st.get(currST).classList.size() - 1 ; i >= 0; i--){        /* For every class in this symbol table */

            for (int j = 0; j < st.get(currST).classList.get(i).funList.size(); j++){     /* Check every function in the class with index j */

                if ((st.get(currST).classList.get(i).funList.get(j).funName).equals(functionName)){   /* Find the function called "functionName" */
                
                    List<String> values = new ArrayList(st.get(currST).classList.get(i).funList.get(j).argsArray.values());

                    for (int x = 0; x < argsTypeList.size(); x++){     /* Check if the function arguments match */

                        boolean flag = false;

                        if (argsTypeList.get(x).equals(values.get(x)) == false){    /* If argument types do not match => check if it's a parent class*/

                            int stIndex = this.findSTindex(values.get(x));

                            if (stIndex != -1){     /* Check if "values.get(x)" is a className => then check if parent classes names match with the arguType*/
                                                                
                                for (int y = st.get(stIndex).classList.size() - 1 ; y >= 0; y--){
                                    
                                    if (st.get(stIndex).classList.get(y).className.equals(argsTypeList.get(x))){
                                        flag = true;
                                        break;
                                    }
                                }

                                if (flag)
                                    continue;
                            }
                                System.err.println("error: argument types do not match: " + argsTypeList.get(x) + " and " + values.get(x) + " in function: " + functionName);
                                System.exit(1);
                        }   
                    }
                }
            }
        }
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> "public"
     * f4 -> "static"
     * f5 -> "String"
     * f6 -> "main"
     * f7 -> "("
     * f8 -> "String"
     * f9 -> "["
     * f10 -> "]"
     * f11 -> Identifier()
     * f12 -> ")"
     * f13 -> "{"
     * f14 -> ( VarDeclaration() )*
     * f15 -> ( Statement() )*
     * f16 -> "}"
     * f17 -> "}"
     */
    public String visit(MainClass n, String argu) throws Exception {

        String classname = n.f1.accept(this,argu);
        mainClassName = classname;

        if (!typeCheck){
    
            /* Declare */
            st.add(new SymbolTable(classname));                                     /* add a new Symbol Table */
            st.get(currSymbolTable).insertVarInClass(n.f11.accept(this,argu), "String[]", currClass);

            NodeListOptional varDecls = n.f14;             /* f14 VARIABLE DECLARATIONS */
            for (int i = 0; i < varDecls.size(); ++i) {
                VarDeclaration varDecl = (VarDeclaration) varDecls.elementAt(i);
                String varId = varDecl.f1.accept(this,argu);
                String varType = varDecl.f0.accept(this,argu);
                
                /* Check if there is already a variable with the same name in the class */
                if (st.get(currSymbolTable).classVarReDeclaration(varId, currClass) != null){
                    System.err.println("error: class variable: " + varId + " double declaration");
                    System.exit(1);
                }
                
                /* Insert the class variables in this st */
                st.get(currSymbolTable).insertVarInClass(varId, varType, currClass);
            }
            
        }else{      /* If it's time for typechecking */

            myFile.write("declare i8* @calloc(i32, i32)\n");
            myFile.write("declare i32 @printf(i8*, ...)\n");
            myFile.write("declare void @exit(i32)\n\n");

            myFile.write("@_cint = constant [4 x i8] c\"%d\\0a\\00\"\n");
            myFile.write("@_cOOB = constant [15 x i8] c\"Out of bounds\\0a\\00\"\n");
            myFile.write("@_cNSZ = constant [15 x i8] c\"Negative size\\0a\\00\"\n\n");

            /* Define print_int function */
            myFile.write("define void @print_int(i32 %i) {\n");
            myFile.write("\t%_str = bitcast [4 x i8]* @_cint to i8*\n");
            myFile.write("\tcall i32 (i8*, ...) @printf(i8* %_str, i32 %i)\n");
            myFile.write("\tret void\n}\n\n");

            /* Define throw_oob function */
            myFile.write("define void @throw_oob() {\n");
            myFile.write("\t%_str = bitcast [15 x i8]* @_cOOB to i8*\n");
            myFile.write("\tcall i32 (i8*, ...) @printf(i8* %_str)\n");
            myFile.write("\tcall void @exit(i32 1)\n");
            myFile.write("\tret void\n}\n\n");

            /* Define throw_nsz function */
            myFile.write("define void @throw_nsz() {\n");
            myFile.write("\t%_str = bitcast [15 x i8]* @_cNSZ to i8*\n");
            myFile.write("\tcall i32 (i8*, ...) @printf(i8* %_str)\n");
            myFile.write("\tcall void @exit(i32 1)\n");
            myFile.write("\tret void\n}\n\n");

            /* Define main function */
            myFile.write("define i32 @main() {\n");
        
            /* Main class variable declarations */
            for (Map.Entry<String, String> entry : st.get(currSymbolTable).classList.get(currClass).classVarArray.entrySet()){
                
                if (entry.getValue().equals("String[]"))    /* Ignore main's default argument */
                    continue;

                String iBits = this.iBits(entry.getValue());
                myFile.write("\t%" + entry.getKey() + " = alloca " + iBits + "\n");
            }

            myFile.write("\n");

            NodeListOptional statDecls = n.f15;            /* Visit each statement */
            for (int i = 0; i < statDecls.size(); ++i) {
                Statement statDecl = (Statement) statDecls.elementAt(i);
                statDecl.f0.accept(this,"main");
            }

            myFile.write("\tret i32 0\n");
            myFile.write("}\n\n");
        }
                
        return "Main Class";
    }

    /**
    * f0 -> ClassDeclaration()
    *       | ClassExtendsDeclaration()
    */
    public String visit(TypeDeclaration n, String argu) throws Exception {
        return n.f0.accept(this, argu);
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "{"
     * f3 -> ( VarDeclaration() )*
     * f4 -> ( MethodDeclaration() )*
     * f5 -> "}"
     */
    public String visit(ClassDeclaration n, String argu) throws Exception {

        currSymbolTable++;                          /* Add a new symbol table for the new class declaration */
        currVTable++;
        String className = n.f1.accept(this,argu);

        if (!typeCheck){

            /* Check if a class called "className" already exists */
            if (this.findSTindex(className) != -1){
                System.err.println("error: Class " + className + " double Declaration");
                System.exit(1);
            }

            st.add(new SymbolTable(className));     /* Add a new Symbol Table */

            NodeListOptional varDecls = n.f3;                   /* f3 Variable Declarations */
            for (int i = 0; i < varDecls.size(); ++i) {
                VarDeclaration varDecl = (VarDeclaration) varDecls.elementAt(i);
                String varId = varDecl.f1.accept(this,argu);
                String varType = varDecl.f0.accept(this,argu);

                /* Check if there is already a variable with the same name in the class */
                if (st.get(currSymbolTable).classVarReDeclaration(varId, currClass) != null){
                    System.err.println("error: class variable: " + varId + " double declaration");
                    System.exit(1);
                }

                /* Insert the class variables in this Symbol Table */
                st.get(currSymbolTable).insertVarInClass(varId, varType, currClass);    
            }
            NodeListOptional methodDecls = n.f4;     

            for (int i = 0; i < methodDecls.size(); ++i){           /*  f4 Method Declarations */

                MethodDeclaration methodDecl = (MethodDeclaration) methodDecls.elementAt(i);
                String methodName = methodDecl.f2.accept(this,argu);
                String methodsType = methodDecl.f1.accept(this,argu);

                int numOfArgs;
                String argumentList = methodDecl.f4.present() ? methodDecl.f4.accept(this,argu) : "";      /* Get the function arguments */

                /* Get the number of the arguments */
                if (argumentList.isEmpty())
                    numOfArgs = 0;
                else{
                    String[] args = argumentList.split(",");
                    numOfArgs = args.length;
                }

                /* Check if there is already a function with this name in the same class => error */
                if (st.get(currSymbolTable).findFunName(methodName, className) != null){
                    System.err.println("error: function " + methodName + " double Declaration");
                    System.exit(1);
                }else
                    /* Insert this class method in this Symbol Table */
                    st.get(currSymbolTable).insertMethodInClass(methodName, methodsType, numOfArgs, currClass);                      
            }
        }
        return super.visit(n, argu);
    }

    /**
     * f0 -> "class"
     * f1 -> Identifier()
     * f2 -> "extends"
     * f3 -> Identifier()
     * f4 -> "{"
     * f5 -> ( VarDeclaration() )*
     * f6 -> ( MethodDeclaration() )*
     * f7 -> "}"
     */
    public String visit(ClassExtendsDeclaration n, String argu) throws Exception {
        
        currClass++;                                    /* Add a new class in the current Symbol Table */
        currVTable++;
        String className = n.f1.accept(this,argu);

        if (!typeCheck){

            String extendsClass = n.f3.accept(this,argu);
            
            /* Find the symbolTable that contains the class called "extendsClass" that the new class called "className" extends */
            int STindex = this.findSTindex(extendsClass);
            
            if (STindex == -1){
                System.err.println("error: there is no class called: " + extendsClass);
                System.exit(1);
            }

            st.get(STindex).enter(className);    /* Add a new class in the current Symbol Table with index (STIndex) */

            NodeListOptional varDecls = n.f5;          /* f5 Variable Declarations */

            for (int i = 0; i < varDecls.size(); ++i){
                VarDeclaration varDecl = (VarDeclaration) varDecls.elementAt(i);
                String varId = varDecl.f1.accept(this,argu);
                String varType = varDecl.f0.accept(this,argu);

                /* Check if there is already a variable with the same name in the class */
                if (st.get(currSymbolTable).classVarReDeclaration(varId, currClass) != null){
                    System.err.println("error: class variable: " + varId + " double declaration");
                    System.exit(1);
                }

                /* Insert the class variables in this st */
                st.get(STindex).insertVarInClass(varId,varType,currClass);
            }

            NodeListOptional methodDecls = n.f6;               /* f6 Method Declarations */
            for (int i = 0; i < methodDecls.size(); ++i){

                MethodDeclaration methodDecl = (MethodDeclaration) methodDecls.elementAt(i);
                String methodName = methodDecl.f2.accept(this,argu);
                String methodsType = methodDecl.f1.accept(this,argu);

                int numOfArgs; 
                String argumentList = methodDecl.f4.present() ? methodDecl.f4.accept(this,argu) : "";      /* Get the function arguments */

                /* Get the number of the arguments */
                if (argumentList.isEmpty())
                    numOfArgs = 0;
                else{
                    String[] args = argumentList.split(",");
                    numOfArgs = args.length;
                }

                /* Check if there is a method with the same name in the new class => if there is it must have the same arguments and the same returj type*/
                st.get(STindex).sameFunDefinition(methodName, argumentList, methodsType);
                /* Insert this class method in this Symbol Table */
                st.get(STindex).insertMethodInClass(methodName, methodsType, numOfArgs, currClass);    
            }
        }

        super.visit(n, argu);
        return "ClassExtendsDeclaration";
    }

    /**
    * f0 -> Type()
    * f1 -> Identifier()
    * f2 -> ";"
    */
    public String visit(VarDeclaration n, String argu) throws Exception {
        String myType = n.f0.accept(this,argu);
        String myName = n.f1.accept(this,argu);
        return myType + " " + myName;
    }

    /**
    * f0 -> "public"
    * f1 -> Type()
    * f2 -> Identifier()
    * f3 -> "("
    * f4 -> ( FormalParameterList() )?
    * f5 -> ")"
    * f6 -> "{"
    * f7 -> ( VarDeclaration() )*
    * f8 -> ( Statement() )*
    * f9 -> "return"
    * f10 -> Expression()
    * f11 -> ";"
    * f12 -> "}"
    */
    public String visit(MethodDeclaration n, String argu) throws Exception {
        
        String methodsType = n.f1.accept(this,argu);
        String methodName = n.f2.accept(this,argu);

        if (!typeCheck){

            String argumentList = n.f4.present() ? n.f4.accept(this,argu) : "";
            String[] temp = argumentList.split(", |,");
                        
            /* Insert function arguments in the symbol table */
            for (int i = 0; i < temp.length ; i++){
                String[] args = temp[i].split(" ");
                for  (int j = 0; j < args.length - 1; j+=2){

                    /* Check if an argument name is declared more than once */
                    if (st.get(currSymbolTable).funArguReDeclaration(args[j+1], methodName, currClass) != null){
                        System.err.println("error: double variable " + args[j+1] + " declaration in method: " + methodName);
                        System.exit(1);
                    }
                    st.get(currSymbolTable).inserArguInMethod(methodName, args[j+1], args[j], currClass);       /* args[j+1] = arguName and args[j] = arguType */
                }
            }

            /* Insert function variables in the symbol table */
            NodeListOptional varDecls = n.f7;
            for (int i = 0; i < varDecls.size(); ++i) {
                VarDeclaration varDecl = (VarDeclaration) varDecls.elementAt(i);
                String varId = varDecl.f1.accept(this,argu);
                String varType = varDecl.f0.accept(this,argu);
                
                /* Check if an method's variable name is declared more than once (in arguments or in method's body)*/
                if (st.get(currSymbolTable).funVarReDeclaration(varId, methodName, currClass) != null){
                    System.err.println("error: double variable " + varId + " declaration in method: " + methodName);
                    System.exit(1);
                }
                st.get(currSymbolTable).inserVarInMethod(methodName, varId, varType, currClass);
            }
            
        }else{      /* If it's time for typechecking */

            String returnVar = n.f10.accept(this, methodName);

            /* If expression is a number => then the function must return int */
            if (this.isNumeric(returnVar)){

                if (methodsType.equals("int") == false){
                    System.err.println("error: incompatible types: int cannot be converted to " + methodsType);
                    System.exit(1);
                }
            
            /* If expression is "true" or "false" => then the function must return boolean */
            }else if (returnVar.equals("true") || returnVar.equals("false")){

                if ((methodsType.equals("boolean") == false)){
                    System.err.println("error: incompatible types: boolean cannot be converted to " + methodsType);
                    System.exit(1);
                }

            }else{

                String typeRetVar;

                if (returnVar.equals("this"))                                        /* Return type is the className */
                    typeRetVar = st.get(currSymbolTable).getClassName(currClass);

                else if (returnVar.contains("MessageSend "))             /* If it's returning a function call then we alredy have the return type */
                    typeRetVar = returnVar.replace("MessageSend ","");

                else                                                                                /* If it's a variable get the varType */
                    typeRetVar = st.get(currSymbolTable).lookup(returnVar, methodName, currClass);
                
                /* If we have different return types */
                if ((methodsType.equals(typeRetVar) == false)){
                    System.err.println("error: incompatible return types: "+ typeRetVar + " cannot be converted to " + methodsType);
                    System.exit(1);
                }
            }
            String iBits = this.iBits(methodsType);

            myFile.write("define " + iBits + " ");
            
            String className = st.get(currSymbolTable).findFunName2(methodName,currClass);

            myFile.write("@" + className + "." + methodName + "(i8* %this");
            
            String argumentList = n.f4.present() ? n.f4.accept(this,argu) : "";
            String[] temp = argumentList.split(", |,");
            
            for (int i = 0; i < temp.length ; i++){
                String[] args = temp[i].split(" ");
                
                for (int j = 0; j < args.length - 1; j+=2){
                    
                    if (args[j].equals("int"))
                        myFile.write(", i32 %." + args[j+1]);
                    else if (args[j].equals("boolean"))
                        myFile.write(", i1 %." + args[j+1]);
                    else 
                        myFile.write(", i8* %." + args[j+1]);
                    }
                }
                
                myFile.write(") {\n");
                
                /* Initialize counters */
                registerCounter = 0;
                ifCounter = -1;
                expResCounter = 0;
                nszCounter = 0;
                oobCounter = 0;
                loopCounter = 0;

                /* Allocate space for the function arguments */
                for (int i = 0; i < temp.length ; i++){
                    
                    String[] args = temp[i].split(" ");
                    for (int j = 0; j < args.length - 1; j+=2){
                        
                        if (args[j].equals("int")){
                            myFile.write("\t%" + args[j+1] + " = alloca i32\n");
                            myFile.write("\tstore i32 %." + args[j+1] + ", i32* %" + args[j+1] + "\n");
                            
                        }else if (args[j].equals("boolean")){
                            myFile.write("\t%t" + args[j+1] + " = alloca i1\n");
                            myFile.write("\tstore i1 %." + args[j+1] + ", i1* %" + args[j+1] + "\n");
                            
                        }else if (args[j].equals("int[]")){
                            myFile.write("\t%t" + args[j+1] + " = alloca i32*\n");
                            
                        }else{
                            myFile.write("\t%t" + args[j+1] + " = alloca i8*\n");
                            myFile.write("\tstore i8* %." + args[j+1] + ", i8** %" + args[j+1] + "\n");
                        }
                    }
                }

                /* Allocate space for the function local variables */
                NodeListOptional varDecls = n.f7;
                for (int i = 0; i < varDecls.size(); ++i) {
                    VarDeclaration varDecl = (VarDeclaration) varDecls.elementAt(i);
                    String varId = varDecl.f1.accept(this,argu);
                    String varType = varDecl.f0.accept(this,argu);
                    
                    String iBits2 = this.iBits(varType);
                    myFile.write("\t%" + varId + " = alloca " + iBits2 + "\n");
                }
                
                NodeListOptional statDecls = n.f8;              /* Visit each statement */
                for (int i = 0; i < statDecls.size(); ++i) {
                    Statement statDecl = (Statement) statDecls.elementAt(i);
                    statDecl.f0.accept(this,methodName);
                }          
                
                if(this.isNumeric(returnVar)){
                    myFile.write("\n\tret i32 " + returnVar + "\n");
                    myFile.write("}\n\n");
                    return "MethodDeclaration";
                }

                
               
                int stIndex = this.findSTindex(className);
                OffsetTable tempOffsetTable = new OffsetTable(className, st.get(stIndex),vt.get(currVTable));
                System.out.println("Return var einai: " + returnVar);

                if (tempOffsetTable.variableOffsets.get(returnVar) == null){    /* The variable is not a class field */
                    myFile.write("\t%t" + registerCounter + " = load " + iBits + ", " + iBits + "* %" + returnVar + "\n");

                }else{
                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, i32 " + (tempOffsetTable.variableOffsets.get(returnVar) + 8) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to " + iBits + "*\n");
                    myFile.write("\t%t" + registerCounter + " = load " + iBits + ", " + iBits + "* %t" + (registerCounter - 1) + "\n");
                }
                
                myFile.write("\n\tret " + iBits + " %t" + registerCounter++ + "\n");
                myFile.write("}\n\n");
            }
            
            return "MethodDeclaration";
        }
        
        /**
         * f0 -> FormalParameter()
         * f1 -> FormalParameterTail()
         */
        public String visit(FormalParameterList n, String argu) throws Exception {
            String ret = n.f0.accept(this,argu);
            
            if (n.f1 != null) {
                ret += n.f1.accept(this,argu);
            }
            return ret;
        }

    /**
     * f0 -> FormalParameter()
     * f1 -> FormalParameterTail()
     */
    public String visit(FormalParameterTerm n, String argu) throws Exception {
        return n.f1.accept(this, argu);
    }

    /**
     * f0 -> ","
     * f1 -> FormalParameter()
     */
    public String visit(FormalParameterTail n, String argu) throws Exception {
        String ret = "";
        for ( Node node: n.f0.nodes) {
            ret += ", " + node.accept(this,argu);
        }
        return ret;
    }

    /**
     * f0 -> Type()
     * f1 -> Identifier()
     */
      
    public String visit(FormalParameter n, String argu) throws Exception{
        String type = n.f0.accept(this,argu);
        String name = n.f1.accept(this,argu);
        return type + " " + name;
    }

    /**
    * f0 -> ArrayType()
    *       | BooleanType()
    *       | IntegerType()
    *       | Identifier()
    */
    public String visit(Type n, String argu) throws Exception {
        return n.f0.accept(this,argu);
    }

    /**
    * f0 -> "int"
    * f1 -> "["
    * f2 -> "]"
    */
    public String visit(ArrayType n, String argu) {
        return "int[]";
    }

    /**
    * f0 -> "boolean"
    */
    public String visit(BooleanType n, String argu) {
        return "boolean";
    }

    /**
    * f0 -> "int"
    */
    public String visit(IntegerType n, String argu) {
        return "int";
    }

    /**
    * f0 -> Block()
    *       | AssignmentStatement()
    *       | ArrayAssignmentStatement()
    *       | IfStatement()
    *       | WhileStatement()
    *       | PrintStatement()
    */
    public String visit(Statement n, String argu) throws Exception {
        return n.f0.accept(this, argu);
    }

    /**
    * f0 -> "{"
    * f1 -> ( Statement() )*
    * f2 -> "}"
    */
    public String visit(Block n, String argu) throws Exception {

        if (typeCheck){

            NodeListOptional statDecls = n.f1;                                       /* f1 STATEMENTS */
            for (int i = 0; i < statDecls.size(); ++i) {
                Statement statDecl = (Statement) statDecls.elementAt(i);
                statDecl.f0.accept(this,argu);
            }
        }
        return "Block";
    }

    /**
     * f0 -> Identifier()
    * f1 -> "="
    * f2 -> Expression()
    * f3 -> ";"
    */ 
    public String visit(AssignmentStatement n, String methodName) throws Exception {

        String identifier = n.f0.accept(this,methodName);
        String expr = n.f2.accept(this,methodName);

        if (typeCheck){

            System.out.println("to identifier einai: " + identifier);
            
            int stIndex = currSymbolTable;
            String idType = st.get(stIndex).lookup(identifier, methodName,currClass);
            
            /* Check if the variable before the '=' (identifier) exists in the SymbolTable (has been declared) */
            if (idType == null){                
                System.err.println("error: cannot find symbol: " + identifier + " in method: " + methodName);
                System.exit(1);
            }

            if (expr.contains("ArrayAllocationExpression ")){         /* If it's a new int[] (array allocation) */

                /* idType must be int array */
                if (idType.equals("int[]") == false){
                    System.err.println("error: incompatible types: " + idType + " cannot be converted to int[]");
                    System.exit(1);
                }

                String idType2 = st.get(stIndex).lookup2(identifier, methodName,currClass, mainClassName);
                
                if (idType2 == null){   /* if id is in class fields */
                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, i32\n");
                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to \n");
                    myFile.write("\tstore i32* %t" + (registerCounter - 5) + ", i32** %t" + (registerCounter - 1) +"\n\n");
                }else{
                    myFile.write("\tstore i32* %t" + (registerCounter-1) + ", i32** %" + identifier +"\n");
                }


            }else if (expr.contains("*")){

                myFile.write("\tstore i32 %t" + (registerCounter-1) + ", i32* %" + identifier +"\n");

            }else if ((expr.contains("AllocationExpression"))){       /* If it's new class allocation e.g. new A() */

                String className = expr.replace("AllocationExpression", "");

                /* Check if idType and className match */
                if (idType.equals(className) == false){
                    System.err.println("error: incompatible types: " + idType + " cannot be converted to " + className);
                    System.exit(1);
                }

                myFile.write("\tstore i8* %t" + (registerCounter-3) + ", i8** %" + identifier + "\n\n");

            }else if (expr.contains("MessageSend ")){           /* If it's a message send */

                String exprType = expr.replace("MessageSend ", "");

                myFile.write("\t; Sto Assignment Statement \n");
                String iBits = this.iBits(idType);

                myFile.write("\tstore " + iBits + " %t" + (registerCounter-1) + ", " + iBits + "* %" + identifier +"\n");

                /* Check if idType and exprType match */
                // if (idType.equals(exprType) == false){                
                //     System.err.println("error: edwww incompatible types: " + idType + " cannot be converted to " + exprType);
                //     System.exit(1);
                // }

            }else{       /* If it's a variable, or a number or a PrimaryExpression e.g. x + 5 */

                String temp[] = expr.split(" ");    /* Split the expression in words */

                for (int i = 0; i < temp.length ; i++){

                    if (this.isNumeric(temp[i])){                          /* If it's a number */

                        /* Identifier must be type int */
                        if (idType.equals("int") == false){
                            System.out.println(expr);
                            System.err.println("error: incompatible types: " + idType + " cannot be converted to int");
                            System.exit(1);
                        }

                        if (!mathFlag)
                            myFile.write("\tstore i32 " + temp[i] + ", i32* %" + identifier + "\n");
                        
                        mathFlag = false;
                    }else{

                        /* Ignore symbols and words like "this", "true", "false" */
                        if (!(temp[i].isEmpty() ||temp[i].contains(".")  || temp[i].contains("&&") || temp[i].contains("+") || temp[i].contains("-") || temp[i].contains("*") || temp[i].contains("ArrayLookup")
                        || temp[i].contains("length") || temp[i].contains("<") || temp[i].contains(")")|| temp[i].contains(",")|| temp[i].contains("this") || temp[i].contains("[") )){                      /* if temp[i] is a variable */

                            String varType;
                           
                            if (temp[i].contains("true") || temp[i].contains("false")){

                                int bool;

                                if (temp[i].contains("true"))
                                    bool = 1;
                                else 
                                    bool = 0;

                                varType = "boolean";
                                myFile.write("\tstore i1 " + bool + ", i1* %" + identifier + "\n\n");
                                continue;

                            }else{

                                varType = st.get(stIndex).lookup(temp[i], methodName, currClass);
    
                                /* Check if variable exists in the Symbol Table (has been declared) */
                                if (varType == null){
                                    System.err.println("error: cannot find symbol: " + temp[i]);
                                    System.exit(1);
                                }
                            }
                            String iBits = this.iBits(varType);

                            if(!mathFlag){        
                                myFile.write("\n\t; Load and Store\n");

                                String varType2 = st.get(stIndex).lookup2(temp[i], methodName, currClass, mainClassName);
                                mathFlag = false;
                                
                                if (varType2 == null){
                                    
                                    OffsetTable tempOffsetTable = new OffsetTable(st.get(stIndex).getClassName(currClass), st.get(stIndex),vt.get(currVTable));
                                    int offset = tempOffsetTable.variableOffsets.get(temp[i]) + 8;

                                    myFile.write("\t%t" + registerCounter++ + " =  getelementptr i8, i8* %this, " + iBits + " " + offset + "\n");
                                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8* " + (registerCounter - 2) + " to " + iBits + "*\n");
                                    myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %t" + (registerCounter - 2) + "\n");
                                    myFile.write("\tstore " + iBits + " %t" + (registerCounter-1) + ", " + iBits + "* %" + identifier + "\n\n");
                                    continue;

                                }else{
                                    myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %" + temp[i] + "\n");
                                }
                            }

                            if (methodName.equals("main")){
                                String type = st.get(currSymbolTable).classList.get(currClass).classVarArray.get(identifier);// funList.get(j).varArray.get(identifier);
                                if (type == null){          /* it's not in local variables use offset */
                                    String className = st.get(stIndex).getClassName(currClass);
                                    OffsetTable tempOffsetTable = new OffsetTable(className, st.get(stIndex),vt.get(currVTable));
                                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, i32 " + (tempOffsetTable.variableOffsets.get(identifier) + 8) + "\n");
                                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter-2) + " to " + iBits + "*\n");
                                    myFile.write("\tstore " + iBits + " %t" + (registerCounter - 3) + ", "+ iBits + "* %t" + (registerCounter - 1) + "\n\n");
                                    break;
                                }else{
                             
                                    myFile.write("\tstore " + iBits + " %t" + (registerCounter-1) + ", " + iBits + "* %" + identifier + "\n\n");                               
                                    break;
                                }
                            }
                           
                            /* NA DW AN YPARXEI KAI EXEI DILOTHEI MESA STI SINARTISI ALIWS AN EINAI SE PEDIO KLASHS GETELEMENTPTR */
                            for (int j = 0; j < st.get(currSymbolTable).classList.get(currClass).funList.size(); j++){
                                
                                if (st.get(currSymbolTable).classList.get(currClass).funList.get(j).funName.equals(methodName) ){
                                    String type = st.get(currSymbolTable).classList.get(currClass).funList.get(j).varArray.get(identifier);
                                    
                                    if (type == null){          /* it's not in local variables use offset */
                                        String className = st.get(stIndex).getClassName(currClass);
                                        OffsetTable tempOffsetTable = new OffsetTable(className, st.get(stIndex),vt.get(currVTable));
                                        myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, i32 " + (tempOffsetTable.variableOffsets.get(identifier) + 8) + "\n");
                                        myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter-2) + " to " + iBits + "*\n");
                                        myFile.write("\tstore " + iBits + " %t" + (registerCounter - 3) + ", "+ iBits + "* %t" + (registerCounter - 1) + "\n\n");
                                        break;
                                    }else{
                                        myFile.write("\tstore " + iBits + " %t" + (registerCounter-1) + ", " + iBits + "* %" + identifier + "\n\n");
                                        //myFile.write("\tstore " + iBits + " %t" + (registerCounter-1) + ", " + iBits + "* %" + identifier + "\n\n");
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
                mathFlag = false;
            }
        }
        return "AssignmentStatement";
    }

    /**
     * f0 -> Identifier()
    * f1 -> "["
    * f2 -> Expression()
    * f3 -> "]"
    * f4 -> "="
    * f5 -> Expression()
    * f6 -> ";"
    */
    public String visit(ArrayAssignmentStatement n, String identifier) throws Exception {

        if (typeCheck){

            String arraysName = n.f0.accept(this,identifier);
            String index = n.f2.accept(this,identifier);
            String expr = n.f5.accept(this,identifier);
            String arraysType = st.get(currSymbolTable).lookup(arraysName, identifier, currClass);

            /* Identifier or "arraysName" must be type "int[]" */
            if (arraysType.equals("int[]") == false){
                System.err.println("error: in array assignment: array required");
                System.exit(1);
            }

            /* Check the index => must be type int*/       
            if (isNumeric(index)){                       /* If index is a number */

                myFile.write("\t%t" + registerCounter++ + " = load i32*, i32** %" + arraysName + "\n");
                myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %t" + (registerCounter-2) + "\n");
                myFile.write("\t%t" + registerCounter++ + " = icmp sge i32 0, 0\n");
                myFile.write("\t%t" + registerCounter++ + " = icmp slt i32 0, %t" + (registerCounter - 3) + "\n");
                myFile.write("\t%t" + registerCounter++ + " = and i1 %t" + (registerCounter - 3) + ", %t" + (registerCounter -2) +"\n");
                myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %oob_ok_" + oobCounter + ", label %oob_err_" + oobCounter + "\n\n");
                
                myFile.write("\toob_err_" + oobCounter + ":\n");
                myFile.write("\tcall void @throw_oob()\n");
                myFile.write("\tbr label %oob_ok_" + oobCounter + "\n\n");

                myFile.write("\toob_ok_" + oobCounter + ":\n");

                myFile.write("\t%t" + registerCounter++ + " = add i32 1, " + index + "\n");
                myFile.write("\t%t" + registerCounter++ + " = getelementptr i32, i32* %t" + (registerCounter - 7) + ", i32 %t" + (registerCounter - 2) + "\n");
                myFile.write("\tstore i32 " + expr + ", i32* %t" + (registerCounter - 1) + "\n");
                myFile.write("\n");
                oobCounter++;

            }else{                                       /* If index is a variable => check variable's type */

                String indexType = st.get(currSymbolTable).lookup(index, identifier, currClass);
                
                /* Check if variable called "index" exists in the Symbol Table */
                if (indexType == null){   
                    System.err.println("error: in array assignment: cannot find symbol: " + index);
                    System.exit(1);
                }
                
                /* Ckeck if variable called "indexType" isn't type "int" */
                if (indexType.equals("int") == false){       
                    System.err.println("error: in array assignment index must be type int");
                    System.exit(1);
                }
            }

            /* Check expression => must be type int */
            if (isNumeric(expr))                       /* If index is a number */
                return "ArrayAssignmentStatement";

            else if(expr.contains("ArrayLookup") || expr.contains("+") || expr.contains("-") || expr.contains("*"))    /* If it's a PrimaryExpression it's already checked */
                return "ArrayAssignmentStatement";

            else if (expr.contains("MessageSend ")){             /* If it's a message send */

                String exprType = expr.replace("MessageSend ","");

                /* Ckeck if variable called "exprType" isn't type "int" */
                if (exprType.equals("int") == false){       
                    System.err.println("error: in array assignment expression must be type int");
                    System.exit(1);
                }

            }else{                                       /* If expr is a variable => check variable's type */

                String exprType = st.get(currSymbolTable).lookup(expr, identifier, currClass);
                
                /* Check if variable called "expr" exists in the Symbol Table */
                if (exprType == null){   
                    System.err.println("error: in array assignment: cannot find symbol: " + expr);
                    System.exit(1);
                }
                
                /* Ckeck if variable called "exprType" isn't type "int" */
                if (exprType.equals("int") == false){       
                    System.err.println("error: in array assignment expression must be type int");
                    System.exit(1);
                }
            }
        }
        return "ArrayAssignmentStatement";
    }

    /**
     * f0 -> "if"
    * f1 -> "("
    * f2 -> Expression()
    * f3 -> ")"
    * f4 -> Statement()
    * f5 -> "else"
    * f6 -> Statement()
    */
    public String visit(IfStatement n, String argu) throws Exception {

        String expr = n.f2.accept(this,argu);

        if (typeCheck){
            
            ifCounter++;
            System.out.println("to expr einai: " + expr + " sti sinartisi " + argu);
            myFile.write("\t; stin arxh tou IfStatement\n");

            String temp[] = expr.split(" ");
            String comparison = "";
            String varType = "";
            String iBits = "";

            for (int i = 0; i < temp.length; i++) {

                if (temp[i].contains("<")){
                    comparison = "slt";
                    continue;
                }

                if(temp[i].contains("&&")){
                    continue;
                }

                if (this.isNumeric(temp[i])){
                    if (i == (temp.length - 1)){
                        myFile.write("\t%t" + registerCounter++ + " = icmp " + comparison + " " + iBits + " %t" + (registerCounter-2) + ", " + temp[i] +"\n");
                    }
                    continue;
                }

                if (temp[i].contains("("))
                    temp[i] = temp[i].replace("(","");

                if (temp[i].contains(")"))
                    temp[i] = temp[i].replace(")","");

                /* Fint the variable's type to calculate the number of bits (iBits) */
                varType = st.get(currSymbolTable).lookup(temp[i], argu, currClass);

                if (varType == null){
                    System.err.println("cannot find symbol: " + temp[i]);
                    System.exit(1);
                }
                iBits = this.iBits(varType);

            }

            int tempIfCounter = ifCounter;
            myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %if_then_" + tempIfCounter + ", label %if_else_" + tempIfCounter + "\n\n");
            myFile.write("\tif_then_" + tempIfCounter + ":\n");
            String stat1 = n.f4.accept(this,argu);
            myFile.write("\tbr label %if_end_" + tempIfCounter + "\n\n");

            myFile.write("\tif_else_" + tempIfCounter + ":\n");
            String stat2 = n.f6.accept(this,argu);
            myFile.write("\tbr label %if_end_" + tempIfCounter + "\n\n");

            myFile.write("\tif_end_" + tempIfCounter +":\n");

        }

        return "IfStatement";
    }

    /**
     * f0 -> "while"
    * f1 -> "("
    * f2 -> Expression()
    * f3 -> ")"
    * f4 -> Statement()
    */
    public String visit(WhileStatement n, String argu) throws Exception {

        
        if (typeCheck){
            
            myFile.write("\tbr label %loop" + loopCounter + "\n\n");
            myFile.write("\tloop" + loopCounter++ + ":\n");
            
            String expr = n.f2.accept(this,argu);

            myFile.write("\tbr i1 %t" + (registerCounter-1) + ", label %loop" + loopCounter + ", label %loop" + ++loopCounter + "\n\n");
            myFile.write("\tloop" + (loopCounter-1) + ":\n");

            String stat1 = n.f4.accept(this,argu);

            myFile.write("\tbr label %loop" + (loopCounter-2) + "\n");
            myFile.write("\tloop" + loopCounter++ + ":\n");  
        }

        return " ";
    }

    /**
     * f0 -> "System.out.println"
    * f1 -> "("
    * f2 -> Expression()
    * f3 -> ")"
    * f4 -> ";"
    */
    public String visit(PrintStatement n, String methodName) throws Exception {
        
        /* only accept expressions of type int as the argument of the PrintStatement */
        String varName = n.f2.accept(this, methodName);

        if (typeCheck){

            String varType = null;

            if (this.isNumeric(varName)){                            /* It's a number = int => ok */
                myFile.write("\tcall void (i32) @print_int(i32 " + varName + ")\n");
                return "System.out.println(" + varName + ")";
            
            }else if ((varName.contains("+")) || (varName.contains("-")) || (varName.contains("*"))){     /* It's a primary expression */
                
                myFile.write("\tcall void (i32) @print_int(i32 %t" + (registerCounter - 1) + ")\n");
                return "System.out.println(" + varName + ")";

            }else if (varName.contains("ArrayLookup")){                         /* It's an index in an int array = int => ok */
                varName = varName.replace("ArrayLookup ","");
                
                myFile.write("\t;Array lookup sto print statement\n");
                myFile.write("\tcall void (i32) @print_int(i32 %t" + (registerCounter - 1) + ")\n");
                return "System.out.println(" + varName + ")";

            }else if (varName.contains("["))                         /* It's an index in an int array = int => ok */
                return "System.out.println(" + varName + ")";

            else if (varName.contains("MessageSend ")){             /* It's a method call */
                varType = varName.replace("MessageSend ","");

                myFile.write("\tcall void (i32) @print_int(i32 %t" + (registerCounter - 1) + ")\n");

            }else{
                varType = st.get(currSymbolTable).lookup(varName, methodName, currClass);

                /* Print a variable type int e.g. System.out.println(x); */
                myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %" + varName + "\n");
                myFile.write("\tcall void (i32) @print_int(i32 %t" + (registerCounter-1) + ")\n");
            }                                                       /* It's a variable => get variable's type */
            
            /* Check if variable exists in the Symbol Table (has been declared) */
            if (varType == null){
                System.err.println("error: in print statement: cannot find symbol: " + varName);
                System.exit(1);
            }

            /* Identifier or "arraysName" must me type "int[]" */
            if (varType.equals("int") == false){
                System.err.println("error: in print statement: int required");
                System.exit(1);
            }

           
        }
        return "System.out.println(" + varName + ")";
    }

    /**
     * f0 -> AndExpression()
    *       | CompareExpression()
    *       | PlusExpression()
    *       | MinusExpression()
    *       | TimesExpression()
    *       | ArrayLookup()
    *       | ArrayLength()
    *       | MessageSend()
    *       | PrimaryExpression()
    */
    public String visit(Expression n, String argu) throws Exception {
        return n.f0.accept(this, argu);
    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "&&"
    * f2 -> PrimaryExpression()
    */
    public String visit(AndExpression n, String methodName) throws Exception {
        
        System.out.println("mpainei sto && expression sti sinartisi " + methodName);
        String expr1 = n.f0.accept(this,methodName);
        String expr2 = n.f2.accept(this,methodName);

        if (typeCheck){
            String varType = st.get(currSymbolTable).lookup(expr1, methodName, currClass);
            
            if (varType == null){
                System.out.println("error: cannot find symbol");
                System.exit(1);
            }
            
            String iBits = this.iBits(varType);
            //load expr1
            myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %" + expr1 + "\n");

            /* check result */
            myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %exp_res_" + (expResCounter+1) + ", label %exp_res_" + expResCounter + "\n\n");

            myFile.write("\texp_res_" + expResCounter + ":\n");
            myFile.write("\tbr label %exp_res_" + (expResCounter+3) + "\n\n");

            myFile.write("\texp_res_" + (expResCounter+1) + ":\n");
            myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %" + expr2 + "\n");
            myFile.write("\tbr label %exp_res_" + (expResCounter+2) + "\n\n");

            myFile.write("\texp_res_" + (expResCounter+2) + ":\n");
            myFile.write("\tbr label %exp_res_" + (expResCounter+3) + "\n\n");
            
            myFile.write("\texp_res_" + (expResCounter+3) + ":\n");
            myFile.write("\t%t" + registerCounter++ + " = phi i1 [ %t" + (registerCounter - 3) +",");
            myFile.write("\t %exp_res_" + expResCounter + " ], [ %t" + (registerCounter-2) + ", %exp_res_" + (expResCounter + 2 + " ]\n"));
            
            expResCounter++;
        }

        return expr1 + " && " +  expr2;
    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "<"
    * f2 -> PrimaryExpression()
    */
    public String visit(CompareExpression n, String argu) throws Exception {

        String expr1 = n.f0.accept(this,argu);
        String expr2 = n.f2.accept(this,argu);

        if (typeCheck){

            myFile.write("\n\t; CompareExpression\n");
            
            if (this.isNumeric(expr1)){

            }else{

                String varType = st.get(currSymbolTable).lookup2(expr1, argu, currClass, mainClassName);
                
                if (varType == null){   /* then variable is in class fields => load */

                }else{
                    String iBits = this.iBits(varType);
                    myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %" + expr1 + "\n");

                }
                
            }
            
            if (this.isNumeric(expr2)){
                
            }else{
                
                if (expr2.contains("(") && expr2.contains(")")){
                    expr2 = expr2.replace("(","");
                    expr2 = expr2.replace(")","");
                }
                
                String varType = st.get(currSymbolTable).lookup2(expr2, argu, currClass, mainClassName);
                
                if (varType == null){       /* If the variable is in a class field */

                    String className = st.get(currSymbolTable).getClassName(currClass);
                    OffsetTable tempOffsetTable = new OffsetTable(className, st.get(currSymbolTable),vt.get(currVTable));
                    int offset = tempOffsetTable.variableOffsets.get(expr2);
        
                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, i32 " + (offset + 8) + "\n");    
                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to i32*\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %t" + (registerCounter -2) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = icmp slt i32 %t" + (registerCounter - 5) + ", %t" + (registerCounter - 2) + "\n");
                    
                }else{
                    String iBits = this.iBits(varType);
                    myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %" + expr2 + "\n");
                }
                
            }

            // if ((this.isNumeric(expr1) == false) && (this.isNumeric(expr2) == false)){
            //     myFile.write("\t%t" + registerCounter++ + " = icmp slt i32 %t" + (registerCounter - 3) + ", %t" + (registerCounter - 2) +"\n");
            // }
        }

        return expr1 + " < " + expr2;
    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "+"
    * f2 -> PrimaryExpression()
    */
    public String visit(PlusExpression n, String methodName) throws Exception {

        String expr1 = n.f0.accept(this,methodName);
        String expr2 = n.f2.accept(this,methodName);

        if (typeCheck){

            if (expr1.contains("ArrayLookup") && expr2.contains("ArrayLookup")){
                System.out.println("PRAKSI METAKSI ARRAYS");
                myFile.write("\t%t" + registerCounter++ + " = add i32 %t" + (registerCounter - 10) + ", %t" + (registerCounter -2) +"\n");
            }

            if ((this.isNumeric(expr1) == false) && (this.isNumeric(expr2))){

                String exprType = st.get(currSymbolTable).lookup2(expr1, methodName, currClass, mainClassName);
                if (exprType == null){

                    String className = st.get(currSymbolTable).getClassName(currClass);
                    OffsetTable tempOffsetTable = new OffsetTable(className, st.get(currSymbolTable),vt.get(currVTable));
                    
                    String exprType2 = st.get(currSymbolTable).lookup(expr1, methodName, currClass);
                    String iBits = this.iBits(exprType2);

                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, " + iBits + " " + (tempOffsetTable.variableOffsets.get(expr1) + 8) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8 %t*, " + (registerCounter - 2) + "to " + iBits + "*\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %" + (registerCounter - 2) + "\n"); 
                    myFile.write("\t%t" + registerCounter++ + " = add i32 %t" + (registerCounter - 2) + ", " + expr2 +"\n");
            
                }else{
                    
                    myFile.write("\t%t" + registerCounter++ + " = add i32 %t" + (registerCounter - 2) + ", " + expr2 +"\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %" + expr1 + "\n");    
                }
                                
                mathFlag = true;
            }
        }

        return expr1 + " + " + expr2;
    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "-"
    * f2 -> PrimaryExpression()
    */
    public String visit(MinusExpression n, String argu) throws Exception {
        
        String x = n.f0.accept(this,argu);
        
        if (typeCheck){
            
            myFile.write("\n\t; MinusExpression\n");
            mathFlag = true;

            /* If x is a variable => load x */
            if ((x.contains("MessageSend") == false) && (x.contains("[") == false) && (this.isNumeric(x) == false)){
                
                String varType = st.get(currSymbolTable).lookup(x, argu, currClass);     
                String iBits2 = this.iBits(varType);

                myFile.write("\t%t" + registerCounter++ + " = load " + iBits2 + ", " + iBits2 + "* %" + x + "\n");
            }
                
            String y = n.f2.accept(this,argu);
            System.out.println("to x einai: " + x + " kai to y einai: " + y);

            /* If y is a number do the substraction */
            if (this.isNumeric(y)){
                myFile.write("\t%t" + registerCounter++ + " = sub i32 %t" + (registerCounter - 2) + ", " + y +"\n\n");
                return x + " - " + y;
            }
           
            
            return x + " - " + y;
        }
        return " - ";

    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "*"
    * f2 -> PrimaryExpression()
    */
    public String visit(TimesExpression n, String argu) throws Exception {
        String x = n.f0.accept(this,argu);
        boolean xIsVar = false;
        
        if (typeCheck){
            
            mathFlag = true;
            myFile.write("\t; Sto Times Expression \n");

            /* If x is a variable => load x */
            if ((x.contains("MessageSend") == false) && (x.contains("[") == false) && (this.isNumeric(x) == false)){
                
                String varType = st.get(currSymbolTable).lookup(x, argu, currClass);     
                String iBits2 = this.iBits(varType);

                myFile.write("\t%t" + registerCounter++ + " = load " + iBits2 + ", " + iBits2 + "* %" + x + "\n");
                xIsVar = true;
            }
                
            String y = n.f2.accept(this,argu);

            /* If y is a variable => load y */
            if ((y.contains("MessageSend") == false) && (y.contains("[") == false) && (this.isNumeric(y) == false)){
                
                String varType = st.get(currSymbolTable).lookup(y, argu, currClass);     
                String iBits2 = this.iBits(varType);

                myFile.write("\t%t" + registerCounter++ + " = load " + iBits2 + ", " + iBits2 + "* %" + y + "\n");
                
                if (this.isNumeric(x)){
                    myFile.write("\t%t" + registerCounter++ + " = mul i32 " + x + ", %t" + (registerCounter - 2) +"\n");
                }
            
            }

            /* If y is a number do the multiplication */
            if (this.isNumeric(y)){
                myFile.write("\t%t" + registerCounter++ + " = mul i32 %t" + (registerCounter - 2) + ", " + y +"\n");
                return x + " * " + y;
            }

            if (y.contains("MessageSend")){

                myFile.write("\t%t" + registerCounter++ + " = mul i32 %t" + (registerCounter - 10) + ", %t" + (registerCounter - 2) + "\n");
                myFile.write("\t; Sto Times Expression BGAINEI 22222 \n");
            }
           

            return x + " * " + y;
        }
        return " * ";

    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "["
    * f2 -> PrimaryExpression()
    * f3 -> "]"
    */
    public String visit(ArrayLookup n, String methodName) throws Exception {

        String arraysName = n.f0.accept(this, methodName);                                           /* Get array's name */
        String arraysType = st.get(currSymbolTable).lookup(arraysName, methodName, currClass);      /* Get array's type */

        if (typeCheck){

            System.out.println("EINAI STI SYNARTISI ARRAY LOOKUP");
            myFile.write("\t; einai sto array look up: " + arraysName + "\n");
          
            /* Check if variable "arraysName" exists in the Symbol Table */
            if (arraysType == null){
                System.err.println("error: in array lookup: array " + arraysName + " wasn't found");
                System.exit(1);
            }

            /* Identifier or "arraysName" must be type "int[]" */
            if (arraysType.equals("int[]") == false){
                System.err.println("error: in array lookup: array required");
                System.exit(1);
            }
    
            /* The arraysIndex must be type "int" */
            String arraysIndex = n.f2.accept(this, methodName);
    
            if (arraysIndex.contains("MessageSend")){       /* If it's a method call => only keep the return type (remove "MessageSend") */

                arraysIndex = arraysIndex.replace("MessageSend", "");

                if (arraysIndex.equals("int") == false){
                    System.err.println("error: in array lookup: index must be type int");
                    System.exit(1);
                }

            }else{      /* If it's not a method call */ 
                
                if (this.isNumeric(arraysIndex) == false){      /* It's a variable => check the variable's type */

                    /* Get variable's "arraysIndexType" type */
                    String arraysIndexType = st.get(currSymbolTable).lookup(arraysIndex, methodName, currClass);

                    /* Check if variable "arraysIndex" exists in the Symbol Table */
                    if (arraysIndexType == null){
                        System.err.println("error: in array lookup: cannot find symbol " + arraysIndex);
                        System.exit(1);
                    }

                    /* Check if variable "arraysIndexType" is type "int" */
                    if (arraysIndexType.equals("int") == false){
                        System.err.println("error: in array lookup: index must be type int");
                        System.exit(1);
                    }

                    /* If array is in class fiels => load it */
                    String className = st.get(currSymbolTable).getClassName(currClass);
                    OffsetTable tempOffsetTable = new OffsetTable(className, st.get(currSymbolTable),vt.get(currVTable));
                    int offset = tempOffsetTable.variableOffsets.get(arraysName);
                    
                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i8, i8* %this, i32 " + (offset + 8) + "\n");    
                    myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to i32**\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32*, i32** %t" + (registerCounter -2) + "\n\n");
                    
                    /* load the index (variable) */
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %" + arraysIndex + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %t" + (registerCounter - 3) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = icmp ult i32 %t" + (registerCounter - 3) + ", %t" + (registerCounter - 2) +"\n");
                    myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %oob_ok_" + oobCounter + ", label %oob_err_" + oobCounter + "\n\n");

                    myFile.write("\toob_ok_" + oobCounter + ":\n");
    
                    myFile.write("\t%t" + registerCounter++ + " = add i32 %t" + (registerCounter - 4) + ", 1\n");
                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i32, i32* %t" + (registerCounter - 6) + ", i32 %t" + (registerCounter - 2) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %t" + (registerCounter -2) + "\n");
                    myFile.write("\tbr label %oob_end_" + oobCounter + "\n\n");

                    myFile.write("\toob_err_" + oobCounter + ":\n");
                    myFile.write("\tcall void @throw_oob()\n");
                    myFile.write("\tbr label %oob_end_" + oobCounter + "\n\n");

                    myFile.write("\toob_end_" + oobCounter++ + ":\n");
                    
                    //myFile.write("\t%t" + registerCounter++ + " = icmp slt i32 %t" + (registerCounter - 4) + ", i32* %t" + (registerCounter - 2) + "\n");

                }else{          /* If the index is  a number */

                    myFile.write("\t%t" + registerCounter++ + " = load i32*, i32** %" + arraysName + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %t" + (registerCounter-2) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = icmp sge i32 0, 0\n");
                    myFile.write("\t%t" + registerCounter++ + " = icmp slt i32 0, %t" + (registerCounter - 3) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = and i1 %t" + (registerCounter - 3) + ", %t" + (registerCounter -2) +"\n");
                    myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %oob_ok_" + oobCounter + ", label %oob_err_" + oobCounter + "\n\n");
                    
                    myFile.write("\toob_err_" + oobCounter + ":\n");
                    myFile.write("\tcall void @throw_oob()\n");
                    myFile.write("\tbr label %oob_ok_" + oobCounter + "\n\n");
    
                    myFile.write("\toob_ok_" + oobCounter + ":\n");
    
                    myFile.write("\t%t" + registerCounter++ + " = add i32 1, " + arraysIndex + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = getelementptr i32, i32* %t" + (registerCounter - 7) + ", i32 %t" + (registerCounter - 2) + "\n");
                    myFile.write("\t%t" + registerCounter++ + " = load i32, i32* %t" + (registerCounter -2) + "\n");
                    myFile.write("\n");
                    oobCounter++;
                }
            }
        }

        return "ArrayLookup " + n.f0.accept(this,methodName) + "[" +  n.f2.accept(this,methodName) + "]";
    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "."
    * f2 -> "length"
    */
    public String visit(ArrayLength n, String methodName) throws Exception {

        String arraysName = n.f0.accept(this,methodName);
        
        if (typeCheck){
            
            String arraysType = st.get(currSymbolTable).lookup(arraysName, methodName, currClass);      /* Get array's type */

            /* Check if variable "arraysName" exists in the Symbol Table (has been declared) */
            if (arraysType == null){
                System.err.println("error in ArrayLength: array " + arraysName + " wasn't found");
                System.exit(1);
            }

            /* Identifier or "arraysName" must be type "int[]" */
            if (arraysType.equals("int[]") == false){
                System.err.println("error: in ArrayLength: array required");
                System.exit(1);
            }
        }

        return arraysName + ".length"; 
    }

    /**
     * f0 -> PrimaryExpression()
    * f1 -> "."
    * f2 -> Identifier()
    * f3 -> "("
    * f4 -> ( ExpressionList() )?
    * f5 -> ")"
    */
    public String visit(MessageSend n, String methodName) throws Exception {

        /* methodName = the name of the method that this MessageSend is inside */
        String idMethod = n.f2.accept(this, methodName);

        if (typeCheck){

            String prExpr = n.f0.accept(this,methodName);
            System.out.println(prExpr + "." + idMethod);
            int stIndex = currSymbolTable;                                 /* the symbol table index to search */
            String className;
            String funType;
            boolean itsAllocarionExpr = false;
            boolean itsThisExpr = false;
            
            if (prExpr.contains("AllocationExpression")){           /* e.g new A() */
                
                className = prExpr.replace("AllocationExpression", "");      /* Remove the keyword "AllocationExpression" from the string to keep only the class name */
                itsAllocarionExpr = true;
                
            }else if (prExpr.contains("(MessageSend ")){                    /* e.g. (p_node.GetLeft()).GetKey(); messageSend.messagesend */
                
                prExpr = prExpr.replace("(MessageSend ", "");
                className = prExpr.replace(")", "");
                
            }else{
                
                if (prExpr.equals("this")){
                    className = st.get(stIndex).getClassName(currClass);
                    itsThisExpr = true;
                }else
                    className = st.get(stIndex).lookup(prExpr, methodName, currClass);       /* If prExpr is a variable => variable's type is a className e.g. Tree r => Tree is a varType and a className */
                
                if (className == null){
                    System.err.println("error: cannot find symbol: " + prExpr + " inside the function called: " + methodName);
                    System.exit(1);
                }
            }
            
            stIndex = this.findSTindex(className);    // varType == className
            int vtIndex = this.findVTindex(className);
            
            /* Check if className exists in the Symbol Table */
            if (stIndex == -1){
                System.err.println("error: cannot find class: " + className);
                System.exit(1);
            }
            
            /* Get the function's type */
            funType = st.get(stIndex).findFunName(idMethod);
            
            /* Check if there is a function called "idMethod" in this class or in a parent class */
            if (funType == null){
                System.err.println("erorr: cannot find method: " + idMethod + " in class: " + className);
                System.exit(1);
            }
            
            /* FOR MESSAGE SEND */
            int receiverObject;
            
            myFile.write("\n\t; Message send here \n");
            
            if((!itsAllocarionExpr) && (!itsThisExpr)){
                myFile.write("\t%t" + registerCounter++ + " = load i8*, i8** %" + prExpr + "\n");
                receiverObject = registerCounter - 1;
            }else{
                receiverObject = registerCounter - 3;
            }
            
            if (itsAllocarionExpr)
                myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 4) + " to i8***\n");
            else if (itsThisExpr)
                myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %this to i8***\n");
            else
                myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to i8***\n");
            
            myFile.write("\t%t" + registerCounter++ + " = load i8**, i8*** %t" + (registerCounter - 2) + "\n");

            OffsetTable tempOffsetTable = new OffsetTable(className, st.get(stIndex),vt.get(currVTable));
            
            int offset = 0;
            for (int k = 0; k < tempOffsetTable.vtable.funList.size(); k++) {
                if (tempOffsetTable.vtable.funList.get(k).funName.equals(idMethod)){
                    offset = tempOffsetTable.vtable.funList.get(k).offset;
                }
            }

            myFile.write("\t%t" + registerCounter++ + " = getelementptr i8*, i8** %t" + (registerCounter - 2) + ", i32 " + offset/8 + "\n");
            myFile.write("\t%t" + registerCounter++ + " = load i8*, i8** %t" + (registerCounter - 2) + "\n");
            
            String funTypeBits = this.iBits(funType);
            myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to " + funTypeBits + " (i8*");
            
            int bitcastRegister = registerCounter - 1;

            for (int i = 0; i < vt.get(vtIndex).funList.size(); i++){
                
                if (vt.get(vtIndex).funList.get(i).funName.equals(idMethod)){
                    for (Map.Entry<String, String> entry : vt.get(vtIndex).funList.get(i).argsArray.entrySet()) {            /* For every variable in the class */
                        myFile.write("," + this.iBits(entry.getValue()));
                    }
                }
            }
            myFile.write(")*\n");
            
            /* EDW PAIRNW TA ORISMATA */
            String expressionList = n.f4.present() ? n.f4.accept(this, methodName) : "";      /* Get the function arguments */
            String[] args = expressionList.split(", |,");
            ArrayList<Integer> registerNumbers = new ArrayList<Integer>();
            
            int numOfArgs; 
            if (expressionList.isEmpty()){            /* Get the number of arguments in the function call */
                numOfArgs = 0;
            }else{  
                numOfArgs = args.length;
            }
            
            /* LOAD THE VARIABLES NEEDED FOR THE CALL */
            for (int x = 0; x < args.length ; x++){         /* Get the type of each argument in an array called argsTypes */
                    
                if (args[x].endsWith(" "))
                    args[x] = args[x].substring(0,args[x].length() - 1);
                
                if (this.isNumeric(args[x])){
                    //myFile.write(", i32 " + args[x]);
                    continue;
                }

                if (args[x].contains("+") || (args[x].contains("-")) || (args[x].contains("*"))){
                    //myFile.write(", i32 %t" + (registerCounter - 1));
                    continue;
                }

                if (args[x].equals("true") || args[x].equals("false")){
                    //myFile.write(", i1 " + args[x]);
                    continue;
                }
                
                if (args[x].contains("MessageSend ")){
                    args[x] = args[x].replace("MessageSend ", "");
                    //argsTypes.add(args[x]);
                    continue;
                }
                
                if (args[x].contains("this")){
                    //argsTypes.add(st.get(currSymbolTable).getClassName(currClass));
                    continue;
                }

                if (args[x].isEmpty() == false){
                    /* If argument is a variable get argumen't type */
                    String arguType = st.get(currSymbolTable).lookup(args[x], methodName, currClass);
                    
                    if (arguType == null){
                        System.err.println("erorr cannot find symbol: " + args[x]);
                        System.exit(1);
                    }
                    String iBits3 = this.iBits(arguType);
                    myFile.write("\t%t" + registerCounter++ + " = load " + iBits3 + ", " + iBits3 + "* %" + args[x] + "\n");
                    registerNumbers.add(registerCounter - 1);
                }
                
            }

            /* Perform the call */
            String iBits = this.iBits(funType);
            
            if (itsThisExpr)
                myFile.write("\t%t" + registerCounter + " = call " + iBits + " %t" + bitcastRegister + "(i8* %this");
            else
                myFile.write("\t%t" + registerCounter + " = call " + iBits + " %t" + (registerCounter - 1) + "(i8* %t" + receiverObject);
            
            itsAllocarionExpr = false;
            itsThisExpr = false;
            int counter = 0;

            for (int x = 0; x < args.length ; x++){         /* Get the type of each argument in an array called argsTypes */
                    
                if (args[x].endsWith(" "))
                    args[x] = args[x].substring(0,args[x].length() - 1);
                
                if (this.isNumeric(args[x])){
                    myFile.write(", i32 " + args[x]);
                    continue;
                }

                if (args[x].contains("+") || (args[x].contains("-")) || (args[x].contains("*"))){
                    myFile.write(", i32 %t" + (registerCounter - 1));
                    continue;
                }

                if (args[x].equals("true") || args[x].equals("false")){
                    myFile.write(", i1 " + args[x]);
                    continue;
                }
                
                if (args[x].contains("MessageSend ")){
                    args[x] = args[x].replace("MessageSend ", "");
                    
                    continue;
                }
                
                if (args[x].contains("this")){
                    
                    continue;
                }

                if (args[x].isEmpty() == false){
                    /* If argument is a variable get argumen't type */
                    String arguType = st.get(currSymbolTable).lookup(args[x], methodName, currClass);
                    
                    if (arguType == null){
                        System.err.println("erorr cannot find symbol: " + args[x]);
                        System.exit(1);
                    }
                    String iBits3 = this.iBits(arguType);
                    myFile.write(", i32 %t" + registerNumbers.get(counter++));
                }
                
            }
            myFile.write(")\n");
            registerCounter++;

            /* ---------------------------------------------------------------- */

            return "MessageSend " + funType;
        }
        return " ";
    }
    
    
    /**
     * f0 -> Expression()
     * f1 -> ExpressionTail()
     */
    public String visit(ExpressionList n, String argu) throws Exception {
        
        String ret = n.f0.accept(this, argu);
        return ret + " " + n.f1.accept(this, argu);
    }

    /**
     * f0 -> ( ExpressionTerm() )*
    */     
    public String visit(ExpressionTail n, String argu) throws Exception {

        String ret = "";
        NodeListOptional varDecls = n.f0;

        for (int i = 0; i < varDecls.size(); ++i) {
            ExpressionTerm varDecl = (ExpressionTerm) varDecls.elementAt(i);
            ret = ret + ", " + varDecl.f1.accept(this,argu);
        }
        return ret;
    }

    /**
     * f0 -> ","
    * f1 -> Expression()
    */
    public String visit(ExpressionTerm n, String argu) throws Exception {
        return n.f1.accept(this,argu);
    }

    /**
     * f0 -> IntegerLiteral()
    *       | TrueLiteral()
    *       | FalseLiteral()
    *       | Identifier()
    *       | ThisExpression()
    *       | ArrayAllocationExpression()
    *       | AllocationExpression()
    *       | NotExpression()
    *       | BracketExpression()
    */
    public String visit(PrimaryExpression n, String argu) throws Exception {
        return n.f0.accept(this, argu);
    }

    /**
     * f0 -> <INTEGER_LITERAL>
    */
    public String visit(IntegerLiteral n, String argu) throws Exception {
        return n.f0.toString();    
    }

    /**
     * f0 -> "true"
    */
    public String visit(TrueLiteral n, String argu) throws Exception {
        return "true";    
    }

    /**
     * f0 -> "false"
    */
    public String visit(FalseLiteral n, String argu) throws Exception {
        return "false";    
    }
   
    /**
    * f0 -> <IDENTIFIER>
    */ 
    public String visit(Identifier n, String argu) {
        return n.f0.toString();   
    }

    /**
    * f0 -> "this"
    */ 
    public String visit(ThisExpression n, String argu) throws Exception {
        return "this";
    }

    /**
     * f0 -> "new"
    * f1 -> "int"
    * f2 -> "["
    * f3 -> Expression()
    * f4 -> "]"
    */
    public String visit(ArrayAllocationExpression n, String methodName) throws Exception {

        String expr = n.f3.accept(this,methodName);
        boolean isVarFlag = false;

        if (typeCheck){

            /* expr must be type int (it's an index) */
            if (isNumeric(expr)){                            /* If index is a number */

                myFile.write("\t%t" + registerCounter++ + " = add i32 1, " + expr + "\n");
                /* Check that the size of the array is not negative (>=1) */
                myFile.write("\t%t" + registerCounter++ + " = icmp sge i32 %t" + (registerCounter - 2) + ", 1\n");
                myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %nsz_ok_" + nszCounter + ", label %nsz_err_" + nszCounter + "\n\n");
                //return "ArrayAllocationExpression " + expr;

            }else if (expr.contains("+") || expr.contains("-") || expr.contains("*")){    /* If it's a PrimaryExpression => it's already checked */
                //return "ArrayAllocationExpression " + expr;
            
            }else if (expr.contains("MessageSend ")){    /* If it's a PrimaryExpression => it's already checked */
                expr = expr.replace("MessageSend ", "");

                if (expr.equals("int") == false){
                    System.err.println("error: in array assignment expression must be type int");
                    System.exit(1);
                }

            }else{                                       /* If expr is a variable => check variable's type */

                String exprType = st.get(currSymbolTable).lookup(expr, methodName, currClass);
                
                /* Check if variable called "expr" exists in the Symbol Table */
                if (exprType == null){   
                    System.err.println("error: in array assignment: cannot find symbol: " + expr);
                    System.exit(1);
                }
                
                /* Ckeck if variable called "exprType" isn't type "int" */
                if (exprType.equals("int") == false){       
                    System.err.println("error: in array assignment expression must be type int");
                    System.exit(1);
                }

                String iBits = this.iBits(exprType);

                myFile.write("\t%t" + registerCounter++ + " = load " + iBits + ", " + iBits + "* %" + expr + "\n");
                myFile.write("\t%t" + registerCounter++ + " = icmp slt i32 %t" + (registerCounter - 2) + ", 0\n");
                /* Check that the size of the array is not negative (>=1) */
                myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %nsz_ok_" + nszCounter + ", label %nsz_err_" + nszCounter + "\n\n");
                myFile.write("\tnsz_err_" + nszCounter + ":\n");
                myFile.write("\tcall void @throw_nsz()\n");
                myFile.write("\tbr label %nsz_ok_" + nszCounter + "\n\n");

                myFile.write("\tnsz_ok_" + nszCounter + ":\n");
               
                myFile.write("\t%t" + registerCounter++ + " add i32 %t" + (registerCounter - 3) + ", 1\n");

                myFile.write("\t%t" + registerCounter++ + " = call i8* @calloc(i32 %t" + (registerCounter-3) + ", i32 4)\n");
                myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to i32*\n");
                myFile.write("\tstore i32 %t" + (registerCounter-5) + ", i32* %t" + (registerCounter-1) + "\n");
                isVarFlag = true;
                return "ArrayAllocationExpression " + expr;
            }

            /* Check that the size of the array is not negative (>=1) */
            //myFile.write("\tbr i1 %t" + (registerCounter - 1) + ", label %nsz_ok_" + nszCounter + ", label %nsz_err_" + nszCounter + "\n\n");

            myFile.write("\tnsz_err_" + nszCounter + ":\n");
            myFile.write("\tcall void @throw_nsz()\n");
            myFile.write("\tbr label %nsz_ok_" + nszCounter + "\n\n");

            myFile.write("\tnsz_ok_" + nszCounter + ":\n");
            if (isVarFlag)
                myFile.write("\t%t" + registerCounter++ + " add i32 %t" + (registerCounter - 3) + ", 1\n");

            myFile.write("\t%t" + registerCounter++ + " = call i8* @calloc(i32 %t" + (registerCounter-3) + ", i32 4)\n");
            myFile.write("\t%t" + registerCounter++ + " = bitcast i8* %t" + (registerCounter - 2) + " to i32*\n");
            
            if (this.isNumeric(expr))
                myFile.write("\tstore i32 " + expr + ", i32* %t" + (registerCounter - 1) + "\n");
            else{
                
                if (isVarFlag){
                    myFile.write("\tstore i32 %t" + (registerCounter - 1) + ", i32* %t" + (registerCounter - 2) + "\n");
                }

                // LEIPEI KWDIKAS
            }

            /* This concludes the array allocation */


        }
        return "ArrayAllocationExpression " + expr;
    }

    /**
     * f0 -> "new"
    * f1 -> Identifier()
    * f2 -> "("
    * f3 -> ")"
    */
    public String visit(AllocationExpression n, String argu) throws Exception {

        String className = n.f1.accept(this, argu);

        if (typeCheck){

            int stIndex = this.findSTindex(className);
            int vtIndex = this.findVTindex(className);
            
            /* Check if Identifier (className) exists (has been declared) */
            if (stIndex == -1){
                System.err.println("error: cannot find class: " + className);
                System.exit(1);
            }

            OffsetTable tempOffsetTable = new OffsetTable(className, st.get(stIndex),vt.get(currVTable));

            System.out.println("TO MAX OFFSET EINAI: " + (tempOffsetTable.maxOffset + 8) + "gia thn class: " + className);

            myFile.write("\t%t" + registerCounter++ + " = call i8* @calloc(i32 1, i32 " + (tempOffsetTable.maxOffset + 8) + ")\n");
            myFile.write("\t%t" + registerCounter + " = bitcast i8* %t" + (registerCounter-1) + " to i8***\n");
            registerCounter++;
            myFile.write("\t%t" + registerCounter + " = getelementptr [");
            myFile.write(vt.get(vtIndex).funList.size() + " x i8*], [" + vt.get(vtIndex).funList.size() + " x i8*]* ");
            myFile.write("@." + className + "_vtable, i32 0 , i32 0\n");
            myFile.write("\tstore i8** %t" + registerCounter + ", i8*** %t" + (registerCounter-1) + "\n");
            registerCounter++;

        }

        return "AllocationExpression" + className;
    }

    /**
     * f0 -> "!"
    * f1 -> PrimaryExpression()
    */
    public String visit(NotExpression n, String argu) throws Exception {
        String expr1 = n.f1.accept(this,argu);
        if (typeCheck){
            myFile.write("\t%t" + registerCounter++ + " = xor i1 1, %t" + (registerCounter - 2) + "\n");
        }
        return expr1;
    }

    /**
     * f0 -> "("
    * f1 -> Expression()
    * f2 -> ")"
    */
    public String visit(BracketExpression n, String argu) throws Exception {
        return "(" + n.f1.accept(this,argu) + ")";
    }
}