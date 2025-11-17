<%@ Page Title="Settings" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Water_Man_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="win.css" rel="stylesheet" media="screen and (min-width: 601px)" />
    <link href="mob.css" rel="stylesheet" media="screen and (max-width: 600px)" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
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
    <!-- Mobile Topbar for mobile view -->
    <div class="mobile-topbar">
        <span class="mobile-welcome">Settings</span>
        <span class="settings-icon"><i class="fas fa-cog"></i></span>
    </div>
    

    <main class="main-content">
        <div class="main-header">Settings</div>
        <div class="form-container">
            <div class="form-group">
                <label for="old-password">Old Password</label>
                <asp:TextBox ID="txtOldPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter old password" />
            </div>
            <div class="form-group">
                <label for="new-password">New Password</label>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter new password" />
            </div>
            <div class="form-group">
                <label for="confirm-password">Confirm New Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Confirm new password" />
            </div>
            <div class="form-actions">
                <asp:Button ID="btnChangePassword" runat="server" Text="Change Password" CssClass="btn-primary" OnClick="btnChangePassword_Click" OnClientClick="return validatePasswordForm();" />
            </div>
            <%--<div class="form-group">
                <label for="theme-mode">Theme Mode</label>
                <asp:DropDownList ID="ddlTheme" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlTheme_SelectedIndexChanged">
                    <asp:ListItem Value="light">Light Mode</asp:ListItem>
                    <asp:ListItem Value="dark">Dark Mode</asp:ListItem>
                </asp:DropDownList>
            </div>--%>
            <div class="form-group">
                <label for="language">Language</label>
                <asp:DropDownList ID="ddlLanguage" runat="server" CssClass="form-control" AutoPostBack="true"
    OnSelectedIndexChanged="ddlLanguage_SelectedIndexChanged">
    <asp:ListItem Text="English" Value="en" />
    <asp:ListItem Text="Gujarati" Value="gu" />
    
</asp:DropDownList>

                <%--<asp:DropDownList ID="ddlLanguage" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="ddlLanguage_SelectedIndexChanged">
                    <asp:ListItem Value="en">English</asp:ListItem>
                    <asp:ListItem Value="gu">Gujarati</asp:ListItem>
                    <asp:ListItem Value="hi">Hindi</asp:ListItem>
                </asp:DropDownList>--%>
            </div>
        </div>
        <div style="height: 56px;"></div>
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

        // Password validation
        function validatePasswordForm() {
            const oldPassword = document.getElementById('<%= txtOldPassword.ClientID %>').value.trim();
            const newPassword = document.getElementById('<%= txtNewPassword.ClientID %>').value.trim();
            const confirmPassword = document.getElementById('<%= txtConfirmPassword.ClientID %>').value.trim();

            let errors = [];

            if (oldPassword === '') {
                errors.push('Old password is required');
            }

            if (newPassword === '') {
                errors.push('New password is required');
            } else if (newPassword.length < 6) {
                errors.push('New password must be at least 6 characters long');
            }

            if (confirmPassword === '') {
                errors.push('Confirm password is required');
            }

            if (newPassword !== '' && confirmPassword !== '' && newPassword !== confirmPassword) {
                errors.push('New password and confirm password do not match');
            }

            if (oldPassword !== '' && newPassword !== '' && oldPassword === newPassword) {
                errors.push('New password must be different from old password');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
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

    <script type="text/javascript">
        function setLanguageCookie(lang) {
            document.cookie = "SiteLanguage=" + lang + "; path=/";
        }

        function getLanguageCookie() {
            var nameEQ = "SiteLanguage=";
            var ca = document.cookie.split(';');
            for (var i = 0; i < ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length);
            }
            return null;
        }

        function changeGoogleLanguage(lang) {
            if (lang === "en") {
                // Clear translation back to original (English)
                var frame = document.querySelector("iframe.goog-te-banner-frame");
                if (frame) {
                    frame.contentWindow.document.querySelector("button").click();
                }
                return;
            }

            // Otherwise translate to selected language
            var tryCount = 0;
            var maxTries = 20;

            var interval = setInterval(function () {
                var combo = document.querySelector(".goog-te-combo");

                if (combo) {
                    combo.value = '';
                    combo.dispatchEvent(new Event("change"));

                    setTimeout(function () {
                        combo.value = lang;
                        combo.dispatchEvent(new Event("change"));
                    }, 100);

                    clearInterval(interval);
                }

                tryCount++;
                if (tryCount > maxTries) clearInterval(interval);
            }, 500);
        }
</script>

</asp:Content>
