package io.compiler.core.ast;

import io.compiler.types.*;

public class AttribCommand extends Command {

    private Var var;
    private String expression;

    public AttribCommand() {
        super();
    }

    public AttribCommand(Var var, String expression) {
        super();
        this.var = var;
        this.expression = expression;
    }

    public Var getVar() {
        return var;
    }

    public void setVar(Var var) {
        this.var = var;
    }

    public String getExpression() {
        return expression;
    }

    public void setExpression(String expression) {
        this.expression = expression;
    }

    @Override
    public String generateTarget(String language) {
        StringBuilder str = new StringBuilder();
        
        if (language.equals("java")) {
            str.append(var.getId() + " = " + expression + ";\n");
            
        } else if (language.equals("c")) {
            switch (var.getType()) {
                case NUMBER:
                case REALNUMBER:
                    str.append(var.getId() + " = " + expression + ";\n");
                    break;
                case TEXT:
                    str.append("strcpy(" + var.getId() + ", " + expression + ");\n");
                    break;
            }
        }
        
        return str.toString();
    }
}
