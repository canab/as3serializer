package localTests
{
	public class CollectionsTest extends TestBase
	{
		[Test]
		public function testArray():void
		{
			var array1:Array = [1, 2, 3];
			var array2:Array = [1, 1.5, false, null, "bla-bla"];

			testValue([]);
			testValue(array1);
			testValue(array2);
			testValue([array1, array2]);
		}

		[Test]
		public function testMap():void
		{
			testValue({});

			var map:Object =
			{
				integer: 5,
				number: 0.5,
				bool: false,
				date: new Date(),
				nullValue: null,
				arrayValue: [1, 2, 3]
			};

			testValue(map);
		}
	}
}
