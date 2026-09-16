[CmdletBinding()]
param([string]$OutputDirectory = (Join-Path $env:TEMP 'jsarticle-check'))
$root = Split-Path $PSScriptRoot -Parent
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
$expected = @{
  'v2-invalid-options' = 'options.page.colz'
  'v2-invalid-basho' = 'config.layout.colums'
}
$failures = @()
foreach ($test in Get-ChildItem (Join-Path $root 'tests') -Filter '*.typ') {
  $diagnostic = & typst compile --root $root $test.FullName (Join-Path $OutputDirectory ($test.BaseName + '.pdf')) 2>&1 | Out-String
  $code = $LASTEXITCODE
  $passed = if ($expected.ContainsKey($test.BaseName)) {
    $code -ne 0 -and $diagnostic.Contains($expected[$test.BaseName])
  } else { $code -eq 0 }
  if ($passed) { Write-Output "PASS $($test.BaseName)" } else {
    $failures += $test.BaseName
    Write-Output "FAIL $($test.BaseName): $diagnostic"
  }
}
if ($failures.Count) { exit 1 }
