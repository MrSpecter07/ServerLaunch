# Schedule Manager Module
# Gestiona tareas programadas de Windows y horarios del servidor

class ScheduleManager {
    [string]$ServerPath
    [string]$TaskName = "ServerLaunchAutoStart"
    [string]$ScheduleFile
    [hashtable]$Schedule = @{}
    
    ScheduleManager([string]$serverPath) {
        $this.ServerPath = $serverPath
        $this.ScheduleFile = Join-Path $this.ServerPath "config\schedule.json"
        $this.LoadSchedule()
    }
    
    hidden [hashtable]ConvertToHashtable([object]$obj) {
        if ($obj -is [System.Collections.IDictionary]) {
            return [hashtable]$obj
        }
        $table = @{}
        if ($null -ne $obj) {
            $obj.PSObject.Properties | ForEach-Object { $table[$_.Name] = $_.Value }
        }
        return $table
    }

    [void]EnsureScheduleDirectory() {
        $dir = Split-Path $this.ScheduleFile -Parent
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
    
    [void]LoadSchedule() {
        $this.EnsureScheduleDirectory()
        
        if (Test-Path $this.ScheduleFile) {
            try {
                $data = Get-Content $this.ScheduleFile -Raw | ConvertFrom-Json
                $this.Schedule = $this.ConvertToHashtable($data)
                Write-Host "Horario cargado correctamente" -ForegroundColor Green
            }
            catch {
                Write-Host "Error cargando horario: $_" -ForegroundColor Yellow
                $this.Schedule = @{
                    "autoStartEnabled" = $false
                    "startHour" = 8
                    "startMinute" = 0
                    "stopHour" = 23
                    "stopMinute" = 30
                }
            }
        }
        else {
            $this.Schedule = @{
                "autoStartEnabled" = $false
                "startHour" = 8
                "startMinute" = 0
                "stopHour" = 23
                "stopMinute" = 30
            }
        }
    }
    
    [void]SaveSchedule() {
        $this.EnsureScheduleDirectory()
        try {
            $this.Schedule | ConvertTo-Json -Depth 4 | Set-Content $this.ScheduleFile
            Write-Host "Horario guardado correctamente" -ForegroundColor Green
        }
        catch {
            Write-Host "Error guardando horario: $_" -ForegroundColor Red
        }
    }
    
    [void]EnableBootAutoStart() {
        # Crear tarea programada de Windows para iniciar con el sistema
        $startScript = $null
        $runPs1 = Join-Path $this.ServerPath "run.ps1"
        $runBat = Join-Path $this.ServerPath "run.bat"
        if (Test-Path $runPs1) {
            $startScript = $runPs1
        }
        elseif (Test-Path $runBat) {
            $startScript = $runBat
        }
        else {
            Write-Host "No se encontró script de inicio en el servidor" -ForegroundColor Yellow
            return
        }
        
        $action = New-ScheduledTaskAction `
            -Execute "powershell.exe" `
            -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$startScript`""
        
        $trigger = New-ScheduledTaskTrigger -AtStartup
        
        try {
            $task = Get-ScheduledTask -TaskName $this.TaskName -ErrorAction SilentlyContinue
            
            if ($task) {
                Unregister-ScheduledTask -TaskName $this.TaskName -Confirm:$false
            }
            
            Register-ScheduledTask `
                -TaskName $this.TaskName `
                -Action $action `
                -Trigger $trigger `
                -RunLevel Highest `
                -Force -ErrorAction SilentlyContinue | Out-Null
            
            Write-Host "Tarea de inicio automático registrada" -ForegroundColor Green
            
            $this.Schedule["autoStartEnabled"] = $true
            $this.SaveSchedule()
        }
        catch {
            Write-Host "Error registrando tarea de inicio: $_" -ForegroundColor Red
        }
    }
    
    [void]DisableBootAutoStart() {
        try {
            $task = Get-ScheduledTask -TaskName $this.TaskName -ErrorAction SilentlyContinue
            
            if ($task) {
                Unregister-ScheduledTask -TaskName $this.TaskName -Confirm:$false
                Write-Host "Tarea de inicio automático deshabilitada" -ForegroundColor Green
            }
            
            $this.Schedule["autoStartEnabled"] = $false
            $this.SaveSchedule()
        }
        catch {
            Write-Host "Error deshabilitando tarea de inicio: $_" -ForegroundColor Red
        }
    }
    
    [bool]IsBootAutoStartEnabled() {
        $task = Get-ScheduledTask -TaskName $this.TaskName -ErrorAction SilentlyContinue
        return $null -ne $task
    }
    
    [void]SetOperatingHours([int]$startHour, [int]$startMinute, [int]$stopHour, [int]$stopMinute) {
        $this.Schedule["startHour"] = $startHour
        $this.Schedule["startMinute"] = $startMinute
        $this.Schedule["stopHour"] = $stopHour
        $this.Schedule["stopMinute"] = $stopMinute
        
        $this.SaveSchedule()
        Write-Host "Horarios de funcionamiento actualizados" -ForegroundColor Green
    }
    
    [hashtable]GetOperatingHours() {
        return @{
            "startTime" = "{0:D2}:{1:D2}" -f $this.Schedule["startHour"], $this.Schedule["startMinute"]
            "stopTime" = "{0:D2}:{1:D2}" -f $this.Schedule["stopHour"], $this.Schedule["stopMinute"]
        }
    }
    
    [bool]IsWithinOperatingHours() {
        $now = Get-Date
        $startTime = [datetime]::Parse("{0:D2}:{1:D2}" -f $this.Schedule["startHour"], $this.Schedule["startMinute"])
        $stopTime = [datetime]::Parse("{0:D2}:{1:D2}" -f $this.Schedule["stopHour"], $this.Schedule["stopMinute"])
        
        $currentTime = $now.TimeOfDay
        $startTimeOfDay = $startTime.TimeOfDay
        $stopTimeOfDay = $stopTime.TimeOfDay
        
        return $currentTime -ge $startTimeOfDay -and $currentTime -le $stopTimeOfDay
    }
}
