using System;
using System.Web;
using System.Web.UI;

public class BaseUserPage : Page
{
    protected override void OnPreInit(EventArgs e)
    {
        base.OnPreInit(e);
        SetTheme();
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        CheckUserAuthentication();
    }

    private void SetTheme()
    {
        string theme = null;

        if (HttpContext.Current.Session["UserTheme"] != null)
        {
            theme = HttpContext.Current.Session["UserTheme"].ToString();
        }
        else if (HttpContext.Current.Request.Cookies["UserTheme"] != null)
        {
            theme = HttpContext.Current.Request.Cookies["UserTheme"].Value;
            HttpContext.Current.Session["UserTheme"] = theme;
        }
        else
        {
            theme = "Light";
            HttpContext.Current.Session["UserTheme"] = "Light";
        }

        this.Theme = theme;
    }

    protected void CheckUserAuthentication()
    {
        // Skip authentication check for public user pages
        if (IsPublicUserPage())
            return;

        // Check if user is authenticated
        if (Session["UserAuthenticated"] != null && Session["UserCustomerId"] != null)
        {
            // Always update last activity time first to prevent premature timeout
            Session["UserLastActivity"] = DateTime.Now;
            
            // Check if LastActivity exists and if session has expired
            if (Session["UserLastActivity"] != null)
            {
                DateTime lastActivity = (DateTime)Session["UserLastActivity"];
                int timeoutMinutes = Session.Timeout;

                // Only check timeout if more than 1 minute has passed (avoid false positives)
                if (DateTime.Now.Subtract(lastActivity).TotalMinutes > timeoutMinutes + 1)
                {
                    // Session has expired
                    ClearUserSessionAndRedirect();
                    return;
                }
            }
        }
        else
        {
            // User is not authenticated, redirect to unified login page
            Response.Redirect("index.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }

    private void ClearUserSessionAndRedirect()
    {
        Session.Clear();
        Session.Abandon();

        if (Request.Cookies["ASP.NET_SessionId"] != null)
        {
            HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId");
            sessionCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(sessionCookie);
        }

        Response.Redirect("index.aspx?timeout=true", false);
        Context.ApplicationInstance.CompleteRequest();
    }

    protected bool IsPublicUserPage()
    {
        string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath).ToLower();
        string[] publicPages = { 
            "index.aspx",
            "userregister.aspx",
            "forgotpassword.aspx"
        };

        foreach (string page in publicPages)
        {
            if (currentPage == page.ToLower())
                return true;
        }
        return false;
    }

    protected int GetCurrentUserId()
    {
        if (Session["UserCustomerId"] != null)
            return Convert.ToInt32(Session["UserCustomerId"]);
        return 0;
    }

    protected string GetCurrentUserName()
    {
        if (Session["UserName"] != null)
            return Session["UserName"].ToString();
        return "";
    }

    protected string GetCurrentUserEmail()
    {
        if (Session["UserEmail"] != null)
            return Session["UserEmail"].ToString();
        return "";
    }

    protected void ForceUserLogout(string reason = "")
    {
        if (!string.IsNullOrEmpty(reason))
        {
            System.Diagnostics.Debug.WriteLine("Force user logout: " + reason);
        }
        ClearUserSessionAndRedirect();
    }
}
