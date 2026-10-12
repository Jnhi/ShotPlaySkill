# Seedance 2.0 → 2.5 适配分析

> 生成日期：2026-10-10 ｜ 状态：**纯分析，不含改动**。
> 所有 2.5 事实来自 ByteDance 官方文档（ModelArk prompt guide、Lumina 发布页、Seed 官方博客）和 Prompt Architects 独立实测。

---

## 一、当前项目为 Seedance 2.0 设计的硬编码点

在动手之前先搞清楚：**本项目到底在哪些地方假设了"Seedance 2.0 是唯一目标模型"**。这些假设散落在 7 个文件里，共影响约 25 处硬规则/模板参数：

| 假设 | 写死在哪里 | 具体内容 |
|---|---|---|
| ① 最长 15 秒 | SKILL.md§四、90§四硬性规则8、90分段四检、20§三铁律1、05电影模式§一AI现实、08运镜库§六重炮段落公式 | `每段≤15s` / `4-15s` / `≤15秒` 反复出现 |
| ② 4K 输出 | SKILL.md§四【技术与输出参数】模板、90§四硬性规则8 | 模板直接写 `4K,30fps` |
| ③ 时间戳只作视觉参考 | SKILL.md§四镜头模板时间码格式 | 用 `00.0—03.0秒` 但没加 `Shot N:` 标签（2.0 会忽略纯时间戳） |
| ④ 单模态参考 | 00c平台适配行、90§三角色一致性、全项目"图先行"工作流 | 只覆盖"首帧图锁脸"，完全不提视频/音频/白模/故事板参考 |
| ⑤ 后期拼接实现长镜头 | 05电影模式§五AI现实、08运镜库§九QA | 电影感=多段缓慢运镜拼接，这是因为 2.0 无法原生延长 |
| ⑥ 音频靠负面词压 | 90§四硬性规则9、SKILL.md铁律④、固定头【绝对指令】 | `负面词必含背景音乐、配乐`（2.0 和 2.5 的 `generate_audio` 默认都是 true） |
| ⑦ 六段式=最终形态 | SKILL.md§四全节、00c平台适配行 | 项目提示词是结构化六大板块；Seedance 官方 2.5 prompt 公式是 prose（summary + timeline + persistent parameters） |
| ⑧ 参考资产数量不关心 | 全项目 | 2.0 上限 15（9 图+3 视频+3 音频），2.5 上限 50（30+10+10），项目完全没提这个限制 |

---

## 二、Seedance 2.0 vs 2.5 差异对照表

以下是官方文档明确标注的差异（**不是社区传闻**）：

| 维度 | Seedance 2.0 | Seedance 2.5 | 来源 |
|---|---|---|---|
| 单次生成时长 | 4–15 秒 | 4–30 秒 | ModelArk prompt guide |
| 参考资产上限 | 15 件（9 图 + 3 视频 + 3 音频） | **50 件**（30 图 + 10 视频 + 10 音频） | 官方 7.31 发布文 |
| 分辨率上限 | **原生 4K**、1080p、720p、480p | 1080p、720p、480p（**2.5 没有 4K**） | ModelArk capability table |
| 输出格式 | mp4 | mp4 + **mov**（延长/编辑推荐 mov） | ModelArk |
| 时间戳识别 | **忽略**，只认 `Shot 1:`、`Shot 2:` 编号 | **支持**整数秒时间戳，两种格式都行 | ByteDance 明确标注 |
| 多视角人物参考 | 不推荐 | **支持**（multi-view images 作 subject reference） | ModelArk 差异项 |
| 画幅比 | 6 种固定（16:9/4:3/1:1/3:4/9:16） | **任意 [0.4, 2.5] 宽高比**（由输入资产自适应） | ModelArk 差异项 |
| 区域级编辑 | 无 | **有**——时间戳级精确编辑、绿幕编辑、视角编辑、参考编辑 | 官方发布文 |
| 多轮延长 | 无原生延长（只能重生成） | **有**——extend forward / extend backward，保持音画连贯 | 官方发布文 |
| 3D 白模参考 | 无 | **有**——粗颗粒/细颗粒白模视频作运动参考，渲染成目标风格 | ModelArk capability table |
| 故事板参考 | 无 | **有**——多格故事板输入（≤15 格），建议简笔线稿 | ModelArk |
| 关键帧参考 | 无 | **有**——多帧严格对齐（比首尾帧更严格） | ModelArk |
| 音频默认 | 开（generate_audio=true） | 开（generate_audio=true）——**两版本一致** | ModelArk |
| 多语言提示 | zh/en + 4 种额外 | zh/en + **9 种额外** | ModelArk |
| 输出质量 | "油腻感"明显 | 大幅优化，弱化油腻感 | 官方发布文 |

