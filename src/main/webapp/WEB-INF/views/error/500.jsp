<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 서버 오류</title>
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
            border-top: 5px solid #dc3545; /* 500은 빨간색! */
        }

        .error-code {
            font-size: 6rem;
            font-weight: 800;
            color: #dc3545; /* 빨간색 */
            margin-bottom: 0;
            line-height: 1;
        }

        .error-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-top: 10px;
            margin-bottom: 20px;
            color: #343a40;
        }

        .error-message {
            color: #6c757d;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .btn-home {
            padding: 10px 30px;
            border-radius: 50px;
            text-decoration: none;
            background-color: #343a40; 
            color: white;
            transition: 0.3s;
        }
        .btn-home:hover { background-color: #000; color: white; }
    </style>
</head>
<body>

    <div class="error-content">
        <h1 class="error-code">500</h1>
        <div class="error-title">시스템 오류가 발생했습니다 🚨</div>
        
        <p class="error-message">
            서버 이용에 불편을 드려 죄송합니다.<br>
            현재 오류 내용이 관리자에게 전송되었습니다.<br>
            잠시 후 다시 시도해 주세요.
        </p>

        <a href="/tudio/dashboard" class="btn-home">메인으로 돌아가기</a>
    </div>

</body>
</html>