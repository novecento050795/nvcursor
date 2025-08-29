# nvcursor

_[English](README.md) | Русский_

Автоматический обновлятель Cursor IDE для Linux

## Описание

`nvcursor` — это bash-скрипт для автоматической установки и обновления Cursor IDE на Linux-системах. Скрипт проверяет текущую версию, сравнивает её с последней доступной и обновляет при необходимости.

## Возможности

- ✅ Автоматическая проверка и загрузка последней версии Cursor
- ✅ Сравнение версий для избежания ненужных обновлений
- ✅ Принудительное обновление при необходимости
- ✅ Автоматическое создание desktop-файла и иконки
- ✅ Следование XDG Base Directory Specification
- ✅ Цветной вывод для лучшего UX
- ✅ Безопасная установка без запуска от root

## Требования

- Linux-система с поддержкой AppImage
- `curl` для API-запросов
- `jq` для парсинга JSON
- `wget` для загрузки файлов
- `sudo` права для установки

### Установка зависимостей

**Ubuntu/Debian:**

```bash
sudo apt update
sudo apt install curl jq wget
```

**CentOS/RHEL/Fedora:**

```bash
# Fedora
sudo dnf install curl jq wget

# CentOS/RHEL
sudo yum install curl jq wget
```

**Arch Linux:**

```bash
sudo pacman -S curl jq wget
```

## Установка nvcursor

### Способ 1: Быстрая установка

```bash
# Скачать и установить в один шаг
curl -fsSL https://raw.githubusercontent.com/novecento/cursor-updater/main/nvcursor.sh -o nvcursor.sh
chmod +x nvcursor.sh
sudo mv nvcursor.sh /usr/local/bin/nvcursor
```

### Способ 2: Клонирование репозитория

```bash
git clone https://github.com/novecento/cursor-updater.git
cd cursor-updater
chmod +x nvcursor.sh
sudo cp nvcursor.sh /usr/local/bin/nvcursor
```

### Способ 3: Ручная установка

```bash
# Скачать скрипт
wget https://raw.githubusercontent.com/novecento/cursor-updater/main/nvcursor.sh

# Сделать исполнимым
chmod +x nvcursor.sh

# Переместить в системную директорию (опционально)
sudo mv nvcursor.sh /usr/local/bin/nvcursor
```

## Использование

### Основные команды

```bash
# Установить Cursor (если не установлен) или обновить до последней версии
nvcursor

# Показать текущую версию
nvcursor --version
nvcursor -v

# Принудительное обновление (даже если версия актуальная)
nvcursor --force
nvcursor -f

# Показать справку
nvcursor --help
nvcursor -h
```

### Примеры использования

```bash
# Первоначальная установка Cursor
$ nvcursor
This script requires sudo privileges to install Cursor.
[sudo] password for user:
Checking for Cursor updates...
No version file found. Installing Cursor version: 0.42.0
Downloading Cursor...
...
Cursor installed successfully! Version: 0.42.0

# Проверка обновлений (когда версия актуальная)
$ nvcursor
Current version: 0.42.0
Latest version: 0.42.0
Cursor is already up to date (version 0.42.0)

# Проверка текущей версии
$ nvcursor --version
Cursor version: 0.42.0
```

## Принцип работы

1. **Проверка версий**: Скрипт запрашивает последнюю версию через API Cursor
2. **Сравнение**: Сравнивает с локально сохранённой версией
3. **Загрузка**: При необходимости загружает новую версию
4. **Установка**: Устанавливает Cursor в `/opt/cursor/`
5. **Интеграция**: Создаёт desktop-файл для интеграции с системой
6. **Сохранение**: Сохраняет информацию о версии для будущих проверок

## Расположение файлов

- **Исполнимый файл**: `/opt/cursor/cursor.AppImage`
- **Иконка**: `/opt/cursor/logo.svg`
- **Desktop-файл**: `/usr/share/applications/cursor.desktop`
- **Информация о версии**: `$XDG_CACHE_HOME/cursor-updater/version` (обычно `~/.cache/cursor-updater/version`)

## Безопасность

- ❌ Скрипт **НЕ** запускается от root
- ✅ Запрашивает sudo только для операций установки
- ✅ Автоматически поддерживает sudo-сессию во время работы
- ✅ Проверяет права доступа перед выполнением

## Автор

**Tamirlan Akanov**

- Email: akanovtt@gmail.com
- GitHub: [@novecento050795](https://github.com/novecento050795)

## Лицензия

Этот проект распространяется под лицензией MIT. См. файл [LICENSE](LICENSE) для подробностей.

## Поддержка

Если у вас возникли проблемы или есть предложения:

1. Создайте issue в [GitHub репозитории](https://github.com/novecento/cursor-updater)
2. Проверьте, что все зависимости установлены
3. Убедитесь, что у вас есть права sudo
4. Запустите скрипт с флагом `--help` для получения подробной информации
