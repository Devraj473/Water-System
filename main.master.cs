
using System;
using System.Web.UI;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.IO;

public partial class Water_Man_main : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check session timeout first
        CheckSessionTimeout();

        if (!IsPostBack)
        {
            string lang = "en";
            SetActiveNavigation();

            HttpCookie langCookie = Request.Cookies["SiteLanguage"];
            if (langCookie != null && !string.IsNullOrEmpty(langCookie.Value))
            {
                lang = langCookie.Value;
            }

            // Removed auto language apply on every page
            // Language will only be changed when user sets it in Settings.aspx
        }
    }

    private void SetActiveNavigation()
    {
        string currentPage = Path.GetFileName(Request.Url.AbsolutePath).ToLower();
        RemoveActiveClasses();

        switch (currentPage)
        {
            case "default.aspx":
                liDashboard.Attributes["class"] = "active";
                navDashboard.Attributes["class"] = "bottom-nav__item active";
                break;

            case "customer_add.aspx":
                liCustomerMaster.Attributes["class"] = "has-submenu parent-active";
                liAddCustomer.Attributes["class"] = "submenu-item active";
                navCustomers.Attributes["class"] = "bottom-nav__item active";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "expandCustomerSubmenu",
                    "document.getElementById('desktop-events-submenu').classList.add('visible');", true);
                break;

            case "customer_master.aspx":
                liCustomerMaster.Attributes["class"] = "has-submenu parent-active";
                liManageCustomer.Attributes["class"] = "submenu-item active";
                navCustomers.Attributes["class"] = "bottom-nav__item active";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "expandCustomerSubmenu",
                    "document.getElementById('desktop-events-submenu').classList.add('visible');", true);
                break;

            case "area_add.aspx":
                liAreaMaster.Attributes["class"] = "has-submenu parent-active";
                liAddArea.Attributes["class"] = "submenu-item active";
                navAreas.Attributes["class"] = "bottom-nav__item active";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "expandAreaSubmenu",
                    "document.getElementById('desktop-area-submenu').classList.add('visible');", true);
                break;

            case "area_master.aspx":
                liAreaMaster.Attributes["class"] = "has-submenu parent-active";
                liManageArea.Attributes["class"] = "submenu-item active";
                navAreas.Attributes["class"] = "bottom-nav__item active";
                Page.ClientScript.RegisterStartupScript(this.GetType(), "expandAreaSubmenu",
                    "document.getElementById('desktop-area-submenu').classList.add('visible');", true);
                break;

            case "transaction_master.aspx":
                liTransaction.Attributes["class"] = "active";
                navTransactions.Attributes["class"] = "bottom-nav__item active";
                break;

            case "reports.aspx":
                liReports.Attributes["class"] = "active";
                navReports.Attributes["class"] = "bottom-nav__item active";
                break;

            case "settings.aspx":
                liSettings.Attributes["class"] = "active";
                break;

            default:
                liDashboard.Attributes["class"] = "active";
                navDashboard.Attributes["class"] = "bottom-nav__item active";
                break;
        }
    }

    private void RemoveActiveClasses()
    {
        liDashboard.Attributes["class"] = "";
        liCustomerMaster.Attributes["class"] = "has-submenu";
        liAddCustomer.Attributes["class"] = "submenu-item";
        liManageCustomer.Attributes["class"] = "submenu-item";
        liAreaMaster.Attributes["class"] = "has-submenu";
        liAddArea.Attributes["class"] = "submenu-item";
        liManageArea.Attributes["class"] = "submenu-item";
        liTransaction.Attributes["class"] = "";
        liReports.Attributes["class"] = "";
        liSettings.Attributes["class"] = "";

        navDashboard.Attributes["class"] = "bottom-nav__item";
        navCustomers.Attributes["class"] = "bottom-nav__item";
        navAreas.Attributes["class"] = "bottom-nav__item";
        navTransactions.Attributes["class"] = "bottom-nav__item";
        navReports.Attributes["class"] = "bottom-nav__item";
    }

    public void CheckAuthentication()
    {
        if (Session["Authenticated"] == null)
        {
            Response.Redirect("Login.aspx");
        }
    }

    public void CheckSessionTimeout()
    {
        if (Session["Authenticated"] != null)
        {
            if (Session["LastActivity"] != null)
            {
                DateTime lastActivity = (DateTime)Session["LastActivity"];
                int timeoutMinutes = Session.Timeout;

                if (DateTime.Now.Subtract(lastActivity).TotalMinutes > timeoutMinutes)
                {
                    Session.Clear();
                    Session.Abandon();
                    Response.Redirect("Login.aspx?timeout=true");
                    return;
                }
            }

            Session["LastActivity"] = DateTime.Now;
        }
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();

        if (Request.Cookies[".ASPXAUTH"] != null)
        {
            HttpCookie authCookie = new HttpCookie(".ASPXAUTH");
            authCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(authCookie);
        }

        Response.Redirect("Login.aspx");
    }
}
