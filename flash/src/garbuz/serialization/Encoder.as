package garbuz.serialization
{
	import flash.utils.ByteArray;

	internal class Encoder
	{
		public function encode(value:Object):ByteArray
		{
			var bytes:ByteArray = new ByteArray();

			if (value is int)
			{
				encodeInt(bytes, value);
			}
			else if (value is Number)
			{
				encodeDouble(value, bytes);
			}
			else if (value is String)
			{
				encodeString(bytes, value);
			}
			else if (value is Boolean)
			{
				encodeBoolean(bytes, value);
			}
			else if (value == null)
			{
				encodeNull(bytes);
			}
			else if (value is Date)
			{
				encodeDate(bytes, value);
			}
			else
			{
				throw new Error("Unsupported data type: " + String(value));
			}

			return bytes;
		}

		private function encodeInt(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(Types.T_INT);
			bytes.writeInt(int(value))
		}

		private function encodeString(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(Types.T_STRING);
			bytes.writeUTF(String(value));
		}

		private function encodeDouble(value:Object, bytes:ByteArray):void
		{
			if (isNaN(Number(value)))
				throw new Error("Unsupported value: " + String(value));

			bytes.writeByte(Types.T_DOUBLE);
			bytes.writeDouble(Number(value))
		}

		private function encodeBoolean(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(value ? Types.T_TRUE : Types.T_FALSE);
		}

		private function encodeDate(bytes:ByteArray, value:Object):void
		{
			bytes.writeByte(Types.T_DATE);
			var date:Date = value as Date;
			bytes.writeDouble(date.time);
		}

		private function encodeNull(bytes:ByteArray):void
		{
			bytes.writeByte(Types.T_NULL);
		}
	}
}
