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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .login-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            max-width: 500px;
            width: 100%;
            animation: slideIn 0.5s ease-out;
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }

        .login-header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 700;
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
            color: #667eea;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
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

        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            font-size: 1em;
            font-family: 'Lato', Arial, sans-serif;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
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
            color: #666;
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
                        <label for="txtEmail">Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtMobile">Mobile Number</label>
                        <asp:TextBox ID="txtMobile" runat="server" placeholder="Enter your 10-digit mobile number" MaxLength="10"></asp:TextBox>
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
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
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
                document.getElementById('<%= txtEmail.ClientID %>').required = true;
                document.getElementById('<%= txtMobile.ClientID %>').required = true;
                document.getElementById('<%= txtUsername.ClientID %>').required = false;
                document.getElementById('<%= txtPassword.ClientID %>').required = false;
            } else {
                buttons[1].classList.add('active');
                document.getElementById('customerFields').style.display = 'none';
                document.getElementById('adminFields').style.display = 'block';
                document.getElementById('<%= txtEmail.ClientID %>').required = false;
                document.getElementById('<%= txtMobile.ClientID %>').required = false;
                document.getElementById('<%= txtUsername.ClientID %>').required = true;
                document.getElementById('<%= txtPassword.ClientID %>').required = true;
            }
        }

        // Set default to customer on page load
        document.addEventListener('DOMContentLoaded', function() {
            setUserType('customer');
        });
    </script>
</body>
</html>
