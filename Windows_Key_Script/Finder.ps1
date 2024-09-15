Write-Host "Getting it from Software Licensing Services"

$LIC_SERVICES = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey

Write-Host "First Check : $LIC_SERVICES"

Write-Host "Checking it from Digital Product ID"

# Export the DigitalProductId to a separate file
$exportPath = "$env:TEMP\DigitalProductId.txt"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DigitalProductId | Out-File -FilePath $exportPath

# Read the digital product ID from the exported file
$regContent = Get-Content -Path $exportPath -Raw
$digitalProductIdMatch = [regex]::Match($regContent, 'DigitalProductId\s+REG_BINARY\s+(.*)')

if ($digitalProductIdMatch.Success) {
    $digitalProductIdHex = $digitalProductIdMatch.Groups[1].Value -replace '\s', ''
    $digitalProductId = [byte[]]::new($digitalProductIdHex.Length / 2)
    for ($i = 0; $i -lt $digitalProductId.Length; $i++) {
        $digitalProductId[$i] = [Convert]::ToByte($digitalProductIdHex.Substring($i * 2, 2), 16)
    }

    $key = ""
    $keyOffset = 52
    $isWin8 = ($digitalProductId[66] / 6) -band 1
    $digitalProductId[66] = ($digitalProductId[66] -band 0xf7) -bor (($isWin8 -band 2) * 4)

    $digits = "BCDFGHJKMPQRTVWXY2346789"
    $last = 0

    for ($i = 24; $i -ge 0; $i--) {
        $current = 0
        for ($j = 14; $j -ge 0; $j--) {
            $current = $current * 256
            $current = $digitalProductId[$j + $keyOffset] + $current
            $digitalProductId[$j + $keyOffset] = [byte][Math]::Floor($current / 24)
            $current = $current % 24
        }
        $key = $digits[$current] + $key
        $last = $current
    }

    $keypart1 = $key.Substring(1, $last)
    $keypart2 = $key.Substring($last + 1, $key.Length - ($last + 1))
    $key = $keypart1 + "N" + $keypart2

    for ($i = 5; $i -lt $key.Length; $i += 6) {
        $key = $key.Insert($i, "-")
    }

    Write-Host "Decoded Digital Product Key: $key"
}
else {
    Write-Host "DigitalProductId not found in the exported file."
}

Write-Host "Checking for the extra Digital Product ID!"

# Export the DigitalProductId to a separate file
$exportPath = "$env:TEMP\DigitalProductId.txt"
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v DigitalProductId4 | Out-File -FilePath $exportPath

# Read the digital product ID from the exported file
$regContent = Get-Content -Path $exportPath -Raw
$digitalProductIdMatch = [regex]::Match($regContent, 'DigitalProductId4\s+REG_BINARY\s+(.*)')

if ($digitalProductIdMatch.Success) {
    $digitalProductIdHex = $digitalProductIdMatch.Groups[1].Value -replace '\s', ''
    $digitalProductId = [byte[]]::new($digitalProductIdHex.Length / 2)
    for ($i = 0; $i -lt $digitalProductId.Length; $i++) {
        $digitalProductId[$i] = [Convert]::ToByte($digitalProductIdHex.Substring($i * 2, 2), 16)
    }

    $key2 = ""
    $keyOffset = 52
    $isWin8 = ($digitalProductId[66] / 6) -band 1
    $digitalProductId[66] = ($digitalProductId[66] -band 0xf7) -bor (($isWin8 -band 2) * 4)

    $digits = "BCDFGHJKMPQRTVWXY2346789"
    $last = 0

    for ($i = 24; $i -ge 0; $i--) {
        $current = 0
        for ($j = 14; $j -ge 0; $j--) {
            $current = $current * 256
            $current = $digitalProductId[$j + $keyOffset] + $current
            $digitalProductId[$j + $keyOffset] = [byte][Math]::Floor($current / 24)
            $current = $current % 24
        }
        $key2 = $digits[$current] + $key2
        $last = $current
    }

    $keypart1 = $key2.Substring(1, $last)
    $keypart2 = $key2.Substring($last + 1, $key2.Length - ($last + 1))
    $key2 = $keypart1 + "N" + $keypart2

    for ($i = 5; $i -lt $key2.Length; $i += 6) {
        $key2 = $key2.Insert($i, "-")
    }

    Write-Host "Decoded Digital Product Key: $key2"
}
else {
    Write-Host "DigitalProductId4 not found in the exported file."
}

# Clean up the temporary file
Remove-Item -Path $exportPath -Force

$CDIR = Get-Location
Write-Host "Outputting to the Keys.txt"
Out-File -FilePath "$CDIR/Keys.txt" -InputObject "Licensing Services Key : $LIC_SERVICES"
Out-File -FilePath "$CDIR/Keys.txt" -InputObject "Digital Product ID Key : $key" -Append
Out-File -FilePath "$CDIR/Keys.txt" -InputObject "Extra Digital Product ID Key : $key2" -Append
