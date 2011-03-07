package servlet;

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
			response.getWriter().print(data);
		}
		catch (Exception e)
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
