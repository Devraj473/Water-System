<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Water_Man_Default"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Hide the welcome message on mobile (≤600px) */
        @media (max-width: 600px) {
            .dashboard-welcome { display: none !important; }
        }
        .dashboard-welcome {
            margin: 0 auto 24px auto;
            max-width: 520px;
            
        }
        .welcome-message {
            font-size: 2em;
            font-weight: 700;
            color: #2196f3;
            margin-top:3vh;
            text-align: center;
        }
        .welcome-desc {
            font-size: 1.1em;
            color: #555;
            text-align: center;
            margin-top: 4px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- Welcome Message (Desktop/Tablet only) -->
    <div class="dashboard-welcome">
        <div class="welcome-message">
            Welcome, <%= Session["Username"] != null ? Session["Username"] : "Admin" %>!
        </div>
        <div class="welcome-desc">
            Overview of your water system business.
        </div>
    </div>

    <!-- Dashboard Cards -->
    <div class="dashboard-cards">
        <div style="height:56px;" class="space"></div>
        <div class="dashboard-card">
            <div class="card-title ">
                <asp:Label ID="lblTotalCustomersTitle" runat="server" style="font-size:22px; color:#000099;" Text="Total Customers" />
            </div>
            <div class="card-value">
                <asp:Label ID="lblTotalCustomers" runat="server" style="font-size:18px; color:#000099;"/>
            </div>
        </div>
        <div class="dashboard-card scroll-animate-card " onclick="location.href='addproduct.aspx'">
            <div class="card-title ">
                <asp:Label ID="lblProductManagementTitle" runat="server" style="font-size:22px; color:#000099;" Text="Product Management" />
            </div>
            <div class="card-value">
                <asp:Label ID="lblTotalProducts" runat="server" style="font-size:18px; color:#000099;"/>
            </div>
        </div>
        <div class="dashboard-card scroll-animate-card" onclick="location.href='ProductRequests.aspx'">
            <div class="card-title">
                <asp:Label ID="lblProductRequestsTitle" runat="server" style="font-size:22px; color:#000099;" Text="Product Requests" />
            </div>
            <div class="card-value">
                <asp:Label ID="lblTotalProductRequests" runat="server" style="font-size:18px; color:#000099;"/>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="card-title">Total Earnings (Last 30 Days)</div>
            <div class="card-value">
                <span class="card-currency"></span>
                <%= allProductsEarningsLabel %>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="card-title">Total Unpaid (Last 30 Days)</div>
            <div class="card-value">
                <span class="card-currency"></span>
                <%= allProductsUnpaidLabel %>
            </div>
        </div>
        <div class="dashboard-card">
            <div class="card-title">Total Unpaid (All Time)</div>
            <div class="card-value">
                <span class="card-currency"></span>
                <%= allProductsUnpaidAllTimeLabel %>
            </div>
        </div>
    </div>

    <!-- Chart.js Bar Chart for Product-wise Paid/Unpaid/Earnings -->
    <div style="width:100%; max-width:900px; margin:32px auto 0 auto;">
        <canvas id="productBarChart"></canvas>
    </div>

    <script>
        
        var ctx = document.getElementById('productBarChart').getContext('2d');
        var productBarChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: productLabels,
                datasets: [
                    {
                        label: 'Paid',
                        data: paidData,
                        backgroundColor: 'rgba(56, 142, 60, 0.7)'
                    },
                    {
                        label: 'Unpaid',
                        data: unpaidData,
                        backgroundColor: 'rgba(183, 28, 28, 0.7)'
                    },
                    {
                        label: 'Earnings',
                        data: earningsData,
                        backgroundColor: 'rgba(33, 150, 243, 0.7)'
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    title: { display: true, text: 'Product-wise Paid/Unpaid/Earnings' }
                },
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    </script>
</asp:Content>
