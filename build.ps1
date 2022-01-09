# Setup source and destination paths
$AppName = 'Ammonite'
$Src = './src/*'
$Dst = './build'
$WowInstallDir = 'C:\'
$WowDst = $WowInstallDir + $AppName
$TocFile = $AppName + '.toc'

# Exclude: gitignore, build
# Include: app, config, Ammonite.toc, init.lua, README, CHANGELOG

# Clean target folder
Get-ChildItem -Path $Dst -Include *.* -File -Recurse | ForEach-Object { $_.Delete()}

# Copy src into build (or dest)
Copy-Item -Path $Src -Destination $Dst -Recurse -Force