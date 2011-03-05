package garbuz.serialization
{
	import flash.utils.ByteArray;

	internal class Decoder
	{
		private var _decodeMethods:Array = [];

		public function Decoder()
		{
			_decodeMethods[Types.T_NULL] = decodeNull;
			_decodeMethods[Types.T_INT] = decodeInt;
			_decodeMethods[Types.T_DOUBLE] = decodeDouble;
			_decodeMethods[Types.T_STRING] = decodeString;
			_decodeMethods[Types.T_TRUE] = decodeTrue;
			_decodeMethods[Types.T_FALSE] = decodeFalse;
			_decodeMethods[Types.T_DATE] = decodeDate;
		}

		public function decode(bytes:ByteArray):Object
		{
			bytes.position = 0;

			var type:int = bytes.readByte();
			var method:Function = _decodeMethods[type];
			var value:Object = method(bytes);

			return value;
		}

		//noinspection JSUnusedLocalSymbols
		private function decodeNull(bytes:ByteArray):Object
		{
			return null;
		}

		private function decodeInt(bytes:ByteArray):int
		{
			return bytes.readInt();
		}

		private function decodeDouble(bytes:ByteArray):Number
		{
			return bytes.readDouble();
		}

		private function decodeString(bytes:ByteArray):String
		{
			return bytes.readUTF();
		}

		//noinspection JSUnusedLocalSymbols
		private function decodeTrue(bytes:ByteArray):Boolean
		{
			return true;
		}

		//noinspection JSUnusedLocalSymbols
		private function decodeFalse(bytes:ByteArray):Boolean
		{
			return false;
		}

		private function decodeDate(bytes:ByteArray):Date
		{
			var date:Date = new Date();
			date.time = bytes.readDouble();
			return date;
		}
	}
}
