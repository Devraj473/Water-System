using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Collections.Generic;
using System.Web;

public partial class Water_Man_Default : BasePage
{
    protected string chartLabels = "";
    protected string chartPaidData = "";
    protected string chartUnpaidData = "";
    protected string chartEarningsData = "";
    protected string chartUnpaidAmountData = "";
    protected string chartUnpaidAmountAllTimeData = "";
    protected string allProductsEarningsLabel = "\u20B90.00";
    protected string allProductsUnpaidLabel = "\u20B90.00";
    protected string allProductsUnpaidAllTimeLabel = "\u20B90.00";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //lblWelcome.Text = "Welcome!";
            //lblOverview.Text = "Overview of your water system business.";
           lblTotalCustomersTitle.Text = "Total Customers";
            lblProductManagementTitle.Text = "Product Management";

            BindSummaryCards();
            PrepareProductChartData();
            RegisterChartScript();
        }
    }

    private void BindSummaryCards()
    {
        string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();

            SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM Tbl_Customer WHERE IsActive = 1", con);
            lblTotalCustomers.Text = cmd1.ExecuteScalar().ToString();

            // Only count active products
            SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM Tbl_Product WHERE IsActive = 1", con);
            lblTotalProducts.Text = cmd3.ExecuteScalar().ToString();

            // Count product requests from customers
            SqlCommand cmd4 = new SqlCommand("SELECT COUNT(*) FROM Tbl_ProductRequest WHERE Status = 'Pending'", con);
            object requestCount = cmd4.ExecuteScalar();
            lblTotalProductRequests.Text = requestCount != null ? requestCount.ToString() : "0";
        }
    }


    private void PrepareProductChartData()
    {
        string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;
        DataTable dt = new DataTable();
        decimal totalEarnings = 0;
        decimal totalUnpaid = 0;
        decimal totalUnpaidAllTime = 0;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            con.Open();
            // Product-wise Paid/Unpaid/Earnings/UnpaidAllTime
            SqlCommand cmd = new SqlCommand(@"
                SELECT 
                    P.Product_Name,
                    SUM(CASE WHEN T.Payment_Status = 'Paid' THEN CP.Quantity ELSE 0 END) AS Paid,
                    SUM(CASE WHEN T.Payment_Status = 'Unpaid' AND T.Month >= DATEADD(day, -30, GETDATE()) THEN CP.Quantity ELSE 0 END) AS Unpaid,
                    SUM(CASE WHEN T.Payment_Status = 'Paid' AND T.Month >= DATEADD(day, -30, GETDATE()) THEN T.Total_Amount ELSE 0 END) AS Earnings,
                    SUM(CASE WHEN T.Payment_Status = 'Unpaid' AND T.Month >= DATEADD(day, -30, GETDATE()) THEN T.Total_Amount ELSE 0 END) AS UnpaidAmount,
                    SUM(CASE WHEN T.Payment_Status = 'Unpaid' THEN T.Total_Amount ELSE 0 END) AS UnpaidAmountAllTime
                FROM Tbl_Product P
                LEFT JOIN Tbl_CustomerProduct CP ON CP.Product_Id = P.Product_Id AND CP.IsActive = 1
                LEFT JOIN Tbl_Transaction T ON T.CP_Id = CP.CP_Id
                WHERE P.IsActive = 1
                GROUP BY P.Product_Name
                ORDER BY P.Product_Name
            ", con);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);

            // All products combined earnings (last 30 days) - Paid transactions
            SqlCommand cmdTotal = new SqlCommand(@"
                SELECT ISNULL(SUM(Total_Amount), 0) FROM Tbl_Transaction
                WHERE Payment_Status='Paid' 
                AND Month >= DATEADD(day, -30, GETDATE())
                AND CP_Id IN (SELECT CP_Id FROM Tbl_CustomerProduct WHERE IsActive = 1)
            ", con);
            object totalObj = cmdTotal.ExecuteScalar();
            if (totalObj != null && totalObj != DBNull.Value)
                totalEarnings = Convert.ToDecimal(totalObj);

            // All products combined unpaid (last 30 days)
            SqlCommand cmdUnpaid = new SqlCommand(@"
                SELECT ISNULL(SUM(Total_Amount), 0) FROM Tbl_Transaction
                WHERE Payment_Status='Unpaid' 
                AND Month >= DATEADD(day, -30, GETDATE())
                AND CP_Id IN (SELECT CP_Id FROM Tbl_CustomerProduct WHERE IsActive = 1)
            ", con);
            object unpaidObj = cmdUnpaid.ExecuteScalar();
            if (unpaidObj != null && unpaidObj != DBNull.Value)
                totalUnpaid = Convert.ToDecimal(unpaidObj);

            // All products combined unpaid (all time)
            SqlCommand cmdUnpaidAllTime = new SqlCommand(@"
                SELECT ISNULL(SUM(Total_Amount), 0) FROM Tbl_Transaction
                WHERE Payment_Status='Unpaid'
                AND CP_Id IN (SELECT CP_Id FROM Tbl_CustomerProduct WHERE IsActive = 1)
            ", con);
            object unpaidAllTimeObj = cmdUnpaidAllTime.ExecuteScalar();
            if (unpaidAllTimeObj != null && unpaidAllTimeObj != DBNull.Value)
                totalUnpaidAllTime = Convert.ToDecimal(unpaidAllTimeObj);
        }

        List<string> labels = new List<string>();
        List<string> paidList = new List<string>();
        List<string> unpaidList = new List<string>();
        List<string> earningsList = new List<string>();
        List<string> unpaidAmountList = new List<string>();
        List<string> unpaidAmountAllTimeList = new List<string>();

        foreach (DataRow row in dt.Rows)
        {
            labels.Add("\"" + row["Product_Name"].ToString() + "\"");
            paidList.Add(row["Paid"] != DBNull.Value ? row["Paid"].ToString() : "0");
            unpaidList.Add(row["Unpaid"] != DBNull.Value ? row["Unpaid"].ToString() : "0");
            earningsList.Add(row["Earnings"] != DBNull.Value ? Convert.ToDecimal(row["Earnings"]).ToString("F2") : "0.00");
            unpaidAmountList.Add(row["UnpaidAmount"] != DBNull.Value ? Convert.ToDecimal(row["UnpaidAmount"]).ToString("F2") : "0.00");
            unpaidAmountAllTimeList.Add(row["UnpaidAmountAllTime"] != DBNull.Value ? Convert.ToDecimal(row["UnpaidAmountAllTime"]).ToString("F2") : "0.00");
        }

        chartLabels = string.Join(", ", labels);
        chartPaidData = string.Join(", ", paidList);
        chartUnpaidData = string.Join(", ", unpaidList);
        chartEarningsData = string.Join(", ", earningsList);
        chartUnpaidAmountData = string.Join(", ", unpaidAmountList);
        chartUnpaidAmountAllTimeData = string.Join(", ", unpaidAmountAllTimeList);

        allProductsEarningsLabel = "\u20B9" + totalEarnings.ToString("N2");
        allProductsUnpaidLabel = "\u20B9" + totalUnpaid.ToString("N2");
        allProductsUnpaidAllTimeLabel = "\u20B9" + totalUnpaidAllTime.ToString("N2");
    }

    private void RegisterChartScript()
    {
        // Output earnings and unpaid as tooltip labels
        string earningsLabels = "[";
        string[] earningsArray = chartEarningsData.Split(',');
        foreach (var earning in earningsArray)
            earningsLabels += "\"\u20B9" + earning.Trim() + "\",";
        earningsLabels = earningsLabels.TrimEnd(',') + "]";

        string unpaidLabels = "[";
        string[] unpaidArray = chartUnpaidAmountData.Split(',');
        foreach (var unpaid in unpaidArray)
            unpaidLabels += "\"\u20B9" + unpaid.Trim() + "\",";
        unpaidLabels = unpaidLabels.TrimEnd(',') + "]";

        string unpaidAllTimeLabels = "[";
        string[] unpaidAllTimeArray = chartUnpaidAmountAllTimeData.Split(',');
        foreach (var unpaidAll in unpaidAllTimeArray)
            unpaidAllTimeLabels += "\"\u20B9" + unpaidAll.Trim() + "\",";
        unpaidAllTimeLabels = unpaidAllTimeLabels.TrimEnd(',') + "]";

        string script = "<script>" +
            "window.onload = function() {" +
            "var ctx = document.getElementById('productBarChart').getContext('2d');" +
            "var chart = new Chart(ctx, {" +
            "    type: 'bar'," +
            "    data: {" +
            "        labels: [" + chartLabels + "]," +
            "        datasets: [" +
            "            {" +
            "                label: 'Paid'," +
            "                data: [" + chartPaidData + "]," +
            "                backgroundColor: '#4caf50'" +
            "            }," +
            "            {" +
            "                label: 'Unpaid (Last 30 Days)'," +
            "                data: [" + chartUnpaidData + "]," +
            "                backgroundColor: '#f44336'" +
            "            }" +
            "        ]" +
            "    }," +
            "    options: {" +
            "        responsive: true," +
            "        plugins: {" +
            "            legend: { position: 'top' }," +
            "            tooltip: {" +
            "                callbacks: {" +
            "                    afterBody: function(context) {" +
            "                        var idx = context[0].dataIndex;" +
            "                        var earnings = " + earningsLabels + ";" +
            "                        var unpaid = " + unpaidLabels + ";" +
            "                        var unpaidAll = " + unpaidAllTimeLabels + ";" +
            "                        return ['Earnings (Last 30 Days): ' + earnings[idx], 'Unpaid (Last 30 Days): ' + unpaid[idx], 'Unpaid (All Time): ' + unpaidAll[idx]];" +
            "                    }" +
            "                }" +
            "            }" +
            "        }," +
            "        scales: {" +
            "            y: { beginAtZero: true }" +
            "        }" +
            "    }" +
            "});" +
            "};" +
            "</script>";
        ClientScript.RegisterStartupScript(this.GetType(), "productBarChartScript", script, false);
    }
}
