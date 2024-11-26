# Windows 2019 Server
## Primeros pasos
## Versión core:
### 1. Cambiar el nombre del equipo
Si no lo hacemos, al crear un dominio/servidor ya no podríamos cambiarlo.

Primero pasamos a powershell con:
`powershell`
Obtenemos la variable del nombre del equipo:
`$env:computername`

Cambiar nombre del equipo:
`Rename-Computer CORE-2019`

Habrá que reiniciar para aplicar los cambios.

Variable para que reinicie automáticamente:
`Rename-Computer CORE-2019 -Restart`

### Cambiar Layout Teclado:
`Set-WinUserLanguageList es-ES`

### Configurar IP:
Al ser un servidor debe de tener una **IP estática**

Obtenemos la configuración de nuestros adaptadores con:
`Get-NetAdapter`

Para mostrarlo en formato lista (cada objeto que recibe Get-NetAdapter nos muestra su lista):
`Get-NetAdapter | Format-List`

También se puede forzar a mostrar en forma de tabla con `| Format-Table`
```
Los comandos de PowerShell encuentran y muestran Objetos, normalmente en lista. Cada objeto tiene sus propiedades
```

#### Nos quedamos con el campo `InterfaceIndex`
Podemos buscarlo específicamente con:
`Get-NetAdapter | Select-Object Name,InterfaceIndex,MacAddress`

### Para que no ejecute el comando y podamos escribir en más líneas
Se añade el carácter **`** para que se se hagan cambios de líneas.

### Configurar nueva IP:
`New-NetIPAddress`:
```powershell
New-NetIPAddress -InterfaceIndex 5 -IPAddress 10.0.0.11 -PrefixLength 8 -DefaultGateway 10.0.0.200
```
*Siendo **-PrefixLength** la máscara de la red, barra 8.

### Ver procesos:
`Get-Process`

### Configurar 2 máquinas con Adaptador NAT DHCP y Adaptador Sólo Anfitrión RED 172.25.0.60

En Versión escritorio, ponemos la IP estática 172.25.0.61 con máscara 255.255.255.0

En versión CORE, hacemos:
```powershell
New-NetIPAddress -InterfaceIndex 10 -IPAddress 172.25.0.62 -PrefixLength 24
```

### Deshabilitar FIREWALL
Importante desactivar el firewall en ambos equipos!!

```powershell
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

O tambien:
`netsh advfirewall set allprofiles state off`

## Herramienta `sconfig` para configuración de red
Permite gestionar configuraciones básicas del servidor fácilmente.