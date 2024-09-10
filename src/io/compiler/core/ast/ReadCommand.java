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
	        str = var.getId() + " = " + ((var.getType() == Types.NUMBER) ? "_scTrx.nextInt();" : "_scTrx.nextLine();") + "\n";
	        
	    } else if (language.equals("c")) {
	        if (var.getType() == Types.NUMBER) {
	            str = "scanf(\"%lf\", &" + var.getId() + ");\n";  // Reading a double for numbers
	        } else {
	            str = "scanf(\"%s\", " + var.getId() + ");\n";  // Reading a string for non-numeric input
	        }
	    }
	    
	    return str;
	}


}
