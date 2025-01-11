# ESP32 Seven Segment Single Print Digital Clock

1. Modular and Monolithic LED Display Designs
2. Ws2818b LED Strip 100LED/m
3. Wemos D1 Mini (ESPHome/Home Assistant)

_Dec 12, 2024 Update - Added Four Digit Lid design as a .scad and .stl which makes a nice clean back plate on the clock hiding the wires and adding mounting holes and optional LED / button holes for future development. This is probably the best place to start unless you want seconds digits, I will work on the back case for that next_

_Dec 19, 2024 Update - Created Part 1 & 2 of a 4-part tutorial series, posted the video links below._

_Dec 24, 2024 Update - Part 3 now available! Includes complete assembly guide and bonus 6-digit clock build._

_Dec 26, 2024 Update - Series complete! All four parts now available._

## Video Tutorials

### Part 1: 3D Printing & Design

Watch either version to learn how to customize, slice, and print your clock:

- [Full Tutorial (10min)](https://youtu.be/DS_muPDX8p8)
- [Quick Guide (2.5min)](https://youtu.be/-_kpwUeTEb4)

### Part 2: Parts, Tools, and Wiring

Learn about the electronics and wiring setup:

- [Full Tutorial (15min)](https://youtu.be/uiOuWeXdryE)
- Quick Guide (Coming Soon)

### Part 3: Assembly & Soldering

Complete assembly guide plus bonus 6-digit clock build:

- [Full Tutorial (15min)](https://youtu.be/76l32a6Kb90)
- Quick Guide (Coming Soon)

### Part 4: Firmware & ESPHome Setup

Complete firmware setup and Home Assistant integration:

- [Full Tutorial (15min)](Your_New_Video_Link)
- Quick Guide (Coming Soon)

### Complete Series Available!

Watch the entire build process from start to finish in our [Complete Tutorial Series](https://youtube.com/playlist?list=PLeBpq2qBuOI1kfnOv1Nu6G2_ES9P5Xj6k)

# ESP Digital Clock Collection

A collection of modern, customizable LED digital clock designs that integrate with Home Assistant through ESPHome. Choose between modular single digits that can be arranged however you like, or complete 4-digit and 6-digit monolithic designs.

Full documentation and code: https://github.com/kylemath/digitalclock

All print files have an accompanying openSCAD .scad file which can be edited, rendered, and saved as a new .stl as you please. Super hint: Ask chatgpt for help with this.
https://openscad.org/

I got inspired after printing and building this great clock: https://www.printables.com/model/478390-ws2812b-digital-pixel-clock-esp8266-esphome-based. I wanted to make something more compact that also used strips of LEDs with minimal soldering so used Cursor and OpenSCAD to create my own design. I tried to make it as modular as possible so that it would be easy to print and assemble.

I don't think that I saw the following design before this development, but the similarities are enough to add it as a remix. I like the great design: https://www.thingiverse.com/thing:5170654

## Design Options

1. **Modular Single Digit Design**

   - Stack and arrange digits as needed
   - Easy maintenance and replacement
   - Perfect for custom configurations
   - Individual digit control

2. **6-Digit Monolithic Clock (HH:MM:SS)**

   - All-in-one design
   - Perfect for wall mounting
   - Complete time display with seconds

3. **4-Digit Monolithic Clock (HH:MM)**
   - Compact design
   - Perfect for desks
   - Clean hour and minute display

## Required Materials

### Electronics

- ESP8266 NodeMCU or ESP32 Wemos D1 Mini
- WS2812B LED strips
- 5V Power Supply (2A minimum)
- Micro USB cable
- Dupont wires
- 220 Ohm Resistor
- Optional: Power jack connector

### Printing Details

- Main body: PLA or PETG
- Diffusers: Clear/translucent filament
- Pause Print after diffuser layers.
- No supports needed for most parts
- 0.2mm layer height recommended
- 20% infill for main bodies
- 100% infill for diffusers

# ESPHome Setup & Installation Guide

## Method 1: Home Assistant Add-on (Recommended)

If you're already using Home Assistant:

1. Open Home Assistant
2. Go to Settings → Add-ons → Add-on Store
3. Search for "ESPHome"
4. Click "Install"
5. Start the ESPHome add-on
6. Open the ESPHome dashboard

## Method 2: Command Line Installation

If you prefer using ESPHome directly:

open terminal:
`pip install esphome`

then to open the dashboard:
`esphome dashboard

## Firmware Installation

### First-Time Setup

1. Connect your ESP board to your computer via USB
2. In the firmware files, Download the appropriate YAML configuration or download the github repo, they are all called leg-digit.yaml,

2.5: You must create your own file secrets.yaml with the following

`#ESPHome
wifi_ssid: "networkName"

wifi_password: "password"

ota_password: "password"

api_encryption_key: "long_jumble_of_random_characters_you_create_once"`

ota_password is just a new key that you create that will be needed to be able to update the clock device wirelessly over the air afterwards.
api_encryption_key Is a unique BASE64 key which can be generated here:
https://esphome.io/components/api.html#configuration-variables

## Configuration Settings in led-digits.yaml

Also in addition to secrets, edit these values in your main YAML file before installing:
wifi:

> ssid: "Your_WiFi_Name"
> password: "Your_WiFi_Password"

# Installing Firmware with ESPHome Dashboard

1. Open Esphome dashboard with the yaml loaded for the print you want:
   `esphome dashboard firmwareV5_SixDigitMonolith`
2. Click the link or go to http://0.0.0.0:6052 in browser
3. Click three dots in dashboard under name of firmware > Install

## First Time Setup,

4.  plug d1 mini usb port into computer:
5.  Click Plug into this computer > Download Project > Agree to allow .bin file in browser download if needed > Open EspHome Web
6.  Connect in the new window > Find your device serialPort
7.  Click "Install"
8.  Chose File - Select the .bin file in downloads folder
9.  Click Install and it should work, you may need to reset or unplug and plug the esp32 or try a few times

## Later updates (changing colour or brightness in the code)

4. plug d1 mini into any power source and observe blue light flash
5. Click Wirelessly
6. Install should start watch log for errors and try again if needed

### Later updates Using Command Line

Navigate to your config directory
`cd path/to/config`
Compile and upload
`esphome --dashboard run ./firmwareV5_Publish6Digit/led-digit.yaml --device OTA`

## Notes

- Basic soldering skills required
- Requires Home Assistant setup
- ESPHome knowledge helpful but not required
- Print time varies by model (2-8 hours depending on version)
- Ask chatgpt for help with any of these.

Happy printing! If you make one, please share your results!
