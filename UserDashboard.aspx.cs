using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class UserDashboard : BaseUserPage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDashboardData();
            LoadRecentOrders();
        }
    }

    private void LoadDashboardData()
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // Total Orders
            SqlCommand cmdTotal = new SqlCommand(@"
                SELECT COUNT(*) FROM Tbl_CustomerProduct 
                WHERE Customer_Id = @CustomerId AND IsActive = 1", con);
            cmdTotal.Parameters.AddWithValue("@CustomerId", customerId);
            lblTotalOrders.Text = cmdTotal.ExecuteScalar().ToString();

            // Paid Orders
            SqlCommand cmdPaid = new SqlCommand(@"
                SELECT COUNT(*) FROM Tbl_Transaction T
                INNER JOIN Tbl_CustomerProduct CP ON T.CP_Id = CP.CP_Id
                WHERE CP.Customer_Id = @CustomerId AND T.Payment_Status = 'Paid'", con);
            cmdPaid.Parameters.AddWithValue("@CustomerId", customerId);
            object paidResult = cmdPaid.ExecuteScalar();
            lblPaidOrders.Text = paidResult != null ? paidResult.ToString() : "0";

            // Pending Payments
            SqlCommand cmdPending = new SqlCommand(@"
                SELECT COUNT(*) FROM Tbl_Transaction T
                INNER JOIN Tbl_CustomerProduct CP ON T.CP_Id = CP.CP_Id
                WHERE CP.Customer_Id = @CustomerId AND T.Payment_Status = 'Unpaid'", con);
            cmdPending.Parameters.AddWithValue("@CustomerId", customerId);
            object pendingResult = cmdPending.ExecuteScalar();
            lblPendingOrders.Text = pendingResult != null ? pendingResult.ToString() : "0";

            // Total Due Amount
            SqlCommand cmdDue = new SqlCommand(@"
                SELECT ISNULL(SUM(T.Total_Amount), 0) FROM Tbl_Transaction T
                INNER JOIN Tbl_CustomerProduct CP ON T.CP_Id = CP.CP_Id
                WHERE CP.Customer_Id = @CustomerId AND T.Payment_Status = 'Unpaid'", con);
            cmdDue.Parameters.AddWithValue("@CustomerId", customerId);
            object dueResult = cmdDue.ExecuteScalar();
            decimal totalDue = dueResult != null && dueResult != DBNull.Value ? Convert.ToDecimal(dueResult) : 0;
            lblTotalDue.Text = totalDue.ToString("N2");
        }
    }

    private void LoadRecentOrders()
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT TOP 10 
                    CP.CP_Id, CP.Quantity, CP.Daily_Date, 
                    P.Product_Name,
                    ISNULL(T.Total_Amount, 0) AS Total_Amount,
                    ISNULL(T.Payment_Status, 'Unpaid') AS Payment_Status
                FROM Tbl_CustomerProduct CP
                INNER JOIN Tbl_Product P ON CP.Product_Id = P.Product_Id
                LEFT JOIN Tbl_Transaction T ON T.CP_Id = CP.CP_Id AND T.Month = CP.Daily_Date
                WHERE CP.Customer_Id = @CustomerId AND CP.IsActive = 1
                ORDER BY CP.Daily_Date DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CustomerId", customerId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                rptRecentOrders.DataSource = dt;
                rptRecentOrders.DataBind();
                pnlNoOrders.Visible = false;
            }
            else
            {
                pnlNoOrders.Visible = true;
            }
        }
    }
}
