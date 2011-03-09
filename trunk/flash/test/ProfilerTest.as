package
{
	import data.SampleObject;

	import flash.display.Sprite;
	import flash.events.Event;

	import flash.utils.ByteArray;

	import flash.utils.getQualifiedClassName;

	import garbuz.serialization.Serializer;

	public class ProfilerTest extends Sprite
	{
		private var array:Array = [];
		
		public function ProfilerTest()
		{
			for (var i:int = 0; i < 500; i++)
			{
				array.push(new SampleObject());
			}
			
			Serializer.registerType(getQualifiedClassName(SampleObject));
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event:Event):void
		{
			var bytes1:ByteArray = Serializer.encode(array);
		}
	}
}
