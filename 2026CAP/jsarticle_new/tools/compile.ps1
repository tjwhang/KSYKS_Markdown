[CmdletBinding()]
param(
  [Alias("Input")]
  [string]$SourcePath = "main.typ",
  [Alias("Output")]
  [string]$OutputPath = "main.pdf",
  [string[]]$FontPath = @(),
  [switch]$CuratedFonts,
  [string[]]$RequiredFont = @(
    "Minion Pro",
    "KoPubWorldBatang_Pro",
    "KoPubWorldDotum_Pro",
    "Source Han Serif K",
    "Source Han Sans K",
    "Source Han Serif SC",
    "Source Han Sans SC",
    "Source Han Serif HC",
    "Source Han Sans HC",
    "Hiragino Mincho ProN",
    "Hiragino Kaku Gothic ProN",
    "Song Myung",
    "New Computer Modern Math",
    "Garamond-Math"
  )
)

$typst = (Get-Command typst -ErrorAction Stop).Source
$useCurated = $CuratedFonts -or $FontPath.Count -gt 0
$fontArgs = @()

if ($useCurated) {
  $validPaths = @($FontPath | Where-Object { Test-Path -LiteralPath $_ -PathType Container })
  if ($validPaths.Count -ne $FontPath.Count -or $validPaths.Count -eq 0) {
    Write-Warning "Curated font paths are incomplete; falling back to normal system font discovery."
    $useCurated = $false
  } else {
    foreach ($path in $validPaths) { $fontArgs += @("--font-path", $path) }
    $catalog = & $typst fonts --ignore-system-fonts @fontArgs | Out-String
    $missing = @($RequiredFont | Where-Object {
      $catalog -notmatch [regex]::Escape($_)
    })
    if ($missing.Count -gt 0) {
      Write-Warning (
        "Curated fonts are missing: " + ($missing -join ", ") +
          ". Falling back to normal system font discovery."
      )
      $useCurated = $false
    }
  }
}

$compileArgs = @("compile", "--root", ".")
if ($useCurated) {
  $compileArgs += "--ignore-system-fonts"
  $compileArgs += $fontArgs
}
$compileArgs += @($SourcePath, $OutputPath)

& $typst @compileArgs
exit $LASTEXITCODE
