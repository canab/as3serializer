package remoteTests
{
	import by.blooddy.crypto.Base64;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;

	import garbuz.serialization.Serializer;

	import org.flexunit.Assert;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.flexunit.runner.Request;

	public class FlashJavaTest extends TestBase
	{
		private static const URL:String = "http://localhost:8080/";
		private static const TIMEOUT:int = 5000;

		[Test(async)]
		public function test():void
		{
			sendRequest(1);
		}

		private function sendRequest(value:Object):void
		{
			var requestData:URLVariables = new URLVariables();
			requestData.data = Base64.encode(Serializer.encode(value));

			var request:URLRequest = new URLRequest(URL);
			request.method = URLRequestMethod.GET;
			request.data = requestData;

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, Async.asyncHandler(this, onResponse, TIMEOUT, value));

			Async.registerFailureEvent(this, loader, SecurityErrorEvent.SECURITY_ERROR);
			Async.registerFailureEvent(this, loader, IOErrorEvent.IO_ERROR);

			loader.load(request);
		}

		private function onResponse(event:Event, source:Object):void
		{
			var data:String = URLLoader(event.target).data;
			var bytes:ByteArray = Base64.decode(data);
			var result:Object = Serializer.decode(bytes);
			deepCompare(source, result);
		}
	}
}
