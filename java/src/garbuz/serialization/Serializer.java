package garbuz.serialization;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Serializer
{
	private static final Encoder encoder = new Encoder();
	private static final Decoder decoder = new Decoder();

	private static final Map<String, TypeHolder> typesByName = new HashMap<String, TypeHolder>();
	private static final List<TypeHolder> typesByIndex = new ArrayList<TypeHolder>();

	public static byte[] encode(Object value)
	{
		return encoder.encode(value);
	}

	public static Object decode(byte[] bytes)
	{
		return decoder.decode(bytes);
	}

	public static void registerType(String qualifiedName)
	{
		if (!typesByName.containsKey(qualifiedName))
		{
			int index = typesByIndex.size();
			TypeHolder type = new TypeHolder(index, qualifiedName);

			typesByName.put(qualifiedName, type);
			typesByIndex.set(index, type);
		}
	}

	protected static TypeHolder getTypeByName(String qualifiedName)
	{
		TypeHolder type = typesByName.get(qualifiedName);

		if (type == null)
			throw new Error("Type " + qualifiedName + " is not registered");

		if (!type.initialized)
			type.initialize();

		return type;
	}

	protected static TypeHolder getTypeByIndex(int typeIndex)
	{
		TypeHolder type = typesByIndex.get(typeIndex);

		if (!type.initialized)
			type.initialize();

		return type;
	}

}
