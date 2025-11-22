<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserInvoice.aspx.cs" Inherits="UserInvoice" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Invoice - Om Sai Marketing</title>
    <style>
        @media print {
            .no-print {
                display: none;
            }
            .invoice-container {
                box-shadow: none;
                margin: 0;
                padding: 20px;
            }
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
            color: #404040;
        }

        .invoice-container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 0;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .invoice-header {
            padding: 30px 40px 20px;
            border-bottom: 2px solid #4472c4;
            background: white;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .company-info {
            flex: 1;
        }

        .company-info h1 {
            color: #4472c4;
            margin: 0 0 5px 0;
            font-size: 16pt;
            font-weight: bold;
        }

        .company-info h2 {
            color: #404040;
            margin: 0 0 10px 0;
            font-size: 12pt;
            font-weight: normal;
        }

        .company-contact {
            color: #404040;
            font-size: 9pt;
            margin: 0;
        }

        .invoice-title {
            text-align: right;
            flex: 1;
        }

        .invoice-title h1 {
            color: #4472c4;
            margin: 0;
            font-size: 16pt;
            font-weight: bold;
        }

        .invoice-body {
            padding: 30px 40px;
        }

        .info-sections {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .info-box {
            border: 1px solid #e0e0e0;
            background: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
        }

        .info-box h3 {
            color: #404040;
            margin: 0 0 15px 0;
            font-size: 11pt;
            font-weight: bold;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 10px;
        }

        .info-box p {
            margin: 8px 0;
            color: #404040;
            font-size: 9pt;
        }

        .info-box .customer-name {
            font-size: 11pt;
            font-weight: bold;
        }

        .invoice-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
            font-size: 9pt;
        }

        .invoice-table th {
            background: #4472c4;
            color: white;
            padding: 12px 8px;
            text-align: center;
            font-weight: bold;
            border: 1px solid #4472c4;
        }

        .invoice-table th:first-child {
            text-align: center;
            width: 50px;
        }

        .invoice-table th:nth-child(2) {
            text-align: left;
            width: auto;
        }

        .invoice-table th:nth-child(3),
        .invoice-table th:nth-child(4),
        .invoice-table th:nth-child(5),
        .invoice-table th:nth-child(6) {
            text-align: center;
            width: 100px;
        }

        .invoice-table td {
            padding: 12px 8px;
            border: 1px solid #e0e0e0;
            vertical-align: middle;
        }

        .invoice-table tr:nth-child(even) {
            background: #F9F9F9;
        }

        .invoice-table tr:nth-child(odd) {
            background: white;
        }

        .invoice-table td:first-child {
            text-align: center;
        }

        .invoice-table td:nth-child(2) {
            text-align: left;
        }

        .invoice-table td:nth-child(3),
        .invoice-table td:nth-child(4),
        .invoice-table td:nth-child(5),
        .invoice-table td:nth-child(6) {
            text-align: right;
        }

        .total-section {
            border: 1px solid #e0e0e0;
            background: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            width: 300px;
            margin-left: auto;
            margin-top: 20px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            align-items: center;
        }

        .total-row.grand-total {
            border-top: 1px solid #e0e0e0;
            padding-top: 15px;
            margin-top: 15px;
        }

        .total-row.grand-total .label {
            font-size: 11pt;
            font-weight: bold;
            color: #404040;
        }

        .total-row.grand-total .amount {
            font-size: 11pt;
            font-weight: bold;
            color: #4472c4;
        }

        .total-row .label {
            font-size: 9pt;
            font-weight: bold;
            color: #404040;
        }

        .total-row .amount {
            font-size: 9pt;
            font-weight: bold;
            color: #404040;
        }

        .salesman-info {
            margin: 20px 0;
            font-size: 9pt;
            color: #404040;
        }

        .thank-you {
            font-style: italic;
            font-size: 9pt;
            color: #404040;
            margin: 15px 0;
        }

        .invoice-footer {
            text-align: center;
            padding: 20px 40px;
            border-top: 1px solid #e0e0e0;
            background: #f9f9f9;
            font-size: 8pt;
            color: #404040;
        }

        .btn-print {
            background: #4472c4;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin: 10px;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        .btn-print:hover {
            background: #3560a8;
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
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        .btn-back:hover {
            background: #444;
        }

        .status-paid {
            color: Green;
            font-weight: bold;
        }

        .status-pending {
            color: Orange;
            font-weight: bold;
        }

        .status-unpaid {
            color: #404040;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="invoice-container">
            <!-- Invoice Header -->
            <div class="invoice-header">
                <div class="header-content">
                    <div class="company-info">
                        <h1>OM SAI MARKETING</h1>
                        <h2>RO WATER SUPPLIERS</h2>
                        <p class="company-contact">Mob: 98245 83875, 99334 29610</p>
                    </div>
                    <div class="invoice-title">
                        <h1>INVOICE</h1>
                    </div>
                </div>
            </div>

            <!-- Invoice Body -->
            <div class="invoice-body">
                <div class="info-sections">
                    <!-- Customer Information Box -->
                    <div class="info-box">
                        <h3>CUSTOMER INFORMATION</h3>
                        <p class="customer-name"><asp:Label ID="lblCustomerName" runat="server"></asp:Label></p>
                        <p><asp:Label ID="lblCustomerAddress" runat="server"></asp:Label></p>
                        <p>Area: <asp:Label ID="lblCustomerArea" runat="server"></asp:Label></p>
                        <p>Mobile: <asp:Label ID="lblCustomerMobile" runat="server"></asp:Label></p>
                    </div>

                    <!-- Invoice Details Box -->
                    <div class="info-box">
                        <h3>INVOICE DETAILS</h3>
                        <p>Invoice #: <asp:Label ID="lblInvoiceNumber" runat="server"></asp:Label></p>
                        <p>Invoice Date: <asp:Label ID="lblInvoiceDate" runat="server"></asp:Label></p>
                        <p>Order Date: <asp:Label ID="lblOrderDate" runat="server"></asp:Label></p>
                        <p>Status: <asp:Label ID="lblPaymentStatus" runat="server" CssClass="status-pending"></asp:Label></p>
                    </div>
                </div>

                <!-- Invoice Table -->
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Product Description</th>
                            <th>Quantity</th>
                            <th>Rate</th>
                            <th>Amount</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td><asp:Label ID="lblProductName" runat="server"></asp:Label></td>
                            <td><asp:Label ID="lblQuantity" runat="server"></asp:Label></td>
                            <td>&#8377;<asp:Label ID="lblRate" runat="server"></asp:Label></td>
                            <td>&#8377;<asp:Label ID="lblAmount" runat="server"></asp:Label></td>
                            <td><asp:Label ID="lblItemStatus" runat="server"></asp:Label></td>
                        </tr>
                    </tbody>
                </table>

                <!-- Total Section -->
                <div class="total-section">
                    <div class="total-row">
                        <span class="label">Subtotal</span>
                        <span class="amount">&#8377;<asp:Label ID="lblSubtotal" runat="server"></asp:Label></span>
                    </div>
                    <div class="total-row grand-total">
                        <span class="label">TOTAL</span>
                        <span class="amount">&#8377;<asp:Label ID="lblTotalAmount" runat="server"></asp:Label></span>
                    </div>
                </div>

                <!-- Additional Information -->
                <div class="salesman-info">
                    <p>Salesman: <asp:Label ID="lblSalesmanName" runat="server"></asp:Label></p>
                </div>

                <div class="thank-you">
                    <p>Thank you for your business!</p>
                </div>
            </div>

            <!-- Invoice Footer -->
            <div class="invoice-footer">
                <p>Workshop: Old Railway E Siding, 5th Galaxy Talkies, Jamnagar Ph: 0288 2550981 | Generated on: <asp:Label ID="lblGeneratedDate" runat="server"></asp:Label></p>
            </div>

            <!-- Print Buttons -->
            <div class="no-print" style="text-align: center; padding: 30px;">
                <button type="button" class="btn-print" onclick="window.print()">
                    Print Invoice
                </button>
                <a href="UserOrders.aspx" class="btn-back">
                    Back to Orders
                </a>
            </div>
        </div>
    </form>
</body>
</html>
