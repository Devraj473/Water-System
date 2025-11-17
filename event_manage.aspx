<%@ Page Title="Event Management" Language="C#" MasterPageFile="~/main.master" AutoEventWireup="true" CodeFile="event_manage.aspx.cs" Inherits="Water_Man_EventManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="win.css" media="screen and (min-width: 601px)" />
    <link rel="stylesheet" href="mob.css" media="screen and (max-width: 600px)" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        
        .inputtxt {
        width: 35%;
        border: 2px solid #0094ff;
        border-radius: 8px;
        padding:10px;
        }
        .products-table {
        margin-left:8vw;
        }
    /* Clean, theme-consistent date input */
    input[type="date"]{
        width: 35%;
        margin-left:1vw;
        font-size: 0.95rem;
        text-align: center;
        border: 2px solid #0094ff;
        border-radius: 10px;
        padding: 6px 10px;
        background-color: white;  /* Changed from black to white */
        color: #000;              /* Changed from white to black */
        margin-bottom: 8px;
    }

    input[type="date"]::-webkit-calendar-picker-indicator {
        filter: none;  /* No inversion needed for white background */
        cursor: pointer;
    }

    .date-input-group {
        display: flex;
        gap: 14px;
        flex-wrap: wrap;
    }

    .date-item {
        flex: 1;
        min-width: 45%;
    }  .products-table {
            width: 86%;
            margin-top: 10px;
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

        .custom-alert.info {
            border-color: #2196F3;
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

        .custom-alert.info .alert-title {
            color: #2196F3;
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

        @media (max-width: 600px) {
            .date-input-group {
                flex-direction: column;
            }

            .date-item {
                width: 92%;
            }

            .product-form-section {
                padding: 0;
                margin: 0;
                width: 88%;
            }
            .products-table {
            margin:.5vw;}

            /* Mobile responsive for alerts */
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
        <span class="mobile-welcome">Event Management</span>
        <a href="Settings.aspx"><span class="settings-icon"><i class="fas fa-cog"></i></span></a>
    </div>
    <div style="height: 56px;"></div>

    <!-- Main Header -->
    <div class="main-header">Event Management</div>

    <!-- Event Form -->
    <div class="product-form-section " style="margin-left:8vw;">
        <div class="product-form">
            <asp:TextBox ID="txtEventName" runat="server" CssClass="form-control" placeholder="Enter event name" />

            <div class="date-input-group">
                <div class="date-item">
                    <asp:Label ID="Label1" runat="server" Text="Starting Date " CssClass="date-label" />
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
                <div class="date-item">
                    <asp:Label ID="Label2" runat="server" Text="Ending Date " CssClass="date-label" />
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control" TextMode="Date" />
                </div>
            </div>

            <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Enter address" />

            <div class="form-actions">
                <asp:Button ID="btnSave" runat="server" Text=" Save" CssClass="btn btn-primary" OnClick="btnSave_Click" OnClientClick="return validateEventForm();" />
                <asp:Button ID="btnCancel" runat="server" Text=" Cancel" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" OnClientClick="return confirmClear();" />
                <asp:HiddenField ID="hfEventId" runat="server" />
            </div>
        </div>
    </div>

    <!-- Products Selection Table -->
    <div style="margin-top: 40px; ">
      <center><b style="font-size:2vw;">Select Products</b></center>  
        <asp:Repeater ID="rptProducts" runat="server">
            <HeaderTemplate>
                <table class="products-table"  >
                    <thead>
                        <tr><th>Product</th><th>Quantity</th></tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td data-label="Product ">
                        <%# Eval("Product_Name") %>
                        <asp:HiddenField ID="hfProductId" runat="server" Value='<%# Eval("Product_Id") %>' />
                    </td>
                    <td data-label="Quantity">
                        <asp:TextBox ID="txtQty" runat="server" Text='<%# Eval("Quantity") %>' CssClass="inputtxt" />
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>

    <!-- All Events Table -->
    <div style="margin-top: 40px;">
     <center><b style="font-size:2vw;">All Events</b></center>   
        <asp:Repeater ID="rptEvents" runat="server" OnItemCommand="rptEvents_ItemCommand" OnItemDataBound="rptEvents_ItemDataBound">
            <HeaderTemplate>
                <table class="products-table events-table" style="width: 86%; margin-top: 10px;">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Date</th>
                            <th>Address</th>
                            <th>Products</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr>
                    <td data-label="Name"><%# Eval("Event_Name") %></td>
                    <td data-label="Date"><%# Eval("Starting_Date", "{0:yyyy-MM-dd}") %> to <%# Eval("Ending_Date", "{0:yyyy-MM-dd}") %></td>
                    <td data-label="Address"><%# Eval("Address") %></td>
                    <td data-label="Products"><%# Eval("ProductsOrdered") %></td>
                    <td data-label="Actions">
                        <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" CommandArgument='<%# Eval("Event_Id") %>' CssClass="my-app-btn my-app-btn-success my-app-btn-sm">Edit</asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Event_Id") %>' CssClass="modern-delete-btn">Delete</asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>
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
                case 'info': title = 'Information'; break;
                default: title = 'Notification';
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
                '<div class="alert-title">⚠️ Confirm Action</div>' +
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
        function confirmDeleteEvent(buttonUniqueId) {
            pendingDeleteButton = buttonUniqueId;
            showConfirmAlert('Are you sure you want to delete this event?', function (result) {
                if (result && pendingDeleteButton) {
                    __doPostBack(pendingDeleteButton, '');
                }
                pendingDeleteButton = null;
            });
            return false;
        }

        // Event Form Validation
        function validateEventForm() {
            var eventNameElement = document.getElementById('<%= txtEventName.ClientID %>');
            var startDateElement = document.getElementById('<%= txtStartDate.ClientID %>');
            var endDateElement = document.getElementById('<%= txtEndDate.ClientID %>');
            var addressElement = document.getElementById('<%= txtAddress.ClientID %>');

            if (!eventNameElement || !startDateElement || !endDateElement || !addressElement) {
                showCustomAlert('Form validation error', 'error');
                return false;
            }

            var eventName = eventNameElement.value.replace(/^\s+|\s+$/g, '');
            var startDate = startDateElement.value.replace(/^\s+|\s+$/g, '');
            var endDate = endDateElement.value.replace(/^\s+|\s+$/g, '');
            var address = addressElement.value.replace(/^\s+|\s+$/g, '');

            var errors = [];

            if (eventName === '') {
                errors.push('Event name is required');
            }

            if (startDate === '') {
                errors.push('Start date is required');
            }

            if (endDate === '') {
                errors.push('End date is required');
            }

            if (startDate !== '' && endDate !== '' && new Date(startDate) > new Date(endDate)) {
                errors.push('Start date cannot be later than end date');
            }

            if (address === '') {
                errors.push('Address is required');
            }

            // Check if at least one product has quantity > 0
            var hasProducts = false;
            var qtyInputs = document.querySelectorAll('[id*="txtQty"]');
            for (var i = 0; i < qtyInputs.length; i++) {
                var qtyValue = parseInt(qtyInputs[i].value);
                if (!isNaN(qtyValue) && qtyValue > 0) {
                    hasProducts = true;
                    break;
                }
            }

            if (!hasProducts) {
                errors.push('Please select at least one product with quantity greater than 0');
            }

            if (errors.length > 0) {
                showCustomAlert(errors.join('\n'), 'error');
                return false;
            }

            return true;
        }

        function confirmClear() {
            var eventNameElement = document.getElementById('<%= txtEventName.ClientID %>');
            var startDateElement = document.getElementById('<%= txtStartDate.ClientID %>');
            var endDateElement = document.getElementById('<%= txtEndDate.ClientID %>');
            var addressElement = document.getElementById('<%= txtAddress.ClientID %>');

            if (!eventNameElement || !startDateElement || !endDateElement || !addressElement) {
                return true;
            }

            var eventName = eventNameElement.value.replace(/^\s+|\s+$/g, '');
            var startDate = startDateElement.value.replace(/^\s+|\s+$/g, '');
            var endDate = endDateElement.value.replace(/^\s+|\s+$/g, '');
            var address = addressElement.value.replace(/^\s+|\s+$/g, '');

            if (eventName !== '' || startDate !== '' || endDate !== '' || address !== '') {
                showConfirmAlert('Are you sure you want to clear all fields?', function (result) {
                    if (result) {
                        // Proceed with clear
                        __doPostBack('<%= btnCancel.UniqueID %>', '');
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

        function showInfoMessage(message) {
            showCustomAlert(message, 'info');
        }

        // JS for Mobile Table Labels
        function setMobileTableLabels() {
            var productHeaders = ['Product', 'Quantity'];
            var productRows = document.querySelectorAll('.products-table tbody tr');
            for (var i = 0; i < productRows.length; i++) {
                var cells = productRows[i].querySelectorAll('td');
                for (var j = 0; j < cells.length; j++) {
                    if (window.innerWidth <= 600) {
                        cells[j].setAttribute('data-label', productHeaders[j] || '');
                    } else {
                        cells[j].removeAttribute('data-label');
                    }
                }
            }

            var eventHeaders = ['Name', 'Date', 'Address', 'Products', 'Actions'];
            var eventRows = document.querySelectorAll('.events-table tbody tr');
            for (var i = 0; i < eventRows.length; i++) {
                var cells = eventRows[i].querySelectorAll('td');
                for (var j = 0; j < cells.length; j++) {
                    if (window.innerWidth <= 600) {
                        cells[j].setAttribute('data-label', eventHeaders[j] || '');
                    } else {
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
                if (window._resizeTimeout) {
                    clearTimeout(window._resizeTimeout);
                }
                window._resizeTimeout = setTimeout(setMobileTableLabels, 100);
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