> **关键发现**：4K 是 2.0 独有的，2.5 降级到 1080p。这意味着"2.5 是更好的版本，但不是 2.0 的超集"——4K 和 15s 上限是 2.0 的优势，而 30s / 50 参考 / 区域编辑 / 白模参考 是 2.5 独有的。选择哪个模型取决于你的交付规格（要 4K→2.0；要 30 秒叙事→2.5）。

---

## 三、硬冲突（必须改，不改会直接降低交付质量）

### ⛔ 冲突 1：`4K` 硬编码是错的

- **现状**：SKILL.md§四【技术与输出参数】模板直接写 `4K,30fps`；90§四硬性规则 8 写 `4K/30fps/画幅/时长≤15s`。
- **问题**：2.5 最高 1080p。如果用户拿 2.5 跑，prompt 里写 `4K` 等于废话（模型忽略，API 会报错或自动降档）。反过来，如果用户确实要 4K，**必须用 2.0**——但项目里完全没告诉用户这件事。
- **2.0 vs 2.5 选择矩阵**（项目当前缺失）：

| 需求 | 用哪个模型 |
|---|---|
| 交付规格要求 4K | Seedance 2.0 |
| 单段 ≤30s 连续叙事 | Seedance 2.5 |
| 多模态参考（视频/音频/白模） | Seedance 2.5 |
| 区域级编辑 / 延长 | Seedance 2.5 |
| 15s 内 + 只要 4K | Seedance 2.0 或 2.5 都行，但 4K 选 2.0 |

### ⛔ 冲突 2：`≤15s` 硬限制浪费了 2.5 的 30s 能力

- **现状**：项目把"每段≤15s"当成所有模型的硬纪律，分布在 7 个文件约 12 处。
- **问题**：如果用 2.5，15s 限制是保守得没必要。30s 意味着一段内可以完整放下"铺垫→推进→转折→收尾"的完整叙事弧，减少拼接、提升连贯性。
- **但 15s 纪律有它的理由**：不是 2.0 的限制，是 90 实战手册基于"完播率/划走点"数据定的。30s 在短剧场景里可能变成"容易划走的长段"。所以这不是简单的"改成 ≤30s"，而是**按场景（广告 vs 短剧 vs 电影预拍）给不同的段落预算**。

### ⛔ 冲突 3：时间戳格式在 2.0 上被忽略

- **现状**：项目六段式用 `00.0—03.0秒` 格式标记每镜时间范围。
- **2.0 问题**：2.0 **完全忽略**时间戳，只认 `Shot 1:` / `Shot 2:` 这样的编号。所以如果你用 2.0 跑，项目里写的 `00.0—03.0秒` 等于白写——模型按出现顺序排列事件，时间戳不影响。
- **2.5 则没问题**：2.5 原生支持整数秒时间戳，且能响应。
- **行动**：要么在 2.0 模式下自动在每镜前加 `Shot N:` 编号；要么在提示词交付物里根据目标模型生成不同时间标记。

### ⛔ 冲突 4：音频默认开着，而项目靠负面词压 BGM

- **现状**：项目铁律④（默认无音乐）+ 固定头【绝对指令】（禁止生成 BGM）+ 90 硬性规则 9（负面词必含背景音乐、配乐）三重保险。
- **问题**：2.0 和 2.5 的 `generate_audio` 默认都是 true。这意味着**即使你写了"禁止BGM"，模型仍然会生成音效/环境声**——这其实是好事（对白+环境声是有情绪的），项目自己也说过"用呼吸/心跳替代 BGM 做悬念"。
- **真实问题**：不是"模型会不会生成声音"，而是"你希望生成哪种声音"。Seedance 2.5 有官方推荐的音频标记语法：

