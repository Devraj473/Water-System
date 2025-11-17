using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ProductRequests : BasePage
{
    string conStr = ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadRequests();
        }
    }

    private void LoadRequests()
    {
        using (SqlConnection con = new SqlConnection(conStr))
        {
            string query = @"
                SELECT 
                    PR.Request_Id,
                    C.Name AS Customer_Name,
                    P.Product_Name,
                    PR.Quantity,
                    PR.Start_Date,
                    PR.Notes,
                    PR.Status
                FROM Tbl_ProductRequest PR
                INNER JOIN Tbl_Customer C ON PR.Customer_Id = C.Customer_Id
                INNER JOIN Tbl_Product P ON PR.Product_Id = P.Product_Id
                WHERE PR.IsActive = 1
                ORDER BY 
                    CASE 
                        WHEN PR.Status = 'Pending' THEN 1
                        WHEN PR.Status = 'Approved' THEN 2
                        WHEN PR.Status = 'Rejected' THEN 3
                    END,
                    PR.Request_Date DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                rptRequests.DataSource = dt;
                rptRequests.DataBind();
                pnlNoData.Visible = false;
            }
            else
            {
                rptRequests.DataSource = null;
                rptRequests.DataBind();
                pnlNoData.Visible = true;
            }
        }
    }

    protected void rptRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int requestId = Convert.ToInt32(e.CommandArgument);
        string newStatus = "";
        string message = "";

        if (e.CommandName == "Approve")
        {
            newStatus = "Approved";
            message = "Request has been approved successfully!";
        }
        else if (e.CommandName == "Reject")
        {
            newStatus = "Rejected";
            message = "Request has been rejected successfully!";
        }
        else if (e.CommandName == "Delete")
        {
            try
            {
                // Soft delete - set IsActive = 0
                using (SqlConnection con = new SqlConnection(conStr))
                {
                    string deleteQuery = "UPDATE Tbl_ProductRequest SET IsActive = 0 WHERE Request_Id = @RequestId";
                    SqlCommand cmd = new SqlCommand(deleteQuery, con);
                    cmd.Parameters.AddWithValue("@RequestId", requestId);
                    
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }

                // Reload requests immediately
                LoadRequests();
                
                // Show success message after reload
                string script = "alert('Request has been deleted successfully!');";
                ClientScript.RegisterStartupScript(this.GetType(), "DeleteSuccess", script, true);
            }
            catch (Exception ex)
            {
                string script = "alert('Error deleting request: " + ex.Message.Replace("'", "\\'") + "');";
                ClientScript.RegisterStartupScript(this.GetType(), "DeleteError", script, true);
            }
            return;
        }

        if (!string.IsNullOrEmpty(newStatus))
        {
            using (SqlConnection con = new SqlConnection(conStr))
            {
                con.Open();
                string updateQuery = "UPDATE Tbl_ProductRequest SET Status = @Status WHERE Request_Id = @RequestId";
                SqlCommand cmd = new SqlCommand(updateQuery, con);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@RequestId", requestId);
                cmd.ExecuteNonQuery();
            }

            // Show success message
            string script = string.Format("alert('{0}');", message);
            ClientScript.RegisterStartupScript(this.GetType(), "StatusUpdate", script, true);

            // Reload requests
            LoadRequests();
        }
    }
}
