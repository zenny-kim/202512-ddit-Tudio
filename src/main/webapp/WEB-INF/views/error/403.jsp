<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>403 - 권한 없음</title>
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
            border-top: 5px solid #6c757d; /* 403은 회색/검정 계열 */
        }

        .error-code {
            font-size: 6rem;
            font-weight: 800;
            color: #495057; /* 묵직한 다크 그레이 */
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
        
        .btn-login { background-color: white; color: #343a40; }
        .btn-login:hover { background-color: #f1f1f1; }
    </style>
</head>
<body>

    <div class="error-content">
        <h1 class="error-code">403</h1>
        <div class="error-title">접근 권한이 없습니다 ✋</div>
        
        <p class="error-message">
            해당 페이지에 접근할 수 있는 권한이 부족합니다.<br>
            관리자 계정으로 로그인되어 있는지 확인해 주세요.<br>
            (일반 회원은 접근할 수 없는 메뉴입니다.)
        </p>

        <div class="btn-group-custom">
            <a href="/tudio/loginForm" class="btn-custom btn-login">로그인 하러가기</a>
            <a href="/tudio/dashboard" class="btn-custom btn-home">메인으로</a>
        </div>
    </div>

</body>
</html>