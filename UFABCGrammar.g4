grammar UFABCGrammar;

@header {
	import java.util.ArrayList;
	import java.util.Stack;
    import java.util.HashMap;
	import io.compiler.types.*;
	import io.compiler.core.exceptions.*;
	import io.compiler.core.ast.*;
}

@members {
    private HashMap<String,Var> symbolTable = new HashMap<String,Var>();
    private ArrayList<Var> currentDecl = new ArrayList<Var>();
    private Types currentType;
    private Types leftType=null, rightType=null;
    private Program program = new Program();
    private String strExpr = "";
    private IfCommand currentIfCommand;
    
    private Stack<ArrayList<Command>> stack = new Stack<ArrayList<Command>>();
    
    public void updateType(){
    	for(Var v: currentDecl){
    	   v.setType(currentType);
    	   symbolTable.put(v.getId(), v);
    	}
    }
    public void showVar(){
        for (String id: symbolTable.keySet()){
        	System.out.println(symbolTable.get(id));
        }
    }
    
    public Program getProgram(){
    	return this.program;
    }
    
    public boolean isDeclared(String id){
    	return symbolTable.get(id) != null;
    }
}

programa	: 'programa' ID { program.setName(_input.LT(-1).getText());
							  stack.push(new ArrayList<Command>());
							}
               declaravar+
              'inicio'
               comando+
              'fim' 
              'fimprog'
              
              { program.setSymbolTable(symbolTable);
                program.setCommandList(stack.pop());
                // After parsing the program
				for (Var v : symbolTable.values()) {
    			  if (!v.isUsed()) {
        		    System.out.println("Warning: Variable " + v.getId() + " declared but never used.");
                  }
                }
              }
			;

comando		: cmdAttrib
			| cmdLeitura
			| cmdEscrita
			| cmdIF
			| cmdWhile
			| cmdDoWhile
			| cmdFor
			;

cmdFor 		: 'para' ID  { if (!isDeclared(_input.LT(-1).getText())) {
                             throw new UFABCSemanticException("Undeclared variable: " + _input.LT(-1).getText());
                     	   }
	                       strExpr = _input.LT(-1).getText() + " = "; 
	                       ForCommand forCmd = new ForCommand(); }
	                       
			   OP_AT expr { forCmd.setInitialization(strExpr);
			   				strExpr = ""; }
			   
	  		  'ate' expr { forCmd.setCondition(forCmd.getInitialization().split("=")[0] + " <= " + strExpr);
	  		  			   strExpr = ""; }
			  'passo' expr { forCmd.setIncrement(forCmd.getInitialization().split("=")[0] + " += " + strExpr); }
			  'faca' { stack.push(new ArrayList<Command>()); }
			   comando+ { forCmd.setCommandList(stack.pop()); }
	  		  'fimpara' { stack.peek().add(forCmd); }
	  		  ;


cmdWhile   : 'enquanto'  { stack.push(new ArrayList<Command>());
 					      strExpr = ""; }
              AP
              expr
              OPREL   { strExpr += _input.LT(-1).getText(); }
              expr
              FP      { WhileCommand whileCmd = new WhileCommand(strExpr); }
             'faca'
              comando+ { whileCmd.setCommandList(stack.pop()); }
             'fimenquanto' { stack.peek().add(whileCmd); }
            ;

cmdDoWhile : 'faca'  { stack.push(new ArrayList<Command>());
                       strExpr = ""; }
             comando+ { DoWhileCommand doWhileCmd = new DoWhileCommand();
                        doWhileCmd.setCommandList(stack.pop());
                        stack.peek().add(doWhileCmd); }
            'enquanto' 
             AP		 { strExpr = ""; }
             expr
             OPREL   { strExpr += _input.LT(-1).getText(); }
             expr
             FP      { doWhileCmd.setCondition(strExpr); }
             PV
           ;


cmdIF		: 'se'  { stack.push(new ArrayList<Command>()); //criar um novo escopo
					  strExpr = "";
					  currentIfCommand = new IfCommand();
					}
			   AP
			   expr
			   OPREL       { strExpr += _input.LT(-1).getText(); }
			   expr
			   FP          { currentIfCommand.setExpression(strExpr); }
			  'entao'
			   comando+    { currentIfCommand.setTrueList(stack.pop()); }
			   ( 'senao'   { stack.push(new ArrayList<Command>()); }
			   comando+    { currentIfCommand.setFalseList(stack.pop()); }
			   )?
			   'fimse'     { stack.peek().add(currentIfCommand); }
			;
			
