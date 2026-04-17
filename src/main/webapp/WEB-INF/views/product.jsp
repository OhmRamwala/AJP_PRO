<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Product" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<div class="row g-4 align-items-stretch">
    <div class="col-lg-7 d-flex">
        <div class="product-detail-image product-detail-frame bg-white p-3 shadow-sm h-100 w-100">
            <img src="${product.imageUrl}" class="img-fluid w-100 rounded-4" alt="${product.name}" onerror="this.onerror=null;this.src='${product.fallbackImageUrl}';">
        </div>
    </div>
    <div class="col-lg-5 d-flex">
        <div class="detail-panel p-4 p-lg-5 h-100 w-100 d-flex flex-column">
            <div class="d-flex flex-wrap gap-2 mb-3">
                <a class="chip-link" href="${ctx}/products">All Products</a>
                <a class="chip-link active" href="${ctx}/category?slug=${product.categorySlug}"><c:out value="${product.category}" /></a>
            </div>
            <h1 class="display-6 fw-bold mt-2 mb-3"><c:out value="${product.name}" /></h1>
            <p class="text-secondary mb-4 flex-grow-1"><c:out value="${product.description}" /></p>

            <div class="product-purchase-panel mt-auto">
                <div class="highlight-note rounded-4 p-3 mb-4">
                    <div class="fw-semibold mb-1">Category</div>
                    <div class="text-secondary"><c:out value="${product.category}" /> collection</div>
                </div>

                <div class="d-flex align-items-center gap-3 mb-4">
                    <span class="price-tag fs-3">Rs. <fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2" /></span>
                    <span class="badge ${product.stock gt 0 ? 'text-bg-success' : 'text-bg-secondary'}">${product.stock gt 0 ? product.stock : 0} in stock</span>
                </div>

                <form method="post" action="${ctx}/cart/add" class="row g-3">
                    <input type="hidden" name="productId" value="${product.id}">
                    <div class="col-sm-4">
                        <label class="form-label" for="quantity">Quantity</label>
                        <input class="form-control" type="number" id="quantity" name="quantity" min="1" max="${product.stock}" value="1" ${product.stock le 0 ? 'disabled' : ''}>
                    </div>
                    <div class="col-sm-8 d-flex align-items-end">
                        <button class="btn btn-dark w-100" type="submit" ${product.stock le 0 ? 'disabled' : ''}>Add to Cart</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<c:if test="${not empty relatedProducts}">
    <section class="mt-5">
        <div class="section-head">
            <div>
                <span class="section-kicker">You May Also Like</span>
                <h2 class="h3 mb-1">More from <c:out value="${product.category}" /></h2>
                <p class="section-subtext mb-0">Recommended products from the same category.</p>
            </div>
            <a class="btn btn-outline-dark" href="${ctx}/category?slug=${product.categorySlug}">View Category</a>
        </div>
        <div class="row g-4">
            <c:set var="productColClass" value="col-md-6 col-xl-3" />
            <c:forEach var="product" items="${relatedProducts}">
                <%@ include file="includes/product-card.jspf" %>
            </c:forEach>
        </div>
    </section>
</c:if>

<%@ include file="includes/footer.jspf" %>
