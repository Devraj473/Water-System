using System;
using System.Web;
using System.Web.UI;

public class BasePage : Page
{
    protected override void OnPreInit(EventArgs e)
    {
        base.OnPreInit(e);

        // Handle theme setting
        SetTheme();
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);

        // Check session timeout for authenticated pages
        CheckSessionTimeout();
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        // Register session timeout script for authenticated users
        if (!IsPostBack)
        {
            RegisterSessionTimeoutScript();
        }
    }

    private void SetTheme()
    {
        string theme = null;

        if (HttpContext.Current.Session["Theme"] != null)
        {
            theme = HttpContext.Current.Session["Theme"].ToString();
        }
        else if (HttpContext.Current.Request.Cookies["Theme"] != null)
        {
            theme = HttpContext.Current.Request.Cookies["Theme"].Value;
            HttpContext.Current.Session["Theme"] = theme; // Restore session
        }
        else
        {
            theme = "Light";
            HttpContext.Current.Session["Theme"] = "Light";
        }

        this.Theme = theme;
    }

    protected void CheckSessionTimeout()
    {
        // Skip session check for login page and other public pages
        if (IsPublicPage())
            return;

        // Check if user should be authenticated
        if (Session["Authenticated"] != null)
        {
            // Always update last activity time first to prevent premature timeout
            Session["LastActivity"] = DateTime.Now;
            
            // Check if LastActivity exists and if session has expired
            if (Session["LastActivity"] != null)
            {
                DateTime lastActivity = (DateTime)Session["LastActivity"];
                int timeoutMinutes = Session.Timeout;

                // Only check timeout if more than 1 minute has passed (avoid false positives)
                if (DateTime.Now.Subtract(lastActivity).TotalMinutes > timeoutMinutes + 1)
                {
                    // Session has expired
                    LogSessionTimeout();
                    ClearSessionAndRedirect();
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

    private void ClearSessionAndRedirect()
    {
        // Clear session
        Session.Clear();
        Session.Abandon();

        // Clear authentication cookie if exists
        if (Request.Cookies[".ASPXAUTH"] != null)
        {
            HttpCookie authCookie = new HttpCookie(".ASPXAUTH");
            authCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(authCookie);
        }

        // Clear session cookie
        if (Request.Cookies["ASP.NET_SessionId"] != null)
        {
            HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId");
            sessionCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(sessionCookie);
        }

        Response.Redirect("index.aspx?timeout=true", false);
        Context.ApplicationInstance.CompleteRequest();
    }

    private void LogSessionTimeout()
    {
        try
        {
            // Log session timeout (optional - you can implement database logging here)
            string username = Session["Username"] != null ? Session["Username"].ToString() : "Unknown";
            string logMessage = string.Format("Session timeout for user: {0} at {1}", username, DateTime.Now);

            // You can implement database logging here if needed
            System.Diagnostics.Debug.WriteLine(logMessage);
        }
        catch (Exception ex)
        {
            // Don't let logging errors affect the application
            System.Diagnostics.Debug.WriteLine("Error logging session timeout: " + ex.Message);
        }
    }

    // Helper method to check if current page is a public page
    protected bool IsPublicPage()
    {
        string currentPage = System.IO.Path.GetFileName(Request.Url.AbsolutePath).ToLower();
        string[] publicPages = { 
            "index.aspx", 
            "default2.aspx", 
            "register.aspx", 
            "forgotpassword.aspx",
            "error.aspx",
            "unauthorized.aspx"
        };

        foreach (string page in publicPages)
        {
            if (currentPage == page.ToLower())
                return true;
        }
        return false;
    }

    // Helper method to get remaining session time in minutes
    protected int GetRemainingSessionTime()
    {
        if (Session["LastActivity"] != null)
        {
            DateTime lastActivity = (DateTime)Session["LastActivity"];
            int timeoutMinutes = Session.Timeout;
            double elapsedMinutes = DateTime.Now.Subtract(lastActivity).TotalMinutes;
            return Math.Max(0, (int)(timeoutMinutes - elapsedMinutes));
        }
        return 0;
    }

    // Helper method to extend session (useful for AJAX calls)
    protected void ExtendSession()
    {
        if (Session["Authenticated"] != null)
        {
            Session["LastActivity"] = DateTime.Now;
        }
    }

    // Helper method to check if session is about to expire
    protected bool IsSessionAboutToExpire(int warningMinutes = 5)
    {
        int remainingMinutes = GetRemainingSessionTime();
        return remainingMinutes > 0 && remainingMinutes <= warningMinutes;
    }

    // Register client-side session timeout script
    protected void RegisterSessionTimeoutScript()
    {
        if (Session["Authenticated"] != null && !IsPublicPage())
        {
            int remainingMinutes = GetRemainingSessionTime();
            int warningMinutes = 5; // Warn 5 minutes before timeout

            if (remainingMinutes > 0)
            {
                string script = string.Format(@"
                    var sessionTimeoutMinutes = {0};
                    var warningMinutes = {1};
                    
                    function startSessionTimer() {{
                        var warningTime = Math.max(0, (sessionTimeoutMinutes - warningMinutes) * 60 * 1000);
                        var timeoutTime = sessionTimeoutMinutes * 60 * 1000;
                        
                        // Show warning before timeout
                        if (warningTime > 0) {{
                            setTimeout(function() {{
                                if (confirm('Your session will expire in ' + warningMinutes + ' minutes. Click OK to extend your session or Cancel to logout now.')) {{
                                    // Extend session by reloading page
                                    window.location.reload();
                                }} else {{
                                    // User chose to logout
                                    window.location.href = 'index.aspx';
                                }}
                            }}, warningTime);
                        }}
                        
                        // Auto logout when session expires
                        setTimeout(function() {{
                            alert('Your session has expired. You will be redirected to the login page.');
                            window.location.href = 'index.aspx?timeout=true';
                        }}, timeoutTime);
                    }}
                    
                    // Start the timer
                    if (sessionTimeoutMinutes > 0) {{
                        startSessionTimer();
                    }}
                ", remainingMinutes, warningMinutes);

                ClientScript.RegisterStartupScript(this.GetType(), "SessionTimeout", script, true);
            }
        }
    }

    // Method to get session information (useful for debugging)
    protected string GetSessionInfo()
    {
        if (Session["Authenticated"] != null)
        {
            string info = string.Format(
                "User: {0}, Login Time: {1}, Last Activity: {2}, Remaining Time: {3} minutes",
                Session["Username"] ?? "Unknown",
                Session["LoginTime"] ?? "Unknown",
                Session["LastActivity"] ?? "Unknown",
                GetRemainingSessionTime()
            );
            return info;
        }
        return "Not authenticated";
    }

    // Method to force logout
    protected void ForceLogout(string reason = "")
    {
        if (!string.IsNullOrEmpty(reason))
        {
            System.Diagnostics.Debug.WriteLine("Force logout: " + reason);
        }

        ClearSessionAndRedirect();
    }

    // Method to check authentication (can be called from pages)
    protected void CheckAuthentication()
    {
        if (Session["Authenticated"] == null)
        {
            Response.Redirect("index.aspx");
        }
    }    
}