declaravar	: 'declare' { currentDecl.clear(); } 
               ID       { currentDecl.add(new Var(_input.LT(-1).getText()));}
               (
               VIRG
               ID       { currentDecl.add(new Var(_input.LT(-1).getText()));}
               )*	 
               DP 
               (
               'number' {currentType = Types.NUMBER;}
               |
               'text'   {currentType = Types.TEXT;}
               )        { updateType(); } 
               PV
			;		

cmdAttrib	: ID	  { if (!isDeclared(_input.LT(-1).getText())){
					  	  throw new UFABCSemanticException("Undeclared variable: " + _input.LT(-1).getText());
					    }
					    symbolTable.get(_input.LT(-1).getText()).setInitialized(true);
					    leftType = symbolTable.get(_input.LT(-1).getText()).getType();
					    String varName = _input.LT(-1).getText();
                  		Var var = symbolTable.get(varName);
                  		strExpr = "";
					  }
			  OP_AT
			  expr
			  PV
			  
					  { //System.out.println("Left side expression type = " +leftType);
					    //System.out.println("Right side expression type = " +rightType);
					    if (leftType.getValue() < rightType.getValue()){
					  	  throw new UFABCSemanticException("Type Mismatching on assignment");
					    }
					    
					    AttribCommand cmd = new AttribCommand(var, strExpr);
                        stack.peek().add(cmd);
					  }
			;
			
cmdLeitura	: 'leia'
			   AP
			   ID     { if (!isDeclared(_input.LT(-1).getText())){
			   			  throw new UFABCSemanticException("Undeclared variable: " + _input.LT(-1).getText());
			   			}
			   		    symbolTable.get(_input.LT(-1).getText()).setInitialized(true);
			   		    Command cmdRead = new ReadCommand(symbolTable.get(_input.LT(-1).getText()));
			   		    stack.peek().add(cmdRead);
			   		  }
			   FP
			   PV
			;
			
cmdEscrita	: 'escreva'
			   AP
			   ( termo  { Command cmdWrite = new WriteCommand(_input.LT(-1).getText());
			   			  stack.peek().add(cmdWrite);
			   			}
			   )
			   FP PV    { rightType = null; }
			;

expr		: termo  { strExpr += _input.LT(-1).getText(); }
			  exprl
			;

termo		: ID   { if (!isDeclared(_input.LT(-1).getText())){
					   throw new UFABCSemanticException("Undeclared variable: " + _input.LT(-1).getText());
					 }
					 if (!symbolTable.get(_input.LT(-1).getText()).isInitialized()) {
					 	throw new UFABCSemanticException("Variable " +_input.LT(-1).getText()+ " has no value assigned" );
					 }
					 
					 symbolTable.get(_input.LT(-1).getText()).setUsed(true);
					 
					 if (rightType == null) {
					 	rightType = symbolTable.get(_input.LT(-1).getText()).getType();
					 } else {
					 	if (symbolTable.get(_input.LT(-1).getText()).getType().getValue() > rightType.getValue()){
					 		rightType = symbolTable.get(_input.LT(-1).getText()).getType();
					 	}
					 }
				   }  
					 
			| NUM	{ if (rightType == null){
						rightType = Types.NUMBER;
					  } else {
					  	if (rightType.getValue() < Types.NUMBER.getValue()){
					  		rightType = Types.NUMBER;
					  	}
					  }
			        }
			| TEXTO { if (rightType == null){
						rightType = Types.TEXT;
					  } else {
					  	if (rightType.getValue() < Types.TEXT.getValue()){
					  		rightType = Types.TEXT;
					  	}
					  }
			        }
			;

exprl		: ( OP  { strExpr += _input.LT(-1).getText(); }
              termo { strExpr += _input.LT(-1).getText(); }
              ) *
			;	

OP			: '+' | '-' | '*' | '/' 
			;	

OP_AT		: ':='
			;

OPREL		: '>' | '<' | '>=' | '<=' | '<>' | '=='
			;

ID			: [a-z] ( [a-z] | [A-Z] | [0-9] )*		
			;

NUM			: [0-9]+ ('.' [0-9]+ )?
			;			

VIRG		: ','
			;

PV			: ';'
            ;		
            
AP			: '('
			;
		
FP			: ')'
			;	

DP			: ':'
		    ;
		    
TEXTO		: '"' ([a-z] | [A-Z] | [0-9] | ',' | '.' | ' ' | '-')* '"'
			;

WS			: (' ' | '\n' | '\r' | '\t' ) -> skip
			;