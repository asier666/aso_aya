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