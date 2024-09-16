Write-Host "Checking your legality of Windows..."

$result = cscript "C:\Windows\System32\slmgr.vbs" /dlv
Out-File -InputObject $result -FilePath "$PWD\result.txt"

# Read the content of the result.txt file
$resultContent = Get-Content -Path "$PWD\result.txt" -Raw

# Define the pattern to check
$pattern = "microsoft.com"

# Check if the pattern exists in the result content
if ($resultContent -match $pattern) {
    Write-Host "Verified: microsoft.com domain found in the activation details" -ForegroundColor Green
    Write-Host "You are using a non-KMS Windows Machine. Check Passed!" -ForegroundColor Green
} else {
    Write-Host "Not found: microsoft.com domain not found in the activation details" -ForegroundColor Red
    Write-Host "You're running on a KMS Server or Activated Windows. Doing further check..." -ForegroundColor Yellow
    $Pirate = Get-Process "KMS*" -ErrorAction SilentlyContinue
    if ($Pirate) {
        Write-Host "You're Using a Pirated Version of Windows that Might have Virus Installed!" -ForegroundColor Red
        Write-Host "Please Consider Re-Install your Windows Installation" -ForegroundColor Red
    }
    else {
        Write-Host "Hmm... Looks like you're running a KMS Version of Windows without any Bad Process" -ForegroundColor Yellow
        Write-Host "You might be using the slmgr KMS Method or we didn't detect the process in the background" -ForegroundColor Yellow
        Write-Host "Consider Checking the Process in the Task Manager for applications that seem abnormal." -ForegroundColor Yellow
    }
}

Remove-Item "$PWD/result.txt" -Force

Write-Output "Press Any Key to Contiune."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')