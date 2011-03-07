package garbuz.serialization;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

final class Decoder
{
	public Object decode(byte[] bytes) throws Exception
	{
		ByteArrayInputStream byteStream = new ByteArrayInputStream(bytes);
		Object value = decodeValue(byteStream);
		return value;

	}

	private Object decodeValue(ByteArrayInputStream stream) throws Exception
	{
		int type = stream.read();

		Object value = null;

		switch (type)
		{
			case Types.T_INT:
				value = decodeInt(stream);
				break;
			case Types.T_DOUBLE:
				value = decodeDouble(stream);
				break;
			case Types.T_STRING:
				value = decodeString(stream);
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
				value = decodeDate(stream);
				break;
			case Types.T_ARRAY:
				value = decodeArray(stream);
				break;
			case Types.T_MAP:
				value = decodeMap(stream);
				break;
			case Types.T_OBJECT:
				value = decodeObject(stream);
				break;
		}

		return value;
	}

	private Object decodeArray(ByteArrayInputStream stream) throws Exception
	{
		int length = decodeInt(stream);
		Object[] array = new Object[length];

		for (int i = 0; i < length; i++)
		{
			array[i] = decodeValue(stream);
		}

		return array;
	}

	private int decodeInt(ByteArrayInputStream stream) throws IOException
	{
		ByteBuffer buffer = ByteBuffer.allocate(4);
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());

		return buffer.getInt(0);
	}

	private Object decodeDouble(ByteArrayInputStream stream) throws IOException
	{
		ByteBuffer buffer = ByteBuffer.allocate(8);
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());
		buffer.put((byte) stream.read());

		return buffer.getDouble(0);
	}

	private String decodeString(ByteArrayInputStream stream) throws IOException
	{
		ByteBuffer buffer = ByteBuffer.allocate(2);

		int length = decodeInt(stream);
		char[] chars = new char[length];

		for (int i = 0; i < length; i++)
		{
			buffer.put(0, (byte) stream.read());
			buffer.put(1, (byte) stream.read());
			chars[i] = buffer.getChar(0);
		}

		return new String(chars);
	}

	private Date decodeDate(ByteArrayInputStream stream) throws IOException
	{
		long time = ((Double) decodeDouble(stream)).longValue();
		return new Date(time);
	}

	private Map<String, Object> decodeMap(ByteArrayInputStream stream) throws Exception
	{
		Map<String, Object> map = new HashMap<String, Object>();
		int keyCount = decodeInt(stream);

		for (int i = 0; i < keyCount; i++)
		{
			String key = decodeString(stream);
			Object value = decodeValue(stream);
			map.put(key, value);
		}

		return map;
	}

	private Object decodeObject(ByteArrayInputStream stream) throws Exception
	{
		int typeIndex = decodeInt(stream);
		TypeHolder type = Serializer.getTypeByIndex(typeIndex);
		Object object = type.classRef.newInstance();

		for (Field field : type.fields)
		{
			field.set(object, decodeValue(stream));
		}

		return object;
	}
}
