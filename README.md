# App Expense Management

> **Quản lý chi tiêu cá nhân - Hệ thống gồm ứng dụng Flutter (frontend) và backend Node.js kết nối Firebase**

---

## Mục lục
- [Giới thiệu](#giới-thiệu)
- [Tính năng chính](#tính-năng-chính)
- [Cấu trúc dự án](#cấu-trúc-dự-án)
- [Hướng dẫn cài đặt & chạy hệ thống](#hướng-dẫn-cài-đặt--chạy-hệ-thống)
  - [1. Backend](#1-backend)
  - [2. Frontend (Flutter App)](#2-frontend-flutter-app)
- [Thông tin nhóm](#thông-tin-nhóm)

---

## Giới thiệu
Dự án **App Expense Management** là hệ thống quản lý chi tiêu cá nhân, hỗ trợ đăng nhập đa nền tảng (email, Google, Facebook), xác thực OTP qua email, lưu trữ dữ liệu trên Firebase, giao diện hiện đại với Flutter.

## Tính năng chính
- Đăng ký/đăng nhập bằng email, Google, Facebook
- Xác thực OTP qua email khi đăng ký hoặc quên mật khẩu
- Quản lý thu chi, phân loại giao dịch, thống kê trực quan
- Lưu trữ dữ liệu người dùng trên Firebase
- Giao diện thân thiện, hỗ trợ đa nền tảng (Android, Web, Windows)

## Cấu trúc dự án

```
├── backend-App_Expense_Management/   # Backend Node.js (Express, Firebase)
├── lib/                             # Mã nguồn Flutter app
├── android/, web/, windows/         # Thư mục build đa nền tảng Flutter
├── pubspec.yaml                     # Khai báo dependencies Flutter
├── README.md                        # Tài liệu này
└── ...
```

## Hướng dẫn cài đặt & chạy hệ thống

### 1. Backend

#### a. Yêu cầu
- Node.js >= 18
- Firebase project (đã tạo trên https://console.firebase.google.com)

#### b. Cài đặt & chạy
```bash
cd backend-App_Expense_Management
cp .env.example .env   # Tạo file cấu hình môi trường, điền thông tin Firebase
npm install            # Cài dependencies
npm run dev            # Chạy server ở chế độ phát triển (hot reload)
# hoặc
npm start              # Chạy server ở chế độ production
```

#### c. Một số API chính
- `POST /auth/register` Đăng ký tài khoản
- `POST /auth/login` Đăng nhập
- `POST /auth/email-otp/request` Gửi OTP qua email
- `POST /auth/email-otp/verify-register` Xác thực OTP khi đăng ký
- `POST /auth/email-otp/verify-reset` Xác thực OTP khi quên mật khẩu
- `POST /auth/firebase`, `/auth/google`, `/auth/facebook` Đăng nhập OAuth
- `GET /auth/me` Lấy thông tin người dùng
- `POST /auth/logout` Đăng xuất

#### d. Thiết lập Firebase
1. Tạo project trên Firebase Console
2. Bật các provider: Email/Password, Google, Facebook trong Authentication > Sign-in method
3. Tải file service account JSON về, đặt vào backend (ví dụ: `app-expense-management-firebase-adminsdk-xxx.json`)
4. Điền các biến môi trường vào file `.env`

### 2. Frontend (Flutter App)

#### a. Yêu cầu
- Flutter SDK >= 3.10.4
- Android Studio (nếu build Android), Chrome (nếu chạy web), hoặc Windows (nếu build desktop)

#### b. Cài đặt & chạy
```bash
flutter pub get           # Cài dependencies
flutter run -d chrome     # Chạy trên web
flutter run -d android    # Chạy trên thiết bị Android
flutter run -d windows    # Chạy trên Windows
```

#### c. Thiết lập Firebase cho Flutter
1. Tạo app trên Firebase Console (Android/Web/Windows)
2. Tải file `google-services.json` (Android) vào `android/app/`
3. Cấu hình Firebase cho web nếu chạy web (xem tài liệu Firebase)

---

## Thông tin nhóm

| STT | Họ và tên           | MSSV      | Email                              |
|-----|---------------------|-----------|------------------------------------|
| 1   | Cao Đức Trung       | 23010018  | 23010018@st.phenikaa-uni.edu.vn    |
| 2   | Nguyễn Thành Nhân   | 23010011  | 23010011@st.phenikaa-uni.edu.vn    |

---

## Liên hệ & đóng góp
- Nếu có thắc mắc hoặc muốn đóng góp, vui lòng liên hệ thành viên nhóm hoặc tạo issue trên repository.


