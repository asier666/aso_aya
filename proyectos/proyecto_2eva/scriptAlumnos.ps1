Import-Module ActiveDirectory
$ADUsers = Import-Csv "Z:\alumnos.csv" -Delimiter ","
$DOM = "aya.local"
foreach ($User in $ADUsers){
    try{
        $nombreUsu = $User.Nombre
        $recorte = $nombreUsu.Substring(0, [Math]::Min($nombreUsu.Length, 1))
        $username = "$($recorte)$($User.'Primer Apellido')"
        $password = ConvertTo-SecureString -String "Passw0rd!" -AsPlainText -Force
        $ciclo = $User.Ciclo
        # Crear CADA USUARIO
        New-ADUser -GivenName "$($User.Nombre)" `
                    -Name "$($User.Nombre) $($User.'Primer Apellido') $($User.'Segundo Apellido')"`
                    -SamAccountName $username `
                    -Surname "$($User.'Primer Apellido') $($User.'Segundo Apellido')" `
                    -UserPrincipalName "$($username)@$($DOM)" `
                    -Path "OU=$($User.Curso),OU=$($User.Ciclo),OU=CURSOS,DC=aya,DC=local"`
                    -HomeDirectory "\\AYA-19\carpetasInstituto\$username" `
                    -HomeDrive 'U:' `
                    -AccountPassword $password `
                    -Enabled $true
            # Crear carpeta LOCAL para CADA USUARIO
        New-Item -Path "C:\Shares\carpetasInstituto" -Name $username -ItemType Directory -ErrorAction SilentlyContinue 
            # Permitir acceso a la carpeta de CADA USUARIO
        $user=$username
        $acl = Get-Acl "C:\Shares\carpetasInstituto\$user"
        $acl.SetAccessRuleProtection($true, $false)
        $ar = New-Object System.Security.AccessControl.FileSystemAccessRule("$user", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $acl.SetAccessRule($ar)
            # Asignar la ACL a la carpeta de CADA USUARIO
        Set-Acl "C:\Shares\carpetasInstituto\$user" $acl

        # Meter usuario en cada grupo
        Add-ADGroupMember -Identity $ciclo -Members $username
    }
        catch {Write-Host "Fallo al crear usuario $($User.Nombre) - $_"}
    }