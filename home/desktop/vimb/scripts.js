(function() {
    'use strict';

    // Skip all user scripts on Cloudflare Turnstile / challenge pages to prevent anti-tampering flags
    if (
        window.location.hostname.includes("cloudflare.com") ||
        /just a moment/i.test(document.title) ||
        /security check/i.test(document.title) ||
        document.querySelector('#challenge-running, #challenge-form, iframe[src*="challenges.cloudflare.com"]')
    ) {
        return;
    }

    if (window !== window.top) return;

    // 1. Cosmetic ad filters and dynamic Reddit promoted-post cleanup
    const adSelectors = [
        '.adsbox', '.ad-banner', '.adsbygoogle', 'amp-ad',
        'div[id^="div-gpt-ad"]', '.sponsored-post', '#sidebar-ads'
    ];
    const isReddit = window.location.hostname === 'reddit.com' ||
        window.location.hostname.endsWith('.reddit.com');
    const redditAdSelectors = [
        'sh-promoted-post',
        'sh-post[data-promoted="true"]',
        'sh-post[promoted="true"]',
        'article[data-ad="true"]',
        '.promotedlink',
        '.thing[data-promoted="true"]',
        'div[data-adclicklocation="ad_post"]',
        'aside[aria-label="Advertisements"]',

    ];
    const selectors = isReddit ? adSelectors.concat(redditAdSelectors) : adSelectors;

    const addStyle = () => {
        const root = document.documentElement;
        if (!root) return;

        if (!document.getElementById('vimb-ad-filter')) {
            const style = document.createElement('style');
            style.id = 'vimb-ad-filter';
            style.textContent = selectors.join(', ') +
                ' { display: none !important; height: 0 !important; visibility: hidden !important; }';
            (document.head || root).appendChild(style);
        }

        if (!isReddit) return;

        const purgeAds = (node) => {
            if (node instanceof Element && node.matches(redditAdSelectors.join(', '))) {
                node.remove();
            }
            document.querySelectorAll(redditAdSelectors.join(', ')).forEach((ad) => ad.remove());
        };
        purgeAds(root);

        const observer = new MutationObserver((records) => {
            records.forEach((record) => record.addedNodes.forEach(purgeAds));
        });
        observer.observe(root, { childList: true, subtree: true });
    };

    if (document.documentElement) {
        addStyle();
    } else {
        document.addEventListener('DOMContentLoaded', addStyle, { once: true });
    }

    // 2. Anti-Adblock Defuser Scriptlet
    window.canRunAds = true;
    window.isAdBlockActive = false;
    window.adsAreWithUs = true;

    if (!window.ga) { window.ga = function() {}; }

    Object.defineProperty(window, 'AdBlock', { value: false, writable: false });
    Object.defineProperty(window, 'snack', { value: { isAdBlockerPresent: function() { return false; } }, writable: false });

    // 3. YouTube Player Ad Skipper
    if (window.location.hostname.includes("youtube.com")) {
        function checkAndSkipAds() {
            const skipButtons = [
                '.ytp-ad-skip-button-modern',
                '.ytp-skip-ad-button',
                '.ytp-ad-skip-button',
                'button[aria-label^="Skip ad"]'
            ];

            for (const selector of skipButtons) {
                const button = document.querySelector(selector);
                if (button && button.offsetParent !== null) {
                    button.click();
                }
            }

            const video = document.querySelector('video');
            if (video && document.querySelector('.ad-showing, .ad-interrupting')) {
                if (video.duration && video.currentTime < video.duration - 0.5) {
                    video.currentTime = video.duration - 0.1;
                }
            }
        }

        setInterval(checkAndSkipAds, 1000);
    }

    // 4. Vimb Clickjack & Popup Blocker
    window.open = function(url) {
        console.warn('Vimb blocked an attempted popup to:', url);
        return {
            focus: function() {},
            blur: function() {},
            close: function() {},
            closed: true
        };
    };

    window.addEventListener('click', function(event) {
        let node = event.target;
        while (node && node !== document.body) {
            if (node instanceof Element && node.tagName === 'A' &&
                node.getAttribute('target') === '_blank') {
                const style = window.getComputedStyle(node);
                const zIndex = Number.parseInt(style.zIndex, 10);
                const suspiciousLayer =
                    (style.position === 'fixed' || style.position === 'absolute') &&
                    (zIndex >= 100 || Number.parseFloat(style.opacity) === 0);

                let destination;
                try {
                    destination = new URL(node.getAttribute('href') || "", window.location.href);
                } catch (_) {
                    return;
                }

                if (suspiciousLayer && /^https?:$/.test(destination.protocol) &&
                    destination.origin !== window.location.origin) {
                    event.preventDefault();
                    event.stopImmediatePropagation();
                    node.remove();
                    console.warn('Vimb blocked a clickjack overlay:', node);
                    return;
                }
            }
            node = node.parentElement;
        }
    }, true);
})();
