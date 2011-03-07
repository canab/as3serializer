package garbuz.serialization;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.lang.reflect.Field;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

final class Decoder
{
	public Object decode(byte[] bytes) throws IOException, IllegalAccessException, InstantiationException, ClassNotFoundException
	{
		ByteArrayInputStream byteStream = new ByteArrayInputStream(bytes);
		ObjectInputStream objectStream = new ObjectInputStream(byteStream);
		Object value = decodeValue(objectStream);
		return value;

	}

	private Object decodeValue(ObjectInputStream objectStream) throws IOException, InstantiationException, IllegalAccessException, ClassNotFoundException
	{
		int type = objectStream.readByte();
		Object value = null;

		switch (type)
		{
			case Types.T_INT:
				value = decodeInt(objectStream);
				break;
			case Types.T_DOUBLE:
				value = decodeDouble(objectStream);
				break;
			case Types.T_STRING:
				value = decodeString(objectStream);
				break;
			case Types.T_TRUE:
				value = true;
				break;
			case Types.T_FALSE:
				value = false;
				break;
			case Types.T_NULL:
				value = null;
				break;
			case Types.T_DATE:
				value = decodeDate(objectStream);
				break;
			case Types.T_ARRAY:
				value = decodeArray(objectStream);
				break;
			case Types.T_MAP:
				value = decodeMap(objectStream);
				break;
			case Types.T_OBJECT:
				value = decodeObject(objectStream);
				break;
		}

		return value;
	}

	private Object decodeArray(ObjectInputStream stream) throws IOException, IllegalAccessException, InstantiationException, ClassNotFoundException
	{
		int length = stream.readInt();
		Object[] array = new Object[length];

		for (int i = 0; i < length; i++)
		{
			array[i] = decodeValue(stream);
		}

		return array;
	}

	private Object decodeInt(ObjectInputStream stream) throws IOException
	{
		return stream.readInt();
	}

	private Object decodeDouble(ObjectInputStream stream) throws IOException
	{
		return stream.readDouble();
	}

	private String decodeString(ObjectInputStream stream) throws IOException
	{
		return stream.readUTF();
	}

	private Date decodeDate(ObjectInputStream stream) throws IOException
	{
		long time = ((Double)stream.readDouble()).longValue();
		return new Date(time);
	}

	private Map<String, Object> decodeMap(ObjectInputStream stream) throws IOException, IllegalAccessException, InstantiationException, ClassNotFoundException
	{
		Map<String, Object> map = new HashMap<String, Object>();
		int keyCount = stream.readInt();

		for (int i = 0; i < keyCount; i++)
		{
			String key = decodeString(stream);
			Object value = decodeValue(stream);
			map.put(key, value);
		}

		return map;
	}

	private Object decodeObject(ObjectInputStream stream) throws IOException, IllegalAccessException, InstantiationException, ClassNotFoundException
	{
			int typeIndex = stream.readShort();
			TypeHolder type = Serializer.getTypeByIndex(typeIndex);
			Object object = type.classRef.newInstance();

			for (Field field: type.fields)
			{
				field.set(object, decodeValue(stream));
			}

			return object;	}
}
