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

		public function test1():void
		{
			var object:TestObject = new TestObject();
			var bytes:ByteArray = Serializer.encode(object);
			var result:TestObject = TestObject(Serializer.decode(bytes));

			checkObject(object, result);
		}

		private function checkObject(object:TestObject, result:TestObject):void
		{
			assertEquals(object.intValue, result.intValue);
			assertEquals(object.numberValue, result.numberValue);
			assertEquals(object.boolValue, result.boolValue);
			assertEquals(object.stringValue, result.stringValue);
			assertEquals(object.dateValue, result.dateValue);
			assertEqualsArrays(object.arrayValue, result.arrayValue);
		}
	}
}
