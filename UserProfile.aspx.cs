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
                
                // Load email from session
                txtEmail.Text = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "";
            }

            reader.Close();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int customerId = GetCurrentUserId();
        string name = txtName.Text.Trim();
        string email = txtEmail.Text.Trim();
        string address = txtAddress.Text.Trim();

        // Validation
        if (string.IsNullOrEmpty(name))
        {
            lblError.Text = "Name is required.";
            lblError.Visible = true;
            lblSuccess.Visible = false;
            return;
        }

        if (string.IsNullOrEmpty(email))
        {
            lblError.Text = "Email is required.";
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
                    Session["UserEmail"] = email;
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
}
