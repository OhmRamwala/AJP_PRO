<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Products" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="store-panel catalog-hero p-4 p-lg-5 mb-5">
    <div class="row g-4 align-items-center">
        <div class="col-lg-8">
            <span class="section-kicker">Full Catalog</span>
            <h1 class="display-6 fw-bold mb-2">Browse every product category in one place</h1>
            <p class="section-subtext mb-0">The catalog is grouped department-wise so shoppers can jump straight to electronics, fashion, accessories, footwear, or home styling.</p>
        </div>
        <div class="col-lg-4">
            <div class="row g-3">
                <div class="col-6">
                    <div class="metric-card">
                        <span class="muted-label">Categories</span>
                        <strong>${fn:length(categories)}</strong>
                        <span class="small text-secondary">active sections</span>
                    </div>
                </div>
                <div class="col-6">
                    <div class="metric-card">
                        <span class="muted-label">Products</span>
                        <strong>${fn:length(products)}</strong>
                        <span class="small text-secondary">available now</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="mb-5">
    <div class="d-flex flex-wrap gap-2">
        <a class="chip-link active" href="${ctx}/products">All</a>
        <c:forEach var="category" items="${categories}">
            <a class="chip-link" href="${ctx}/category?slug=${category.slug}"><c:out value="${category.name}" /></a>
        </c:forEach>
    </div>
</section>

<c:choose>
    <c:when test="${empty products}">
        <div class="alert alert-info">No products are available yet.</div>
    </c:when>
    <c:otherwise>
        <c:set var="productColClass" value="col-md-6 col-xl-4" />
        <c:forEach var="category" items="${categories}">
            <c:set var="categoryProducts" value="${productsByCategory[category.name]}" />
            <c:if test="${not empty categoryProducts}">
                <section class="mb-5">
                    <div class="section-head">
                        <div>
                            <span class="section-kicker"><c:out value="${category.name}" /></span>
                            <h2 class="h3 mb-1">Explore <c:out value="${category.name}" /></h2>
                            <p class="section-subtext mb-0"><c:out value="${category.description}" /></p>
                        </div>
                        <a class="btn btn-outline-dark" href="${ctx}/category?slug=${category.slug}">View All</a>
                    </div>
                    <div class="row g-4">
                        <c:forEach var="product" items="${categoryProducts}">
                            <%@ include file="includes/product-card.jspf" %>
                        </c:forEach>
                    </div>
                </section>
            </c:if>
        </c:forEach>
    </c:otherwise>
</c:choose>

<%@ include file="includes/footer.jspf" %>
