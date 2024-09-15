Write-Host "Checking your legality of Windows..."

$result = cscript "C:\Windows\System32\slmgr.vbs" /dlv
Out-File -InputObject $result -FilePath "$PWD\result.txt"

# Read the content of the result.txt file
$resultContent = Get-Content -Path "$PWD\result.txt" -Raw

# Define the patterns to check
$patterns = @(
    "Validation URL: https://validation-v2.sls.microsoft.com/SLWGA/slwga.asmx"
)

# Initialize a flag to track if all patterns are found
$allPatternsFound = $true

# Check each pattern
foreach ($pattern in $patterns) {
    if ($resultContent -match $pattern) {
        Write-Host "Verified: $pattern" -ForegroundColor Green
    } else {
        Write-Host "Not found or mismatch: $pattern" -ForegroundColor Red
        $allPatternsFound = $false
    }
}

# Final verdict
if ($allPatternsFound) {
    Write-Host "You are using non-kms Windows Machine Check Passed!" -ForegroundColor Green
} else {
    Write-Host "You're running on a KMS Server of Activated Windows. Doing Further check" -ForegroundColor Yellow
    $Pirate = Get-Process "KMS*" -ErrorAction SilentlyContinue
    if ($Pirate) {
        Write-Host "You're Using a Pirated Version of Windows that Might have Virus Installed!" -ForegroundColor Red
        Write-Host "Please Consider Re-Install your Windows Installation" -ForegroundColor Red
    }
    else {
        Write-Host "Hmm... Looks like you're running a KMS Version of Windows without any Bad Process" -ForegroundColor Yellow
        Write-Host "You might using the slmgr KMS Method or either We didn't detect the process in the background" -ForegroundColor Yellow
        Write-Host "Consider Check the Process in the Task Manager for application that seems abnormal." -ForegroundColor Yellow
    }
}

Remove-Item "$PWD/result.txt" -Force

