using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class UserRequest : BaseUserPage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProducts();
            LoadMyRequests();
            txtStartDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
        }
    }

    private void LoadProducts()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = "SELECT Product_Id, Product_Name FROM Tbl_Product WHERE IsActive = 1 ORDER BY Product_Name";
            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            ddlProduct.DataSource = dt;
            ddlProduct.DataTextField = "Product_Name";
            ddlProduct.DataValueField = "Product_Id";
            ddlProduct.DataBind();
            ddlProduct.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Product --", ""));
        }
    }

    private void LoadMyRequests()
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            // Check if Tbl_ProductRequest table exists, if not we'll create it
            string checkTableQuery = @"
                IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tbl_ProductRequest]') AND type in (N'U'))
                BEGIN
                    CREATE TABLE [dbo].[Tbl_ProductRequest](
                        [Request_Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
                        [Customer_Id] [int] NOT NULL,
                        [Product_Id] [int] NOT NULL,
                        [Quantity] [int] NOT NULL,
                        [Start_Date] [date] NULL,
                        [Notes] [nvarchar](500) NULL,
                        [Request_Date] [datetime] NOT NULL DEFAULT GETDATE(),
                        [Status] [nvarchar](50) NOT NULL DEFAULT 'Pending',
                        [IsActive] [bit] NOT NULL DEFAULT 1
                    )
                END";

            SqlCommand cmdCheck = new SqlCommand(checkTableQuery, con);
            con.Open();
            cmdCheck.ExecuteNonQuery();
            con.Close();

            // Load requests
            string query = @"
                SELECT TOP 10 
                    PR.Request_Id, PR.Quantity, PR.Start_Date, PR.Notes, PR.Request_Date, PR.Status,
                    P.Product_Name
                FROM Tbl_ProductRequest PR
                INNER JOIN Tbl_Product P ON PR.Product_Id = P.Product_Id
                WHERE PR.Customer_Id = @CustomerId AND PR.IsActive = 1
                ORDER BY PR.Request_Date DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CustomerId", customerId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                rptRequests.DataSource = dt;
                rptRequests.DataBind();
                pnlNoRequests.Visible = false;
            }
            else
            {
                pnlNoRequests.Visible = true;
            }
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        // Validation
        if (string.IsNullOrEmpty(ddlProduct.SelectedValue))
        {
            lblError.Text = "Please select a product.";
            lblError.Visible = true;
            lblSuccess.Visible = false;
            return;
        }

        if (string.IsNullOrEmpty(txtQuantity.Text) || Convert.ToInt32(txtQuantity.Text) <= 0)
        {
            lblError.Text = "Please enter a valid quantity.";
            lblError.Visible = true;
            lblSuccess.Visible = false;
            return;
        }

        if (string.IsNullOrEmpty(txtStartDate.Text))
        {
            lblError.Text = "Please select a start date.";
            lblError.Visible = true;
            lblSuccess.Visible = false;
            return;
        }

        try
        {
            int customerId = GetCurrentUserId();
            int productId = Convert.ToInt32(ddlProduct.SelectedValue);
            int quantity = Convert.ToInt32(txtQuantity.Text);
            DateTime startDate = Convert.ToDateTime(txtStartDate.Text);
            string notes = txtNotes.Text.Trim();

            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
                    INSERT INTO Tbl_ProductRequest (Customer_Id, Product_Id, Quantity, Start_Date, Notes, Request_Date, Status, IsActive)
                    VALUES (@CustomerId, @ProductId, @Quantity, @StartDate, @Notes, GETDATE(), 'Pending', 1)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CustomerId", customerId);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.Parameters.AddWithValue("@Quantity", quantity);
                cmd.Parameters.AddWithValue("@StartDate", startDate);
                cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(notes) ? (object)DBNull.Value : notes);

                con.Open();
                int result = cmd.ExecuteNonQuery();

                if (result > 0)
                {
                    lblSuccess.Text = "Request submitted successfully! We'll contact you soon.";
                    lblSuccess.Visible = true;
                    lblError.Visible = false;

                    // Clear form
                    ddlProduct.SelectedIndex = 0;
                    txtQuantity.Text = "";
                    txtStartDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
                    txtNotes.Text = "";

                    // Reload requests
                    LoadMyRequests();
                }
                else
                {
                    lblError.Text = "Failed to submit request. Please try again.";
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
            System.Diagnostics.Debug.WriteLine("Request submission error: " + ex.Message);
        }
    }
}
