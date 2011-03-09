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
	private ByteArrayOutputStream byteStream;
	private ByteBuffer byteBuffer = ByteBuffer.allocate(8);

	public byte[] encode(Object value) throws Exception
	{
		byteStream = new ByteArrayOutputStream();
		encodeValue(value);
		byteStream.close();
		
		return byteStream.toByteArray();
	}

	@SuppressWarnings({"unchecked"})
	private void encodeValue(Object value) throws Exception
	{
		if (value instanceof Integer)
		{
			encodeInteger((Integer) value);
		}
		else if ((value instanceof Double) || (value instanceof Float))
		{
			encodeDouble((Double) value);
		}
		else if (value instanceof String)
		{
			encodeString((String) value);
		}
		else if (value instanceof Boolean)
		{
			encodeBoolean((Boolean) value);
		}
		else if (value instanceof Date)
		{
			encodeDate((Date) value);
		}
		else if (value instanceof Map)
		{
			encodeMap((Map<Object, Object>) value);
		}
		else if (value == null)
		{
			encodeNull();
		}
		else if (value.getClass().isArray())
		{
			encodeArray((Object[]) value);
		}
		else
		{
			encodeTypedObject(value);
		}
	}

	private void encodeInteger(int value) throws IOException
	{
		byteStream.write(Types.T_INT);
		writeInteger(value);
	}

	private void writeInteger(int value) throws IOException
	{
		byteBuffer.putInt(0, value);
		byteStream.write(byteBuffer.array(), 0, 4);
	}

	private void encodeDouble(double value) throws IOException
	{
		byteStream.write(Types.T_DOUBLE);
		writeDouble(value);
	}

	private void writeDouble(double value) throws IOException
	{
		byteBuffer.putDouble(0, value);
		byteStream.write(byteBuffer.array(), 0, 8);
	}

	private void encodeString(String value) throws IOException
	{
		byteStream.write(Types.T_STRING);
		writeString(value);
	}

	private void writeString(String value) throws IOException
	{
		char[] chars = value.toCharArray();
		writeInteger(chars.length);

		for (char ch: chars)
		{
			byteBuffer.putChar(0, ch);
			byteStream.write(byteBuffer.array(), 0, 2);
		}
	}

	private void encodeBoolean(boolean value) throws IOException
	{
		byteStream.write(value ? Types.T_TRUE : Types.T_FALSE);
	}

	private void encodeNull() throws IOException
	{
		byteStream.write(Types.T_NULL);
	}

	private void encodeDate(Date value) throws IOException
	{
		byteStream.write(Types.T_DATE);
		writeDouble(value.getTime());
	}

	private void encodeArray(Object[] value) throws Exception
	{
		int length = Array.getLength(value);

		byteStream.write(Types.T_ARRAY);
		writeInteger(length);

		for (int i = 0; i < length; i++)
		{
			encodeValue(value[i]);
		}
	}

	private void encodeMap(Map<Object, Object> map) throws Exception
	{
		byteStream.write(Types.T_MAP);
		writeInteger(map.size());

		for (Object key : map.keySet())
		{
			writeString(key.toString());
			encodeValue(map.get(key));
		}
	}

	private void encodeTypedObject(Object object) throws Exception
	{
		String typeName = object.getClass().getName();
		TypeHolder type = Serializer.getTypeByName(typeName);

		byteStream.write(Types.T_OBJECT);
		writeInteger(type.index);

		for (Field field : type.fields)
		{
			encodeValue(field.get(object));
		}
	}

}
