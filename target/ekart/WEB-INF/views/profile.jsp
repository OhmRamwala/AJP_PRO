<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Profile" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="summary-panel p-4 p-lg-5">
    <span class="section-kicker">Profile</span>
    <h1 class="h3 mb-3">Your account</h1>
    <div class="row g-4">
        <div class="col-md-6">
            <div class="detail-panel p-4 h-100">
                <div class="muted-label mb-2">Name</div>
                <div class="fw-semibold"><c:out value="${currentUser.name}" /></div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="detail-panel p-4 h-100">
                <div class="muted-label mb-2">Email</div>
                <div class="fw-semibold"><c:out value="${currentUser.email}" /></div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="detail-panel p-4 h-100">
                <div class="muted-label mb-2">Role</div>
                <div class="fw-semibold"><c:out value="${currentUser.role}" /></div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="detail-panel p-4 h-100">
                <div class="muted-label mb-2">Quick Links</div>
                <div class="d-flex flex-wrap gap-2">
                    <a class="btn btn-outline-dark btn-sm" href="${ctx}/my-orders">My Orders</a>
                    <a class="btn btn-outline-dark btn-sm" href="${ctx}/products">Shop More</a>
                    <c:if test="${currentUser.admin}">
                        <a class="btn btn-outline-dark btn-sm" href="${ctx}/admin">Admin</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="includes/footer.jspf" %>
