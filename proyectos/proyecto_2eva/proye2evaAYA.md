# Proyecto de la 2ª Evaluación


## Situación inicial

Se indican las características del centro educativo:

- Se imparten los ciclos formativos de ASIR, SMR, DAM y DAW
- Cada ciclo formativo tiene un curso de primero y otro de segundo
- Los primeros cursos tienen 30 alumnos matriculados y los segundos cursos 15
- Los datos de los alumnos se encuentran en este [fichero](./alumnos.csv)
- Cada curso tiene un aula propia con 15 equipos con Windows 10
- Hay 15 profesores que pueden impartir clase en cualquier aula


## Creación Unidades Organizativas:

Contenido del fichero ``uo.csv``:
```
name
ASIR
SMR
DAM
DAW
```

Contenido de `scriptUO.ps1`:
```powershell
# author: activedirectorypro.com
# This script is used for creating bulk organizational units.

# Importar módulo ActiveDirectory
Import-Module activedirectory

# Guardamos el fichero csv en la variable $ADou. 
$ADou = Import-csv Z:\uo2.csv

# Creo Equipos
New-ADOrganizationalUnit -name "AULAS" -path "DC=aya,DC=local"
# Para cada línea
foreach ($ou in $ADou)
{
# Asignamos cada nombre del csv a la variable $name.
$name=$ou.name
# Creamos cada OU por cada $name del CSV.
New-ADOrganizationalUnit -name $name -path "DC=aya,DC=local"
New-ADOrganizationalUnit -name $name -path "OU=AULAS,DC=aya,DC=local"
    for ($i=1;$i -le 15;$i++){
        $prefijo=$name.Substring(0, [Math]::Min($name.Length, 3))
        if ($i -ge 10){
            New-ADComputer -name "$($prefijo)-$i" -path "OU=$($name),OU=AULAS,DC=aya,DC=local"
        } else {
            New-ADComputer -name "$($prefijo)-0$i" -path "OU=$($name),OU=AULAS,DC=aya,DC=local"
        }
        
    }
# Crear las carpetas "Primero" y "Segundo" en cada UO del CSV:
New-ADOrganizationalUnit -name "Primero" -path "OU=$($name),DC=aya,DC=local"
New-ADOrganizationalUnit -name "Segundo" -path "OU=$($name),DC=aya,DC=local"
}

```

## Crear Profesores
```powershell
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
```

## A PARTE
```powershell
New-ADUser -GivenName $nombre `
    -Name "$($User.Nombre) $($User.'Primer Apellido') $($User.'Segundo Apellido')"`
    -SamAccountName $nombre `
    -Surname "$($User.'Primer Apellido') $($User.'Segundo Apellido')" `
    -UserPrincipalName "$($nombre)@$($DOM)" `
    -Path "OU=PROFESORES,DC=aya,DC=local"`
    -HomeDirectory "\\AYA-2019\carpetasPersonales$`\$username" `
    -HomeDrive 'U:' `
    -AccountPassword $password `
    -Enabled $true
```


OU=Primero,OU=ASIR,DC=aya,DC=local

## Datos de usuarios a tener en cuenta:
### Usuario TEST
|nombre dato | valor |
|-----------|------------|
|DistinguishedName | CN=test garcia,OU=Primero,OU=ASIR,DC=aya,DC=local |
|Enabled           | True|
|GivenName         | test|
|Name              | test garcia|
|ObjectClass       | user|
|ObjectGUID        | 3345a00e-77fc-41d0-bdcd-0015d364922e|
|SamAccountName    | usertest
|SID               | S-1-5-21-96269640-80280514-4135821150-1118
|Surname           | garcia
|UserPrincipalName | usertest@aya.local

## Formato archivo alumnos.csv
```
Nombre,Primer Apellido,Segundo Apellido,Ciclo,Curso
María,Torres,Vázquez,ASIR,Primero
```


## Script Alumnos `scriptAlumnos.ps1`
```powershell
Import-Module ActiveDirectory
$ADUsers = Import-Csv "Z:\alumnosTEST.csv" -Delimiter ","

