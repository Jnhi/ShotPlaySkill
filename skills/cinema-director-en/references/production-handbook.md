# Production Handbook (Line-Lite) — From Methodology to Rolling Camera

> The craft files teach you how to think; this handbook keeps you from crashing. It is the workable lite version of the full production line: follow it and you ship polished films. The industrial versions (per-model quirk library, 6-dimension QA scorer, blocking automation) are Pro.

---

## 1. Generation Red Lines (universal, cross-model)

Hold these eight lines on any video model and you dodge ~80% of failures:

1. **One camera move per shot** — "push in while trucking and panning" = guaranteed mush. Split into shots.
2. **5–15s per segment** — longer gets split; in short-drama pacing most shots run 1.5–4s.
3. **No lens numbers** — "85mm, f/2.8, ISO400" confuses models. Write the effect: "shallow depth of field, background melts, subject razor-sharp."
4. **Describe light in detail** — what the source is + where it comes from + which way it falls off (motivated light). The more specific the light, the less AI the frame.
5. **One shot, one beat, one change** — one emotional/action change per shot. "Calm → shocked → furious" = three shots.
6. **Dialogue budget** — one short sentence per 15s segment; always state the delivery ("steady voice, smiling softly").
7. **Speed words are dangerous** — "fast/rapid" triggers motion blur or frame skips; write speed through physics ("crosses in two strides", "sleeve whips past the lens").
8. **Negative prompts ≥ 5 items** — always include: the opposite aspect ratio, "background music, soundtrack"; add scene-specific ones (morphing, extra fingers, foot sliding, floating objects).

## 2. The Three De-AI Fixes (why frames look fake)

| Symptom | Cause | Fix |
|---|---|---|
| Subject pasted on background | overusing "blurred background", zero environment interaction | Every shot writes ≥1 interaction: boots kick up dust, sleeve brushes the table, shadow lands on the wall |
| Stiff, puppet-like motion | poses written without process | Write the process: not "raises hand" but "borrowing the turn's momentum, fingertips rise first" |
| Too clean, rendered look | air with no medium in it | Air kit: light (dust motes / god rays) + sound bed (ambience) + medium (mist, rain, steam, drifting ash) — pick 1–2 per scene |

## 3. Image-First & Character Consistency (the cure for face drift)

**If you can image-to-video, never text-to-video.** The flow:

1. **First frame first** — generate the shot's first frame as a still, approve it (composition / light / likeness), then feed it to I2V. A bad first frame cannot be rescued in video; the first frame's expression IS the shot's expression.
2. **Identity block, copied verbatim** — one fixed description block per character, pasted word-for-word into every prompt. No synonym swapping ("black tunic" must never become "dark robe").
3. **Reference-image face lock** — on models that take reference images, use the same character sheet image throughout; when using it, stop describing the face — write only shot size + action + wardrobe.
4. **First/last-frame continuity** — each segment's end-state declaration is the generation brief for the next segment's first frame; cross-segment action must resume from the exact same pose.
5. **Consistency clause** — end every [Character/Subject Setup] with: "keep facial structure, hairstyle and wardrobe unchanged; same character throughout; face clear, no morphing."

## 4. Ten Hard Rules of the Six-Block Format (all pass or no ship)

1. ≤800 words per segment prompt; all six [] blocks present, in order, no renaming/merging/inventing
2. One aspect ratio declared project-wide; negative prompts include the opposite ratio
3. [Core Style & Tone] must contain: cultural style + emotion + aesthetic school + immersive atmosphere + cinematic camera language + render-domain declaration + aspect ratio
4. [Visual Texture Parameters] must contain: materials + light (motivation + fall-off) + atmosphere + reference film
5. [Character/Subject Setup]: identity + expression + action + appearance per subject; crowds marked "no clear frontal close-ups"
6. [Shot-by-Shot Script] is a timeline (0-Xs per shot), scene master setup first; dialogue/SFX/ambience in parentheses at each shot's end
7. [Shot-by-Shot Script] ends with the ⚡ trio: size-alternation check / motion-match check / end-state declaration
8. [Technical & Output Specs]: 4K / 30fps / ratio / ≤15s / camera moves listed per shot
9. [Negative Prompts] ≥5 items, must include opposite ratio + "background music, soundtrack"
10. The whole prompt obeys §1 red lines (one move per shot / no lens numbers / detailed light)

**Segment-boundary four checks** (at shot-list stage): each segment ≤15s ✅ adjacent shot sizes alternate ✅ adjacent motion energy matches (motion cuts to motion, stillness to stillness) ✅ segment's last action = next segment's first action ✅

## 5. Pre-Delivery Checklist (six questions; any fail = redo)

```
□ 1. Same character? — recognizably one person across shots (identity block pasted verbatim?)
□ 2. Every light motivated? — each source answers "from where, falling off which way"
□ 3. Physics believable? — feet grounded (no sliding), contact shadows, cloth & hair have weight
□ 4. Environment alive? — interaction + air medium present (§2), not a green-screen paste
□ 5. Three sound tracks? — dialogue/SFX/ambience present, BGM banned in negatives
□ 6. Where's the poster frame? — at least one screenshot-worthy frame per scene; can't point to it = aesthetics undercooked
```

## 6. Minimal Workflow (one episode, zero to finished)

```
① Project setup: set render domain → 7-step style bible (copy example-style-bible.md)
   → motif & POV → medium mode grammar
② Per episode: think (13) → blocking diagram per scene (blocking-diagram.md, pass 5 checks)
   → shot list (pass 4 checks) → polish (10/11) → Six-Block prompts (pass 10 rules)
③ Generate: first frames per shot (§3) → approve stills → I2V per segment → §5 checklist
④ Failures: diagnose against §1 red lines and §2 fixes; change one thing, test one thing
⑤ Edit: assemble per the continuity bible (file 25); grade toward lower saturation,
   add fine grain to kill the rendered look
```

---
*Line-Lite v1.0 (EN) | This handbook = the generalized version of Pro modules 02 (model constraints) / 15 (first-frame anchoring) / 26 (QA scorer). Per-model quirk libraries, auto-regenerate scoring red lines, failure casebooks and the facial performance library are Pro.*
