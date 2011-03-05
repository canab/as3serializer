package garbuz.serialization
{
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	internal class Encoder
	{
		private var _encodeMethods:Array = [];

		public function Encoder()
		{
			_encodeMethods["number"] = encodeNumber;
			_encodeMethods["object"] = encodeObject;
			_encodeMethods["string"] = encodeString;
			_encodeMethods["boolean"] = encodeBoolean;
		}

		public function encode(value:Object):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			encodeValue(bytes, value);
			return bytes;
		}

		private function encodeValue(bytes:ByteArray, value:Object):void
		{
			var typeName:String = typeof(value);
			var method:Function = _encodeMethods[typeName];

			if (method == null)
				throw new Error("Cannot serialize type:" + typeName);

			method(bytes, value);
		}

		private function encodeObject(bytes:ByteArray, value:Object):void
		{
			if (value == null)
				encodeNull(bytes);
			else if (value is Date)
				encodeDate(bytes, value as Date);
			else if (value is Array)
				encodeArray(bytes, value as Array);
			else
				encodeTypedObject(bytes, value);
		}

		private function encodeTypedObject(bytes:ByteArray, object:Object):void
		{
			var typeName:String = getQualifiedClassName(object);
			var type:TypeHolder = Serializer.getTypeByName(typeName);

			bytes.writeByte(Types.T_OBJECT);
			bytes.writeShort(type.index);

			for each (var property:String in type.properties)
			{
				encodeValue(bytes, object[property]);
			}
		}

		private function encodeArray(bytes:ByteArray, array:Array):void
		{
			var length:uint = array.length;

			bytes.writeByte(Types.T_ARRAY);
			bytes.writeUnsignedInt(length);

			for (var i:int = 0; i < length; i++)
			{
				encodeValue(bytes, array[i]);
			}
		}

		private function encodeNumber(bytes:ByteArray, value:Number):void
		{
			if (value is int)
				encodeInt(bytes, value);
			else
				encodeDouble(bytes, value);
		}

		private function encodeInt(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(Types.T_INT);
			bytes.writeInt(int(value))
		}

		private function encodeDouble(bytes:ByteArray, value:Number):void
		{
			if (isNaN(value))
				throw new Error("Cannot serialize NaN");

			bytes.writeByte(Types.T_DOUBLE);
			bytes.writeDouble(Number(value))
		}

		private function encodeString(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(Types.T_STRING);
			bytes.writeUTF(String(value));
		}

		private function encodeBoolean(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(value ? Types.T_TRUE : Types.T_FALSE);
		}

		private function encodeDate(bytes:ByteArray, value:Date):void
		{
			bytes.writeByte(Types.T_DATE);
			bytes.writeDouble(value.time);
		}

		//noinspection JSUnusedLocalSymbols
		private function encodeNull(bytes:ByteArray, value:Object = null):void
		{
			bytes.writeByte(Types.T_NULL);
		}
	}
}
