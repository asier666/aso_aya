# Promover un equipo a controlador de dominio.

1. Antes de hacerlo controlador, tenemos que cambiar su nombre de equipo.
2. Asignarle IP estática
3. Instalar el rol de Servicios de Dominio de Active Directory



Active Directory es una base de datos, se guarda todo en:
Windows\NTDS, Windows\NTDS y Windows\SYSVOL


Script de Windows powershell para implementar AD DS
Import-Module ADDSDeployment
Install-ADDSForest
-CreateDnsDelegation:$false
-DatabasePath "C:\Windows\NTDS"
-DomainMode "Win2012R2"


aya.local

Instalación AD DS:

Agregar un nuevo bosque
Pass:Villabalter1





# Comandos Active Directory

``Get-ADForest`` : Nos da información sobre el bosque

``Get-ADUser`` : proporciona información sobre los usuarios
``New-ADUser`` : crea un usuario en el dominio




Ámbito normal para grupo: Grupo **global**

``Add-ADGroupMember`` : agrega un usuario a un grupo

``Remove-ADGroupMember`` : elimina un usuario de un grupo, Si no queremos que nos pregunte confirmación añadimos: ``-Confirm:$false``