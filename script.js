// ============================================================
// SHANECODES TECH HUB - MAIN SCRIPT
// ============================================================

// ============================================================
// TOOL DATA
// ============================================================
const tools = [
    {
        id: 'diagnostic',
        name: 'Windows Diagnostic Tool',
        icon: '🔍',
        description: 'Collects comprehensive system information and generates diagnostic reports.',
        category: 'diagnostic',
        tags: ['Diagnostic', 'System Info'],
        version: 'v2.0',
        download: 'tools/Windows_Diagnostic.ps1'
    },
    {
        id: 'repair',
        name: 'Windows Repair Tool',
        icon: '🛠️',
        description: 'Automatically fixes common Windows issues including activation, updates, and system files.',
        category: 'repair',
        tags: ['Repair', 'Fix'],
        version: 'v11.0',
        download: 'tools/Windows_Repair_Advanced.ps1'
    },
    {
        id: 'activation',
        name: 'Activation Fixer',
        icon: '🔑',
        description: 'Resolves Windows activation issues and licensing errors.',
        category: 'repair',
        tags: ['Activation', 'License'],
        version: 'v3.0',
        download: 'tools/Activation_Fixer.ps1'
    },
    {
        id: 'cleaner',
        name: 'System Cleaner Pro',
        icon: '🧹',
        description: 'Removes junk files, temp data, and optimizes system performance.',
        category: 'utility',
        tags: ['Cleaner', 'Optimize'],
        version: 'v4.0',
        download: 'tools/System_Cleaner.ps1'
    },
    {
        id: 'security',
        name: 'Security Scanner',
        icon: '🛡️',
        description: 'Scans for security vulnerabilities and provides hardening recommendations.',
        category: 'security',
        tags: ['Security', 'Scan'],
        version: 'v1.5',
        download: 'tools/Security_Scanner.ps1'
    },
    {
        id: 'network',
        name: 'Network Diagnostic',
        icon: '🌐',
        description: 'Analyzes network connectivity, DNS, and resolves common network issues.',
        category: 'diagnostic',
        tags: ['Network', 'DNS'],
        version: 'v2.0',
        download: 'tools/Network_Diagnostic.ps1'
    },
    {
        id: 'update',
        name: 'Update Manager',
        icon: '⬆️',
        description: 'Manages Windows updates, controls update schedules, and fixes update issues.',
        category: 'utility',
        tags: ['Update', 'Windows Update'],
        version: 'v3.0',
        download: 'tools/Update_Manager.ps1'
    },
    {
        id: 'backup',
        name: 'Backup & Restore',
        icon: '💾',
        description: 'Creates system restore points and backups critical system files.',
        category: 'utility',
        tags: ['Backup', 'Restore'],
        version: 'v2.0',
        download: 'tools/Backup_Restore.ps1'
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

// Load saved theme
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

// Close menu on link click
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
    
    // Active nav link
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
                <button class="btn btn-download" onclick="downloadTool('${tool.download}')">
                    ⬇️ Download
                </button>
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
function downloadTool(url) {
    // Simulate download
    const tool = tools.find(t => t.download === url);
    if (tool) {
        // Create download link
        const link = document.createElement('a');
        link.href = url;
        link.download = url.split('/').pop();
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        // Update download count
        updateStats('download');
    }
}

function showToolInfo(id) {
    const tool = tools.find(t => t.id === id);
    if (tool) {
        alert(
            `📦 ${tool.name}\n` +
            `Version: ${tool.version}\n` +
            `Category: ${tool.category}\n\n` +
            `${tool.description}\n\n` +
            `📥 Download: ${tool.download}\n` +
            `🏷️ Tags: ${tool.tags.join(', ')}`
        );
    }
}

// ============================================================
// STATS COUNTER
// ============================================================
function updateStats(type) {
    // Simple demo - increment download count
    const downloadStat = document.querySelector('.stat-number[data-count]');
    if (downloadStat) {
        let count = parseInt(downloadStat.textContent) || 0;
        if (type === 'download') {
            count++;
            downloadStat.textContent = count;
        }
    }
}

// Animate stats on scroll
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
    
    // Simple validation
    if (!data.name || !data.email || !data.message) {
        alert('Please fill in all required fields.');
        return;
    }
    
    // Send email via mailto
    const subject = encodeURIComponent(`ShaneCodes Support: ${data.subject}`);
    const body = encodeURIComponent(
        `Name: ${data.name}\n` +
        `Email: ${data.email}\n` +
        `Subject: ${data.subject}\n\n` +
        `Message:\n${data.message}`
    );
    
    window.location.href = `mailto:shanecodes@proton.me?subject=${subject}&body=${body}`;
    
    // Show success
    alert('✅ Your message has been sent! We\'ll get back to you within 24 hours.');
    this.reset();
});

// ============================================================
// INIT
// ============================================================
renderTools();
console.log('⚡ ShaneCodes Tech Hub loaded successfully!');