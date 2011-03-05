package garbuz.serialization.test
{
	import asunit.framework.TestCase;

	import flash.utils.ByteArray;

	import garbuz.serialization.Serializer;

	public class ArrayTest extends TestCase
	{
		public function testArray1():void
		{
			var array1:Array = [1, 2, 3];
			var array2:Array = [1, 1.5, false, null, "bla-bla"];

			testArray(array1);
			testArray(array2);
			testNestedArray([array1, array2]);
		}

		private function testNestedArray(array:Array):void
		{
			var bytes:ByteArray = Serializer.encode(array);
			var decodedArray:Array = Serializer.decode(bytes) as Array;

			for (var i:int = 0; i < array.length; i++)
			{
				assertEqualsArrays(array[i], decodedArray[i]);
			}
		}

		private function testArray(array:Array):void
		{
			var bytes:ByteArray = Serializer.encode(array);
			var decodedValue:Object = Serializer.decode(bytes);
			assertEqualsArrays(array, decodedValue);
		}
	}
}
