grammar UFABCGrammar;

@header {
	import java.util.ArrayList;
	import java.util.Stack;
    import java.util.HashMap;
	import io.compiler.types.*;
	import io.compiler.core.exceptions.*;
	import io.compiler.core.ast.*;
	import io.compiler.runtime.*;
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
    
    private AbstractExpression topo = null;
    private Stack<AbstractExpression> expressionStack = new Stack<AbstractExpression>();
    private boolean containsVariable = false;
    private String variableName = "";
    
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
    
    public void generateValue(){
    	if(!containsVariable){
    		topo = expressionStack.pop();
	    	double value = topo.evaluate();
	    	System.out.println("[INFO] Evaluated expression \"" +topo.toString()+ "\" with value " + value);
	    	System.out.println("[INFO] Expression JSON: " + generateJSON());
	    } else {
	    	 System.out.println("[INFO] Skipping evaluation due to variable \""+variableName+"\" in expression.");
	    }
    	
    	containsVariable = false;
    	// return value;
    }
    
    public String generateJSON(){
    	if (topo == null){
    		topo = expressionStack.pop();
    	}
    	return topo.toJSON();
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
        		    System.out.println("[WARNING] Variable " + v.getId() + " declared but never used.");
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
			   				strExpr = "";
			   				generateValue(); }
			   
	  		  'ate' expr { forCmd.setCondition(forCmd.getInitialization().split("=")[0] + " <= " + strExpr);
	  		  			   strExpr = "";
	  		  			   generateValue(); }
			  'passo' expr { forCmd.setIncrement(forCmd.getInitialization().split("=")[0] + " += " + strExpr);
			  				 generateValue(); }
			  'faca' { stack.push(new ArrayList<Command>()); }
			   comando+ { forCmd.setCommandList(stack.pop()); }
	  		  'fimpara' { stack.peek().add(forCmd); }
	  		  ;


cmdWhile   : 'enquanto'  { stack.push(new ArrayList<Command>());
 					      strExpr = ""; }
              AP
              expr	  { generateValue(); }
              OPREL   { strExpr += _input.LT(-1).getText(); }
              expr	  { generateValue(); }
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
             expr	 { generateValue(); }
             OPREL   { strExpr += _input.LT(-1).getText(); }
             expr	 { generateValue(); }
             FP      { doWhileCmd.setCondition(strExpr); }
             PV
           ;


cmdIF		: 'se'  { stack.push(new ArrayList<Command>()); //criar um novo escopo
					  strExpr = "";
					  currentIfCommand = new IfCommand();
					}
			   AP
			   expr		   { generateValue(); }
			   OPREL       { strExpr += _input.LT(-1).getText(); }
			   expr		   { generateValue(); }
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
               'numero' {currentType = Types.NUMBER;}
               |
               'numeroreal' {currentType = Types.REALNUMBER;}
               |
               'texto'   {currentType = Types.TEXT;}
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
			  expr    {
			  			if(leftType == Types.NUMBER || leftType == Types.REALNUMBER ) generateValue();
			  		  }
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
			   ( fator  { Command cmdWrite = new WriteCommand(_input.LT(-1).getText(), program);
			   			  stack.peek().add(cmdWrite);
			   			  containsVariable = false;
			   			}
			   )
			   FP PV    { rightType = null; }
			;

expr		: termo
			  exprl
			;

exprl		: ((OP_SOMA | OP_SUB) 
				{ strExpr += _input.LT(-1).getText();
				  if(!containsVariable){
				  	BinaryExpression bin = new BinaryExpression(_input.LT(-1).getText().charAt(0));
				  	bin.setLeft(expressionStack.pop());
				  	expressionStack.push(bin);
				  }
				}
			  termo
			    {
			      if(!containsVariable){
			      	AbstractExpression topo = expressionStack.pop();
              	  	BinaryExpression root = (BinaryExpression) expressionStack.pop();
              	  	root.setRight(topo);
              	  	expressionStack.push(root);
              	  }
			    })*
			;

termo		: fator { strExpr += _input.LT(-1).getText(); }
			  termol
			;

termol		: ((OP_MUL | OP_DIV)
				{ strExpr += _input.LT(-1).getText();
				  BinaryExpression bin = new BinaryExpression(_input.LT(-1).getText().charAt(0));
				  if(!containsVariable){
	                  if (expressionStack.peek() instanceof UnaryExpression){
	                	bin.setLeft(expressionStack.pop());
	                  } else {
	                	BinaryExpression father = (BinaryExpression) expressionStack.pop();
	                	if(father.getOperation() == '-' || father.getOperation() == '+'){
	                	  bin.setLeft(father.getRight());
	                	  father.setRight(bin);
	                	  expressionStack.push(father);
	                	} else {
	                	  bin.setLeft(father);
	                	  expressionStack.push(bin);
	                	}
	                  }
	               }
				}
  			  fator
  			    { strExpr += _input.LT(-1).getText();
  			      if(!containsVariable){
	  			     bin.setRight(expressionStack.pop());
	              	 expressionStack.push(bin);
	              }
  			    }
  			  )*
  			;

fator		: ID   { if (!isDeclared(_input.LT(-1).getText())){
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
					 
					 containsVariable = true;
					 variableName = _input.LT(-1).getText();
				   }  
					 
			| NUMBER  { if (rightType == null){
						rightType = Types.NUMBER;
					  } else {
					  	if (rightType.getValue() < Types.NUMBER.getValue()){
					  		rightType = Types.NUMBER;
					  	}
					  }
					  UnaryExpression element = new UnaryExpression(Integer.parseInt(_input.LT(-1).getText()));
					  expressionStack.push(element);
			         }
			| REALNUMBER { if (rightType == null){
						rightType = Types.REALNUMBER;
					  } else {
					  	if (rightType.getValue() < Types.REALNUMBER.getValue()){
					  		rightType = Types.REALNUMBER;
					  	}
					  }
					  UnaryExpression element = new UnaryExpression(Double.parseDouble(_input.LT(-1).getText()));
					  expressionStack.push(element);
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
			
OP_SOMA		: '+'
			;

OP_SUB		: '-'
			;
			
OP_MUL		: '*'
			;

OP_DIV		: '/'
			;

OP_AT		: ':='
			;

OPREL		: '>' | '<' | '>=' | '<=' | '<>' | '=='
			;

ID			: [a-z] ( [a-z] | [A-Z] | [0-9] )*		
			;

NUMBER		: [0-9]+
			;

REALNUMBER	: [0-9]+ ('.' [0-9]+ )?		
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