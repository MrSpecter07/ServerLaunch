# Configuration Helper Script
# Script auxiliar para configuración avanzada

function Backup-ServerConfig {
    param(
        [string]$ServerPath,
        [string]$BackupPath = "$ServerPath\backups"
    )
    
    if (-not (Test-Path $BackupPath)) {
        New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $backupName = "backup_$timestamp"
    $backupFullPath = Join-Path $BackupPath $backupName
    
    try {
        # Copiar configuración importante
        $configItems = @(
            "server.properties",
            "ops.json",
            "whitelist.json",
            "config"
        )
        
        foreach ($item in $configItems) {
            $itemPath = Join-Path $ServerPath $item
            if (Test-Path $itemPath) {
                Copy-Item -Path $itemPath -Destination $backupFullPath -Recurse -Force
            }
        }
        
        Write-Host "✅ Backup realizado: $backupName" -ForegroundColor Green
        return $backupFullPath
    }
    catch {
        Write-Host "❌ Error en backup: $_" -ForegroundColor Red
        return $null
    }
}

function Restore-ServerConfig {
    param(
        [string]$BackupPath,
        [string]$ServerPath
    )
    
    try {
        $configItems = @(
            "server.properties",
            "ops.json",
            "whitelist.json",
            "config"
        )
        
        foreach ($item in $configItems) {
            $itemPath = Join-Path $BackupPath $item
            $targetPath = Join-Path $ServerPath $item
            
            if (Test-Path $itemPath) {
                if (Test-Path $targetPath) {
                    Remove-Item -Path $targetPath -Recurse -Force
                }
                Copy-Item -Path $itemPath -Destination $targetPath -Recurse -Force
            }
        }
        
        Write-Host "✅ Restauración completada" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error en restauración: $_" -ForegroundColor Red
        return $false
    }
}

function Test-ServerConnectivity {
    param(
        [string]$ServerHost = "localhost",
        [int]$ServerPort = 25565,
        [int]$Timeout = 5
    )
    
    try {
        $socket = New-Object System.Net.Sockets.TcpClient
        $asyncResult = $socket.BeginConnect($ServerHost, $ServerPort, $null, $null)
        $asyncResult.AsyncWaitHandle.WaitOne($Timeout * 1000) | Out-Null
        
        if ($socket.Connected) {
            $socket.Close()
            Write-Host "✅ Servidor conectado en $ServerHost`:$ServerPort" -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "❌ No se puede conectar a $ServerHost`:$ServerPort" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Error de conectividad: $_" -ForegroundColor Red
        return $false
    }
}

function Get-ServerMemoryUsage {
    $javaProcesses = Get-Process -Name java, javaw -ErrorAction SilentlyContinue
    
    if ($javaProcesses) {
        foreach ($process in $javaProcesses) {
            $memoryMB = [math]::Round($process.WorkingSet / 1MB, 2)
            Write-Host "Proceso Java PID $($process.Id): $memoryMB MB" -ForegroundColor Cyan
        }
        return $true
    }
    else {
        Write-Host "No hay procesos Java en ejecución" -ForegroundColor Yellow
        return $false
    }
}

function Enable-PlayitVoiceIntegration {
    param(
        [string]$PlayitToken,
        [string]$ServerPath
    )
    
    try {
        $configPath = Join-Path $ServerPath "config\playit_voice.json"
        
        $config = @{
            "enabled" = $true
            "token" = $PlayitToken
            "autoConnect" = $true
            "logLevel" = "INFO"
        }
        
        $config | ConvertTo-Json | Set-Content $configPath -Force
        
        Write-Host "✅ Integración PlayIT Voice habilitada" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error configurando PlayIT Voice: $_" -ForegroundColor Red
        return $false
    }
}

function Get-PlayitTunnelStatus {
    try {
        $playitPath = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
                      Where-Object { $_.DisplayName -match "PlayIT" }).InstallLocation
        
        if ($playitPath -and (Test-Path "$playitPath\playit.exe")) {
            $output = & "$playitPath\playit.exe" status 2>&1
            Write-Host $output -ForegroundColor Green
            return $true
        }
        else {
            Write-Host "PlayIT no encontrado en registro" -ForegroundColor Yellow
            return $false
        }
    }
    catch {
        Write-Host "Error obteniendo estado de PlayIT: $_" -ForegroundColor Red
        return $false
    }
}
