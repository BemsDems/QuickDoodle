# QuickDoodle

## Архитектура

**Слоистая**

```text
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

**Стейтменеджер и DI:**
- Riverpod
- fpdart

**Backend:**
- Firebase Auth (Email/Password)
- Firebase Realtime Database (`user/{uid}/doodles/`)

**UI/UX:**
- flutter_drawing_board (рисование)
- flutter_svg (иконки)
- flutter_inset_shadow (тени)
- google_fonts (Roboto)

**Медиа и кэш:**
- flutter_cache_manager (Кэш изображений)
- flutter_image_compress (сжатие JPEG)
- image_picker + saver_gallery (галерея и сохранение)

**Сетевые проверки:**
- internet_connection_checker_plus

