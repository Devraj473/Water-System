<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true"
    CodeFile="Transaction_Master.aspx.cs" Inherits="Water_Man_Transaction_Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="win.css" media="screen and (min-width: 601px)">
    <link rel="stylesheet" href="mob.css" media="screen and (max-width: 600px)">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="css/main_css.css" rel="stylesheet" />
    <style>
        /* Modern ASP.NET Control Styling */
        
        /* DropDownList Styling */
        select[id*="ddl"], select[id*="DropDown"] {
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background: #fff url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 5"><path fill="%23666" d="M2 0L0 2h4zm0 5L0 3h4z"/></svg>') no-repeat right 12px center;
            background-size: 12px;
            padding: 14px 40px 14px 16px;
            border: 2px solid #2196f3;
            border-radius: 12px;
            font-size: 1em;
            color: #183153;
            font-family: 'Lato', Arial, sans-serif;
            font-weight: 500;
            box-shadow: 0 4px 16px rgba(33, 150, 243, 0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            min-width: 200px;
        }
        
        select[id*="ddl"]:focus, select[id*="DropDown"]:focus {
            outline: none;
            border-color: #1565c0;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.15);
            transform: translateY(-1px);
        }
        
        select[id*="ddl"]:hover, select[id*="DropDown"]:hover {
            border-color: #1976d2;
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.12);
        }
        
        /* TextBox Styling */
         input[type="date"], input[type="number"] {
            padding: 14px 16px;
            border: 2px solid #2196f3;
            border-radius: 12px;
            font-size: 1em;
            color: #183153;
            background: #fff;
            font-family: 'Lato', Arial, sans-serif;
            font-weight: 500;
            box-shadow: 0 4px 16px rgba(33, 150, 243, 0.08);
            transition: all 0.3s ease;
            min-width: 200px;
        }
        
        input[type="text"]:focus, input[type="date"]:focus, input[type="number"]:focus {
            outline: none;
            border-color: #1565c0;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.15);
            transform: translateY(-1px);
        }
        
        input[type="text"]:hover, input[type="date"]:hover, input[type="number"]:hover {
            border-color: #1976d2;
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.12);
        }
        
        input[type="text"][readonly] {
            width: 60%;
        border: 2px solid #0094ff;
        border-radius: 8px;
        padding:15px;
            cursor: not-allowed;
            
        }
        
        /* Button Styling */
        input[type="submit"], input[type="button"], button, .aspNetButton {
            background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 14px 28px;
            font-size: 1em;
            font-weight: 600;
            font-family: 'Lato', Arial, sans-serif;
            cursor: pointer;
            box-shadow: 0 4px 16px rgba(33, 150, 243, 0.3);
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
            width:14vw;
        }
        
        input[type="submit"]:hover, input[type="button"]:hover, button:hover, .aspNetButton:hover {
            background: linear-gradient(135deg, #1976d2 0%, #1565c0 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(33, 150, 243, 0.4);

        }
        
        input[type="submit"]:active, input[type="button"]:active, button:active, .aspNetButton:active {
            transform: translateY(0);
            box-shadow: 0 4px 16px rgba(33, 150, 243, 0.3);
        }
        
        /* Secondary Button Styling */
        .btn-secondary, input[value="Clear Filter"], input[value="Cancel"] {
            background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%) !important;
            color: #183153 !important;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1) !important;
        }
        
        .btn-secondary:hover, input[value="Clear Filter"]:hover, input[value="Cancel"]:hover {
            background: linear-gradient(135deg, #e0e0e0 0%, #bdbdbd 100%) !important;
            color: #183153 !important;
        }
        
        /* Edit Button Styling */
        input[value="Edit"] {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%) !important;
            padding: 8px 16px !important;
            font-size: 0.9em !important;
        }
        
        input[value="Edit"]:hover {
            background: linear-gradient(135deg, #f57c00 0%, #ef6c00 100%) !important;
        }
        
        /* Update Button Styling */
        input[value="Update"] {
            background: linear-gradient(135deg, #4caf50 0%, #388e3c 100%) !important;
            padding: 8px 16px !important;
            font-size: 0.9em !important;
        }
        
        input[value="Update"]:hover {
            background: linear-gradient(135deg, #388e3c 0%, #2e7d32 100%) !important;
        }
        
        /* Label Styling */
        label, .aspNetLabel {
            font-weight: 600;
            color: #183153;
            font-size: 1em;
            font-family: 'Lato', Arial, sans-serif;
            margin-bottom: 8px;
            display: block;
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
        
        /* Main content container */
        .main-content-container {
            padding: 24px;
            background: linear-gradient(120deg, #eaf6fb 0%, #c3e3eb 100%);
            min-height: 100vh;
            font-family: 'Lato', Arial, sans-serif;
        }
        
        /* Page header */
        .page-header {
            font-size: 2.5em;
            font-weight: 700;
            color: #2196f3;
            margin-bottom: 32px;
            letter-spacing: 1px;
            text-align: center;
            text-shadow: 0 2px 4px rgba(33, 150, 243, 0.2);
        }
        
        /* Customer group styling */
        .customer-group {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
            margin: 24px 0;
            padding: 24px;
            border: 1px solid rgba(33, 150, 243, 0.1);
            position: relative;
            overflow: hidden;
        }
        
        .customer-group::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #2196f3 0%, #21cbf3 100%);
        }
        
        .customer-group h3 {
            color: #2196f3;
            font-size: 1.4em;
            margin-bottom: 20px;
            font-weight: 700;
            display: flex;
            align-items: center;
        }
        
        .customer-group h3 i {
            margin-right: 12px;
            font-size: 1.2em;
        }
        
        /* Modern filter section */
        .filter-section {
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            padding: 28px;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(33, 150, 243, 0.1);
            margin-bottom: 28px;
            border: 1px solid rgba(33, 150, 243, 0.1);
        }
        
        .filter-section::before {
            content: 'Filters';
            display: block;
            font-size: 1.2em;
            font-weight: 700;
            color: #2196f3;
            margin-bottom: 20px;
        }
        
        .filter-controls {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            align-items: end;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
        }
        
        .filter-group label {
            font-weight: 600;
            color: #183153;
            margin-bottom: 8px;
            font-size: 1em;
        }
        
        /* Customer table styling */
        .customer-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 20px;
        }
        
        .customer-table thead tr {
            background: linear-gradient(135deg, #2196f3 0%, #1976d2 100%);
            color: #fff;
        }
        
        .customer-table th {
            padding: 16px 20px;
            text-align: left;
            font-size: 1em;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .customer-table td {
            padding: 16px 20px;
            font-size: 1em;
            border-bottom: 1px solid #f0f0f0;
            transition: background 0.2s;
        }
        
        .customer-table tbody tr {
            background: #fff;
            transition: all 0.2s;
        }
        
        .customer-table tbody tr:hover {
            background: linear-gradient(135deg, #f6fbff 0%, #e3f2fd 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.1);
        }
        
        .customer-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* Footer row styling */
        .footer-row {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%) !important;
            font-weight: 700 !important;
            color: #2196f3 !important;
        }
        
        .footer-row td {
            border-top: 2px solid #2196f3 !important;
            font-size: 1.1em !important;
            font-weight: 700 !important;
        }
        
        /* Add product section styling */
        .add-product-section {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            padding: 20px;
            border-radius: 12px;
            margin-top: 16px;
            border: 1px solid #2196f3;
            position: relative;
        }
        
        .add-product-section b i {
            margin-right: 8px;
            color: #2196f3;
        }
        
        .add-product-section b {
            color: #1565c0;
            font-size: 1.1em;
            display: block;
            margin-bottom: 12px;
        }
        
        .add-product-controls {
            display: grid;
            grid-template-columns: 2fr auto 1fr auto;
            gap: 16px;
            align-items: center;
        }
        
        .add-product-controls select,
        .add-product-controls input {
            padding: 12px 16px;
            border: 2px solid #1976d2;
            border-radius: 8px;
            font-size: 1em;
            background: white;
            color:black;
        }
        
        .add-product-controls button {
            padding: 12px 20px;
            background: linear-gradient(135deg, #1976d2 0%, #1565c0 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .add-product-controls button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(25, 118, 210, 0.4);
        }
        
        /* Edit input styling */
        .edit-input {
            width: 80px !important;
            padding: 8px 12px !important;
            border: 2px solid #ff9800 !important;
            border-radius: 6px !important;
            font-size: 0.95em !important;
            text-align: center !important;
            background: #fff3e0 !important;
        }
        
        .edit-input:focus {
            outline: none !important;
            border-color: #f57c00 !important;
            box-shadow: 0 0 0 2px rgba(255, 152, 0, 0.2) !important;
        }
        
        /* Mobile responsive adjustments */
        @media (max-width: 600px) {
            .main-content-container {
                padding: 16px 8px 80px 8px;
            }
            .edit-input {
            
            width:9vw;}
            .page-header {
                font-size: 1.8em;
                margin-bottom: 20px;
                display:none;
                
            }
            
            .filter-section {
                padding: 20px 16px;
                margin-top:7vh;
            }
            
            .filter-controls {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            
            .customer-group {
                width:90vw;

            }
            
            .add-product-controls {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            .add-product-controls select,
            .add-product-controls input,
            .add-product-controls button {
                width: 100%;
            }
            
            /* Mobile table styling */
            .customer-table {
                border-collapse: separate;
                border-spacing: 0 8px;
                background: none;
                box-shadow: none;
                width:90vw;
            }
            .customer-table thead {
                display: none;
            }
            
            .customer-table tbody tr {
                display: block;
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                margin-bottom: 16px;
                border-radius: 12px;
                box-shadow: 0 4px 16px rgba(0,0,0,0.1);
                width:85vw;
                border: 1px solid rgba(33, 150, 243, 0.1);
            }
            
            .customer-table td {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 20px;
                border: none;
                font-size: 1em;
                position: relative;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .customer-table td:last-child {
                border-bottom: none;
            }
            
            .customer-table td:before {
                content: attr(data-label);
                font-weight: 700;
                color: #2196f3;
                min-width: 120px;
                text-align: left;
            }
            
            /* Hide date column in mobile footer */
            .customer-table .footer-row td:nth-child(4) {
                display: none !important;
            }
            
            /* Mobile button adjustments */
            input[type="submit"], input[type="button"], button {
                padding: 12px 20px;
                font-size: 0.95em;
                margin: 4px;
                color:black;
                width:85vw;     
            }
            
            select[id*="ddl"], select[id*="DropDown"],
            input[type="date"], input[type="number"] {
                min-width: 88%;
                padding: 12px 16px;
            }
            
            /* Mobile responsive for alerts */
            .custom-alert {
                min-width: 280px;
                max-width: 95%;
                padding: 15px;
            }
        }
        
        /* Loading animation for buttons */
        .loading {
            position: relative;
            pointer-events: none;
        }
        
        .loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            margin: auto;
            border: 2px solid transparent;
            border-top-color: #ffffff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            top: 0;
            left: 0;
            bottom: 0;
            right: 0;
        }

 
  
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Mobile navigation */
        .bottom-nav {
            position: fixed;
            left: 0;
            right: 0;
            bottom: 0;
            height: 70px;
            background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
            box-shadow: 0 -4px 20px rgba(33,150,243,0.15);
            display: none;
            justify-content: space-around;
            align-items: center;
            z-index: 1000;
            border-top: 2px solid #2196f3;
            backdrop-filter: blur(10px);
        }

        
        @media (max-width: 600px) {
            .bottom-nav {
                display: flex;
            }
     
      }
        
        input[type="text"] {
        width: 50%;
        border: 2px solid #0094ff;
        border-radius: 8px;
        padding:10px;
        }
        
        .bottom-nav__item {
            flex: 1;
            text-align: center;
            color: #6c8ca1;
            font-size: 0.85em;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            cursor: pointer;
            padding: 8px 4px;
            border-radius: 12px;
            margin: 0 4px;
        }
        
        .bottom-nav__item.active {
            color: #2196f3;
            font-weight: 700;
            background: rgba(33, 150, 243, 0.1);
        }
        
        .bottom-nav__icon {
            font-size: 1.5em;
            display: block;
            margin-bottom: 4px;
            transition: transform 0.3s ease;
        }
        
        
        .bottom-nav__item:active .bottom-nav__icon {
            transform: scale(1.2);
        }
    </style>
    <script type="text/javascript">
        function setMaxDateToday(id) {
            var today = new Date().toISOString().split('T')[0];
            var el = document.getElementById(id);
            if (el) el.setAttribute('max', today);
        }
        window.onload = function () {
            setMaxDateToday('<%= txtDateFilter.ClientID %>');
            var dateInputs = document.querySelectorAll("input[type='date']");
            for (var i = 0; i < dateInputs.length; i++) {
                dateInputs[i].setAttribute('max', new Date().toISOString().split('T')[0]);
            }
        };

            // Custom Alert Functions
            function showCustomAlert(message, type, callback) {
                // Remove existing alerts
                const existingAlerts = document.querySelectorAll('.custom-alert, .alert-overlay');
                existingAlerts.forEach(alert => alert.remove());

                // Create overlay
                const overlay = document.createElement('div');
                overlay.className = 'alert-overlay';
                overlay.onclick = function() { closeCustomAlert(); };
            
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
                    '<button class="alert-button" id="alertOkButton">OK</button>';
            
                document.body.appendChild(overlay);
                document.body.appendChild(alertBox);
            
                // Add event listener to OK button
                setTimeout(function() {
                    const okButton = document.getElementById('alertOkButton');
                    if (okButton) {
                        okButton.onclick = function() { closeCustomAlert(); };
                        okButton.focus();
                    }
                }, 10);
            
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

            function validateQty(input) {
                var val = input.value;
                if (!/^[1-9][0-9]*$/.test(val)) {
                    showCustomAlert('Please enter a valid positive quantity.', 'error');
                    input.value = '';
                    input.focus();
                    return false;
                }
                return true;
            }
    
            // Add loading animation to buttons
            function addLoadingToButton(button) {
                button.classList.add('loading');
                setTimeout(() => {
                    button.classList.remove('loading');
            }, 2000);
            }
    
            // Add click handlers for loading animation
            document.addEventListener('DOMContentLoaded', function() {
                var buttons = document.querySelectorAll('input[type="submit"], input[type="button"], button');
                buttons.forEach(function(button) {
                    button.addEventListener('click', function() {
                        addLoadingToButton(this);
                    });
                });
            });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mobile-topbar">
        <span class="mobile-welcome">Transaction Master</span>
        <a href="Settings.aspx"><span class="settings-icon"><i class="fas fa-cog"></i></span></a>
    </div>
    <div style="height: 56px;"></div>
    <main class="main-content ">
        <div class="main-header">Transaction Master</div>
<%--    <div class="main-content-container">
        <div class="page-header">Transaction Master</div>--%>
        
        
        <!-- Updated Filter Section -->
<div class="filter-section-buttons">
    <div class="filter-controls">
        
        <div class="filter-group">
            <label for="<%= ddlAreaFilter.ClientID %>"><i class="fas fa-map-marker-alt"></i> Select Area</label>
            <asp:DropDownList ID="ddlAreaFilter" runat="server" />
        </div>

        <div class="filter-group">
            <label for="<%= txtDateFilter.ClientID %>"><i class="far fa-calendar"></i> Select Date</label>
            <asp:TextBox ID="txtDateFilter" runat="server" />
        </div>

        <div class="filter-group">
            <label for="<%= txtSalesman.ClientID %>"><i class="fas fa-user-tie"></i> Salesman Info</label>
            <asp:TextBox ID="txtSalesman" runat="server" ReadOnly="true" />
        </div>

        <div class="button-group">
            <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn-filterforme" OnClick="btnFilter_Click" />
            <asp:Button ID="btnClear" runat="server" Text="Clear Filter" OnClick="btnClear_Click" CssClass="btn-secondary" />
        </div>

    </div>
</div>
        
        <!-- Removed lblMessage as it's no longer needed -->

        <!-- Customer Data -->
        <asp:Repeater ID="rptCustomers" runat="server" OnItemCommand="rptCustomers_ItemCommand" OnItemDataBound="rptCustomers_ItemDataBound">
            <ItemTemplate>
                <div class="customer-group">
                    <h3><i class="fas fa-user"></i> <%# Eval("Name") %> (ID: <%# Eval("Customer_Id") %>)</h3>
                    <asp:HiddenField ID="hfCustomerID" runat="server" Value='<%# Eval("Customer_Id") %>' />
                    
                    <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand" OnItemDataBound="rptProducts_ItemDataBound">
                        <HeaderTemplate>
                            <table class="customer-table">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-box"></i> Product</th>
                                        <th><i class="fas fa-cubes"></i> Quantity</th>
                                        <th><i class="fas fa-rupee-sign"></i> Total Amount</th>
                                        <th><i class="far fa-calendar"></i> Date</th>
                                        <th><i class="fas fa-cog"></i> Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td data-label="Product"><%# Eval("Product_Name") %></td>
                                <td data-label="Quantity">
                                    <asp:Label ID="lblQty" runat="server" Text='<%# Eval("Quantity") %>' Visible='<%# !(bool)Eval("IsEdit") %>' />
                                    <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Quantity") %>' CssClass="edit-input" Visible='<%# (bool)Eval("IsEdit") %>' onblur="validateQty(this);" />
                                </td>
                                <td data-label="Total Amount">&#8377;<%# Eval("Total_Amount", "{0:F2}") %></td>
                                <td data-label="Date"><%# Eval("Daily_Date", "{0:dd-MM-yyyy}") %></td>
                                <td data-label="Action">
                                    <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="Edit" Visible='<%# !(bool)Eval("IsEdit") %>' />
                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CommandName="Update" Visible='<%# (bool)Eval("IsEdit") %>' />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="Cancel" Visible='<%# (bool)Eval("IsEdit") %>' CssClass="btn-secondary" />
                                    <asp:HiddenField ID="hfCPId" runat="server" Value='<%# Eval("CP_Id") %>' />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                <tr class="footer-row">
                                    <td data-label="Total">GRAND TOTAL</td>
                                    <td data-label="Total Quantity"><asp:Label ID="lblFooterTotalQty" runat="server" /></td>
                                    <td data-label="Total Amount">&#8377;<asp:Label ID="lblFooterTotalAmt" runat="server" /></td>
                                    <td style="display: none;"></td>
                                    <td></td>
                                </tr>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    
                    <!-- Add Product Section -->
                    <div class="add-product-section">
                        <b><i class="fas fa-plus-circle"></i> Add New Product</b>
                        <div class="add-product-controls">
                            <asp:DropDownList ID="ddlAddProduct" runat="server" />
                            <label><i class="fas fa-cubes"></i> Quantity:</label>
                            <asp:TextBox ID="txtAddQty" runat="server" onblur="validateQty(this);" placeholder="Enter quantity" />
                            <asp:Button ID="btnAddProduct" runat="server" Text="Add Product" CommandName="AddProduct" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    
    <script>
        // Add data-labels for mobile view - excluding date from footer
        document.addEventListener('DOMContentLoaded', function() {
            if(window.innerWidth <= 600) {
                var headers = ['Product', 'Quantity', 'Total Amount', 'Date', 'Action'];
                document.querySelectorAll('.customer-table tbody tr:not(.footer-row)').forEach(function(row) {
                    row.querySelectorAll('td').forEach(function(cell, i) {
                        if (!cell.getAttribute('data-label')) {
                            cell.setAttribute('data-label', headers[i]);
                        }
                    });
                });
                
                // Special handling for footer row - only show first 3 columns
                document.querySelectorAll('.customer-table .footer-row').forEach(function(row) {
                    var footerHeaders = ['Total', 'Total Quantity', 'Total Amount'];
                    row.querySelectorAll('td').forEach(function(cell, i) {
                        if (i < 3 && !cell.getAttribute('data-label')) {
                            cell.setAttribute('data-label', footerHeaders[i]);
                        }
                    });
                });
            }
        });
    </script>
</asp:Content>