package io.compiler.core.ast;

import io.compiler.types.Var;

public class WriteCommand extends Command {
	private String content;
	private Program program;

	public WriteCommand() {
		super();
	}

	public WriteCommand(String content) {
		super();
		this.content = content;
	}
	
	public WriteCommand(String content, Program program) {
        super();
        this.content = content;
        this.program = program;
    }

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	private Var getVarFromContent(String content) {
        if (program != null && program.getSymbolTable() != null) {
            return program.getSymbolTable().get(content);
        }
        return null;
    }
	
	@Override
    public String generateTarget(String language) {
        String str = "";
        
        if (language.equals("java")) {
            str = "System.out.println(" + content + ");\n";
            
        } else if (language.equals("c")) {
            if (content.startsWith("\"") && content.endsWith("\"")) {
                str = "printf(" + content + ");\n";
            } else {
                Var var = getVarFromContent(content);
                if (var != null) {
                    switch (var.getType()) {
                        case NUMBER:
                            str = "printf(\"%d\", " + content + ");\n";
                            break;
                        case REALNUMBER:
                            str = "printf(\"%lf\", " + content + ");\n";
                            break;
                        case TEXT:
                            str = "printf(\"%s\", " + content + ");\n";
                            break;
                    }
                }
            }
        }
        
        return str;
    }
}
