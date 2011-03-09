package garbuz.serialization
{
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	internal final class Encoder
	{
		private var _encodeMethods:Object = {};
		private var _bytes:ByteArray;

		public function Encoder()
		{
			_encodeMethods["string"] = encodeString;
			_encodeMethods["number"] = encodeNumber;
			_encodeMethods["boolean"] = encodeBoolean;
			_encodeMethods["object"] = encodeObject;
		}

		public function encode(value:Object):ByteArray
		{
			_bytes = new ByteArray();
			encodeValue(value);
			return _bytes;
		}

		private function encodeValue(value:Object):void
		{
			var typeName:String = typeof(value);
			var method:Function = _encodeMethods[typeName];

			if (method == null)
				throw new Error("Cannot serialize type:" + typeName);

			method(value);
		}

		private function encodeNumber(value:Number):void
		{
			if (value is int)
				encodeInt(value as int);
			else
				encodeDouble(value as Number);
		}

		private function encodeInt(value:int):void
		{
			var unsigned:uint = (value >= 0) ? value : -value;

			if (value >= 0)
			{
				if (unsigned <= 0xFF)
				{
					_bytes.writeByte(Types.T_UINT1);
					_bytes.writeByte(unsigned);
				}
				else if (unsigned <= 0xFFFF)
				{
					_bytes.writeByte(Types.T_UINT2);
					_bytes.writeByte(unsigned & 0xFF);
					_bytes.writeByte(unsigned >> 8);
				}
				else if (unsigned <= 0xFFFFFF)
				{
					_bytes.writeByte(Types.T_UINT3);
					_bytes.writeByte(unsigned & 0xFF);
					_bytes.writeByte((unsigned >> 8) & 0xFF);
					_bytes.writeByte((unsigned >> 16));
				}
				else
				{
					_bytes.writeByte(Types.T_UINT4);
					_bytes.writeByte(unsigned & 0xFF);
					_bytes.writeByte((unsigned >> 8) & 0xFF);
					_bytes.writeByte((unsigned >> 16) & 0xFF);
					_bytes.writeByte((unsigned >> 24));
				}
			}
			else
			{
				if (unsigned <= 0xFF)
				{
					_bytes.writeByte(Types.T_NINT1);
					_bytes.writeByte(unsigned);
				}
				else if (unsigned <= 0xFFFF)
				{
					_bytes.writeByte(Types.T_NINT2);
					_bytes.writeByte(unsigned & 0xFF);
					_bytes.writeByte(unsigned >> 8);
				}
				else if (unsigned <= 0xFFFFFF)
				{
					_bytes.writeByte(Types.T_NINT3);
					_bytes.writeByte(unsigned & 0xFF);
					_bytes.writeByte((unsigned >> 8) & 0xFF);
					_bytes.writeByte((unsigned >> 16));
				}
				else
				{
					_bytes.writeByte(Types.T_NINT4);
					_bytes.writeByte(unsigned & 0xFF);
					_bytes.writeByte((unsigned >> 8) & 0xFF);
					_bytes.writeByte((unsigned >> 16) & 0xFF);
					_bytes.writeByte((unsigned >> 24));
				}
			}
		}

		private function encodeDouble(value:Number):void
		{
			_bytes.writeByte(Types.T_DOUBLE);
			_bytes.writeDouble(Number(value))
		}

		private function encodeString(value:String):void
		{
			_bytes.writeByte(Types.T_STRING);
			writeString(value);
		}

		private function writeString(value:String):void
		{
			var utfBytes:ByteArray = new ByteArray();
			utfBytes.writeUTFBytes(value);
			encodeInt(utfBytes.length);
			_bytes.writeBytes(utfBytes);
		}

		private function encodeBoolean(value:Boolean):void
		{
			_bytes.writeByte(value ? Types.T_TRUE : Types.T_FALSE);
		}

		private function encodeObject(object:Object):void
		{
			if (object == null)
			{
				encodeNull();
			}
			else if (object is Date)
			{
				encodeDate(object as Date);
			}
			else if (object is Array)
			{
				encodeArray(object as Array);
			}
			else
			{
				var typeName:String = getQualifiedClassName(object);

				if (typeName == "Object")
					encodeMap(object);
				else
					encodeTypedObject(object, typeName);
			}
		}

		private function encodeArray(array:Array):void
		{
			var length:uint = array.length;

			_bytes.writeByte(Types.T_ARRAY);

			encodeInt(length);

			for (var i:int = 0; i < length; i++)
			{
				encodeValue(array[i]);
			}
		}

		private function encodeMap(object:Object):void
		{
			_bytes.writeByte(Types.T_MAP);

			var properties:Array = [];
			for (var property:String in object)
			{
				properties.push(property);
			}

			encodeInt(properties.length);

			for each (property in properties)
			{
				writeString(property);
				encodeValue(object[property]);
			}
		}

		private function encodeDate(value:Date):void
		{
			_bytes.writeByte(Types.T_DATE);
			_bytes.writeDouble(value.time);
		}

		private function encodeTypedObject(object:Object, typeName:String):void
		{
			var type:TypeHolder = Serializer.getTypeByName(typeName);

			_bytes.writeByte(Types.T_OBJECT);

			encodeInt(type.index);

			for each (var property:String in type.properties)
			{
				encodeValue(object[property]);
			}
		}

		private function encodeNull():void
		{
			_bytes.writeByte(Types.T_NULL);
		}

	}
}
