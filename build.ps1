# ====================================================================
# G&D Live Compat Fix - Portable Build Script
# Compatible with Windows, Linux, and macOS (PowerShell Core / Windows PowerShell)
# ====================================================================

$projectDir = $PSScriptRoot.Replace('\', '/')
$srcDir     = "$projectDir/src/main/java"
$resDir     = "$projectDir/src/main/resources"
$libsDir    = "$projectDir/libs"
$buildDir   = "$projectDir/build/classes"
$jarOut     = "$projectDir/build/gnd-compat-fix-1.21.1-1.0.0.jar"

# 1. Clean & Prepare Build Directory
if (Test-Path $buildDir) {
    Remove-Item -Recurse -Force $buildDir
}
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path $jarOut) -Force | Out-Null

# 2. Collect Compile Classpath from Project 'libs'
if (-not (Test-Path $libsDir)) {
    Write-Error "The 'libs' directory was not found. Please ensure dependencies are placed in $libsDir"
    exit 1
}

$jars = (Get-ChildItem -Path $libsDir -Filter '*.jar' -Recurse | ForEach-Object { $_.FullName.Replace('\', '/') })
if ($jars.Count -eq 0) {
    Write-Error "No library jars found in $libsDir"
    exit 1
}
$cp = $jars -join ';'

# 3. Find Java Source Files
$javaFiles = (Get-ChildItem -Path $srcDir -Filter '*.java' -Recurse | ForEach-Object { $_.FullName.Replace('\', '/') })
if ($javaFiles.Count -eq 0) {
    Write-Error "No Java source files found in $srcDir"
    exit 1
}

# 4. Write Arguments File for Javac (Cross-Platform Safe)
$argFile = "$projectDir/build/javac_args.txt"
$argLines = @(
    "-proc:none",
    "-cp",
    "`"$cp`"",
    "-d",
    "`"$buildDir`""
)
$argLines += $javaFiles | ForEach-Object { "`"$_`"" }
[System.IO.File]::WriteAllLines($argFile, $argLines)

# 5. Compile
Write-Host "Compiling Java sources..." -ForegroundColor Cyan
& javac "@$argFile"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Compilation failed with exit code $LASTEXITCODE"
    exit 1
}

# 6. Copy Resources
Write-Host "Packaging resources and Mixin configs..." -ForegroundColor Cyan
if (Test-Path $resDir) {
    Copy-Item -Path "$resDir/*" -Destination $buildDir -Recurse -Force
}

# 7. Package Jar
Write-Host "Creating mod jar: $jarOut" -ForegroundColor Cyan
Push-Location $buildDir
& jar cvf $jarOut *
Pop-Location

if (-not (Test-Path $jarOut)) {
    Write-Error "Jar packaging failed!"
    exit 1
}

Write-Host "`nSuccessfully built:" -ForegroundColor Green
Write-Host "  -> $jarOut" -ForegroundColor Green

# 8. Optional Deployment (reads from deploy_targets.txt if present)
$deployConfig = "$projectDir/deploy_targets.txt"
if (Test-Path $deployConfig) {
    Write-Host "`nDeploying to targets defined in deploy_targets.txt..." -ForegroundColor Yellow
    $targets = Get-Content $deployConfig | Where-Object { $_.Trim() -ne '' -and -not $_.StartsWith('#') }
    foreach ($target in $targets) {
        $trimmed = $target.Trim()
        $destParent = Split-Path $trimmed
        if (Test-Path $destParent) {
            Copy-Item -Path $jarOut -Destination $trimmed -Force
            Write-Host "  [OK] Deployed to: $trimmed" -ForegroundColor Green
        } else {
            Write-Host "  [SKIP] Destination directory not found: $destParent" -ForegroundColor DarkGray
        }
    }
}

Write-Host "`n=== BUILD COMPLETE ===" -ForegroundColor Green
