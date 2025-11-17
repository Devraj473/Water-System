<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeFile="UserDashboard.aspx.cs" Inherits="UserDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .welcome-section {
            background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
            color: white;
            padding: 40px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.3);
        }

        .welcome-section h1 {
            font-size: 2.2em;
            margin-bottom: 10px;
        }

        .welcome-section p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8em;
            margin-bottom: 15px;
        }

        .stat-icon.blue {
            background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
            color: white;
        }

        .stat-icon.green {
            background: linear-gradient(135deg, #4caf50 0%, #2e7d32 100%);
            color: white;
        }

        .stat-icon.orange {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }

        .stat-icon.red {
            background: linear-gradient(135deg, #f44336 0%, #c62828 100%);
            color: white;
        }

        .stat-label {
            color: #666;
            font-size: 0.95em;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 2em;
            font-weight: 700;
            color: #2c3e50;
        }

        .recent-orders {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .section-title {
            font-size: 1.4em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }

        .order-item {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .order-info {
            flex: 1;
        }

        .order-product {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .order-date {
            color: #666;
            font-size: 0.9em;
        }

        .order-amount {
            font-size: 1.2em;
            font-weight: 700;
            color: #2196f3;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .no-data i {
            font-size: 3em;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        @media (max-width: 768px) {
            .welcome-section h1 {
                font-size: 1.6em;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .order-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <h1>Welcome, <%= Session["UserName"] != null ? Session["UserName"].ToString() : "Customer" %>!</h1>
        <p>Here's an overview of your account</p>
    </div>

    <!-- Statistics Cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon blue">
                <i class="fas fa-shopping-cart"></i>
            </div>
            <div class="stat-label">Total Orders</div>
            <div class="stat-value">
                <asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon green">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-label">Paid Orders</div>
            <div class="stat-value">
                <asp:Label ID="lblPaidOrders" runat="server" Text="0"></asp:Label>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon orange">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-label">Pending Payments</div>
            <div class="stat-value">
                <asp:Label ID="lblPendingOrders" runat="server" Text="0"></asp:Label>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon red">
                <i class="fas fa-rupee-sign"></i>
            </div>
            <div class="stat-label">Total Due</div>
            <div class="stat-value">
                &#8377;<asp:Label ID="lblTotalDue" runat="server" Text="0.00"></asp:Label>
            </div>
        </div>
    </div>

    <!-- Recent Orders -->
    <div class="recent-orders">
        <h2 class="section-title">Recent Orders</h2>
        <asp:Repeater ID="rptRecentOrders" runat="server">
            <ItemTemplate>
                <div class="order-item">
                    <div class="order-info">
                        <div class="order-product"><%# Eval("Product_Name") %></div>
                        <div class="order-date">
                            <i class="far fa-calendar"></i> <%# Convert.ToDateTime(Eval("Daily_Date")).ToString("dd MMM yyyy") %>
                            | Qty: <%# Eval("Quantity") %>
                        </div>
                    </div>
                    <div class="order-amount">
                        &#8377;<%# Convert.ToDecimal(Eval("Total_Amount")).ToString("N2") %>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlNoOrders" runat="server" CssClass="no-data" Visible="false">
            <i class="fas fa-inbox"></i>
            <p>No recent orders found</p>
        </asp:Panel>
    </div>
</asp:Content>
