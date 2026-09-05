# Backstage development portal

Тестовое Backstage-приложение с локальными PostgreSQL и GitLab. Исходники
frontend и backend находятся в корне репозитория в `packages/`, а инфраструктура
для разработки описана в `compose.yaml`.

## Что входит

- Backstage frontend и backend с гостевой авторизацией для локальной разработки;
- PostgreSQL как хранилище Backstage и внешний PostgreSQL для GitLab;
- GitLab Community Edition на `http://localhost:8080`;
- GitLab catalog provider, который раз в 30 минут ищет `catalog-info.yaml`;
- software template **Node.js service in GitLab**, создающий приватный проект и
  сразу регистрирующий его в каталоге.

## Требования

- Node.js 22 или 24;
- Docker с Compose v2;
- не менее 6 GB свободной оперативной памяти для GitLab.

## Первый запуск

1. Создайте локальный файл окружения:

   ```bash
   cp .env.example .env
   ```

2. Запустите инфраструктуру. Первый старт GitLab обычно занимает несколько минут:

   ```bash
   docker compose up -d
   docker compose ps
   ```

3. Создайте idempotent personal access token для Backstage. Скрипт дождётся
   статуса `healthy` и установит GitLab root-пользователю токен со scope `api`:

   ```bash
   ./scripts/bootstrap-gitlab.sh
   ```

4. Экспортируйте переменные, установите зависимости и запустите Backstage:

   ```bash
   set -a
   source .env
   set +a
   yarn install
   yarn start
   ```

5. Откройте Backstage по адресу `http://localhost:3000` и войдите как guest.
   GitLab доступен по `http://localhost:8080` (логин `root`, пароль из
   `GITLAB_ROOT_PASSWORD`).

## Создание проекта кнопкой

1. В Backstage откройте **Create**.
2. Выберите **Node.js service in GitLab** и нажмите **Choose**.
3. Заполните название и описание.
4. В Repository Location укажите owner `root` и имя нового репозитория.
5. Нажмите **Create**. Backstage отрендерит заготовку, создаст приватный GitLab
   проект и зарегистрирует его `catalog-info.yaml` в каталоге.

Публикация выполняется серверным `GITLAB_TOKEN`; пользователю не нужно передавать
собственный токен в форме.

## Полезные команды

```bash
# Логи GitLab
docker compose logs -f gitlab

# Проверки приложения
yarn tsc
yarn lint:all
yarn test

# Остановить сервисы
docker compose down

# Полностью удалить dev-данные
docker compose down -v
```

Данные PostgreSQL и GitLab сохраняются в именованных Docker volumes. SQL-файл
инициализации выполняется только при первом создании volume `postgres-data`.
