<%@ Page Title="Customer Invoice Report" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="~/Reports.aspx.cs" Inherits="Water_Man_InvoiceReport" %>
<%@ Register Assembly="Microsoft.ReportViewer.WebForms" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            box-sizing: border-box;
        }

        .report-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #2196f3 100%);
            color: white;
            
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .page-header h2 {
            
            margin: 0;
            font-size: 2.5rem;
            font-weight: 300;
            letter-spacing: 1px;
        }

        .controls-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e1e5e9;
        }

        .section-title {
            font-size: 1.4rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #34495e;
            margin-bottom: 8px;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
            background: white;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            transform: translateY(-1px);
        }

        .form-control:hover {
            border-color: #bdc3c7;
            background: white;
        }

        .date-range-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
        }

        .btn-danger {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.3);
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #27ae60, #229954);
            color: white;
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.3);
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
        }

        .button-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .report-viewer-container {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e1e5e9;
        }

        .export-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border: 1px solid #e1e5e9;
            text-align: center;
        }

        /* Custom Alert Styles */
        .custom-alert {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            z-index: 10000;
            min-width: 300px;
            max-width: 90%;
            text-align: center;
        }
        
        .custom-alert.success {
            border-color: #4CAF50;
        }
        
        .custom-alert.error {
            border-color: #f44336;
        }
        
        .custom-alert.warning {
            border-color: #ff9800;
        }

        .custom-alert.info {
            border-color: #2196F3;
        }
        
        .custom-alert .alert-title {
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .custom-alert.success .alert-title {
            color: #4CAF50;
        }
        
        .custom-alert.error .alert-title {
            color: #f44336;
        }
        
        .custom-alert.warning .alert-title {
            color: #ff9800;
        }

        .custom-alert.info .alert-title {
            color: #2196F3;
        }
        
        .custom-alert .alert-message {
            margin-bottom: 15px;
            color: #333;
            white-space: pre-line;
        }
        
        .custom-alert .alert-button {
            background: #007bff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 5px;
        }
        
        .custom-alert .alert-button:hover {
            background: #0056b3;
        }
        
        .custom-alert .alert-button.cancel {
            background: #6c757d;
        }
        
        .custom-alert .alert-button.cancel:hover {
            background: #545b62;
        }
        
        .alert-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .report-container {
                padding: 15px;
            }

            .page-header {
                padding: 20px;
                margin-top:9vh;
            }

            .page-header h2 {
                font-size: 2rem;
            }

            .controls-section,
            .export-section {
                padding: 20px;
            }

            .form-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .date-range-group {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                width: 100%;
                margin-bottom: 10px;
            }

            /* Mobile responsive for alerts */
            .custom-alert {
                min-width: 280px;
                max-width: 95%;
                padding: 15px;
            }
        }

        @media (max-width: 480px) {
            .page-header h2 {
                font-size: 1.5rem;
            }

            .section-title {
                font-size: 1.2rem;
            }

            .controls-section,
            .export-section {
                padding: 15px;
            }
        }

        /* Hover Effects for Cards */
        .controls-section:hover,
        .export-section:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        }

        /* Focus States */
        .btn:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.3);
        }

    </style>

    <script type="text/javascript">
        // Custom Alert Functions
        function showCustomAlert(message, type, callback) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            existingAlerts.forEach(alert => alert.remove());

            // Create overlay
            const overlay = document.createElement('div');
            overlay.className = 'alert-overlay';
            
            // Create alert box
            const alertBox = document.createElement('div');
            alertBox.className = 'custom-alert ' + type;
            
            let title = '';
            switch(type) {
                case 'success': title = 'Success'; break;
                case 'error': title = 'Error'; break;
                case 'warning': title = 'Warning'; break;
                case 'info': title = 'Information'; break;
                default: title = 'Notification';
            }
            
            alertBox.innerHTML = 
                '<div class="alert-title">' + title + '</div>' +
                '<div class="alert-message">' + message + '</div>' +
                '<button class="alert-button" onclick="closeCustomAlert()">OK</button>';
            
            document.body.appendChild(overlay);
            document.body.appendChild(alertBox);
            
            // Store callback for later use
            window.alertCallback = callback;
        }

        function closeCustomAlert() {
            const alerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            alerts.forEach(alert => alert.remove());
            
            if (window.alertCallback) {
                window.alertCallback();
                window.alertCallback = null;
            }
        }

        // Server-side message functions
        function showSuccessMessage(message) {
            showCustomAlert(message, 'success');
        }

        function showErrorMessage(message) {
            showCustomAlert(message, 'error');
        }

        function showWarningMessage(message) {
            showCustomAlert(message, 'warning');
        }

        function showInfoMessage(message) {
            showCustomAlert(message, 'info');
        }

        // Client-side validation
        function validateForm() {
            const customer = document.getElementById('<%= ddlCustomers.ClientID %>').value;
            const startDate = document.getElementById('<%= txtStartDate.ClientID %>').value;
            const endDate = document.getElementById('<%= txtEndDate.ClientID %>').value;

            let errors = [];

            if (!customer) {
                errors.push('Please select a customer');
            }

            if (!startDate) {
                errors.push('Please select a start date');
            }

            if (!endDate) {
                errors.push('Please select an end date');
            }

            if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                errors.push('Start date cannot be greater than end date');
            }

            if (endDate && new Date(endDate) > new Date()) {
                errors.push('End date cannot be in the future');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
        }

        // Set max date to today for date inputs
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            const dateInputs = document.querySelectorAll('input[type="date"]');
            dateInputs.forEach(input => {
                input.setAttribute('max', today);
        });
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mobile-topbar">
        <span class="mobile-welcome">Report Master</span>
        <a href="Settings.aspx"><span class="settings-icon" ><i class="fas fa-cog"></i></span></a>
    </div>
    <div style="height: 56px;"></div>
    <main class="main-content ">
        <div class="main-header">Report Master</div>

        <!-- Report Controls Section -->
        <div class="controls-section">
            <h3 class="section-title">Report Filters</h3>
            <div class="form-grid">
                <div class="form-group">
                    <label for="<%= ddlCustomers.ClientID %>">Select Customer</label>
                    <asp:DropDownList ID="ddlCustomers" runat="server" AutoPostBack="true" 
                        OnSelectedIndexChanged="ddlCustomers_SelectedIndexChanged" 
                        CssClass="form-control" />
                </div>
                
                <div class="form-group">
                    
                    <div class="date-range-group">
                        <label>Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" 
                            CssClass="form-control" placeholder="Start Date" />
                        <label>End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" 
                            CssClass="form-control" placeholder="End Date" />
                    </div>
                </div>
            </div>
            
            <div class="button-group">
                <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" 
                    OnClick="btnGenerateReport_Click" CssClass="btn btn-primary" 
                    OnClientClick="return validateForm();" />
            </div>
        </div>

        <!-- Report Viewer Section -->
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="report-viewer-container" id="rpt1" style="display:none;" runat="server">
            <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="600px"
                ProcessingMode="Local" ShowExportControls="False">
            </rsweb:ReportViewer>
        </div>

        <!-- Export Section -->
        <div class="export-section" id="rptbtn1" style="display:none;" runat="server">
            <h3 class="section-title">Export Options</h3>
            <div class="button-group">
                <asp:Button ID="btnExportPDF" runat="server" Text="📄 Export to PDF" 
                    OnClick="btnExportPDF_Click" CssClass="btn btn-danger" Visible="False" />
                <asp:Button ID="btnExportExcel" runat="server" Text="📊 Export to Excel" 
                    OnClick="btnExportExcel_Click" CssClass="btn btn-success" Visible="False" />
                 <asp:Button ID="btnClearReport" runat="server" Text="Clear Report" 
                    OnClick="btnClearReport_Click" CssClass="btn btn-primary" />
            </div>
        </div>
    </main>
</asp:Content>