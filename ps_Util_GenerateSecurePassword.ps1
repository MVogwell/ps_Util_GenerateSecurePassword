<#

.SYNOPSIS
Powershell script to create a secure password to file which is encrypted using the local machine and logged on account (and will only work under with these conditions).

The secure password is saved to file for use elsewhere but is also decrypted to prove that the password can be retreieved.

.DESCRIPTION


.PARAMETER clearPassword
    Required. This is the password that you want to encrypt

.PARAMETER outputFile
    Optional. If you don't set a filename (including full path) to use then the default will be the current script path + "\SecurePasswordOutput.txt"

.EXAMPLE

.\ps_Util_GenerateSecurePassword.ps1 -clearPassword MyPassword1 

.EXAMPLE

.\ps_Util_GenerateSecurePassword.ps1 -clearPassword MyPassword1 -outputFile c:\Temp\MyEncryptedPassword.txt

.NOTES
MVogwell - Feb2020
Used decrypt info from https://stackoverflow.com/questions/28352141/convert-a-secure-string-to-plain-text

.LINK
https://github.com/mvogwell

#>

[CmdletBinding()]
param ( 
    [Parameter(Mandatory=$True)][string]$clearPassword,
    [Parameter(Mandatory=$False)][string]$outputFile = ""
)

Write-Host "`n`nGenerate secure password`n`n" -ForegroundColor Yellow

# Set the output file if nothing is set
If ($outputFile.Length -eq 0) {
    $outputFile = $PSScriptRoot + "\SecurePasswordOutput.txt"
}

Write-Host "Initial data: " -ForegroundColor Yellow
Write-Host "... Clear text password enetered: " -ForegroundColor Yellow -NoNewline
Write-Host "$clearPassword" -ForegroundColor Cyan

Write-Host "... Output File: " -ForegroundColor Yellow -NoNewline
Write-Host "$outputFile `n" -ForegroundColor Cyan

$SecurePassword = ConvertTo-SecureString $clearPassword -AsPlainText -Force
$ClearSecurePassword = $SecurePassword | ConvertFrom-SecureString

Try {
    $bSaveSuccess = $True

    Write-host "Saving encrypted password to file: " -ForegroundColor Yellow -NoNewline

    $ClearSecurePassword | Out-File $outputFile -Force

    Write-Host "Success" -ForegroundColor Green

    Write-Host "`nEncrypted password: " -ForegroundColor Yellow -NoNewline
    Write-Host "$ClearSecurePassword" -ForegroundColor Cyan
}
Catch {
    $bSaveSuccess = $False

    Write-Host "Failed`n" -ForegroundColor Red

    $sErrorSysMsg = (($Error[0].exception).toString()).replace("`r"," ").replace("`n"," ")
    Write-Host "Error: $sErrorSysMsg"
}


If ($bSaveSuccess -eq $True) {
    Write-Host "`n`nTesting decryption:`n" -ForegroundColor Yellow

    $SavedClearSecurePassword = Get-Content $outputFile

    $ReEncryptedPassword = ConvertTo-SecureString $SavedClearSecurePassword

    Write-Host "... Re-encrypted password type: " -ForegroundColor Yellow -NoNewline
    Write-Host "$($ReEncryptedPassword.Gettype()) " -ForegroundColor Cyan

    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ReEncryptedPassword)
    $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

    Write-Host "`n... Decrypted password: " -ForegroundColor Yellow -NoNewline
    Write-Host "$UnsecurePassword" -ForegroundColor Cyan
}

Write-Host "`n`nFinished`n`n" -ForegroundColor Green