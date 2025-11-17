using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace Water_Man
{
    public partial class Area_Master : BasePage
    {
        string connectionString = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAreaFilter();
                LoadAreas();
            }
        }

        private void LoadAreaFilter()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "SELECT Area_Id, Area_Name FROM Tbl_Areas WHERE IsActive=1";
                    SqlCommand cmd = new SqlCommand(query, con);
                    con.Open();
                    ddlAreaFilter.DataSource = cmd.ExecuteReader();
                    ddlAreaFilter.DataTextField = "Area_Name";
                    ddlAreaFilter.DataValueField = "Area_Id";
                    ddlAreaFilter.DataBind();
                }
                ddlAreaFilter.Items.Insert(0, new ListItem("-- All Areas --", ""));
            }
            catch (Exception ex)
            {
                ShowErrorAlert("Error loading area filter: " + ex.Message);
            }
        }

        protected void ddlAreaFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAreas();
        }

        private void LoadAreas()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = @"SELECT a.Area_Id, a.Area_Name, ISNULL(s.Salesman_Name, '') AS Salesman_Name, ISNULL(a.Salesman_Id, 0) AS Salesman_Id, 0 AS IsEdit
                                     FROM Tbl_Areas a
                                     LEFT JOIN Tbl_Salesman s ON a.Salesman_Id = s.Salesman_Id
                                     WHERE a.IsActive = 1";
                    if (!string.IsNullOrEmpty(ddlAreaFilter.SelectedValue))
                    {
                        query += " AND a.Area_Id = @AreaId";
                    }

                    SqlCommand cmd = new SqlCommand(query, con);
                    if (!string.IsNullOrEmpty(ddlAreaFilter.SelectedValue))
                    {
                        cmd.Parameters.AddWithValue("@AreaId", ddlAreaFilter.SelectedValue);
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count == 0)
                    {
                        ShowWarningAlert("No areas found for the selected criteria.");
                    }

                    rptAreas.DataSource = dt;
                    rptAreas.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowErrorAlert("Error loading areas: " + ex.Message);
            }
        }

        private DataTable GetAreasTable()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = @"SELECT a.Area_Id, a.Area_Name, ISNULL(s.Salesman_Name, '') AS Salesman_Name, ISNULL(a.Salesman_Id, 0) AS Salesman_Id, 0 AS IsEdit
                                 FROM Tbl_Areas a
                                 LEFT JOIN Tbl_Salesman s ON a.Salesman_Id = s.Salesman_Id
                                 WHERE a.IsActive = 1";
                if (!string.IsNullOrEmpty(ddlAreaFilter.SelectedValue))
                {
                    query += " AND a.Area_Id = @AreaId";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                if (!string.IsNullOrEmpty(ddlAreaFilter.SelectedValue))
                {
                    cmd.Parameters.AddWithValue("@AreaId", ddlAreaFilter.SelectedValue);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void rptAreas_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            try
            {
                int areaId = Convert.ToInt32(e.CommandArgument);

                if (e.CommandName == "Edit")
                {
                    DataTable dt = GetAreasTable();
                    foreach (DataRow row in dt.Rows)
                    {
                        row["IsEdit"] = (Convert.ToInt32(row["Area_Id"]) == areaId) ? 1 : 0;
                    }
                    rptAreas.DataSource = dt;
                    rptAreas.DataBind();
                    ShowSuccessAlert("You are now editing area #" + areaId + ". Make your changes and click Save.");
                }
                else if (e.CommandName == "Cancel")
                {
                    LoadAreas();
                    ShowWarningAlert("Edit operation cancelled.");
                }
                else if (e.CommandName == "Update")
                {
                    RepeaterItem item = e.Item;
                    string areaName = ((TextBox)item.FindControl("txtAreaName")).Text.Trim();

                    // Get the dropdown and its value
                    DropDownList ddlSalesman = (DropDownList)item.FindControl("ddlSalesman");
                    string salesmanId = "";

                    if (ddlSalesman != null)
                    {
                        salesmanId = ddlSalesman.SelectedValue;
                    }

                    // Server-side validation
                    if (string.IsNullOrEmpty(areaName))
                    {
                        ShowErrorAlert("Area name is required.");
                        return;
                    }

                    // Only check if salesman dropdown exists and has a valid selection (allow empty salesman)
                    if (ddlSalesman == null)
                    {
                        ShowErrorAlert("Salesman dropdown not found. Please refresh the page and try again.");
                        return;
                    }

                    // Check if area name already exists (excluding current area)
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Areas WHERE Area_Name = @AreaName AND Area_Id != @AreaId AND IsActive = 1", con);
                        checkCmd.Parameters.AddWithValue("@AreaName", areaName);
                        checkCmd.Parameters.AddWithValue("@AreaId", areaId);
                        con.Open();
                        int existingCount = (int)checkCmd.ExecuteScalar();
                        con.Close();

                        if (existingCount > 0)
                        {
                            ShowErrorAlert("An area with this name already exists.");
                            return;
                        }
                    }

                    // Handle empty salesman selection (set to NULL)
                    object salesmanIdParam = string.IsNullOrEmpty(salesmanId) ? (object)DBNull.Value : salesmanId;

                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Tbl_Areas SET Area_Name = @AreaName, Salesman_Id = @SalesmanId WHERE Area_Id = @AreaId", con);
                        cmd.Parameters.AddWithValue("@AreaName", areaName);
                        cmd.Parameters.AddWithValue("@SalesmanId", salesmanIdParam);
                        cmd.Parameters.AddWithValue("@AreaId", areaId);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();
                        con.Close();

                        if (result > 0)
                        {
                            ShowSuccessAlert("Area updated successfully!");
                        }
                        else
                        {
                            ShowErrorAlert("Failed to update area. Please try again.");
                        }
                    }

                    LoadAreas();
                }
                else if (e.CommandName == "Delete")
                {
                    // Check if area has customers
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Customer WHERE Area_Id = @AreaId AND IsActive = 1", con);
                        checkCmd.Parameters.AddWithValue("@AreaId", areaId);
                        con.Open();
                        int customerCount = (int)checkCmd.ExecuteScalar();
                        con.Close();

                        if (customerCount > 0)
                        {
                            ShowErrorAlert("Cannot delete this area because it has " + customerCount + " active customers.");
                            return;
                        }
                    }

                    // Perform soft delete
                    using (SqlConnection con = new SqlConnection(connectionString))
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Tbl_Areas SET IsActive = 0 WHERE Area_Id = @AreaId", con);
                        cmd.Parameters.AddWithValue("@AreaId", areaId);
                        con.Open();
                        int result = cmd.ExecuteNonQuery();
                        con.Close();

                        if (result > 0)
                        {
                            ShowSuccessAlert("Area deleted successfully!");
                            LoadAreaFilter(); // Refresh the filter dropdown
                            LoadAreas(); // Refresh the main data
                        }
                        else
                        {
                            ShowErrorAlert("Failed to delete area. Please try again.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowErrorAlert("An error occurred: " + ex.Message);
            }
        }

        protected void rptAreas_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                bool isEdit = Convert.ToBoolean(drv["IsEdit"]);

                // Set up delete button with proper client-side confirmation
                Button btnDelete = (Button)e.Item.FindControl("btnDelete");
                if (btnDelete != null && !isEdit)
                {
                    btnDelete.OnClientClick = "return confirmDelete('" + btnDelete.UniqueID + "');";
                }

                if (isEdit)
                {
                    // Set TextBox Area Name
                    TextBox txtAreaName = (TextBox)e.Item.FindControl("txtAreaName");
                    if (txtAreaName != null)
                    {
                        txtAreaName.Text = drv["Area_Name"].ToString();
                    }

                    // Bind Salesman Dropdown
                    DropDownList ddlSalesman = (DropDownList)e.Item.FindControl("ddlSalesman");
                    if (ddlSalesman != null)
                    {
                        try
                        {
                            // Clear any existing items
                            ddlSalesman.Items.Clear();

                            using (SqlConnection con = new SqlConnection(connectionString))
                            {
                                SqlCommand cmd = new SqlCommand("SELECT Salesman_Id, Salesman_Name FROM Tbl_Salesman WHERE IsActive = 1 ORDER BY Salesman_Name", con);
                                con.Open();
                                SqlDataReader reader = cmd.ExecuteReader();

                                // Add default option first
                                ddlSalesman.Items.Add(new ListItem("-- Select Salesman --", ""));

                                while (reader.Read())
                                {
                                    ddlSalesman.Items.Add(new ListItem(reader["Salesman_Name"].ToString(), reader["Salesman_Id"].ToString()));
                                }
                                reader.Close();
                                con.Close();
                            }

                            // Set selected value to current salesman
                            string currentSalesmanId = drv["Salesman_Id"].ToString();
                            if (!string.IsNullOrEmpty(currentSalesmanId) && currentSalesmanId != "0")
                            {
                                ListItem li = ddlSalesman.Items.FindByValue(currentSalesmanId);
                                if (li != null)
                                {
                                    ddlSalesman.SelectedValue = currentSalesmanId;
                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            ShowErrorAlert("Error loading salesmen: " + ex.Message);
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