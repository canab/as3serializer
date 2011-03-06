package garbuz.serialization;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class Serializer
{
	private static final Encoder encoder = new Encoder();
	private static final Decoder decoder = new Decoder();

	private static final Map<String, TypeHolder> typesByName = new HashMap<String, TypeHolder>();
	private static final List<TypeHolder> typesByIndex = new ArrayList<TypeHolder>();

	private static final Object lock = new Object();

	public static byte[] encode(Object value) throws IOException
	{
		return encoder.encode(value);
	}

	public static Object decode(byte[] bytes) throws IOException
	{
		return decoder.decode(bytes);
	}

	public static void registerType(String qualifiedName)
	{
		if (typesByName.containsKey(qualifiedName))
			return;

		synchronized (lock)
		{
			int index = typesByIndex.size();
			TypeHolder type = new TypeHolder(index, qualifiedName);

			typesByName.put(qualifiedName, type);
			typesByIndex.set(index, type);
		}
	}

	protected static TypeHolder getTypeByName(String qualifiedName)
	{
		TypeHolder type;

		synchronized (lock)
		{
			type = typesByName.get(qualifiedName);

			if (type != null && !type.initialized)
				type.initialize();
		}

		if (type == null)
			throw new Error("Type " + qualifiedName + " is not registered");

		return type;
	}

	protected static TypeHolder getTypeByIndex(int typeIndex)
	{
		TypeHolder type;
		
		synchronized (lock)
		{
			type = typesByIndex.get(typeIndex);

			if (!type.initialized)
				type.initialize();
		}

		return type;
	}

}
