package io.compiler.types;

public class Var {
	private String id;
	private Types type;
	private boolean initialized;
	private boolean used;
	
	public boolean isUsed() {
		return used;
	}

	public void setUsed(boolean used) {
		this.used = used;
	}

	public Var() {
		super();
	}
	
	public Var(String id) {
		super();
		this.id = id;
	}

	public Var(String id, Types type) {
		super();
		this.id = id;
		this.type = type;
	}
	
	@Override
	public String toString() {
		return "Var [id=" + id + ", type=" + type + ", initialized=" + initialized + "]";
	}

	public boolean isInitialized() {
		return initialized;
	}

	public void setInitialized(boolean initialized) {
		this.initialized = initialized;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Types getType() {
		return type;
	}

	public void setType(Types type) {
		this.type = type;
	}
}
