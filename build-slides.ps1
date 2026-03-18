$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $root "docs/digital_case_study_workshop_slides.md"
$htmlOut = Join-Path $root "docs/index.html"
$pdfOut = Join-Path $root "docs/digital_case_study_workshop_slides.pdf"

if (-not (Test-Path $source)) {
  throw "Source markdown not found: $source"
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
  throw "Docker CLI not found. Install Docker Desktop and try again."
}

docker info *> $null
if ($LASTEXITCODE -ne 0) {
  throw "Docker engine is not running. Start Docker Desktop and try again."
}

Write-Host "Building HTML..."
docker run --rm -v "${root}:/work" -w /work marpteam/marp-cli docs/digital_case_study_workshop_slides.md -o docs/index.html

Write-Host "Building PDF..."
docker run --rm -v "${root}:/work" -w /work marpteam/marp-cli --pdf docs/digital_case_study_workshop_slides.md -o docs/digital_case_study_workshop_slides.pdf

Write-Host ""
Write-Host "Done:"
Write-Host " - $htmlOut"
Write-Host " - $pdfOut"
