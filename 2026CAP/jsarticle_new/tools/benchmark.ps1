[CmdletBinding()]
param(
  [string]$SourcePath = "main.typ",
  [int]$Runs = 5,
  [string]$OutputDirectory = $env:TEMP
)

if ($Runs -lt 1) {
  throw "Runs must be at least one."
}

$typst = (Get-Command typst -ErrorAction Stop).Source
$samples = @()

for ($index = 1; $index -le $Runs; $index += 1) {
  $output = Join-Path $OutputDirectory ("jsarticle-benchmark-{0}.pdf" -f $index)
  $watch = [Diagnostics.Stopwatch]::StartNew()
  & $typst compile --root . $SourcePath $output
  $watch.Stop()
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
  $samples += $watch.Elapsed.TotalSeconds
}

$ordered = @($samples | Sort-Object)
$middle = [int][Math]::Floor($ordered.Count / 2)
$median = if ($ordered.Count % 2) {
  $ordered[$middle]
} else {
  ($ordered[$middle - 1] + $ordered[$middle]) / 2
}

[pscustomobject]@{
  Source = $SourcePath
  Runs = $Runs
  MedianSeconds = [Math]::Round($median, 3)
  SamplesSeconds = ($samples | ForEach-Object { [Math]::Round($_, 3) }) -join ", "
} | Format-List
