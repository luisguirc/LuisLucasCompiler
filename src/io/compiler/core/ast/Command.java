package io.compiler.core.ast;

public abstract class Command {
	
	protected static final String INDENTATION = "    ";
	
	public abstract String generateTarget(String language);
	
	protected String indent(String code) {
		String[] lines = code.split("\n");
		StringBuilder indentedCode = new StringBuilder();
		for (String line : lines) {
			indentedCode.append(INDENTATION).append(line).append("\n");
		}
		return indentedCode.toString();
	}
}
