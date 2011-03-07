package garbuz.serialization;

import java.lang.reflect.Field;

final class TypeHolder
{
	protected int index;
	protected String className;
	protected Field[] fields;
	protected Class classRef;
	protected boolean initialized = false;

	protected TypeHolder(int index, String qualifiedName)
	{
		this.index = index;
		this.className = qualifiedName;
	}

	protected void initialize() throws ClassNotFoundException
	{
		classRef = Class.forName(className);
		fields = classRef.getFields();
		initialized = true;
	}
}
