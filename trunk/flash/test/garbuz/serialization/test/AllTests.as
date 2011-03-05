package garbuz.serialization.test
{
	import asunit.framework.TestSuite;

	public class AllTests extends TestSuite
	{
		public function AllTests()
		{
			addTest(new TestSimpleValues());
		}
	}
}
