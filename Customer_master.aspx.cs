using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace Water_Man
{
    public partial class Customer_master : BasePage
    {
        string connectionString = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAreas();
                LoadCustomers();
            }
        }

        private void LoadAreas()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT Area_Id, Area_Name FROM Tbl_Areas WHERE IsActive = 1";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        ddlAreaFilter.DataSource = cmd.ExecuteReader();
                        ddlAreaFilter.DataTextField = "Area_Name";
                        ddlAreaFilter.DataValueField = "Area_Id";
                        ddlAreaFilter.DataBind();
                        ddlAreaFilter.Items.Insert(0, new ListItem("All Areas", ""));
                        con.Close();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorAlert("Error loading areas: " + ex.Message);
            }
        }

        private void LoadCustomers()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT c.Customer_Id, c.Name, c.Address, c.Mobile, c.Date, a.Area_Name, c.Area_Id, 0 AS IsEdit
                                    FROM Tbl_Customer c
                                    LEFT JOIN Tbl_Areas a ON c.Area_Id = a.Area_Id
                                    WHERE c.IsActive = 1";
                    if (ddlAreaFilter.SelectedValue != "")
                    {
                        query += " AND a.Area_Id = @AreaId";
                    }
                    SqlCommand cmd = new SqlCommand(query, con);
                    if (ddlAreaFilter.SelectedValue != "")
                    {
                        cmd.Parameters.AddWithValue("@AreaId", ddlAreaFilter.SelectedValue);
                    }
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count == 0)
                    {
                        ShowWarningAlert("No customers found for the selected criteria.");
                    }

                    rptCustomer.DataSource = dt;
                    rptCustomer.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowErrorAlert("Error loading customers: " + ex.Message);
            }
        }

        protected void ddlAreaFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadCustomers();
        }

        protected void rptCustomer_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int customerId = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "Edit")
                {
                    DataTable dt = GetCustomersTable();
                    foreach (DataRow row in dt.Rows)
                    {
                        row["IsEdit"] = (Convert.ToInt32(row["Customer_Id"]) == customerId) ? 1 : 0;
                    }
                    rptCustomer.DataSource = dt;
                    rptCustomer.DataBind();
                    ShowSuccessAlert("You are now editing customer #" + customerId + ". Make your changes and click Save.");
                }
                else if (e.CommandName == "Cancel")
                {
                    LoadCustomers();
                    ShowWarningAlert("Edit operation cancelled.");
                }
                else if (e.CommandName == "Update")
                {
                    RepeaterItem item = e.Item;
                    string name = ((TextBox)item.FindControl("txtName")).Text.Trim();
                    string address = ((TextBox)item.FindControl("txtAddress")).Text.Trim();
                    string mobile = ((TextBox)item.FindControl("txtMobile")).Text.Trim();
                    string date = ((TextBox)item.FindControl("txtDate")).Text.Trim();

                    // Get the dropdown and its value
                    DropDownList ddlArea = (DropDownList)item.FindControl("ddlArea");
                    string areaId = "";

                    if (ddlArea != null)
                    {
                        areaId = ddlArea.SelectedValue;
                    }

                    // Simple validation
                    if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(address) ||
                        string.IsNullOrEmpty(mobile) || string.IsNullOrEmpty(date))
                    {
                        ShowErrorAlert("Please fill all required fields.");
                        return;
                    }

                    // Only check if area dropdown exists and has a valid selection
                    if (ddlArea == null || ddlArea.SelectedIndex <= 0)
                    {
                        ShowErrorAlert("Please select an area.");
                        return;
                    }

                    // Mobile validation
                    if (mobile.Length != 10 || !System.Text.RegularExpressions.Regex.IsMatch(mobile, @"^\d{10}$"))
                    {
                        ShowErrorAlert("Mobile number must be 10 digits.");
                        return;
                    }

                    // Check if mobile number already exists (excluding current customer)
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Customer WHERE Mobile = @Mobile AND Customer_Id != @CustomerId AND IsActive = 1", con);
                        checkCmd.Parameters.AddWithValue("@Mobile", mobile);
                        checkCmd.Parameters.AddWithValue("@CustomerId", customerId);
                        con.Open();
                        int existingCount = (int)checkCmd.ExecuteScalar();
                        con.Close();

                        if (existingCount > 0)
                        {
                            ShowErrorAlert("A customer with this mobile number already exists.");
                            return;
                        }
                    }

                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = @"UPDATE Tbl_Customer SET Name = @Name, Address = @Address, Mobile = @Mobile, Date = @Date, Area_Id = @AreaId WHERE Customer_Id = @CustomerId";
                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Address", address);
                        cmd.Parameters.AddWithValue("@Mobile", mobile);
                        cmd.Parameters.AddWithValue("@Date", date);
                        cmd.Parameters.AddWithValue("@AreaId", areaId);
                        cmd.Parameters.AddWithValue("@CustomerId", customerId);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();
                        con.Close();

                        if (result > 0)
                        {
                            ShowSuccessAlert("Customer updated successfully!");
                        }
                        else
                        {
                            ShowErrorAlert("Failed to update customer. Please try again.");
                        }
                    }
                    LoadCustomers();
                }
                else if (e.CommandName == "Delete")
                {
                    // Perform soft delete
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        string query = "UPDATE Tbl_Customer SET IsActive = 0 WHERE Customer_Id = @CustomerId";
                        SqlCommand cmd = new SqlCommand(query, con);
                        cmd.Parameters.AddWithValue("@CustomerId", customerId);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();
                        con.Close();

                        if (result > 0)
                        {
                            ShowSuccessAlert("Customer deleted successfully!");
                            LoadCustomers(); // Refresh the data
                        }
                        else
                        {
                            ShowErrorAlert("Failed to delete customer. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorAlert("An error occurred: " + ex.Message);
            }
        }

        private DataTable GetCustomersTable()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT c.Customer_Id, c.Name, c.Address, c.Mobile, c.Date, a.Area_Name, c.Area_Id, 0 AS IsEdit
                                FROM Tbl_Customer c
                                LEFT JOIN Tbl_Areas a ON c.Area_Id = a.Area_Id
                                WHERE c.IsActive = 1";
                if (ddlAreaFilter.SelectedValue != "")
                {
                    query += " AND a.Area_Id = @AreaId";
                }
                SqlCommand cmd = new SqlCommand(query, con);
                if (ddlAreaFilter.SelectedValue != "")
                {
                    cmd.Parameters.AddWithValue("@AreaId", ddlAreaFilter.SelectedValue);
                }
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void rptCustomer_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                bool isEdit = Convert.ToBoolean(drv["IsEdit"]);

                // Set up delete button with proper client-side confirmation
                Button btnDelete = (Button)e.Item.FindControl("btnDelete");
                if (btnDelete != null && !isEdit)
                {
                    btnDelete.OnClientClick = "return confirmDeleteCustomer('" + btnDelete.UniqueID + "');";
                }

                // For edit mode, populate Area dropdown
                if (isEdit)
                {
                    DropDownList ddlArea = (DropDownList)e.Item.FindControl("ddlArea");
                    if (ddlArea != null)
                    {
                        try
                        {
                            // Clear any existing items
                            ddlArea.Items.Clear();

                            using (SqlConnection con = new SqlConnection(connectionString))
                            {
                                SqlCommand cmd = new SqlCommand("SELECT Area_Id, Area_Name FROM Tbl_Areas WHERE IsActive = 1 ORDER BY Area_Name", con);
                                con.Open();
                                SqlDataReader reader = cmd.ExecuteReader();

                                // Add default option first
                                ddlArea.Items.Add(new ListItem("-- Select Area --", ""));

                                while (reader.Read())
                                {
                                    ddlArea.Items.Add(new ListItem(reader["Area_Name"].ToString(), reader["Area_Id"].ToString()));
                                }
                                reader.Close();
                                con.Close();
                            }

                            // Set selected value to current area
                            string currentAreaId = drv["Area_Id"].ToString();
                            if (!string.IsNullOrEmpty(currentAreaId))
                            {
                                ListItem li = ddlArea.Items.FindByValue(currentAreaId);
                                if (li != null)
                                {
                                    ddlArea.SelectedValue = currentAreaId;
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            ShowErrorAlert("Error loading areas: " + ex.Message);
                        }
                    }
                }
            }
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
}