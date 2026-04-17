<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="${selectedCategory.name}" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="store-panel category-hero p-4 p-lg-5 mb-5 text-white" style="background-image: url('${selectedCategory.imageUrl}');">
    <div class="row align-items-center g-4">
        <div class="col-lg-8">
            <span class="hero-chip mb-3">Category Spotlight</span>
            <h1 class="display-5 fw-bold mb-2"><c:out value="${selectedCategory.name}" /></h1>
            <p class="lead mb-0 col-lg-10"><c:out value="${selectedCategory.description}" /></p>
        </div>
        <div class="col-lg-4">
            <div class="hero-metric">
                <span class="text-white-50 small text-uppercase">Products Available</span>
                <strong>${fn:length(products)}</strong>
                <span class="small">in this category</span>
            </div>
        </div>
    </div>
</section>

<section class="mb-5">
    <div class="section-head mb-4">
        <div>
            <span class="section-kicker"><c:out value="${selectedCategory.name}" /></span>
            <h2 class="h3 mb-1">Browse <c:out value="${selectedCategory.name}" /> products</h2>
            <p class="section-subtext mb-0">Showing every mapped product for this category, including older items cleaned up from existing data.</p>
        </div>
    </div>
    <div class="d-flex flex-wrap gap-2">
        <c:forEach var="category" items="${categories}">
            <a class="chip-link ${category.slug eq selectedCategory.slug ? 'active' : ''}" href="${ctx}/category?slug=${category.slug}">
                <c:out value="${category.name}" />
            </a>
        </c:forEach>
    </div>
</section>

<div class="row g-4">
    <c:choose>
        <c:when test="${empty products}">
            <div class="col-12">
                <div class="alert alert-info mb-0">No products found in this category yet.</div>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="productColClass" value="col-md-6 col-xl-4" />
            <c:forEach var="product" items="${products}">
                <%@ include file="includes/product-card.jspf" %>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="includes/footer.jspf" %>
