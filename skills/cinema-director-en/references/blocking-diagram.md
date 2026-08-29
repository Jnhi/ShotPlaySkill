# Blocking-Diagram Bible — Text-Based Overhead Staging Map (draw BEFORE storyboarding)

> **Draw the map, then break the shots.** Before any scene enters the shot list, produce a text-based blocking diagram: a top-down wide view that marks character positions, movement paths, camera positions and light positions — a ground plan drawn in characters.
> **Why**: few people write staging into prompts; almost nobody draws it. Once drawn, three error families die on paper: ① axis jumps (all cameras visible → crossing the line is obvious) ② unmotivated light (a lamp must sit at a physical position — can't place it = can't light it) ③ spatial amnesia (where everyone stands, where they move, how far apart — no more guessing at shot-breaking time).
> **Dual use**: the map is the spatial ground truth for shot-breaking, AND can be fed to an image model as a spatial reference (§6).

## 1. Six Required Elements (missing one = rejected)

| # | Element | Content | Serves |
|---|---|---|---|
| 1 | Scene frame | top-down outline: walls/doors/windows/key props, orientation + scale | "teach the space to the audience first" |
| 2 | Characters & paths | start ●/end ○/dashed path + beat numbers ①② | staging methods land on paper |
| 3 | Cameras | C1/C2… + facing arrow + shot size + covered shot #s | every shot must map to a camera |
| 4 | Lights | K key / F fill / B rim / E ambient + direction + **motivated source** | "every light has an explainable origin" |
| 5 | The axis | 180° line drawn as dots, camera discipline annotated | axis / 30° rule enforced on paper |
| 6 | Legend + scale + orientation | first line declares "top-down · up=X · 1 cell ≈ X m" | anyone (or any AI) reads it in 3 seconds |

## 2. Symbol System (fixed)

```
●A     character start position (solid dot + single-letter code)
○A'    character position after moving
─ ─▶   movement path (dashed + arrow), beat numbers ①②③ on the line
⌒      curved path (circling = toying with prey)
✕      key landing point (kneel spot / body position / prop drop / impact point)
C1▲    camera + lens facing (▲▼◀▶↖↗↘↙ eight directions), note (size · shot #s)
K1→    key light, arrow = throw direction, (motivated source) in parentheses
F1→    fill light (same)      B1→  rim light (same)      E1  ambient (mark area)
━ ┃    walls        ╬door╬    ▤ window        ▭  table/bed/prop (labeled)
┆┆┆    the axis (180° line), annotated "all cameras on X side"
```

**Discipline**: single-letter character codes, locked project-wide; a light without a motivated source in parentheses may not be drawn (= may not be lit); a camera without shot numbers may not exist on the map; a shot number without a camera may not exist in the shot list.

## 3. Verbatim Template (one per scene)

```
[Blocking Diagram · EPxx-Sx Scene Name · top-down · up=direction · 1 cell ≈ X m · domain A/B/C]

(character drawing: scene frame + characters + paths + cameras + lights + axis)

◆ Beat table:    | beat | who | action | shot #s | dialogue/SFX anchor |
◆ Camera table:  | cam | size | facing | covered shots | staging method used |
◆ Light table:   | light | type | motivated source | direction & fall-off | serves shots |
◆ Axis declaration: axis = who↔who; cameras all on X side; crossing via on-axis / cutaway
◆ Staging method: which of the six (file 12 §1); mute test: power readable from map alone?
```

## 4. Worked Example — "Snowblade Inn", the bounty crew enters

```
[Blocking Diagram · EP01-S3 Inn main hall · top-down · up=north (hearth end) · 1≈1m · domain A]

━━━━▤━━━━━━▤━━━━  north wall (hearth)
┃   K1↓(hearth fire · warm)      ┃
┃     ▭ counter                  ┃
┃     ●B(innkeeper/Blade,        ┃
┃        wiping a bowl, still)   ┃
┃          ┆                     ┃
┃   ▭table ┆  ▭table   C2◀      ┃
┃          ┆          (MS·S05-08)┃
┃     ✕center floor              ┃
┃     ▲    ┆            C3◀     ┃
┃     ┆①   ┆        (CU·S09-11) ┃
┃  ●L(bounty leader)+♦♦crew      ┃
┃ F1→(oil lamps on tables · dim) ┃
━━━━╬door(south)╬━━━━  B1↑(moonlit snow outside · cold rim)

┆┆┆ axis = B↔L (north-south) · all cameras east side · C1▲(ELS·S01 establishing·on-axis)
```

