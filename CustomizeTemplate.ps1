param (
    [Parameter(Mandatory=$true)]
    [string]$NewDM
)

$Root = Get-Location
Write-Host "Customizing template for DM: $NewDM"

Get-ChildItem -Path $Root -Recurse -File -Filter "TemplateDM*" | ForEach-Object {
    $NewName = $_.Name -replace "TemplateDM", $NewDM
    Rename-Item -Path $_.FullName -NewName $NewName
    Write-Host "Renamed: $($_.FullName) -> $NewName"
}

$FilesToEdit = @(
    "settings.gradle.kts",
    "vo-dml/$NewDM-v1.vodml-binding.xml",
    "doc/std/$NewDM.tex",
    "doc/site/index.md"
)

foreach ($File in $FilesToEdit) {
    $FullPath = Join-Path $Root $File
    if (Test-Path $FullPath) {
        (Get-Content $FullPath) -replace "TemplateDM", $NewDM | Set-Content $FullPath
        Write-Host "Updated file: $FullPath"
    }
}

Write-Host "Done"
