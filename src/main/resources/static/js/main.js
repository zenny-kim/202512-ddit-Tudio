document.addEventListener("DOMContentLoaded", () => {
    
    // 1. Hero Logo Animation
    const progressCircle = document.getElementById('progress-circle');
    if (progressCircle) {
        setTimeout(() => {
            progressCircle.style.strokeDashoffset = '0';
        }, 500);
    }

    // 2. Scroll Reveal Animation (Intersection Observer)
    const observerOptions = { threshold: 0.15, rootMargin: "0px 0px -50px 0px" };
    
    const revealObserver = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('reveal-active');
                obs.unobserve(entry.target);
                
                // 3. Count Up Animation Trigger
                // (숫자 요소가 화면에 나타나면 카운팅 시작)
                const counters = entry.target.querySelectorAll('.count-up');
                counters.forEach(counter => {
                    const target = +counter.getAttribute('data-target');
                    const duration = 2000; // 2초
                    const increment = target / (duration / 16); 
                    
                    let current = 0;
                    const updateCount = () => {
                        current += increment;
                        if (current < target) {
                            counter.innerText = Math.ceil(current);
                            requestAnimationFrame(updateCount);
                        } else {
                            counter.innerText = target;
                        }
                    };
                    updateCount();
                });
            }
        });
    }, observerOptions);

    document.querySelectorAll('.js-scroll').forEach(el => revealObserver.observe(el));


    // 4. Sticky Section Logic (Scroll-driven Image Switch)
    const stepBlocks = document.querySelectorAll('.step-block');
    const uiScreens = document.querySelectorAll('.ui-screen');
    
    // 스크롤 이벤트 핸들러 (IntersectionObserver 대신 더 정밀한 scroll 이벤트 사용)
    window.addEventListener('scroll', () => {
        let currentIdx = 0;
        
        stepBlocks.forEach((block, index) => {
            const rect = block.getBoundingClientRect();
            // 블록이 화면 중앙(뷰포트의 50% 지점)에 오면 활성화
            if (rect.top < window.innerHeight * 0.5 && rect.bottom > window.innerHeight * 0.5) {
                currentIdx = index;
            }
        });

        // 텍스트 활성화
        stepBlocks.forEach(b => b.classList.remove('active'));
        stepBlocks[currentIdx].classList.add('active');

        // 이미지 활성화
        uiScreens.forEach(s => {
            s.classList.remove('active');
            s.classList.add('inactive'); // 살짝 축소 효과
        });
        
        const activeScreen = document.getElementById(`screen-${currentIdx}`);
        if(activeScreen) {
            activeScreen.classList.remove('inactive');
            activeScreen.classList.add('active');
        }
    });
});