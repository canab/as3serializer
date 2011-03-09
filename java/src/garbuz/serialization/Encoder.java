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

	private void encodeInteger(int value)
	{
		long unsigned = (value >= 0) ? value : -(long)value;

		if (value >= 0)
		{
			if (unsigned <= 0xFF)
			{
				byteStream.write(Types.T_UINT1);
				byteStream.write((int) unsigned);
			}
			else if (unsigned <= 0xFFFF)
			{
				byteStream.write(Types.T_UINT2);
				byteStream.write((int) (unsigned & 0xFF));
				byteStream.write((int) (unsigned >> 8));
			}
			else if (unsigned <= 0xFFFFFF)
			{
				byteStream.write(Types.T_UINT3);
				byteStream.write((int) (unsigned & 0xFF));
				byteStream.write((int) ((unsigned >> 8) & 0xFF));
				byteStream.write((int) (unsigned >> 16));
			}
			else
			{
				byteStream.write(Types.T_UINT4);
				byteStream.write((int) (unsigned & 0xFF));
				byteStream.write((int) ((unsigned >> 8) & 0xFF));
				byteStream.write((int) ((unsigned >> 16) & 0xFF));
				byteStream.write((int) (unsigned >> 24));
			}
		}
		else
		{
			if (unsigned <= 0xFF)
			{
				byteStream.write(Types.T_NINT1);
				byteStream.write((int) unsigned);
			}
			else if (unsigned <= 0xFFFF)
			{
				byteStream.write(Types.T_NINT2);
				byteStream.write((int) (unsigned & 0xFF));
				byteStream.write((int) (unsigned >> 8));
			}
			else if (unsigned <= 0xFFFFFF)
			{
				byteStream.write(Types.T_NINT3);
				byteStream.write((int) (unsigned & 0xFF));
				byteStream.write((int) ((unsigned >> 8) & 0xFF));
				byteStream.write((int) (unsigned >> 16));
			}
			else
			{
				byteStream.write(Types.T_NINT4);
				byteStream.write((int) (unsigned & 0xFF));
				byteStream.write((int) ((unsigned >> 8) & 0xFF));
				byteStream.write((int) ((unsigned >> 16) & 0xFF));
				byteStream.write((int) (unsigned >> 24));
			}
		}
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

	private void encodeString(String value) throws Exception
	{
		byteStream.write(Types.T_STRING);
		writeString(value);
	}

	private void writeString(String value) throws IOException
	{
		ByteBuffer stringBuffer = Serializer.charset.encode(value);
		int length = stringBuffer.limit();
		byte[] bytes = new byte[length];
		stringBuffer.get(bytes);
		encodeInteger(length);
		byteStream.write(bytes);
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
		encodeInteger(length);

		for (int i = 0; i < length; i++)
		{
			encodeValue(value[i]);
		}
	}

	private void encodeMap(Map<Object, Object> map) throws Exception
	{
		byteStream.write(Types.T_MAP);
		encodeInteger(map.size());

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
		encodeInteger(type.index);

		for (Field field : type.fields)
		{
			encodeValue(field.get(object));
		}
	}

}
