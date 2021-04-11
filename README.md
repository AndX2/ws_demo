# ws_demo

Клиент демо проекта реального времени.

## Getting Started

## Commands

DI generation:

```sh
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

## API

### Auth

```sh
POST https://dartservice.ru/auth/signup
{
    "name": "userName"
}
```

```sh
POST https://dartservice.ru/auth/signin
{
    "name": "userName"
}
```

```sh
POST https://dartservice.ru/auth/refresh
headers:
{
    "Authorization": "<refreshToken>",

}
```

### Data

Заголовки каналов (название и последенее сообщение)

```sh
GET https://dartservice.ru/messenger/channel
headers:
{
    "Authorization": "Bearer <access>"
}
```

Список сообщений канала

```sh
GET https://dartservice.ru/messenger/channel/<channel name>
headers:
{
    "Authorization": "Bearer <access>"
}
```

Стрим сообщений

```sh
wss://dartservice.ru/messenger/ws

```
