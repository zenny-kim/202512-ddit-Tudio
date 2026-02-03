<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found - 공사 중</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        body {
            height: 100vh;
            margin: 0;
            overflow: hidden; /* 배경 애니메이션이 밖으로 나가지 않도록 */
            display: flex;
            flex-direction: column; /* 세로 정렬 */
            align-items: center; /* 가로 중앙 정렬 */
            justify-content: center; /* 세로 중앙 정렬 */
            position: relative;
            color: #343a40; /* 텍스트 기본 색상 */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f8f0; /* 배경의 상단 베이지색과 어울리는 기본 배경색 */
        }

        /* 배경 이미지 컨테이너 */
        .background-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('/resources/error/error_back.png'); /* 여기에 제공해주신 일러스트 이미지 URL을 넣어주세요 */
            background-size: cover;
            background-position: center bottom; /* 바닥에 맞춰서 배치 */
            background-repeat: no-repeat;
            z-index: -2; /* 가장 뒤에 배치 */
            filter: brightness(0.9); /* 약간 어둡게 */
        }

        /* 트럭 애니메이션을 위한 레이어 */
        .truck-animation-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0; /* 배경과 콘텐츠 사이에 배치 */
            overflow: hidden; /* 트럭이 밖으로 나가지 않도록 */
        }

        .animated-truck {
            position: absolute;
            bottom: 20%; /* 트럭 위치 (조정 필요) */
            left: -20%; /* 화면 밖에서 시작 */
            width: 150px; /* 트럭 크기 (조정 필요) */
            height: auto;
            animation: moveTruck 15s linear infinite; /* 15초 동안 선형적으로 무한 반복 */
        }

        @keyframes moveTruck {
            0% { transform: translateX(0); }
            100% { transform: translateX(calc(100vw + 25%)); } /* 화면 너비 + 트럭 너비만큼 이동 */
        }

        .error-content {
            z-index: 1; /* 콘텐츠가 배경 위로 오도록 */
            text-align: center;
            padding: 2rem;
            background-color: rgba(255, 255, 255, 0.8); /* 콘텐츠 영역을 살짝 불투명하게 */
            border-radius: 1rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            max-width: 650px;
        }

        .error-code {
            font-size: 7rem;
            font-weight: 800;
            color: #217ddb; /* 빨간색 500 */
            margin-bottom: 0.5rem;
            line-height: 1;
        }

        .error-message {
/*             font-size: 1.5rem; */
            color: #495057;
            margin-bottom: 0;
            line-height: 1.4;
        }
    </style>
</head>
<body>

<!--     <div class="truck-animation-layer"> -->
<!--         <img src="/resources/error/Gemini_Generated_Image_4uvjlz4uvjlz4uvj.png" alt="Animated Truck" class="animated-truck"> -->
<!--     </div> -->
    <div class="background-container"></div>


    <div class="error-content">
        <h1 class="error-code">500</h1>
        <h4>예상치 못한 서버 오류가 발생했습니다 🚨</h4>
        <p class="error-message">
            ${errMsg }
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

</body>
</html>