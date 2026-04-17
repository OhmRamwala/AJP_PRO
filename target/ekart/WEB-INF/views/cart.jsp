<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Cart" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<div class="row g-4 align-items-start">
    <div class="col-lg-8">
        <div class="summary-panel p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h3 mb-1">Shopping Cart</h1>
                    <p class="text-secondary mb-0">Review quantities and place your order when ready.</p>
                </div>
                <a class="btn btn-outline-dark" href="${ctx}/products">Continue Shopping</a>
            </div>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="alert alert-info mb-0">Your cart is empty.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>Product</th>
                                <th class="text-center">Price</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Subtotal</th>
                                <th class="text-end">Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="item" items="${cartItems}">
                                <tr>
                                    <td>
                                        <div class="fw-semibold"><c:out value="${item.product.name}" /></div>
                                    </td>
                                    <td class="text-center">Rs. <fmt:formatNumber value="${item.product.price}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td class="text-center" style="min-width: 170px;">
                                        <form method="post" action="${ctx}/cart/update" class="d-flex gap-2 justify-content-center">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            <input class="form-control form-control-sm" type="number" name="quantity" min="1" max="${item.product.stock}" value="${item.quantity}">
                                            <button class="btn btn-sm btn-outline-dark" type="submit">Update</button>
                                        </form>
                                    </td>
                                    <td class="text-end">Rs. <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td class="text-end">
                                        <form method="post" action="${ctx}/cart/remove">
                                            <input type="hidden" name="productId" value="${item.product.id}">
                                            <button class="btn btn-sm btn-outline-danger" type="submit">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="summary-panel p-4">
            <h2 class="h4 mb-3">Order Summary</h2>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-secondary">Items</span>
                <span>${cartCount}</span>
            </div>
            <div class="d-flex justify-content-between mb-4">
                <span class="text-secondary">Total</span>
                <span class="fw-bold">Rs. <fmt:formatNumber value="${cartTotal}" minFractionDigits="2" maxFractionDigits="2" /></span>
            </div>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <button class="btn btn-dark w-100" type="button" disabled>Checkout</button>
                </c:when>
                <c:when test="${empty currentUser}">
                    <a class="btn btn-warning w-100" href="${ctx}/login">Login to Checkout</a>
                </c:when>
                <c:otherwise>
                    <form method="post" action="${ctx}/checkout">
                        <button class="btn btn-dark w-100" type="submit">Place Order</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jspf" %>
