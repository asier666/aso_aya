# Proyecto de la 2ª Evaluación
Asier Yusto Abad

Desarrollo de un dominio para centro educativo `AYA`

## Índice

1. Archivos con los datos
2. Scripts 
3. Script de instalación


Se indican las características del centro educativo:

- Se imparten los ciclos formativos de ASIR, SMR, DAM y DAW
- Cada ciclo formativo tiene un curso de primero y otro de segundo
- Los primeros cursos tienen 30 alumnos matriculados y los segundos cursos 15
- Los datos de los alumnos se encuentran en este [fichero](./alumnos.csv)
- Cada curso tiene un aula propia con 15 equipos con Windows 10
- Hay 15 profesores que pueden impartir clase en cualquier aula

## 1. Configuración del dominio

Nombre de dominio: `AYA-19`
Distribución de UOs, grupos y usuarios:

Aplicación de GPOs a Alumnos:

Los grupos, UOs, usuarios y carpetas se implementan en el dominio mediante los scripts que se van a explicar en los puntos posteriores, empleando también los archivos de datos que expondré en el siguiente apartado.


## 2. Archivos con los datos

Este apartado incluye información sobre los archivos de datos necesarios para la ejecución del script para nuestro dominio.

### 2.1. `uo.csv`:
**Uso:** contiene los nombres de cada curso bajo la columna `name`, para su uso posterior en los scripts.

**Contenido:**
```
name
ASIR
SMR
DAM
DAW
```

### 2.2. `alumnos.csv`:
**Uso:** contiene los datos de cada alumno con las columnas **Nombre**, **Primer Apellido**, **Segundo Apellido**, **Ciclo** y **Curso** para la creación de estos usuarios.

**Contenido:**
```
Nombre,Primer Apellido,Segundo Apellido,Ciclo,Curso
María,Torres,Vázquez,ASIR,Primero
Carlos,Jiménez,Sánchez,ASIR,Primero
Daniel,Moreno,Romero,ASIR,Primero
Ana,Castro,Vázquez,ASIR,Primero
...
```

## 3. Scripts

Este apartado contiene explicaciones de los scripts individuales que se ejecutan en el script de instalación final.

### 3.1. `scriptUO.ps1`

#### Función:
1. Crea la UO AULAS
2. Crea las UO ASIR, SMR, DAM dentro de AULAS.
3. Crea la UO CURSOS
4. Crea las UO ASIR, SMR, DAM y DAW dentro de CURSOS.
5. Crea las UO Primero y Segundo dentro de cada CURSO
6. Crea 15 Equipos en cada AULA, con nombres `ASI-01/ASI-15` para **ASIR**, `DAM-01/DAM-15` para **DAM**, etc...

#### Contenido de `scriptUO.ps1`:
```powershell
Import-Module activedirectory
$ADou = Import-csv Z:\uo.csv
    # Creación UO AULAS
New-ADOrganizationalUnit -name "AULAS" -path "DC=aya,DC=local"
    # Creación UO CURSOS
New-ADOrganizationalUnit -name "CURSOS" -path "DC=aya,DC=local"
    # Para cada registro del CSV
foreach ($ou in $ADou) {
        # Asignamos cada nombre del csv a la variable $name.
    $name=$ou.name
        # Creamos cada OU por cada $name del CSV, una en CURSOS y otra en AULAS
    New-ADOrganizationalUnit -name $name -path "OU=CURSOS,DC=aya,DC=local"
    New-ADOrganizationalUnit -name $name -path "OU=AULAS,DC=aya,DC=local"
        # Adición de los 15 Equipos a las Aulas
        for ($i=1;$i -le 15;$i++){
                # Cojo los 3 primeros carácteres del $name del CSV
            $prefijo=$name.Substring(0, [Math]::Min($name.Length, 3))
            if ($i -ge 10){
                New-ADComputer -name "$($prefijo)-$i" -path "OU=$($name),OU=AULAS,DC=aya,DC=local"
            } else {
                New-ADComputer -name "$($prefijo)-0$i" -path "OU=$($name),OU=AULAS,DC=aya,DC=local"
            }
        }
    # Crear las carpetas "Primero" y "Segundo" en cada UO del CSV en CURSOS:
    New-ADOrganizationalUnit -name "Primero" -path "OU=$($name),OU=CURSOS,DC=aya,DC=local"
    New-ADOrganizationalUnit -name "Segundo" -path "OU=$($name),OU=CURSOS,DC=aya,DC=local"
}
```

