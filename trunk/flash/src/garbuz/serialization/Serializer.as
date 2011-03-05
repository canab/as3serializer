package garbuz.serialization
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class Serializer
	{
		private static var _encoder:Encoder = new Encoder();
		private static var _decoder:Decoder = new Decoder();

		private static var _typesByName:Object = {};
		private static var _typesByIndex:Array = [];
		private static var _typesByClass:Dictionary = new Dictionary();

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
			if (!(qualifiedName in _typesByName))
			{
				var index:int = _typesByIndex.length;
				var typeInfo:TypeInfo = new TypeInfo(index, qualifiedName);

				_typesByName[qualifiedName] = typeInfo;
				_typesByIndex[index] = typeInfo;
			}
		}

		internal static function getTypeInfo(type:Class):TypeInfo
		{
			var info:TypeInfo = _typesByClass[type];

			if (!info)
			{
				info = _typesByName[getQualifiedClassName(type)];
				initializeTypeInfo(info);
			}

			return info;
		}

		internal static function getTypeInfoByIndex(typeIndex:int):TypeInfo
		{
			var info:TypeInfo = _typesByIndex[typeIndex];

			if (!info.initialized)
				initializeTypeInfo(info);

			return info;
		}

		private static function initializeTypeInfo(info:TypeInfo):void
		{
			info.initialize();
			_typesByClass[info.classRef] = info;
		}
	}
}
