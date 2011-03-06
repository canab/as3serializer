package garbuz.serialization
{
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	internal class Encoder
	{
		private static var _encodeMethods:Object = {};

		public function Encoder()
		{
			_encodeMethods["string"] = encodeString;
			_encodeMethods["number"] = encodeNumber;
			_encodeMethods["boolean"] = encodeBoolean;
			_encodeMethods["object"] = encodeObject;
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

		private function encodeNumber(bytes:ByteArray, value:Number):void
		{
			if (value is int)
				encodeInt(bytes, value as int);
			else
				encodeDouble(bytes, value as Number);
		}

		private function encodeInt(bytes:ByteArray, value:int):void
		{
			bytes.writeByte(Types.T_INT);
			bytes.writeInt(value)
		}

		private function encodeDouble(bytes:ByteArray, value:Number):void
		{
			if (isNaN(value))
				throw new Error("Cannot serialize NaN");

			bytes.writeByte(Types.T_DOUBLE);
			bytes.writeDouble(Number(value))
		}

		private function encodeString(bytes:ByteArray, value:String):void
		{
			bytes.writeByte(Types.T_STRING);
			bytes.writeUTF(String(value));
		}

		private function encodeObject(bytes:ByteArray, object:Object):void
		{
			if (object == null)
			{
				encodeNull(bytes);
			}
			else if (object is Date)
			{
				encodeDate(bytes, object as Date);
			}
			else if (object is Array)
			{
				encodeArray(bytes, object as Array);
			}
			else
			{
				var typeName:String = getQualifiedClassName(object);

				if (typeName == "Object")
					encodeMap(bytes, object);
				else
					encodeTypedObject(bytes, object, typeName);
			}
		}

		private function encodeMap(bytes:ByteArray, object:Object):void
		{
			var properties:Array = [];
			for (var property:String in object)
			{
				properties.push(property);
			}

			bytes.writeByte(Types.T_MAP);
			bytes.writeUnsignedInt(properties.length);

			for each (property in properties)
			{
				bytes.writeUTF(property);
				encodeValue(bytes, object[property]);
			}
		}

		private function encodeTypedObject(bytes:ByteArray, object:Object, typeName:String):void
		{
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

		private function encodeBoolean(bytes:ByteArray, value:Boolean):void
		{
			bytes.writeByte(value ? Types.T_TRUE : Types.T_FALSE);
		}

		private function encodeDate(bytes:ByteArray, value:Date):void
		{
			bytes.writeByte(Types.T_DATE);
			bytes.writeDouble(value.time);
		}

		private function encodeNull(bytes:ByteArray):void
		{
			bytes.writeByte(Types.T_NULL);
		}

	}
}
