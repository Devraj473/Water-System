using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using Microsoft.Reporting.WebForms;

public partial class Water_Man_InvoiceReport : BasePage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCustomers();

            txtStartDate.Text = DateTime.Today.AddDays(-30).ToString("yyyy-MM-dd");
            txtEndDate.Text = DateTime.Today.ToString("yyyy-MM-dd");

            btnExportExcel.Visible = false;
            btnExportPDF.Visible = false;
            btnClearReport.Visible = false;

            // === Setup the ReportViewer ===
            ReportViewer1.Reset(); // Always reset first

            // Set path to RDLC file
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Reports/CustomerInvoice.rdlc");

            // Enable external image support
            ReportViewer1.LocalReport.EnableExternalImages = true;

            // Prepare the absolute image URL
            string logoUrl = Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/WaterSystem/Images/icon_logo.png");

            // Pass logo as report parameter
            ReportParameter logoParam = new ReportParameter("CompanyLogo", logoUrl);

            // Set the parameter to report
            ReportViewer1.LocalReport.SetParameters(new ReportParameter[] { logoParam });

            // Refresh the report
            ReportViewer1.LocalReport.Refresh();
        }
    }

    private void LoadCustomers()
    {
        try
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT Customer_Id, Name FROM Tbl_Customer WHERE IsActive = 1 ORDER BY Name ", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCustomers.DataSource = dt;
                ddlCustomers.DataTextField = "Name";
                ddlCustomers.DataValueField = "Customer_Id";
                ddlCustomers.DataBind();
                ddlCustomers.Items.Insert(0, new ListItem("-- Select Customer --", ""));
            }
        }
        catch (Exception ex)
        {
            ShowCustomAlert("Error loading customers: " + ex.Message, "error");
        }
    }

    protected void ddlCustomers_SelectedIndexChanged(object sender, EventArgs e)
    {
        // Remove automatic report generation - only clear the report viewer
        ClearReportViewer();
    }

    protected void btnGenerateReport_Click(object sender, EventArgs e)
    {
        // Server-side validation (backup for client-side validation)
        if (ValidateInputs())
        {
            try
            {
                rpt1.Attributes["style"] = "display: block;";
                rptbtn1.Attributes["style"] = "display: block;";

                GenerateReport();
                btnExportExcel.Visible = true;
                btnExportPDF.Visible = true;
                btnClearReport.Visible = true;
            }
            catch (Exception ex)
            {
                ShowCustomAlert("Error generating report: " + ex.Message, "error");
            }
        }
    }

    protected void btnClearReport_Click(object sender, EventArgs e)
    {
        ClearReportViewer();
        ShowCustomAlert("Report cleared successfully!", "success");
    }

    private void ClearReportViewer()
    {
        try
        {
            // Clear the report viewer
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.ReleaseSandboxAppDomain();
            ReportViewer1.LocalReport.Refresh();

            // Hide export and clear buttons
            btnExportExcel.Visible = false;
            btnExportPDF.Visible = false;
            btnClearReport.Visible = false;

            // Hide report sections
            rpt1.Attributes["style"] = "display: none;";
            rptbtn1.Attributes["style"] = "display: none;";
        }
        catch (Exception ex)
        {
            ShowCustomAlert("Error clearing report: " + ex.Message, "error");
        }
    }

    private bool ValidateInputs()
    {
        bool isValid = true;
        string errorMessage = "";

        // Validate customer selection
        if (string.IsNullOrEmpty(ddlCustomers.SelectedValue))
        {
            errorMessage += "Please select a customer.\n";
            isValid = false;
        }

        // Validate start date
        DateTime startDate;
        if (string.IsNullOrEmpty(txtStartDate.Text) || !DateTime.TryParse(txtStartDate.Text, out startDate))
        {
            errorMessage += "Please enter a valid start date.\n";
            isValid = false;
        }

        // Validate end date
        DateTime endDate;
        if (string.IsNullOrEmpty(txtEndDate.Text) || !DateTime.TryParse(txtEndDate.Text, out endDate))
        {
            errorMessage += "Please enter a valid end date.\n";
            isValid = false;
        }

        // Validate date range
        if (isValid && DateTime.TryParse(txtStartDate.Text, out startDate) && DateTime.TryParse(txtEndDate.Text, out endDate))
        {
            if (startDate > endDate)
            {
                errorMessage += "Start date cannot be greater than end date.\n";
                isValid = false;
            }

            if (endDate > DateTime.Today)
            {
                errorMessage += "End date cannot be in the future.\n";
                isValid = false;
            }

            // Check if date range is too large (optional - adjust as needed)
            TimeSpan dateRange = endDate - startDate;
            if (dateRange.TotalDays > 365)
            {
                errorMessage += "Date range cannot exceed 365 days.\n";
                isValid = false;
            }
        }

        // Show validation errors if any
        if (!isValid)
        {
            ShowCustomAlert(errorMessage.Trim(), "error");
        }

        return isValid;
    }

    private void GenerateReport()
    {
        int customerId = Convert.ToInt32(ddlCustomers.SelectedValue);
        DateTime startDate = DateTime.Parse(txtStartDate.Text);
        DateTime endDate = DateTime.Parse(txtEndDate.Text);

        try
        {
            // Update payment status from "Unpaid" to "Paid" for all records in this date range
            UpdatePaymentStatus(customerId, startDate, endDate);

            // IMPORTANT: Clear and reset the ReportViewer completely
            ReportViewer1.Reset();
            ReportViewer1.LocalReport.DataSources.Clear();
            ReportViewer1.LocalReport.ReleaseSandboxAppDomain();

            // Set up report
            ReportViewer1.ProcessingMode = ProcessingMode.Local;
            ReportViewer1.LocalReport.ReportPath = Server.MapPath("~/Reports/CustomerInvoice.rdlc");
            ReportViewer1.LocalReport.EnableExternalImages = true;

            // Create DataTable for the report
            DataTable dt = GetInvoiceData(customerId, startDate, endDate);

            // Check if data exists
            if (dt.Rows.Count == 0)
            {
                ShowCustomAlert("No data found for the selected customer and date range.", "warning");
                return;
            }

            // Add DataSource
            ReportDataSource rds = new ReportDataSource("InvoiceDataSet", dt);
            ReportViewer1.LocalReport.DataSources.Add(rds);

            // Clear any existing parameters first
            ReportViewer1.LocalReport.SetParameters(new ReportParameter[] { });

            // Set Report Parameters
            List<ReportParameter> parameters = new List<ReportParameter>();

            // Add logo parameter
            string logoUrl = Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/WaterSystem/Images/icon_logo.png");
            parameters.Add(new ReportParameter("CompanyLogo", logoUrl));

            // Set new parameters
            ReportViewer1.LocalReport.SetParameters(parameters.ToArray());

            // Force refresh
            ReportViewer1.LocalReport.Refresh();

            ShowCustomAlert("Report generated successfully!", "success");
        }
        catch (Exception ex)
        {
            ShowCustomAlert("Error generating report: " + ex.Message, "error");
        }
    }

    private DataTable GetInvoiceData(int customerId, DateTime startDate, DateTime endDate)
    {
        DataTable dt = new DataTable();
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT
                    c.Customer_Id,
                    c.Name AS Customer_Name,
                    c.Mobile,
                    c.Address,
                    a.Area_Name,
                    s.Salesman_Name,
                    cp.CP_Id,
                    cp.Quantity,
                    cp.Daily_Date,
                    p.Product_Name,
                    p.Product_Rate,
                    t.Transaction_Id,
                    t.Total_Amount,
                    t.Payment_Status
                FROM Tbl_Customer c
                INNER JOIN Tbl_Areas a ON c.Area_Id = a.Area_Id
                LEFT JOIN Tbl_Salesman s ON a.Salesman_Id = s.Salesman_Id
                INNER JOIN Tbl_CustomerProduct cp ON c.Customer_Id = cp.Customer_Id
                INNER JOIN Tbl_Product p ON cp.Product_Id = p.Product_Id
                INNER JOIN Tbl_Transaction t ON cp.CP_Id = t.CP_Id
                WHERE c.Customer_Id = @CustomerID
                  AND cp.Daily_Date BETWEEN @StartDate AND @EndDate
                ORDER BY cp.Daily_Date, p.Product_Name";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@CustomerID", customerId);
            cmd.Parameters.AddWithValue("@StartDate", startDate);
            cmd.Parameters.AddWithValue("@EndDate", endDate);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dt);
        }
        return dt;
    }

    protected void btnExportPDF_Click(object sender, EventArgs e)
    {
        if (ValidateReportExists())
        {
            ExportReport("PDF");
        }
    }

    protected void btnExportExcel_Click(object sender, EventArgs e)
    {
        if (ValidateReportExists())
        {
            ExportReport("Excel");
        }
    }

    private bool ValidateReportExists()
    {
        if (ReportViewer1.LocalReport.DataSources.Count == 0)
        {
            ShowCustomAlert("Please generate the report first before exporting.", "warning");
            return false;
        }
        return true;
    }

    private void UpdatePaymentStatus(int customerId, DateTime startDate, DateTime endDate)
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            try
            {
                con.Open();

                // Start transaction to ensure both updates are successful
                SqlTransaction transaction = con.BeginTransaction();

                try
                {
                    // 1. Update transaction status from Unpaid to Paid
                    string updateTransactionQuery = @"
                        UPDATE Tbl_Transaction
                        SET Payment_Status = 'Paid'
                        WHERE CP_Id IN (
                            SELECT CP_Id FROM Tbl_CustomerProduct
                            WHERE Customer_Id = @CustomerID
                            AND Daily_Date BETWEEN @StartDate AND @EndDate
                        )
                        AND Payment_Status = 'Unpaid'";

                    SqlCommand cmdTransaction = new SqlCommand(updateTransactionQuery, con, transaction);
                    cmdTransaction.Parameters.AddWithValue("@CustomerID", customerId);
                    cmdTransaction.Parameters.AddWithValue("@StartDate", startDate);
                    cmdTransaction.Parameters.AddWithValue("@EndDate", endDate);

                    int recordsUpdated = cmdTransaction.ExecuteNonQuery();

                    // 2. Update Tbl_Bill with current date for all affected records
                    string updateBillQuery = @"
                        UPDATE Tbl_Bill
                        SET Month = @CurrentDate
                        WHERE CP_Id IN (
                            SELECT CP_Id FROM Tbl_CustomerProduct
                            WHERE Customer_Id = @CustomerID
                            AND Daily_Date BETWEEN @StartDate AND @EndDate
                        )";

                    SqlCommand cmdBill = new SqlCommand(updateBillQuery, con, transaction);
                    cmdBill.Parameters.AddWithValue("@CurrentDate", DateTime.Now.ToString("yyyy-MM-dd"));
                    cmdBill.Parameters.AddWithValue("@CustomerID", customerId);
                    cmdBill.Parameters.AddWithValue("@StartDate", startDate);
                    cmdBill.Parameters.AddWithValue("@EndDate", endDate);

                    int billsUpdated = cmdBill.ExecuteNonQuery();

                    // Commit the transaction
                    transaction.Commit();

                    // Show informational message about updated records
                    if (recordsUpdated > 0 || billsUpdated > 0)
                    {
                        ShowCustomAlert(string.Format("{0} transactions updated from Unpaid to Paid. {1} bill records updated with current date.",
                            recordsUpdated, billsUpdated), "info");
                    }
                }
                catch (Exception ex)
                {
                    // Rollback transaction if any error occurs
                    transaction.Rollback();
                    throw ex; // Re-throw for outer catch block
                }
            }
            catch (Exception ex)
            {
                ShowCustomAlert("Error updating payment status and bill date: " + ex.Message, "error");
            }
        }
    }

    private void ExportReport(string format)
    {
        string contentType = "";
        string extension = "";

        string deviceInfo = "<DeviceInfo>" +
            "<OutputFormat>" + format + "</OutputFormat>" +
            "<PageWidth>8.5in</PageWidth>" +
            "<PageHeight>11in</PageHeight>" +
            "<MarginTop>0.5in</MarginTop>" +
            "<MarginLeft>0.5in</MarginLeft>" +
            "<MarginRight>0.5in</MarginRight>" +
            "<MarginBottom>0.5in</MarginBottom>" +
            "</DeviceInfo>";

        Warning[] warnings;
        string[] streamIds;
        string mimeType;
        string encoding;

        try
        {
            byte[] bytes = ReportViewer1.LocalReport.Render(
                format == "Excel" ? "Excel" : "PDF",
                deviceInfo,
                out mimeType,
                out encoding,
                out extension,
                out streamIds,
                out warnings);

            if (format == "Excel")
            {
                contentType = "application/vnd.ms-excel";
                extension = "xls";
            }
            else
            {
                contentType = "application/pdf";
                extension = "pdf";
            }

            Response.Clear();
            Response.ContentType = contentType;
            Response.AddHeader("Content-Disposition", "attachment; filename=Invoice_" +
                ddlCustomers.SelectedItem.Text.Replace(" ", "_") + "_" +
                DateTime.Now.ToString("yyyyMMdd") + "." + extension);
            Response.Buffer = true;
            Response.BinaryWrite(bytes);
            Response.End();

            // Note: This message won't show because Response.End() terminates the response
            // But it's good practice to have it for logging purposes
            ShowCustomAlert(format + " export completed successfully!", "success");
        }
        catch (Exception ex)
        {
            ShowCustomAlert("Error exporting report: " + ex.Message, "error");
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