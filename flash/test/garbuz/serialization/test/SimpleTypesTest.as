package garbuz.serialization.test
{
	import asunit.framework.TestCase;

	import flash.utils.ByteArray;

	import garbuz.serialization.Serializer;

	public class SimpleTypesTest extends TestCase
	{
		public function testInteger():void
		{
			testValue(0);
			testValue(12);
			testValue(-12);
			testValue(int.MIN_VALUE);
			testValue(int.MAX_VALUE);
		}

		public function testNumber():void
		{
			testValue(0);
			testValue(-Math.PI);
			testValue(0.25);
			testValue(Number.MAX_VALUE);
			testValue(Number.MIN_VALUE);
			testValue(Number.NEGATIVE_INFINITY);
			testValue(Number.POSITIVE_INFINITY);

			assertThrows(Error, function():void { testValue(Number.NaN) });
		}

		public function testString():void
		{
			testValue("");
			testValue("qwerty");
			testValue("йцукен");
			testValue("qwertyйцукен");
		}

		public function testBoolean():void
		{
			testValue(true);
			testValue(false);
		}

		public function testDate():void
		{
			var date:Date = new Date();
			var bytes:ByteArray = Serializer.encode(date);
			var decodedValue:Date = Serializer.decode(bytes) as Date;
			assertEquals(date.time, decodedValue.time);
		}

		public function testNull():void
		{
			testValue(null);
		}

		private function testValue(value:Object):void
		{
			var bytes:ByteArray = Serializer.encode(value);
			var decodedValue:Object = Serializer.decode(bytes);
			assertEquals(value, decodedValue);
		}
	}
}
