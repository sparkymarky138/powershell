# Step 1: Get package list and filter for PackageName
$packageList = DISM /Online /Get-ProvisionedAppxPackages | Select-String Packagename

# Step 2: Check if the folder exists, if not, create it
$folderPath = "C:\temp"
if (-Not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
}

# Step 3: Write the package list to a text file
$filePath = Join-Path -Path $folderPath -ChildPath "PackageList.txt"
$packageList | ForEach-Object { $_.ToString().Split(":")[1].Trim() } | Out-File -FilePath $filePath

Write-Host "Package list written to: $filePath"

# Step 4: Pause the script and open the text file for user editing
notepad.exe $filePath

# Step 5: Wait for user confirmation to continue
Write-Host "Press any key to continue..."
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null

# Step 6: Read the modified package list from the text file
$editedPackageList = Get-Content -Path $filePath

# Step 7: Create and cycle through the string
foreach ($packageName in $editedPackageList) {
    # Do something with $packageName, e.g., print it
    Write-Host "Package Name: $packageName"

    # Step 8: Remove the provisioned package using DISM command
    $removeCommand = "DISM /Online /Remove-ProvisionedAppxPackage /PackageName:$packageName"
    Invoke-Expression $removeCommand
}

Write-Host "Packages have been removed as per the modified list."
