using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class UserProfile : BaseUserPage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProfile();
        }
    }

    private void LoadProfile()
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT C.Customer_Id, C.Name, C.Mobile, C.Address, C.Area_Id, A.Area_Name
                FROM Tbl_Customer C
                LEFT JOIN Tbl_Areas A ON C.Area_Id = A.Area_Id
                WHERE C.Customer_Id = @CustomerId";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CustomerId", customerId);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                txtCustomerId.Text = reader["Customer_Id"].ToString();
                txtName.Text = reader["Name"].ToString();
                txtMobile.Text = reader["Mobile"].ToString();
                txtAddress.Text = reader["Address"] != DBNull.Value ? reader["Address"].ToString() : "";
                txtArea.Text = reader["Area_Name"] != DBNull.Value ? reader["Area_Name"].ToString() : "Not Assigned";
            }

            reader.Close();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int customerId = GetCurrentUserId();
        string name = txtName.Text.Trim();
        string address = txtAddress.Text.Trim();

        // Validation
        if (string.IsNullOrEmpty(name))
        {
            lblError.Text = "Name is required.";
            lblError.Visible = true;
            lblSuccess.Visible = false;
            return;
        }

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
                    UPDATE Tbl_Customer 
                    SET Name = @Name, Address = @Address
                    WHERE Customer_Id = @CustomerId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@CustomerId", customerId);

                con.Open();
                int result = cmd.ExecuteNonQuery();

                if (result > 0)
                {
                    // Update session
                    Session["UserName"] = name;
                    Session["UserAddress"] = address;

                    lblSuccess.Text = "Profile updated successfully!";
                    lblSuccess.Visible = true;
                    lblError.Visible = false;
                }
                else
                {
                    lblError.Text = "Failed to update profile. Please try again.";
                    lblError.Visible = true;
                    lblSuccess.Visible = false;
                }
            }
        }
        catch (Exception ex)
        {
            lblError.Text = "An error occurred: " + ex.Message;
            lblError.Visible = true;
            lblSuccess.Visible = false;
            System.Diagnostics.Debug.WriteLine("Profile update error: " + ex.Message);
        }
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        lblSuccess.Visible = false;
        lblError.Visible = false;

        string oldPassword = txtOldPassword.Text.Trim();
        string newPassword = txtNewPassword.Text.Trim();
        string confirmPassword = txtConfirmPassword.Text.Trim();

        if (string.IsNullOrEmpty(oldPassword) || string.IsNullOrEmpty(newPassword) || string.IsNullOrEmpty(confirmPassword))
        {
            lblError.Text = "All password fields are required.";
            lblError.Visible = true;
            return;
        }

        if (newPassword.Length < 6)
        {
            lblError.Text = "New password must be at least 6 characters.";
            lblError.Visible = true;
            return;
        }

        if (newPassword != confirmPassword)
        {
            lblError.Text = "New password and confirmation do not match.";
            lblError.Visible = true;
            return;
        }

        int customerId = GetCurrentUserId();

        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string selectQuery = "SELECT Password FROM Tbl_Customer WHERE Customer_Id = @CustomerId";
                SqlCommand selectCmd = new SqlCommand(selectQuery, con);
                selectCmd.Parameters.AddWithValue("@CustomerId", customerId);

                con.Open();
                object currentPasswordObj = selectCmd.ExecuteScalar();

                if (currentPasswordObj == null)
                {
                    lblError.Text = "Customer not found.";
                    lblError.Visible = true;
                    return;
                }

                string currentPassword = currentPasswordObj.ToString();

                if (!string.Equals(currentPassword, oldPassword))
                {
                    lblError.Text = "Old password is incorrect.";
                    lblError.Visible = true;
                    return;
                }

                string updateQuery = "UPDATE Tbl_Customer SET Password = @Password WHERE Customer_Id = @CustomerId";
                SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                updateCmd.Parameters.AddWithValue("@Password", newPassword);
                updateCmd.Parameters.AddWithValue("@CustomerId", customerId);

                int rows = updateCmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    lblSuccess.Text = "Password updated successfully!";
                    lblSuccess.Visible = true;
                    txtOldPassword.Text = string.Empty;
                    txtNewPassword.Text = string.Empty;
                    txtConfirmPassword.Text = string.Empty;
                }
                else
                {
                    lblError.Text = "Failed to update password. Please try again.";
                    lblError.Visible = true;
                }
            }
        }
        catch (Exception ex)
        {
            lblError.Text = "An error occurred: " + ex.Message;
            lblError.Visible = true;
            System.Diagnostics.Debug.WriteLine("Password change error: " + ex.Message);
        }
    }
}
