package io.compiler.core.ast;

import java.util.HashMap;
import java.util.List;

import io.compiler.types.Types;
import io.compiler.types.Var;

public class Program {
	private String name;
	private HashMap<String,Var> symbolTable;
	private List<Command> commandList;
	private static final String INDENTATION = "    ";
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public HashMap<String, Var> getSymbolTable() {
		return symbolTable;
	}
	public void setSymbolTable(HashMap<String, Var> symbolTable) {
		this.symbolTable = symbolTable;
	}
	public List<Command> getCommandList() {
		return commandList;
	}
	public void setCommandList(List<Command> commandList) {
		this.commandList = commandList;
	}
	
	private String indent(String code) {
		String[] lines = code.split("\n");
		StringBuilder indentedCode = new StringBuilder();
		for (String line : lines) {
			indentedCode.append(INDENTATION).append(line).append("\n");
		}
		return indentedCode.toString();
	}
	
	public String generateTarget(String language) {
	    StringBuilder str = new StringBuilder();
	    
	    if (language.equals("java")) {
	        str.append("import java.util.Scanner;\n");
	        str.append("public class " + name + " { \n");
	        str.append(indent("public static void main(String args[]) { \n"));
	        str.append(indent("Scanner _scTrx = new Scanner(System.in);\n"));
	        
	        for (String varId : symbolTable.keySet()) {
	            Var var = symbolTable.get(varId);
	            if (var.getType() == Types.NUMBER) {
	                str.append(indent("int " + var.getId() + ";\n"));
	            } else if (var.getType() == Types.REALNUMBER) {
	                str.append(indent("double " + var.getId() + ";\n"));
	            } else {
	                str.append(indent("String " + var.getId() + ";\n"));
	            }
	        }
	        
	        for (Command cmd : commandList) {
	            str.append(indent(cmd.generateTarget(language)));
	        }
	        
	        str.append(indent("}\n"));
	        str.append("}");
	        
	    } else if (language.equals("c")) {
	        str.append("#include <stdio.h>\n");
	        str.append("#include <string.h>\n");
	        str.append("int main() {\n");
	        
	        for (String varId : symbolTable.keySet()) {
	            Var var = symbolTable.get(varId);
	            if (var.getType() == Types.NUMBER) {
	                str.append(indent("int " + var.getId() + ";\n"));
	            } else if (var.getType() == Types.REALNUMBER) {
	                str.append(indent("double " + var.getId() + ";\n"));
	            } else {
	                str.append(indent("char " + var.getId() + "[100];\n")); // assuming a max length of 100 for strings
	            }
	        }
	        
	        for (Command cmd : commandList) {
	            str.append(indent(cmd.generateTarget(language)));
	        }
	        
	        str.append(indent("return 0;\n"));
	        str.append("}\n");
	    }
	    
	    return str.toString();
	}
	
}
