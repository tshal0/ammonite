# Setup source and destination paths
$AppName = 'Ammonite'

$Src = './src/*'
$Dst = './build'

$WowInstallDir = 'C:\'
$WowDst = $WowInstallDir + $AppName

$TocFile = $AppName + '.toc'
$Build = $Dst + '/'
$TocPath = $Build + $TocFile
$BuildPath = $Build + '*'
# Exclude: gitignore, build
# Include: Ammonite.toc, init.lua, README, CHANGELOG, app/


try {
    # Clean target folder
    # Get-ChildItem -Path $Dst -Include *.* -File -Recurse | ForEach-Object { $_.Delete()}

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

    Copy-Item -Path $Src -Destination $Dst -Recurse -Force
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
    Copy-Item -Path $BuildPath -Destination $WowDst -Recurse -Force
}
catch {
    Write-Host $PSItem.Exception.Message -ForegroundColor RED
}
finally {
    $Error.Clear()
}


