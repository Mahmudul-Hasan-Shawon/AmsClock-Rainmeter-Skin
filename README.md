<div align="center">

# AmsClock

**A minimal Rainmeter clock that quietly rotates a quote beneath your time.**

A huge, letter-spaced day of week, a thin date and a 12 hour clock, centered on a
transparent strip of your desktop. Underneath, a Lua script fades one quote out and
slides the next one in every five seconds, at a smooth 60 fps. One variable turns
the quotes off, and the change applies live.

![Rainmeter](https://img.shields.io/badge/Rainmeter-4.0%2B-1a1a1a?logo=rainmeter&logoColor=white)
![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D6?logo=windows&logoColor=white)
![Lua](https://img.shields.io/badge/logic-Lua%205.1-2C2D72?logo=lua&logoColor=white)
![Version](https://img.shields.io/badge/version-1.3-brightgreen)
![License](https://img.shields.io/badge/license-CC%20BY--NC--SA%203.0-lightgrey)

<img src="preview.png" alt="AmsClock running on a desktop: SUNDAY, 27 SEP 2026 and the Shawon signature over a dark floral wallpaper" width="100%">

</div>

---

## ✨ Features

### 🕐 Clock display

| Feature | Detail |
| --- | --- |
| Day of week | Anurati, 40 px, 20 pt letter spacing, uppercase |
| Date | Gravity Bold, 15 px, 2 pt letter spacing, format `%d %b %Y` |
| Time | Gravity, 10 px, 12 hour with seconds and AM/PM, format `%I:%M:%S %p` |
| Signature | "Shawon" in the Amsterdam script typeface |
| Layout | All meters centered on an adjustable `Width` axis (default 600), transparent background, white text |

### 💬 Rotating quotes

| Feature | Detail |
| --- | --- |
| 9 quotes | Sequential rotation, one new quote every ~5 seconds |
| Fade and slide | ~1 second smoothstep fade in from below, fade out through the top |
| 60 fps motion | Driven on every 16 ms skin tick by the script measure |
| Live toggle | Flip `QuoteShow` between `1` and `0` and the Lua picks it up on the next tick, no refresh needed |
| Quotes editable | Plain Lua table in `@Resources/Quotes.lua` |

### 🔤 Typography and assets

| Feature | Detail |
| --- | --- |
| Bundled fonts | Anurati, Gravity, Gravity Light, plus Bebas family, Yellowtail and Dudu Calligraphy as spares |
| Auto loading | Fonts in `@Resources/Fonts` are available to the skin without installing them (Rainmeter 4.0+) |
| Wallpaper | `AmsClock.png`, a matching dark floral wallpaper included in the folder |

## 🏗️ Architecture

```
                    Rainmeter engine
                    Update=16 ms (~60 fps), AccurateText
                              |
            +-----------------+-------------------+
            |                                     |
            v                                     v
   [Time measures]                     [MeasureQuoteScript]
   MeasureDayOfWeek   %A                Measure=Script
   MeasureDate        %d %b %Y          ScriptFile=#@#Quotes.lua
   MeasureTime        %I:%M:%S %p            |
            |                                 v
            |                           [Quotes.lua]
            |                           advance quote every ~5 s (313 ticks)
            |                           smoothstep fade in/out (~62 ticks)
            |                           !SetOption FontColor / Y
            |                                 |
            v                                 v
   +---------------------------------------------------------+
   |                        Meters                           |
   |   MeterDayOfWeek  (Anurati 40)      MeterQuote          |
   |   MeterDate       (Gravity 15)      (Gravity Light 12,  |
   |   MeterTime       (Gravity 10)      alpha + Y driven    |
   |   MeterShawon     (Amsterdam 30)    by the script)      |
   +---------------------------------------------------------+
```

The skin splits cleanly in two. [AmsClock.ini](AmsClock.ini) is declarative: three
`Time` measures feed four static string meters, and it declares a `Script` measure
pointing at [Quotes.lua](@Resources/Quotes.lua). The Lua owns everything animated:
on every skin update it advances the tick counter, wraps the quote index, applies a
smoothstep curve (`x * x * (3 - 2x)`) to alpha and Y, and pushes the result into
`MeterQuote` with `!SetOption`, followed by `!UpdateMeter` and `!Redraw`. It also
polls the `QuoteShow` variable every tick, which is why toggling quotes needs no
refresh. Tweak the feel entirely from Lua constants: `ticksPerQuote`, `fadeTicks`,
`enterSlide`, `exitSlide`, `maxAlpha`.

## 📁 Project structure

```
AmsClock/
├── AmsClock.ini               # the skin: variables, measures, meters
├── AmsClock.png               # matching dark wallpaper artwork
├── preview.png                # screenshot used at the top of this README
└── @Resources/
    ├── Quotes.lua             # quote list + fade/slide animation engine
    └── Fonts/                 # auto-loaded by Rainmeter 4.0+
        ├── Anurati.otf        #   day of week
        ├── Gravity.otf        #   date and time
        ├── Gravity Light.otf  #   quote
        ├── bebas*.ttf         #   spares (not referenced by the skin)
        ├── yellowtail_1.ttf   #   spares (not referenced by the skin)
        └── Dudu_Calligraphy_Modified.ttf  # spares (not referenced by the skin)
```

## 🧰 Tech stack

| Layer | Technology |
| --- | --- |
| Engine | Rainmeter 4.0+ (requires 4.0 for `@Resources/Fonts` auto loading) |
| Skin | Rainmeter `.ini`: Time measures, String meters, InlineSetting letter spacing |
| Logic | Lua 5.1, embedded by Rainmeter, driven by a Script measure |
| Fonts | Anurati, Gravity, Gravity Light, Amsterdam (signature only) |
| Platform | Windows |

## 🚀 Getting started

### Prerequisites

- Windows 10 or 11
- [Rainmeter](https://www.rainmeter.net/) 4.0 or newer

### Install

1. Copy the `AmsClock` folder into your skins directory:

   ```
   Documents\Rainmeter\Skins\AmsClock
   ```

2. Right click the Rainmeter tray icon and choose **Refresh All**.
3. Open **Manage** (tray icon > Manage), select `AmsClock\AmsClock.ini` and click **Load**.

> **Note on fonts:** the bundled fonts load automatically for this skin. The signature
> meter additionally uses the **Amsterdam** typeface, which is *not* bundled in
> `@Resources/Fonts`; install it system wide, or that meter falls back to your default
> font.

### Turn the quotes on

Quotes are off by default (`QuoteShow=0`). To enable them, either edit
[AmsClock.ini](AmsClock.ini) and set `QuoteShow=1` under `[Variables]`, or run the
bang `!SetVariable QuoteShow 1` from a shortcut, another skin or Rainmeter's Manage
panel. The script notices the change on the next tick and shows or hides the meter
without a refresh.

## 🎛️ Configuration reference

### Skin variables ([AmsClock.ini](AmsClock.ini))

| Variable | Default | Effect |
| --- | --- | --- |
| `QuoteShow` | `0` | `1` shows the rotating quote, `0` hides it (applies live) |
| `Width` | `600` | X axis all meters are centered on; raise it for a wider layout |

### Animation constants ([Quotes.lua](@Resources/Quotes.lua))

| Constant | Default | Effect |
| --- | --- | --- |
| `ticksPerQuote` | `313` | Ticks per quote, ~5 seconds at 60 fps |
| `fadeTicks` | `62` | Fade duration, ~1 second in and out |
| `baseOffset` | `18` | Resting Y offset of the quote meter |
| `enterSlide` | `12` | Pixels the quote slides up from when entering |
| `exitSlide` | `18` | Pixels the quote slides up through when leaving |
| `maxAlpha` | `180` | Resting text alpha, matching the meter's `FontColor` |

### The quotes

Edit the `quotes` table at the top of [Quotes.lua](@Resources/Quotes.lua). Keep them
short: they render on a single line in Gravity Light at 12 px.

<details>
<summary>All 9 quotes shipped in v1.3</summary>

1. WHAT YOU SEEK IS SEEKING YOU.
2. THE WOUND IS THE PLACE WHERE THE LIGHT ENTERS YOU.
3. LET YOURSELF BE SILENTLY DRAWN BY WHAT YOU REALLY LOVE.
4. WHERE THERE IS RUIN, THERE IS HOPE FOR A TREASURE.
5. RAISE YOUR WORDS, NOT YOUR VOICE.
6. THE QUIETER YOU BECOME, THE MORE YOU ARE ABLE TO HEAR.
7. THE BEAUTY YOU SEE IN ME IS A REFLECTION OF YOU.
8. YESTERDAY I WAS CLEVER, SO I WANTED TO CHANGE THE WORLD.
9. TODAY I AM WISE, SO I AM CHANGING MYSELF.

Most of these are well known lines attributed to the poet Rumi, which sets the tone
of the whole skin.
</details>

## 📦 Packaging for distribution

There is no `.rmskin` in this folder, but the skin is ready to be packed with
Rainmeter's built in wizard: tray icon > **Manage** > **Create .rmskin**, add the
`AmsClock` folder (the `@Resources/Fonts` directory rides along, so recipients get
the fonts automatically). That produces a single installable file for sharing.

## 💭 Why AmsClock exists

Some desktops want widgets, graphs and gadgets. This one wanted a single quiet line
of type: what day it is, what time it is, and a sentence worth reading while the
second hand moves. AmsClock is that line, plus nine sentences attributed to Rumi
that cycle through it slowly enough to be noticed and briefly enough to never wear
out. It was built as a personal skin, signature included, and shared under a
non-commercial license so it stays free the way it was made.

## 📄 License

Declared in the skin's `[Metadata]` ([AmsClock.ini](AmsClock.ini)):
**Creative Commons Attribution-NonCommercial-ShareAlike 3.0 (CC BY-NC-SA 3.0)**.
The bundled fonts carry their own licenses from their respective foundries.

---

<div align="center">

<sub>AmsClock 1.3 by mhshan7: time on top, wisdom underneath.</sub>

</div>
