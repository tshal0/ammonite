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