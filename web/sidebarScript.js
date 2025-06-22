// Fetch and insert components
document.addEventListener('DOMContentLoaded', function() {
    // Insert topbar
    document.getElementById('topbar').innerHTML = `
        <div class="topbar-container">
            <div class="toggle-btn" id="toggleSidebar">
                <i class="fas fa-bars"></i>
            </div>

            <div class="topbar-left">
                <div class="mobile-toggle" id="mobileToggle">
                    <i class="fas fa-bars"></i>
                </div>
                
                <div class="search-container">
                    <i class="fas fa-search search-icon"></i>
                    <input type="text" placeholder="Search...">
                </div>
            </div>
            
            <div class="topbar-right">
                <div class="notification-btn" id="notificationBtn">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">3</span>
                    
                    <div class="notification-dropdown" id="notificationDropdown">
                        <div class="notification-header">
                            <div class="notification-title">Notifications</div>
                            <div class="mark-read">Mark all as read</div>
                        </div>
                        <div class="notification-list">
                            <div class="notification-item unread">
                                <div class="notification-icon">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-text">Your project proposal has been approved</div>
                                    <div class="notification-time">2 hours ago</div>
                                </div>
                            </div>
                            <div class="notification-item unread">
                                <div class="notification-icon">
                                    <i class="fas fa-exclamation-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-text">Deadline approaching: Progress Report due</div>
                                    <div class="notification-time">5 hours ago</div>
                                </div>
                            </div>
                            <div class="notification-item">
                                <div class="notification-icon">
                                    <i class="fas fa-comment"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-text">Dr. Johnson commented on your document</div>
                                    <div class="notification-time">Yesterday</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <a href="ProfileServlet" class="topbar-profile">
                    <div class="topbar-img">
                        <img src="DownloadAvatar?filename=${window.userData.userAvatar || 'default.png'}" 
                            alt="Profile" style="width:35px; height:35px; border-radius:50%; object-fit:cover;">
                    </div>
                    <div class="topbar-name">${window.userData.firstLine}</div>
                    <span class="profile-tooltip">View Profile</span>
                </a>
            </div>
        </div>
    `;
    
    // Insert sidebar
    document.getElementById('sidebar').innerHTML = `
        <div class="sidebar-header">
            <div class="user-profile">
                <div class="profile-img">
                    <img src="DownloadAvatar?filename=${window.userData.userAvatar || 'default.png'}&background=b399d4&color=4b2e83" alt="Profile">
                </div>
                <div class="user-info">
                    <div class="user-name">
                        <div>${window.userData.firstLine}</div>
                        <div>${window.userData.secondLine}</div>
                    </div>
                    <div class="user-role">${window.userData.displayRole}</div>
                </div>
            </div>
        </div>
        
        <div class="sidebar-menu">
            <!-- Dashboard - Common to all roles -->
            <a href="Dashboard.jsp" class="menu-item ${window.location.pathname.endsWith('/Dashboard.jsp') ? 'active' : ''}">
                <div class="menu-icon"><i class="fas fa-home"></i></div>
                <div class="menu-text">Dashboard</div>
            </a>

            ${window.userData.isSupervisor ? `
                <!-- Supervisor Menu -->
                <a href="ProfileServlet" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-user"></i></div>
                    <div class="menu-text">Profile</div>
                </a>

                <a href="SupervisorStudent.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-user-graduate"></i></div>
                    <div class="menu-text">Students</div>
                </a>

                <a href="Form.jsp" class="menu-item ${window.location.pathname.toLowerCase().endsWith('form.jsp') ? 'active' : ''}">
                    <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="menu-text">Forms</div>
                </a>

                <div class="menu-dropdown">
                    <div class="menu-item parent-item">
                        <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
                        <div class="menu-text">Review</div>
                        <div class="menu-arrow">&#9662;</div>
                    </div>
                    <div class="submenu">
                        <a href="Plagiarism.jsp" class="submenu-item">Form</a>
                        <a href="#" class="submenu-item">Plagiarism</a>
                    </div>
                </div>

                <a href="#" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-folder-open"></i></div>
                    <div class="menu-text">Past Projects</div>
                </a>
            ` : ''}

            ${window.userData.isStudent ? `
                <!-- Student Menu -->
                <a href="ProfileServlet" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-user"></i></div>
                    <div class="menu-text">Profile</div>
                </a>

                <a href="ProposalIdea.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-lightbulb"></i></div>
                    <div class="menu-text">Proposal Idea</div>
                </a>

                <a href="Form.jsp" class="menu-item ${window.location.pathname.toLowerCase().endsWith('form.jsp') ? 'active' : ''}">
                    <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="menu-text">Forms</div>
                </a>

                <a href="ProgressReportSubmission.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-tasks"></i></div>
                    <div class="menu-text">Progress Report</div>
                </a>

                <a href="SubmitFinalReports.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-file-pdf"></i></div>
                    <div class="menu-text">Final Reports</div>
                </a>

                <a href="Evaluation.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-check-circle"></i></div>
                    <div class="menu-text">Evaluation</div>
                </a>

                <a href="Guideline.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-book"></i></div>
                    <div class="menu-text">Guideline</div>
                </a>

                <a href="StudentConsultationLog.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-comments"></i></div>
                    <div class="menu-text">Consultation Log</div>
                </a>

                <a href="PastReports.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-archive"></i></div>
                    <div class="menu-text">Past Reports</div>
                </a>
            ` : ''}

            ${window.userData.isLecturer ? `
                <!-- Lecturer Menu -->
                <a href="ProfileServlet" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-user"></i></div>
                    <div class="menu-text">Profile</div>
                </a>

                <div class="menu-dropdown">
                    <div class="menu-item parent-item">
                        <div class="menu-icon"><i class="fas fa-user-graduate"></i></div>
                        <div class="menu-text">Students</div>
                        <div class="menu-arrow">&#9662;</div>
                    </div>
                    <div class="submenu">
                        <a href="StudentList?course=1" class="submenu-item">CSP600</a>
                        <a href="StudentList?course=2" class="submenu-item">CSP650</a>
                    </div>
                </div>

                <div class="menu-dropdown">
                    <div class="menu-item parent-item">
                        <div class="menu-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                        <div class="menu-text">Supervisors</div>
                        <div class="menu-arrow">&#9662;</div>
                    </div>
                    <div class="submenu">
                        <a href="SupervisorList.jsp" class="submenu-item">Supervisors</a>
                        <a href="ExaminerList.jsp" class="submenu-item">Examiners</a>
                    </div>
                </div>

                <a href="Form.jsp" class="menu-item ${window.location.pathname.toLowerCase().endsWith('form.jsp') ? 'active' : ''}">
                    <div class="menu-icon"><i class="fas fa-file-alt"></i></div>
                    <div class="menu-text">Forms</div>
                </a>

                <a href="LecturerReports.jsp" class="menu-item">
                    <div class="menu-icon"><i class="fas fa-chart-bar"></i></div>
                    <div class="menu-text">Reports</div>
                </a>
            ` : ''}

            <div class="divider"></div>

            <!-- Common Settings & Logout -->
            <a href="#" class="menu-item">
                <div class="menu-icon"><i class="fas fa-question-circle"></i></div>
                <div class="menu-text">Help & Support</div>
            </a>

            <div class="divider"></div>

            <a href="Login.jsp" class="menu-item" id="logoutBtn">
                <div class="menu-icon"><i class="fas fa-sign-out-alt"></i></div>
                <div class="menu-text">Logout</div>
            </a>
        </div>
    `;

    // Initialize functionality
    initComponents();
});

