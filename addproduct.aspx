<%@ Page Title="Add Product" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="addproduct.aspx.cs" Inherits="Water_Man_Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="win.css" media="screen and (min-width: 601px)" />
    <link rel="stylesheet" href="mob.css" media="screen and (max-width: 600px)" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Mobile Header -->
    <div class="mobile-topbar">
        <span class="mobile-welcome">Add New Product</span>
        <a href="Settings.aspx"><span class="settings-icon"><i class="fas fa-cog"></i></span></a>
    </div>
    <div style="height: 56px;"></div>

    <!-- Main Header -->
    <div class="main-header">Add New Product</div>

    <!-- Product Form -->
    <div class="product-form-section">
        <div class="product-form">
            <asp:TextBox ID="txtpName" runat="server" CssClass="form-control" placeholder="Enter product name" />
            <asp:TextBox ID="txtRate" runat="server" CssClass="form-control" placeholder="Enter product rate" TextMode="Number" />
            <div class="form-actions">
                <asp:Button ID="btnSave" runat="server" Text=" ADD" CssClass="btn btn-primary" OnClick="btnSave_Click" OnClientClick="return validateProductForm();" />
                <asp:Button ID="btnClear" runat="server" Text=" Cancel" CssClass="btn btn-secondary" OnClick="btnClear_Click" CausesValidation="false" OnClientClick="return confirmClear();" />
            </div>
            <asp:HiddenField ID="hfEditID" runat="server" />
        </div>
    </div>

    <!-- Product Table -->
    <div style="margin-top: 40px;">
       <center> <b style="font-size:2vw;">All Products</b></center>
        <table class="products-table" style="width: 100%; margin-top: 10px;">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Product Rate</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand" OnItemDataBound="rptProducts_ItemDataBound">
                    <ItemTemplate>
                        <tr>
                            <td data-label="Product Name"><%# Eval("Product_Name") %></td>
                            <td data-label="Product Rate">&#8377;<%# Eval("Product_Rate") %></td>
                            <td data-label="Actions">
                                <asp:LinkButton ID="lnkEdit" runat="server"
                                    CommandName="Edit"
                                    CommandArgument='<%# Eval("Product_Id") %>'
                                    CssClass="my-app-btn my-app-btn-success my-app-btn-sm"
                                    Text=" Edit" />
                                &nbsp;
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CommandName="Delete"
                                    CommandArgument='<%# Eval("Product_Id") %>'
                                    CssClass="modern-delete-btn"
                                    Text=" Delete" />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>


    <script type="text/javascript">
        // Store the button reference for delete confirmation
        var pendingDeleteButton = null;

        // Custom Alert Functions
        function showCustomAlert(message, type, callback) {
            // Remove existing alerts
            var existingAlerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            for (var i = 0; i < existingAlerts.length; i++) {
                existingAlerts[i].parentNode.removeChild(existingAlerts[i]);
            }

            // Create overlay
            var overlay = document.createElement('div');
            overlay.className = 'alert-overlay';

            // Create alert box
            var alertBox = document.createElement('div');
            alertBox.className = 'custom-alert ' + type;

            var title = '';
            switch (type) {
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

        function showConfirmAlert(message, callback) {
            // Remove existing alerts
            var existingAlerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            for (var i = 0; i < existingAlerts.length; i++) {
                existingAlerts[i].parentNode.removeChild(existingAlerts[i]);
            }

            // Create overlay
            var overlay = document.createElement('div');
            overlay.className = 'alert-overlay';

            // Create alert box
            var alertBox = document.createElement('div');
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
            var alerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            for (var i = 0; i < alerts.length; i++) {
                alerts[i].parentNode.removeChild(alerts[i]);
            }

            if (window.alertCallback) {
                window.alertCallback();
                window.alertCallback = null;
            }
        }

        function confirmAction(result) {
            var alerts = document.querySelectorAll('.custom-alert, .alert-overlay');
            for (var i = 0; i < alerts.length; i++) {
                alerts[i].parentNode.removeChild(alerts[i]);
            }

            if (window.confirmCallback) {
                window.confirmCallback(result);
                window.confirmCallback = null;
            }
        }

        // Fixed Delete confirmation function
        function confirmDeleteProduct(buttonUniqueId) {
            pendingDeleteButton = buttonUniqueId;
            showConfirmAlert('Are you sure you want to delete this product?', function (result) {
                if (result && pendingDeleteButton) {
                    __doPostBack(pendingDeleteButton, '');
                }
                pendingDeleteButton = null;
            });
            return false;
        }

        // Validation Functions
        function validateProductForm() {
            var nameElement = document.getElementById('<%= txtpName.ClientID %>');
            var rateElement = document.getElementById('<%= txtRate.ClientID %>');

            if (!nameElement || !rateElement) {
                showCustomAlert('Form validation error', 'error');
                return false;
            }

            var name = nameElement.value.replace(/^\s+|\s+$/g, '');
            var rate = rateElement.value.replace(/^\s+|\s+$/g, '');

            var errors = [];

            if (name === '') {
                errors.push('Product name is required');
            }

            if (rate === '') {
                errors.push('Product rate is required');
            } else if (isNaN(rate) || parseFloat(rate) <= 0) {
                errors.push('Please enter a valid product rate greater than 0');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
        }

        function confirmClear() {
            var nameElement = document.getElementById('<%= txtpName.ClientID %>');
            var rateElement = document.getElementById('<%= txtRate.ClientID %>');

            if (!nameElement || !rateElement) {
                return true;
            }

            var name = nameElement.value.replace(/^\s+|\s+$/g, '');
            var rate = rateElement.value.replace(/^\s+|\s+$/g, '');

            if (name !== '' || rate !== '') {
                showConfirmAlert('Are you sure you want to clear all fields?', function (result) {
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

        // Mobile table functions
        function setMobileTableLabels() {
            var headers = ['Product Name', 'Product Rate', 'Actions'];
            if (window.innerWidth <= 600) {
                var rows = document.querySelectorAll('.products-table tbody tr');
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].querySelectorAll('td');
                    for (var j = 0; j < cells.length; j++) {
                        cells[j].setAttribute('data-label', headers[j]);
                    }
                }
            } else {
                var rows = document.querySelectorAll('.products-table tbody tr');
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].querySelectorAll('td');
                    for (var j = 0; j < cells.length; j++) {
                        cells[j].removeAttribute('data-label');
                    }
                }
            }
        }

        // Cross-browser event handling for older browsers
        function addEvent(element, event, handler) {
            if (element.addEventListener) {
                element.addEventListener(event, handler, false);
            } else if (element.attachEvent) {
                element.attachEvent('on' + event, handler);
            }
        }

        // Initialize when DOM is ready (compatible with older browsers)
        function initializePage() {
            setMobileTableLabels();

            addEvent(window, 'resize', function () {
                if (window._tableResizeTimeout) {
                    clearTimeout(window._tableResizeTimeout);
                }
                window._tableResizeTimeout = setTimeout(setMobileTableLabels, 100);
            });
        }

        // Cross-browser DOM ready
        if (document.addEventListener) {
            document.addEventListener('DOMContentLoaded', initializePage);
        } else if (document.attachEvent) {
            document.attachEvent('onreadystatechange', function () {
                if (document.readyState === 'complete') {
                    initializePage();
                }
            });
        }
    </script>

</asp:Content>