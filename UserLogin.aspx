<%@ Page Language="C#" AutoEventWireup="true" CodeFile="UserLogin.aspx.cs" Inherits="UserLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Login - Water System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700&display=swap" rel="stylesheet" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Lato', Arial, sans-serif;
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
            max-width: 450px;
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
            background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
        }

        .login-header h1 {
            font-size: 2em;
            margin-bottom: 10px;
            font-weight: 700;
        }

        .login-header p {
            font-size: 1em;
            opacity: 0.95;
        }

        .login-body {
            padding: 40px 30px;
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
            border-color: #2196f3;
            background: white;
            box-shadow: 0 0 0 4px rgba(33, 150, 243, 0.1);
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.4);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(33, 150, 243, 0.5);
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

        .login-footer {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e0e0e0;
        }

        .login-footer a {
            color: #2196f3;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-footer a:hover {
            color: #1565c0;
            text-decoration: underline;
        }

        .admin-link {
            text-align: center;
            margin-top: 20px;
        }

        .admin-link a {
            color: white;
            text-decoration: none;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 8px;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .admin-link a:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        @media (max-width: 600px) {
            .login-header h1 {
                font-size: 1.6em;
            }

            .login-body {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-header">
                <h1>Customer Portal</h1>
                <p>Welcome back! Please login to your account</p>
            </div>
            <div class="login-body">
                <asp:Label ID="lblError" runat="server" CssClass="error-message" Visible="false"></asp:Label>
                <asp:Label ID="lblSuccess" runat="server" CssClass="success-message" Visible="false"></asp:Label>

                <div class="form-group">
                    <label for="txtEmail">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email" required="required"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtMobile">Mobile Number</label>
                    <asp:TextBox ID="txtMobile" runat="server" TextMode="SingleLine" placeholder="Enter your mobile number" MaxLength="10" required="required"></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn-login" OnClick="btnLogin_Click" />

                <div class="login-footer">
                    <p>Need help? Contact your administrator</p>
                </div>
            </div>
        </div>

        <div class="admin-link">
            <a href="Login.aspx"><i class="fas fa-user-shield"></i> Admin Login</a>
        </div>
    </form>
</body>
</html>
