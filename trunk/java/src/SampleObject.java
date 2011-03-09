import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class SampleObject
{
	public int intValue = -10;
	public double numberValue = -1.5;
	public boolean boolValue = true;
	public String stringValue = "qwertyйцукен";
	public Date dateValue = new Date();
	public Object[] arrayValue = new Object[]{intValue, boolValue, stringValue};
	public Map<String, Object> mapValue = new HashMap<String, Object>();

	public SampleObject()
	{
		mapValue.put("1", arrayValue);
	}

}
