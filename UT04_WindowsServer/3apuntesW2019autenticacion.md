# Autenticación para Windows 2019

Para que conecte por HTTPS, en lugar de HTTP

## 1. Crear un certificado autofirmado

-DnsName: La IP del propio servidor
-CertStoreLocation: localización del archivo donde se guardará

`New-SelfSignedCertificate -DnsName "10.0.0.11" -CertStoreLocation Cert:\LocalMachine\My -KeyLength 2048`




## 3. Crear nuevo listener


`New-Item -Path WSMan:\localhost\listener -Transport HTTPS -Address -CertificateThumbPrint <certificado>`



En la máquina **QUE VAMOS A ADMINISTRAR** tenemos que añadir -UseSSL para que use HTTPS
`Invoke-Command -ComputerName 10.0.0.11 -Credential ( Get-Credential ) -ScriptBlock ( Get-Content env:computername ) -UseSSL`

Puede que de un error porque detecta que el certificado no tiene una firma oficial. Tendremos que exportar el certificado para marcarlo como fiable:

`Export-Certificate -Cert Cert:\LocalMachina\My\<id_certificado> -FilePath C:\servercert.cer`

Lo siguiente es enviar este certificado al cliente

`Copy-Item -Path C:\servercert-cer -Destination "\\10.0.0.11"`

Para luego importar el certificado en el cliente

`Import-Certificate -FilePath C:\compartida\servercert.cer -CertStoreLocation Cert:\LocalMachine`