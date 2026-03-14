# 🪻VDCABT🌷

## English 🇺🇲

A simple bash script that lets you create a virtual display (dummy) and stream its content to other devices in just a few minutes.

## Quick Start 🐓

**Step 1** :
Copy the script and necessary files to any folder and navigate into it <img src="https://media.tenor.com/yknttBHpnjsAAAAM/wahid-yimshee-kilometraat.gif" width="10" alt="hood irony">
```bash
git clone https://github.com/m0p7mka/VDCABT.git
cd VDCABT
```

**Step 2** :
Make the script executable and run it as superuser
```bash
chmod +x main.sh
sudo ./main.sh
```

**Step 3** :
Follow the script instructions and reboot the system after completion to apply changes
```bash
sudo reboot
```

**Step 4** :
Open the Sunshine interface via the tray icon or at https://localhost:47990 and complete the initial setup.
If you did not enable autostart during installation, run it via terminal
```bash
sunshine
```

**Step 5** :
Install the [Moonlight](https://moonlight-stream.org/) client on your device and connect to the computer via local IP

### Done 🎉

## Settings 🦧
For display settings (resolution, refresh rate, position relative to the main monitor) open System Settings and go to the Screen and Monitor section. Streaming settings are configured through the Sunshine interface.
**Recommended Sunshine configuration** :
```bash
# in Audio/Video
Maximum bitrate < 1500
Minimum FPS target = 60
# in Software Encoder
SW Presets = ultrafast
```

## Possible Problems 🪾
**When connecting to the stream you see your main monitor** : In the Sunshine configuration, in the Audio/Video section, change the value of config.output_name_unix.
**If you encounter other issues, please write about them and I will try to help**

---

## Русский 🇷🇺

Простой bash скрипт позволяющий за несколько минут создать виртуальный дисплей (заглушку) и транслировать его содержиме на другие устройства.

## Быстрый старт 🐓

**Шаг 1** :
Скопируйте скрипт и необходимые файлы в любую папку и зайдите в неё <img src="https://media.tenor.com/yknttBHpnjsAAAAM/wahid-yimshee-kilometraat.gif" width="10" alt="hood irony">
```bash
git clone https://github.com/m0p7mka/VDCABT.git
cd VDCABT
```

**Шаг 2** :
Сделайте скрипт исполняемым и запустите от имени суперпользователя
```bash
chmod +x main.sh
sudo ./main.sh
```

**Шаг 3** :
Следуйте инструкциям скрипта и перезапустите систему после завершения для применения изменений
```bash
sudo reboot
```

**Шаг 4** :
Зайдите в интерфейс Sunshine через иконку в трее или по адресу https://localhost:47990 и пройдите первичную настройку.
Если вы не включили автозагрузку при установке запустите через терминал
```bash
sunshine
```

**Шаг 5** :
Установите клиент [Moonlight](https://moonlight-stream.org/) на ваше устройство и подключитесь к компьютеру по локальному ip

### Готово 🎉

## Настройки 🦧
Для настроек самого дисплея (разрешение, частота обновление, расположение относительно основного монитора) откройте Параметры системы и перейдите в раздел Экран и монитор. Настройки трансляции осуществляются через интерфейс Sunshine.
**Рекомеднуемая конфигурация Sunshine** :
```bash
# в Audio/Video
Maximum bitrate < 1500
Minimum FPS target = 60
# в Software Encoder
SW Presets = ultrafast
```
## Возможные проблемы 🪾
**При подключении к тарнсляции вы видите свой основной монитор** : В конфигурации Sunshine в разделе Audio/Video измените значение config.output_name_unix.
**Если у вас возникнут другие проблемы напишите о них и я постараюсь помочь**
