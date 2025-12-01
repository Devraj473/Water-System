<%@ Page Title="My Orders" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true"
    CodeFile="UserOrders.aspx.cs" Inherits="UserOrders" %>

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

            .filter-section {
                background: white;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 20px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            }

            .filter-row {
                display: flex;
                gap: 15px;
                align-items: end;
                flex-wrap: wrap;
            }

            .filter-group {
                flex: 1;
                min-width: 200px;
            }

            .filter-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 600;
            }

            .filter-group input,
            .filter-group select {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 1em;
            }

            .btn-filter {
                padding: 12px 30px;
                background: #2196f3;
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-filter:hover {
                background: #1565c0;
            }

            .orders-table {
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

            /* Only highlight body rows on hover — keep thead intact */
            tbody tr:hover {
                background: #f8f9fa;
                transition: background 180ms ease-in-out;
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

            .btn-download {
                padding: 8px 16px;
                background: #4caf50;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 0.9em;
            }

            .btn-download:hover {
                background: #2e7d32;
            }

            @media (max-width: 768px) {
                .orders-table {
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
            <h1><i class="fas fa-shopping-cart"></i> My Orders</h1>
            <p>View all your orders and transactions</p>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-row">
                <div class="filter-group">
                    <label>From Date</label>
                    <asp:TextBox ID="txtFromDate" runat="server" TextMode="Date"></asp:TextBox>
                </div>
                <div class="filter-group">
                    <label>To Date</label>
                    <asp:TextBox ID="txtToDate" runat="server" TextMode="Date"></asp:TextBox>
                </div>
                <div class="filter-group">
                    <label>Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Value="">All</asp:ListItem>
                        <asp:ListItem Value="Paid">Paid</asp:ListItem>
                        <asp:ListItem Value="Unpaid">Unpaid</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div>
                    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn-filter"
                        OnClick="btnFilter_Click" />
                </div>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="orders-table">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptOrders" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Convert.ToDateTime(Eval("Daily_Date")).ToString("dd MMM yyyy") %>
                                </td>
                                <td>
                                    <%# Eval("Product_Name") %>
                                </td>
                                <td>
                                    <%# Eval("Quantity") %>
                                </td>
                                <td>&#8377;<%# Convert.ToDecimal(Eval("Total_Amount")).ToString("N2") %>
                                </td>
                                <td>
                                    <span
                                        class='status-badge status-<%# Eval("Payment_Status").ToString().ToLower() %>'>
                                        <%# Eval("Payment_Status") %>
                                    </span>
                                </td>
                                <td>
                                    <asp:LinkButton ID="btnDownload" runat="server" CssClass="btn-download"
                                        CommandArgument='<%# Eval("CP_Id") %>' OnCommand="btnDownload_Command"
                                        Visible='<%# Eval("Payment_Status").ToString() == "Paid" %>'>
                                        <i class="fas fa-download"></i> Invoice
                                    </asp:LinkButton>
                                    <%# Eval("Payment_Status").ToString()=="Unpaid"
                                        ? "<span style='color: #999; font-style: italic;'>Not Available</span>" : "" %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            <asp:Panel ID="pnlNoData" runat="server" Visible="false"
                style="padding: 40px; text-align: center; color: #999;">
                <i class="fas fa-inbox" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
                <p>No orders found</p>
            </asp:Panel>
        </div>
    </asp:Content>