using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class Water_Man_Default2 : BasePage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            btnSave.Text = "ADD";
            LoadProducts();
        }
    }

    private void LoadProducts()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = "SELECT Product_Id, Product_Name, Product_Rate FROM Tbl_Product WHERE IsActive = 1 ORDER BY Product_Id DESC";
                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProducts.DataSource = dt;
                rptProducts.DataBind();
            }
        }
        catch (Exception ex)
        {
            ShowErrorAlert("Error loading products: " + ex.Message);
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string name = txtpName.Text.Trim();
            string rateText = txtRate.Text.Trim();
            decimal rate = 0;

            // Server-side validation
            if (string.IsNullOrEmpty(name))
            {
                ShowErrorAlert("Product name is required.");
                return;
            }

            if (string.IsNullOrEmpty(rateText) || !decimal.TryParse(rateText, out rate) || rate <= 0)
            {
                ShowErrorAlert("Please enter a valid product rate greater than 0.");
                return;
            }

            int productId = 0;
            int.TryParse(hfEditID.Value, out productId);

            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;

                if (productId == 0)
                {
                    // Check if product name already exists
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Product WHERE Product_Name = @Name AND IsActive = 1", con);
                    checkCmd.Parameters.AddWithValue("@Name", name);
                    con.Open();
                    int existingCount = (int)checkCmd.ExecuteScalar();
                    con.Close();

                    if (existingCount > 0)
                    {
                        ShowErrorAlert("A product with this name already exists.");
                        return;
                    }

                    // Insert new product
                    cmd.CommandText = "INSERT INTO Tbl_Product (Product_Name, Product_Rate, IsActive) VALUES (@Name, @Rate, 1)";
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Rate", rate);

                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    con.Close();

                    if (result > 0)
                    {
                        ShowSuccessAlert("Product added successfully!");
                        ClearForm();
                        LoadProducts();
                    }
                    else
                    {
                        ShowErrorAlert("Failed to add product. Please try again.");
                    }
                }
                else
                {
                    // Check if product name already exists (excluding current product)
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Tbl_Product WHERE Product_Name = @Name AND Product_Id != @Id AND IsActive = 1", con);
                    checkCmd.Parameters.AddWithValue("@Name", name);
                    checkCmd.Parameters.AddWithValue("@Id", productId);
                    con.Open();
                    int existingCount = (int)checkCmd.ExecuteScalar();
                    con.Close();

                    if (existingCount > 0)
                    {
                        ShowErrorAlert("A product with this name already exists.");
                        return;
                    }

                    // Update existing product
                    cmd.CommandText = "UPDATE Tbl_Product SET Product_Name = @Name, Product_Rate = @Rate WHERE Product_Id = @Id";
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Rate", rate);
                    cmd.Parameters.AddWithValue("@Id", productId);

                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    con.Close();

                    if (result > 0)
                    {
                        ShowSuccessAlert("Product updated successfully!");
                        ClearForm();
                        LoadProducts();
                    }
                    else
                    {
                        ShowErrorAlert("Failed to update product. Please try again.");
                    }
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
        ShowSuccessAlert("Form cleared successfully!");
    }

    private void ClearForm()
    {
        txtpName.Text = "";
        txtRate.Text = "";
        hfEditID.Value = "";
        btnSave.Text = "ADD";
    }

    protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Edit")
            {
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT Product_Name, Product_Rate FROM Tbl_Product WHERE Product_Id = @Id", con);
                    cmd.Parameters.AddWithValue("@Id", id);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        txtpName.Text = dr["Product_Name"].ToString();
                        txtRate.Text = dr["Product_Rate"].ToString();
                        hfEditID.Value = id.ToString();
                        btnSave.Text = "UPDATE";
                        ShowSuccessAlert("Product loaded for editing. Make your changes and click UPDATE.");
                    }
                    else
                    {
                        ShowErrorAlert("Product not found.");
                    }
                    con.Close();
                }
            }
            else if (e.CommandName == "Delete")
            {
                // Perform soft delete
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    SqlCommand cmd = new SqlCommand("UPDATE Tbl_Product SET IsActive = 0 WHERE Product_Id = @Id", con);
                    cmd.Parameters.AddWithValue("@Id", id);
                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    con.Close();

                    if (result > 0)
                    {
                        ShowSuccessAlert("Product deleted successfully!");
                        LoadProducts(); // Refresh the data
                    }
                    else
                    {
                        ShowErrorAlert("Failed to delete product. Please try again.");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            ShowErrorAlert("An error occurred: " + ex.Message);
        }
    }

    protected void rptProducts_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            // Set up delete button with proper client-side confirmation
            LinkButton lnkDelete = (LinkButton)e.Item.FindControl("lnkDelete");
            if (lnkDelete != null)
            {
                lnkDelete.OnClientClick = "return confirmDeleteProduct('" + lnkDelete.UniqueID + "');";
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