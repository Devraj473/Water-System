using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class UserOrders : BaseUserPage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.AddMonths(-1).ToString("yyyy-MM-dd");
            txtToDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
            LoadOrders();
        }
    }

    private void LoadOrders()
    {
        int customerId = GetCurrentUserId();
        DateTime fromDate = DateTime.Parse(txtFromDate.Text);
        DateTime toDate = DateTime.Parse(txtToDate.Text);
        string status = ddlStatus.SelectedValue;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT 
                    CP.CP_Id, CP.Quantity, CP.Daily_Date, 
                    P.Product_Name,
                    ISNULL(T.Total_Amount, 0) AS Total_Amount,
                    ISNULL(T.Payment_Status, 'Unpaid') AS Payment_Status
                FROM Tbl_CustomerProduct CP
                INNER JOIN Tbl_Product P ON CP.Product_Id = P.Product_Id
                LEFT JOIN Tbl_Transaction T ON T.CP_Id = CP.CP_Id AND T.Month = CP.Daily_Date
                WHERE CP.Customer_Id = @CustomerId 
                    AND CP.IsActive = 1
                    AND CP.Daily_Date BETWEEN @FromDate AND @ToDate";

            if (!string.IsNullOrEmpty(status))
            {
                query += " AND T.Payment_Status = @Status";
            }

            query += " ORDER BY CP.Daily_Date DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CustomerId", customerId);
            cmd.Parameters.AddWithValue("@FromDate", fromDate);
            cmd.Parameters.AddWithValue("@ToDate", toDate);
            
            if (!string.IsNullOrEmpty(status))
            {
                cmd.Parameters.AddWithValue("@Status", status);
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                rptOrders.DataSource = dt;
                rptOrders.DataBind();
                pnlNoData.Visible = false;
            }
            else
            {
                rptOrders.DataSource = null;
                rptOrders.DataBind();
                pnlNoData.Visible = true;
            }
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        LoadOrders();
    }

    protected void btnDownload_Command(object sender, CommandEventArgs e)
    {
        int cpId = Convert.ToInt32(e.CommandArgument);
        // Redirect to invoice download page
        Response.Redirect("UserInvoice.aspx?cpid=" + cpId);
    }
}
