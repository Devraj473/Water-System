<%@ Page Language="C#" %>
<!DOCTYPE html>
<html>
<head>
    <title>Water System - Welcome</title>
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

        .container {
            text-align: center;
            color: white;
        }

        h1 {
            font-size: 3em;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .subtitle {
            font-size: 1.2em;
            margin-bottom: 50px;
            opacity: 0.95;
        }

        .portal-buttons {
            display: flex;
            gap: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .portal-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            min-width: 280px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            text-decoration: none;
            color: #333;
        }

        .portal-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 30px 80px rgba(0,0,0,0.4);
        }

        .portal-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5em;
        }

        .customer-icon {
            background: linear-gradient(135deg, #2196f3 0%, #1565c0 100%);
            color: white;
        }

        .admin-icon {
            background: linear-gradient(135deg, #f44336 0%, #c62828 100%);
            color: white;
        }

        .portal-card h2 {
            font-size: 1.8em;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .portal-card p {
            color: #666;
            font-size: 1em;
        }

        @media (max-width: 600px) {
            h1 {
                font-size: 2em;
            }

            .portal-buttons {
                flex-direction: column;
                gap: 20px;
/*                dfskn*/
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1><i class="fas fa-tint"></i> Water System</h1>
        <p class="subtitle">Choose your portal to continue</p>

        <div class="portal-buttons">
            <a href="UserLogin.aspx" class="portal-card">
                <div class="portal-icon customer-icon">
                    <i class="fas fa-user"></i>
                </div>
                <h2>Customer Portal</h2>
                <p>View orders, payments & profile</p>
            </a>

            <a href="Login.aspx" class="portal-card">
                <div class="portal-icon admin-icon">
                    <i class="fas fa-user-shield"></i>
                </div>
                <h2>Admin Portal</h2>
                <p>Manage customers & business</p>
            </a>
        </div>
    </div>
</body>
</html>
