# AI短剧导演工具库分层

Use this as the routing matrix.

## Fast Matrix

| Problem | Primary Skill | Pair With |
|---|---|---|
| 开头不抓人 | `wong-jing-commercial-hooks` | `ning-hao-black-comedy` |
| 喜剧不够 | `zhou-xingchi-director` | `ning-hao-black-comedy` |
| 太像AI / 人不真实 | `ang-lee-emotional-realism` | `johnnie-to-staging` |
| 人物站着说话 | `johnnie-to-staging` | `ang-lee-emotional-realism` |
| 画面没电影感 | `peter-pau-cinematography` | `zhang-yimou-visual-ritual` |
| 需要东方美学 | `peter-pau-cinematography` | `zhang-yimou-visual-ritual` |
| 需要都市情绪 | `wong-kar-wai-emotion` | `peter-pau-cinematography` |
| 需要奇观动作 | `tsui-hark-fantasy-action` | `peter-pau-cinematography` |
| 结构散 | `ning-hao-black-comedy` | `wong-jing-commercial-hooks` |
| 结尾不想追 | `wong-jing-commercial-hooks` | `johnnie-to-staging` |

## Default Packs

### 10分钟喜剧短片

1. `wong-jing-commercial-hooks`: first-minute hook and major reversals.
2. `zhou-xingchi-director`: small-person pain and visible comedy business.
3. `ning-hao-black-comedy`: causality and escalation.
4. Optional `peter-pau-cinematography`: cinematic image plan.

### 高质感AI影像

1. `peter-pau-cinematography`: light, frame, movement.
2. `zhang-yimou-visual-ritual`: color and symbolic image.
3. Optional `wong-kar-wai-emotion`: mood and time texture.

### 犯罪/压迫感场景

1. `johnnie-to-staging`: room geometry and power.
2. `ning-hao-black-comedy`: mistake and consequence.
3. Optional `ang-lee-emotional-realism`: human cost.

### 东方幻想动作

1. `tsui-hark-fantasy-action`: impossible rule and set piece.
2. `peter-pau-cinematography`: camera/light realism.
3. `ang-lee-emotional-realism`: inner conflict.

## Output Contract

When using this library, state:

```text
Used layers:
Why these layers:
Primary creative diagnosis:
Draft / plan / prompts:
Next best refinement:
```

Keep the layer list short. More than 3 skills in the first pass usually blurs taste.
