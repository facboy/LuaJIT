gsudo {
    cd $args[0]

    $BuildDir = "src\\"
    $DestDir = "C:\Program Files\RainMeter\\"

    robocopy "$BuildDir" "$DestDir" "lua51.dll" /w:5
} -args $PSScriptRoot
