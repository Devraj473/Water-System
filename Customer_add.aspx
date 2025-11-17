<%@ Page Title="Add New Customer" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Customer_add.aspx.cs" Inherits="Water_Man_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="win.css" rel="stylesheet" media="screen and (min-width: 601px)" />
    <link href="mob.css" rel="stylesheet" media="screen and (max-width: 600px)" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .success { color: green; font-weight: bold; }
        .error { color: red; font-size: 12px; }
        

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
            text-align: center;
        }
        
        .custom-alert.success {
            border-color: #4CAF50;
        }
        
        .custom-alert.error {
            border-color: #f44336;
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
        
        .custom-alert .alert-message {
            margin-bottom: 15px;
            color: #333;
        }
        
        .custom-alert .alert-button {
            background: #007bff;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .custom-alert .alert-button:hover {
            background: #0056b3;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- Mobile Topbar -->
    <div class="mobile-topbar">
        <span class="mobile-welcome">Add New Customer</span>
        <a href="Settings.aspx"><span class="settings-icon"><i class="fas fa-cog"></i></span></a>
    </div>

    <main class="main-content">
        <div class="main-header">Add New Customer</div>
        <div class="form-container">
            <asp:Panel ID="pnlCustomer" runat="server" CssClass="add-customer-form">
                <div class="form-group">
                    <label for="txtName">Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtAddress1">Address</label>
                    <asp:TextBox ID="txtAddress1" runat="server" CssClass="form-control" />
                </div>
                <div class="form-group">
                    <label for="txtMobile">Mobile No</label>
                    <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="10" />
                </div>
                <div class="form-group">
                    <label for="txtJoinDate">Join Date</label>
                    <asp:TextBox ID="txtJoinDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="form-group">
                    <label for="ddlArea">Area</label>
                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Select Area" Value="" />
                    </asp:DropDownList>
                </div>
                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn-primary" OnClick="btnSave_Click" OnClientClick="return validateForm();" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn-secondary" CausesValidation="false" OnClick="btnClear_Click" />
                </div>
            </asp:Panel>
        </div>
    </main>

    
    <script>
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

        // Custom Alert Function
        function showCustomAlert(message, type, callback) {
            // Remove existing alerts
            const existingAlerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            existingAlerts.forEach(alert => alert.remove());

            // Create overlay
            const overlay = document.createElement('div');
            overlay.className = 'alert-overlay';
            
            // Create alert box
            const alertBox = document.createElement('div');
            alertBox.className = `custom-alert ${type}`;
            
            const title = type === 'success' ? 'Success' : 'Validation Error';
            
            alertBox.innerHTML = `
                <div class="alert-title">${title}</div>
                <div class="alert-message">${message}</div>
                <button class="alert-button" onclick="closeCustomAlert()">OK</button>
            `;
            
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

        // Form Validation Function
        function validateForm() {
            const name = document.getElementById('<%= txtName.ClientID %>').value.trim();
            const address = document.getElementById('<%= txtAddress1.ClientID %>').value.trim();
            const mobile = document.getElementById('<%= txtMobile.ClientID %>').value.trim();
            const joinDate = document.getElementById('<%= txtJoinDate.ClientID %>').value.trim();
            const area = document.getElementById('<%= ddlArea.ClientID %>').value;

            let errors = [];

            if (name === '') {
                errors.push('Name is required');
            }

            if (address === '') {
                errors.push('Address is required');
            }

            if (mobile === '') {
                errors.push('Mobile No is required');
            } else if (!/^[0-9]{10}$/.test(mobile)) {
                errors.push('Enter valid 10-digit mobile number');
            }

            if (joinDate === '') {
                errors.push('Join Date is required');
            }

            if (area === '') {
                errors.push('Please select an Area');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
        }

        // Function to show success message from server
        function showSuccessMessage(message) {
            showCustomAlert(message, 'success');
        }

        // Function to show error message from server
        function showErrorMessage(message) {
            showCustomAlert(message, 'error');
        }
    </script>
</asp:Content>
