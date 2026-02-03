<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 페이지 없음</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            height: 100vh;
            margin: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: #f8f8f0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #343a40;
        }

        .error-content {
            text-align: center;
            padding: 3rem;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 1rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            max-width: 600px;
            width: 90%;
        }

        .error-code {
            font-size: 6rem;
            font-weight: 800;
            color: #fd7e14; /* 404는 주황색 계열이 국룰! */
            margin-bottom: 0;
            line-height: 1;
        }

        .error-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-top: 10px;
            margin-bottom: 20px;
        }

        .error-message {
            color: #6c757d;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .btn-group-custom {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .btn-custom {
            padding: 10px 25px;
            border-radius: 50px;
            text-decoration: none;
            transition: 0.3s;
            border: 1px solid #343a40;
        }
        
        .btn-home { background-color: #343a40; color: white; }
        .btn-home:hover { background-color: #000; color: white; }
        
        .btn-back { background-color: white; color: #343a40; }
        .btn-back:hover { background-color: #f1f1f1; }
    </style>
</head>
<body>

    <div class="error-content">
        <h1 class="error-code">404</h1>
        <div class="error-title">페이지를 찾을 수 없습니다 🧐</div>
        
        <p class="error-message">
            요청하신 페이지가 제거되었거나, 이름이 변경되었거나,<br>
            일시적으로 사용할 수 없는 상태입니다.<br>
            입력하신 주소(URL)가 정확한지 다시 한번 확인해 주세요.
        </p>

        <div class="btn-group-custom">
            <a href="javascript:history.back()" class="btn-custom btn-back">이전 페이지</a>
            <a href="/tudio/dashboard" class="btn-custom btn-home">메인으로</a>
        </div>
    </div>

</body>
</html>