# ps_Util_GenerateSecurePassword


## About
Powershell script to create a secure password to file which is encrypted using the local machine and logged on account (and will only work under with these conditions).

The secure password is saved to file for use elsewhere but is also decrypted to prove that the password can be retreieved.

## Parameters
* PARAMETER clearPassword
    * Required. This is the password that you want to encrypt

* PARAMETER outputFile
    * Optional. If you don't set a filename (including full path) to use then the default will be the current script path + "\SecurePasswordOutput.txt"

## Examples

* EXAMPLE

.\ps_Util_GenerateSecurePassword.ps1 -clearPassword MyPassword1 

* EXAMPLE

.\ps_Util_GenerateSecurePassword.ps1 -clearPassword MyPassword1 -outputFile c:\Temp\MyEncryptedPassword.txt

## Notes
MVogwell - Feb2020

Used decrypt info from https://stackoverflow.com/questions/28352141/convert-a-secure-string-to-plain-text

## Link
https://github.com/mvogwell
