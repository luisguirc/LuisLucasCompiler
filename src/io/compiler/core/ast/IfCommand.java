package io.compiler.core.ast;

import java.util.List;

public class IfCommand extends Command {

	private String expression;
	private List<Command> trueList;
	private List<Command> falseList;
	
	public IfCommand() {
		super();
	}

	public IfCommand(String expression, List<Command> trueList, List<Command> falseList) {
		super();
		this.expression = expression;
		this.trueList = trueList;
		this.falseList = falseList;
	}

	public String getExpression() {
		return expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}

	public List<Command> getTrueList() {
		return trueList;
	}

	public void setTrueList(List<Command> trueList) {
		this.trueList = trueList;
	}

	public List<Command> getFalseList() {
		return falseList;
	}

	public void setFalseList(List<Command> falseList) {
		this.falseList = falseList;
	}
	
	@Override
	public String generateTarget(String language) {
	    StringBuilder str = new StringBuilder();
	    
	    if (language.equals("java") || language.equals("c")) {          
	        str.append("if (" + expression + ") {\n");
	        
	        for (Command cmd: trueList) {
	            str.append(indent(cmd.generateTarget(language)));
	        }
	        str.append("}\n");
	        
	        if (!falseList.isEmpty()) {
	            str.append("else {\n");
	            for (Command cmd: falseList) {
	                str.append(indent(cmd.generateTarget(language)));
	            }
	            str.append("}\n");
	        }
	    }
	    
	    return str.toString();
	}

}
