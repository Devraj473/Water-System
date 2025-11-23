using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Text.RegularExpressions;

public partial class index : System.Web.UI.Page
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is already logged in
        if (Session["UserAuthenticated"] != null && Session["UserCustomerId"] != null)
        {
            Response.Redirect("UserDashboard.aspx", false);
            return;
        }

        // Check if admin is already logged in (using same session variables as existing admin login)
        if (Session["Authenticated"] != null && Session["Username"] != null)
        {
            DateTime lastActivity = (DateTime)Session["LastActivity"];
            int timeoutMinutes = Session.Timeout;

            if (DateTime.Now.Subtract(lastActivity).TotalMinutes <= timeoutMinutes)
            {
                Response.Redirect("Default.aspx", false);
                return;
            }
        }

        // Set default field requirements for customer login
        if (!IsPostBack)
        {
            txtEmail.Attributes.Add("placeholder", "Enter your email");
            txtMobile.Attributes.Add("placeholder", "Enter your 10-digit mobile number");
            txtUsername.Attributes.Add("placeholder", "Enter your username");
            txtPassword.Attributes.Add("placeholder", "Enter your password");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string userType = Request.Form["userType"] ?? "customer"; // Get selected user type

        if (userType == "customer")
        {
            CustomerLogin();
        }
        else
        {
            AdminLogin();
        }
    }

    private void CustomerLogin()
    {
        string email = txtEmail.Text.Trim();
        string mobile = txtMobile.Text.Trim();

        // Validation
        if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(mobile))
        {
            lblError.Text = "Please enter both email and mobile number.";
            lblError.Visible = true;
            return;
        }

        // Validate email format
        if (!IsValidEmail(email))
        {
            lblError.Text = "Please enter a valid email address.";
            lblError.Visible = true;
            return;
        }

        // Validate mobile number format
        if (mobile.Length != 10 || !Regex.IsMatch(mobile, @"^\d{10}$"))
        {
            lblError.Text = "Please enter a valid 10-digit mobile number.";
            lblError.Visible = true;
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"SELECT Customer_Id, Name, Address, Mobile, Area_Id, IsActive 
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

                    reader.Close();
                    con.Close();

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
            System.Diagnostics.Debug.WriteLine("Customer login error: " + ex.Message);
        }
    }

    private void AdminLogin()
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        // Validation
        if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
        {
            lblError.Text = "Please enter both username and password.";
            lblError.Visible = true;
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                // Use the same table as your existing admin login (Tbl_Login)
                string query = "SELECT COUNT(*) FROM Tbl_Login WHERE Username=@user AND Password=@pass";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@user", username);
                cmd.Parameters.AddWithValue("@pass", password);

                con.Open();
                int count = Convert.ToInt32(cmd.ExecuteScalar());

                if (count > 0)
                {
                    // Clear any existing session data
                    Session.Clear();

                    // Set admin session variables (matching your existing admin login)
                    Session["Authenticated"] = true;
                    Session["Username"] = username;
                    Session["LoginTime"] = DateTime.Now;
                    Session["LastActivity"] = DateTime.Now;

                    // Set session cookie parameters for better security
                    HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId", Session.SessionID);
                    sessionCookie.HttpOnly = true;
                    sessionCookie.Secure = Request.IsSecureConnection;
                    Response.Cookies.Add(sessionCookie);

                    con.Close();

                    // Redirect to admin dashboard (same as your existing admin login)
                    Response.Redirect("Default.aspx", false);
                }
                else
                {
                    lblError.Text = "Invalid username or password.";
                    lblError.Visible = true;
                }
            }
        }
        catch (Exception ex)
        {
            lblError.Text = "An error occurred during login. Please try again.";
            lblError.Visible = true;
            System.Diagnostics.Debug.WriteLine("Admin login error: " + ex.Message);
        }
    }

    private bool IsValidEmail(string email)
    {
        try
        {
            var addr = new System.Net.Mail.MailAddress(email);
            return addr.Address == email;
        }
        catch
        {
            return false;
        }
    }
}