| 标记 | 含义 | 示例 |
|---|---|---|
| `(...)` | 音乐（BGM） | `(subtle piano music plays in the background)` |
| `<...>` | 音效 | `<a chair scrapes across the floor>` |
| `{...}` | 对话 | `{You shouldn't be here.}` |
| `【...】` | 字幕 | `【Chapter One】` |

- **当前项目**：台词用"台词：原话全文"、音效用"6.音效：xxx"行内描述——不是 Seedance 原生语法。改成官方括号标记，模型对音频的控制力会更精准（特别是在多轮延长时音画连贯性更稳）。

---

## 四、架构机会（可以做，价值大，但不紧急）

### 💡 机会 1：多模态参考系统 = 角色/场景一致性的彻底升级

- **现状**：项目用"身份描述块逐字复用 + 参考图锁脸"（90§三）。这是 2.0 时代的做法。
- **2.5 能做的事**（项目完全没覆盖）：

| 参考类型 | 2.5 能力 | 项目可以怎么用 |
|---|---|---|
| Subject image reference（多图锁脸） | 1–8 张图锁同角色，支持多视角 | 用角色定妆照 + 不同表情/角度图，**一次锁定全剧** |
| Subject audio/video reference | 角色声音片段或表演视频 | 上传参考视频里"那个人说话的方式/走路的样子"，模型会自动匹配 |
| Motion reference（视频） | 动作/运镜/特效视频作运动参考 | 想用某电影里的运镜？上传片段说"按 @Video1 的运动" |
| 3D 白模参考（视频） | 粗/细颗粒白模视频作运动参考，渲染成目标风格 | 复杂打斗/舞蹈场景，先做白模动画，再喂给模型生成实拍版 |
| Style reference（图/视频） | 视觉风格参考 | 把品牌色彩方案、参考电影片段喂进去 |
| Storyboard reference（多格图） | ≤15 格简笔故事板，模型按高层 plot 参考 | 美术先画故事板草稿，模型自动生成镜头 |
| Keyframe reference（多图） | 多帧严格对齐 | 想精确控制某几个关键帧（比如"第 3 秒他必须刚好抬头"） |

- **@资产绑定语法**（2.5 必需，项目当前没有）：
  - `@Image 1` / `@Video 1` / `@Audio 1`（按上传顺序从 1 开始，**同类型独立计数**）
  - `@Image 1 是 Adrian 的定妆照`——必须在 prompt 里**明确声明每个资产的用途**，否则模型不知道怎么用
  - 参考 ByteDance 官方模板：
    ```
    参考声明段:
    Images 1-2 are Character 1 (Adrian); Images 3-4 are Character 2 (Luca).
    Audio 1 is Adrian's voice reference; Audio 2 is Luca's voice reference.
    Video 1 is the camera movement reference (slow push-in with slight handheld).
    
    0-30秒: ...... (时间线)
    ```

### 💡 机会 2：原生延长 vs 后期拼接

- **现状**：电影感长镜头 = "多段缓慢运镜拼接"（05电影模式§五AI现实）。
- **2.5 能做**：`extend forward` / `extend backward` 指令，在已生成视频上无缝延长，保持音画连贯。
- **行动**：在 05 电影模式里加一节"2.5 原生延长策略"——比如先用 15s 模板出一段，然后 extend 到 30s，中间不用后期拼接。

### 💡 机会 3：区域级编辑 = 低成本修复工作流

- **现状**：某镜翻车 = 整条重生成。
- **2.5 能做**：时间戳级精确编辑（改某秒的某物体、换某区域的颜色/灯光/材质）+ 绿幕编辑 + 视角编辑 + 参考编辑。
- **行动**：在 90 实战手册里加"2.5 编辑工作流"一节——翻车时先尝试区域编辑，再考虑重生成。

### 💡 机会 4：故事板参考 + 多模态首帧策略

- **现状**：90§三只说"图先行"——先出首帧图，再图生视频。
- **2.5 有 6 种首帧策略**，项目只覆盖了其中 1 种（普通首帧图）：

