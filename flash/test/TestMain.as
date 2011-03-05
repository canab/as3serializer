package
{
	import asunit.textui.TestRunner;

	import flash.display.Sprite;

	import garbuz.serialization.test.AllTests;

	[SWF(width=800, height=480)]
	public class TestMain extends Sprite
	{
		public function TestMain()
		{
			var testRunner:TestRunner = new TestRunner();
			stage.addChild(testRunner);
			testRunner.start(AllTests, null, false)
		}
	}
}