function initComponents() {
    const sidebar = document.getElementById('sidebar');
    const sidebarOverlay = document.getElementById('sidebarOverlay');
    const toggleSidebar = document.getElementById('toggleSidebar');
    const mobileToggle = document.getElementById('mobileToggle');
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationDropdown = document.getElementById('notificationDropdown');
    const logoutBtn = document.getElementById('logoutBtn');
    const markRead = document.querySelector('.mark-read');
    const unreadItems = document.querySelectorAll('.notification-item.unread');
    const notificationCount = document.querySelector('.notification-count');
    
    // Check screen size and set initial sidebar state
    function checkScreenSize() {
        if (window.innerWidth <= 992) {
            sidebar.classList.remove('collapsed');
            sidebar.classList.remove('active');
            sidebarOverlay.classList.remove('active');
        } else {
            sidebar.classList.add('collapsed');
            sidebarOverlay.classList.remove('active');
        }
    }
    
    // Initial check
    checkScreenSize();
    
    // Toggle sidebar collapse/expand
    toggleSidebar.addEventListener('click', () => {
        sidebar.classList.toggle('collapsed');
        
        // Rotate the icon
        if (sidebar.classList.contains('collapsed')) {
            toggleSidebar.innerHTML = '<i class="fas fa-bars"></i>';
        } else {
            toggleSidebar.innerHTML = '<i class="fas fa-times"></i>';
        }
    });
    
    // Mobile toggle for sidebar
    mobileToggle.addEventListener('click', () => {
        sidebar.classList.toggle('active');
        sidebarOverlay.classList.toggle('active');
    });
    
    // Close sidebar when clicking overlay
    sidebarOverlay.addEventListener('click', () => {
        sidebar.classList.remove('active');
        sidebarOverlay.classList.remove('active');
    });
    
    // Notification dropdown toggle
    notificationBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        notificationDropdown.classList.toggle('active');
    });
    
    // Close notification dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!notificationBtn.contains(e.target)) {
            notificationDropdown.classList.remove('active');
        }
    });
    
    // Logout functionality with SweetAlert
    logoutBtn.addEventListener('click', () => {
        Swal.fire({
            title: 'Logout Confirmation',
            text: 'Are you sure you want to logout?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#4b2e83',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, Logout',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Logged Out!',
                    text: 'You have been successfully logged out.',
                    icon: 'success',
                    confirmButtonColor: '#4b2e83',
                    timer: 2000,
                    timerProgressBar: true
                }).then(() => {
                    // Redirect to login page
                    window.location.href = 'login.html';
                });
            }
        });
    });
    
    // Mark notifications as read
    if (markRead) {
        markRead.addEventListener('click', () => {
            unreadItems.forEach(item => {
                item.classList.remove('unread');
            });
            notificationCount.textContent = '0';
        });
    }
    
    // Adjust main content position based on sidebar state
    function adjustMainContent() {
        const mainContent = document.querySelector('.main-content');
        const topbar = document.getElementById('topbar');
        
        if (window.innerWidth > 992) {
            if (sidebar.classList.contains('collapsed')) {
                mainContent.style.marginLeft = '70px';
                topbar.style.left = '70px';
            } else {
                mainContent.style.marginLeft = '250px';
                topbar.style.left = '250px';
            }
        } else {
            mainContent.style.marginLeft = '0';
            topbar.style.left = '0';
        }
    }
    
    // Initial adjustment
    adjustMainContent();
    
    // Watch for sidebar changes
    const observer = new MutationObserver(adjustMainContent);
    observer.observe(sidebar, { attributes: true });
    
    // Watch for window resize
    window.addEventListener('resize', () => {
        checkScreenSize();
        adjustMainContent();
    });
}