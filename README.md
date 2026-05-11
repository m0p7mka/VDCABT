# 🪻VDCABT🌷

## English 🇺🇲

A simple bash script that allows you to create a virtual display (dummy) in a few minutes and stream its contents to other devices.

## What this script does ❔
- Adds an EDID file (monitor characteristics dump) to initramfs.
- Adds a file to GRUB that forces the video driver to activate a video output and generate an image for it with the specified parameters.
- Installs a utility for streaming this image to other devices.

## Quick Start 🚀

**Step 1** :
Copy the script and necessary files to any folder and navigate into it
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
**Why do I see my main monitor when connecting to the stream?** : In the Sunshine configuration, in the Audio/Video section, change the value of config.output_name_unix.  
**How do I remove all of this now?** : Run the remover script and follow the instructions.
```bash
chmod +x remover.sh
sudo ./remover.sh
```
**At this stage the script fully performs its functions on my system (KDE Manjaro Linux) and I have nothing else to add.**  
**If you have any other problems, please write about them and I will try to help.**

---

## Русский 🇷🇺

Простой bash скрипт позволяющий за несколько минут создать виртуальный дисплей (заглушку) и транслировать его содержиме на другие устройства.

## Что делает этот скрипт ❔
- Добавляет EDID файл (дамп характеристик монитора) в intiramfs.
- Добавляет в GRUB файл указание драйверу видеокарты принудительно активировать видеовыход и генерировать для него изображение по заданным характеристикам.
- Устанавливает утилиту для трансляции этого изображения на другие устройства.

## Быстрый старт 🚀

**Шаг 1** :
Скопируйте скрипт и необходимые файлы в любую папку и зайдите в неё 
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
**Почему я вижу свой основной монитор при подклчении к трансляции?** : В конфигурации Sunshine в разделе Audio/Video измените значение config.output_name_unix.  
**Как мне теперь все это удалить?** : Запустите скрипт remover и следуйте инструкциям.
```bash
chmod +x remover.sh
sudo ./remover.sh
```
**На данном этапе скрипт полностью выполняет свои функции на моей системе (KDE Manjaro Linux) и мне нечего к нему добавить.**   
**Если у вас возникнут другие проблемы, напишите о них и я постараюсь помочь.**
