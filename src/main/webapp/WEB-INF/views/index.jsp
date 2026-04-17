<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Home" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="hero-banner p-4 p-lg-5 mb-5">
    <div class="row align-items-center g-4 h-100">
        <div class="col-lg-7 hero-content py-lg-5">
            <span class="hero-chip mb-3">EKART</span>
            <h1 class="display-4 fw-bold mb-3">Style, tech, and everyday essentials in one place</h1>
            <p class="lead mb-4 col-lg-10">Browse fresh picks across electronics, fashion, accessories, footwear, home and lifestyle, and skincare without leaving the homepage.</p>
            <div class="d-flex flex-wrap gap-3">
                <a class="btn btn-warning btn-lg px-4" href="${ctx}/products">Shop Now</a>
            </div>
        </div>
        <div class="col-lg-5">
            <div class="hero-highlight p-4 p-lg-5">
                <span class="section-kicker text-white-50">Why Shop eKart</span>
                <h2 class="h3 fw-bold mb-3 text-white">Top categories, cleaner browsing, faster product discovery.</h2>
                <p class="mb-0 text-white-50">Jump straight from the banner into the catalog, then keep scrolling through dedicated product sections right below.</p>
            </div>
        </div>
    </div>
</section>

<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Browse Categories</span>
            <h2 class="h3 mb-1">Start with the department you love</h2>
            <p class="section-subtext mb-0">Every category has a dedicated page and a deeper product selection.</p>
        </div>
    </div>
    <div class="row g-4">
        <c:forEach var="category" items="${categories}">
            <c:if test="${category.name eq 'Skincare'}">
                <div class="col-md-6 col-xl-4">
                    <a class="category-tile p-4" href="${ctx}/category?slug=${category.slug}" style="background-image: url('${category.imageUrl}');">
                        <div>
                            <span class="hero-chip mb-3">Category</span>
                            <h3 class="h2 fw-bold mb-2"><c:out value="${category.name}" /></h3>
                            <p class="mb-0 text-white-50"><c:out value="${category.description}" /></p>
                        </div>
                    </a>
                </div>
            </c:if>
        </c:forEach>
        <c:forEach var="category" items="${categories}">
            <c:if test="${category.name eq 'Electronics' or category.name eq 'Fashion' or category.name eq 'Accessories' or category.name eq 'Home & Lifestyle' or category.name eq 'Footwear'}">
                <div class="col-md-6 col-xl-4">
                    <a class="category-tile p-4" href="${ctx}/category?slug=${category.slug}" style="background-image: url('${category.imageUrl}');">
                        <div>
                            <span class="hero-chip mb-3">Category</span>
                            <h3 class="h2 fw-bold mb-2"><c:out value="${category.name}" /></h3>
                            <p class="mb-0 text-white-50"><c:out value="${category.description}" /></p>
                        </div>
                    </a>
                </div>
            </c:if>
        </c:forEach>
    </div>
</section>

<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Trending Picks</span>
            <h2 class="h3 mb-1">New arrivals shoppers are clicking first</h2>
            <p class="section-subtext mb-0">Featured products pulled directly from the latest catalog additions.</p>
        </div>
        <a class="btn btn-outline-dark" href="${ctx}/products">See All Products</a>
    </div>
    <div class="row g-4">
        <c:set var="productColClass" value="col-md-6 col-xl-3" />
        <c:set var="showStockBadge" value="${false}" />
        <c:forEach var="product" items="${featuredProducts}">
            <c:if test="${product.category ne 'Skincare'}">
                <%@ include file="includes/product-card.jspf" %>
            </c:if>
        </c:forEach>
    </div>
</section>

<c:set var="productColClass" value="col-md-6 col-xl-3" />
<c:set var="showStockBadge" value="${false}" />
<c:set var="skincareProducts" value="${productsByCategory['Skincare']}" />
<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Skincare</span>
            <h2 class="h3 mb-1">Skincare</h2>
            <p class="section-subtext mb-0">Shop gentle daily essentials for cleansing, brightening, and hydration.</p>
        </div>
        <a class="chip-link" href="${ctx}/category?slug=skincare">View All</a>
    </div>
    <div class="row g-4">
        <c:forEach var="product" items="${skincareProducts}">
            <%@ include file="includes/product-card.jspf" %>
        </c:forEach>
    </div>
</section>

<c:set var="electronicsProducts" value="${productsByCategory['Electronics']}" />
<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Electronics</span>
            <h2 class="h3 mb-1">Electronics</h2>
            <p class="section-subtext mb-0">Shop smart devices and everyday tech essentials.</p>
        </div>
        <a class="chip-link" href="${ctx}/category?slug=electronics">View All</a>
    </div>
    <div class="row g-4">
        <c:forEach var="product" items="${electronicsProducts}">
            <%@ include file="includes/product-card.jspf" %>
        </c:forEach>
    </div>
</section>

<c:set var="fashionProducts" value="${productsByCategory['Fashion']}" />
<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Fashion</span>
            <h2 class="h3 mb-1">Fashion</h2>
            <p class="section-subtext mb-0">Browse everyday fits and polished wardrobe staples.</p>
        </div>
        <a class="chip-link" href="${ctx}/category?slug=fashion">View All</a>
    </div>
    <div class="row g-4">
        <c:forEach var="product" items="${fashionProducts}">
            <%@ include file="includes/product-card.jspf" %>
        </c:forEach>
    </div>
</section>

<c:set var="accessoriesProducts" value="${productsByCategory['Accessories']}" />
<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Accessories</span>
            <h2 class="h3 mb-1">Accessories</h2>
            <p class="section-subtext mb-0">Discover everyday add-ons that balance style and utility.</p>
        </div>
        <a class="chip-link" href="${ctx}/category?slug=accessories">View All</a>
    </div>
    <div class="row g-4">
        <c:forEach var="product" items="${accessoriesProducts}">
            <%@ include file="includes/product-card.jspf" %>
        </c:forEach>
    </div>
</section>

<c:set var="homeProducts" value="${productsByCategory['Home & Lifestyle']}" />
<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Home & Lifestyle</span>
            <h2 class="h3 mb-1">Home &amp; Lifestyle</h2>
            <p class="section-subtext mb-0">Explore stylish and practical picks for modern homes.</p>
        </div>
        <a class="chip-link" href="${ctx}/category?slug=home-lifestyle">View All</a>
    </div>
    <div class="row g-4">
        <c:forEach var="product" items="${homeProducts}">
            <%@ include file="includes/product-card.jspf" %>
        </c:forEach>
    </div>
</section>

<c:set var="footwearProducts" value="${productsByCategory['Footwear']}" />
<section class="mb-5">
    <div class="section-head">
        <div>
            <span class="section-kicker">Footwear</span>
            <h2 class="h3 mb-1">Footwear</h2>
            <p class="section-subtext mb-0">Find versatile shoes built for comfort and daily wear.</p>
        </div>
        <a class="chip-link" href="${ctx}/category?slug=footwear">View All</a>
    </div>
    <div class="row g-4">
        <c:forEach var="product" items="${footwearProducts}">
            <%@ include file="includes/product-card.jspf" %>
        </c:forEach>
    </div>
</section>

<%@ include file="includes/footer.jspf" %>
