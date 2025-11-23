using System;
using System.Web;
using System.Web.UI;

public partial class UserMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is authenticated
        if (Session["UserAuthenticated"] == null || Session["UserCustomerId"] == null)
        {
            Response.Redirect("index.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        // Clear session
        Session.Clear();
        Session.Abandon();

        // Clear cookies
        if (Request.Cookies["ASP.NET_SessionId"] != null)
        {
            HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId");
            sessionCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(sessionCookie);
        }

        // Redirect to unified login page
        Response.Redirect("index.aspx", false);
        Context.ApplicationInstance.CompleteRequest();
    }
}
