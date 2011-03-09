package localTests;

import garbuz.serialization.Serializer;
import org.junit.Assert;
import org.junit.Test;

import java.util.Date;

public class SimpleTypesTest
{
	@Test
	public void testInteger() throws Exception
	{
		testValue(0);
		testValue(0xFF);
		testValue(0xFF - 1);
		testValue(0xFF + 1);
		testValue(0xFFFF);
		testValue(0xFFFF - 1);
		testValue(0xFFFF + 1);
		testValue(0xFFFFFF);
		testValue(0xFFFFFF - 1);
		testValue(0xFFFFFF + 1);

		testValue(Integer.MIN_VALUE);
		testValue(Integer.MIN_VALUE + 1);
		testValue(Integer.MAX_VALUE);
		testValue(Integer.MAX_VALUE - 1);
	}

	@Test
	public void testDouble() throws Exception
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
	public void testString() throws Exception
	{
		testValue("йцукен");
		testValue("");
		testValue("qwerty");
		testValue("йцукен");
		testValue("qwertyйцукен");
	}

	@Test
	public void testBoolean() throws Exception
	{
		testValue(true);
		testValue(false);
	}

	@Test
	public void testNull() throws Exception
	{
		testValue(null);
	}

	@Test
	public void testDate() throws Exception
	{
		testValue(new Date());
	}

	protected void testValue(Object value) throws Exception
	{
		byte[] bytes = Serializer.encode(value);
		Object result = Serializer.decode(bytes);
		Assert.assertEquals(value, result);
	}

}