| 策略 | 2.5 API 参数 | 项目当前覆盖？ |
|---|---|---|
| 普通参考图（图生视频） | content.role = reference_image | ✅ 是 |
| First-frame（首帧严格） | content.role = first_frame | ❌ 否 |
| First-and-last-frame（首尾帧约束） | content.role = first_frame / last_frame | ❌ 否 |
| Multiple keyframes（多关键帧严格对齐） | 多图 + content.role = first_frame | ❌ 否 |
| 故事板参考（高层 plot 参考） | 多格故事板作为 reference_image | ❌ 否 |
| 3D 白模参考 | 白模视频作 motion reference | ❌ 否 |

---

## 五、次要文案更新（不急，但必须改）

| 位置 | 当前内容 | 建议改成 | 理由 |
|---|---|---|---|
| 00c§六平台适配 | `Seedance(视频) \| 吃时间码分镜+镜头动词;七层提示词` | 拆成 **Seedance 2.0** 和 **Seedance 2.5** 两行。2.5 行写：支持整数秒时间戳 + Shot N，500 汉字/1000 词上限，6 步公式，原生音频用 `{}` 对话/`<>` 音效/`()` 音乐标记，多模态参考 `@Image N/@Video N/@Audio N` | 不拆会误导用户 |
| 00c 平台适配行 | ``camera_fixed`/`return_last_frame`(2.5)` | 确认这两个 token 是否是 Seedance 原生参数还是项目自定义（ByteDance 官方 prompt guide 没提这两个词）。如果是项目自定义，标注清楚；如果是别的平台参数，删除 | 避免误导 |
| README 工作流程图 | `每段≤15s` | 改为 `每段 ≤15s(2.0) / ≤30s(2.5)` | 流程图已经开始过时 |
| README 提示词示例 | 旧六段式示例 | 保留旧格式 + 标注"2.0 模式"，再加一个 2.5 prose 格式示例（summary + 时间戳 timeline + 收尾 persistent parameters） | 两个版本共存 |
| SKILL.md§四【技术与输出参数】模板 | `4K,30fps,[画幅],时长(≤15s)` | 改为 `[4K(2.0) / 1080p(2.5)], 30fps, [画幅], 时长(≤15s·2.0 / ≤30s·2.5)` | 硬错误必须修 |
| 08 运镜库重炮段落公式 | `≤15s段落级` | 增加 2.5 版"≤30s 完整叙事弧"重炮公式 | 机会 |
| 全项目"无 BGM 负面词必含" | 作为通用规则 | 改为 2.5 模式下"用 `(...)` 音乐标记主动声明需要/不需要"——比负面词更精准 | 2.5 原生音频控制更强 |
| 单文件执行版 | 未标注 Seedance 版本 | 顶部加"v1.0 基于 Seedance 2.0 设计，2026-10-10 起需升级到 v1.1 适配 2.5" | 用户会困惑 |

---

## 六、文件级改动清单（按优先级排序）

### 🔴 高优先级（硬冲突，不改会误导用户）

| # | 文件 | 改什么 | 工作量 |
|---|---|---|---|
| 1 | [SKILL.md§四](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/SKILL.md) | 【技术与输出参数】模板把 `4K` 改成 `[4K(2.0) / 1080p(2.5)]`，时长模板把 `≤15s` 改成 `≤15s·2.0 / ≤30s·2.5` | 1 处 |
| 2 | [SKILL.md§四](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/SKILL.md) | 加"模型选择矩阵"一节（2.0 vs 2.5，按交付规格） | 新节 |
| 3 | [SKILL.md§四](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/SKILL.md) | 镜头模板时间码在 2.0 模式下自动加 `Shot N:` 编号 | 逻辑说明 |
| 4 | [90 实战手册§四硬性规则 8](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/90_实战手册_产线Lite.md) | `4K/30fps` → 同 SKILL.md；`≤15s` → 2.0/2.5 分 | 1 处 |
| 5 | [90 分段四检](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/90_实战手册_产线Lite.md) | `每段累计≤15s` → 2.0/2.5 分 | 1 处 |
| 6 | [00c 平台适配](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/美学基础库/00c_提示词写法规范.md) | Seedance 拆 2.0/2.5 两行 | 1 行 |

### 🟡 中优先级（架构升级，价值大）

