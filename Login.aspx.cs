using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web;
using System.Security.Cryptography;
using System.Text;

public partial class Water_Man_Default2 : BasePage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is already authenticated and session is still valid
        if (Session["Authenticated"] != null && Session["LastActivity"] != null)
        {
            DateTime lastActivity = (DateTime)Session["LastActivity"];
            int timeoutMinutes = Session.Timeout;

            if (DateTime.Now.Subtract(lastActivity).TotalMinutes <= timeoutMinutes)
            {
                // Session is still valid, redirect to dashboard
                Response.Redirect("Default.aspx", false);
                return;
            }
            else
            {
                // Session has expired, clear it
                Session.Clear();
                Session.Abandon();

                // Show timeout message if coming from timeout
                if (Request.QueryString["timeout"] == "true")
                {
                    lblError.Text = "Your session has expired. Please log in again.";
                    lblError.Visible = true;
                }
            }
        }

        if (IsPostBack)
        {
            string username = Request.Form["txtuname"];
            string password = Request.Form["txtpassword"];

            if (!string.IsNullOrEmpty(username) && !string.IsNullOrEmpty(password))
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(conStr))
                    {
                        string query = "SELECT COUNT(*) FROM Tbl_Login WHERE Username=@user AND Password=@pass";
                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@user", username.Trim());
                        cmd.Parameters.AddWithValue("@pass", password);

                        con.Open();
                        int count = Convert.ToInt32(cmd.ExecuteScalar());

                        if (count > 0)
                        {
                            // Clear any existing session data
                            Session.Clear();

                            // Set authentication session variables
                            Session["Authenticated"] = true;
                            Session["Username"] = username.Trim();
                            Session["LoginTime"] = DateTime.Now;

                            // ✅ IMPORTANT: Set LastActivity for session timeout tracking
                            Session["LastActivity"] = DateTime.Now;
                           
                            // ✅ Set session cookie parameters for better security (optional)
                            HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", Session.SessionID);
                            sessionCookie.HttpOnly = true; // Prevent JavaScript access
                            sessionCookie.Secure = Request.IsSecureConnection; // HTTPS only if site uses HTTPS
                            Response.Cookies.Add(sessionCookie);

                            // Redirect to dashboard
                            Response.Redirect("Default.aspx", false);
                        }
                        else
                        {
                            lblError.Text = "Invalid username or password. Please try again.";
                            lblError.Visible = true;
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblError.Text = "An error occurred during login. Please try again.";
                    lblError.Visible = true;

                    // Log the exception (consider implementing proper logging)
                    System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
                }
            }
            else
            {
                lblError.Text = "Please enter both username and password.";
                lblError.Visible = true;
            }
        }
        else
        {
            lblError.Visible = false;
        }
    }

    // ✅ Helper method to check if session has timed out (can be used elsewhere)
    private bool IsSessionTimedOut()
    {
        if (Session["LastActivity"] == null)
            return true;

        DateTime lastActivity = (DateTime)Session["LastActivity"];
        return (DateTime.Now.Subtract(lastActivity).TotalMinutes > Session.Timeout);
    }
}