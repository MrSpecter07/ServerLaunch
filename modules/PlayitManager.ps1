# PlayIT Manager Module
# Gestiona la conexión automática a PlayIT

class PlayitManager {
    [string]$PlayitPath
    [string]$PlayitExe
    [bool]$IsConnected = $false
    [System.Diagnostics.Process]$Process
    
    PlayitManager() {
        $this.FindPlayit()
    }
    
    [void]FindPlayit() {
        # Buscar PlayIT en rutas comunes
        $possiblePaths = @(
            "$env:APPDATA\playit",
            "$env:PROGRAMFILES\playit",
            "$env:PROGRAMFILES(x86)\playit",
            "$env:LOCALAPPDATA\playit"
        )
        
        foreach ($path in $possiblePaths) {
            if (Test-Path "$path\playit.exe") {
                $this.PlayitPath = $path
                $this.PlayitExe = "$path\playit.exe"
                Write-Host "PlayIT encontrado en: $($this.PlayitExe)" -ForegroundColor Green
                return
            }
        }
        
        Write-Host "PlayIT no encontrado en rutas estándar" -ForegroundColor Yellow
    }
    
    [bool]IsPlayitInstalled() {
        return (Test-Path $this.PlayitExe)
    }
    
    [void]LaunchPlayit([scriptblock]$onOutput) {
        if ($this.IsPlayitInstalled()) {
            try {
                $psi = New-Object System.Diagnostics.ProcessStartInfo
                $psi.FileName = $this.PlayitExe
                $psi.WorkingDirectory = $this.PlayitPath
                $psi.UseShellExecute = $false
                $psi.RedirectStandardOutput = $true
                $psi.RedirectStandardError = $true
                $psi.CreateNoWindow = $true

                $proc = New-Object System.Diagnostics.Process
                $proc.StartInfo = $psi
                $proc.EnableRaisingEvents = $true
                if ($onOutput) {
                    $handler = $onOutput
                    $proc.add_OutputDataReceived({ param($s,$e) if ($e.Data) { & $handler "[PLAYIT] $($e.Data)" } })
                    $proc.add_ErrorDataReceived({ param($s,$e) if ($e.Data) { & $handler "[PLAYIT][ERR] $($e.Data)" } })
                }

                $started = $proc.Start()
                if ($started -and $onOutput) {
                    $proc.BeginOutputReadLine()
                    $proc.BeginErrorReadLine()
                }

                $this.Process = $proc
                Start-Sleep -Seconds 2
                $this.IsConnected = $true
                Write-Host "PlayIT iniciado correctamente" -ForegroundColor Green
            }
            catch {
                Write-Host "Error al iniciar PlayIT: $_" -ForegroundColor Red
                $this.IsConnected = $false
            }
        }
        else {
            Write-Host "PlayIT no está instalado" -ForegroundColor Red
        }
    }
    
    [string]GetPlayitInfo() {
        if ($this.IsPlayitInstalled()) {
            try {
                $output = & $this.PlayitExe info 2>&1
                return $output
            }
            catch {
                return "Error obteniendo información de PlayIT"
            }
        }
        return "PlayIT no está disponible"
    }
    
    [string]EnableServerTunnel([string]$serverPort) {
        if ($this.IsPlayitInstalled()) {
            try {
                # Habilitar túnel para el puerto del servidor
                $output = & $this.PlayitExe tunnel add --protocol udp --local-addr localhost:$serverPort 2>&1
                Write-Host "Túnel activado para puerto $serverPort" -ForegroundColor Green
                return $output
            }
            catch {
                Write-Host "Error habilitando túnel: $_" -ForegroundColor Red
                return $null
            }
        }
        return $null
    }
}
