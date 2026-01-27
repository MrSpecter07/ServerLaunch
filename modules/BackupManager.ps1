# Backup Manager Module
# Realiza copias de seguridad periodicas del servidor

class BackupManager {
    [string]$RootBackupPath
    [System.Timers.Timer]$Timer
    [scriptblock]$LogHandler
    [string]$CurrentServerName
    [string]$CurrentServerPath
    [int]$IntervalMinutes = 60

    BackupManager([string]$rootBackupPath, [scriptblock]$logHandler) {
        $this.RootBackupPath = $rootBackupPath
        $this.LogHandler = $logHandler
        if (-not (Test-Path $this.RootBackupPath)) {
            New-Item -ItemType Directory -Path $this.RootBackupPath -Force | Out-Null
        }
    }

    [void]Start([string]$serverName, [string]$serverPath, [int]$intervalMinutes) {
        $this.Stop()
        $this.CurrentServerName = $serverName
        $this.CurrentServerPath = $serverPath
        $this.IntervalMinutes = $intervalMinutes

        $this.Timer = New-Object System.Timers.Timer
        $this.Timer.Interval = [double]($intervalMinutes * 60 * 1000)
        $this.Timer.AutoReset = $true
        $this.Timer.Enabled = $true

        $handler = $this.LogHandler
        $self = $this
        $this.Timer.add_Elapsed({
            $self.RunBackup()
        })

        & $this.LogHandler "[BACKUP] Auto-backup cada $intervalMinutes min activo"
        $this.RunBackup() # realizar primera copia al activar
    }

    [void]Stop() {
        if ($this.Timer) {
            $this.Timer.Stop()
            $this.Timer.Dispose()
            $this.Timer = $null
            if ($this.LogHandler) { & $this.LogHandler "[BACKUP] Programa detenido" }
        }
    }
    
    [string[]]GetBackupList() {
        $safeName = $this.CurrentServerName -replace '[\\/:*?"<>|]', '_'
        $targetRoot = Join-Path $this.RootBackupPath $safeName
        if (Test-Path $targetRoot) {
            $backups = Get-ChildItem -Path $targetRoot -Directory | Sort-Object Name -Descending
            return $backups.Name
        }
        return @()
    }
    
    [bool]RestoreBackup([string]$backupName) {
        if (-not $this.CurrentServerPath) { return $false }
        $safeName = $this.CurrentServerName -replace '[\\/:*?"<>|]', '_'
        $serverBackupRoot = Join-Path $this.RootBackupPath $safeName
        $backupPath = Join-Path $serverBackupRoot $backupName
        
        if (-not (Test-Path $backupPath)) {
            if ($this.LogHandler) { & $this.LogHandler "[BACKUP] Backup no encontrado: $backupName" }
            return $false
        }
        
        try {
            $itemsToRestore = @("world", "world_nether", "world_the_end", "config")
            foreach ($item in $itemsToRestore) {
                $source = Join-Path $backupPath $item
                $target = Join-Path $this.CurrentServerPath $item
                
                if (Test-Path $source) {
                    if (Test-Path $target) {
                        Remove-Item -Path $target -Recurse -Force -ErrorAction SilentlyContinue
                    }
                    Copy-Item -Path $source -Destination $target -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
            if ($this.LogHandler) { & $this.LogHandler "[BACKUP] Restauracion completada desde $backupName" }
            return $true
        }
        catch {
            if ($this.LogHandler) { & $this.LogHandler "[BACKUP][ERROR] $_" }
            return $false
        }
    }

    [void]RunBackup() {
        if (-not $this.CurrentServerPath) { return }
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $safeName = $this.CurrentServerName -replace '[\\/:*?"<>|]', '_'
        $targetRoot = Join-Path $this.RootBackupPath $safeName
        $targetPath = Join-Path $targetRoot $timestamp

        try {
            if (-not (Test-Path $targetRoot)) { New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null }
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null | Out-Null

            $itemsToCopy = @("world", "world_nether", "world_the_end", "server.properties", "config")
            foreach ($item in $itemsToCopy) {
                $source = Join-Path $this.CurrentServerPath $item
                if (Test-Path $source) {
                    Copy-Item -Path $source -Destination $targetPath -Recurse -Force -ErrorAction SilentlyContinue
                }
            }
            if ($this.LogHandler) { & $this.LogHandler "[BACKUP] Copia creada en $timestamp" }
        }
        catch {
            if ($this.LogHandler) { & $this.LogHandler "[BACKUP][ERROR] $_" }
        }
    }
}
