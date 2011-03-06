package garbuz.serialization;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;

@SuppressWarnings({"ConstantConditions"})
final class Encoder
{
	public Encoder()
	{
	}

	public byte[] encode(Object value) throws IOException
	{
		ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
		ObjectOutputStream objectStream = new ObjectOutputStream(byteStream);
		encodeValue(objectStream, value);
		objectStream.close();
		return byteStream.toByteArray();
	}

	private void encodeValue(ObjectOutputStream stream, Object value) throws IOException
	{
		if (value instanceof Integer)
		{
			encodeInteger(stream, (Integer) value);
		}
		else if ((value instanceof Double) || (value instanceof Float))
		{
			encodeDouble(stream, (Double) value);
		}
		else if ((value instanceof String))
		{
			encodeString(stream, (String) value);
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

}
