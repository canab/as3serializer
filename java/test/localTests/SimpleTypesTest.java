package localTests;

import garbuz.serialization.Serializer;
import org.junit.Assert;
import org.junit.Test;

public class SimpleTypesTest
{
	@Test
	public void testInteger()
	{
		testValue(0);
		testValue(12);
		testValue(-12);
		testValue(Integer.MAX_VALUE);
		testValue(Integer.MIN_VALUE);
	}

	protected void testValue(Object value)
	{
		byte[] bytes = Serializer.encode(value);
		Object result = Serializer.decode(bytes);
		Assert.assertEquals(value, result);
	}

}
