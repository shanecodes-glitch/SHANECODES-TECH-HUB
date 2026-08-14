// ============================================================
// SHANECODES TECH HUB - MAIN SCRIPT v3.0
// ============================================================

// ============================================================
// TOOL DATA
// ============================================================
const tools = [
    {
        id: 'smart-pc-optimizer',
        name: 'Smart PC Optimizer',
        icon: '⚡',
        description: 'Auto-detects and fixes 20+ PC issues with one click.',
        category: 'repair',
        tags: ['Optimizer', 'Fix'],
        version: 'v1.0',
        file: 'tools/SmartPCOptimizer.ps1'
    },
    {
        id: 'shanecodes-cleaner',
        name: 'ShaneCodes Cleaner',
        icon: '🧹',
        description: 'Deep clean with animated progress bar. Removes temp files, cache, and junk.',
        category: 'utility',
        tags: ['Cleaner', 'Optimize'],
        version: 'v1.0',
        file: 'tools/ShaneCodesCleaner.ps1'
    },
    {
        id: 'quick-fix-wizard',
        name: 'Quick Fix Wizard',
        icon: '🔧',
        description: 'One-click fixes for common Windows problems. Network, DNS, Updates, and more.',
        category: 'repair',
        tags: ['Fix', 'Wizard'],
        version: 'v1.0',
        file: 'tools/QuickFixWizard.ps1'
    },
    {
        id: 'system-restore-manager',
        name: 'System Restore Manager',
        icon: '💾',
        description: 'Create, manage, and restore system restore points with ease.',
        category: 'utility',
        tags: ['Restore', 'Backup'],
        version: 'v1.0',
        file: 'tools/SystemRestoreManager.ps1'
    },
    {
        id: 'boot-speed-analyzer',
        name: 'Boot Speed Analyzer',
        icon: '🚀',
        description: 'Measures boot time and provides optimization recommendations.',
        category: 'diagnostic',
        tags: ['Boot', 'Performance'],
        version: 'v1.0',
        file: 'tools/BootSpeedAnalyzer.ps1'
    },
    {
        id: 'privacy-guard',
        name: 'Privacy Guard',
        icon: '🛡️',
        description: 'Clears browsing history, cookies, and temp files to protect your privacy.',
        category: 'security',
        tags: ['Privacy', 'Cleaner'],
        version: 'v1.0',
        file: 'tools/PrivacyGuard.ps1'
    },
    {
        id: 'battery-health-checker',
        name: 'Battery Health Checker',
        icon: '🔋',
        description: 'Diagnoses laptop battery health and provides usage reports.',
        category: 'diagnostic',
        tags: ['Battery', 'Laptop'],
        version: 'v1.0',
        file: 'tools/BatteryHealthChecker.ps1'
    },
    {
        id: 'startup-manager-pro',
        name: 'Startup Manager Pro',
        icon: '⚙️',
        description: 'Manage startup programs with intelligent recommendations.',
        category: 'utility',
        tags: ['Startup', 'Optimize'],
        version: 'v1.0',
        file: 'tools/StartupManagerPro.ps1'
    },
    {
        id: 'network-refresh-tool',
        name: 'Network Refresh Tool',
        icon: '🌐',
        description: 'One-click network reset. Fixes connectivity issues instantly.',
        category: 'repair',
        tags: ['Network', 'Fix'],
        version: 'v1.0',
        file: 'tools/NetworkRefreshTool.ps1'
    },
    {
        id: 'file-shredder',
        name: 'File Shredder',
        icon: '🗑️',
        description: 'Securely delete files with military-grade overwrite. No recovery possible.',
        category: 'security',
        tags: ['Security', 'Delete'],
        version: 'v1.0',
        file: 'tools/FileShredder.ps1'
    }
];

// ============================================================
// DOM ELEMENTS
// ============================================================
const toolsGrid = document.getElementById('toolsGrid');
const filterBtns = document.querySelectorAll('.filter-btn');
const themeToggle = document.getElementById('themeToggle');
const menuToggle = document.getElementById('menuToggle');
const navMenu = document.getElementById('navMenu');
const navLinks = document.querySelectorAll('.nav-menu a');
const stats = document.querySelectorAll('.stat-number');
const footerTools = document.getElementById('footerTools');

