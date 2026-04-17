<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Register" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<div class="row justify-content-center">
    <div class="col-lg-6">
        <div class="summary-panel p-4 p-lg-5">
            <h1 class="h3 mb-3">Create your eKart account</h1>
            <p class="text-secondary mb-4">Registration is quick, then you can save a cart and place orders immediately.</p>

            <form method="post" action="${ctx}/register">
                <div class="mb-3">
                    <label class="form-label" for="name">Full Name</label>
                    <input class="form-control" type="text" id="name" name="name" value="${formName}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email" value="${formEmail}" required>
                </div>
                <div class="mb-4">
                    <label class="form-label" for="password">Password</label>
                    <input class="form-control" type="password" id="password" name="password" minlength="6" required>
                    <div class="form-text">Use at least 6 characters.</div>
                </div>
                <button class="btn btn-warning w-100" type="submit">Register</button>
            </form>

            <p class="text-secondary mt-4 mb-0">Already have an account? <a href="${ctx}/login">Login</a></p>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jspf" %>
