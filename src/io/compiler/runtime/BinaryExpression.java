package io.compiler.runtime;

public class BinaryExpression extends AbstractExpression {
	private char operation;
	private AbstractExpression left;
	private AbstractExpression right;
	
	public BinaryExpression(char operation, AbstractExpression left, AbstractExpression right) {
		super();
		this.operation = operation;
		this.left = left;
		this.right = right;
	}

	public BinaryExpression(char operation) {
		super();
		this.operation = operation;
	}

	public BinaryExpression() {
		super();
	}

	public char getOperation() {
		return operation;
	}

	public void setOperation(char operation) {
		this.operation = operation;
	}

	public AbstractExpression getLeft() {
		return left;
	}

	public void setLeft(AbstractExpression left) {
		this.left = left;
	}

	public AbstractExpression getRight() {
		return right;
	}

	public void setRight(AbstractExpression right) {
		this.right = right;
	}

	@Override
	public double evaluate() {
		switch(this.operation) {
		case '+':
			return left.evaluate() + right.evaluate();
		case '-':
			return left.evaluate() - right.evaluate();
		case '*':
			return left.evaluate() * right.evaluate();
		case '/':
			return left.evaluate() / right.evaluate();
		default:
			return 0;
		}
	}

	@Override
	public String toJSON() {
		return "{ \"operation\": \"" +this.operation+ "\","
				+ "\"left\": " +left.toJSON()+ ","
				+ "\"right\": " +right.toJSON()+ "}";
	}
	
	@Override
	public String toString() {
		return "(" + left.toString() + " " + this.operation + " " + right.toString() + ")";
	}
}
