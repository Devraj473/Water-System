<%@ Page Title="Request Product" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true" CodeFile="UserRequest.aspx.cs" Inherits="UserRequest" %>

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

        .request-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .request-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 0.95em;
        }

        .form-group select,
        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 1em;
            font-family: 'Lato', Arial, sans-serif;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group select:focus,
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #2196f3;
            background: white;
            box-shadow: 0 0 0 4px rgba(33, 150, 243, 0.1);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #4caf50 0%, #2e7d32 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.4);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.5);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .alert-success {
            background: #e8f5e9;
            color: #2e7d32;
            border-left: 4px solid #2e7d32;
        }

        .alert-error {
            background: #ffebee;
            color: #c62828;
            border-left: 4px solid #c62828;
        }

        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .info-box i {
            color: #2196f3;
            margin-right: 10px;
        }

        .my-requests {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
            margin-top: 30px;
        }

        .section-title {
            font-size: 1.4em;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e0e0e0;
        }

        .request-item {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .request-item:last-child {
            border-bottom: none;
        }

        .request-info h4 {
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .request-date {
            color: #666;
            font-size: 0.9em;
        }

        .request-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 600;
        }

        .status-pending {
            background: #fff3e0;
            color: #e65100;
        }

        .status-approved {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .status-rejected {
            background: #ffebee;
            color: #c62828;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-header">
        <h1><i class="fas fa-plus-circle"></i> Request Product/Service</h1>
        <p>Submit a request for new products or services</p>
    </div>

    <div class="request-container">
        <div class="request-card">
            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                <strong>Note:</strong> Your request will be reviewed by our admin team. We'll contact you soon!
            </div>

            <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
            <asp:Label ID="lblError" runat="server" CssClass="alert alert-error" Visible="false"></asp:Label>

            <div class="form-group">
                <label>Select Product</label>
                <asp:DropDownList ID="ddlProduct" runat="server">
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label>Requested Quantity</label>
                <asp:TextBox ID="txtQuantity" runat="server" TextMode="Number" placeholder="Enter quantity" min="1"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Preferred Start Date</label>
                <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date"></asp:TextBox>
            </div>

            <div class="form-group">
                <label>Additional Notes (Optional)</label>
                <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" placeholder="Any special requirements or notes..."></asp:TextBox>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Request" CssClass="btn-submit" OnClick="btnSubmit_Click" />
        </div>

        
        <div class="my-requests">
            <h2 class="section-title">My Recent Requests</h2>
            <asp:Repeater ID="rptRequests" runat="server">
                <ItemTemplate>
                    <div class="request-item">
                        <div class="request-info">
                            <h4><%# Eval("Product_Name") %> - Qty: <%# Eval("Quantity") %></h4>
                            <div class="request-date">
                                <i class="far fa-calendar"></i> Requested on: <%# Convert.ToDateTime(Eval("Request_Date")).ToString("dd MMM yyyy") %>
                            </div>
                            <%# !string.IsNullOrEmpty(Eval("Notes").ToString()) ? 
                                "<div style='color: #666; margin-top: 5px;'><i class='fas fa-comment'></i> " + Eval("Notes") + "</div>" : "" %>
                        </div>
                        <div class='request-status status-<%# Eval("Status").ToString().ToLower() %>'>
                            <%# Eval("Status") %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Panel ID="pnlNoRequests" runat="server" Visible="false" style="text-align: center; padding: 40px; color: #999;">
                <i class="fas fa-inbox" style="font-size: 3em; margin-bottom: 15px; opacity: 0.5;"></i>
                <p>No requests yet</p>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
