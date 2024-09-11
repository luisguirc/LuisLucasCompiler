package io.compiler.runtime;

public class UnaryExpression extends AbstractExpression {

	public double value;

	@Override
	public double evaluate() {
		return value;
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}

	public UnaryExpression() {
		super();
	}

	public UnaryExpression(double value) {
		super();
		this.value = value;
	}

	@Override
	public String toJSON() {
		return "{\"value\": " +this.value+ "}";
	}
	
	@Override
	public String toString() {
		return Double.toString(this.value);
	}
}
