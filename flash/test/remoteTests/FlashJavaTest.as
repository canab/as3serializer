package remoteTests
{
	import common.serialization.Serializer;

	import data.OtherObject;
	import data.SampleObject;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	import org.flexunit.async.Async;

	public class FlashJavaTest extends TestBase
	{
		private static const URL:String = "http://localhost:8080/";
		private static const TIMEOUT:int = 10000;

		[Test(async)]
		public function testInteger():void
		{
			sendRequest([0, 1, -1, int.MIN_VALUE, int.MAX_VALUE]);
		}

		[Test(async)]
		public function testNumber():void
		{
			sendRequest(
				[
					0,
					-Math.PI,
					0.25,
					Number.MAX_VALUE,
					Number.MIN_VALUE,
					Number.NEGATIVE_INFINITY,
					Number.POSITIVE_INFINITY,
					Number.NaN,
				]);
		}

		[Test(async)]
		public function testString():void
		{
			sendRequest([
				"qwerty",
				"йцукен",
				"qwertyйцукен"
			]);
		}


		[Test(async)]
		public function testBoolean():void
		{
			sendRequest([true, false]);
		}

		[Test(async)]
		public function testNull():void
		{
			sendRequest(null);
		}

		[Test(async)]
		public function testDate():void
		{
			sendRequest(new Date());
		}

		[Test(async)]
		public function testArray():void
		{
			var array1:Array = [1, 2, 3];
			var array2:Array = [1, 1.5, false, null, "bla-bla"];

			sendRequest([array1, array2, [array1, array2]]);
		}

		[Test(async)]
		public function testList():void
		{
			var object:OtherObject = new OtherObject();
			object.array = [new SampleObject()];
			object.vector = new <SampleObject>[new SampleObject()];
			sendRequest(object);
		}

		[Test(async)]
		public function testMap():void
		{
			var map:Object =
			{
				integer: 5,
				number: 0.5,
				bool: false,
				date: new Date(),
				nullValue: null,
				mapValue: {},
				arrayValue: []
			};

			sendRequest(map);
		}

		[BeforeClass]
		public static function setUp():void
		{
			Serializer.registerType(getQualifiedClassName(SampleObject));
			Serializer.registerType(getQualifiedClassName(OtherObject));
		}

		[Test(async)]
		public function testObject():void
		{
			sendRequest(new SampleObject());
		}

		private function sendRequest(value:Object):void
		{
			var requestData:URLVariables = new URLVariables();
			var bytes:ByteArray = Serializer.encode(value);

			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(bytes);
			requestData.data = encoder.toString();

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

			var decoder:Base64Decoder = new Base64Decoder();
			decoder.decode(data);
			var bytes:ByteArray = decoder.toByteArray();

			var result:Object = Serializer.decode(bytes);

			deepCompare(source, result);
		}
	}
}
