using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Water_Man_Default2 : BasePage
{
    string connectionString = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Page load logic if needed
    }

    protected void btnSave_Click1(object sender, EventArgs e)
    {
        try
        {
            string areaName = txtAreaName.Text.Trim();
            string salesmanName = txtsalesmanName.Text.Trim();

            // Server-side validation
            if (string.IsNullOrEmpty(areaName))
            {
                ShowErrorAlert("Area name is required.");
                return;
            }

            if (string.IsNullOrEmpty(salesmanName))
            {
                ShowErrorAlert("Salesman name is required.");
                return;
            }

            // Check if area name already exists
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Areas WHERE Area_Name = @AreaName AND IsActive = 1", con);
                checkCmd.Parameters.AddWithValue("@AreaName", areaName);
                con.Open();
                int existingCount = (int)checkCmd.ExecuteScalar();
                con.Close();

                if (existingCount > 0)
                {
                    ShowErrorAlert("An area with this name already exists.");
                    return;
                }
            }

            // First, add or get salesman
            int salesmanId = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                // Check if salesman already exists
                SqlCommand checkSalesmanCmd = new SqlCommand("SELECT Salesman_Id FROM Tbl_Salesman WHERE Salesman_Name = @SalesmanName", con);
                checkSalesmanCmd.Parameters.AddWithValue("@SalesmanName", salesmanName);
                con.Open();
                object result = checkSalesmanCmd.ExecuteScalar();

                if (result != null)
                {
                    salesmanId = Convert.ToInt32(result);
                }
                else
                {
                    // Add new salesman
                    SqlCommand addSalesmanCmd = new SqlCommand("INSERT INTO Tbl_Salesman (Salesman_Name) VALUES (@SalesmanName); SELECT SCOPE_IDENTITY();", con);
                    addSalesmanCmd.Parameters.AddWithValue("@SalesmanName", salesmanName);
                    salesmanId = Convert.ToInt32(addSalesmanCmd.ExecuteScalar());
                }
                con.Close();
            }

            // Add new area
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Tbl_Areas (Area_Name, Salesman_Id, IsActive) VALUES (@AreaName, @SalesmanId, 1)", con);
                cmd.Parameters.AddWithValue("@AreaName", areaName);
                cmd.Parameters.AddWithValue("@SalesmanId", salesmanId);

                con.Open();
                int rowsAffected = cmd.ExecuteNonQuery();
                con.Close();

                if (rowsAffected > 0)
                {
                    ShowSuccessAlert("Area added successfully!");
                    ClearForm();
                }
                else
                {
                    ShowErrorAlert("Failed to add area. Please try again.");
                }
            }
        }
        catch (Exception ex)
        {
            ShowErrorAlert("An error occurred: " + ex.Message);
        }
    }

    protected void btnClear_Click1(object sender, EventArgs e)
    {
        ClearForm();
        ShowSuccessAlert("Form cleared successfully!");
    }

    private void ClearForm()
    {
        txtAreaName.Text = "";
        txtsalesmanName.Text = "";
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
