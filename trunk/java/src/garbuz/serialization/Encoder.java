package garbuz.serialization;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
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
		ObjectOutputStream objectStream = new ObjectOutputStream(byteStream);
		encodeValue(objectStream, value);
		objectStream.close();
		return byteStream.toByteArray();
	}

	@SuppressWarnings({"unchecked"})
	private void encodeValue(ObjectOutputStream stream, Object value) throws Exception
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

	private void encodeInteger(ObjectOutputStream stream, int value) throws IOException
	{
		stream.writeByte(Types.T_INT);
		stream.writeInt(value);
	}

	private void encodeDouble(ObjectOutputStream stream, Double value) throws IOException
	{
		stream.writeByte(Types.T_DOUBLE);
		stream.writeDouble(value);
	}

	private void encodeString(ObjectOutputStream stream, String value) throws IOException
	{
		stream.writeByte(Types.T_STRING);
		stream.writeUTF(value);
	}

	private void encodeBoolean(ObjectOutputStream stream, boolean value) throws IOException
	{
		stream.writeByte(value ? Types.T_TRUE : Types.T_FALSE);
	}

	private void encodeNull(ObjectOutputStream stream) throws IOException
	{
		stream.writeByte(Types.T_NULL);
	}

	private void encodeDate(ObjectOutputStream stream, Date value) throws IOException
	{
		stream.writeByte(Types.T_DATE);
		stream.writeDouble(value.getTime());
	}

	private void encodeArray(ObjectOutputStream stream, Object[] value) throws Exception
	{
		int length = Array.getLength(value);

		stream.writeByte(Types.T_ARRAY);
		stream.writeInt(length);

		for (int i = 0; i < length; i++)
		{
			encodeValue(stream, value[i]);
		}
	}

	private void encodeMap(ObjectOutputStream stream, Map<Object, Object> map) throws Exception
	{
		stream.writeByte(Types.T_MAP);
		stream.writeInt(map.size());

		for (Object key : map.keySet())
		{
			stream.writeUTF(key.toString());
			encodeValue(stream, map.get(key));
		}
	}

	private void encodeTypedObject(ObjectOutputStream stream, Object object) throws Exception
	{
		String typeName = object.getClass().getName();
		TypeHolder type = Serializer.getTypeByName(typeName);

		stream.writeByte(Types.T_OBJECT);
		stream.writeShort(type.index);

		for (Field field : type.fields)
		{
			encodeValue(stream, field.get(object));
		}
	}

}
