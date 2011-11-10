package localTests;

import common.serialization.Serializer;
import data.SampleObject;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Test;

public class ObjectTest
{
	@BeforeClass
	public static void setUp()
	{
		Serializer.registerType(SampleObject.class.getName());
	}

	@Test(expected = Exception.class)
	public void testError() throws Exception
	{
		Serializer.encode(new java.util.Formatter());
	}

	@Test
	public void testObject() throws Exception
	{
		doTest(new SampleObject());
	}

	private void doTest(SampleObject value) throws Exception
	{
		byte[] bytes = Serializer.encode(value);
		SampleObject result = (SampleObject) Serializer.decode(bytes);
		Assert.assertEquals(value.intValue, result.intValue);
		Assert.assertEquals(value.numberValue, result.numberValue, 0.000001);
		Assert.assertEquals(value.boolValue, result.boolValue);
		Assert.assertEquals(value.stringValue, result.stringValue);
		Assert.assertEquals(value.dateValue.getTime(), result.dateValue.getTime());
		Assert.assertArrayEquals(value.mapValue.keySet().toArray(), result.mapValue.keySet().toArray());
		Assert.assertArrayEquals(value.mapValue.values().toArray(), result.mapValue.values().toArray());
		Assert.assertArrayEquals(value.arrayValue, result.arrayValue);
	}
}
