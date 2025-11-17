<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserInvoice.aspx.cs" Inherits="UserInvoice" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Invoice</title>
    <style>
        @media print {
            .no-print {
                display: none;
            }
        }

        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: #f5f5f5;
        }

        .invoice-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .invoice-header {
            text-align: center;
            border-bottom: 3px solid #2196f3;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .invoice-header h1 {
            color: #2196f3;
            margin: 0;
            font-size: 2.5em;
        }

        .invoice-header p {
            margin: 5px 0;
            color: #666;
        }

        .invoice-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .info-section h3 {
            color: #2196f3;
            margin-bottom: 10px;
            font-size: 1.1em;
        }

        .info-section p {
            margin: 5px 0;
            color: #333;
        }

        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        .invoice-table th {
            background: #2196f3;
            color: white;
            padding: 12px;
            text-align: left;
        }

        .invoice-table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        .invoice-table tr:last-child td {
            border-bottom: 2px solid #2196f3;
        }

        .total-section {
            text-align: right;
            margin-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: flex-end;
            gap: 20px;
            margin: 10px 0;
            font-size: 1.1em;
        }

        .total-row.grand-total {
            font-size: 1.5em;
            font-weight: bold;
            color: #2196f3;
            border-top: 2px solid #2196f3;
            padding-top: 10px;
        }

        .invoice-footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #ddd;
            color: #666;
        }

        .btn-print {
            background: #2196f3;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin: 10px;
        }

        .btn-print:hover {
            background: #1565c0;
        }

        .btn-back {
            background: #666;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin: 10px;
            text-decoration: none;
            display: inline-block;
        }

        .btn-back:hover {
            background: #444;
        }

        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
        }

        .status-paid {
            background: #4caf50;
            color: white;
        }

        .status-unpaid {
            background: #f44336;
            color: white;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="invoice-container">
            <div class="invoice-header">
                <h1>INVOICE</h1>
                <p>Water System</p>
                <p>Invoice #<asp:Label ID="lblInvoiceNumber" runat="server"></asp:Label></p>
            </div>

            <div class="invoice-info">
                <div class="info-section">
                    <h3>Bill To:</h3>
                    <p><strong><asp:Label ID="lblCustomerName" runat="server"></asp:Label></strong></p>
                    <p><asp:Label ID="lblCustomerAddress" runat="server"></asp:Label></p>
                    <p>Mobile: <asp:Label ID="lblCustomerMobile" runat="server"></asp:Label></p>
                    <p>Area: <asp:Label ID="lblCustomerArea" runat="server"></asp:Label></p>
                </div>

                <div class="info-section">
                    <h3>Invoice Details:</h3>
                    <p>Invoice Date: <asp:Label ID="lblInvoiceDate" runat="server"></asp:Label></p>
                    <p>Order Date: <asp:Label ID="lblOrderDate" runat="server"></asp:Label></p>
                    <p>Status: <span class="status-badge" id="statusBadge" runat="server"></span></p>
                </div>
            </div>

            <table class="invoice-table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Rate</th>
                        <th>Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><asp:Label ID="lblProductName" runat="server"></asp:Label></td>
                        <td><asp:Label ID="lblQuantity" runat="server"></asp:Label></td>
                        <td>&#8377;<asp:Label ID="lblRate" runat="server"></asp:Label></td>
                        <td>&#8377;<asp:Label ID="lblAmount" runat="server"></asp:Label></td>
                    </tr>
                </tbody>
            </table>

            <div class="total-section">
                <div class="total-row grand-total">
                    <span>Total Amount:</span>
                    <span>&#8377;<asp:Label ID="lblTotalAmount" runat="server"></asp:Label></span>
                </div>
            </div>

            <div class="invoice-footer">
                <p><strong>Thank you for your business!</strong></p>
                <p>For any queries, please contact your administrator</p>
            </div>

            <div class="no-print" style="text-align: center; margin-top: 30px;">
                <button type="button" class="btn-print" onclick="window.print()">
                    <i class="fas fa-print"></i> Print Invoice
                </button>
                <a href="UserOrders.aspx" class="btn-back">
                    <i class="fas fa-arrow-left"></i> Back to Orders
                </a>
            </div>
        </div>
    </form>
</body>
</html>
