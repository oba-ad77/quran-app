$shell = New-Object -ComObject Shell.Application
$folder = $shell.Namespace("C:\quran_app\assets\audio_compressed")
$items = $folder.Items()

$result = ""
foreach ($item in $items) {
    $result += "$($item.Name) ||| $($folder.GetDetailsOf($item, 21))`n"
}

[System.IO.File]::WriteAllText("C:\quran_app\titles.txt", $result, [System.Text.Encoding]::UTF8)