// ============================================================
// THEME TOGGLE
// ============================================================
function toggleTheme() {
    const html = document.documentElement;
    const current = html.getAttribute('data-theme');
    const newTheme = current === 'dark' ? 'light' : 'dark';
    html.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    themeToggle.innerHTML = newTheme === 'dark' ? '🌙' : '☀️';
}

const savedTheme = localStorage.getItem('theme') || 'light';
document.documentElement.setAttribute('data-theme', savedTheme);
themeToggle.innerHTML = savedTheme === 'dark' ? '🌙' : '☀️';
themeToggle.addEventListener('click', toggleTheme);

// ============================================================
// MOBILE MENU
// ============================================================
menuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('open');
});

navLinks.forEach(link => {
    link.addEventListener('click', () => {
        navMenu.classList.remove('open');
        navLinks.forEach(l => l.classList.remove('active'));
        link.classList.add('active');
    });
});

// ============================================================
// SCROLL EFFECTS
// ============================================================
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }

    const sections = document.querySelectorAll('section[id]');
    sections.forEach(section => {
        const top = section.offsetTop - 100;
        const bottom = top + section.offsetHeight;
        const id = section.getAttribute('id');
        const link = document.querySelector(`.nav-menu a[href="#${id}"]`);
        if (link) {
            if (window.scrollY >= top && window.scrollY < bottom) {
                navLinks.forEach(l => l.classList.remove('active'));
                link.classList.add('active');
            }
        }
    });
});

// ============================================================
// RENDER TOOLS
// ============================================================
function renderTools(category = 'all') {
    const filtered = category === 'all'
        ? tools
        : tools.filter(t => t.category === category);

    toolsGrid.innerHTML = filtered.map(tool => `
        <div class="tool-card" data-category="${tool.category}">
            <div class="tool-icon">${tool.icon}</div>
            <h3 class="tool-name">${tool.name}</h3>
            <p class="tool-desc">${tool.description}</p>
            <div class="tool-tags">
                ${tool.tags.map(tag => `
                    <span class="tool-tag ${tool.category}">${tag}</span>
                `).join('')}
            </div>
            <div class="tool-actions">
                <a href="${tool.file}" download class="btn btn-download" onclick="trackDownload('${tool.name}')">
                    ⬇️ Download
                </a>
                <button class="btn btn-info" onclick="showToolInfo('${tool.id}')">
                    ℹ️ Info
                </button>
            </div>
            <div style="font-size:0.7rem;color:var(--text-muted);margin-top:0.5rem;">
                ${tool.version}
            </div>
        </div>
    `).join('');
}

// ============================================================
// FILTER TOOLS
// ============================================================
filterBtns.forEach(btn => {
    btn.addEventListener('click', () => {
        filterBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        renderTools(btn.dataset.filter);
    });
});

// ============================================================
// TOOL ACTIONS
// ============================================================
function trackDownload(toolName) {
    const downloadStat = document.querySelector('.stat-number[data-count="1500"]');
    if (downloadStat) {
        let count = parseInt(downloadStat.textContent) || 0;
        count++;
        downloadStat.textContent = count;
    }
    showToast(`📥 Downloading: ${toolName}`, 'success');
}

function showToolInfo(id) {
    const tool = tools.find(t => t.id === id);
    if (tool) {
        alert(
            `📦 ${tool.name}\n` +
            `Version: ${tool.version}\n` +
            `Category: ${tool.category}\n\n` +
            `${tool.description}\n\n` +
            `📥 Download: ${tool.file}\n` +
            `🏷️ Tags: ${tool.tags.join(', ')}\n\n` +
            `💡 How to use:\n` +
            `1. Download the PS1 file\n` +
            `2. Right-click → Run with PowerShell\n` +
            `3. Follow on-screen instructions`
        );
    }
}

