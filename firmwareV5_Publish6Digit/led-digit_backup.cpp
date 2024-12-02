# 'esphome --dashboard run ./firmwareV4/led-digit.yaml --device OTA
esphome:
  name: 6-digit-clock-inone
  friendly_name: SixDigit Clock In One

esp8266:
  board: d1_mini

# Add this time component
time:
  - platform: sntp
    id: sntp_time
    timezone: America/Edmonton # Change this to your timezone

logger:

ota:
  platform: esphome
  password: !secret ota_password

wifi:
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  ap:
    ssid: "Seven-Seg-Test"
    password: "configureme"

light:
  - platform: neopixelbus
    id: led_strip
    name: "LED Strip"
    type: RGB
    pin: GPIO4
    num_leds: 52
    variant: WS2812
    default_transition_length: 0s
    restore_mode: ALWAYS_ON
    on_turn_on:
      then:
        - light.turn_on:
            id: led_strip
            effect: "Show Time"
    effects:
      - addressable_lambda:
          name: "Show Time"
          update_interval: 1000ms
          lambda: |-
            static Color sign_color = Color(0, 255, 0);
            static const Color off_color = Color(0, 0, 0);

            auto time = id(sntp_time).now();
            int hours = time.hour;
            int minutes = time.minute;

            // Choose brightness based on time
            if (hours >= 20 || hours < 7) {
              // Night time (8 PM - 7 AM) - dimmer red
              sign_color = Color(0, 127, 0);  // GRB order: (Green=0, Red=127, Blue=0)
            } else {
              // Day time (7 AM - 8 PM) - full red
              sign_color = Color(0, 255, 0);  // GRB order: (Green=0, Red=255, Blue=0)
            }

            // Convert to 12-hour format
            if (hours > 12) hours -= 12;
            if (hours == 0) hours = 12;

            // Redefine segments array to match physical layout
            // Index meaning:
            // [0] = left top vertical
            // [1] = top horizontal
            // [2] = middle horizontal (appears on both strips)
            // [3] = right top vertical
            // [4] = left bottom vertical
            // [5] = bottom horizontal
            // [6] = middle horizontal (same as [2])
            // [7] = right bottom vertical
            static const uint8_t SEGMENTS[10][8] = {
              {1, 1, 0, 1, 1, 1, 0, 1},    // 0
              {0, 0, 0, 1, 0, 0, 0, 1},    // 1
              {0, 1, 1, 1, 1, 1, 1, 0},    // 2
              {0, 1, 1, 1, 0, 1, 1, 1},    // 3
              {1, 0, 1, 1, 0, 0, 1, 1},    // 4
              {1, 1, 1, 0, 0, 1, 1, 1},    // 5
              {1, 1, 1, 0, 1, 1, 1, 1},    // 6
              {0, 1, 0, 1, 0, 0, 0, 1},    // 7
              {1, 1, 1, 1, 1, 1, 1, 1},    // 8
              {1, 1, 1, 1, 0, 1, 1, 1}     // 9
            };

            // Updated display_digit function for new layout
            auto display_digit = [&](int digit_position, int number) {
              if (number < 0 || number > 9) return;
              
              // Calculate top LED positions, accounting for colon LEDs
              int top_start;
              if (digit_position <= 1) {
                  top_start = digit_position * 4;  // First two digits: 0-3, 4-7
              } else if (digit_position <= 3) {
                  top_start = (digit_position * 4) + 1;  // Middle digits: 9-12, 13-16
              } else {
                  top_start = (digit_position * 4) + 2;  // Last two digits: 18-21, 22-25
              }
              
              // Calculate bottom LED positions, accounting for colon LEDs
              int bottom_start;
              if (digit_position <= 1) {
                  bottom_start = 51 - (digit_position * 4);  // First two digits: 48-51, 44-47
              } else if (digit_position <= 3) {
                  bottom_start = 42 - ((digit_position - 2) * 4);  // Middle digits: 39-42, 35-38
              } else {
                  bottom_start = 33 - ((digit_position - 4) * 4);  // Last two digits: 30-33, 26-29
              }
              
              // Top row LEDs (left to right)
              it[top_start].set(SEGMENTS[number][0] ? sign_color : off_color);     // left top vertical
              it[top_start + 1].set(SEGMENTS[number][1] ? sign_color : off_color); // top horizontal
              it[top_start + 2].set(SEGMENTS[number][2] ? sign_color : off_color); // middle horizontal
              it[top_start + 3].set(SEGMENTS[number][3] ? sign_color : off_color); // right top vertical
              
              // Bottom row LEDs (right to left)
              it[bottom_start - 3].set(SEGMENTS[number][7] ? sign_color : off_color); // right bottom vertical
              it[bottom_start - 2].set(SEGMENTS[number][5] ? sign_color : off_color); // bottom horizontal
              it[bottom_start - 1].set(SEGMENTS[number][2] ? sign_color : off_color); // middle horizontal
              it[bottom_start].set(SEGMENTS[number][4] ? sign_color : off_color);     // left bottom vertical
            };

            // Clear all LEDs first
            for (int i = 0; i < it.size(); i++) {
              it[i].set(off_color);
            }

            // Display time digits (positions 0-5, from left to right)
            if (hours < 10) {
              // Hours < 10, leave first digit blank
              display_digit(1, hours);          // Hours in ones position
            } else {
              // Hours 10-12, show both digits
              display_digit(0, hours / 10);     // Hours tens
              display_digit(1, hours % 10);     // Hours ones
            }

            // Always show both digits for minutes
            display_digit(2, minutes / 10);    // Minutes tens
            display_digit(3, minutes % 10);    // Minutes ones

            // Always show both digits for seconds
            int seconds = time.second;
            display_digit(4, seconds / 10);    // Seconds tens
            display_digit(5, seconds % 10);    // Seconds ones

            // Colons - both top and bottom should be lit
            it[8].set(sign_color);    // First colon top
            it[43].set(sign_color);   // First colon bottom
            it[17].set(sign_color);   // Second colon top
            it[34].set(sign_color);   // Second colon bottom

