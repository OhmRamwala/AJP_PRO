<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Login" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<div class="row justify-content-center">
    <div class="col-lg-6 col-xl-5">
        <div class="summary-panel p-4 p-lg-5">
            <h1 class="h3 mb-3">Login to your account</h1>
            <p class="text-secondary mb-4">Use your registered email to continue shopping or access the admin panel.</p>

            <form method="post" action="${ctx}/login">
                <div class="mb-3">
                    <label class="form-label" for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email" value="${formEmail}" required>
                </div>
                <div class="mb-4">
                    <label class="form-label" for="password">Password</label>
                    <input class="form-control" type="password" id="password" name="password" required>
                </div>
                <button class="btn btn-dark w-100" type="submit">Login</button>
            </form>

            <p class="text-secondary mt-4 mb-0">New here? <a href="${ctx}/register">Create an account</a></p>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jspf" %>
