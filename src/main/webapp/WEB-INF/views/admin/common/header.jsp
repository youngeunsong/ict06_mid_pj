<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!--begin::Header-->
<nav class="app-header navbar navbar-expand bg-body">
	<!--begin::Container-->
	<div class="container-fluid">
		<!--begin::Start Navbar Links-->
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" data-lte-toggle="sidebar" href="#" role="button">
				<i class="fas fa-bars"></i>
				</a>
			</li>
			<li class="nav-item d-none d-md-block">
				<a href="${path}/adminHome.ad" class="nav-link">ADMIN DASHBOARD</a>
			</li>
		</ul>
		<!--end::Start Navbar Links-->

		<!--begin::End Navbar Links-->
		<ul class="navbar-nav ms-auto align-items-center">
			<!--begin::Navbar Search-->
			<li class="nav-item me-2">
				<a href="${path}/main.do" class="nav-link btn btn-outline-success btn-sm px-2 px-md-3"
					style="border-radius: 20px; font-size: 0.85rem; border-color: #01D281; color: #01D281;">
					<i class="fas fa-external-link-alt"></i>
					<span class="d-none d-md-inline ms-1">User Home</span>
				</a>
			</li>

			<li class="nav-item">
				<a class="nav-link text-danger fw-bold"	href="${path}/logout.do" title="로그아웃">
					<i class="fas fa-power-off"></i>
					<span class="d-none d-md-inline ms-2">LOGOUT</span>
				</a>
			</li>
			<!--end::Navbar Search-->
			<!--begin::Messages Dropdown Menu-->
			<li class="nav-item dropdown"><a class="nav-link"
				data-bs-toggle="dropdown" href="#"> <i class="bi bi-chat-text"></i>
					<span class="navbar-badge badge text-bg-danger">3</span>
			</a>
				<div class="dropdown-menu dropdown-menu-lg dropdown-menu-end">
					<a href="#" class="dropdown-item">
						<!--begin::Message-->
						<div class="d-flex">
							<div class="flex-shrink-0">
								<img src="${path}/resources/assets/img/user1-128x128.jpg"
									alt="User Avatar" class="img-size-50 rounded-circle me-3" />
							</div>
							<div class="flex-grow-1">
								<h3 class="dropdown-item-title">
									Brad Diesel <span class="float-end fs-7 text-danger"> <i
										class="bi bi-star-fill"></i>
									</span>
								</h3>
								<p class="fs-7">Call me whenever you can...</p>
								<p class="fs-7 text-secondary">
									<i class="bi bi-clock-fill me-1"></i> 4 Hours Ago
								</p>
							</div>
						</div>
						<!--end::Message-->
					</a>
					<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item">
						<!--begin::Message-->
						<div class="d-flex">
							<div class="flex-shrink-0">
								<img src="${path}/resources/assets/img/user8-128x128.jpg"
									alt="User Avatar" class="img-size-50 rounded-circle me-3" />
							</div>
							<div class="flex-grow-1">
								<h3 class="dropdown-item-title">
									John Pierce <span class="float-end fs-7 text-secondary">
										<i class="bi bi-star-fill"></i>
									</span>
								</h3>
								<p class="fs-7">I got your message bro</p>
								<p class="fs-7 text-secondary">
									<i class="bi bi-clock-fill me-1"></i> 4 Hours Ago
								</p>
							</div>
						</div>
						<!--end::Message-->
					</a>
					<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item dropdown-footer">See All Messages</a>
				</div>
			</li>
			<!--end::Messages Dropdown Menu-->

			<!--begin::Notifications Dropdown Menu-->
			<li class="nav-item dropdown"><a class="nav-link"
				data-bs-toggle="dropdown" href="#"> <i class="bi bi-bell-fill"></i>
					<span class="navbar-badge badge text-bg-warning">15</span>
			</a>
				<div class="dropdown-menu dropdown-menu-lg dropdown-menu-end">
					<span class="dropdown-item dropdown-header">15 Notifications</span>
					<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item"> <i
						class="bi bi-file-earmark-fill me-2"></i> 3 new reports <span
						class="float-end text-secondary fs-7">2 days</span>
					</a>
					<div class="dropdown-divider"></div>
					<a href="#" class="dropdown-item dropdown-footer"> See All
						Notifications </a>
				</div></li>
			<!--end::Notifications Dropdown Menu-->
			<!--begin::Fullscreen Toggle-->
			<li class="nav-item"><a class="nav-link" href="#"
				data-lte-toggle="fullscreen"> <i data-lte-icon="maximize"
					class="bi bi-arrows-fullscreen"></i> <i data-lte-icon="minimize"
					class="bi bi-fullscreen-exit" style="display: none"></i>
			</a></li>
			<!--end::Fullscreen Toggle-->
			<!--begin::User Menu Dropdown-->
			<li class="nav-item dropdown user-menu"><a href="#"
				class="nav-link dropdown-toggle" data-bs-toggle="dropdown"> <img
					src="${path}/resources/assets/img/user2-160x160.jpg"
					class="user-image rounded-circle shadow" alt="User Image" />
					<span class="d-none d-md-inline ms-1">${sessionScope.sessionID}</span>
			</a>
				<ul class="dropdown-menu dropdown-menu-lg dropdown-menu-end">
					<!--begin::User Image-->
					<li class="user-header text-bg-primary"><img
						src="${path}/resources/assets/img/user2-160x160.jpg"
						class="rounded-circle shadow" alt="User Image" />
						<p>
							Alexander Pierce - Web Developer <small>Member since Nov.
								2023</small>
						</p></li>
					<!--end::User Image-->
					<!--begin::Menu Body-->
					<li class="user-body">
						<!--begin::Row-->
						<div class="row">
							<div class="col-4 text-center">
								<a href="#">Followers</a>
							</div>
							<div class="col-4 text-center">
								<a href="#">Sales</a>
							</div>
							<div class="col-4 text-center">
								<a href="#">Friends</a>
							</div>
						</div> <!--end::Row-->
					</li>
					<!--end::Menu Body-->
					<!--begin::Menu Footer-->
					<li class="user-footer"><a href="#"
						class="btn btn-default btn-flat">Profile</a> <a href="#"
						class="btn btn-default btn-flat float-end">Sign out</a></li>
					<!--end::Menu Footer-->
				</ul></li>
			<!--end::User Menu Dropdown-->
		</ul>
		<!--end::End Navbar Links-->
	</div>
	<!--end::Container-->
</nav>
<!--end::Header-->