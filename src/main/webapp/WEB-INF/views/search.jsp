<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Search" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="store-panel p-4 p-lg-5 mb-5">
    <span class="section-kicker">Search</span>
    <c:choose>
        <c:when test="${not empty searchQuery}">
            <h1 class="display-6 fw-bold mb-2">Results for "<c:out value="${searchQuery}" />"</h1>
            <p class="section-subtext mb-0">${fn:length(products)} product(s) matched by name or description.</p>
        </c:when>
        <c:otherwise>
            <h1 class="display-6 fw-bold mb-2">Search the catalog</h1>
            <p class="section-subtext mb-0">Use the search bar above to look up products by name or description. Featured products are shown below as suggestions.</p>
        </c:otherwise>
    </c:choose>
</section>

<div class="row g-4">
    <c:choose>
        <c:when test="${not empty searchQuery and empty products}">
            <div class="col-12">
                <div class="alert alert-warning mb-0">No products matched your search. Try a different keyword or browse by category.</div>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="productColClass" value="col-md-6 col-xl-3" />
            <c:forEach var="product" items="${products}">
                <%@ include file="includes/product-card.jspf" %>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="includes/footer.jspf" %>
