package {
	import asunit.framework.TestSuite;

	import localTests.ArrayTest;
	import localTests.SimpleTypesTest;
	import localTests.TypedObjectTest;

	public class LocalSuite extends TestSuite
	{
		public function LocalSuite()
		{
			addTest(new SimpleTypesTest());
			addTest(new ArrayTest());
			addTest(new TypedObjectTest());
		}
	}
}
