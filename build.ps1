# Setup source and destination paths
$AppName = 'Ammonite'

$Src = './src'
$Dst = './build'
$BuildSrc = $Src + '/*'
$BuildDst = $Dst + '/*'

$WowInstallDir = 'C:\'
$WowDst = $WowInstallDir + $AppName

$TocFile = $AppName + '.toc'
$Build = $Dst + '/'
$TocPath = $Build + $TocFile
# Exclude: gitignore, build
# Include: Ammonite.toc, init.lua, README, CHANGELOG, app/


try {
    # Clean target folder
    $exists = Test-Path $Dst
    if ( $exists) {
        $CleanDst = $Dst + '/*'
        Remove-Item -Recurse -Force $CleanDst
    }
    # Copy README, CHANGELOG
    $filter = [regex] ".*(README|CHANGELOG)"
    $bin = Get-ChildItem -Path '.' | Where-Object { $_.Name -match $filter }
    foreach ($item in $bin) {
        Copy-Item -Path $item.FullName -Destination $Dst
    }
    # Copy src into build (or dest)

    Copy-Item -Path $BuildSrc -Destination $Dst -Recurse -Force
}
catch {
    Write-Host $PSItem.Exception.Message -ForegroundColor RED
}
finally {
    $Error.Clear()
}


try {
    # Clean target wow install folder
    $exists = Test-Path $WowDst
    if ( $exists) {
        $CleanWowDst = $WowDst + '/*'
        Remove-Item -Recurse -Force $CleanWowDst
    }
    else {
        New-Item -ItemType "directory" -Path $WowDst
    }

    # Install the TOC file

    Copy-Item -Path $TocPath  -Destination $WowDst -Recurse -Force
    # Copy src into build (or dest)
    Copy-Item -Path $BuildDst -Destination $WowDst -Recurse -Force
}
catch {
    Write-Host $PSItem.Exception.Message -ForegroundColor RED
}
finally {
    $Error.Clear()
}


