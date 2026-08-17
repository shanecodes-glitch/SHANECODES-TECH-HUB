document.addEventListener('DOMContentLoaded', () => {

  /* ==========================================================
     DATA — All 11 tools (match sa actual PS1 files mo)
     ========================================================== */
  const REPO_BASE = 'https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/';

  const tools = [
    {
      id: 'smart-pc-optimizer',
      name: 'Smart PC Optimizer',
      icon: '⚡',
      description: 'Auto-detects and fixes 20+ PC issues with one click.',
      category: 'repair',
      tags: ['Optimizer', 'Fix'],
      version: 'v1.0',
      file: 'tools/SmartPCOptimizer.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/SmartPCOptimizer.ps1 | iex'
    },
    {
      id: 'shanecodes-cleaner',
      name: 'ShaneCodes Cleaner',
      icon: '🧹',
      description: 'Deep clean with animated progress bar. Removes temp files, cache, and junk.',
      category: 'utility',
      tags: ['Cleaner', 'Optimize'],
      version: 'v1.0',
      file: 'tools/ShaneCodesCleaner.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/ShaneCodesCleaner.ps1 | iex'
    },
    {
      id: 'quick-fix-wizard',
      name: 'Quick Fix Wizard',
      icon: '🔧',
      description: 'One-click fixes for common Windows problems. Network, DNS, Updates, and more.',
      category: 'repair',
      tags: ['Fix', 'Wizard'],
      version: 'v1.0',
      file: 'tools/QuickFixWizard.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/QuickFixWizard.ps1 | iex'
    },
    {
      id: 'system-restore-manager',
      name: 'System Restore Manager',
      icon: '💾',
      description: 'Create, manage, and restore system restore points with ease.',
      category: 'utility',
      tags: ['Restore', 'Backup'],
      version: 'v1.0',
      file: 'tools/SystemRestoreManager.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/SystemRestoreManager.ps1 | iex'
    },
    {
      id: 'boot-speed-analyzer',
      name: 'Boot Speed Analyzer',
      icon: '🚀',
      description: 'Measures boot time and provides optimization recommendations.',
      category: 'diagnostic',
      tags: ['Boot', 'Performance'],
      version: 'v1.0',
      file: 'tools/BootSpeedAnalyzer.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/BootSpeedAnalyzer.ps1 | iex'
    },
    {
      id: 'privacy-guard',
      name: 'Privacy Guard',
      icon: '🛡️',
      description: 'Clears browsing history, cookies, and temp files to protect your privacy.',
      category: 'security',
      tags: ['Privacy', 'Cleaner'],
      version: 'v1.0',
      file: 'tools/PrivacyGuard.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/PrivacyGuard.ps1 | iex'
    },
    {
      id: 'battery-health-checker',
      name: 'Battery Health Checker',
      icon: '🔋',
      description: 'Diagnoses laptop battery health and provides usage reports.',
      category: 'diagnostic',
      tags: ['Battery', 'Laptop'],
      version: 'v1.0',
      file: 'tools/BatteryHealthChecker.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/BatteryHealthChecker.ps1 | iex'
    },
    {
      id: 'startup-manager-pro',
      name: 'Startup Manager Pro',
      icon: '⚙️',
      description: 'Manage startup programs with intelligent recommendations.',
      category: 'utility',
      tags: ['Startup', 'Optimize'],
      version: 'v1.0',
      file: 'tools/StartupManagerPro.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/StartupManagerPro.ps1 | iex'
    },
    {
      id: 'network-refresh-tool',
      name: 'Network Refresh Tool',
      icon: '🌐',
      description: 'One-click network reset. Fixes connectivity issues instantly.',
      category: 'repair',
      tags: ['Network', 'Fix'],
      version: 'v1.0',
      file: 'tools/NetworkRefreshTool.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/NetworkRefreshTool.ps1 | iex'
    },
    {
      id: 'file-shredder',
      name: 'File Shredder',
      icon: '🗑️',
      description: 'Securely delete files with military-grade overwrite. No recovery possible.',
      category: 'security',
      tags: ['Security', 'Delete'],
      version: 'v1.0',
      file: 'tools/FileShredder.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/FileShredder.ps1 | iex'
    },
    {
      id: 'activation-fixer',
      name: 'Windows Activation Fixer',
      icon: '🔑',
      description: 'Fixes Windows activation issues. Downloads and runs the repair tool automatically.',
      category: 'repair',
      tags: ['Activation', 'License', 'Fix'],
      version: 'v3.0',
      file: 'tools/Activation_Fixer.ps1',
      command: 'irm https://raw.githubusercontent.com/shanecodes-glitch/SHANECODES-TECH-HUB/main/tools/Activation_Fixer.ps1 | iex'
    }
  ];

  /* ---------- Utilities ---------- */
  function escapeHtml(str) {
    return String(str).replace(/[&<>"']/g, (c) => ({
      '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
    }[c]));
  }

  function prefersReducedMotion() {
    return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  }

  /* ---------- Theme (dark/light + localStorage) ---------- */
  const root = document.documentElement;
  const themeToggle = document.getElementById('themeToggle');

  function initTheme() {
    const stored = localStorage.getItem('shanecodes-theme');
    const theme = stored || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    root.setAttribute('data-theme', theme);
  }
  themeToggle.addEventListener('click', () => {
    const next = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
    root.setAttribute('data-theme', next);
    localStorage.setItem('shanecodes-theme', next);
  });
  initTheme();

  /* ---------- Mobile menu ---------- */
  const hamburger = document.getElementById('hamburger');
  const navMenu = document.getElementById('navMenu');
  hamburger.addEventListener('click', () => {
    const isActive = navMenu.classList.toggle('active');
    hamburger.classList.toggle('active', isActive);
    hamburger.setAttribute('aria-expanded', String(isActive));
  });
  navMenu.querySelectorAll('.nav-link').forEach(link => {
    link.addEventListener('click', () => {
      navMenu.classList.remove('active');
      hamburger.classList.remove('active');
      hamburger.setAttribute('aria-expanded', 'false');
    });
  });

  /* ---------- Navbar background + active link on scroll ---------- */
  const navbar = document.getElementById('navbar');
  const navLinks = document.querySelectorAll('.nav-link[data-section]');
  const spySections = Array.from(navLinks)
    .map(link => document.getElementById(link.dataset.section))
    .filter(Boolean);

  function onScroll() {
    navbar.classList.toggle('scrolled', window.scrollY > 12);

    let current = spySections.length ? spySections[0].id : '';
    spySections.forEach(section => {
      if (window.scrollY >= section.offsetTop - window.innerHeight * 0.35) {
        current = section.id;
      }
    });
    navLinks.forEach(link => link.classList.toggle('active', link.dataset.section === current));
  }
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  /* ---------- Toast notifications ---------- */
  const toastContainer = document.getElementById('toastContainer');
  function showToast(message, type = 'success') {
    const icons = { success: '✅', error: '⚠️', info: 'ℹ️' };
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `<span>${icons[type] || icons.info}</span><span>${escapeHtml(message)}</span>`;
    toastContainer.appendChild(toast);
    requestAnimationFrame(() => toast.classList.add('show'));
    setTimeout(() => {
      toast.classList.remove('show');
      setTimeout(() => toast.remove(), 320);
    }, 3200);
  }

  /* ---------- Copy to clipboard (with fallback) ---------- */
  function copyText(text) {
    if (navigator.clipboard && window.isSecureContext) {
      return navigator.clipboard.writeText(text);
    }
    return new Promise((resolve, reject) => {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.style.position = 'fixed';
      textarea.style.opacity = '0';
      document.body.appendChild(textarea);
      textarea.focus();
      textarea.select();
      try {
        document.execCommand('copy');
        resolve();
      } catch (err) {
        reject(err);
      } finally {
        document.body.removeChild(textarea);
      }
    });
  }

  document.addEventListener('click', (e) => {
    const btn = e.target.closest('[data-copy]');
    if (!btn) return;
    copyText(btn.dataset.copy).then(() => {
      showToast('Command copied to clipboard!', 'success');
      btn.classList.add('copied');
      setTimeout(() => btn.classList.remove('copied'), 1500);
    }).catch(() => {
      showToast('Could not copy — please copy it manually.', 'error');
    });
  });

  /* ---------- Render: tools grid ---------- */
  const toolsGrid = document.getElementById('toolsGrid');
  function renderTools(filter = 'all') {
    const list = filter === 'all' ? tools : tools.filter(t => t.category === filter);
    toolsGrid.innerHTML = list.map(tool => `
      <article class="tool-card" data-category="${tool.category}">
        <div class="tool-card-top">
          <div class="tool-icon">${tool.icon}</div>
          <span class="tool-version">${escapeHtml(tool.version)}</span>
        </div>
        <h3 class="tool-name">${escapeHtml(tool.name)}</h3>
        <p class="tool-description">${escapeHtml(tool.description)}</p>
        <div class="tool-tags">${tool.tags.map(tag => `<span class="tag">${escapeHtml(tag)}</span>`).join('')}</div>
        <div class="tool-actions">
          <button class="btn-download" data-id="${tool.id}" aria-label="Download ${escapeHtml(tool.name)}">⬇ Download</button>
          <button class="btn-info" data-id="${tool.id}" aria-label="Info about ${escapeHtml(tool.name)}">ℹ Info</button>
        </div>
      </article>
    `).join('');
  }

  document.querySelectorAll('.filter-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      renderTools(btn.dataset.filter);
    });
  });

  /* ---------- Render: individual commands list ---------- */
  const commandsList = document.getElementById('commandsList');
  function renderCommands() {
    commandsList.innerHTML = tools.map(tool => `
      <div class="command-row">
        <span class="command-icon">${tool.icon}</span>
        <span class="command-name">${escapeHtml(tool.name)}</span>
        <code class="command-text">${escapeHtml(tool.command)}</code>
        <button class="command-copy" data-copy="${escapeHtml(tool.command)}" aria-label="Copy command for ${escapeHtml(tool.name)}">
          <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        </button>
      </div>
    `).join('');
  }

  /* ---------- Render: footer tools list ---------- */
  function renderFooterTools() {
    const footerList = document.getElementById('footerToolsList');
    footerList.innerHTML = tools.slice(0, 5).map(tool => `<li><a href="#tools">${escapeHtml(tool.name)}</a></li>`).join('');
  }

  /* ---------- Tool info modal ---------- */
  const modalOverlay = document.getElementById('modalOverlay');
  const modalContent = document.getElementById('modalContent');
  const modalClose = document.getElementById('modalClose');

  function openModal(tool) {
    modalContent.innerHTML = `
      <div class="modal-icon">${tool.icon}</div>
      <h3 id="modalTitle">${escapeHtml(tool.name)}</h3>
      <div class="modal-meta">
        <span class="tag">${escapeHtml(tool.category)}</span>
        <span class="tag">${escapeHtml(tool.version)}</span>
        ${tool.tags.map(t => `<span class="tag">${escapeHtml(t)}</span>`).join('')}
      </div>
      <p class="modal-desc">${escapeHtml(tool.description)}</p>
      <div class="modal-command">
        <code>${escapeHtml(tool.command)}</code>
        <button class="copy-btn" data-copy="${escapeHtml(tool.command)}" aria-label="Copy command">
          <svg class="icon-inline" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
        </button>
      </div>
      <div class="modal-actions">
        <button class="btn btn-primary" data-download="${tool.id}">⬇ Download Script</button>
      </div>
    `;
    modalOverlay.classList.add('active');
    modalClose.focus();
  }
  function closeModal() { modalOverlay.classList.remove('active'); }

  modalClose.addEventListener('click', closeModal);
  modalOverlay.addEventListener('click', (e) => { if (e.target === modalOverlay) closeModal(); });
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeModal(); });

  document.addEventListener('click', (e) => {
    const infoBtn = e.target.closest('.btn-info');
    if (!infoBtn) return;
    const tool = tools.find(t => t.id === infoBtn.dataset.id);
    if (tool) openModal(tool);
  });

  /* ---------- Download (fetch + blob, falls back to new tab) ---------- */
  async function downloadTool(tool) {
    const url = REPO_BASE + tool.file;
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error('bad response');
      const text = await res.text();
      const blob = new Blob([text], { type: 'text/plain' });
      const blobUrl = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = blobUrl;
      a.download = tool.file.split('/').pop();
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(blobUrl);
      showToast(`${tool.name} downloaded!`, 'success');
    } catch (err) {
      window.open(url, '_blank', 'noopener');
      showToast('Opened the script in a new tab — use Save As to download.', 'info');
    }
  }

  document.addEventListener('click', (e) => {
    const dlBtn = e.target.closest('.btn-download, [data-download]');
    if (!dlBtn) return;
    const id = dlBtn.dataset.id || dlBtn.dataset.download;
    const tool = tools.find(t => t.id === id);
    if (tool) downloadTool(tool);
  });

  /* ---------- Stats counter animation on scroll ---------- */
  const toolsStat = document.getElementById('statTools');
  if (toolsStat) toolsStat.dataset.target = tools.length;

  function animateCounter(el) {
    const target = Number(el.dataset.target) || 0;
    if (prefersReducedMotion()) { el.textContent = target.toLocaleString(); return; }
    const duration = 1400;
    const start = performance.now();
    function tick(now) {
      const progress = Math.min((now - start) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      el.textContent = Math.floor(eased * target).toLocaleString();
      if (progress < 1) requestAnimationFrame(tick);
      else el.textContent = target.toLocaleString();
    }
    requestAnimationFrame(tick);
  }

  const statObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        statObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.6 });
  document.querySelectorAll('.stat-number').forEach(el => statObserver.observe(el));

  /* ---------- Skills bar animation on scroll ---------- */
  const skillObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.width = entry.target.dataset.level + '%';
        skillObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.4 });
  document.querySelectorAll('.skill-fill').forEach(el => skillObserver.observe(el));

  /* ---------- Generic scroll reveal ---------- */
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('revealed');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15 });
  document.querySelectorAll('.reveal-item').forEach(el => revealObserver.observe(el));

  /* ---------- Hero terminal: typing loop (signature element) ---------- */
  function runTerminal() {
    const typedEl = document.getElementById('typedCommand');
    const outputEl = document.getElementById('terminalOutput');
    if (!typedEl || !outputEl) return;

    const command = 'irm https://tinyurl.com/shanetechub | iex';
    const outputLines = [
      { text: 'Connecting to ShaneCodes Tech Hub...', ok: true },
      { text: 'Loading tool menu...', ok: true },
      { text: `${tools.length} tools ready. Select one to run.`, ok: false }
    ];

    if (prefersReducedMotion()) {
      typedEl.textContent = command;
      outputEl.innerHTML = outputLines
        .map(l => `<div class="out-line ${l.ok ? 'ok' : ''}" style="opacity:1">${l.ok ? '✓ ' : ''}${escapeHtml(l.text)}</div>`)
        .join('');
      return;
    }

    let i = 0;
    typedEl.textContent = '';
    outputEl.innerHTML = '';

    function typeChar() {
      if (i < command.length) {
        typedEl.textContent += command[i];
        i++;
        setTimeout(typeChar, 34);
        return;
      }
      outputLines.forEach((line, idx) => {
        setTimeout(() => {
          const div = document.createElement('div');
          div.className = `out-line ${line.ok ? 'ok' : ''}`;
          div.textContent = (line.ok ? '✓ ' : '') + line.text;
          outputEl.appendChild(div);
        }, 260 * (idx + 1));
      });
      setTimeout(() => {
        typedEl.textContent = '';
        outputEl.innerHTML = '';
        i = 0;
        typeChar();
      }, 260 * (outputLines.length + 1) + 2600);
    }
    typeChar();
  }

  /* ---------- Contact form: validation + mailto ---------- */
  const contactForm = document.getElementById('contactForm');
  const cfName = document.getElementById('cf-name');
  const cfEmail = document.getElementById('cf-email');
  const cfSubject = document.getElementById('cf-subject');
  const cfMessage = document.getElementById('cf-message');
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  contactForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = cfName.value.trim();
    const email = cfEmail.value.trim();
    const subject = cfSubject.value;
    const message = cfMessage.value.trim();

    let hasError = false;
    [[cfName, name, true], [cfEmail, email, emailRegex.test(email)], [cfMessage, message, true]].forEach(([el, value, validExtra]) => {
      const row = el.closest('.form-row');
      const invalid = !value || !validExtra;
      row.classList.toggle('error', invalid);
      if (invalid) hasError = true;
    });

    if (hasError) {
      showToast('Please fill in all fields with a valid email.', 'error');
      return;
    }

    const mailto = `mailto:obinguarshane77@gmail.com?subject=${encodeURIComponent(subject + ' — ' + name)}&body=${encodeURIComponent(message + '\n\nFrom: ' + name + ' (' + email + ')')}`;
    window.location.href = mailto;
    showToast('Opening your email client...', 'success');
    contactForm.reset();
  });

  /* ---------- Newsletter (front-end only) ---------- */
  const newsletterForm = document.getElementById('newsletterForm');
  newsletterForm.addEventListener('submit', (e) => {
    e.preventDefault();
    showToast('Thanks for subscribing!', 'success');
    newsletterForm.reset();
  });

  /* ---------- Footer year ---------- */
  document.getElementById('year').textContent = new Date().getFullYear();

  /* ---------- Init ---------- */
  renderTools();
  renderCommands();
  renderFooterTools();
  runTerminal();
});