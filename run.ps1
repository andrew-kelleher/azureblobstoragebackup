# Input bindings are passed in via param block.
param($Timer)

# Define variables
$SrcStgAccURI = "https://sourceblobstg.blob.core.windows.net/"
$SrcBlobContainer = "myblobs"
$SrcSASToken = SAS_TOKEN_SOURCE
$SrcFullPath = "$($SrcStgAccURI)$($SrcBlobContainer)?$($SrcSASToken)"

$DstStgAccURI = "https://destinationfilestg.file.core.windows.net/"
$DstFileShare = "backupstaging"
$DstSASToken = SAS_TOKEN_DESTINATION
$DstFullPath = "$($DstStgAccURI)$($DstFileShare)?$($DstSASToken)"

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' property is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

# uncomment to delete azcopy and force download again
# del azcopy.exe

# Test if AzCopy.exe exists in current folder
$WantFile = "azcopy.exe"
$AzCopyExists = Test-Path $WantFile
Write-Host "AzCopy exists:" $AzCopyExists

# Download AzCopy if it doesn't exist
If ($AzCopyExists -eq $False)
{
    Write-Host "AzCopy not found. Downloading..."
    
    #Download AzCopy
    Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing
 
    #Expand Archive
    write-host "Expanding archive..."
    Expand-Archive ./AzCopy.zip ./AzCopy -Force

    # Copy AzCopy to current dir
    Get-ChildItem ./AzCopy/*/azcopy.exe | Copy-Item -Destination "./AzCopy.exe"
}
else
{
    Write-Host "AzCopy found, skipping download."
}

# Run AzCopy from source blob to destination file share

Write-Host "Backing up storage account..."
./azcopy.exe copy $SrcFullPath $DstFullPath --recursive --overwrite=ifsourcenewer