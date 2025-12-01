<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Water System - Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&display=swap" rel="stylesheet" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Lato', 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(120deg, #eaf6fb 0%, #c3e3eb 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.13);
            border-radius: 22px;
            box-shadow: 0 8px 32px rgba(33, 150, 243, 0.12);
            overflow: hidden;
            max-width: 500px;
            width: 100%;
            animation: slideIn 0.5s ease-out;
            backdrop-filter: blur(22px) saturate(180%);
            -webkit-backdrop-filter: blur(22px) saturate(180%);
            position: relative;
            z-index: 1;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-header {
            background: #2196f3;
            padding: 40px 30px;
            text-align: center;
            color: white;
        }

        .login-header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
            letter-spacing: 1px;
        }

        .login-header p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        .login-body {
            padding: 40px 30px;
        }

        .user-type-selector {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            background: #f8f9fa;
            padding: 5px;
            border-radius: 12px;
        }

        .user-type-btn {
            flex: 1;
            padding: 12px;
            border: none;
            background: transparent;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            color: #666;
            transition: all 0.3s ease;
        }

        .user-type-btn.active {
            background: white;
            color: #2196f3;
            box-shadow: 0 2px 8px rgba(33, 150, 243, 0.15);
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #183153;
            font-weight: 600;
            font-size: 0.95em;
        }

        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid rgba(33, 150, 243, 0.06);
            border-radius: 12px;
            font-size: 1em;
            font-family: 'Lato', Arial, sans-serif;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.8);
        }

        .form-group input:focus {
            border-color: #2196f3;
            outline: none;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }

        .password-input-container {
            position: relative;
            display: flex;
            align-items: center;
        }

        .password-field {
            width: 100%;
            padding-right: 45px !important;
        }

        .password-toggle-btn {
            position: absolute;
            right: 12px;
            background: none;
            border: none;
            color: #2196f3;
            cursor: pointer;
            padding: 8px;
            border-radius: 4px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .password-toggle-btn:hover {
            background: rgba(33, 150, 243, 0.1);
            color: #1976d2;
        }

        .password-toggle-btn:active {
            transform: scale(0.95);
        }

        .password-toggle-btn i {
            font-size: 14px;
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: #2196f3;
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 1.1em;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.2s;
            box-shadow: 0 2px 8px rgba(33, 150, 243, 0.15);
            letter-spacing: 1px;
        }

        .btn-login:hover {
            background: #1976d2;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(33, 150, 243, 0.25);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #c62828;
            font-size: 0.95em;
        }

        .success-message {
            background: #e8f5e9;
            color: #2e7d32;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2e7d32;
            font-size: 0.95em;
        }

        .help-text {
            text-align: center;
            margin-top: 25px;
            color: #6c8ca1;
            font-size: 0.9em;
        }

        @media (max-width: 600px) {
            .login-header h1 {
                font-size: 2em;
            }

            .login-body {
                padding: 30px 20px;
            }

            .user-type-selector {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="userType" name="userType" value="customer" runat="server" />
        <div class="login-container">
            <div class="login-header">
                <h1><i class="fas fa-tint"></i> Water System</h1>
                <p>Login to access your account</p>
            </div>
            <div class="login-body">
                <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <asp:Label ID="lblSuccess" runat="server" CssClass="success-message" Visible="false"></asp:Label>

                <div class="user-type-selector">
                    <button type="button" class="user-type-btn active" onclick="setUserType('customer')">
                        <i class="fas fa-user"></i> Customer
                    </button>
                    <button type="button" class="user-type-btn" onclick="setUserType('admin')">
                        <i class="fas fa-user-shield"></i> Admin
                    </button>
                </div>

                <!-- Customer Login Fields -->
                <div id="customerFields">
                    <div class="form-group">
                        <label for="txtMobile">Mobile Number</label>
                        <asp:TextBox ID="txtMobile" runat="server" placeholder="Enter your 10-digit mobile number" MaxLength="10"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtCustomerPassword">Password</label>
                        <div class="password-input-container">
                            <asp:TextBox ID="txtCustomerPassword" runat="server" TextMode="Password" placeholder="Enter your password" CssClass="password-field"></asp:TextBox>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('<%= txtCustomerPassword.ClientID %>', 'customerPasswordIcon')">
                                <i class="fas fa-eye" id="customerPasswordIcon"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Admin Login Fields -->
                <div id="adminFields" style="display: none;">
                    <div class="form-group">
                        <label for="txtUsername">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter your username"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtPassword">Password</label>
                        <div class="password-input-container">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password" CssClass="password-field"></asp:TextBox>
                            <button type="button" class="password-toggle-btn" onclick="togglePassword('<%= txtPassword.ClientID %>', 'adminPasswordIcon')">
                                <i class="fas fa-eye" id="adminPasswordIcon"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />

                <div class="help-text">
                    <p>Need help? Contact your administrator</p>
                </div>
            </div>
        </div>
    </form>

    <script>
        function setUserType(type) {
            const buttons = document.querySelectorAll('.user-type-btn');
            buttons.forEach(btn => btn.classList.remove('active'));
            
            // Set hidden field value
            document.getElementById('<%= userType.ClientID %>').value = type;
            
            if (type === 'customer') {
                buttons[0].classList.add('active');
                document.getElementById('customerFields').style.display = 'block';
                document.getElementById('adminFields').style.display = 'none';
                document.getElementById('<%= txtMobile.ClientID %>').required = true;
                document.getElementById('<%= txtCustomerPassword.ClientID %>').required = true;
                document.getElementById('<%= txtUsername.ClientID %>').required = false;
                document.getElementById('<%= txtPassword.ClientID %>').required = false;
            } else {
                buttons[1].classList.add('active');
                document.getElementById('customerFields').style.display = 'none';
                document.getElementById('adminFields').style.display = 'block';
                document.getElementById('<%= txtMobile.ClientID %>').required = false;
                document.getElementById('<%= txtCustomerPassword.ClientID %>').required = false;
                document.getElementById('<%= txtUsername.ClientID %>').required = true;
                document.getElementById('<%= txtPassword.ClientID %>').required = true;
            }
        }

        function togglePassword(fieldId, iconId) {
            const passwordField = document.getElementById(fieldId);
            const passwordIcon = document.getElementById(iconId);

            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                passwordIcon.classList.remove('fa-eye');
                passwordIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                passwordIcon.classList.remove('fa-eye-slash');
                passwordIcon.classList.add('fa-eye');
            }
        }

        // Set default to customer on page load
        document.addEventListener('DOMContentLoaded', function() {
            setUserType('customer');
        });
    </script>
</body>
</html>
