package localTests
{
	import common.serialization.Serializer;

	import data.OtherObject;
	import data.SampleObject;

	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	public class ObjectTest extends TestBase
	{
		[BeforeClass]
		public static function setUp():void
		{
			Serializer.registerType(getQualifiedClassName(SampleObject));
			Serializer.registerType(getQualifiedClassName(OtherObject));
		}

		[Test]
		public function testVector():void
		{
			var value:Vector.<SampleObject> = new <SampleObject>[new SampleObject(), new SampleObject()];
			var bytes:ByteArray = Serializer.encode(value);
			var decodedValue:Object = Serializer.decode(bytes);
			deepCompare(value, Vector.<SampleObject>(decodedValue));
		}

		[Test]
		public function testObject():void
		{
			testValue(new SampleObject());

			var otherObject:OtherObject = new OtherObject();
			testValue(otherObject);

			otherObject.array = [new SampleObject(), new SampleObject()];
			otherObject.vector = new <SampleObject>[new SampleObject(), new SampleObject()];
			testValue(otherObject);
		}

		[Test]
		public function testObjectWithNulls():void
		{
			var object:SampleObject = new SampleObject();
			object.stringValue = null;
			testValue(object);
		}

		[Test]
		public function testNestedObject():void
		{
			var object1:SampleObject = new SampleObject();
			object1.arrayValue = [[Math.PI]];

			var object2:SampleObject = new SampleObject();
			object2.arrayValue = [[object1]];

			testValue(object2);
		}
	}
}
