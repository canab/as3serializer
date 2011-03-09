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
			testValue(0xFF);
			testValue(0xFF - 1);
			testValue(0xFF + 1);
			testValue(0xFFFF);
			testValue(0xFFFF - 1);
			testValue(0xFFFF + 1);
			testValue(0xFFFFFF);
			testValue(0xFFFFFF - 1);
			testValue(0xFFFFFF + 1);
			testValue(int.MIN_VALUE);
			testValue(int.MIN_VALUE + 1);
			testValue(int.MAX_VALUE);
			testValue(int.MAX_VALUE - 1);
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
			testValue(Number.NaN);
		}

		[Test]
		public function testString():void
		{
			//testValue("");
			//testValue("qwerty");
			testValue("й");
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
		public function testNull():void
		{
			testValue(null);
		}

		[Test]
		public function testDate():void
		{
			testValue(new Date());
		}
	}
}
