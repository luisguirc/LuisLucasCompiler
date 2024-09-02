package io.compiler.types;

public enum Types {
	NUMBER(1),
	REALNUMBER(2),
	TEXT(3);
//	talvez nao faca sentido para nos termos a abstracao de "subtipos"
	
	private int value;
	
	private Types(int typeValue) {
		this.value = typeValue;
	}
	
	public int getValue() {
		return this.value;
	}
}
