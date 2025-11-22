<%@ Page Title="Add Area" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Area_add.aspx.cs" Inherits="Water_Man_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" href="win.css" media="screen and (min-width: 601px)">
    <link rel="stylesheet" href="mob.css" media="screen and (max-width: 600px)">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
        
        /* Mobile responsive */
        @media (max-width: 600px) {
            .custom-alert {
                min-width: 280px;
                max-width: 95%;
                padding: 15px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- Mobile Topbar -->
    <div class="mobile-topbar">
        <span class="mobile-welcome">Add New Area</span>
        <a href="Settings.aspx"><span class="settings-icon"><i class="fas fa-cog"></i></span></a>
    </div>
    <div style="height:56px;"></div>

    <main class="main-content">
        <div class="main-header">Add New Area</div>
        <div class="form-container ">
            <asp:Panel ID="pnlAddArea" runat="server" CssClass="add-customer-form">
                <div class="form-group">
                    <label for="txtAreaName">Area Name</label>
                    <asp:TextBox ID="txtAreaName" runat="server" CssClass="form-control" placeholder="Enter area name" />
                </div>
                <div class="form-group">
                    <label for="txtsalesmanName">Salesman</label>
                    <asp:TextBox ID="txtsalesmanName" runat="server" CssClass="form-control" placeholder="Enter salesman name" />
                </div>
                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text=" Save" CssClass="btn-primary" OnClick="btnSave_Click1" OnClientClick="return validateAreaForm();" />
                    <asp:Button ID="btnClear" runat="server" Text=" Clear" CssClass="btn-secondary" CausesValidation="false" OnClick="btnClear_Click1" OnClientClick="return confirmClear();" />
                </div>
            </asp:Panel>
        </div>
    </main>

    <script>
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
                default: title = 'Information';
            }
            
            alertBox.innerHTML = 
                '<div class="alert-title">' + title + '</div>' +
                '<div class="alert-message">' + message + '</div>' +
                '<button class="alert-button" onclick="closeCustomAlert()">OK</button>';
            
            document.body.appendChild(overlay);
            document.body.appendChild(alertBox);
            
            window.alertCallback = callback;
        }

        function showConfirmAlert(message, callback) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            existingAlerts.forEach(alert => alert.remove());

            // Create overlay
            const overlay = document.createElement('div');
            overlay.className = 'alert-overlay';
            
            // Create alert box
            const alertBox = document.createElement('div');
            alertBox.className = 'custom-alert warning';
            
            alertBox.innerHTML = 
                '<div class="alert-title">Confirm Action</div>' +
                '<div class="alert-message">' + message + '</div>' +
                '<button class="alert-button" onclick="confirmAction(true)">Yes</button>' +
                '<button class="alert-button cancel" onclick="confirmAction(false)">Cancel</button>';
            
            document.body.appendChild(overlay);
            document.body.appendChild(alertBox);
            
            // Store callback for later use
            window.confirmCallback = callback;
        }

        function closeCustomAlert() {
            const alerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            alerts.forEach(alert => alert.remove());
            
            if (window.alertCallback) {
                window.alertCallback();
                window.alertCallback = null;
            }
        }

        function confirmAction(result) {
            const alerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            alerts.forEach(alert => alert.remove());
            
            if (window.confirmCallback) {
                window.confirmCallback(result);
                window.confirmCallback = null;
            }
        }

        // Validation Functions
        function validateAreaForm() {
            const areaName = document.getElementById('<%= txtAreaName.ClientID %>').value.trim();
            const salesmanName = document.getElementById('<%= txtsalesmanName.ClientID %>').value.trim();

            let errors = [];

            if (areaName === '') {
                errors.push('Area name is required');
            }

            if (salesmanName === '') {
                errors.push('Salesman name is required');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
        }

        function confirmClear() {
            const areaName = document.getElementById('<%= txtAreaName.ClientID %>').value.trim();
            const salesmanName = document.getElementById('<%= txtsalesmanName.ClientID %>').value.trim();
            
            if (areaName !== '' || salesmanName !== '') {
                showConfirmAlert('Are you sure you want to clear all fields?', function(result) {
                    if (result) {
                        // Proceed with clear
                        __doPostBack('<%= btnClear.UniqueID %>', '');
                    }
                });
                return false;
            }
            return true;
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

        function toggleSubmenu(submenuId) {
            const allSubmenus = document.querySelectorAll('.submenu, .bottom-nav__submenu');
            allSubmenus.forEach(menu => {
                if (menu.id !== submenuId) menu.classList.remove('visible');
        });
            const submenu = document.getElementById(submenuId);
        if (submenu) submenu.classList.toggle('visible');
        }
        
        function navigateTo(page) {
            window.location.href = page;
        }
    </script>
</asp:Content>
