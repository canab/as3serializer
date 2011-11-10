package common.serialization
{
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class Serializer
	{
		internal static var objectPool:ObjectPool = new ObjectPool();
		internal static var domains:Dictionary = new Dictionary(true);

		private static var _encoder:Encoder = new Encoder();
		private static var _decoder:Decoder = new Decoder();

		private static var _typesByName:Object = {};
		private static var _typesByIndex:Array = [];

		registerDomain(ApplicationDomain.currentDomain);

		public static function encode(value:Object):ByteArray
		{
			return _encoder.encode(value);
		}

		public static function decode(bytes:ByteArray):Object
		{
			return _decoder.decode(bytes);
		}

		public static function registerDomain(domain:ApplicationDomain):void
		{
			if (!domain)
				throw new Error("Domain cannot be null");

			domains[domain] = domain;
		}

		public static function unregisterDomain(domain:ApplicationDomain):void
		{
			if (!domain)
				throw new Error("Domain cannot be null");

			delete domains[domain];
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
