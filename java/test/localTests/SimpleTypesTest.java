package localTests;

import garbuz.serialization.Serializer;
import org.junit.Assert;
import org.junit.Test;

import java.io.IOException;
import java.util.Date;

public class SimpleTypesTest
{
	@Test
	public void testInteger() throws IOException
	{
		testValue(0);
		testValue(12);
		testValue(-12);
		testValue(Integer.MAX_VALUE);
		testValue(Integer.MIN_VALUE);
	}

	@Test
	public void testDouble() throws IOException
	{
		testValue(0);
		testValue(-Math.PI);
		testValue(0.25);
		testValue(Double.MAX_VALUE);
		testValue(Double.MIN_VALUE);
		testValue(Double.NEGATIVE_INFINITY);
		testValue(Double.POSITIVE_INFINITY);
		testValue(Double.NaN);
	}

	@Test
	public void testString() throws IOException
	{
		testValue("");
		testValue("qwerty");
		testValue("йцукен");
		testValue("qwertyйцукен");
	}

	@Test
	public void testBoolean() throws IOException
	{
		testValue(true);
		testValue(false);
	}

	@Test
	public void testNull() throws IOException
	{
		testValue(null);
	}

	@Test
	public void testDate() throws IOException
	{
		testValue(new Date());
	}

	protected void testValue(Object value) throws IOException
	{
		byte[] bytes = Serializer.encode(value);
		Object result = Serializer.decode(bytes);
		Assert.assertEquals(value, result);
	}

}
