package garbuz.serialization;

import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

final class Decoder
{
	private ByteBuffer byteBuffer;

	public Object decode(byte[] bytes) throws Exception
	{
		byteBuffer = ByteBuffer.wrap(bytes);
		Object value = decodeValue();
		return value;

	}

	private Object decodeValue() throws Exception
	{
		int type = byteBuffer.get();

		Object value = null;

		switch (type)
		{
			case Types.T_INT:
				value = decodeInt();
				break;
			case Types.T_DOUBLE:
				value = decodeDouble();
				break;
			case Types.T_STRING:
				value = decodeString();
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
				value = decodeDate();
				break;
			case Types.T_ARRAY:
				value = decodeArray();
				break;
			case Types.T_MAP:
				value = decodeMap();
				break;
			case Types.T_OBJECT:
				value = decodeObject();
				break;
		}

		return value;
	}

	private Object decodeArray() throws Exception
	{
		int length = (Integer) decodeValue();
		Object[] array = new Object[length];

		for (int i = 0; i < length; i++)
		{
			array[i] = decodeValue();
		}

		return array;
	}

	private int decodeInt() throws IOException
	{
		return byteBuffer.getInt();
	}

	private Object decodeDouble() throws IOException
	{
		return byteBuffer.getDouble();
	}

	private String decodeString() throws Exception
	{
		int length = (Integer) decodeValue();
		char[] chars = new char[length];

		for (int i = 0; i < length; i++)
		{
			chars[i] = byteBuffer.getChar();
		}

		return new String(chars);
	}

	private Date decodeDate() throws IOException
	{
		long time = ((Double) decodeDouble()).longValue();
		return new Date(time);
	}

	private Map<String, Object> decodeMap() throws Exception
	{
		Map<String, Object> map = new HashMap<String, Object>();
		int keyCount = (Integer) decodeValue();

		for (int i = 0; i < keyCount; i++)
		{
			String key = decodeString();
			Object value = decodeValue();
			map.put(key, value);
		}

		return map;
	}

	private Object decodeObject() throws Exception
	{
		int typeIndex = (Integer) decodeValue();
		TypeHolder type = Serializer.getTypeByIndex(typeIndex);
		Object object = type.classRef.newInstance();

		for (Field field : type.fields)
		{
			Object value = decodeValue();
			field.set(object, value);
		}

		return object;
	}
}
