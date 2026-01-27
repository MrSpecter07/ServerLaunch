# Server Manager Module
# Gestiona la detección y ejecución del servidor Minecraft

class ServerManager {
    [string]$ServerPath
    [string]$ServerName
    [bool]$IsRunning = $false
    [string]$RunScript
    [hashtable]$ServerProperties = @{}
    [System.Diagnostics.Process]$Process
    [scriptblock]$OutputHandler
    [System.IO.StreamWriter]$StdinWriter
    [int[]]$ManagedProcessIds = @()
    
    ServerManager([string]$serverPath) {
        $this.ServerPath = $serverPath
        $this.DetectServer()
        $this.LoadServerProperties()
    }
    
    [void]DetectServer() {
        # Usar solo el nombre de la carpeta del servidor, sin MOTD
        $this.ServerName = Split-Path $this.ServerPath -Leaf
        Write-Host "Servidor detectado: $($this.ServerName)" -ForegroundColor Green
    }
    
    [void]LoadServerProperties() {
        $serverPropsPath = Join-Path $this.ServerPath "server.properties"
        
        if (Test-Path $serverPropsPath) {
            $content = Get-Content $serverPropsPath
            foreach ($line in $content) {
                if ($line -and -not $line.StartsWith("#")) {
                    $parts = $line -split "="
                    if ($parts.Count -eq 2) {
                        $this.ServerProperties[$parts[0].Trim()] = $parts[1].Trim()
                    }
                }
            }
        }
    }
    
    [string]GetServerPort() {
        if ($this.ServerProperties.ContainsKey("server-port") -and $this.ServerProperties["server-port"]) {
            return $this.ServerProperties["server-port"]
        }
        return "25565"
    }
    
    [string]GetMotd() {
        if ($this.ServerProperties.ContainsKey("motd") -and $this.ServerProperties["motd"]) {
            return $this.ServerProperties["motd"]
        }
        return "A Minecraft Server"
    }
    
