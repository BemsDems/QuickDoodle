# QuickDoodle

## Архитектура

lib/
├── core/           # Базовая инфраструктура
│   ├── di/         # Dependency Injection (Riverpod)
│   ├── error/      # Обработка ошибок (AppFailure)
│   └── config/     # Цвета, стили, роутинг
├── data/           # Репозитории + Data Sources
│   └── repositories/
├── models/         # Модели (DoodleModel, UserModel)
├── presentation/   # UI + контроллеры (MVVM-подобная)
│   ├── auth/       # Экраны авторизации
│   ├── gallery/    # Галерея рисунков
│   └── doodle/     # Редактор рисунков
└── shared/         # Переиспользуемые компоненты

## Стек технологий

Стейтменеджер и DI
Riverpod 
fpdart

Backend
Firebase Auth 6.1.4 (Email/Password)
Firebase Realtime Database 12.1.2 (user/{uid}/doodles/)

UI/UX
flutter_drawing_board 1.0.1 (рисование)
flutter_svg 2.2.3 (иконки)
flutter_inset_shadow 2.0.3 (тени)
google_fonts 7.1.0 (Roboto)

Медиа и кэш
flutter_cache_manager 3.4.1 (LRU кэш изображений)
flutter_image_compress 2.4.0 (сжатие JPEG)
image_picker 1.2.1 + saver_gallery 4.1.0 (галерея/сохранение)

Сетевые проверки
internet_connection_checker_plus

