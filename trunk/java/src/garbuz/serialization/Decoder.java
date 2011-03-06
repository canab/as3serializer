package garbuz.serialization;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.util.Date;

public class Decoder
{
	public Object decode(byte[] bytes) throws IOException
	{
		ByteArrayInputStream byteStream = new ByteArrayInputStream(bytes);
		ObjectInputStream objectStream = new ObjectInputStream(byteStream);
		Object value = decodeValue(objectStream);
		return value;

	}

	private Object decodeValue(ObjectInputStream objectStream) throws IOException
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
		}

		return value;
	}

	private Object decodeInt(ObjectInputStream objectStream) throws IOException
	{
		return objectStream.readInt();
	}

	private Object decodeDouble(ObjectInputStream objectStream) throws IOException
	{
		return objectStream.readDouble();
	}

	private Object decodeString(ObjectInputStream objectStream) throws IOException
	{
		return objectStream.readUTF();
	}

	private Object decodeDate(ObjectInputStream objectStream) throws IOException
	{
		long time = ((Double)objectStream.readDouble()).longValue();
		return new Date(time);
	}
}
