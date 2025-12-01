<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/user.master" AutoEventWireup="true"
    CodeFile="UserProfile.aspx.cs" Inherits="UserProfile" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
            .page-header {
                margin-bottom: 30px;
            }

            .page-header h1 {
                font-size: 2em;
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .profile-container {
                max-width: 800px;
                margin: 0 auto;
            }

            .profile-card {
                background: white;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
                margin-bottom: 20px;
            }

            .profile-header {
                text-align: center;
                padding-bottom: 30px;
                border-bottom: 2px solid #e0e0e0;
                margin-bottom: 30px;
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3em;
                margin: 0 auto 15px;
            }

            .profile-name {
                font-size: 1.8em;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 5px;
            }

            .section-title {
                font-size: 1.3em;
                font-weight: 700;
                color: #2c3e50;
                margin: 35px 0 15px;
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

            .form-group input,
            .form-group textarea {
                width: 100%;
                padding: 14px 16px;
                border: 2px solid #e0e0e0;
                border-radius: 12px;
                font-size: 1em;
                font-family: 'Lato', Arial, sans-serif;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }

            .form-group input:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: #2196f3;
                background: white;
                box-shadow: 0 0 0 4px rgba(33, 150, 243, 0.1);
            }

            .form-group input:disabled {
                background: #e9ecef;
                cursor: not-allowed;
            }

            .form-group textarea {
                min-height: 100px;
                resize: vertical;
            }

            .btn-update {
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

            .btn-update:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(33, 150, 243, 0.5);
            }

            .alert {
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .alert-success {
                background: #e8f5e9;
                color: #2e7d32;
                border-left: 4px solid #2e7d32;
            }

            .alert-error {
                background: #ffebee;
                color: #c62828;
                border-left: 4px solid #c62828;
            }

            .info-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="page-header">
            <h1><i class="fas fa-user"></i> My Profile</h1>
            <p>View and update your account information</p>
        </div>

        <div class="profile-container">
            <div class="profile-card">
                <div class="profile-header">
                    <div class="profile-avatar">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="profile-name">
                        <%= Session["UserName"] !=null ? Session["UserName"].ToString() : "Customer" %>
                    </div>
                </div>

                <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
                <asp:Label ID="lblError" runat="server" CssClass="alert alert-error" Visible="false"></asp:Label>

                <div class="info-row">
                    <div class="form-group">
                        <label>Mobile Number</label>
                        <asp:TextBox ID="txtMobile" runat="server" Enabled="false"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Enter your full name"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine"
                        placeholder="Enter your complete address"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Area</label>
                    <asp:TextBox ID="txtArea" runat="server" Enabled="false"></asp:TextBox>
                </div>

                <asp:Button ID="btnUpdate" runat="server" Text="Update Profile" CssClass="btn-update"
                    OnClick="btnUpdate_Click" />

                <div class="section-title">Change Password</div>

                <div class="form-group">
                    <label>Old Password</label>
                    <asp:TextBox ID="txtOldPassword" runat="server" TextMode="Password"
                        placeholder="Enter your current password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                        placeholder="Enter a new password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Confirm New Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                        placeholder="Re-enter the new password"></asp:TextBox>
                </div>

                <asp:Button ID="btnChangePassword" runat="server" Text="Update Password" CssClass="btn-update"
                    OnClick="btnChangePassword_Click" />
            </div>
        </div>
    </asp:Content>