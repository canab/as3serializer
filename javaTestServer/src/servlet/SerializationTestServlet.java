package servlet;

import garbuz.serialization.Serializer;
import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SerializationTestServlet extends HttpServlet
{
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			String data = request.getParameter("data");
			byte[] bytes = new BASE64Decoder().decodeBuffer(data);
			Object object = Serializer.decode(bytes);
			byte[] result = Serializer.encode(object);
			response.getWriter().print(new BASE64Encoder().encode(result));
		}
		catch (Throwable e)
		{
			response.getWriter().println("Service call error:");
			response.getWriter().println(e.toString());
			e.printStackTrace();
		}
		finally
		{
			response.getWriter().close();
		}
	}
}
