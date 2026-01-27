# Voice Chat Manager Module
# Detecta y configura VoiceChat (Plasmo mod o VoiceChat mod)

class VoiceChatManager {
    [string]$ServerPath
    [string]$VoiceChatType = "none"
    [hashtable]$VoiceChatConfig = @{}
    
    VoiceChatManager([string]$serverPath) {
        $this.ServerPath = $serverPath
        try {
            $this.DetectVoiceChat()
        }
        catch {
            Write-Host "Error detectando VoiceChat: $_" -ForegroundColor Yellow
        }
    }
    
    [void]DetectVoiceChat() {
        $modsPath = Join-Path $this.ServerPath "mods"
        $configPath = Join-Path $this.ServerPath "config"
        
        # Buscar archivos de VoiceChat
        if (Test-Path $modsPath) {
            $voicechatMod = Get-ChildItem $modsPath -Filter "*voicechat*" -ErrorAction SilentlyContinue
            if ($voicechatMod) {
                $this.VoiceChatType = "voicechat_mod"
                Write-Host "Detectado: VoiceChat Mod" -ForegroundColor Green
            }
            
            $plasmoMod = Get-ChildItem $modsPath -Filter "*plasmo*" -ErrorAction SilentlyContinue
            if ($plasmoMod) {
                $this.VoiceChatType = "plasmo"
                Write-Host "Detectado: Plasmo VoiceChat" -ForegroundColor Green
            }
        }
        
        # Buscar configuración existente
        if (Test-Path $configPath) {
            $configEntries = Get-ChildItem $configPath -Filter "*voicechat*" -File -ErrorAction SilentlyContinue
            if ($configEntries) {
                $firstMatch = $configEntries | Select-Object -First 1
                $this.LoadVoiceChatConfig($firstMatch.FullName)
            }
        }
    }
    
    [void]LoadVoiceChatConfig([string]$configFile) {
        try {
            $content = Get-Content $configFile -Raw
            # Parsear configuración según formato (JSON o TOML)
            $this.VoiceChatConfig = @{
                "path" = $configFile
                "content" = $content
            }
            Write-Host "Configuración de VoiceChat cargada" -ForegroundColor Green
        }
        catch {
            Write-Host "Error cargando config de VoiceChat: $_" -ForegroundColor Red
        }
    }
    
    [bool]IsVoiceChatAvailable() {
        return $this.VoiceChatType -ne "none"
    }
    
    [string]GetVoiceChatType() {
        return $this.VoiceChatType
    }
    
    [void]ConfigureVoiceChat([hashtable]$settings) {
        switch ($this.VoiceChatType) {
            "voicechat_mod" {
                $this.ConfigureVoiceChatMod($settings)
            }
            "plasmo" {
                $this.ConfigurePlasmoChatMod($settings)
            }
            default {
                Write-Host "Tipo de VoiceChat no reconocido o no disponible" -ForegroundColor Yellow
            }
        }
    }
    
    [void]ConfigureVoiceChatMod([hashtable]$settings) {
        $configPath = Join-Path $this.ServerPath "config\voicechat-server.toml"
        
        if (Test-Path $configPath) {
            try {
                $content = Get-Content $configPath -Raw
                
                # Actualizar configuraciones
                if ($settings.ContainsKey("enabled")) {
                    $content = $content -replace 'enabled\s*=\s*.*', "enabled = $($settings['enabled'])"
                }
                
                Set-Content $configPath -Value $content
                Write-Host "VoiceChat Mod configurado correctamente" -ForegroundColor Green
            }
            catch {
                Write-Host "Error configurando VoiceChat Mod: $_" -ForegroundColor Red
            }
        }
    }
    
    [void]ConfigurePlasmoChatMod([hashtable]$settings) {
        $configPath = Join-Path $this.ServerPath "config\plasmo_voice_common.toml"
        
        if (Test-Path $configPath) {
            try {
                $content = Get-Content $configPath -Raw
                
                # Actualizar configuraciones de Plasmo
                if ($settings.ContainsKey("enabled")) {
                    $content = $content -replace 'enabled\s*=\s*.*', "enabled = $($settings['enabled'])"
                }
                
                Set-Content $configPath -Value $content
                Write-Host "Plasmo VoiceChat configurado correctamente" -ForegroundColor Green
            }
            catch {
                Write-Host "Error configurando Plasmo VoiceChat: $_" -ForegroundColor Red
            }
        }
    }
}
