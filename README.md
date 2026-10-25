# Solar Display

Battery-powered, wall-mounted 7.5" e-paper display that shows solar production
and grid consumption from Home Assistant, and reports its battery level back.

```
esphome/solar-display.yaml               firmware (ESPHome, deep sleep)
esphome/secrets.yaml.example             copy to secrets.yaml
homeassistant/packages/solar_display.yaml helpers, meters, 24h history, low-battery alert
case/solar_display_case.scad             parametric 2-part case (OpenSCAD)
```

## Parts

| Part | Notes |
|---|---|
| Waveshare 7.5" e-Paper HAT **V2** (800×480) | only the raw panel is used, the HAT adapter board stays unused |
| Seeed XIAO ePaper Display Board EE04 | XIAO ESP32-S3 Plus, set the jumper to **24-pin** |
| LiPo 1S 3.7 V **4000 mAh, size 606090** (6 × 60 × 90 mm) | with protection circuit (PCM), JST-PH 2.0 connector |
| 24-pin 0.5 mm FPC/FFC extension: adapter board + ~10 cm FFC cable | the panel's 24 mm FPC tail can't reach the EE04 connector (see Case) |
| 4 × M3 heat-set inserts (Ø4 mm hole, ≤6 mm long), 4 × M3×8 countersunk screws | lid |
| 4 × M2×6 self-tapping screws | board onto the lid standoffs |
| Foam tape ~1 mm, double-sided tape | pads → panel back, board → lid |
| 2 wall screws, head Ø ≤ 8 mm | keyholes, 100 mm apart |

### Battery

The 606090 cell fits flat behind the panel next to the board, keeps the case at
about 20 mm deep and gives roughly **5 months** at a refresh every 15 minutes
during the day (estimate: ~0.35 mAh per wake, sleeping 22:00–06:00). Any other
1S pouch cell works if you change the `batt_*` parameters in the case.

- **Check the polarity before plugging it in.** Many cells sold with a JST-PH
  connector have red/black swapped compared to the board. Compare with the +/−
  marking on the EE04 and swap the pins in the plug if needed.
- Only use cells with a protection circuit. The battery sits in its own pocket
  so nothing presses on it.
- Seeed doesn't publish the EE04's charge current. At a typical 100–200 mA,
  a full charge of 4000 mAh takes about one day. To charge, lift the display off
  the keyholes and plug in USB-C at the bottom.

## Pin map (EE04)

From Seeed_GFX `User_Setups/EPaper_Board_Pins_Setups.h` and the Seeed wiki:

| Signal | GPIO |
|---|---|
| SCK / MOSI | 7 / 9 |
| CS / DC / RST / BUSY | 44 / 10 / 38 / 4 |
| Display power enable | 43 (driven high) |
| Battery ADC / ADC enable | 1 / 6 |
| Buttons KEY0 / KEY1 / KEY2 | 2 / 3 / 5 (pressed = low); KEY0 wakes the display |

The wiki names the buttons KEY0–2, the silkscreen KEY1–3. Most likely the
silkscreen KEY1 (next to the CHG LED) is GPIO2. Check that in the ESPHome logs.

## Setup

### 1. Home Assistant

1. Find your entities under *Developer tools → States*:
   - solar power, in **W**
   - power provider: check the unit (**kWh** = energy, **W** = power) and how
     often `last_changed` moves (live vs. once a day)
2. Copy `homeassistant/packages/solar_display.yaml` to `<config>/packages/`,
   enable packages in `configuration.yaml` and replace the two `REPLACE_ME`
   entities. If the provider entity is in W, use the commented integration
   sensor in the package.
3. Restart HA. The history sensors fill up one bar per hour.

If the provider only delivers data in daily batches, "Grid per hour" will show
one big bar per day. In that case switch that chart to daily values later.

### 2. Firmware

```sh
cd esphome
cp secrets.yaml.example secrets.yaml   # fill in, key: openssl rand -base64 32
# set solar_power_entity at the top of solar-display.yaml
esphome run solar-display.yaml          # first flash via USB-C
```

Then add the device in HA (*Settings → Devices → ESPHome*, usually
auto-discovered). It exposes *Battery Level*, *Battery Voltage* and *WiFi
Signal*. Since the device declares deep sleep, HA keeps the last values while
it sleeps.

- **OTA updates:** turn on `input_boolean.solar_display_stay_awake`, wait for
  the next wake (or press KEY0), flash, then turn it off again. The device goes
  to sleep right away.
- **Calibrate the battery reading:** measure the battery with a multimeter and
  adjust `multiply: 2.0` under `battery_voltage` until the values match.
- **Faster wakes:** set a static IP (`manual_ip`) to save 1–2 s per wake.

### 3. Case

Open `case/solar_display_case.scad` in OpenSCAD, set `part` to `front` or
`back`, render (F6) and export as STL. `assembly` shows both parts with the
panel, battery and the real board model (`case/ref/ee04.stl`), `open` the
same without the lid. Ready exports are in `case/stl/`.

Outer size 187 × 132 × 19.6 mm. The dimensions come from:
- Panel: Waveshare *7.5inch e-Paper V2 Specification*. The active area is
  3.5 mm from the left, right and top edges and 9.78 mm from the FPC edge.
  The FPC tail is 22 mm wide and 24 mm long.
- Board: Seeed's STEP model *XIAO ePaper Display Board EE04 v2* (80 × 41.2 mm,
  four Ø2.5 mm holes 74.9 × 36.2 mm apart).

USB-C, the ON/OFF switch, RESET and the three keys all sit on one long edge of
the EE04, and the 24-pin connector on the opposite one. So the board lies along
the bottom wall (component side towards the panel), and the panel's short
FPC tail connects through a 24-pin FFC extension.

Bottom wall, seen from the back, left to right:
- ON/OFF switch
- RESET (pin hole, use a paper clip)
- KEY3, KEY2, KEY1 (flexure buttons)
- USB-C

Seen from the front it's mirrored.

Checked on the board: the button actuators sit 3.3 mm above the PCB back
(`key_up`), stick out 0.46 mm past the PCB edge and travel about 0.1 mm.
After the first print, tune `key_nub` in 0.1 mm steps:
- no click: increase it
- a button stays pressed or the tab bulges outward: decrease it

A pressed KEY1 keeps the display waking up and drains the battery.

Print in PETG or ASA (PLA can warp in a warm spot or in sun):
- front tray face down, no supports
- back lid outer face down (`part = "back"` is already flipped)

Assembly:
1. Melt the inserts into the four posts.
2. Put the panel into the pocket with the FPC at the bottom. Fold the FPC
   tail gently behind the panel, never crease it, and plug it into the
   extension adapter. Tape the adapter flat onto the panel back.
3. Screw the board onto the lid standoffs (M2×6), components facing away from
   the lid. Tape the battery into its pocket and stick 1 mm foam onto the four
   pressure pads.
4. Connect the FFC from the adapter to the EE04's 24-pin connector, then plug
   in the battery and the antenna. The XIAO's flexible antenna goes on the
   inside of the lid, away from the battery.
5. Set the EE04 jumper to 24-pin. If the image comes out upside down, add
   `rotation: 180` to the display in the ESPHome config.
6. Screw the lid on and hang the case on two screws 100 mm apart.

## Possible next steps

- Skip the refresh when nothing changed (saves battery)
- Use KEY1/KEY2 to switch pages (e.g. today vs. last 7 days)
- Partial refresh with `model: 7.50inV2p` for a clock
