package localTests
{
	import asunit.framework.TestSuite;

	public class LocalSuite extends TestSuite
	{
		public function LocalSuite()
		{
			addTest(new SimpleTypesTest());
			addTest(new ArrayTest());
			addTest(new TypedObjectTest());
			addTest(new MapTest());
		}
	}
}
