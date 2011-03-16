package garbuz.serialization;

import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

final class Decoder
{
	private ByteBuffer byteBuffer;
	private List<String> stringCache = new ArrayList<String>();

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
			case Types.T_NULL:
				value = null;
				break;
			case Types.T_TRUE:
				value = true;
				break;
			case Types.T_FALSE:
				value = false;
				break;
			case Types.T_STRING:
				value = decodeString();
				break;
			case Types.T_STRING_REF:
				value = decodeStringRef();
				break;
			case Types.T_DOUBLE:
				value = decodeDouble();
				break;
			case Types.T_DATE:
				value = decodeDate();
				break;
			case Types.T_MAP:
				value = decodeMap();
				break;
			case Types.T_ARRAY:
				value = decodeArray();
				break;
			case Types.T_OBJECT:
				value = decodeObject();
				break;
			case Types.T_UINT1:
				value = decodeUInt1();
				break;
			case Types.T_UINT2:
				value = decodeUInt2();
				break;
			case Types.T_UINT3:
				value = decodeUInt3();
				break;
			case Types.T_UINT4:
				value = decodeUInt4();
				break;
			case Types.T_NINT1:
				value = decodeNInt1();
				break;
			case Types.T_NINT2:
				value = decodeNInt2();
				break;
			case Types.T_NINT3:
				value = decodeNInt3();
				break;
			case Types.T_NINT4:
				value = decodeNInt4();
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

	private int decodeUInt1() throws IOException
	{
		return byteBuffer.get() & 0xFF;
	}

	private int decodeUInt2() throws IOException
	{
		long unsigned = byteBuffer.get() & 0xFF;
		unsigned |= (byteBuffer.get() & 0xFF) << 8;
		return (int) unsigned;
	}

	private int decodeUInt3() throws IOException
	{
		long unsigned = byteBuffer.get() & 0xFF;
		unsigned |= (byteBuffer.get() & 0xFF) << 8;
		unsigned |= (byteBuffer.get() & 0xFF) << 16;
		return (int) unsigned;
	}

	private int decodeUInt4() throws IOException
	{
		long unsigned = byteBuffer.get() & 0xFF;
		unsigned |= (byteBuffer.get() & 0xFF) << 8;
		unsigned |= (byteBuffer.get() & 0xFF) << 16;
		unsigned |= (byteBuffer.get() & 0xFF) << 24;
		return (int) unsigned;
	}

	private int decodeNInt1() throws IOException
	{
		return -(byteBuffer.get() & 0xFF);
	}

	private int decodeNInt2() throws IOException
	{
		long unsigned = byteBuffer.get() & 0xFF;
		unsigned |= byteBuffer.get() << 8;
		return (int) -unsigned ;
	}

	private int decodeNInt3() throws IOException
	{
		long unsigned = byteBuffer.get() & 0xFF;
		unsigned |= (byteBuffer.get() & 0xFF) << 8;
		unsigned |= (byteBuffer.get() & 0xFF) << 16;
		return (int) -unsigned;
	}

	private int decodeNInt4() throws IOException
	{
		long unsigned = byteBuffer.get() & 0xFF;
		unsigned |= (byteBuffer.get() & 0xFF) << 8;
		unsigned |= (byteBuffer.get() & 0xFF) << 16;
		unsigned |= (byteBuffer.get() & 0xFF) << 24;
		return (int) -unsigned;
	}

	private Object decodeDouble() throws IOException
	{
		return byteBuffer.getDouble();
	}

	private String decodeString() throws Exception
	{
		int length = (Integer) decodeValue();
		int limit = byteBuffer.limit();
		byteBuffer.limit(byteBuffer.position() + length);
		String string = Serializer.charset.decode(byteBuffer).toString();
		byteBuffer.limit(limit);

		stringCache.add(string);

		return string;
	}

	private String decodeStringRef() throws Exception
	{
		Integer ref = (Integer) decodeValue();
		return stringCache.get(ref);
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
			String key = (String) decodeValue();
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

			if (value.getClass().isArray() && !field.getType().isArray())
				value = Arrays.asList((Object[]) value);

			field.set(object, value);
		}

		return object;
	}

}
