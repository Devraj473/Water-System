<%@ Page Title="Payment History" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeFile="UserPayments.aspx.cs" Inherits="UserPayments" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 2em;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .summary-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .summary-card h3 {
            color: #666;
            font-size: 0.95em;
            margin-bottom: 10px;
        }

        .summary-card .amount {
            font-size: 2em;
            font-weight: 700;
            color: #2196f3;
        }

        .summary-card.paid .amount {
            color: #4caf50;
        }

        .summary-card.unpaid .amount {
            color: #f44336;
        }

        .payments-table {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
            color: white;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            display: inline-block;
        }

        .status-paid {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .status-unpaid {
            background: #ffebee;
            color: #c62828;
        }

        @media (max-width: 768px) {
            .payments-table {
                overflow-x: auto;
            }

            table {
                min-width: 600px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h1><i class="fas fa-credit-card"></i> Payment History</h1>
        <p>View all your payment transactions</p>
    </div>

    <!-- Summary Cards -->
    <div class="summary-cards">
        <div class="summary-card">
            <h3>Total Transactions</h3>
            <div class="amount">
                <asp:Label ID="lblTotalTransactions" runat="server" Text="0"></asp:Label>
            </div>
        </div>

        <div class="summary-card paid">
            <h3>Total Paid</h3>
            <div class="amount">
                &#8377;<asp:Label ID="lblTotalPaid" runat="server" Text="0.00"></asp:Label>
            </div>
        </div>

        <div class="summary-card unpaid">
            <h3>Total Unpaid</h3>
            <div class="amount">
                &#8377;<asp:Label ID="lblTotalUnpaid" runat="server" Text="0.00"></asp:Label>
            </div>
        </div>
    </div>

    <!-- Payments Table -->
    <div class="payments-table">
        <table>
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Amount</th>
                    <th>Status</th>
                    <th>Payment Date</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptPayments" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Convert.ToDateTime(Eval("Daily_Date")).ToString("dd MMM yyyy") %></td>
                            <td><%# Eval("Product_Name") %></td>
                            <td><%# Eval("Quantity") %></td>
                            <td>&#8377;<%# Convert.ToDecimal(Eval("Total_Amount")).ToString("N2") %></td>
                            <td>
                                <span class='status-badge status-<%# Eval("Payment_Status").ToString().ToLower() %>'>
                                    <%# Eval("Payment_Status") %>
                                </span>
                            </td>
                            <td>
                                <%# Eval("Payment_Date") != DBNull.Value ? 
                                    Convert.ToDateTime(Eval("Payment_Date")).ToString("dd MMM yyyy") : "-" %>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
        <asp:Panel ID="pnlNoData" runat="server" Visible="false" style="padding: 40px; text-align: center; color: #999;">
            <i class="fas fa-inbox" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
            <p>No payment records found</p>
        </asp:Panel>
    </div>
</asp:Content>
