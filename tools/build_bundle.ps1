# build_bundle.ps1 — 把技能文件按流水线顺序合并为单文件全量合集
# 用法: powershell -File tools/build_bundle.ps1   (在仓库根目录运行)
# 产出: dist/超级导演系统_全量合集.md  (给 Kimi/Gemini 等长上下文AI整包投喂)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$ref  = Join-Path $root "skills\cinema-director\references"
$out  = Join-Path $root "dist\超级导演系统_全量合集.md"

# 流水线顺序:总纲 → 产线 → 立项 → 思维/调度/分镜 → 光影美学 → 节奏 → 三域 → 剪辑/打斗/声音/媒介/运镜 → 美学基础库
$files = @(
  (Join-Path $root "skills\cinema-director\SKILL.md"),
  (Join-Path $ref "90_实战手册_产线Lite.md"),
  (Join-Path $ref "91_示例圣经_美学七步法示范.md"),
  (Join-Path $ref "21_渲染域总开关_写实×动漫×3DCG.md"),
  (Join-Path $ref "13_导演思维_决策框架.md"),
  (Join-Path $ref "29_调度图圣经_文字版站位灯位机位图.md"),
  (Join-Path $ref "12_分镜大师_场面调度库.md"),
  (Join-Path $ref "10_光影圣经_照明语法库.md"),
  (Join-Path $ref "11_美学体系_风格构建方法.md"),
  (Join-Path $ref "20_叙事节奏引擎_情绪交响与人格魅力.md"),
  (Join-Path $ref "01_导演原则_永恒层.md"),
  (Join-Path $ref "03_声音系统_台词音效无BGM.md"),
  (Join-Path $ref "04_媒介模式_短剧.md"),
  (Join-Path $ref "05_媒介模式_电影.md"),
  (Join-Path $ref "06_媒介模式_电视剧.md"),
  (Join-Path $ref "08_高动态运镜库_机械臂级.md"),
  (Join-Path $ref "22_打斗系统_动作设计与打斗分镜.md"),
  (Join-Path $ref "23_动漫美学_赛璐璐光影与作画法则.md"),
  (Join-Path $ref "24_3DCG美学_渲染质感与虚拟摄影.md"),
  (Join-Path $ref "25_剪辑衔接与首尾帧圣经.md"),
  (Join-Path $ref "27_2D动漫导演动态演出库_v1.0.md")
)
# 美学基础库全部追加(按文件名排序)
$files += Get-ChildItem -Recurse -File (Join-Path $ref "美学基础库") -Filter *.md | Sort-Object FullName | ForEach-Object { $_.FullName }

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine("# 超级导演系统 · 全量合集(自动编译,勿手改;重编运行 tools/build_bundle.ps1)")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("> 给长上下文AI整包投喂用。阅读顺序=文件顺序=执行流水线。精简版见同目录《超级导演系统_单文件执行版.md》。")
[void]$sb.AppendLine("")

foreach ($f in $files) {
  if (-not (Test-Path $f)) { Write-Warning "缺文件: $f"; continue }
  $name = [System.IO.Path]::GetFileNameWithoutExtension($f)
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine("---")
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine("<!-- ======== 收录文件: $name ======== -->")
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine((Get-Content -Raw -Encoding UTF8 $f))
}

New-Item -ItemType Directory -Force (Split-Path $out) | Out-Null
[System.IO.File]::WriteAllText($out, $sb.ToString(), (New-Object System.Text.UTF8Encoding($false)))
$kb = [math]::Round((Get-Item $out).Length / 1KB)
Write-Host "已生成 $out ($kb KB, $($files.Count) 个文件)"
