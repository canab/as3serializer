package localTests
{
	import flash.utils.ByteArray;

	import garbuz.serialization.Serializer;

	public class SimpleTypesTest extends TestBase
	{
		[Test]
		public function testInteger():void
		{
			testValue(0);
			testValue(12);
			testValue(-12);
			testValue(int.MIN_VALUE);
			testValue(int.MAX_VALUE);
		}

		[Test]
		public function testNumber():void
		{
			testValue(0);
			testValue(-Math.PI);
			testValue(0.25);
			testValue(Number.MAX_VALUE);
			testValue(Number.MIN_VALUE);
			testValue(Number.NEGATIVE_INFINITY);
			testValue(Number.POSITIVE_INFINITY);
		}

		[Test(expects="Error")]
		public function testNaN():void
		{
			testValue(Number.NaN);
		}

		[Test]
		public function testString():void
		{
			testValue("");
			testValue("qwerty");
			testValue("йцукен");
			testValue("qwertyйцукен");
		}

		[Test]
		public function testBoolean():void
		{
			testValue(true);
			testValue(false);
		}

		[Test]
		public function testDate():void
		{
			var date:Date = new Date();
			var bytes:ByteArray = Serializer.encode(date);
			var decodedValue:Date = Serializer.decode(bytes) as Date;
			deepCompare(date.time, decodedValue.time);
		}

		[Test]
		public function testNull():void
		{
			testValue(null);
		}
	}
}
