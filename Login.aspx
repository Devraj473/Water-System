<%@ Page Title="Login" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Water_Man_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" href="win.css" media="screen and (min-width: 601px)">
    <link rel="stylesheet" href="mob.css" media="screen and (max-width: 600px)">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
        display:none;

        }
        .bottom-nav {
        visibility:hidden;}
        * {
            box-sizing: border-box;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            33% { transform: translateY(-30px) rotate(120deg); }
            66% { transform: translateY(-60px) rotate(240deg); }
        }

        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 3rem 2.5rem;
            border-radius: 24px;
            box-shadow: 
                0 8px 32px rgba(31, 38, 135, 0.37),
                0 2px 16px rgba(31, 38, 135, 0.2);
            width: 100%;
            max-width: 420px;
            margin: 32px auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            border: 1px solid rgba(255, 255, 255, 0.18);
            position: relative;
            transform: translateY(20px);
            opacity: 0;
            animation: slideUp 0.8s ease-out forwards;
        }

        @keyframes slideUp {
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .login-icon i {
            font-size: 2rem;
            color: white;
        }

        .login-container h2 {
            margin: 0;
            color: #2c3e50;
            font-weight: 700;
            font-size: 2.2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .login-subtitle {
            color: #7f8c8d;
            font-size: 1rem;
            margin-top: 0.5rem;
        }

        .input-group {
            position: relative;
            width: 100%;
            margin-bottom: 1.8rem;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input {
            width: 100%;
            padding: 18px 16px 18px 50px;
            border: 2px solid #e1e8ed;
            border-radius: 16px;
            font-size: 1.1em;
            color: #2c3e50;
            background: rgba(255, 255, 255, 0.9);
            outline: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            font-family: inherit;
        }

        .input:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            background: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
        }

        .input-icon {
            position: absolute;
            left: 16px;
            color: #7f8c8d;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            z-index: 2;
        }

        .input:focus + .input-icon {
            color: #667eea;
            transform: scale(1.1);
        }

        .label {
            position: absolute;
            left: 50px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            font-size: 1.1em;
            pointer-events: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: transparent;
            padding: 0;
        }

        .input:focus + .input-icon + .label,
        .input:not(:placeholder-shown) + .input-icon + .label {
            top: -12px;
            left: 12px;
            color: #667eea;
            font-size: 0.85em;
            background: rgba(255, 255, 255, 0.9);
            padding: 0 8px;
            font-weight: 600;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            color: #7f8c8d;
            cursor: pointer;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            z-index: 3;
            padding: 4px;
        }

        .password-toggle:hover {
            color: #667eea;
            transform: scale(1.1);
        }

        .btn-login {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            border: none;
            border-radius: 16px;
            font-size: 1.2em;
            font-weight: 600;
            cursor: pointer;
            margin-top: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .btn-login:hover::before {
            left: 100%;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
        }

        .btn-login:active {
            transform: translateY(-1px);
        }

        .error-message {
            color: #e74c3c;
            font-size: 1em;
            margin-top: 1.5rem;
            text-align: center;
            padding: 12px;
            background: rgba(231, 76, 60, 0.1);
            border-radius: 12px;
            border-left: 4px solid #e74c3c;
            animation: shake 0.5s ease-in-out;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }

        /* Customer Portal Link */
        .customer-link {
            text-align: center;
            margin-top: 20px;
        }

        .customer-link a {
            color: white;
            text-decoration: none;
            font-weight: 600;
            background: rgba(255, 255, 255, 0.2);
            padding: 10px 20px;
            border-radius: 8px;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .customer-link a:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        /* Loading animation */
        .btn-login.loading {
            pointer-events: none;
            opacity: 0.8;
        }

        .btn-login.loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            border: 2px solid transparent;
            border-top: 2px solid #fff;
            border-radius: 50%;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: translateY(-50%) rotate(0deg); }
            100% { transform: translateY(-50%) rotate(360deg); }
        }

        /* Responsive Design */
        @media (max-width: 600px) {
            .bodydiv {
                padding: 1rem;
            }
            .mobile-topbar {
            display:none;
            }
            .login-container {
               
                margin-top:10vh;
                max-width: 94%;
                
                padding: 2rem 1.5rem;
                border-radius: 20px;
                margin-top: 58px;
            }
            
            .input {
                font-size: 1em;
                padding: 16px 12px 16px 45px;
            }
            
            .login-container h2 {
                font-size: 1.8rem;
            }
            
            .login-icon {
                width: 60px;
                height: 60px;
            }
            
            .login-icon i {
                font-size: 1.5rem;
            }
        }

        /* Focus trap for accessibility */
        /*.login-container:focus-within {
            box-shadow: 
                0 8px 32px rgba(31, 38, 135, 0.37),
                0 2px 16px rgba(31, 38, 135, 0.2),
                0 0 0 4px rgba(102, 126, 234, 0.1);
        }*/
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="">
        <div class="login-container" >
            <div class="login-header">
                <div class="login-icon">
                    <i class="fas fa-tint"></i>
                </div>
              
                <p class="login-subtitle">Sign in to your account</p>
            </div>
            
            <form method="post" autocomplete="off" style="width: 100%;">
                <div class="input-group">
                    <div class="input-wrapper">
                        <input class="input" id="txtuname" name="txtuname" type="text" 
                               autocomplete="username" required placeholder=" " />
                        <i class="fas fa-user input-icon"></i>
                        <label class="label" for="txtuname">Username</label>
                    </div>
                </div>
                
                <div class="input-group">
                    <div class="input-wrapper">
                        <input class="input" id="txtpassword" name="txtpassword" type="password" 
                               autocomplete="current-password" required placeholder=" " />
                        <i class="fas fa-lock input-icon"></i>
                        <label class="label" for="txtpassword">Password</label>
                        <i class="fas fa-eye password-toggle" id="togglePassword" onclick="togglePasswordVisibility()"></i>
                    </div>
                </div>
                
                <button type="submit" class="btn-login" id="loginBtn" onclick="showLoading()">
                    Sign In
                </button>
                
                
                <asp:Label ID="lblError" runat="server" CssClass="error-message" EnableViewState="false" />
            </form>
        </div>

        <div class="customer-link">
            <a href="UserLogin.aspx"><i class="fas fa-user"></i> Customer Login</a>
        </div>
    </div>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('txtpassword');
            const toggleIcon = document.getElementById('togglePassword');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('fa-eye');
                toggleIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('fa-eye-slash');
                toggleIcon.classList.add('fa-eye');
            }
        }

        function showLoading() {
            const loginBtn = document.getElementById('loginBtn');
            loginBtn.classList.add('loading');
            loginBtn.innerHTML = 'Signing In...';
        }

        // Add floating label animation
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.input');
            
            inputs.forEach(input => {
                // Check if input has value on page load
                if (input.value.trim() !== '') {
                    input.classList.add('has-value');
        }
                
                input.addEventListener('blur', function() {
                    if (this.value.trim() !== '') {
                        this.classList.add('has-value');
                    } else {
                        this.classList.remove('has-value');
                    }
                });
        });
        });

        // Add ripple effect to button
        document.querySelector('.btn-login').addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
        }, 600);
        });

        // Add CSS for ripple effect
        const style = document.createElement('style');
        style.textContent = `
            .ripple {
            position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.3);
                transform: scale(0);
                animation: ripple-animation 0.6s linear;
                pointer-events: none;
            }
            
            @keyframes ripple-animation {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</asp:Content>
