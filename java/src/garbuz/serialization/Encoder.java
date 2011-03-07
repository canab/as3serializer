package garbuz.serialization;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.util.Date;
import java.util.Map;

@SuppressWarnings({"ConstantConditions"})
final class Encoder
{
	public Encoder()
	{
	}

	public byte[] encode(Object value) throws Exception
	{
		ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
		encodeValue(byteStream, value);
		byteStream.close();
		return byteStream.toByteArray();
	}

	@SuppressWarnings({"unchecked"})
	private void encodeValue(ByteArrayOutputStream stream, Object value) throws Exception
	{
		if (value instanceof Integer)
		{
			encodeInteger(stream, (Integer) value);
		}
		else if ((value instanceof Double) || (value instanceof Float))
		{
			encodeDouble(stream, (Double) value);
		}
		else if (value instanceof String)
		{
			encodeString(stream, (String) value);
		}
		else if (value instanceof Boolean)
		{
			encodeBoolean(stream, (Boolean) value);
		}
		else if (value instanceof Date)
		{
			encodeDate(stream, (Date) value);
		}
		else if (value instanceof Map)
		{
			encodeMap(stream, (Map<Object, Object>) value);
		}
		else if (value == null)
		{
			encodeNull(stream);
		}
		else if (value.getClass().isArray())
		{
			encodeArray(stream, (Object[]) value);
		}
		else
		{
			encodeTypedObject(stream, value);
		}
	}

	private void encodeInteger(ByteArrayOutputStream stream, int value) throws IOException
	{
		stream.write(Types.T_INT);
		writeInt(stream, value);
	}

	private void writeInt(ByteArrayOutputStream stream, int value) throws IOException
	{
		ByteBuffer buffer = ByteBuffer.allocate(4);
		buffer.putInt(value);
		stream.write(buffer.array());
	}

	private void encodeDouble(ByteArrayOutputStream stream, double value) throws IOException
	{
		stream.write(Types.T_DOUBLE);
		writeDouble(stream, value);
	}

	private void writeDouble(ByteArrayOutputStream stream, double value) throws IOException
	{
		ByteBuffer buffer = ByteBuffer.allocate(8);
		buffer.putDouble(value);
		stream.write(buffer.array());
	}

	private void encodeString(ByteArrayOutputStream stream, String value) throws IOException
	{
		stream.write(Types.T_STRING);
		writeString(stream, value);
	}

	private void writeString(ByteArrayOutputStream stream, String value) throws IOException
	{
		char[] chars = value.toCharArray();
		writeInt(stream, chars.length);

		ByteBuffer buffer = ByteBuffer.allocate(2);

		for (char ch: chars)
		{
			buffer.putChar(0, ch);
			stream.write(buffer.array());
		}
	}

	private void encodeBoolean(ByteArrayOutputStream stream, boolean value) throws IOException
	{
		stream.write(value ? Types.T_TRUE : Types.T_FALSE);
	}

	private void encodeNull(ByteArrayOutputStream stream) throws IOException
	{
		stream.write(Types.T_NULL);
	}

	private void encodeDate(ByteArrayOutputStream stream, Date value) throws IOException
	{
		stream.write(Types.T_DATE);
		writeDouble(stream, value.getTime());
	}

	private void encodeArray(ByteArrayOutputStream stream, Object[] value) throws Exception
	{
		int length = Array.getLength(value);

		stream.write(Types.T_ARRAY);
		writeInt(stream, length);

		for (int i = 0; i < length; i++)
		{
			encodeValue(stream, value[i]);
		}
	}

	private void encodeMap(ByteArrayOutputStream stream, Map<Object, Object> map) throws Exception
	{
		stream.write(Types.T_MAP);
		writeInt(stream, map.size());

		for (Object key : map.keySet())
		{
			writeString(stream, key.toString());
			encodeValue(stream, map.get(key));
		}
	}

	private void encodeTypedObject(ByteArrayOutputStream stream, Object object) throws Exception
	{
		String typeName = object.getClass().getName();
		TypeHolder type = Serializer.getTypeByName(typeName);

		stream.write(Types.T_OBJECT);
		writeInt(stream, type.index);

		for (Field field : type.fields)
		{
			encodeValue(stream, field.get(object));
		}
	}

}