    [void]StartServer([scriptblock]$onOutput) {
        try {
            # Buscar script de ejecución
            $runBat = Join-Path $this.ServerPath "run.bat"
            $runPs1 = Join-Path $this.ServerPath "run.ps1"
            $runSh = Join-Path $this.ServerPath "run.sh"
            
            $fileToRun = $null
            $arguments = $null
            if (Test-Path $runBat) {
                $this.RunScript = $runBat
                # Parse run.bat to extract java command and add nogui
                $batContent = Get-Content $runBat -Raw
                if ($batContent -match "java\s+(.+)") {
                    $fileToRun = "java"
                    $javaArgs = $matches[1].Trim()
                    # Remove pause, add nogui if not present
                    if ($javaArgs -notmatch "nogui") {
                        $javaArgs = "$javaArgs nogui"
                    }
                    $arguments = $javaArgs
                }
                else {
                    $fileToRun = "cmd.exe"
                    $arguments = "/c `"$($this.RunScript)`" nogui"
                }
            }
            elseif (Test-Path $runPs1) {
                $this.RunScript = $runPs1
                $fileToRun = "powershell.exe"
                $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$($this.RunScript)`""
            }
            elseif (Test-Path $runSh) {
                $this.RunScript = $runSh
                $fileToRun = "bash"
                $arguments = "`"$($this.RunScript)`""
            }
            else {
                Write-Host "No se encontró script de ejecución" -ForegroundColor Red
                return
            }

            $psi = New-Object System.Diagnostics.ProcessStartInfo
            $psi.FileName = $fileToRun
            $psi.Arguments = $arguments
            $psi.WorkingDirectory = $this.ServerPath
            $psi.UseShellExecute = $false
            $psi.RedirectStandardOutput = $true
            $psi.RedirectStandardError = $true
            $psi.RedirectStandardInput = $true
            $psi.CreateNoWindow = $true

            $proc = New-Object System.Diagnostics.Process
            $proc.StartInfo = $psi
            $proc.EnableRaisingEvents = $true
            $this.OutputHandler = $onOutput

            if ($onOutput) {
                $handler = $onOutput
                $proc.add_OutputDataReceived({ param($s,$e) if ($e.Data) { & $handler "[SERVER] $($e.Data)" } })
                $proc.add_ErrorDataReceived({ param($s,$e) if ($e.Data) { & $handler "[SERVER][ERR] $($e.Data)" } })
            }

            $started = $proc.Start()
            if ($started) {
                $this.ManagedProcessIds += $proc.Id
                $this.StdinWriter = $proc.StandardInput
                if ($onOutput) {
                    $proc.BeginOutputReadLine()
                    $proc.BeginErrorReadLine()
                }
            }

            $this.Process = $proc
            $this.IsRunning = $true
            Write-Host "Servidor iniciado correctamente" -ForegroundColor Green
        }
        catch {
            Write-Host "Error iniciando servidor: $_" -ForegroundColor Red
            $this.IsRunning = $false
        }
    }
    
    [void]StopServer() {
        try {
            if ($this.Process -and -not $this.Process.HasExited) {
                Write-Host "Enviando comando stop al servidor..." -ForegroundColor Yellow
                
                # Send stop command via stdin
                $this.SendCommand("stop")
                
                # Wait up to 30 seconds for graceful shutdown
                $waited = 0
                $maxWait = 30
                while (-not $this.Process.HasExited -and $waited -lt $maxWait) {
                    Start-Sleep -Milliseconds 500
                    $waited += 0.5
                    if ($waited % 5 -eq 0) {
                        Write-Host "Esperando cierre del servidor... ($waited/$maxWait seg)" -ForegroundColor Yellow
                    }
                }
                
                # Force kill if still running after timeout
                if (-not $this.Process.HasExited) {
                    Write-Host "Servidor no responde. Terminando proceso forzosamente..." -ForegroundColor Red
                    $this.Process.Kill()
                    Start-Sleep -Seconds 1
                }
                
                Write-Host "Servidor detenido correctamente" -ForegroundColor Green
            }
            
            # Cleanup
            if ($this.StdinWriter) {
                try { $this.StdinWriter.Close() } catch { }
                $this.StdinWriter = $null
            }
            
            if ($this.Process) {
                try { $this.Process.Close() } catch { }
                $this.Process = $null
            }
             
            $this.IsRunning = $false
        }
        catch {
            Write-Host "Error deteniendo servidor: $_" -ForegroundColor Red
        }
    }
    
    [void]SendCommand([string]$command) {
        try {
            if ($this.StdinWriter -and -not $this.StdinWriter.BaseStream.CanWrite) {
                Write-Host "No se puede enviar comando: stream cerrado" -ForegroundColor Yellow
                return
            }
            if ($this.Process -and -not $this.Process.HasExited -and $this.StdinWriter) {
                $this.StdinWriter.WriteLine($command)
                $this.StdinWriter.Flush()
            }
        }
        catch {
            Write-Host "Error enviando comando: $_" -ForegroundColor Red
        }
    }
    
    [void]KillAllProcesses() {
        $allJavaProcesses = Get-Process -Name java, javaw -ErrorAction SilentlyContinue
        
        foreach ($proc in $allJavaProcesses) {
            try {
                $proc.Kill()
                Write-Host "Proceso Java PID $($proc.Id) terminado" -ForegroundColor Yellow
            }
            catch {}
        }
        
        $this.ManagedProcessIds = @()
        $this.IsRunning = $false
    }
    
    [bool]CheckIfRunning() {
        $processNames = @("java", "javaw")
        
        foreach ($procName in $processNames) {
            $processes = Get-Process -Name $procName -ErrorAction SilentlyContinue | 
                Where-Object { $_.CommandLine -like "*$($this.ServerPath)*" }
            
            if ($processes) {
                $this.IsRunning = $true
                return $true
            }
        }
        
        $this.IsRunning = $false
        return $false
    }
    
    [string[]]GetRecentLogs([int]$lines = 50) {
        $logFile = Join-Path $this.ServerPath "logs\latest.log"
        
        if (Test-Path $logFile) {
            return @(Get-Content $logFile -Tail $lines)
        }
        
        return @("No logs available")
    }
}