### 3.2. `scriptPROFES.ps1`
#### Función:
1. Crea la UO profesores y añade 15 profes a ella, llamándolos `PROF_01` a `PROF_15`

#### Contenido:
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

### 3.3. `scriptGRUPOS.ps1`
#### Función:
1. Crea los grupos ASIR, DAM, DAW, SMR.
2. Crea y comparte las carpetas con cada grupo, añadiendo también el share smb. (todos ven y usan todas las carpetas)

#### Contenido:
```powershell
Import-Module activedirectory
$ADou = Import-csv Z:\uo2.csv
foreach ($ou in $ADou){
    $grupo=$ou.name
        #("Grupo_ASIR", "Grupo_SMR", "Grupo_DAM", "Grupo_DAW")
    $rutaBase = "C:\Shares\carpetasInstituto\"
    #$rutaCarpeta = "SHARED_$grupo"
        # Crear el grupo en Active Directory
    if (-not (Get-ADGroup -Filter { Name -eq $grupo })) {
       New-ADGroup -Name $grupo -GroupScope Global -Path "OU=$($grupo),OU=CURSOS,DC=aya,DC=local" -Description "Grupo para $grupo"
    } else {
        Write-Host "El grupo '$grupo' ya existe."
    }
        # Crear la carpeta para el grupo
    #New-Item -Path $rutaBase$rutaCarpeta -ItemType Directory -Force
        # Establecer permisos para la carpeta
    
    #$acl = Get-Acl $rutaBase$rutaCarpeta
    #$regla = New-Object System.Security.AccessControl.FileSystemAccessRule($grupo, "Modify", "Allow")
    #$acl.SetAccessRule($regla)
    #Set-Acl -Path $rutaBase$rutaCarpeta -AclObject $acl
        # Compartir la carpeta
    New-SmbShare -Name $grupo -Path $rutaBase -FullAccess "AYA\$grupo"
    #$rutaCarpeta 
    
    # Mostrar mensaje de éxito
    Write-Host "Grupo '$grupo' creado y carpeta compartida '$rutaCarpeta' configurada."
}
```

### 3.4. `scriptAlumnos.ps1`
1. Introduce Alumnos desde alumnos.csv a su correspondiente curso y año en CURSOS
2. Crea su carpeta compartida y le da los permisos necesarios.
3. Mete a cada usuario en su correspondiente grupo
```powershell
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
```
<!--
## `scriptAlumnos.ps1`
1. Introduce Alumnos desde alumnos.csv a su correspondiente curso y año en CURSOS
2. Crea su carpeta compartida y le da los permisos necesarios.
3. Mete a cada usuario en su correspondiente grupo
```powershell
# Crear carpeta compartida para cada grupo
Import-Module ActiveDirectory
$ADou = Import-csv Z:\uo.csv
foreach ($ou in $ADou){
    $grupo=$ou.name
    $rutaCarpeta = "C:\shares\carpetasInstituto\SHARED_$grupo"
    New-Item -Path $rutaCarpeta -ItemType Directory

    # Establecer permisos
    $acl = Get-Acl $rutaCarpeta
    $regla = New-Object System.Security.AccessControl.FileSystemAccessRule("$grupo","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    #Set-Acl $rutaCarpeta $regla
    $acl.SetAccessRule($regla)
}
```
-->

## 4. Script de instalación

