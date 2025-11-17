using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Globalization;
using System.Web;

public partial class Water_Man_Transaction_Master : BasePage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    private Dictionary<int, int?> EditProduct
    {
        get
        {
            if (ViewState["EditProduct"] == null)
                ViewState["EditProduct"] = new Dictionary<int, int?>();
            return (Dictionary<int, int?>)ViewState["EditProduct"];
        }
        set
        {
            ViewState["EditProduct"] = value;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDateFilter.Attributes["type"] = "date";
            txtDateFilter.Text = DateTime.Today.ToString("yyyy-MM-dd");
            LoadAreas();
            BindCustomers();
        }
    }

    private void LoadAreas()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT Area_Id, Area_Name FROM Tbl_Areas WHERE IsActive = 1", con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            ddlAreaFilter.DataSource = dt;
            ddlAreaFilter.DataTextField = "Area_Name";
            ddlAreaFilter.DataValueField = "Area_Id";
            ddlAreaFilter.DataBind();

            ddlAreaFilter.Items.Insert(0, new ListItem("-- All Areas --", "0"));
        }
    }

    private void BindCustomers()
    {
        int areaId = 0;
        DateTime? selectedDate = null;
        if (ddlAreaFilter.SelectedValue != null)
            int.TryParse(ddlAreaFilter.SelectedValue, out areaId);
        if (!string.IsNullOrWhiteSpace(txtDateFilter.Text))
        {
            DateTime dt;
            if (DateTime.TryParseExact(txtDateFilter.Text.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                selectedDate = dt;
        }

        // Store selected date in ViewState for use in product binding
        ViewState["SelectedDate"] = selectedDate;

        using (SqlConnection con = new SqlConnection(conStr))
        {
            // Show all customers in the selected area, regardless of whether they have transactions
            string query = "SELECT * FROM Tbl_Customer WHERE (@AreaId = 0 OR Area_Id = @AreaId) AND IsActive = 1 ORDER BY Customer_Id";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@AreaId", areaId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            rptCustomers.DataSource = dt;
            rptCustomers.DataBind();
        }

        // Show salesman for selected area
        txtSalesman.Text = "";
        if (areaId > 0)
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"SELECT S.Salesman_Name FROM Tbl_Salesman S
                                 INNER JOIN Tbl_Areas A ON S.Salesman_Id = A.Salesman_Id
                                 WHERE A.Area_Id = @AreaId AND A.IsActive = 1 AND S.IsActive = 1";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@AreaId", areaId);
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                    txtSalesman.Text = "Salesman: " + result.ToString();
                else
                    txtSalesman.Text = "Salesman: Not assigned";
            }
        }
    }

    protected void btnFilter_Click(object sender, EventArgs e)
    {
        if (!string.IsNullOrWhiteSpace(txtDateFilter.Text))
        {
            DateTime filterDate;
            if (DateTime.TryParseExact(txtDateFilter.Text.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out filterDate))
            {
                if (filterDate > DateTime.Today)
                {
                    ShowCustomAlert("Future date is not allowed in filter!", "error");
                    return;
                }
            }
        }
        BindCustomers();
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        ddlAreaFilter.SelectedIndex = 0;
        txtDateFilter.Text = DateTime.Today.ToString("yyyy-MM-dd");
        txtSalesman.Text = "";
        BindCustomers();
        ShowCustomAlert("Filter cleared successfully.", "info");
    }

    protected void rptCustomers_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            var hfCustomerID = (HiddenField)e.Item.FindControl("hfCustomerID");
            int customerId = Convert.ToInt32(hfCustomerID.Value);

            DateTime? filterDate = null;
            if (!string.IsNullOrWhiteSpace(txtDateFilter.Text))
            {
                DateTime dt;
                if (DateTime.TryParseExact(txtDateFilter.Text.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dt))
                    filterDate = dt;
            }

            var rptProducts = (Repeater)e.Item.FindControl("rptProducts");
            DataTable dtProducts = new DataTable();

            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = @"
                    SELECT CP.CP_Id, CP.Quantity, CP.Daily_Date, P.Product_Name,
                           ISNULL(T.Total_Amount, 0) AS Total_Amount
                    FROM Tbl_CustomerProduct CP
                    INNER JOIN Tbl_Product P ON CP.Product_Id = P.Product_Id
                    LEFT JOIN Tbl_Transaction T ON T.CP_Id = CP.CP_Id AND T.Month = CP.Daily_Date
                    WHERE CP.Customer_Id = @CustomerId AND CP.IsActive = 1";
                if (filterDate.HasValue)
                    query += " AND CP.Daily_Date = @FilterDate";
                query += " ORDER BY CP.Daily_Date DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@CustomerId", customerId);
                if (filterDate.HasValue)
                    cmd.Parameters.AddWithValue("@FilterDate", filterDate.Value.Date);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtProducts);
            }

            if (!dtProducts.Columns.Contains("IsEdit"))
                dtProducts.Columns.Add("IsEdit", typeof(bool));

            var editDict = EditProduct;
            foreach (DataRow row in dtProducts.Rows)
            {
                int cpId = Convert.ToInt32(row["CP_Id"]);
                row["IsEdit"] = (editDict.ContainsKey(customerId) && editDict[customerId] == cpId);
            }

            rptProducts.DataSource = dtProducts;
            rptProducts.DataBind();

            // Bind product dropdown for adding
            var ddlAddProduct = (DropDownList)e.Item.FindControl("ddlAddProduct");
            using (SqlConnection con = new SqlConnection(conStr))
            {
                string query = "SELECT Product_Id, Product_Name FROM Tbl_Product WHERE IsActive = 1";
                SqlCommand cmd = new SqlCommand(query, con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dtProd = new DataTable();
                da.Fill(dtProd);
                ddlAddProduct.DataSource = dtProd;
                ddlAddProduct.DataTextField = "Product_Name";
                ddlAddProduct.DataValueField = "Product_Id";
                ddlAddProduct.DataBind();
                ddlAddProduct.Items.Insert(0, new ListItem("--Select--", ""));
            }
        }
    }

    // This event calculates and displays the totals in the footer
    protected void rptProducts_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            int totalQty = 0;
            decimal totalAmt = 0;

            Repeater rpt = (Repeater)sender;

            // Get the data source to calculate totals - using older C# syntax
            DataTable dt = rpt.DataSource as DataTable;
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    if (row["Quantity"] != DBNull.Value)
                    {
                        totalQty += Convert.ToInt32(row["Quantity"]);
                    }
                    if (row["Total_Amount"] != DBNull.Value)
                    {
                        totalAmt += Convert.ToDecimal(row["Total_Amount"]);
                    }
                }
            }
            else
            {
                // Fallback: calculate from rendered items
                foreach (RepeaterItem item in rpt.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        // Get quantity from either label or textbox
                        Label lblQty = (Label)item.FindControl("lblQty");
                        TextBox txtQty = (TextBox)item.FindControl("txtQty");

                        int qty = 0;
                        decimal amt = 0;

                        // Check if in edit mode
                        if (txtQty != null && txtQty.Visible)
                        {
                            int.TryParse(txtQty.Text, out qty);
                        }
                        else if (lblQty != null && lblQty.Visible)
                        {
                            int.TryParse(lblQty.Text, out qty);
                        }

                        // Get the total amount directly from the data item
                        DataRowView rowView = item.DataItem as DataRowView;
                        if (rowView != null && rowView["Total_Amount"] != DBNull.Value)
                        {
                            amt = Convert.ToDecimal(rowView["Total_Amount"]);
                        }

                        totalQty += qty;
                        totalAmt += amt;
                    }
                }
            }

            Label lblFooterQty = (Label)e.Item.FindControl("lblFooterTotalQty");
            Label lblFooterAmt = (Label)e.Item.FindControl("lblFooterTotalAmt");

            if (lblFooterQty != null)
                lblFooterQty.Text = totalQty.ToString();
            if (lblFooterAmt != null)
                lblFooterAmt.Text = totalAmt.ToString("F2"); // Format to 2 decimal places
        }
    }

    protected void rptCustomers_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        var hfCustomerID = (HiddenField)e.Item.FindControl("hfCustomerID");
        int customerId = Convert.ToInt32(hfCustomerID.Value);

        var editDict = EditProduct;

        if (e.CommandName == "AddProduct")
        {
            var ddlAddProduct = (DropDownList)e.Item.FindControl("ddlAddProduct");
            var txtAddQty = (TextBox)e.Item.FindControl("txtAddQty");

            int productId;
            int quantity;

            DateTime dailyDate;
            if (!int.TryParse(ddlAddProduct.SelectedValue, out productId) || productId == 0)
            {
                ShowCustomAlert("Please select a product.", "error");
                return;
            }
            if (!int.TryParse(txtAddQty.Text, out quantity) || quantity <= 0)
            {
                ShowCustomAlert("Please enter a valid positive quantity.", "error");
                return;
            }
            if (string.IsNullOrWhiteSpace(txtDateFilter.Text) ||
                !DateTime.TryParseExact(txtDateFilter.Text.Trim(), "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out dailyDate))
            {
                ShowCustomAlert("Please select a date from the filter calendar.", "error");
                return;
            }
            if (dailyDate > DateTime.Today)
            {
                ShowCustomAlert("Future date is not allowed.", "error");
                return;
            }

            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();

                // Prevent duplicate product for customer on the same date
                string checkCP = @"SELECT COUNT(*) FROM Tbl_CustomerProduct 
                               WHERE Customer_Id=@CustomerId AND Product_Id=@ProductId AND Daily_Date=@DailyDate AND IsActive = 1 ";
                SqlCommand cmdCheck = new SqlCommand(checkCP, con);
                cmdCheck.Parameters.AddWithValue("@CustomerId", customerId);
                cmdCheck.Parameters.AddWithValue("@ProductId", productId);
                cmdCheck.Parameters.AddWithValue("@DailyDate", dailyDate);

                int alreadyExists = Convert.ToInt32(cmdCheck.ExecuteScalar());
                if (alreadyExists > 0)
                {
                    ShowCustomAlert("This product is already added for this customer on this date.", "warning");
                    return;
                }

                int areaId = 0;
                SqlCommand cmdArea = new SqlCommand("SELECT Area_Id FROM Tbl_Customer WHERE Customer_Id=@CustomerId AND IsActive = 1", con);
                cmdArea.Parameters.AddWithValue("@CustomerId", customerId);
                var areaObj = cmdArea.ExecuteScalar();
                if (areaObj != null && areaObj != DBNull.Value)
                    areaId = Convert.ToInt32(areaObj);

                int salesmanId = 0;
                SqlCommand cmdSalesman = new SqlCommand("SELECT TOP 1 Salesman_Id FROM Tbl_Salesman WHERE Area_Id=@AreaId AND IsActive = 1", con);
                cmdSalesman.Parameters.AddWithValue("@AreaId", areaId);
                var salesmanObj = cmdSalesman.ExecuteScalar();
                if (salesmanObj != null && salesmanObj != DBNull.Value)
                    salesmanId = Convert.ToInt32(salesmanObj);

                decimal productRate = 0;
                SqlCommand cmdRate = new SqlCommand("SELECT Product_Rate FROM Tbl_Product WHERE Product_Id=@ProductId AND IsActive = 1", con);
                cmdRate.Parameters.AddWithValue("@ProductId", productId);
                var rateObj = cmdRate.ExecuteScalar();
                if (rateObj != null && rateObj != DBNull.Value)
                    productRate = Convert.ToDecimal(rateObj);

                using (SqlTransaction sqlTran = con.BeginTransaction())
                {
                    try
                    {
                        // 1. Insert into Tbl_CustomerProduct
                        string insertCP = @"INSERT INTO Tbl_CustomerProduct (Customer_Id, Product_Id, Quantity, Daily_Date)
                                        VALUES (@CustomerId, @ProductId, @Quantity, @DailyDate);
                                        SELECT SCOPE_IDENTITY();";
                        SqlCommand cmdCP = new SqlCommand(insertCP, con, sqlTran);
                        cmdCP.Parameters.AddWithValue("@CustomerId", customerId);
                        cmdCP.Parameters.AddWithValue("@ProductId", productId);
                        cmdCP.Parameters.AddWithValue("@Quantity", quantity);
                        cmdCP.Parameters.AddWithValue("@DailyDate", dailyDate);
                        int cpId = Convert.ToInt32(cmdCP.ExecuteScalar());

                        // 2. Insert into Tbl_Transaction
                        string insertTrans = @"INSERT INTO Tbl_Transaction (CP_Id, Area_Id, Salesman_Id, Total_Amount, Payment_Status, Month)
                                           VALUES (@CPId, @AreaId, @SalesmanId, @TotalAmount, @PaymentStatus, @Month)";
                        SqlCommand cmdTrans = new SqlCommand(insertTrans, con, sqlTran);
                        cmdTrans.Parameters.AddWithValue("@CPId", cpId);
                        cmdTrans.Parameters.AddWithValue("@AreaId", areaId);
                        cmdTrans.Parameters.AddWithValue("@SalesmanId", salesmanId);
                        cmdTrans.Parameters.AddWithValue("@TotalAmount", quantity * productRate);
                        cmdTrans.Parameters.AddWithValue("@PaymentStatus", "Unpaid");
                        cmdTrans.Parameters.AddWithValue("@Month", dailyDate);
                        cmdTrans.ExecuteNonQuery();

                        // 3. Insert into Tbl_Bill (with latest cpId, Month as empty string)
                        string insertBill = @"INSERT INTO Tbl_Bill (CP_Id, Month) VALUES (@CP_Id, @Month);";
                        SqlCommand cmdBill = new SqlCommand(insertBill, con, sqlTran);
                        cmdBill.Parameters.AddWithValue("@CP_Id", cpId);
                        cmdBill.Parameters.AddWithValue("@Month", "");
                        cmdBill.ExecuteNonQuery();

                        sqlTran.Commit();
                        ShowCustomAlert("Product added successfully!", "success");
                    }
                    catch (Exception ex)
                    {
                        sqlTran.Rollback();
                        ShowCustomAlert("Error adding product: " + ex.Message, "error");
                    }
                }
            }

            BindCustomers();
        }
    }

    protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        var parent = (RepeaterItem)((Repeater)source).NamingContainer;
        var hfCustomerID = (HiddenField)parent.FindControl("hfCustomerID");
        int customerId = Convert.ToInt32(hfCustomerID.Value);

        var hfCPId = (HiddenField)e.Item.FindControl("hfCPId");
        int cpId = Convert.ToInt32(hfCPId.Value);

        var editDict = EditProduct;

        switch (e.CommandName)
        {
            case "Edit":
                editDict[customerId] = cpId;
                EditProduct = editDict;
                BindCustomers();
                ShowCustomAlert("Edit mode enabled for this product.", "info");
                break;
            case "Cancel":
                editDict.Remove(customerId);
                EditProduct = editDict;
                BindCustomers();
                ShowCustomAlert("Edit cancelled.", "info");
                break;
            case "Update":
                var txtQty = (TextBox)e.Item.FindControl("txtQty");
                int newQty;
                if (!int.TryParse(txtQty.Text, out newQty) || newQty <= 0)
                {
                    ShowCustomAlert("Please enter a valid positive quantity.", "error");
                    return;
                }
                try
                {
                    using (SqlConnection con = new SqlConnection(conStr))
                    {
                        con.Open();
                        string updateCP = "UPDATE Tbl_CustomerProduct SET Quantity = @Qty WHERE CP_Id = @CPId";
                        SqlCommand cmd = new SqlCommand(updateCP, con);
                        cmd.Parameters.AddWithValue("@Qty", newQty);
                        cmd.Parameters.AddWithValue("@CPId", cpId);
                        cmd.ExecuteNonQuery();

                        decimal productRate = 0;
                        SqlCommand cmdRate = new SqlCommand("SELECT Product_Rate FROM Tbl_Product WHERE Product_Id = (SELECT Product_Id FROM Tbl_CustomerProduct WHERE CP_Id = @CPId) AND IsActive = 1", con);
                        cmdRate.Parameters.AddWithValue("@CPId", cpId);
                        var rateObj = cmdRate.ExecuteScalar();
                        if (rateObj != null && rateObj != DBNull.Value)
                            productRate = Convert.ToDecimal(rateObj);

                        string updateTrans = "UPDATE Tbl_Transaction SET Total_Amount = @TotalAmount WHERE CP_Id = @CPId";
                        SqlCommand cmdTrans = new SqlCommand(updateTrans, con);
                        cmdTrans.Parameters.AddWithValue("@TotalAmount", newQty * productRate);
                        cmdTrans.Parameters.AddWithValue("@CPId", cpId);
                        cmdTrans.ExecuteNonQuery();
                    }
                    editDict.Remove(customerId);
                    EditProduct = editDict;
                    BindCustomers();
                    ShowCustomAlert("Product quantity updated successfully!", "success");
                }
                catch (Exception ex)
                {
                    ShowCustomAlert("Error updating product: " + ex.Message, "error");
                }
                break;
        }
    }

    // Method to show custom styled alerts - Compatible with .NET Framework 4.0
    private void ShowCustomAlert(string message, string type)
    {
        string script = string.Format("showCustomAlert('{0}', '{1}');",
            message.Replace("'", "\\'").Replace("\r\n", "\\n").Replace("\n", "\\n"),
            type);

        ClientScript.RegisterStartupScript(this.GetType(), "ShowCustomAlert", script, true);
    }
}