| # | 文件 | 改什么 | 工作量 |
|---|---|---|---|
| 7 | 90§三 角色一致性 | 加 2.5 多模态参考工作流（Subject image/audio/video reference + @资产绑定） | 新节 |
| 8 | 新增一个 **Seedance 2.5 参考系统专用文件**（或并入 90） | 覆盖 6 种参考类型 + @语法 + 官方音频标记 + 延长/编辑工作流 | 新文件 |
| 9 | [05 电影模式](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/05_媒介模式_电影.md) | 加"2.5 原生延长策略"一节 | 新节 |
| 10 | [08 运镜库](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/08_运镜库_全情绪运镜圣经.md) | §六重炮段落公式增加 2.5 版 ≤30s 完整叙事弧 | 新公式 |
| 11 | [20 节奏引擎铁律 1](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/20_叙事节奏引擎_情绪交响与人格魅力.md) | `生成P段≤15s` → 2.0/2.5 分 | 1 行 |
| 12 | 单文件执行版 阶段 4 | 模型选择矩阵 + 4K/1080p 分离 + 15/30s 分离 | 多段 |

### 🟢 低优先级（文案/注释，不急）

| # | 文件 | 改什么 |
|---|---|---|
| 13 | [README.md](file:///Users/joe/Documents/GitHub/ShotPlaySkill/README.md) | 流程图 `≤15s` → 2.0/2.5 分；提示词示例更新 |
| 14 | [README.md 英文](file:///Users/joe/Documents/GitHub/ShotPlaySkill/README.md) | 同上英文版 |
| 15 | 所有 references 里散落的 `≤15s` | 逐个评估是改 2.0/2.5 分还是保留（有些是短剧完播率数据，不是模型限制） |
| 16 | [00c 平台适配行](file:///Users/joe/Documents/GitHub/ShotPlaySkill/skills/cinema-director/references/美学基础库/00c_提示词写法规范.md) | `camera_fixed`/`return_last_frame` 确认性质后决定留/删/改 |
| 17 | 编译脚本 | build_bundle.ps1 不动；但如果后续要新增 2.5 专用文件，更新 CRAFT_NAMES |

---

## 七、参考来源（全部公开可验证）

| 来源 | URL | 权威性 |
|---|---|---|
| ByteDance ModelArk Seedance 2.5 prompt guide | https://docs.byteplus.com/en/docs/ModelArk/2607689 | ★★★★★ 官方 API 文档 |
| ByteDance Lumina 发布页 | https://ai.byteplus.com/lumina/zh/resource/seedance-2-5-release-date | ★★★★★ 官方发布 |
| Seed 官方博客"一镜成片，随心参考" | https://seed.bytedance.com/zh/blog/ | ★★★★★ 官方博客 |
| Prompt Architects 深度分析（21 文） | https://prompt-architects.com/blog/216-how-to-prompt-seedance-2-0 | ★★★★☆ 独立实测 |
| Seedance2Pro 功能对照 | https://www.seedance2pro.net/seedance/seedance-2-5 | ★★★☆☆ 第三方平台 |

---

## 八、行动建议（不执行，仅规划）

**Phase 1（紧急，1 轮）**：修复硬冲突——4K/1080p 分离、15/30s 分离、加模型选择矩阵、时间戳兼容 2.0。影响 SKILL.md + 90 + 00c，约 8 处改动。

**Phase 2（中等，2 轮）**：新增 Seedance 2.5 专用文件——多模态参考系统、@资产语法、官方音频标记、延长/编辑工作流。这是 2.5 最大的架构红利。

**Phase 3（收尾，1 轮）**：README 更新、单文件执行版重编、编译脚本同步、全 references 散落 ≤15s 评估。

**不建议的做法**：
- 不要直接把全项目 `≤15s` 改成 `≤30s`——很多 15s 限制来自短剧完播率数据，不是 2.0 的模型限制。30s 只适合广告/电影预拍/特定场景。
- 不要删掉 2.0 适配——4K 是 2.0 独有的，项目必须同时支持两个模型。
- 不要改 build_bundle.ps1 也不要新建 .py——当前 PowerShell 脚本在 Windows 环境正常工作，之前只是因为这台 Mac 上没有 PowerShell 才临时用了 Python。
