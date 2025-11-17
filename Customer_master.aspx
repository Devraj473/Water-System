<%@ Page Title="" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="Customer_master.aspx.cs" Inherits="Water_Man.Customer_master" Debug="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="win.css" rel="stylesheet" />
    <link href="mob.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .area-filter {
            background: #fff;
            border: 2px solid #2196f3;
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 10px;
            font-size: 15px;
            color: #333;
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg fill="%232196f3" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>');
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 20px;
            box-shadow: 0 2px 8px rgba(33, 150, 243, 0.1);
            transition: all 0.2s;
            min-width: 220px;
        }

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

        // Fixed Delete confirmation function
        function confirmDeleteCustomer(buttonUniqueId) {
            pendingDeleteButton = buttonUniqueId;
            showConfirmAlert('Are you sure you want to delete this customer?', function (result) {
                if (result && pendingDeleteButton) {
                    __doPostBack(pendingDeleteButton, '');
                }
                pendingDeleteButton = null;
            });
            return false;
        }

        // FIXED Validation for update - simplified approach
        function validateCustomerForm(formIndex) {
            // Find the row that's currently in edit mode
            var editingRow = null;
            var allRows = document.querySelectorAll('[id*="rptCustomer"] tbody tr');

            for (var i = 0; i < allRows.length; i++) {
                var saveButton = allRows[i].querySelector('[id*="btnUpdate"]');
                if (saveButton && saveButton.offsetParent !== null) {
                    editingRow = allRows[i];
                    break;
                }
            }

            if (!editingRow) {
                return true; // Let server handle validation
            }

            var nameInput = editingRow.querySelector('[id*="txtName"]');
            var addressInput = editingRow.querySelector('[id*="txtAddress"]');
            var mobileInput = editingRow.querySelector('[id*="txtMobile"]');
            var dateInput = editingRow.querySelector('[id*="txtDate"]');
            var areaInput = editingRow.querySelector('[id*="ddlArea"]');

            var errors = [];

            if (!nameInput || nameInput.value.trim() === '') {
                errors.push('Name is required');
            }

            if (!addressInput || addressInput.value.trim() === '') {
                errors.push('Address is required');
            }

            if (!mobileInput || mobileInput.value.trim() === '') {
                errors.push('Mobile number is required');
            } else if (!/^[0-9]{10}$/.test(mobileInput.value.trim())) {
                errors.push('Mobile number must be 10 digits');
            }

            if (!dateInput || dateInput.value.trim() === '') {
                errors.push('Date is required');
            }

            // Simplified area validation
            if (!areaInput || areaInput.selectedIndex <= 0) {
                errors.push('Please select an area');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
        }

        // Mobile table functions
        function setMobileTableLabels() {
            var headers = ['Customer ID', 'Name', 'Address', 'Mobile', 'Date', 'Area', 'Actions'];
            if (window.innerWidth <= 600) {
                var rows = document.querySelectorAll('.customer-table tbody tr');
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].querySelectorAll('td');
                    for (var j = 0; j < cells.length; j++) {
                        cells[j].setAttribute('data-label', headers[j]);
                    }
                }
            } else {
                var rows = document.querySelectorAll('.customer-table tbody tr');
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
                if (window._tableLabelTimeout) {
                    clearTimeout(window._tableLabelTimeout);
                }
                window._tableLabelTimeout = setTimeout(setMobileTableLabels, 100);
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

        function toggleSubmenu(submenuId) {
            var allSubmenus = document.querySelectorAll('.submenu, .bottom-nav__submenu');
            for (var i = 0; i < allSubmenus.length; i++) {
                if (allSubmenus[i].id !== submenuId) {
                    if (allSubmenus[i].classList.contains('visible')) {
                        allSubmenus[i].classList.remove('visible');
                    }
                }
            }
            var submenu = document.getElementById(submenuId);
            if (submenu) {
                if (submenu.classList.contains('visible')) {
                    submenu.classList.remove('visible');
                } else {
                    submenu.classList.add('visible');
                }
            }
        }

        function navigateTo(page) {
            window.location.href = page;
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mobile-topbar">
        <span class="mobile-welcome">Customer Master</span>
        <a href="Settings.aspx"><span class="settings-icon"><i class="fas fa-cog"></i></span></a>
    </div>
    <div style="height: 56px;"></div>
    <main class="main-content">
        <div class="main-header">Customer Master</div>
        <div>
            <asp:DropDownList ID="ddlAreaFilter" runat="server" AutoPostBack="true" 
                OnSelectedIndexChanged="ddlAreaFilter_SelectedIndexChanged" CssClass="area-filter" />
        </div>
        <div class="table-container">
            <table class="customer-table">
                <thead>
                    <tr>
                        <th>Customer ID</th>
                        <th>Name</th>
                        <th>Address</th>
                        <th>Mobile</th>
                        <th>Date</th>
                        <th>Area</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptCustomer" runat="server" OnItemCommand="rptCustomer_ItemCommand" OnItemDataBound="rptCustomer_ItemDataBound">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("Customer_Id") %></td>
                                <td>
                                    <asp:Panel ID="pnlViewName" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <%# Eval("Name") %>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEditName" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <asp:TextBox ID="txtName" runat="server" Text='<%# Eval("Name") %>' CssClass="form-control" />
                                    </asp:Panel>
                                </td>
                                <td>
                                    <asp:Panel ID="pnlViewAddress" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <%# Eval("Address") %>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEditAddress" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <asp:TextBox ID="txtAddress" runat="server" Text='<%# Eval("Address") %>' CssClass="form-control" />
                                    </asp:Panel>
                                </td>
                                <td>
                                    <asp:Panel ID="pnlViewMobile" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <%# Eval("Mobile") %>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEditMobile" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <asp:TextBox ID="txtMobile" runat="server" Text='<%# Eval("Mobile") %>' CssClass="form-control" />
                                    </asp:Panel>
                                </td>
                                <td>
                                    <asp:Panel ID="pnlViewDate" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <%# Eval("Date", "{0:yyyy-MM-dd}") %>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEditDate" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <asp:TextBox ID="txtDate" runat="server" Text='<%# Eval("Date", "{0:yyyy-MM-dd}") %>' CssClass="form-control" TextMode="Date" />
                                    </asp:Panel>
                                </td>
                                <td>
                                    <asp:Panel ID="pnlViewArea" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <%# Eval("Area_Name") %>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEditArea" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-control" />
                                    </asp:Panel>
                                </td>
                                <td class="action-buttons">
                                    <asp:Panel ID="pnlViewButtons" runat="server" Visible='<%# !Convert.ToBoolean(Eval("IsEdit")) %>'>
                                        <asp:Button ID="btnEdit" runat="server" Text="Edit" CommandName="Edit" CommandArgument='<%# Eval("Customer_Id") %>' CssClass="btn btn-primary btn-sm" />
                                        <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="Delete" CommandArgument='<%# Eval("Customer_Id") %>' CssClass="modern-delete-btn" />
                                    </asp:Panel>
                                    <asp:Panel ID="pnlEditButtons" runat="server" Visible='<%# Convert.ToBoolean(Eval("IsEdit")) %>'>
                                    <asp:Button ID="btnUpdate" runat="server" Text="Save" CommandName="Update" CommandArgument='<%# Eval("Customer_Id") %>' CssClass="my-app-btn my-app-btn-success my-app-btn-sm" OnClientClick='<%# "return validateCustomerForm(" + Container.ItemIndex + ");" %>' />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="Cancel" CommandArgument='<%# Eval("Customer_Id") %>' CssClass="my-app-btn my-app-btn-secondary my-app-btn-sm" />
                                            
                                    </asp:Panel>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
        <div style="height:56px;"></div>
    </main>

</asp:Content>