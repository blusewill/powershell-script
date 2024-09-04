# Variables

$CURRENT_PATH = Get-Location
$FOLDER_PATH = "$env:USERPROFILE\YouTube Download"
$YT_DLP_PATH = "$env:USERPROFILE\YouTube Download\yt-dlp.exe"
$FFMPEG_PATH = "$env:USERPROFILE\YouTube Download\ffmpeg.exe"

# Code Starts Here

Write-Output $CURRENT_PATH

if (-not (Test-Path -Path $FOLDER_PATH)) {
    New-Item -Path $env:USERPROFILE -Name "YouTube Download" -ItemType "Directory"
}

if (-not (Test-Path -Path $YT_DLP_PATH)) {
    Invoke-WebRequest https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe -OutFile "$FOLDER_PATH\yt-dlp.exe"
}
else {
    $lastModified = (Get-Item $YT_DLP_PATH).LastWriteTime
    $threeWeeksAgo = (Get-Date).AddDays(-21)
    
    if ($lastModified -lt $threeWeeksAgo) {
        Write-Output "檢查更新中..."
        Set-Location $FOLDER_PATH
        Start-Process -FilePath "$YT_DLP_PATH" -ArgumentList "--update" -Wait -NoNewWindow
        Set-Location $CURRENT_PATH
    }
}

if (-not (Test-Path -Path $FFMPEG_PATH)) {
    Write-Output "正在下載 ffmpeg"
    $ffmpegUrl = "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"
    $zipPath = "$FOLDER_PATH\ffmpeg.zip"
    
    # Download the zip file
    Invoke-WebRequest -Uri $ffmpegUrl -OutFile $zipPath
    
    # Extract the zip file
    Expand-Archive -Path $zipPath -DestinationPath $FOLDER_PATH -Force
    
    # Move ffmpeg.exe to the correct location
    Move-Item -Path "$FOLDER_PATH\ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe" -Destination $FFMPEG_PATH -Force
    
    # Clean up
    Remove-Item -Path $zipPath -Force
    Remove-Item -Path "$FOLDER_PATH\ffmpeg-master-latest-win64-gpl" -Recurse -Force
    
    Write-Output "ffmpeg 下載且安裝成功！"
}

Clear-Host

$URL = Read-Host "請輸入你的 YouTube 連結，或是包括很多 YouTube 連接的文字檔案 "
if ($URL.EndsWith(".txt")) {
    if (Test-Path -Path $URL) {
        $todayFolder = Join-Path $CURRENT_PATH (Get-Date -Format "yyyy-MM-dd 音樂下載")
        if (-not (Test-Path -Path $todayFolder)) {
            New-Item -Path "$todayFolder" -ItemType Directory
        }
        Start-Process -FilePath "$YT_DLP_PATH" -ArgumentList "-x", "--audio-format", "mp3", "--batch-file", "$URL", "--ffmpeg-location", "`"$FFMPEG_PATH`"", "-o", "`"$todayFolder\%(title)s.%(ext)s`"" -Wait -NoNewWindow
    }
}
else {
    Start-Process -FilePath "$YT_DLP_PATH" -ArgumentList "-x", "--audio-format", "mp3", "$URL", "--ffmpeg-location", "`"$FFMPEG_PATH`"", "-o", "`"$CURRENT_PATH\%(title)s.%(ext)s`"" -Wait -NoNewWindow
}

Write-Output "下載成功！請按任意鍵離開"
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