◆ Beat table
| beat | who | action | shots | sound anchor |
|---|---|---|---|---|
| ① | L + crew | push through door, advance to center floor ✕, fan out | S02-S04 | door slam, snow gust, boots |
| ② | B | keeps wiping the bowl — sets it down, cloth folded flat | S09 | cloth on wood, hall goes silent |

◆ Camera table
| cam | size | facing | shots | staging method |
|---|---|---|---|---|
| C1 | ELS | ▲north, on-axis | S01 | teach the space: door-tables-counter one axis |
| C2 | MS | ◀ east side | S05-S08 | triangle: L at apex, crew as base |
| C3 | CU | ◀ east near | S09-S11 | power blocking: the still man rules the room |

◆ Light table
| light | type | motivated source | direction & fall-off | shots |
|---|---|---|---|---|
| K1 | key | hearth fire, north wall | south-throwing, warm, near-bright far-dark | all |
| F1 | fill | table oil lamps | local pools, dim | S05-S08 |
| B1 | rim | moonlit snow through door | south→north, cold | S02 entrance silhouettes |

◆ Axis: B↔L north-south; all cameras east; C1 on-axis legal (establishing).
◆ Staging: power blocking (whole crew moves, one man still = the still one owns the room). Mute test ✅ — map alone reads: many advance on one, and the one is not afraid.

## 5. Short-Form Exemption (anti-bloat)

Single-character or two-person static dialogue scenes (no movement, ≤2 cameras) may use the **3-line short form** at the top of the shot list:

```
Positions: A seated by window (still) | B standing at door
Cameras: C1◀MS(S01-03) · C2↗CU(S04-06) · axis=A↔B, all cameras left side
Lights: K1=window daylight→(bright left, falls right) · F1=candle→(warm, dim)
```

Three or more characters, any movement, any fight, any crowd — **full map required**. Fight scenes overlay attack/defense beats on the movement paths.

## 6. Two Ways to Feed the Map

**A. Direct text feed (default)**: the map never enters the final deliverable, but it is the upstream truth — the [Shot-by-Shot Script] scene setup copies spatial relations from the frame; each shot's move/size copies from the camera table; light description copies from the light table (motivation + direction + fall-off, ready-made); actions copy from the beat table. **Breaking shots without the map on hand = blind storyboarding, rejected.**

**B. Image reference (optional, strongly advised for complex scenes)**: hand the map to an image model to produce a real overhead schematic, used as a spatial reference for first-frame generation. Prompt template:

> Film production blocking schematic, top-down view, hand-drawn production style, black linework on white: [scene outline]. Annotations: [character codes & positions]; dashed arrows for movement paths [describe]; camera icons at [positions, facings]; light-fixture icons at [positions] with short rays showing throw direction. Technical-drawing style, clear labels, no perspective, no color, no character detail.

## 7. The Five Checks (pass, then storyboard)

```
□ 1. Axis: all cameras one side? crossings via on-axis/cutaway shots only?
□ 2. Motivated light: every light's parentheses name a physical source?
□ 3. Staging: which of the six methods? does the mute test pass?
□ 4. Alignment: every path numbered and tied to shot #s / dialogue anchors?
□ 5. Coverage: every shot number in the list maps back to a camera? (no orphan shots)
```

---
*Blocking-Diagram Bible v1.0 (EN) | Delivery flow: Director analysis → **Blocking diagram** → Shot list → Six-Block prompts. Full Chinese edition with extended examples: `../cinema-director/references/29_调度图圣经_文字版站位灯位机位图.md`*
