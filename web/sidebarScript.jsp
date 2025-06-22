<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
// Debounce function for resize events
function debounce(func, wait) {
    let timeout;
    return function() {
        const context = this, args = arguments;
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(context, args), wait);
    };
}

document.addEventListener('DOMContentLoaded', function() {
    initComponents();
});

function initComponents() {
    try {
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
                sidebar?.classList.remove('collapsed');
                sidebar?.classList.remove('active');
                sidebarOverlay?.classList.remove('active');
            } else {
                sidebar?.classList.add('collapsed');
                sidebarOverlay?.classList.remove('active');
            }
        }
        
        // Initial check
        checkScreenSize();
        
        // Toggle sidebar collapse/expand
        if (toggleSidebar) {
            toggleSidebar.addEventListener('click', () => {
                sidebar.classList.toggle('collapsed');
                
                // Rotate the icon
                toggleSidebar.innerHTML = sidebar.classList.contains('collapsed') 
                    ? '<i class="fas fa-bars"></i>' 
                    : '<i class="fas fa-times"></i>';
            });
        }
        
        // Mobile toggle for sidebar
        if (mobileToggle) {
            mobileToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
                sidebarOverlay.classList.toggle('active');
            });
        }
        
        // Close sidebar when clicking overlay
        if (sidebarOverlay) {
            sidebarOverlay.addEventListener('click', () => {
                sidebar.classList.remove('active');
                sidebarOverlay.classList.remove('active');
            });
        }
        
        // Notification dropdown toggle
        if (notificationBtn && notificationDropdown) {
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
        }
        
        // Dropdown menu functionality
        function toggleDropdown(element) {
            if (!element || !element.closest) return;
            
            const dropdown = element.closest('.menu-dropdown');
            if (!dropdown) return;
            
            const wasOpen = dropdown.classList.contains('open');
            const arrow = element.querySelector('.menu-arrow');
            const submenu = dropdown.querySelector('.submenu');
            
            // Close all dropdowns first
            document.querySelectorAll('.menu-dropdown.open').forEach(d => {
                d.classList.remove('open');
                const a = d.querySelector('.menu-arrow');
                if (a) a.innerHTML = '&#9662;';
            });
            
            // Open current if wasn't open
            if (!wasOpen) {
                dropdown.classList.add('open');
                if (arrow) arrow.innerHTML = '&#9652;';
                if (submenu) submenu.style.maxHeight = submenu.scrollHeight + 'px';
            } else {
                if (submenu) submenu.style.maxHeight = '0';
            }
            
            // Accessibility updates
            element.setAttribute('aria-expanded', !wasOpen);
            if (submenu) submenu.setAttribute('aria-hidden', wasOpen);
        }
        
        // Initialize dropdown menus
        document.querySelectorAll('.menu-dropdown .parent-item').forEach(item => {
            item.addEventListener('click', function(e) {
                if (window.innerWidth > 992 || e.target.closest('.parent-item')) {
                    e.preventDefault();
                    toggleDropdown(this);
                }
            });
            
            // Accessibility attributes
            item.setAttribute('role', 'button');
            item.setAttribute('aria-expanded', 'false');
            const submenu = item.closest('.menu-dropdown')?.querySelector('.submenu');
            if (submenu) submenu.setAttribute('aria-hidden', 'true');
        });
        
        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
            if (!e.target.closest('.menu-dropdown')) {
                document.querySelectorAll('.menu-dropdown.open').forEach(dropdown => {
                    dropdown.classList.remove('open');
                    const arrow = dropdown.querySelector('.menu-arrow');
                    if (arrow) arrow.innerHTML = '&#9662;';
                });
            }
        });
        
        // Logout functionality with SweetAlert
        if (logoutBtn) {
            logoutBtn.addEventListener('click', (e) => {
                e.preventDefault();
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
                        window.location.href = 'Login.jsp';
                    }
                });
            });
        }
        
        // Mark notifications as read
        if (markRead && unreadItems && notificationCount) {
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
            
            if (mainContent && topbar) {
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
        }
        
        // Initial adjustment
        adjustMainContent();
        
        // Watch for sidebar changes
        let sidebarObserver;
        if (sidebar) {
            sidebarObserver = new MutationObserver(adjustMainContent);
            sidebarObserver.observe(sidebar, { attributes: true });
        }
        
        // Debounced resize handler
        const resizeHandler = debounce(() => {
            checkScreenSize();
            adjustMainContent();
        }, 100);
        
        window.addEventListener('resize', resizeHandler);
        
        // Cleanup function (useful for SPAs)
        window.cleanupSidebar = function() {
            if (sidebarObserver) sidebarObserver.disconnect();
            window.removeEventListener('resize', resizeHandler);
        };
        
    } catch (error) {
        console.error('Error initializing sidebar components:', error);
        // Fallback: Ensure sidebar is visible if initialization fails
        const sidebar = document.getElementById('sidebar');
        if (sidebar) {
            sidebar.classList.remove('collapsed');
            sidebar.style.display = 'block';
        }
    }
}
</script>