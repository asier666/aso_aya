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

# Para cada línea
foreach ($ou in $ADou)
{
# Asignamos cada nombre del csv a la variable $name.
$name=$ou.name
# Creamos cada OU por cada $name del CSV.
New-ADOrganizationalUnit -name $name -path "DC=aya,DC=local"
# Crear las carpetas "Primero" y "Segundo" en cada UO del CSV:
New-ADOrganizationalUnit -name "Primero" -path "OU=$($name),DC=aya,DC=local"
New-ADOrganizationalUnit -name "Segundo" -path "OU=$($name),DC=aya,DC=local"
}
```


OU=Primero,OU=ASIR,DC=aya,DC=local

## Script Alumnos
```powershell
$ADUsers = Import-Csv "Z:\alumnosTEST.csv" -Delimiter ","

$DOM = "aya.local"
foreach ($User in $ADUsers){
    try{
        $nombreUsu = $User.Nombre
        $recorte = $nombreUsu.Substring(0, [Math]::Min($nombreUsu.Length, 1))
        $username = "$($recorte)$($User.'Primer Apellido')"
        $password = ConvertTo-SecureString -String "Passw0rd!" -AsPlainText -Force

        $UserConfig = @{
            
           GivenName= $User.Nombre
           Name= "$($User.Nombre) $($User.'Primer Apellido') $($User.'Segundo Apellido')"    
                    #Nombre PrimerApellido SegundoApellido` (NOMBRE COMPLETO)
                # username HECHO
           SamAccountName= $username #Nombre.PrimerApellido (NOMBRE INICIO DE SESIÓN)
           Surname= "$($User.'Primer Apellido') $($User.'Segundo Apellido')"
                #Primer Apellido, Segundo Apellido (APELLIDOS)
               # USERPRINCIPAL NAME HECHO 
           UserPrincipalName= "$($username)@$($DOM)"  #(NOMBRE INICIO DE SESIÓN + DOM)
           Path= "OU=$($User.Curso),OU=$($User.Ciclo),DC=aya,DC=local" #(RUTA)

           HomeDirectory= "\\share\users\$($UserConfig.SamAccountName)"
           HomeDrive= 'U:'
           AccountPassword= $password
           Enabled= $true
        }
        New-Item -Path "\\share\users" -Name $UserConfig.SamAccountName -ItemType Directory -ErrorAction SilentlyContinue
        New-ADUser @UserConfig

        # Set-ADAccountPassword -Identity ($UserConfig.Path) -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "p@ssw0rd!" -Force)
    }
        catch {Write-Host "Fallo al crear usuario $($User.Nombre) - $_"}
    }
```
Nombre,Primer Apellido,Segundo Apellido,Ciclo,Curso
María,Torres,Vázquez,ASIR,Primero

## Usuario TEST
DistinguishedName : CN=test garcia,OU=Primero,OU=ASIR,DC=aya,DC=local
Enabled           : True
GivenName         : test
Name              : test garcia
ObjectClass       : user
ObjectGUID        : 3345a00e-77fc-41d0-bdcd-0015d364922e
SamAccountName    : usertest
SID               : S-1-5-21-96269640-80280514-4135821150-1118
Surname           : garcia
UserPrincipalName : usertest@aya.local

``scriptALUMNOS.ps1`

## Ruta Perfil
```powershell
Get-ADUser -Filter * -Properties HomeDirectory
```
RUTA: `\\AYA-2019\carpetasPersonales$\fgonzalez`

TRY:
```
New-Item -Path "\\share\users" -Name $UserName -ItemType Directory -ErrorAction SilentlyContinue
```
