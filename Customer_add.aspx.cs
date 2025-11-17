using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Water_Man_Default2 : BasePage
{
    string connectionString = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadAreas();
        }
    }

    private void LoadAreas()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT Area_Id, Area_Name FROM Tbl_Areas WHERE IsActive=1", con);
                con.Open();
                ddlArea.DataSource = cmd.ExecuteReader();
                ddlArea.DataTextField = "Area_Name";
                ddlArea.DataValueField = "Area_Id";
                ddlArea.DataBind();
                ddlArea.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select Area", ""));
            }
        }
        catch (Exception ex)
        {
            ShowErrorAlert("Error loading areas: " + ex.Message);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string name = txtName.Text.Trim();
            string address = txtAddress1.Text.Trim();
            string mobile = txtMobile.Text.Trim();
            string joinDate = txtJoinDate.Text.Trim();
            string areaId = ddlArea.SelectedValue;

            // Server-side validation (backup)
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(address) ||
                string.IsNullOrEmpty(mobile) || string.IsNullOrEmpty(joinDate) ||
                string.IsNullOrEmpty(areaId))
            {
                ShowErrorAlert("Please fill all required fields.");
                return;
            }

            // Check if mobile number already exists
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Customer WHERE Mobile = @mobile AND IsActive = 1", con);
                checkCmd.Parameters.AddWithValue("@mobile", mobile);
                con.Open();
                int existingCount = (int)checkCmd.ExecuteScalar();
                con.Close();

                if (existingCount > 0)
                {
                    ShowErrorAlert("A customer with this mobile number already exists.");
                    return;
                }
            }

            // Insert new customer
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Tbl_Customer (Name, Address, Mobile, Date, Area_Id, IsActive) VALUES (@name, @address, @mobile, @joinDate, @areaId, 1)", con);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@address", address);
                cmd.Parameters.AddWithValue("@mobile", mobile);
                cmd.Parameters.AddWithValue("@joinDate", joinDate);
                cmd.Parameters.AddWithValue("@areaId", areaId);
                con.Open();
                int result = cmd.ExecuteNonQuery();
                con.Close();

                if (result > 0)
                {
                    ShowSuccessAlert("Customer added successfully!");
                    ClearForm();
                }
                else
                {
                    ShowErrorAlert("Failed to add customer. Please try again.");
                }
            }
        }
        catch (Exception ex)
        {
            ShowErrorAlert("An error occurred: " + ex.Message);
        }
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        ClearForm();
    }

    private void ClearForm()
    {
        txtName.Text = "";
        txtAddress1.Text = "";
        txtMobile.Text = "";
        txtJoinDate.Text = "";
        ddlArea.SelectedIndex = 0;
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
}
