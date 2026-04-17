<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="My Orders" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="summary-panel p-4 p-lg-5 mb-4">
    <span class="section-kicker">My Orders</span>
    <h1 class="h3 mb-2">Track your purchases</h1>
    <p class="text-secondary mb-0">Review order totals, placed dates, and delivery status in one place.</p>
</section>

<c:choose>
    <c:when test="${empty orders}">
        <div class="alert alert-info">You haven't placed any orders yet.</div>
    </c:when>
    <c:otherwise>
        <div class="accordion" id="myOrdersAccordion">
            <c:forEach var="order" items="${orders}" varStatus="loop">
                <div class="accordion-item mb-3 border rounded-4 overflow-hidden">
                    <h2 class="accordion-header">
                        <button class="accordion-button ${loop.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#my-order-${order.id}">
                            <div class="w-100 d-flex flex-column flex-lg-row justify-content-between me-3 gap-2">
                                <span class="fw-semibold">Order #${order.id}</span>
                                <span class="text-secondary small">${order.createdAtDisplay} | Rs. <fmt:formatNumber value="${order.total}" minFractionDigits="2" maxFractionDigits="2" /> | ${order.statusDisplay}</span>
                            </div>
                        </button>
                    </h2>
                    <div id="my-order-${order.id}" class="accordion-collapse collapse ${loop.first ? 'show' : ''}" data-bs-parent="#myOrdersAccordion">
                        <div class="accordion-body">
                            <div class="mb-3">
                                <span class="badge ${order.delivered ? 'text-bg-success' : 'text-bg-warning'}">${order.statusDisplay}</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-sm mb-0">
                                    <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Qty</th>
                                        <th>Price</th>
                                        <th class="text-end">Subtotal</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="item" items="${order.items}">
                                        <tr>
                                            <td><c:out value="${item.productName}" /></td>
                                            <td>${item.quantity}</td>
                                            <td>Rs. <fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                            <td class="text-end">Rs. <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="includes/footer.jspf" %>
