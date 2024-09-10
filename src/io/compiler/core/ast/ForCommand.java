package io.compiler.core.ast;

import java.util.List;

public class ForCommand extends Command {

	private String initialization;
	private String condition;
	private String increment;
	private List<Command> commandList;

	public ForCommand() {
		super();
	}

	public ForCommand(String initialization, String condition, String increment, List<Command> commandList) {
		super();
		this.initialization = initialization;
		this.condition = condition;
		this.increment = increment;
		this.commandList = commandList;
	}

	public String getInitialization() {
		return initialization;
	}

	public void setInitialization(String initialization) {
		this.initialization = initialization;
	}

	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public String getIncrement() {
		return increment;
	}

	public void setIncrement(String increment) {
		this.increment = increment;
	}

	public List<Command> getCommandList() {
		return commandList;
	}

	public void setCommandList(List<Command> commandList) {
		this.commandList = commandList;
	}

	@Override
	public String generateTarget(String language) {
	    StringBuilder str = new StringBuilder();
	    
	    if (language.equals("java") || language.equals("c")) {          
	        str.append("for (" + initialization + "; " + condition + "; " + increment + ") {\n");
	        
	        for (Command cmd : commandList) {
	            str.append(indent(cmd.generateTarget(language)));
	        }
	        
	        str.append("}\n");
	    }
	    
	    return str.toString();
	}
}
