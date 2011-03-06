package localTests
{
	import asunit.framework.TestCase;

	import data.SampleObject;

	import flash.utils.ByteArray;

	import garbuz.serialization.Serializer;

	public class MapTest extends TestCase
	{
		public function test1():void
		{
			var map:Object = {};
			var bytes:ByteArray = Serializer.encode(map);
			var result:Object = Serializer.decode(bytes);
			assertTrue(result is Object);
		}

		public function test2():void
		{
			var map:Object =
			{
				integer: 5,
				number: 0.5,
				bool: false,
				date: new Date(),
				arrayValue: [new SampleObject()]
			};

			var bytes:ByteArray = Serializer.encode(map);
			var result:Object = Serializer.decode(bytes);

			assertEquals(map.integer, result.integer);
			assertEquals(map.number, result.number);
			assertEquals(map.bool, result.bool);
			assertEquals(map.date.time, result.date.time);
			assertEquals(
					SampleObject(map.arrayValue[0]).intValue,
					SampleObject(result.arrayValue[0]).intValue);
		}
	}
}
