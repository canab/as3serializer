package garbuz.serialization.test
{
	import asunit.framework.TestCase;

	import flash.utils.ByteArray;

	import flash.utils.getQualifiedClassName;

	import garbuz.serialization.Serializer;

	public class TypedObjectTest extends TestCase
	{
		override protected function setUp():void
		{
			Serializer.registerType(getQualifiedClassName(TestObject));
		}

		public function testObject():void
		{
			var object:TestObject = new TestObject();
			var bytes:ByteArray = Serializer.encode(object);
			var result:TestObject = TestObject(Serializer.decode(bytes));

			checkObject(object, result);
		}

		public function testObjectWithNulls():void
		{
			var object:TestObject = new TestObject();
			object.stringValue = null;
			var bytes:ByteArray = Serializer.encode(object);
			var result:TestObject = TestObject(Serializer.decode(bytes));

			checkObject(object, result);
		}

		public function testNestedObject():void
		{
			var object1:TestObject = new TestObject();
			object1.arrayValue = [[Math.PI]];

			var object2:TestObject = new TestObject();
			object2.arrayValue = [[object1]];

			var bytes:ByteArray = Serializer.encode(object2);
			var result:TestObject = TestObject(Serializer.decode(bytes));

			assertEquals(result.arrayValue[0][0].arrayValue[0][0], Math.PI);
		}

		private function checkObject(object:TestObject, result:TestObject):void
		{
			assertEquals(object.intValue, result.intValue);
			assertEquals(object.numberValue, result.numberValue);
			assertEquals(object.boolValue, result.boolValue);
			assertEquals(object.stringValue, result.stringValue);
			assertEquals(object.dateValue.time, result.dateValue.time);
			assertEqualsArrays(object.arrayValue, result.arrayValue);
		}
	}
}
