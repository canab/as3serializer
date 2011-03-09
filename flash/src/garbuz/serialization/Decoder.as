package garbuz.serialization
{
	import flash.utils.ByteArray;

	internal final class Decoder
	{
		private var _decodeMethods:Array = [];
		private var _bytes:ByteArray;

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
			_bytes = bytes;
			_bytes.position = 0;
			
			return decodeValue();
		}

		private function decodeValue():Object
		{
			var type:int = _bytes.readByte();
			var method:Function = _decodeMethods[type];
			var value:Object = method();
			return value;
		}

		private function decodeInt():int
		{
			return _bytes.readInt();
		}

		private function decodeDouble():Number
		{
			return _bytes.readDouble();
		}

		private function decodeString():String
		{
			var length:int = int(decodeValue());
			var string:String = "";

			for (var i:int = 0; i < length; i++)
			{
				string += String.fromCharCode(_bytes.readUnsignedShort());
			}

			return string;
		}

		//noinspection JSUnusedLocalSymbols
		private function decodeTrue():Boolean
		{
			return true;
		}

		//noinspection JSUnusedLocalSymbols
		private function decodeFalse():Boolean
		{
			return false;
		}

		//noinspection JSUnusedLocalSymbols
		private function decodeNull():Object
		{
			return null;
		}

		private function decodeArray():Array
		{
			var length:int = int(decodeValue());
			var array:Array = [];

			for (var i:int = 0; i < length; i++)
			{
				array.push(decodeValue());
			}

			return array;
		}

		private function decodeMap():Object
		{
			var object:Object = {};
			var propCount:int = int(decodeValue());

			for (var i:int = 0; i < propCount; i++)
			{
				var propName:String = decodeString();
				var propValue:Object = decodeValue();
				object[propName] = propValue;
			}

			return object;
		}

		private function decodeDate():Date
		{
			var date:Date = new Date();
			date.time = _bytes.readDouble();
			return date;
		}

		private function decodeTypedObject():Object
		{
			var typeIndex:int = int(decodeValue());
			var type:TypeHolder = Serializer.getTypeByIndex(typeIndex);
			var object:Object = new (type.classRef)();

			for each (var property:String in type.properties)
			{
				object[property] = decodeValue();
			}

			return object;
		}

	}
}