Incluye los scripts mencionados en el apartado 2. Su función es ejecutarlos todos en el orden correcto para que no haya problemas en la implementación de objetos.

### Contenido de `scriptInstalacion.ps1`:
```powershell
& "C:\scriptUO.ps1"
& "C:\scriptPROFES.ps1"
& "C:\scriptGRUPOS.ps1"
& "C:\scriptAlumnos.ps1"
& "C:\scriptCompartir.ps1"
```

## 5. Directivas

Cabe mencionar que realicé esta configuración en una máquina de Windows Server 2019 en inglés, por lo que la traducción de las directivas puede que no sea 100% fiel a las de Windows en Español.

### 5.1. Lista de directivas a configurar
#### 5.1.1. Cambiar fondo de pantalla a instituto
**Configuración de usuario > Políticas > Plantillas Administrativas > Escritorio > Escritorio > Fondo de pantalla de Escritorio**

:white_check_mark: ``Habilitado``

Opciones:
- **Nombre de fondo de pantalla:** `\\aya-19\carpetasInstituto\fondo.png`
- **Estidlo de fondo de pantalla:** ``Centrado``

#### 5.1.2. No permitir cambiar fondo de pantalla
**Configuración de usuario > Políticas > Plantillas Administrativas > Panel de Control > Personalización > Prohibir cambiar el fondo de pantalla**

:white_check_mark: ``Habilitado``


#### 5.1.3. Activar salvapantallas (para permitir que el equipo hiberne)
**Configuración de usuario > Políticas > Plantillas Administrativas > Panel de Control > Personalización > Permitir salvapantallas**

:white_check_mark: `Habilitado`

#### 5.1.4. Prohibir acceso a ajustes y panel de control
**Configuración de usuario > Políticas > Plantillas Administrativas > Panel de Control > Aspecto > Deshabilitar mostrar Panel de Control**

:white_check_mark: `Habilitado`

#### 5.1.5. Contraseña protege al salvapantallas
**Configuración de usuario > Políticas > Plantillas Administrativas > Panel de Control > Personalización > Salvapantallas protegido por Contraseña**

:white_check_mark: `Habilitado`

#### 5.1.6. Hibernación a los 15 minutos sin actividad
**Configuración de usuario > Políticas > Plantillas Administrativas > Panel de Control > Personalización > Tiempo de espera de Salvapantallas**

:white_check_mark: `Habilitado`

Opciones:
- **Segundos:** `900`

#### 5.1.7. Ocultar "Windows Marketplace"
**Configuración de usuario > Políticas > Plantillas Administrativas > Panel de Control > Programas > Ocultar "Windows Marketplace"**

:white_check_mark: `Habilitado`

#### 5.1.8. Prohibir cmd
**Configuración de usuario > Políticas > Plantillas Administrativas > Sistema > Prohibir acceso al intérprete de comandos**

:white_check_mark: `Habilitado`

Opciones:
- **¿Deshabilitar también la ejecución de scripts?:** `No`

#### 5.1.9. Prohibir edición de registro
**Configuración de usuario > Políticas > Plantillas Administrativas > Sistema > Prohibir acceso a herramientas de edición del registro**

:white_check_mark: `Habilitado`

#### 5.1.10. Recibir actualizaciones de windows
**Configuración de usuario > Políticas > Plantillas Administrativas > Sistema > Actualizaciones automáticas de Windows**

:white_check_mark: `Deshabilitado`

De esta manera, hacemos que se descarguen e instalen las actualizaciones de Windows automáticamente.

#### 5.1.11. Deshabilitar Administrador de Tareas en Ctr+Alt+Del
**Configuración de usuario > Políticas > Plantillas Administrativas > Sistema/Opciones Ctrl+Alt+Del > Deshactivar Administrador de Tareas**

:white_check_mark: `Habilitado`


### 5.2. Aplicación de directivas

Estas directivas están aplicadas en la `GPO_Alumnos`