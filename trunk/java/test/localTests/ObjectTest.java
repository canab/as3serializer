package localTests;

import common.serialization.Serializer;
import data.ObjectWithStaticField;
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
		Serializer.registerType(ObjectWithStaticField.class.getName());
	}

	@Test(expected = Exception.class)
	public void testError() throws Exception
	{
		Serializer.encode(new java.util.Formatter());
	}

	@Test
	public void testObject() throws Exception
	{
		SampleObject original = new SampleObject();
		byte[] bytes = Serializer.encode(original);
		SampleObject result = (SampleObject) Serializer.decode(bytes);

		Assert.assertEquals(original.intValue, result.intValue);
		Assert.assertEquals(original.numberValue, result.numberValue, 0.000001);
		Assert.assertEquals(original.boolValue, result.boolValue);
		Assert.assertEquals(original.stringValue, result.stringValue);
		Assert.assertEquals(original.dateValue.getTime(), result.dateValue.getTime());
		Assert.assertArrayEquals(original.mapValue.keySet().toArray(), result.mapValue.keySet().toArray());
		Assert.assertArrayEquals(original.mapValue.values().toArray(), result.mapValue.values().toArray());
		Assert.assertArrayEquals(original.arrayValue, result.arrayValue);

	}

	@Test
	public void testObjectWithStatic() throws Exception
	{
		ObjectWithStaticField original = new ObjectWithStaticField();
		byte[] bytes = Serializer.encode(original);
		ObjectWithStaticField result = (ObjectWithStaticField) Serializer.decode(bytes);

		Assert.assertEquals(original.data, result.data);
	}

}