// ============================================================
// COPY COMMAND
// ============================================================
function copyCommand() {
    const commandText = document.getElementById('commandText');
    const text = commandText.textContent;
    
    navigator.clipboard.writeText(text).then(() => {
        const btn = document.querySelector('.btn-copy-command');
        btn.textContent = '✅ Copied!';
        btn.classList.add('copied');
        showToast('✅ Command copied to clipboard!', 'success');
        setTimeout(() => {
            btn.textContent = '📋 Copy';
            btn.classList.remove('copied');
        }, 3000);
    }).catch(() => {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        showToast('✅ Command copied to clipboard!', 'success');
    });
}

function copyMasterCommand() {
    const text = 'irm https://tinyurl.com/Shanetechub | iex';
    
    navigator.clipboard.writeText(text).then(() => {
        showToast('✅ Run command copied! Paste in PowerShell as Admin.', 'success');
    }).catch(() => {
        const textarea = document.createElement('textarea');
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        showToast('✅ Run command copied!', 'success');
    });
}

// ============================================================
// TOAST NOTIFICATION
// ============================================================
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    toast.textContent = message;
    toast.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        padding: 12px 24px;
        border-radius: 12px;
        color: white;
        font-weight: 500;
        z-index: 9999;
        max-width: 400px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        animation: slideIn 0.3s ease;
        background: ${type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#4f46e5'};
    `;
    document.body.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);

// ============================================================
// STATS COUNTER
// ============================================================
let statsAnimated = false;

function animateStats() {
    if (statsAnimated) return;
    const section = document.querySelector('.hero');
    const rect = section.getBoundingClientRect();

    if (rect.top < window.innerHeight && rect.bottom > 0) {
        statsAnimated = true;
        stats.forEach(stat => {
            const target = parseInt(stat.dataset.count);
            let current = 0;
            const increment = Math.ceil(target / 50);
            const interval = setInterval(() => {
                current += increment;
                if (current >= target) {
                    current = target;
                    clearInterval(interval);
                }
                stat.textContent = current;
            }, 30);
        });
    }
}

window.addEventListener('scroll', animateStats);
window.addEventListener('load', animateStats);

// ============================================================
// SKILL BARS ANIMATION
// ============================================================
function animateSkills() {
    const bars = document.querySelectorAll('.skill-fill');
    const section = document.querySelector('.about-section');
    if (!section) return;

    const rect = section.getBoundingClientRect();
    if (rect.top < window.innerHeight && rect.bottom > 0) {
        bars.forEach(bar => {
            const width = bar.style.width;
            bar.style.width = '0%';
            setTimeout(() => {
                bar.style.width = width;
            }, 300);
        });
    }
}

window.addEventListener('scroll', animateSkills);
window.addEventListener('load', animateSkills);

// ============================================================
// POPULATE FOOTER TOOLS
// ============================================================
function populateFooterTools() {
    if (!footerTools) return;
    footerTools.innerHTML = tools.slice(0, 5).map(tool => `
        <li><a href="#tools" onclick="scrollToTools()">${tool.icon} ${tool.name}</a></li>
    `).join('');
}

function scrollToTools() {
    document.getElementById('tools').scrollIntoView({ behavior: 'smooth' });
}

populateFooterTools();

// ============================================================
// CONTACT FORM
// ============================================================
document.getElementById('contactForm')?.addEventListener('submit', function(e) {
    e.preventDefault();
    const formData = new FormData(this);
    const data = Object.fromEntries(formData);

    if (!data.name || !data.email || !data.message) {
        showToast('Please fill in all required fields.', 'error');
        return;
    }

    const subject = encodeURIComponent(`ShaneCodes Support: ${data.subject}`);
    const body = encodeURIComponent(
        `Name: ${data.name}\n` +
        `Email: ${data.email}\n` +
        `Subject: ${data.subject}\n\n` +
        `Message:\n${data.message}`
    );

    window.location.href = `mailto:obinguarshane77@gmail.com?subject=${subject}&body=${body}`;
    showToast('✅ Message sent! We\'ll respond within 24 hours.', 'success');
    this.reset();
});

// ============================================================
// INIT
// ============================================================
renderTools();
console.log('⚡ ShaneCodes Tech Hub v3.0 loaded successfully!');
console.log('📧 Contact: obinguarshane77@gmail.com');
console.log('🚀 Run from web: irm https://tinyurl.com/Shanetechub | iex');