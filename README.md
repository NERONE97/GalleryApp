
# Gallary APP

iOS-приложение для просмотра изображений, загружаемых с Unsplash API, с возможностью добавления в избранное и локального хранения.

## Автор: Роман Мухин
### Контактная информация:
- [Telegram (предпочтительно)](https://www.t.me/NERONE97)
- [Github](https://www.github.com/octokatherine)
- [LinkedIn](https://www.linkedin.com/in/mukhinroman/)

## Функционал:
Приложение состоит из трёх экранов:
 1. Gallery Screen
 - Сетка изображений (UICollectionView)
 - Загрузка данных с Unsplash API
 - Пагинация (infinite scroll)
 - Индикатор избранного
2. Image Detail Screen
- Просмотр изображения в полном размере
- Отображение информации (title / description)
- Добавление/удаление из избранного ❤️
- Swipe-навигация между изображениями
3. Favourites Screen
- Сетка избранных изоьражений
- Возможность удаления из избранного (Долгое нажатие на изображение)
- Локальное хранение (CoreData)


## Используемые технологии:

**Base:** Swift

**UI:** UIKit, UICollectionView, UIImageView, Auto Layout

**Storage:** CoreData, NSCache

**Server:** Unsplash API

**Networking:** URLSession, async/await

**Architecture:** MVVM, Coordinator, SOLID

**Testing: XCTest**

**Tools:** Git (Gitflow), SwiftLint

## Архитектура

MVVM + layered architecture (с элементами Clean Architecture).

```bash
Presentation (View + ViewModel)
        ↓
Domain (Models / Use-cases abstraction)
        ↓
Data Layer (API / Persistence / Services)
```
# Как запустить:
1. Скопировать репозиторий
```bash
git clone https://github.com/NERONE97/GalleryApp
cd GalleryApp
```
2. Открыть:
```bash
GalleryApp.xcodeproj
```
3. Получить API ключ:
```bash
https://unsplash.com/developers
```
4. Вставить API-ключ:
```bash
в файл: Gallery App MVVM/Business Layer/Networking/APIService.swift
в переменную: private let accessKey = "ВАШ КЛЮЧ" (Не забудь про " ")
```

# Скриншоты
<img width="300" height="655" alt="Simulator Screenshot - iPhone 17 - 2026-03-18 at 17 06 28" src="https://github.com/user-attachments/assets/68954295-9712-41a5-aa1e-53fe8eccdbbb" />

<img width="300" height="655" alt="Simulator Screenshot - iPhone 17 - 2026-03-18 at 17 06 36" src="https://github.com/user-attachments/assets/2bc9d7cd-5216-4a27-a751-9d3ef434b478" />

<img width="300" height="655" alt="Simulator Screenshot - iPhone 17 - 2026-03-18 at 17 06 22" src="https://github.com/user-attachments/assets/fb36184f-d1ed-4460-82af-320af1568372" />




