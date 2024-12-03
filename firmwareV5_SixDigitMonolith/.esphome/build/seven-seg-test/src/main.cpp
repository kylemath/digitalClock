// Auto generated code by esphome
// ========== AUTO GENERATED INCLUDE BLOCK BEGIN ===========
#include "esphome.h"
using namespace esphome;
using std::isnan;
using std::min;
using std::max;
using namespace time;
using namespace light;
logger::Logger *logger_logger_id;
wifi::WiFiComponent *wifi_wificomponent_id;
mdns::MDNSComponent *mdns_mdnscomponent_id;
esphome::ESPHomeOTAComponent *esphome_esphomeotacomponent_id;
safe_mode::SafeModeComponent *safe_mode_safemodecomponent_id;
preferences::IntervalSyncer *preferences_intervalsyncer_id;
sntp::SNTPComponent *sntp_time;
neopixelbus::NeoPixelRGBLightOutput<NeoEspBitBangMethodBase<NeoEspBitBangSpeed800Kbps, NeoEspPinset>> *neopixelbus_neopixelbuslightoutputbase_id;
light::AddressableLightState *led_strip;
light::AddressableLambdaLightEffect *light_addressablelambdalighteffect_id;
light::LightTurnOnTrigger *light_lightturnontrigger_id;
Automation<> *automation_id;
light::LightControlAction<> *light_lightcontrolaction_id;
const uint8_t ESPHOME_ESP8266_GPIO_INITIAL_MODE[16] = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255};
const uint8_t ESPHOME_ESP8266_GPIO_INITIAL_LEVEL[16] = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255};
#define yield() esphome::yield()
#define millis() esphome::millis()
#define micros() esphome::micros()
#define delay(x) esphome::delay(x)
#define delayMicroseconds(x) esphome::delayMicroseconds(x)
// ========== AUTO GENERATED INCLUDE BLOCK END ==========="

