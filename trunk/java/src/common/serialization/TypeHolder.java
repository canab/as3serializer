package common.serialization;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.Comparator;

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

		Arrays.sort(fields, new Comparator<Field>()
		{
			public int compare(Field field, Field field1)
			{
				return field.getName().compareTo(field1.getName());
			}
		});

		initialized = true;
	}
}
