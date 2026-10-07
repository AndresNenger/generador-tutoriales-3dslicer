# Genera la narración de un guion con una voz de Windows (System.Speech).
# Uso:  powershell -File tts_windows.ps1 -Proyecto ejemplo -Voz "Microsoft Helena Desktop"
# Lista las voces instaladas con:  powershell -File tts_windows.ps1 -ListarVoces
param([string]$Proyecto = ".", [string]$Voz = "Microsoft Helena Desktop", [int]$Velocidad = -1, [switch]$ListarVoces)
Add-Type -AssemblyName System.Speech
$s = New-Object System.Speech.Synthesis.SpeechSynthesizer
if ($ListarVoces) { $s.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo.Name + " | " + $_.VoiceInfo.Culture }; exit }
$g = Get-Content (Join-Path $Proyecto "guion.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$out = Join-Path $Proyecto "voz"; New-Item -ItemType Directory -Force $out | Out-Null
$s.SelectVoice($Voz); $s.Rate = $Velocidad; $s.Volume = 100
$items = @(); foreach ($st in $g.steps) { $items += [pscustomobject]@{n = $st.name; t = $st.voz} }
$items += [pscustomobject]@{n = "intro"; t = $g.extra.intro}; $items += [pscustomobject]@{n = "outro"; t = $g.extra.outro}
foreach ($i in $items) { $s.SetOutputToWaveFile((Join-Path $out ($i.n + ".wav"))); $s.Speak($i.t) }
$s.SetOutputToNull(); $s.Dispose()
Write-Host ("Generados " + $items.Count + " archivos en " + $out)