void setup() {
  // ========== AUTO GENERATED CODE BEGIN ===========
  // esp8266:
  //   board: d1_mini
  //   framework:
  //     version: 3.1.2
  //     source: ~3.30102.0
  //     platform_version: platformio/espressif8266@4.2.1
  //   restore_from_flash: false
  //   early_pin_init: true
  //   board_flash_mode: dout
  esphome::esp8266::setup_preferences();
  // esphome:
  //   name: seven-seg-test
  //   friendly_name: Seven Segment Test
  //   build_path: build/seven-seg-test
  //   area: ''
  //   platformio_options: {}
  //   includes: []
  //   libraries: []
  //   name_add_mac_suffix: false
  //   min_version: 2024.10.3
  App.pre_setup("seven-seg-test", "Seven Segment Test", "", "", __DATE__ ", " __TIME__, false);
  // time:
  // light:
  // logger:
  //   id: logger_logger_id
  //   baud_rate: 115200
  //   tx_buffer_size: 512
  //   deassert_rts_dtr: false
  //   hardware_uart: UART0
  //   level: DEBUG
  //   logs: {}
  //   esp8266_store_log_strings_in_flash: true
  logger_logger_id = new logger::Logger(115200, 512);
  logger_logger_id->set_uart_selection(logger::UART_SELECTION_UART0);
  logger_logger_id->pre_setup();
  logger_logger_id->set_component_source("logger");
  App.register_component(logger_logger_id);
  // wifi:
  //   ap:
  //     ssid: Seven-Seg-Test
  //     password: configureme
  //     id: wifi_wifiap_id
  //     ap_timeout: 1min
  //   id: wifi_wificomponent_id
  //   domain: .local
  //   reboot_timeout: 15min
  //   power_save_mode: NONE
  //   fast_connect: false
  //   output_power: 20.0
  //   passive_scan: false
  //   enable_on_boot: true
  //   networks:
  //   - ssid: !secret 'wifi_ssid'
  //     password: !secret 'wifi_password'
  //     id: wifi_wifiap_id_2
  //     priority: 0.0
  //   use_address: seven-seg-test.local
  wifi_wificomponent_id = new wifi::WiFiComponent();
  wifi_wificomponent_id->set_use_address("seven-seg-test.local");
  {
  wifi::WiFiAP wifi_wifiap_id_2 = wifi::WiFiAP();
  wifi_wifiap_id_2.set_ssid("KitchigaiNet_2Ghz");
  wifi_wifiap_id_2.set_password("ohcanada");
  wifi_wifiap_id_2.set_priority(0.0f);
  wifi_wificomponent_id->add_sta(wifi_wifiap_id_2);
  }
  {
  wifi::WiFiAP wifi_wifiap_id = wifi::WiFiAP();
  wifi_wifiap_id.set_ssid("Seven-Seg-Test");
  wifi_wifiap_id.set_password("configureme");
  wifi_wificomponent_id->set_ap(wifi_wifiap_id);
  }
  wifi_wificomponent_id->set_ap_timeout(60000);
  wifi_wificomponent_id->set_reboot_timeout(900000);
  wifi_wificomponent_id->set_power_save_mode(wifi::WIFI_POWER_SAVE_NONE);
  wifi_wificomponent_id->set_fast_connect(false);
  wifi_wificomponent_id->set_passive_scan(false);
  wifi_wificomponent_id->set_output_power(20.0f);
  wifi_wificomponent_id->set_enable_on_boot(true);
  wifi_wificomponent_id->set_component_source("wifi");
  App.register_component(wifi_wificomponent_id);
  // mdns:
  //   id: mdns_mdnscomponent_id
  //   disabled: false
  //   services: []
  mdns_mdnscomponent_id = new mdns::MDNSComponent();
  mdns_mdnscomponent_id->set_component_source("mdns");
  App.register_component(mdns_mdnscomponent_id);
  // ota:
  // ota.esphome:
  //   platform: esphome
  //   password: !secret 'ota_password'
  //   id: esphome_esphomeotacomponent_id
  //   version: 2
  //   port: 8266
  esphome_esphomeotacomponent_id = new esphome::ESPHomeOTAComponent();
  esphome_esphomeotacomponent_id->set_port(8266);
  esphome_esphomeotacomponent_id->set_auth_password("paddingfoot");
  esphome_esphomeotacomponent_id->set_component_source("esphome.ota");
  App.register_component(esphome_esphomeotacomponent_id);
  // safe_mode:
  //   id: safe_mode_safemodecomponent_id
  //   boot_is_good_after: 1min
  //   disabled: false
  //   num_attempts: 10
  //   reboot_timeout: 5min
  safe_mode_safemodecomponent_id = new safe_mode::SafeModeComponent();
  safe_mode_safemodecomponent_id->set_component_source("safe_mode");
  App.register_component(safe_mode_safemodecomponent_id);
  if (safe_mode_safemodecomponent_id->should_enter_safe_mode(10, 300000, 60000)) return;
  // preferences:
  //   id: preferences_intervalsyncer_id
  //   flash_write_interval: 60s
  preferences_intervalsyncer_id = new preferences::IntervalSyncer();
  preferences_intervalsyncer_id->set_write_interval(60000);
  preferences_intervalsyncer_id->set_component_source("preferences");
  App.register_component(preferences_intervalsyncer_id);
  // time.sntp:
  //   platform: sntp
  //   id: sntp_time
  //   timezone: MST7MDT,M3.2.0,M11.1.0
  //   update_interval: 15min
  //   servers:
  //   - 0.pool.ntp.org
  //   - 1.pool.ntp.org
  //   - 2.pool.ntp.org
  sntp_time = new sntp::SNTPComponent();
  sntp_time->set_servers("0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org");
  sntp_time->set_update_interval(900000);
  sntp_time->set_component_source("sntp.time");
  App.register_component(sntp_time);
  sntp_time->set_timezone("MST7MDT,M3.2.0,M11.1.0");
  // light.neopixelbus:
  //   platform: neopixelbus
  //   id: led_strip
  //   name: LED Strip
  //   type: RGB
  //   pin: 4
  //   num_leds: 36
  //   variant: ws2812
  //   default_transition_length: 0s
  //   restore_mode: ALWAYS_ON
  //   on_turn_on:
  //   - then:
  //     - light.turn_on:
  //         id: led_strip
  //         effect: Show Time
  //         state: true
  //       type_id: light_lightcontrolaction_id
  //     automation_id: automation_id
  //     trigger_id: light_lightturnontrigger_id
  //   effects:
  //   - addressable_lambda:
  //       name: Show Time
  //       update_interval: 1000ms
  //       lambda: !lambda "static const Color sign_color = Color(200, 60, 60);\nstatic const
  //         \ Color off_color = Color(0, 0, 0);\n\nauto time = id(sntp_time).now();\nint
  //         \ hours = time.hour;\nint minutes = time.minute;\n\n Convert to 12-hour format\n
  //         if (hours > 12) hours -= 12;\nif (hours == 0) hours = 12;\n\n Keep your existing
  //         \ SEGMENTS array and display_digit function exactly as they are\nstatic const
  //         \ uint8_t SEGMENTS[10][8] = {\n  {1, 0, 1, 1, 1, 1, 0, 1},     0\n  {0, 0,
  //         \ 0, 1, 0, 0, 0, 1},     1\n  {1, 1, 1, 0, 0, 1, 1, 1},     2\n  {0, 1,
  //         \ 1, 1, 0, 1, 1, 1},     3\n  {0, 1, 0, 1, 1, 0, 1, 1},     4\n  {0, 1,
  //         \ 1, 1, 1, 1, 1, 0},     5\n  {1, 1, 1, 1, 1, 1, 1, 0},     6\n  {0, 0,
  //         \ 0, 1, 0, 1, 0, 1},     7\n  {1, 1, 1, 1, 1, 1, 1, 1},     8\n  {0, 1,
  //         \ 1, 1, 1, 1, 1, 1}      9\n};\n\n Function to display a number at a specific
  //         \ digit position\nauto display_digit = [&](int bottom_start, int top_start,
  //         \ int number) {\n  if (number < 0 || number > 9) return;\n  \n   Bottom row
  //         \ LEDs\n  it[bottom_start].set(SEGMENTS[number][0] ? sign_color : off_color);
  //         \       i\n  it[bottom_start + 1].set(SEGMENTS[number][1] ? sign_color : off_color);
  //         \   ii\n  it[bottom_start + 2].set(SEGMENTS[number][2] ? sign_color : off_color);
  //         \   iii\n  it[bottom_start + 3].set(SEGMENTS[number][3] ? sign_color : off_color);
  //         \   iv\n  \n   Top row LEDs\n  it[top_start].set(SEGMENTS[number][4] ? sign_color
  //         \ : off_color);       v\n  it[top_start - 1].set(SEGMENTS[number][5] ? sign_color
  //         \ : off_color);   vi\n  it[top_start - 2].set(SEGMENTS[number][6] ? sign_color
  //         \ : off_color);   vii\n  it[top_start - 3].set(SEGMENTS[number][7] ? sign_color
  //         \ : off_color);   viii\n};\n\n Clear all LEDs first\nfor (int i = 0; i <
  //         \ it.size(); i++) {\n  it[i].set(off_color);\n}\n\n Display hours and minutes
  //         \ using your working LED positions\nif (hours < 10) {\n   Hours < 10, leave
  //         \ first digit blank\n  display_digit(4, 31, hours);           Hours in ones
  //         \ position\n} else {\n   Hours 10-12, show both digits\n  display_digit(0,
  //         \ 35, hours / 10);      Hours tens\n  display_digit(4, 31, hours % 10);  
  //         \    Hours ones\n}\n\n Always show both digits for minutes\ndisplay_digit(10,
  //         \ 25, minutes / 10);     Minutes tens\ndisplay_digit(14, 21, minutes % 10);
  //         \     Minutes ones\n\n Light up both colon pairs (always on)\nit[8].set(sign_color);
  //         \    First colon bottom\nit[27].set(sign_color);   Second colon bottom"
  //     type_id: light_addressablelambdalighteffect_id
  //   disabled_by_default: false
  //   gamma_correct: 2.8
  //   flash_transition_length: 0s
  //   output_id: neopixelbus_neopixelbuslightoutputbase_id
  //   invert: false
  //   method:
  //     type: bit_bang
  neopixelbus_neopixelbuslightoutputbase_id = new neopixelbus::NeoPixelRGBLightOutput<NeoEspBitBangMethodBase<NeoEspBitBangSpeed800Kbps, NeoEspPinset>>();
  led_strip = new light::AddressableLightState(neopixelbus_neopixelbuslightoutputbase_id);
  App.register_light(led_strip);
  led_strip->set_component_source("light");
  App.register_component(led_strip);
  led_strip->set_name("LED Strip");
  led_strip->set_object_id("led_strip");
  led_strip->set_disabled_by_default(false);
  led_strip->set_restore_mode(light::LIGHT_ALWAYS_ON);
  led_strip->set_default_transition_length(0);
  led_strip->set_flash_transition_length(0);
  led_strip->set_gamma_correct(2.8f);
  light_addressablelambdalighteffect_id = new light::AddressableLambdaLightEffect("Show Time", [=](light::AddressableLight & it, Color current_color, bool initial_run) -> void {
      #line 49 "./firmwareV4_Publish4Digit/led-digit.yaml"
      static const Color sign_color = Color(200, 60, 60);
      static const Color off_color = Color(0, 0, 0);
      
      auto time = sntp_time->now();
      int hours = time.hour;
      int minutes = time.minute;
      
       
      if (hours > 12) hours -= 12;
      if (hours == 0) hours = 12;
      
       
      static const uint8_t SEGMENTS[10][8] = {
        {1, 0, 1, 1, 1, 1, 0, 1},     
        {0, 0, 0, 1, 0, 0, 0, 1},     
        {1, 1, 1, 0, 0, 1, 1, 1},     
        {0, 1, 1, 1, 0, 1, 1, 1},     
        {0, 1, 0, 1, 1, 0, 1, 1},     
        {0, 1, 1, 1, 1, 1, 1, 0},     
        {1, 1, 1, 1, 1, 1, 1, 0},     
        {0, 0, 0, 1, 0, 1, 0, 1},     
        {1, 1, 1, 1, 1, 1, 1, 1},     
        {0, 1, 1, 1, 1, 1, 1, 1}      
      };
      
       
      auto display_digit = [&](int bottom_start, int top_start, int number) {
        if (number < 0 || number > 9) return;
        
         
        it[bottom_start].set(SEGMENTS[number][0] ? sign_color : off_color);       
        it[bottom_start + 1].set(SEGMENTS[number][1] ? sign_color : off_color);   
        it[bottom_start + 2].set(SEGMENTS[number][2] ? sign_color : off_color);   
        it[bottom_start + 3].set(SEGMENTS[number][3] ? sign_color : off_color);   
        
         
        it[top_start].set(SEGMENTS[number][4] ? sign_color : off_color);       
        it[top_start - 1].set(SEGMENTS[number][5] ? sign_color : off_color);   
        it[top_start - 2].set(SEGMENTS[number][6] ? sign_color : off_color);   
        it[top_start - 3].set(SEGMENTS[number][7] ? sign_color : off_color);   
      };
      
       
      for (int i = 0; i < it.size(); i++) {
        it[i].set(off_color);
      }
      
       
      if (hours < 10) {
         
        display_digit(4, 31, hours);           
      } else {
         
        display_digit(0, 35, hours / 10);      
        display_digit(4, 31, hours % 10);      
      }
      
       
      display_digit(10, 25, minutes / 10);     
      display_digit(14, 21, minutes % 10);     
      
       
      it[8].set(sign_color);    
      it[27].set(sign_color);   
  }, 1000);
  led_strip->add_effects({light_addressablelambdalighteffect_id});
  light_lightturnontrigger_id = new light::LightTurnOnTrigger(led_strip);
  automation_id = new Automation<>(light_lightturnontrigger_id);
  light_lightcontrolaction_id = new light::LightControlAction<>(led_strip);
  light_lightcontrolaction_id->set_state(true);
  light_lightcontrolaction_id->set_effect("Show Time");
  automation_id->add_actions({light_lightcontrolaction_id});
  neopixelbus_neopixelbuslightoutputbase_id->set_component_source("neopixelbus.light");
  App.register_component(neopixelbus_neopixelbuslightoutputbase_id);
  neopixelbus_neopixelbuslightoutputbase_id->add_leds(36, 4);
  neopixelbus_neopixelbuslightoutputbase_id->set_pixel_order(neopixelbus::ESPNeoPixelOrder::RGB);
  // md5:
  // socket:
  //   implementation: lwip_tcp
  // network:
  //   enable_ipv6: false
  //   min_ipv6_addr_count: 0
  // =========== AUTO GENERATED CODE END ============
  App.setup();
}

void loop() {
  App.loop();
}
