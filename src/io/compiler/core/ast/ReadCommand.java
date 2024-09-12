package io.compiler.core.ast;

import io.compiler.types.Types;
import io.compiler.types.Var;

public class ReadCommand extends Command {

	private Var var;
	
	public ReadCommand() {
		super();
	}

	public ReadCommand(Var var) {
		super();
		this.var = var;
	}

	public Var getVar() {
		return var;
	}

	public void setVar(Var var) {
		this.var = var;
	}

	@Override
	public String generateTarget(String language) {
	    String str = "";
	    
	    if (language.equals("java")) {
	    	switch (var.getType()) {
	        case NUMBER:
	            str = var.getId() + " = _scTrx.nextInt();\n";
	            break;
	        case REALNUMBER:
	            str = var.getId() + " = _scTrx.nextDouble();\n";
	            break;
	        default:
	            str = var.getId() + " = _scTrx.nextLine();\n";
	            break;
	    }
	        
	    } else if (language.equals("c")) {
	        if (var.getType() == Types.NUMBER) {
	            str = "scanf(\"%d\", &" + var.getId() + ");\n";
	        } else if (var.getType() == Types.REALNUMBER) {
	            str = "scanf(\"%lf\", &" + var.getId() + ");\n";
	        } else {
	            str = "scanf(\"%s\", " + var.getId() + ");\n";
	        }
	    }
	    
	    return str;
	}


}
