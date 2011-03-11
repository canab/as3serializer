package localTests
{
	import flash.utils.ByteArray;

	import garbuz.serialization.Serializer;

	import org.flexunit.asserts.assertEquals;

	public class SimpleTypesTest extends TestBase
	{
		[Test]
		public function testSequence():void
		{
			var val1:int = 1;
			var val2:int = 2;

			var b1:ByteArray = Serializer.encode(val1);
			var b2:ByteArray = Serializer.encode(val2);

			var res1:int = int(Serializer.decode(b1));
			var res2:int = int(Serializer.decode(b2));

			assertEquals(val1, res1);
			assertEquals(val2, res2);
		}

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
			testValue("");
			testValue("й");
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
