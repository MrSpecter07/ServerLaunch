# Auto Shutdown Manager Module
# Gestiona el apagado automático del servidor

class AutoShutdownManager {
    [string]$ServerPath
    [string]$ShutdownScriptPath
    [bool]$IsEnabled = $false
    [int]$IdleMinutes = 30
    [datetime]$ScheduledTime
    [System.Timers.Timer]$Monitor
    [scriptblock]$OnShutdown
    
    AutoShutdownManager([string]$serverPath) {
        $this.ServerPath = $serverPath
        $this.ShutdownScriptPath = Join-Path $serverPath "auto_shutdown.ps1"
        $this.CheckExistingShutdown()
    }
    
    [void]CheckExistingShutdown() { }
    
    [void]EnableAutoShutdown([int]$idleMinutes, [scriptblock]$onShutdown) {
        $this.IdleMinutes = $idleMinutes
        $this.OnShutdown = $onShutdown
        $this.StartMonitoring()
    }
    
    [void]StartMonitoring() {
        $this.StopMonitoring()
        $timer = New-Object System.Timers.Timer
        $timer.Interval = 60 * 1000
        $timer.AutoReset = $true
        $self = $this
        $timer.add_Elapsed({ $self.CheckIdleAndShutdown() })
        $timer.Start()
        $this.Monitor = $timer
        $this.IsEnabled = $true
        Write-Host "Auto-shutdown activo (inactividad: $($this.IdleMinutes) min)" -ForegroundColor Green
    }
    
    [void]StopMonitoring() {
        if ($this.Monitor) {
            $this.Monitor.Stop()
            $this.Monitor.Dispose()
            $this.Monitor = $null
        }
        $this.IsEnabled = $false
    }
    
    [void]CheckIdleAndShutdown() {
        try {
            $logPath = Join-Path $this.ServerPath "logs\latest.log"
            if (Test-Path $logPath) {
                $lastModified = (Get-Item $logPath).LastWriteTime
                $minutes = [math]::Round(((Get-Date) - $lastModified).TotalMinutes)
                if ($minutes -ge $this.IdleMinutes) {
                    if ($this.OnShutdown) { & $this.OnShutdown }
                    $this.StopMonitoring()
                }
            }
        }
        catch { }
    }
    
    [void]DisableAutoShutdown() {
        $this.StopMonitoring()
        Write-Host "Auto-shutdown deshabilitado" -ForegroundColor Green
    }
    
    [void]SetScheduledShutdown([datetime]$shutdownTime) {
        $this.ScheduledTime = $shutdownTime
        $script = @"
# Scheduled Shutdown Script
`$ShutdownTime = [datetime]"$($shutdownTime.ToString('yyyy-MM-dd HH:mm:ss'))"
`$ServerPath = "$($this.ServerPath)"

while ((Get-Date) -lt `$ShutdownTime) {
    Start-Sleep -Seconds 60
}

# Ejecutar el apagado
Add-Content "`$ServerPath\server_commands.txt" -Value "stop"
Write-Host "Servidor apagado según horario programado"
"@
        
        Set-Content $this.ShutdownScriptPath -Value $script
        $this.IsEnabled = $true
        Write-Host "Apagado programado para: $($shutdownTime.ToString())" -ForegroundColor Green
    }
}
