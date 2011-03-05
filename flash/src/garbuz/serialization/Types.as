package garbuz.serialization
{
	internal class Types
	{
		public static const T_NULL:int = getValue();
		public static const T_INT:int = getValue();
		public static const T_DOUBLE:int = getValue();
		public static const T_STRING:int = getValue();
		public static const T_TRUE:int = getValue();
		public static const T_FALSE:int = getValue();
		public static const T_DATE:int = getValue();

		private static var _currentValue:int = 0;

		private static function getValue():int
		{
			return _currentValue++;
		}
	}
}
