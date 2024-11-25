# Windows 2019 Server

Abrir otra vez el cmd: Ctrl Alt Supr

### Deshabilitar FIREWALL
```powershell
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```
- Crear regla de Firewall:
```powershell
New-NetFirewallRule
    -DisplayName "ICMP Permitir ping" 
    -Direction Inbound 
    -Protocol ICMPv4 
    -IcmpType 8 
    -RemoteAddress 10.0.0.0
    -Action Allow
```

## Administración Remota
Se puede ejecutar un comando y mandarlo a una máquina u a otra.

- WinRM (Windows Remote Management)

Para configurar una máquina en modo CORE desde una máquina con interfaz Gráfica:
Pantalla negra: Modo CORE | Pantalla azul: Modo Escritorio

### Equipo CORE (el que será gestionado):
`Enable-PSRemoting -Force`

*Si estamos dentro de un dominio, será suficiente con ejecutar este comando y ya está. Si no:

- Si no está disponible el protocolo Kerberos, se usará **NTLM**, que sirve para autenticar un equipo en otro equipo remoto:

En el **cliente** tendremos que añadir el **nombre del servidor** al fichero **TrustedHosts** para que reconozca a este y pueda ser gestionado de forma remota.

### Desde equipo Cliente (desde el que gestionaremos):
Con `winrm get winrm/config/client` podemos ver la configuración de WinRM, y la lista de TrustedHosts

Empleamos `set-Item WSMan:\localhost\Client\TrustedHosts Value "10.0.0.11"` 
Se pueden poner distintos equipos separados por comas.


Ahora ya podemos ejecutar comandos en el equipo remoto utilizando **Invoke-Command**
```powershell
Invoke-Command -ComputerName 10.0.0.11 -Credential (Get-Credential) -ScriptBlock { # COMANDOS A ENVIAR # Get-Content env:computername }
```

Si en lugar de enviar comandos, queremos **iniciar una sesión**:
```powershell
Enter-PSSession -ComputerName 10.0.0.11 -Credential ( Get-Credential )
```



# Práctica:
Preparar nuestra versión core para poder administrarla desde la versión escritorio y nuestra máquina host.

W2019 con escritorio: 
```
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "172.25.0.62"
```

Equipo Host:
```
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "172.25.0.61"
```
Tuve que poner winrm quickconfig para activar el servicio.