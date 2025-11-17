using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class UserPayments : BaseUserPage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadPaymentSummary();
            LoadPayments();
        }
    }

    private void LoadPaymentSummary()
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            // Total Transactions
            SqlCommand cmdTotal = new SqlCommand(@"
                SELECT COUNT(*) FROM Tbl_Transaction T
                INNER JOIN Tbl_CustomerProduct CP ON T.CP_Id = CP.CP_Id
                WHERE CP.Customer_Id = @CustomerId", con);
            cmdTotal.Parameters.AddWithValue("@CustomerId", customerId);
            object totalResult = cmdTotal.ExecuteScalar();
            lblTotalTransactions.Text = totalResult != null ? totalResult.ToString() : "0";

            // Total Paid
            SqlCommand cmdPaid = new SqlCommand(@"
                SELECT ISNULL(SUM(T.Total_Amount), 0) FROM Tbl_Transaction T
                INNER JOIN Tbl_CustomerProduct CP ON T.CP_Id = CP.CP_Id
                WHERE CP.Customer_Id = @CustomerId AND T.Payment_Status = 'Paid'", con);
            cmdPaid.Parameters.AddWithValue("@CustomerId", customerId);
            object paidResult = cmdPaid.ExecuteScalar();
            decimal totalPaid = paidResult != null && paidResult != DBNull.Value ? Convert.ToDecimal(paidResult) : 0;
            lblTotalPaid.Text = totalPaid.ToString("N2");

            // Total Unpaid
            SqlCommand cmdUnpaid = new SqlCommand(@"
                SELECT ISNULL(SUM(T.Total_Amount), 0) FROM Tbl_Transaction T
                INNER JOIN Tbl_CustomerProduct CP ON T.CP_Id = CP.CP_Id
                WHERE CP.Customer_Id = @CustomerId AND T.Payment_Status = 'Unpaid'", con);
            cmdUnpaid.Parameters.AddWithValue("@CustomerId", customerId);
            object unpaidResult = cmdUnpaid.ExecuteScalar();
            decimal totalUnpaid = unpaidResult != null && unpaidResult != DBNull.Value ? Convert.ToDecimal(unpaidResult) : 0;
            lblTotalUnpaid.Text = totalUnpaid.ToString("N2");
        }
    }

    private void LoadPayments()
    {
        int customerId = GetCurrentUserId();

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT 
                    CP.Daily_Date,
                    P.Product_Name,
                    CP.Quantity,
                    ISNULL(T.Total_Amount, 0) AS Total_Amount,
                    ISNULL(T.Payment_Status, 'Unpaid') AS Payment_Status,
                    T.Month AS Payment_Date
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
                rptPayments.DataSource = dt;
                rptPayments.DataBind();
                pnlNoData.Visible = false;
            }
            else
            {
                rptPayments.DataSource = null;
                rptPayments.DataBind();
                pnlNoData.Visible = true;
            }
        }
    }
}
