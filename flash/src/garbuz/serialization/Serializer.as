package garbuz.serialization
{
	import flash.utils.ByteArray;

	public class Serializer
	{
		private static var _encoder:Encoder = new Encoder();
		private static var _decoder:Decoder = new Decoder();

		public static function encode(value:Object):ByteArray
		{
			return _encoder.encode(value);
		}

		public static function decode(bytes:ByteArray):Object
		{
			return _decoder.decode(bytes);
		}
	}
}
