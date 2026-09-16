[CmdletBinding()]
param(
  [ValidateSet('preview', 'check', 'apply')][string]$Mode = 'preview',
  [ValidateSet('unist', '수능수학')][string[]]$Targets = @('unist', '수능수학'),
  [string[]]$Files = @(),
  [switch]$AllowLocalChanges
)
$source = Split-Path $PSScriptRoot -Parent
$parent = Split-Path $source -Parent
$manifestFiles = (Get-Content -LiteralPath (Join-Path $source 'engine-files.json') -Raw | ConvertFrom-Json).files
foreach ($file in $Files) {
  if ($file -notin $manifestFiles) { throw "Not an engine-manifest file: $file" }
}
$selectedFiles = if ($Files.Count) { $Files } else { $manifestFiles }
$different = $false
foreach ($name in $Targets) {
  $target = Join-Path $parent $name
  if (-not (Test-Path -LiteralPath $target -PathType Container)) { throw "Missing consumer: $target" }
  if ($Mode -eq 'apply' -and -not (Test-Path -LiteralPath (Join-Path $target 'engine-local.typ'))) {
    throw "Missing engine-local.typ: $name. Define project preferences before applying this engine; never copy another project's profile."
  }
  $lockPath = Join-Path $target 'engine-lock.json'
  $previous = if (Test-Path -LiteralPath $lockPath) { Get-Content -LiteralPath $lockPath -Raw | ConvertFrom-Json -AsHashtable } else { @{} }
  $next = $previous.Clone()
  $changes = @()
  foreach ($file in $selectedFiles) {
    if ($file -match '(^[\\/]|\.\.|:)') { throw "Unsafe manifest path: $file" }
    $origin = Join-Path $source $file
    $destination = Join-Path $target $file
    $hash = (Get-FileHash -LiteralPath $origin).Hash
    $next[$file] = $hash
    $actual = if (Test-Path -LiteralPath $destination) { (Get-FileHash -LiteralPath $destination).Hash } else { $null }
    if ($hash -ne $actual) {
      if ($previous.ContainsKey($file) -and $actual -ne $previous[$file] -and -not $AllowLocalChanges) {
        throw "Consumer edit detected: $name/$file. Review it before using -AllowLocalChanges."
      }
      $changes += $file
    }
  }
  $changes | ForEach-Object { Write-Output "$name : $_" }
  if ($changes.Count) { $different = $true }
  if ($Mode -eq 'apply') {
    foreach ($file in $changes) {
      $destination = Join-Path $target $file
      New-Item -ItemType Directory -Force (Split-Path $destination -Parent) | Out-Null
      Copy-Item -LiteralPath (Join-Path $source $file) -Destination $destination
    }
    $next | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $lockPath
  }
  Write-Output "$name : $($changes.Count) differing engine files"
}
if ($Mode -eq 'check' -and $different) { exit 1 }
