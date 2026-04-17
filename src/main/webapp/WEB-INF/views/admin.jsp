<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Admin" />
<%@ include file="includes/header.jspf" %>
<%@ include file="includes/messages.jspf" %>

<section class="store-panel admin-hero p-4 p-lg-5 mb-5">
    <div class="row g-4 align-items-center">
        <div class="col-lg-7">
            <span class="section-kicker">Admin Dashboard</span>
            <h1 class="display-6 fw-bold mb-2">Control the storefront from one place</h1>
            <p class="section-subtext mb-0">Monitor users, products, and orders while keeping category browsing and search live for shoppers.</p>
        </div>
        <div class="col-lg-5">
            <div class="row g-3">
                <div class="col-4">
                    <div class="metric-card text-center">
                        <span class="muted-label">Users</span>
                        <strong>${fn:length(users)}</strong>
                    </div>
                </div>
                <div class="col-4">
                    <div class="metric-card text-center">
                        <span class="muted-label">Products</span>
                        <strong>${fn:length(products)}</strong>
                    </div>
                </div>
                <div class="col-4">
                    <div class="metric-card text-center">
                        <span class="muted-label">Orders</span>
                        <strong>${fn:length(orders)}</strong>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<div class="row g-4">
    <div class="col-xl-4">
        <div class="admin-panel p-4">
            <h2 class="h4 mb-3">Add Product</h2>
            <form method="post" action="${ctx}/admin/product/add">
                <div class="mb-3">
                    <label class="form-label" for="name">Name</label>
                    <input class="form-control" type="text" id="name" name="name" required>
                </div>
                <div class="mb-3">
                    <label class="form-label" for="description">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                </div>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <label class="form-label" for="price">Price</label>
                        <input class="form-control" type="number" id="price" name="price" min="0" step="0.01" required>
                    </div>
                    <div class="col-sm-6">
                        <label class="form-label" for="stock">Stock</label>
                        <input class="form-control" type="number" id="stock" name="stock" min="0" required>
                    </div>
                </div>
                <div class="mt-3">
                    <label class="form-label" for="category">Category</label>
                    <select class="form-select" id="category" name="category" required>
                        <option value="">Select category</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.name}"><c:out value="${category.name}" /></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mt-3 mb-4">
                    <label class="form-label" for="imageUrl">Image URL</label>
                    <input class="form-control" type="url" id="imageUrl" name="imageUrl" placeholder="https://...">
                </div>
                <button class="btn btn-dark w-100" type="submit">Add Product</button>
            </form>
        </div>
    </div>

    <div class="col-xl-8">
        <div class="admin-panel p-4 mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h4 mb-0">Users</h2>
                <span class="badge text-bg-dark">${fn:length(users)} accounts</span>
            </div>

            <c:choose>
                <c:when test="${empty users}">
                    <div class="alert alert-info mb-0">No users found.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>#${user.id}</td>
                                    <td><c:out value="${user.name}" /></td>
                                    <td class="wrap-cell"><c:out value="${user.email}" /></td>
                                    <td><span class="badge ${user.admin ? 'text-bg-dark' : 'text-bg-secondary'}"><c:out value="${user.role}" /></span></td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="admin-panel p-4 mb-4">
            <div class="d-flex flex-column flex-lg-row justify-content-between align-items-lg-center gap-3 mb-3">
                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <h2 class="h4 mb-0">Products</h2>
                    <span class="badge text-bg-dark">${fn:length(products)} items</span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <label class="form-label mb-0" for="adminCategoryFilter">Category</label>
                    <select class="form-select admin-filter-select" id="adminCategoryFilter">
                        <option value="all">All</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${fn:toLowerCase(category.name)}"><c:out value="${category.name}" /></option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty products}">
                    <div class="alert alert-info mb-0">No products found.</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th class="text-end">Edit</th>
                            </tr>
                            </thead>
                            <tbody id="adminProductsTableBody">
                            <c:forEach var="product" items="${products}">
                                <tr data-category="${fn:toLowerCase(product.category)}">
                                    <td>#${product.id}</td>
                                    <td class="wrap-cell">
                                        <div class="fw-semibold"><c:out value="${product.name}" /></div>
                                    </td>
                                    <td><span class="badge text-bg-light border"><c:out value="${product.category}" /></span></td>
                                    <td>Rs. <fmt:formatNumber value="${product.price}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                    <td>${product.stock}</td>
                                    <td class="text-end">
                                        <div class="dropdown">
                                            <button class="btn btn-sm btn-outline-dark dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                Edit
                                            </button>
                                            <ul class="dropdown-menu dropdown-menu-end">
                                                <li>
                                                    <a class="dropdown-item" href="${ctx}/admin/product/edit?id=${product.id}">Edit Product</a>
                                                </li>
                                                <li>
                                                    <form method="post" action="${ctx}/admin/product/delete" onsubmit="return confirm('Delete this product?');">
                                                        <input type="hidden" name="id" value="${product.id}">
                                                        <button class="dropdown-item text-danger" type="submit">Delete</button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="admin-panel p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="h4 mb-0">Orders</h2>
                <span class="badge text-bg-success">${fn:length(orders)} orders</span>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="alert alert-info mb-0">No orders have been placed yet.</div>
                </c:when>
                <c:otherwise>
                    <div class="accordion" id="orderAccordion">
                        <c:forEach var="order" items="${orders}" varStatus="loop">
                            <div class="accordion-item mb-3 border rounded-4 overflow-hidden">
                                <h2 class="accordion-header">
                                    <button class="accordion-button ${loop.first ? '' : 'collapsed'}" type="button" data-bs-toggle="collapse" data-bs-target="#order-${order.id}">
                                        <div class="w-100 d-flex flex-column flex-lg-row justify-content-between me-3 gap-2">
                                            <span class="fw-semibold">Order #${order.id} by <c:out value="${order.userName}" /></span>
                                            <span class="text-secondary small">${order.createdAtDisplay} | Rs. <fmt:formatNumber value="${order.total}" minFractionDigits="2" maxFractionDigits="2" /> | ${order.statusDisplay}</span>
                                        </div>
                                    </button>
                                </h2>
                                <div id="order-${order.id}" class="accordion-collapse collapse ${loop.first ? 'show' : ''}" data-bs-parent="#orderAccordion">
                                    <div class="accordion-body">
                                        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
                                            <span class="badge ${order.delivered ? 'text-bg-success' : 'text-bg-warning'}">${order.statusDisplay}</span>
                                            <div class="d-flex flex-wrap gap-2">
                                                <c:if test="${not order.delivered}">
                                                    <form method="post" action="${ctx}/admin/order/deliver">
                                                        <input type="hidden" name="id" value="${order.id}">
                                                        <button class="btn btn-sm btn-success" type="submit">Mark Delivered</button>
                                                    </form>
                                                </c:if>
                                                <form method="post" action="${ctx}/admin/order/delete" onsubmit="return confirm('Delete this order?');">
                                                    <input type="hidden" name="id" value="${order.id}">
                                                    <button class="btn btn-sm btn-outline-danger" type="submit">Delete Order</button>
                                                </form>
                                            </div>
                                        </div>
                                        <div class="row g-3 mb-3">
                                            <div class="col-md-3">
                                                <div class="muted-label">Order ID</div>
                                                <div class="fw-semibold">#${order.id}</div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="muted-label">Customer</div>
                                                <div class="fw-semibold"><c:out value="${order.userName}" /></div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="muted-label">Email</div>
                                                <div class="fw-semibold"><c:out value="${order.userEmail}" /></div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="muted-label">Date</div>
                                                <div class="fw-semibold">${order.createdAtDisplay}</div>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="muted-label">Status</div>
                                                <div class="fw-semibold">${order.statusDisplay}</div>
                                            </div>
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
                                                        <td class="wrap-cell"><c:out value="${item.productName}" /></td>
                                                        <td>${item.quantity}</td>
                                                        <td>Rs. <fmt:formatNumber value="${item.price}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                                        <td class="text-end">Rs. <fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2" /></td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="text-end fw-bold mt-3">
                                            Total Amount: Rs. <fmt:formatNumber value="${order.total}" minFractionDigits="2" maxFractionDigits="2" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
    (() => {
        const filter = document.getElementById('adminCategoryFilter');
        const rows = document.querySelectorAll('#adminProductsTableBody tr[data-category]');
        if (!filter || rows.length === 0) {
            return;
        }

        const applyFilter = () => {
            const selected = filter.value;
            rows.forEach((row) => {
                row.classList.toggle('d-none', selected !== 'all' && row.dataset.category !== selected);
            });
        };

        filter.addEventListener('change', applyFilter);
        applyFilter();
    })();
</script>

<%@ include file="includes/footer.jspf" %>
