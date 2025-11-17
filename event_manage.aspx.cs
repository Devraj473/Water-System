using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Web.UI.WebControls;

public partial class Water_Man_EventManage : BasePage
{
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["db_RoWaterConnectionString"].ConnectionString);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadProducts();
            LoadEvents();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid)
            return;

        try
        {
            string eventName = txtEventName.Text.Trim();
            string startDate = txtStartDate.Text.Trim();
            string endDate = txtEndDate.Text.Trim();
            string address = txtAddress.Text.Trim();

            // Gather product quantities from Repeater
            DataTable dtProducts = new DataTable();
            dtProducts.Columns.Add("Product_Id", typeof(int));
            dtProducts.Columns.Add("Quantity", typeof(int));

            foreach (RepeaterItem item in rptProducts.Items)
            {
                TextBox txtQty = (TextBox)item.FindControl("txtQty");
                HiddenField hfProductId = (HiddenField)item.FindControl("hfProductId");
                int qty = 0;
                int.TryParse(txtQty.Text, out qty);
                int pid = 0;
                int.TryParse(hfProductId.Value, out pid);

                if (pid > 0 && qty > 0)
                {
                    dtProducts.Rows.Add(pid, qty);
                }
            }

            if (string.IsNullOrEmpty(hfEventId.Value))
            {
                // Add new event
                int newEventId = 0;
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Tbl_Event (Event_Name, Starting_Date, Ending_Date, Address, IsActive) OUTPUT INSERTED.Event_Id VALUES (@name, @start, @end, @address, 1)", con))
                {
                    cmd.Parameters.AddWithValue("@name", eventName);
                    cmd.Parameters.AddWithValue("@start", startDate);
                    cmd.Parameters.AddWithValue("@end", endDate);
                    cmd.Parameters.AddWithValue("@address", address);
                    con.Open();
                    newEventId = (int)cmd.ExecuteScalar();
                    con.Close();
                }
                // Insert event products
                foreach (DataRow dr in dtProducts.Rows)
                {
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Tbl_EventProduct (Event_Id, Product_Id, Quantity) VALUES (@eid, @pid, @qty)", con))
                    {
                        cmd.Parameters.AddWithValue("@eid", newEventId);
                        cmd.Parameters.AddWithValue("@pid", dr["Product_Id"]);
                        cmd.Parameters.AddWithValue("@qty", dr["Quantity"]);
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                ShowCustomAlert("Event saved successfully!", "success");
            }
            else
            {
                // Update event
                int eventId = int.Parse(hfEventId.Value);
                using (SqlCommand cmd = new SqlCommand("UPDATE Tbl_Event SET Event_Name=@name, Starting_Date=@start, Ending_Date=@end, Address=@address WHERE Event_Id=@id", con))
                {
                    cmd.Parameters.AddWithValue("@name", eventName);
                    cmd.Parameters.AddWithValue("@start", startDate);
                    cmd.Parameters.AddWithValue("@end", endDate);
                    cmd.Parameters.AddWithValue("@address", address);
                    cmd.Parameters.AddWithValue("@id", eventId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
                // Update event products: delete old, insert new
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Tbl_EventProduct WHERE Event_Id=@eid", con))
                {
                    cmd.Parameters.AddWithValue("@eid", eventId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
                foreach (DataRow dr in dtProducts.Rows)
                {
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO Tbl_EventProduct (Event_Id, Product_Id, Quantity) VALUES (@eid, @pid, @qty)", con))
                    {
                        cmd.Parameters.AddWithValue("@eid", eventId);
                        cmd.Parameters.AddWithValue("@pid", dr["Product_Id"]);
                        cmd.Parameters.AddWithValue("@qty", dr["Quantity"]);
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                ShowCustomAlert("Event updated successfully!", "success");
            }

            ClearForm();
            LoadProducts();
            LoadEvents();
        }
        catch (Exception ex)
        {
            ShowCustomAlert("An error occurred: " + ex.Message, "error");
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ClearForm();
        LoadProducts();
        ShowCustomAlert("Form cleared successfully.", "info");
    }

    protected void rptEvents_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        int eventId;
        if (!int.TryParse(e.CommandArgument.ToString(), out eventId))
        {
            ShowCustomAlert("Invalid event ID.", "error");
            return;
        }

        try
        {
            if (e.CommandName == "Edit")
            {
                // Load event for editing
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM Tbl_Event WHERE Event_Id=@id", con))
                {
                    cmd.Parameters.AddWithValue("@id", eventId);
                    con.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            txtEventName.Text = dr["Event_Name"].ToString();
                            txtStartDate.Text = Convert.ToDateTime(dr["Starting_Date"]).ToString("yyyy-MM-dd");
                            txtEndDate.Text = Convert.ToDateTime(dr["Ending_Date"]).ToString("yyyy-MM-dd");
                            txtAddress.Text = dr["Address"].ToString();
                            hfEventId.Value = dr["Event_Id"].ToString();
                        }
                    }
                    con.Close();
                }
                // Load product quantities for this event
                LoadProducts(eventId);
                ShowCustomAlert("Event loaded for editing.", "info");
            }
            else if (e.CommandName == "Delete")
            {
                // Perform soft delete
                using (SqlCommand cmd = new SqlCommand("UPDATE Tbl_Event SET IsActive=0 WHERE Event_Id=@id", con))
                {
                    cmd.Parameters.AddWithValue("@id", eventId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
                using (SqlCommand cmd = new SqlCommand("DELETE FROM Tbl_EventProduct WHERE Event_Id=@id", con))
                {
                    cmd.Parameters.AddWithValue("@id", eventId);
                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
                ShowCustomAlert("Event deleted successfully!", "success");
                ClearForm();
                LoadProducts();
                LoadEvents();
            }
        }
        catch (Exception ex)
        {
            ShowCustomAlert("An error occurred: " + ex.Message, "error");
        }
    }

    protected void rptEvents_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            // Set up delete button with proper client-side confirmation
            LinkButton lnkDelete = (LinkButton)e.Item.FindControl("lnkDelete");
            if (lnkDelete != null)
            {
                lnkDelete.OnClientClick = "return confirmDeleteEvent('" + lnkDelete.UniqueID + "');";
            }
        }
    }

    private void LoadProducts(int eventId = 0)
    {
        DataTable dt = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter("SELECT Product_Id, Product_Name FROM Tbl_Product WHERE IsActive=1", con))
        {
            da.Fill(dt);
        }

        // Always add Quantity column and initialize to 0
        if (!dt.Columns.Contains("Quantity"))
            dt.Columns.Add("Quantity", typeof(int));
        foreach (DataRow row in dt.Rows)
        {
            row["Quantity"] = 0;
        }

        // If editing, load quantities
        if (eventId > 0)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT Product_Id, Quantity FROM Tbl_EventProduct WHERE Event_Id=@eid", con))
            {
                cmd.Parameters.AddWithValue("@eid", eventId);
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            if (row["Product_Id"].ToString() == dr["Product_Id"].ToString())
                            {
                                row["Quantity"] = dr["Quantity"];
                                break;
                            }
                        }
                    }
                }
                con.Close();
            }
        }

        rptProducts.DataSource = dt;
        rptProducts.DataBind();

        // Set product quantities if editing
        if (eventId > 0)
        {
            foreach (RepeaterItem item in rptProducts.Items)
            {
                HiddenField hfProductId = (HiddenField)item.FindControl("hfProductId");
                TextBox txtQty = (TextBox)item.FindControl("txtQty");
                DataRow[] found = dt.Select("Product_Id=" + hfProductId.Value);
                if (found.Length > 0)
                    txtQty.Text = found[0]["Quantity"].ToString();
            }
        }
    }

    private void LoadEvents()
    {
        DataTable dtEvents = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Tbl_Event WHERE IsActive=1 ORDER BY Event_Id DESC", con))
        {
            da.Fill(dtEvents);
        }

        // Add ProductsOrdered column for display
        dtEvents.Columns.Add("ProductsOrdered", typeof(string));
        foreach (DataRow row in dtEvents.Rows)
        {
            int eventId = Convert.ToInt32(row["Event_Id"]);
            StringBuilder sb = new StringBuilder();
            using (SqlCommand cmd = new SqlCommand(
                @"SELECT p.Product_Name, ep.Quantity 
                  FROM Tbl_EventProduct ep 
                  INNER JOIN Tbl_Product p ON ep.Product_Id = p.Product_Id 
                  WHERE ep.Event_Id=@eid", con))
            {
                cmd.Parameters.AddWithValue("@eid", eventId);
                con.Open();
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        if (sb.Length > 0) sb.Append(", ");
                        sb.AppendFormat("{0} ({1})", dr["Product_Name"], dr["Quantity"]);
                    }
                }
                con.Close();
            }
            row["ProductsOrdered"] = sb.ToString();
        }

        rptEvents.DataSource = dtEvents;
        rptEvents.DataBind();
    }

    private void ClearForm()
    {
        txtEventName.Text = "";
        txtStartDate.Text = "";
        txtEndDate.Text = "";
        txtAddress.Text = "";
        hfEventId.Value = "";
        LoadProducts();
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