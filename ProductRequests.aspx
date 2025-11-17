<%@ Page Title="Product Requests" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="ProductRequests.aspx.cs" Inherits="ProductRequests" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .page-container {
            padding: 30px;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }

        .page-header {
            font-size: 2.5em;
            font-weight: 700;
            color: #2196f3;
            margin-bottom: 30px;
            text-align: center;
        }

        .requests-table {
            width: 100%;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .requests-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .requests-table thead {
            background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
            color: white;
        }

        .requests-table th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .requests-table td {
            padding: 16px;
            border-bottom: 1px solid #f0f0f0;
        }

        .requests-table tbody tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
            display: inline-block;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .btn-action {
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            margin: 0 4px;
            transition: all 0.3s ease;
        }

        .btn-approve {
            background: #4caf50;
            color: white;
        }

        .btn-approve:hover {
            background: #45a049;
        }

        .btn-reject {
            background: #f44336;
            color: white;
        }

        .btn-reject:hover {
            background: #da190b;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 1.2em;
        }

        .no-data i {
            font-size: 3em;
            color: #ddd;
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-container">
        <h1 class="page-header"><i class="fas fa-clipboard-list"></i> Product Requests</h1>

        <div class="requests-table">
            <asp:Repeater ID="rptRequests" runat="server" OnItemCommand="rptRequests_ItemCommand">
                <HeaderTemplate>
                    <table>
                        <thead>
                            <tr>
                                <th>Request ID</th>
                                <th>Customer Name</th>
                                <th>Product</th>
                                <th>Quantity</th>
                                <th>Start Date</th>
                                <th>Notes</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>#<%# Eval("Request_Id") %></td>
                        <td><%# Eval("Customer_Name") %></td>
                        <td><%# Eval("Product_Name") %></td>
                        <td><%# Eval("Quantity") %></td>
                        <td><%# Convert.ToDateTime(Eval("Start_Date")).ToString("dd MMM yyyy") %></td>
                        <td><%# Eval("Notes") %></td>
                        <td>
                            <span class='status-badge status-<%# Eval("Status").ToString().ToLower() %>'>
                                <%# Eval("Status") %>
                            </span>
                        </td>
                        <td>
                            <asp:Button ID="btnApprove" runat="server" Text="Approve" 
                                CssClass="btn-action btn-approve" 
                                CommandName="Approve" 
                                CommandArgument='<%# Eval("Request_Id") %>'
                                Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                            <asp:Button ID="btnReject" runat="server" Text="Reject" 
                                CssClass="btn-action btn-reject" 
                                CommandName="Reject" 
                                CommandArgument='<%# Eval("Request_Id") %>'
                                Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                            <asp:Button ID="btnDelete" runat="server" Text="Delete" 
                                CssClass="btn-action btn-delete" 
                                CommandName="Delete" 
                                CommandArgument='<%# Eval("Request_Id") %>'
                                Visible='<%# Eval("Status").ToString() != "Pending" %>'
                                OnClientClick="return confirm('Are you sure you want to delete this request?');" />
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoData" runat="server" CssClass="no-data" Visible="false">
                <i class="fas fa-inbox"></i>
                <p>No product requests found</p>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
