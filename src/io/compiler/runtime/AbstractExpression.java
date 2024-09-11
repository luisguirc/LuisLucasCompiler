package io.compiler.runtime;

public abstract class AbstractExpression {
	public abstract double evaluate();
	public abstract String toJSON();
	public abstract String toString();
}
