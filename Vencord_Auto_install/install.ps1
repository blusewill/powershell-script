$VencordDownloadUrl = "https://github.com/Vencord/Installer/releases/latest/download/VencordInstallerCli.exe"
$DiscordProcess = Get-Process "Discord"
$GetDiscordPath = (Get-Process "Discord" | Select-Object -First 1).Path

$DiscordRealPath = $GetDiscordPath

Write-Host "Checking if the Discord Process is running..."

if ($null -eq $DiscordRealPath)
{
	Write-Host "Discord is not currently running."
	Write-Host "This Won't Affect the install. But you have to auto start Discord later!"
	$DiscordRunning = 0
} else
{
	Write-Host "Discord is currently running. Closing..."
	if ($DiscordProcess)
	{
		$DiscordProcess | Stop-Process
		Start-Sleep 1
	}
}

Write-Host "Installing Vencord..."
Start-Sleep 1

Start-Sleep 1

Invoke-WebRequest -Uri $VencordDownloadUrl -OutFile "$env:TEMP\VencordInstallerCli.exe"

Start-Process -FilePath "$env:TEMP\VencordInstallerCli.exe" -ArgumentList "-branch auto", "-install" -NoNewWindow -Wait
if ($DiscordRunning -eq 0)
{
	Write-Host "Discord has been sucessfully installed!"
} else
{
	Write-Host "Vencord has been successfully installed. Starting Discord"

	cmd.exe /c start "" $DiscordRealPath 
}

Remove-Item "$env:TEMP\VencordInstallerCli.exe"

