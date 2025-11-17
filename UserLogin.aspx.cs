using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;

public partial class UserLogin : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is already authenticated
        if (Session["UserAuthenticated"] != null && Session["UserCustomerId"] != null)
        {
            Response.Redirect("UserDashboard.aspx", false);
            return;
        }

        // Show timeout message if coming from timeout
        if (!IsPostBack && Request.QueryString["timeout"] == "true")
        {
            lblError.Text = "Your session has expired. Please log in again.";
            lblError.Visible = true;
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();
        string mobile = txtMobile.Text.Trim();

        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mobile))
        {
            lblError.Text = "Please enter both email and mobile number.";
            lblError.Visible = true;
            return;
        }

        // Validate mobile number format
        if (mobile.Length != 10 || !System.Text.RegularExpressions.Regex.IsMatch(mobile, @"^\d{10}$"))
        {
            lblError.Text = "Please enter a valid 10-digit mobile number.";
            lblError.Visible = true;
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                // First, check if email column exists, if not we'll add it
                string query = @"SELECT Customer_Id, Name, Address, Mobile, Area_Id 
                                FROM Tbl_Customer 
                                WHERE Mobile = @Mobile AND IsActive = 1";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Mobile", mobile);

                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    // Clear any existing session data
                    Session.Clear();

                    // Set user session variables
                    Session["UserAuthenticated"] = true;
                    Session["UserCustomerId"] = reader["Customer_Id"];
                    Session["UserName"] = reader["Name"];
                    Session["UserMobile"] = reader["Mobile"];
                    Session["UserEmail"] = email; // Store the email they entered
                    Session["UserAddress"] = reader["Address"];
                    Session["UserAreaId"] = reader["Area_Id"];
                    Session["UserLoginTime"] = DateTime.Now;
                    Session["UserLastActivity"] = DateTime.Now;

                    // Set session cookie
                    HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", Session.SessionID);
                    sessionCookie.HttpOnly = true;
                    sessionCookie.Secure = Request.IsSecureConnection;
                    Response.Cookies.Add(sessionCookie);

                    // Redirect to user dashboard
                    Response.Redirect("UserDashboard.aspx", false);
                }
                else
                {
                    lblError.Text = "Invalid credentials. Please check your mobile number and try again.";
                    lblError.Visible = true;
                }

                reader.Close();
            }
        }
        catch (Exception ex)
        {
            lblError.Text = "An error occurred during login. Please try again.";
            lblError.Visible = true;
            System.Diagnostics.Debug.WriteLine("User login error: " + ex.Message);
        }
    }
}
