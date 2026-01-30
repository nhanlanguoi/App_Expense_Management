lib/
├── assets/                 # (Tùy chọn) Chứa ảnh, fonts, json nếu khai báo trong pubspec.yaml
├── components/             # Các widget nhỏ dùng chung (Button, Input, Sidebar...) - Bạn đang làm đúng!
│   ├── buttons/
│   ├── inputs/
│   └── dialogs/
├── configs/                # Cấu hình app (Theme, Route, Env)
│   ├── app_routes.dart     # Quản lý đường dẫn điều hướng
│   └── theme.dart          # Màu sắc, font chữ toàn app
├── core/                   # Các hàm xử lý cốt lõi, constants
│   ├── constants/          # Lưu các biến cố định (API URL, Key...)
│   └── utils/              # Các hàm tiện ích (format ngày tháng, validate email...)
├── models/                 # Khuôn mẫu dữ liệu (Data Class)
│   ├── user_model.dart
│   └── product_model.dart
├── screens/                # Các màn hình chính (Mỗi màn hình 1 thư mục)
│   ├── auth/               # Màn hình đăng nhập/đăng ký
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   └── profile/
├── services/               # Nơi gọi API hoặc Database (Logic xử lý dữ liệu)
│   ├── api_service.dart
│   └── local_storage.dart
├── providers/ (hoặc blocs) # Quản lý trạng thái (State Management)
└── main.dart               # File chạy chính
