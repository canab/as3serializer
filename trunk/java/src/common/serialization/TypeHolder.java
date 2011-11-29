package common.serialization;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

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

		List<Field> fieldList = new ArrayList<Field>();

		for (Field field : classRef.getFields())
		{
			int modifiers = field.getModifiers();

			if (Modifier.isStatic(modifiers) || Modifier.isFinal(modifiers))
				continue;

			fieldList.add(field);
		}

		Collections.sort(fieldList, new Comparator<Field>()
		{
			public int compare(Field field, Field field1)
			{
				return field.getName().compareTo(field1.getName());
			}
		});

		fields = fieldList.toArray(new Field[fieldList.size()]);
		initialized = true;
	}
}
