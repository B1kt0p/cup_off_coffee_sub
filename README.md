# cup_off_coffee

Пакеты OpenWrt для обновления списка `urltest_proxy_links` Podkop из
Base64-подписки Remnawave. Одинаковый список записывается во все UCI-секции
Podkop типа `section`. VLESS-ссылки с `YouTube` в имени ставятся в начало,
остальные сохраняют исходный порядок. Дубликаты удаляются.

## Состав

- `cup_off_coffee` - UCI-конфиг, updater и procd-планировщик.
- `luci-app-cup-off-coffee` - страница LuCI в `Сервисы -> Cup of Coffee`.
- OpenWrt 24.10 собирается в IPK, OpenWrt 25.12 - в APK.

Настройки хранятся в `/etc/config/cup_off_coffee`. После установки LuCI можно
указать URL подписки и точные времена обновления в формате `HH:MM` через пробел,
включить запуск при старте и выполнить ручное обновление. Число значений времени
задаёт количество обновлений за сутки, например `05:00`, `13:00`, `21:00` — три
обновления. По умолчанию обновление выполняется один раз в сутки в `05:00`.

## Требования

- Docker с доступом в интернет;
- около 5 ГБ свободного места на время сборки;
- `make` на машине, с которой запускается сборка.

По умолчанию используется SDK для `x86/64`. Основной пакет собирается для
архитектуры выбранного target, LuCI-пакет имеет архитектуру `all`. Сам контейнер
запускается как `linux/amd64`, в том числе через эмуляцию Docker Desktop на
Apple Silicon. Текущие версии по умолчанию: OpenWrt 24.10.7 и 25.12.4.

## Сборка

Собрать IPK для 24.10:

```sh
make build-24.10
```

Собрать APK для 25.12:

```sh
make build-25.12
```

Собрать оба варианта:

```sh
make all
```

Артефакты появятся в `dist/24.10.7/` и `dist/25.12.4/`.

На сервере сборки из этого проекта:

```sh
ssh buktop@192.168.2.234
cd /storage/project/update_subscrition
make build-24.10 TARGET=mediatek SUBTARGET=filogic
make build-25.12 TARGET=mediatek SUBTARGET=filogic
```

Версии и SDK target можно переопределить:

```sh
make build-24.10 OPENWRT_24_VERSION=24.10.7 TARGET=mediatek SUBTARGET=filogic
make build-25.12 OPENWRT_25_VERSION=25.12.4 TARGET=mediatek SUBTARGET=filogic
```

Прямая Docker-сборка без корневого Makefile:

```sh
docker build \
  --platform linux/amd64 \
  --build-arg OPENWRT_VERSION=24.10.7 \
  --build-arg TARGET=x86 \
  --build-arg SUBTARGET=64 \
  -t cup-off-coffee-builder:24.10.7 .

mkdir -p dist/24.10.7
docker run --rm \
  --platform linux/amd64 \
  -v "$PWD/dist/24.10.7:/output" \
  cup-off-coffee-builder:24.10.7
```

## Установка

OpenWrt 24.10:

```sh
opkg install cup_off_coffee_*.ipk luci-app-cup-off-coffee_*.ipk
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
```

OpenWrt 25.12:

```sh
apk add --allow-untrusted cup_off_coffee-*.apk luci-app-cup-off-coffee-*.apk
/etc/init.d/rpcd restart
/etc/init.d/uhttpd restart
```

Для запуска из консоли:

```sh
/usr/bin/cup_off_coffee-update
```

URL также можно передать только для одного запуска:

```sh
/usr/bin/cup_off_coffee-update 'https://example.com/subscription/token'
```
