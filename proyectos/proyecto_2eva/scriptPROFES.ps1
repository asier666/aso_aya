Import-Module activedirectory
New-ADOrganizationalUnit -name "PROFESORES" -path "DC=aya,DC=local"
for ($i=1;$i -le 15;$i++){
    $DOM = "aya.local"
    $nombre = ""
    if ($i -ge 10){
            $nombre = "PROF_$i"
        } else {
            $nombre = "PROF_0$i"
        }
   New-ADUser -Name $nombre -SamAccountName $nombre -UserPrincipalName "$($nombre)@$($DOM)" -Path "OU=PROFESORES,DC=aya,DC=local"          
    }