<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Edit Product" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="store-panel p-4 p-lg-5 mb-4">
    <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3">
        <div>
            <span class="section-kicker">Admin</span>
            <h1 class="display-6 fw-bold mb-2">Edit product</h1>
            <p class="section-subtext mb-0">Update the product details and save the changes back to the catalog.</p>
        </div>
        <div>
            <a class="btn btn-outline-dark" href="${ctx}/admin">Back to Dashboard</a>
        </div>
    </div>
</section>

<div class="row justify-content-center">
    <div class="col-xl-8">
        <div class="admin-panel p-4 p-lg-5">
            <form method="post" action="${ctx}/admin/product/edit">
                <input type="hidden" name="id" value="${product.id}">
                <div class="mb-3">
                    <label class="form-label" for="name">Name</label>
                    <input class="form-control" type="text" id="name" name="name" value="${product.name}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="description">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="5" required><c:out value="${product.description}" /></textarea>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label" for="price">Price</label>
                        <input class="form-control" type="number" id="price" name="price" min="0" step="0.01" value="${product.price}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="stock">Stock</label>
                        <input class="form-control" type="number" id="stock" name="stock" min="0" value="${product.stock}" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="category">Category</label>
                        <select class="form-select" id="category" name="category" required>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.name}" ${category.name eq product.category ? 'selected' : ''}>
                                    <c:out value="${category.name}" />
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="mt-3 mb-4">
                    <label class="form-label" for="imageUrl">Image URL</label>
                    <input class="form-control" type="url" id="imageUrl" name="imageUrl" value="${product.imageUrl}" placeholder="https://...">
                </div>
                <div class="d-flex flex-column flex-sm-row justify-content-end gap-2">
                    <a class="btn btn-outline-secondary" href="${ctx}/admin">Cancel</a>
                    <button class="btn btn-dark" type="submit">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@ include file="includes/footer.jspf" %>
