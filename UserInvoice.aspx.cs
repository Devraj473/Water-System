using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class UserInvoice : BaseUserPage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            int cpId = 0;
            if (Request.QueryString["cpid"] != null)
            {
                int.TryParse(Request.QueryString["cpid"], out cpId);
            }

            if (cpId > 0)
            {
                LoadInvoiceData(cpId);
            }
            else
            {
                Response.Redirect("UserOrders.aspx");
            }
        }
    }

    private void LoadInvoiceData(int cpId)
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT 
                    CP.CP_Id, CP.Quantity, CP.Daily_Date,
                    C.Customer_Id, C.Name, C.Address, C.Mobile,
                    A.Area_Name,
                    P.Product_Name, P.Product_Rate,
                    ISNULL(T.Total_Amount, 0) AS Total_Amount,
                    ISNULL(T.Payment_Status, 'Unpaid') AS Payment_Status
                FROM Tbl_CustomerProduct CP
                INNER JOIN Tbl_Customer C ON CP.Customer_Id = C.Customer_Id
                LEFT JOIN Tbl_Areas A ON C.Area_Id = A.Area_Id
                INNER JOIN Tbl_Product P ON CP.Product_Id = P.Product_Id
                LEFT JOIN Tbl_Transaction T ON T.CP_Id = CP.CP_Id AND T.Month = CP.Daily_Date
                WHERE CP.CP_Id = @CpId AND CP.Customer_Id = @CustomerId";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CpId", cpId);
            cmd.Parameters.AddWithValue("@CustomerId", customerId);

            con.Open();
            SqlDataReader reader = cmd.ExecuteReader();

            if (reader.Read())
            {
                // Invoice Details
                lblInvoiceNumber.Text = reader["CP_Id"].ToString().PadLeft(6, '0');
                lblInvoiceDate.Text = DateTime.Now.ToString("dd MMM yyyy");
                lblOrderDate.Text = Convert.ToDateTime(reader["Daily_Date"]).ToString("dd MMM yyyy");

                // Customer Details
                lblCustomerName.Text = reader["Name"].ToString();
                lblCustomerAddress.Text = reader["Address"] != DBNull.Value ? reader["Address"].ToString() : "N/A";
                lblCustomerMobile.Text = reader["Mobile"].ToString();
                lblCustomerArea.Text = reader["Area_Name"] != DBNull.Value ? reader["Area_Name"].ToString() : "N/A";

                // Product Details
                lblProductName.Text = reader["Product_Name"].ToString();
                lblQuantity.Text = reader["Quantity"].ToString();
                
                decimal rate = reader["Product_Rate"] != DBNull.Value ? Convert.ToDecimal(reader["Product_Rate"]) : 0;
                lblRate.Text = rate.ToString("N2");

                decimal amount = reader["Total_Amount"] != DBNull.Value ? Convert.ToDecimal(reader["Total_Amount"]) : 0;
                lblAmount.Text = amount.ToString("N2");
                lblTotalAmount.Text = amount.ToString("N2");

                // Payment Status
                string status = reader["Payment_Status"].ToString();
                lblPaymentStatus.Text = status;
                
                // Set status CSS class
                string statusClass = "status-" + status.ToLower();
                if (statusClass == "status-paid")
                    lblPaymentStatus.CssClass = "status-paid";
                else if (statusClass == "status-pending")
                    lblPaymentStatus.CssClass = "status-pending";
                else
                    lblPaymentStatus.CssClass = "status-unpaid";

                // Additional fields for new design
                lblSubtotal.Text = amount.ToString("N2");
                lblItemStatus.Text = status;
                lblSalesmanName.Text = "Assigned"; // You can modify this to get actual salesman name
                lblGeneratedDate.Text = DateTime.Now.ToString("dd-MM-yyyy HH:mm:ss");
            }
            else
            {
                // Invalid invoice or unauthorized access
                Response.Redirect("UserOrders.aspx");
            }

            reader.Close();
        }
    }
}