$DOM = "aya.local"
foreach ($User in $ADUsers){
    try{
        $nombreUsu = $User.Nombre
        $recorte = $nombreUsu.Substring(0, [Math]::Min($nombreUsu.Length, 1))
        $username = "$($recorte)$($User.'Primer Apellido')"
        $password = ConvertTo-SecureString -String "Passw0rd!" -AsPlainText -Force

        # Crear CADA USUARIO
        New-ADUser -GivenName "$($User.Nombre)" `
                    -Name "$($User.Nombre) $($User.'Primer Apellido') $($User.'Segundo Apellido')"`
                    -SamAccountName $username `
                    -Surname "$($User.'Primer Apellido') $($User.'Segundo Apellido')" `
                    -UserPrincipalName "$($username)@$($DOM)" `
                    -Path "OU=$($User.Curso),OU=$($User.Ciclo),DC=aya,DC=local"`
                    -HomeDirectory "\\AYA-2019\carpetasPersonales$`\$username" `
                    -HomeDrive 'U:' `
                    -AccountPassword $password `
                    -Enabled $true

            # Crear carpeta LOCAL para CADA USUARIO
        New-Item -Path "C:\Shares\carpetasPersonales$" -Name $username -ItemType Directory -ErrorAction SilentlyContinue
            
        # Permitir acceso a la carpeta de CADA USUARIO
            # Variable nombreUSUARIO
        $user=$username

        $acl = Get-Acl "C:\Shares\carpetasPersonales$`\$user"
        $acl.SetAccessRuleProtection($true, $false)
        $ar = New-Object System.Security.AccessControl.FileSystemAccessRule("$user", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $acl.SetAccessRule($ar)

        # Asignar la ACL a la carpeta de CADA USUARIO
        Set-Acl "\\AYA-2019\carpetasPersonales$`\$user" $acl

    }
        catch {Write-Host "Fallo al crear usuario $($User.Nombre) - $_"}
    }
```

## CREACIÓN DE EQUIPOS
```powershell
# Inicializar el número
$numero = 0

# Bucle que itera 15 veces
for ($i = 1; $i -le 15; $i++) {
    # Aumentar el número en 1
    $numero++
    
    # Mostrar el número actual
    Write-Host "Iteración $i: Número actual es $numero"
}
```


```powershell
# Crear carpeta compartida para cada grupo
$clases = @("ASIR", "SMR", "", "Alumnos_DAW")

foreach ($grupo in $grupos) {
    $rutaCarpeta = "C:\Compartidas\$grupo"
    New-Item -Path $rutaCarpeta -ItemType Directory

    # Establecer permisos
    $acl = Get-Acl $rutaCarpeta
    $regla = New-Object System.Security.AccessControl.FileSystemAccessRule("$grupo",
```


## CARPETAS COMPARTIDAS EN GRUPO
```
Crea las carpetas y los grupos (CON LA RUTA MAL, CREO), pero se comparten las carpetas bien. Revisar.
```
```powershell
# Importar el módulo de Active Directory
Import-Module activedirectory

# Guardamos el fichero csv en la variable $ADou. 
$ADou = Import-csv Z:\uo2.csv
foreach ($ou in $ADou){
    $grupo=$ou.name
    #("Grupo_ASIR", "Grupo_SMR", "Grupo_DAM", "Grupo_DAW")

    $rutaBase = "C:\Shares\carpetasPersonales$`\"
    $rutaCarpeta = "SHARED_$grupo"
    # Crear el grupo en Active Directory
    New-ADGroup -Name $grupo -GroupScope Global -Path "OU=$($grupo),DC=aya,DC=local" -Description "Grupo para $grupo"

    # Crear la carpeta para el grupo
    New-Item -Path $rutaBase$rutaCarpeta -ItemType Directory -Force

    # Establecer permisos para la carpeta
    $acl = Get-Acl $rutaBase$rutaCarpeta
    $regla = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo, "FullControl", "Allow")
    $acl.SetAccessRule($regla)
    Set-Acl -Path $rutaBase$rutaCarpeta -AclObject $acl

    # Compartir la carpeta
    New-SmbShare -Name $grupo -Path $rutaBase -FullAccess $grupo

    # Mostrar mensaje de éxito
    Write-Host "Grupo '$grupo' creado y carpeta compartida '$rutaCarpeta' configurada."
}
```



## BUSCAR USUARIOS DE x UO
```powershell
Get-ADUser -Filter { SamAccountName -like '*' } -SearchBase "OU=Primero,OU=ASIR,DC=aya,DC=local"
```