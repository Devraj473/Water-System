<script>
    document.addEventListener("DOMContentLoaded", function () {
        const cblProducts = document.querySelectorAll("input[type='checkbox'][id*='cblProducts']");
        const quantityContainer = document.getElementById("productQuantityContainer");

        function updateQuantityInputs() {
            quantityContainer.innerHTML = ""; // Clear previous inputs
            cblProducts.forEach((cb) => {
                if (cb.checked) {
                    const productName = cb.nextSibling.nodeValue.trim();
                    const inputDiv = document.createElement("div");
            inputDiv.classList.add("form-group");
            inputDiv.innerHTML = `
                <label for="qty_${productName}">${productName} Quantity</label>
                <input type="number" id="qty_${productName}" name="qty_${productName}" class="form-control" min="0" />
            `;
        quantityContainer.appendChild(inputDiv);
    }
});
}

cblProducts.forEach((cb) => {
    cb.addEventListener("change", updateQuantityInputs);
});

updateQuantityInputs(); // Initial call in case of postback
});
</script>
