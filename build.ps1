# Setup source and destination paths
$AppName = 'Ammonite'

$Src = './src'
$Dst = './build'
$BuildSrc = $Src + '/*'
$BuildDst = $Dst + '/*'

$WowInstallDir = 'C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\'
$WowDst = $WowInstallDir + $AppName

$TocFile = $AppName + '.toc'
$TocPath = $Dst + '/' + $TocFile

# BUILD 

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


##### Increment Build Number and Replace in Files #####

$Config = Get-Content config.json | ConvertFrom-Json

$Version = $Config.VERSION
$Build = $Config.BUILD
$Interface = $Config.INTERFACE
$script:Build++ 

$Version = $Version + '.' + $Build

Write-Host Build: $Version

$Config.BUILD = $Build
$Config | ConvertTo-Json | Out-File -FilePath config.json

$old = '{{VERSION}}'
$new = $Version

Get-ChildItem $Config.BUILD_DIR -recurse -include *.toc, *.lua | 
Select-Object -expand fullname |
ForEach-Object {
  (Get-Content $_) -replace $old, $new | Set-Content $_
}

$old = '{{INTERFACE}}'
$new = $Interface

Get-ChildItem $Config.BUILD_DIR -recurse -include *.toc | 
Select-Object -expand fullname |
ForEach-Object {
  (Get-Content $_) -replace $old, $new | Set-Content $_
}

## INSTALL IN LOCAL WOW ADDONS ##

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
