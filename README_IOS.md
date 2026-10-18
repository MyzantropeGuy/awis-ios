# Инструкция по сборке и получению IPA проекта AWIS iOS

В данной папке развернут полноценный нативный проект для iOS (Swift / SwiftUI), портированный с Android-приложения `np.ua.reportapp` (Мобильный AWIS v1.71).

---

## Структура проекта

```
awis/
├── .github/workflows/build_ios.yml   # Автоматическая сборка IPA в облаке GitHub Actions
├── project.yml                       # Конфигурация генератора проекта XcodeGen
├── AwisApp/
│   ├── Info.plist                    # Разрешения камеры, Bluetooth, FaceID, URL-схемы
│   └── Sources/
│       ├── App/AwisApp.swift         # Точка входа SwiftUI
│       ├── Models/                   # Модели (Cargo, ExpressWaybill, Operation, HandbookItem)
│       ├── Services/
│       │   ├── Network/              # Клиент API URLSession и эндпоинты AWIS
│       │   ├── Auth/                 # Менеджер авторизации и PIN-кода
│       │   ├── Database/             # Локальная база данных (оффлайн-буфер)
│       │   └── Scanner/              # Нативный сканер штрихкодов (AVFoundation)
│       └── Views/                    # Экраны (Dashboard, Отделение, Оффлайн склад, Справочник)
```

---

## Как собрать готовый IPA прямо сейчас (через GitHub Actions)

1. **Создайте репозиторий на [GitHub](https://github.com):**
   * Создайте новый приватный или публичный репозиторий (например, `awis-ios`).

2. **Инициализируйте Git и отправьте код в репозиторий:**
   Выполните в терминале в этой папке:
   ```bash
   git init
   git add .
   git commit -m "Initial commit of ported AWIS iOS app"
   git branch -M main
   git remote add origin https://github.com/<ВАШ_АККАУНТ>/awis-ios.git
   git push -u origin main
   ```

3. **Получение готового IPA:**
   * Перейдите во вкладку **Actions** в вашем репозитории на GitHub.
   * Вы увидите запущенный пайплайн **Build iOS IPA** на виртуальной машине macOS-14.
   * Сборка займет около 2-3 минут.
   * По завершении откройте сборку и в разделе **Artifacts** скачайте готовый архив **`AwisApp-v1.71-iOS`** (внутри находится скомпилированный `AwisApp.ipa`).

---

## Как установить IPA на iPhone / iPad:

Поскольку IPA собран без коммерческой подписи App Store, его можно установить:
1. **TrollStore** (для поддерживаемых версий iOS — установка в 1 клик навсегда).
2. **AltStore** / **SideStore** (бесплатная подпись вашим личным Apple ID на 7 дней).
3. **Sideloadly** (утилита для Windows/Mac: перетаскиваете `.ipa`, вводите свой Apple ID и нажимаете Start).
4. **TestFlight / Сертификат разработчика** (если у вас есть аккаунт Apple Developer, можно подписать файл через `fastlane` или Xcode).
