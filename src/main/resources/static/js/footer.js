document.addEventListener("DOMContentLoaded", function() {
    // 현재 연도 자동 업데이트 (Copyright 2025 -> 2026 ...)
    const yearSpan = document.getElementById("currentYear");
    if (yearSpan) {
        yearSpan.textContent = new Date().getFullYear();
    }
});