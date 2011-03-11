package localTests;

import garbuz.serialization.Serializer;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class CollectionsTest
{
	@Test
	public void testArrayList() throws Exception
	{
		Object[] array1 = new Object[]{1, 2, 3};
		ArrayList<Object> arrayList = new ArrayList<Object>();
		arrayList.add(1);
		arrayList.add(2);
		arrayList.add(3);

		byte[] bytes = Serializer.encode(arrayList);
		Object result = Serializer.decode(bytes);
		Assert.assertArrayEquals(arrayList.toArray(), (Object[]) result);
	}

	@Test
	public void testArrays() throws Exception
	{
		Object[] array1 = new Object[]{1, 2, 3};
		Object[] array2 = new Object[]{1, 1.5, false, null, "bla-bla"};

		testArray(new Object[]{});
		testArray(array1);
		testArray(array2);
		testArray(new Object[]{array1, array2});
	}

	@Test
	public void testMap() throws Exception
	{
		Map<String, Object> map = new HashMap<String, Object>();

		testMap(map);

		map.put("integer", 5);
		map.put("number", 0.5);
		map.put("bool", false);
		map.put("date", new Date());
		map.put("nullValue", null);
		map.put("arrayValue", new Object[]{1, 2, 3});

		testMap(map);
	}

	protected void testMap(Map value) throws Exception
	{
		byte[] bytes = Serializer.encode(value);
		Map result = (Map) Serializer.decode(bytes);
		Assert.assertArrayEquals(value.keySet().toArray(), result.keySet().toArray());
		Assert.assertArrayEquals(value.values().toArray(), result.values().toArray());
	}

	protected void testArray(Object value) throws Exception
	{
		byte[] bytes = Serializer.encode(value);
		Object result = Serializer.decode(bytes);
		Assert.assertArrayEquals((Object[]) value, (Object[]) result);
	}
}
