Import-Module activedirectory
$ADou = Import-csv Z:\uo.csv
foreach ($ou in $ADou){
    $grupo=$ou.name
        #("Grupo_ASIR", "Grupo_SMR", "Grupo_DAM", "Grupo_DAW")
    $rutaBase = "C:\Shares\carpetasInstituto\"
        # Crear el grupo en Active Directory
    if (-not (Get-ADGroup -Filter { Name -eq $grupo })) {
       New-ADGroup -Name $grupo -GroupScope Global -Path "OU=$($grupo),OU=CURSOS,DC=aya,DC=local" -Description "Grupo para $grupo"
    } else {
        Write-Host "El grupo '$grupo' ya existe."
    }
        # Compartir la carpeta
    New-SmbShare -Name $grupo -Path $rutaBase -FullAccess "AYA\$grupo"
    # Mostrar mensaje de éxito
    Write-Host "Grupo '$grupo' creado y carpeta compartida '$rutaCarpeta' configurada."
}