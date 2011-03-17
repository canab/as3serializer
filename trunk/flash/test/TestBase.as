package
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import garbuz.serialization.Serializer;

	import org.flexunit.Assert;

	public class TestBase
	{
		private static var _comparators:Object = {};

		_comparators["string"] = compareEquals;
		_comparators["number"] = compareNumbers;
		_comparators["boolean"] = compareEquals;
		_comparators["object"] = compareObjects;

		protected static function testValue(value:Object):void
		{
			var bytes:ByteArray = Serializer.encode(value);
			var decodedValue:Object = Serializer.decode(bytes);
			deepCompare(value, decodedValue);
		}


		public static function deepCompare(source:Object, target:Object):void
		{
			var sourceType:String = typeof(source);
			var targetType:String = typeof(target);

			Assert.assertEquals(sourceType, targetType);

			var compareMethod:Function = _comparators[sourceType];
			
			Assert.assertNotNull(compareMethod);

			compareMethod(source, target);
		}

		private static function compareObjects(source:Object, target:Object):void
		{
			if (source == null && target == null)
				return;

			if (source == null || target == null)
			{
				doFail(source, target);
				return;
			}

			var sourceType:String = getQualifiedClassName(source);
			var targetType:String = getQualifiedClassName(target);

			Assert.assertEquals(sourceType, targetType);

			if (sourceType == "Date")
				compareDates(source as Date, target as Date);
			else if (sourceType=="Array")
				compareArrays(source as Array, target as Array);
			else if (sourceType.indexOf("__AS3__.vec::Vector") == 0)
				compareVectors(source as Object, target as Object);
			if (sourceType=="Objects")
				compareMaps(source, target);
			else
				compareTypedObjects(source, target);
		}

		private static function compareTypedObjects(source:Object, target:Object):void
		{
			var sourceProps:Array = getProperties(source);
			var targetProps:Array = getProperties(target);

			compareArrays(sourceProps, targetProps);

			for each (var propName:String in sourceProps)
			{
				deepCompare(source[propName], target[propName]);
			}
		}

		private static function getProperties(object:Object):Array
		{
			var properties:Array = [];

			var description:XML = describeType(object);
			var variables:XMLList = description.variable;

			for each (var variable:XML in variables)
			{
				var property:String = variable.@name;
				properties.push(property);
			}

			properties.sort();
			
			return properties;
		}

		private static function compareMaps(source:Object, target:Object):void
		{
			var sourceKeys:Array = getMapKeys(source);
			var targetKeys:Array = getMapKeys(target);

			compareArrays(sourceKeys, targetKeys);

			for each (var propName:String in sourceKeys)
			{
				deepCompare(source[propName], target[propName]);
			}
		}

		private static function getMapKeys(object:Object):Array
		{
			var keys:Array = [];
			for (var propName:String in object)
			{
				keys.push(propName);
			}
			keys.sort();
			return keys;
		}

		private static function compareArrays(source:Array, target:Array):void
		{
			if (source.length != target.length)
			{
				doFail(source, target);
				return;
			}

			for (var i:int = 0; i < source.length; i++)
			{
				deepCompare(source[i], target[i]);
			}
		}

		private static function compareVectors(source:Object, target:Object):void
		{
			if (source.length != target.length)
			{
				doFail(source, target);
				return;
			}

			for (var i:int = 0; i < source.length; i++)
			{
				deepCompare(source[i], target[i]);
			}
		}

		private static function compareDates(source:Date, target:Date):void
		{
			Assert.assertEquals(source.time, target.time);
		}

		private static function compareEquals(source:String, target:String):void
		{
			Assert.assertEquals(source, target);
		}

		private static function compareNumbers(source:Number, target:Number):void
		{
			if (isNaN(source) && isNaN(target))
				return;

			if (isNaN(source) || isNaN(target))
				doFail(source, target);

			Assert.assertEquals(source, target);
		}

		private static function doFail(source:Object, target:Object):void
		{
			Assert.failNotEquals("Not equals:", source, target);
		}
	}
}
