package garbuz.serialization
{
	import flash.utils.ByteArray;

	internal final class Decoder
	{
		private var _decodeMethods:Array = [];
		private var _bytes:ByteArray;

		public function Decoder()
		{
			_decodeMethods[Types.T_NULL] = decodeNull;

			_decodeMethods[Types.T_TRUE] = decodeTrue;
			_decodeMethods[Types.T_FALSE] = decodeFalse;

			_decodeMethods[Types.T_STRING] = decodeString;
			_decodeMethods[Types.T_DOUBLE] = decodeDouble;
			_decodeMethods[Types.T_DATE] = decodeDate;
			_decodeMethods[Types.T_MAP] = decodeMap;
			_decodeMethods[Types.T_ARRAY] = decodeArray;
			_decodeMethods[Types.T_OBJECT] = decodeTypedObject;

			_decodeMethods[Types.T_UINT1] = decodeUInt1;
			_decodeMethods[Types.T_UINT2] = decodeUInt2;
			_decodeMethods[Types.T_UINT3] = decodeUInt3;
			_decodeMethods[Types.T_UINT4] = decodeUInt4;

			_decodeMethods[Types.T_NINT1] = decodeNInt1;
			_decodeMethods[Types.T_NINT2] = decodeNInt2;
			_decodeMethods[Types.T_NINT3] = decodeNInt3;
			_decodeMethods[Types.T_NINT4] = decodeNInt4;

		}

		public function decode(bytes:ByteArray):Object
		{
			_bytes = bytes;
			_bytes.position = 0;
			
			return decodeValue();
		}

		private function decodeValue():Object
		{
			var type:int = _bytes.readUnsignedByte();
			var method:Function = _decodeMethods[type];
			var value:Object = method();
			return value;
		}

		private function decodeUInt1():int
		{
			return _bytes.readUnsignedByte();
		}

		private function decodeUInt2():int
		{
			var unsigned:uint = _bytes.readUnsignedByte();
			unsigned |= _bytes.readUnsignedByte() << 8;
			return unsigned;
		}

		private function decodeUInt3():int
		{
			var unsigned:uint = _bytes.readUnsignedByte();
			unsigned |= _bytes.readUnsignedByte() << 8;
			unsigned |= _bytes.readUnsignedByte() << 16;
			return unsigned;
		}

		private function decodeUInt4():int
		{
			var unsigned:uint = _bytes.readUnsignedByte();
			unsigned |= _bytes.readUnsignedByte() << 8;
			unsigned |= _bytes.readUnsignedByte() << 16;
			unsigned |= _bytes.readUnsignedByte() << 24;
			return unsigned;
		}

		private function decodeNInt1():int
		{
			return -_bytes.readUnsignedByte();
		}

		private function decodeNInt2():int
		{
			var unsigned:uint = _bytes.readUnsignedByte();
			unsigned |= _bytes.readUnsignedByte() << 8;
			return -unsigned;
		}

		private function decodeNInt3():int
		{
			var unsigned:uint = _bytes.readUnsignedByte();
			unsigned |= _bytes.readUnsignedByte() << 8;
			unsigned |= _bytes.readUnsignedByte() << 16;
			return -unsigned;
		}

		private function decodeNInt4():int
		{
			var unsigned:uint = _bytes.readUnsignedByte();
			unsigned |= _bytes.readUnsignedByte() << 8;
			unsigned |= _bytes.readUnsignedByte() << 16;
			unsigned |= _bytes.readUnsignedByte() << 24;
			return -unsigned;
		}

		private function decodeDouble():Number
		{
			return _bytes.readDouble();
		}

		private function decodeString():String
		{
			var length:int = int(decodeValue());
			return _bytes.readUTFBytes(length);
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
