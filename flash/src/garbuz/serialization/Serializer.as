package garbuz.serialization
{
	import flash.utils.ByteArray;

	public final class Serializer
	{
		internal static var objectPool:ObjectPool = new ObjectPool();

		private static var _encoder:Encoder = new Encoder();
		private static var _decoder:Decoder = new Decoder();

		private static var _typesByName:Object = {};
		private static var _typesByIndex:Array = [];

		public static function encode(value:Object):ByteArray
		{
			return _encoder.encode(value);
		}

		public static function decode(bytes:ByteArray):Object
		{
			return _decoder.decode(bytes);
		}

		public static function registerType(qualifiedName:String):void
		{
			var typeName:String = qualifiedName.replace("::", ".");

			if (!(typeName in _typesByName))
			{
				var index:int = _typesByIndex.length;
				var type:TypeHolder = new TypeHolder(index, typeName);

				_typesByName[typeName] = type;
				_typesByIndex[index] = type;
			}
		}

		internal static function getTypeByName(qualifiedName:String):TypeHolder
		{
			var typeName:String = qualifiedName.replace("::", ".");

			var type:TypeHolder = _typesByName[typeName];

			if (!type)
				throw new Error("Type " + typeName + " is not registered");

			if (!type.initialized)
				type.initialize();

			return type;
		}

		internal static function getTypeByIndex(typeIndex:int):TypeHolder
		{
			var type:TypeHolder = _typesByIndex[typeIndex];

			if (!type.initialized)
				type.initialize();

			return type;
		}

	}
}
