package io.compiler.core.ast;

import java.util.List;

public class DoWhileCommand extends Command {

	private String condition;
	private List<Command> commandList;

	public DoWhileCommand() {
		super();
	}

	public DoWhileCommand(String condition) {
		super();
		this.condition = condition;
	}

	public DoWhileCommand(String condition, List<Command> commandList) {
		super();
		this.condition = condition;
		this.commandList = commandList;
	}

	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
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
		if (language.equals("c") || language.equals("java")) {
	        str.append("do {\n");
	        for (Command cmd : commandList) {
	            str.append(indent(cmd.generateTarget(language)));
	        }
	        str.append("} while (" + condition + ");\n");
	    }
		return str.toString();
	}
}