package localTests
{
	import data.SampleObject;

	import flash.net.ObjectEncoding;
	import flash.net.registerClassAlias;
	import flash.sampler.Sample;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	import flash.utils.getTimer;

	import garbuz.serialization.Serializer;

	import org.flexunit.asserts.assertEquals;

	public class SizeTest extends TestBase
	{
		[BeforeClass]
		public static function setUp():void
		{
			Serializer.registerType(getQualifiedClassName(SampleObject));
		}

		[Test]
		public function test():void
		{
			var array:Array = [];
			for (var i:int = 0; i < 1000; i++)
			{
				array.push(new SampleObject());
			}

			var time1:int = getTimer();
			var bytes1:ByteArray = Serializer.encode(array);
			time1 = getTimer() - time1;

			var time2:int = getTimer();
			var bytes2:ByteArray = new ByteArray();
			bytes2.writeObject(array);
			time2 = getTimer() - time2;

			registerClassAlias("getQualifiedClassName(SampleObject)", SampleObject);

			var time3:int = getTimer();
			var bytes3:ByteArray = new ByteArray();
			bytes3.writeObject(array);
			time3 = getTimer() - time3;

			testValue(array);
//			assertEquals(time1, time2);
//			assertEquals(time1, time3);

//			assertEquals(bytes1.length, bytes2.length);
//			assertEquals(bytes1.length, bytes3.length);
		}

	}
}
