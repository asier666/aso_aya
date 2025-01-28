# Proyecto de la 2ª Evaluación


## Situación inicial

Se indican las características del centro educativo:

- Se imparten los ciclos formativos de ASIR, SMR, DAM y DAW
- Cada ciclo formativo tiene un curso de primero y otro de segundo
- Los primeros cursos tienen 30 alumnos matriculados y los segundos cursos 15
- Los datos de los alumnos se encuentran en este [fichero](./alumnos.csv)
- Cada curso tiene un aula propia con 15 equipos con Windows 10
- Hay 15 profesores que pueden impartir clase en cualquier aula


### Creación Unidades Organizativas:

New-ADOrganizationalUnit -Name "ASIR" -Path "DC=AYA,DC=LOCAL"