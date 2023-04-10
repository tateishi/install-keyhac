function Confirm($title, $message="") {
    $CollectionType = [System.Management.Automation.Host.ChoiceDescription]
    $ChoiceType = "System.Collections.ObjectModel.Collection"

    $descriptions = New-Object "$ChoiceType``1[$CollectionType]"
    $questions = (("&Yes", "実行します"), ("&No", "実行しません"))
    $questions | %{$descriptions.Add((New-Object $CollectionType $_))}

    $answer = $host.UI.PromptForChoice($title, $message, $descriptions, 1)

    return $answer
}

function Expand-KeyHac($dir, $file) {
    if (Test-Path $dir) {
        Remove-Item $dir -Recurse
    }
    Expand-Archive $file
}

function Copy-KeyHac($src, $dest) {
    if (Test-Path $dest) {
        Remove-Item $dest -Recurse
    }

    Copy-Item $src -Destination $dest -Recurse
}

function Initialize-Archive {
    $url = "https://crftwr.github.io/keyhac/download/keyhac_182.zip"
    $temp = Join-Path $env:TEMP "Keyhac"
    $archive_file = "keyhac_182.zip"
    $archive_dir = Join-Path $temp "keyhac_182"

    if (-Not(Test-Path $temp)) {
        New-Item $temp -ItemType Directory > $null
    }

    Push-Location $temp

    Invoke-WebRequest $url -OutFile $archive_file
    Expand-KeyHac $archive_dir $archive_file

    Pop-Location
}

function Install-KeyHac {
    $temp = Join-Path $env:TEMP keyhac
    $dest = Join-Path $env:LOCALAPPDATA "Keyhac"
    $src = Join-Path $temp "keyhac_182" | Join-Path -ChildPath "Keyhac"

    Push-Location $temp

    Copy-KeyHac $src $dest

    Pop-Location
}

function Remove-Archive {
    Push-Location $env:TEMP

    if (Test-Path "Keyhac") {
        Remove-Item "Keyhac" -Recurse
    }

    Pop-Location
}

function Initialize-ConfigDir {
    $location = Join-Path $env:USERPROFILE "wks"
    $config_dir = "MyConfigs"

    Push-Location $location
    if (-Not(Test-Path $config_dir)) {
        New-Item $config_dir -ItemType Directory > $null
    }
    Pop-Location
}

function Clone-Repository {
    $location = Join-Path $env:USERPROFILE "wks" | Join-Path -ChildPath "MyConfigs"
    $repo = "https://github.com/tateishi/keyhac-config"
    $repo_dir = "keyhac-config"

    Push-Location $location
    if (Test-Path $repo_dir) {
        Push-Location $repo_dir
        git pull
        Pop-Location
    } else {
        git clone $repo
    }
    Pop-Location
}

function Copy-Config {
    $location = Join-Path $env:USERPROFILE "wks" | Join-Path -ChildPath "MyConfigs"
    $repo_dir = Join-Path $location "keyhac-config"

    $dest = Join-Path $env:APPDATA "Keyhac"

    if (-Not(Test-Path $dest)) {
        New-Item $dest -ItemType Directory > $null
    }

    Push-Location $repo_dir
    Copy-Item config.py $dest
    Pop-Location
}

function Add-Startup {
    $wsh = New-Object -ComObject Wscript.Shell
    $path = Join-Path $wsh.SpecialFolders("Startup") "Keyhac.lnk"
    $target = Join-Path $env:LOCALAPPDATA "Keyhac" | Join-Path -ChildPath "keyhac.exe"

    $shortcut = $wsh.CreateShortcut($path)
    $shortcut.TargetPath = $target
    $shortcut.save()
}


$ans = Confirm("実行確認")
if ($ans -eq 1) {
    Exit 1
}

Initialize-Archive
Install-KeyHac
Remove-Archive

Initialize-ConfigDir
Clone-Repository
Copy-Config

Add-Startup

exit 0
