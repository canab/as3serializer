package garbuz.serialization
{
	import flash.utils.ByteArray;

	internal final class Decoder
	{
		private var _decodeMethods:Array = [];

		public function Decoder()
		{
			_decodeMethods[Types.T_INT] = decodeInt;
			_decodeMethods[Types.T_DOUBLE] = decodeDouble;
			_decodeMethods[Types.T_STRING] = decodeString;
			_decodeMethods[Types.T_TRUE] = decodeTrue;
			_decodeMethods[Types.T_FALSE] = decodeFalse;
			_decodeMethods[Types.T_ARRAY] = decodeArray;
			_decodeMethods[Types.T_MAP] = decodeMap;
			_decodeMethods[Types.T_DATE] = decodeDate;
			_decodeMethods[Types.T_NULL] = decodeNull;
			_decodeMethods[Types.T_OBJECT] = decodeTypedObject;
		}

		public function decode(bytes:ByteArray):Object
		{
			bytes.position = 0;
			var value:Object = decodeValue(bytes);
			return value;
		}

		private function decodeValue(bytes:ByteArray):Object
		{
			var type:int = bytes.readByte();
			var method:Function = _decodeMethods[type];
			var value:Object = method(bytes);
			return value;
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
			var length:int = bytes.readInt();
			var string:String = "";

			for (var i:int = 0; i < length; i++)
			{
				string += String.fromCharCode(bytes.readUnsignedShort());
			}

			return string;
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

		//noinspection JSUnusedLocalSymbols
		private function decodeNull(bytes:ByteArray):Object
		{
			return null;
		}

		private function decodeArray(bytes:ByteArray):Array
		{
			var length:int = bytes.readInt();
			var array:Array = [];

			for (var i:int = 0; i < length; i++)
			{
				array.push(decodeValue(bytes));
			}

			return array;
		}

		private function decodeMap(bytes:ByteArray):Object
		{
			var object:Object = {};
			var propCount:int = bytes.readInt();

			for (var i:int = 0; i < propCount; i++)
			{
				var propName:String = decodeString(bytes);
				var propValue:Object = decodeValue(bytes);
				object[propName] = propValue;
			}

			return object;
		}

		private function decodeDate(bytes:ByteArray):Date
		{
			var date:Date = new Date();
			date.time = bytes.readDouble();
			return date;
		}

		private function decodeTypedObject(bytes:ByteArray):Object
		{
			var typeIndex:int = bytes.readShort();
			var type:TypeHolder = Serializer.getTypeByIndex(typeIndex);
			var object:Object = new (type.classRef)();

			for each (var property:String in type.properties)
			{
				object[property] = decodeValue(bytes);
			}

			return object;
		}

	}
}
