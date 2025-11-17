using System;
using System.Web;
using System.Web.UI;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Water_Man_Default2 : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadSettings();
            string lang = "en";
            HttpCookie langCookie = Request.Cookies["SiteLanguage"];
            if (langCookie != null && !string.IsNullOrEmpty(langCookie.Value))
            {
                lang = langCookie.Value;
            }

            try
            {
                ddlLanguage.SelectedValue = lang;
            }
            catch
            {
                ddlLanguage.SelectedIndex = 0;
            }
        }

    }

    private void LoadSettings()
    {
        try
        {
            HttpCookie langCookie = Request.Cookies["SiteLanguage"];
            if (langCookie != null && !string.IsNullOrEmpty(langCookie.Value))
            {
                ddlLanguage.SelectedValue = langCookie.Value;
            }

        }
        catch (Exception ex)
        {
            ShowErrorAlert("Error loading settings: " + ex.Message);
        }
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        try
        {
            string oldPassword = txtOldPassword.Text.Trim();
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();

            // Server-side validation
            if (string.IsNullOrEmpty(oldPassword))
            {
                ShowErrorAlert("Old password is required.");
                return;
            }

            if (string.IsNullOrEmpty(newPassword))
            {
                ShowErrorAlert("New password is required.");
                return;
            }

            if (newPassword.Length < 6)
            {
                ShowErrorAlert("New password must be at least 6 characters long.");
                return;
            }

            if (string.IsNullOrEmpty(confirmPassword))
            {
                ShowErrorAlert("Confirm password is required.");
                return;
            }

            if (newPassword != confirmPassword)
            {
                ShowErrorAlert("New password and confirm password do not match.");
                return;
            }

            if (oldPassword == newPassword)
            {
                ShowErrorAlert("New password must be different from old password.");
                return;
            }

            // Check if user is logged in
            if (Session["User_Id"] == null)
            {
                ShowErrorAlert("Session expired. Please login again.");
                Response.Redirect("Login.aspx");
                return;
            }

            string userId = Session["User_Id"].ToString();

            // Verify old password
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ToString()))
            {
                SqlCommand checkCmd = new SqlCommand("SELECT Password FROM Tbl_Login WHERE User_Id = @UserID", con);
                checkCmd.Parameters.AddWithValue("@UserID", userId);
                con.Open();
                object currentPassword = checkCmd.ExecuteScalar();
                con.Close();

                if (currentPassword == null)
                {
                    ShowErrorAlert("User not found.");
                    return;
                }

                // Note: In a real application, you should hash passwords
                // For now, assuming passwords are stored as plain text (not recommended)
                if (currentPassword.ToString() != oldPassword)
                {
                    ShowErrorAlert("Old password is incorrect.");
                    return;
                }
            }

            // Update password
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ToString()))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Tbl_Login SET Password = @Password WHERE User_Id = @UserID", con);
                cmd.Parameters.AddWithValue("@Password", newPassword); // In production, hash this password
                cmd.Parameters.AddWithValue("@UserID", userId);

                con.Open();
                int result = cmd.ExecuteNonQuery();
                con.Close();

                if (result > 0)
                {
                    ShowSuccessAlert("Password changed successfully!");
                    ClearPasswordFields();
                }
                else
                {
                    ShowErrorAlert("Failed to change password. Please try again.");
                }
            }
        }
        catch (Exception ex)
        {
            ShowErrorAlert("An error occurred while changing password: " + ex.Message);
        }
    }

    protected void ddlLanguage_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            string selectedLang = ddlLanguage.SelectedValue;

            // Update Session
            HttpCookie langCookie = new HttpCookie("SiteLanguage", selectedLang);
            langCookie.Expires = DateTime.Now.AddYears(1);
            Response.Cookies.Add(langCookie);

            // JS: Reset and re-trigger translation reliably
            string script = string.Format(@"
            setLanguageCookie('{0}');
            setTimeout(function() {{
                var combo = document.querySelector('.goog-te-combo');
                if (combo) {{
                    combo.value = '';
                    combo.dispatchEvent(new Event('change'));

                    setTimeout(function() {{
                        combo.value = '{0}';
                        combo.dispatchEvent(new Event('change'));
                    }}, 100);
                }}
            }}, 1000);", selectedLang);

            ClientScript.RegisterStartupScript(this.GetType(), "LangChange", script, true);

            ShowSuccessAlert("Language changed successfully!");
        }
        catch (Exception ex)
        {
            ShowErrorAlert("Error: " + ex.Message);
        }
        
    }

    private void ClearPasswordFields()
    {
        txtOldPassword.Text = "";
        txtNewPassword.Text = "";
        txtConfirmPassword.Text = "";
    }

    private void ShowSuccessAlert(string message)
    {
        string script = "showSuccessMessage('" + message.Replace("'", "\\'") + "');";
        ClientScript.RegisterStartupScript(this.GetType(), "SuccessAlert", script, true);
    }

    private void ShowErrorAlert(string message)
    {
        string script = "showErrorMessage('" + message.Replace("'", "\\'") + "');";
        ClientScript.RegisterStartupScript(this.GetType(), "ErrorAlert", script, true);
    }

    private void ShowWarningAlert(string message)
    {
        string script = "showWarningMessage('" + message.Replace("'", "\\'") + "');";
        ClientScript.RegisterStartupScript(this.GetType(), "WarningAlert", script, true);
    }
}
