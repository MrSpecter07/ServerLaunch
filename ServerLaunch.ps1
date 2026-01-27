# ServerLaunch v2.0 - Gestor Universal de Servidores
# GUI Principal con pestañas - Rehecho desde cero

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Importar módulos
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulePath = Join-Path $scriptPath "modules"

Get-ChildItem -Path $modulePath -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

# GUI Principal con Tab Control
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="ServerLaunch" Width="700" Height="750"
        FontFamily="Segoe UI"
        Background="#1E1E1E" Foreground="#E0E0E0"
        WindowStartupLocation="CenterScreen">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        
        <!-- Header -->
        <Grid Grid.Row="0" Background="#2D2D2D" Margin="20,20,20,10">
            <StackPanel>
                <TextBlock x:Name="HeaderTitle" Text="SERVER LAUNCH" FontSize="20" FontWeight="Bold" Foreground="#4CAF50"/>
                <TextBlock x:Name="HeaderSubtitle" Text="Gestor de Servidores Minecraft" FontSize="11" Foreground="#888888"/>
            </StackPanel>
        </Grid>
        
        <!-- TabControl -->
        <TabControl Grid.Row="1" Background="#1E1E1E" BorderThickness="0" Margin="20,0,20,20">
            <TabControl.Resources>
                <Style TargetType="TabItem">
                    <Setter Property="Background" Value="#2D2D2D"/>
                    <Setter Property="Foreground" Value="#E0E0E0"/>
                    <Setter Property="Padding" Value="20,10"/>
                    <Setter Property="FontWeight" Value="Bold"/>
                    <Setter Property="FontSize" Value="13"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="TabItem">
                                <Border Name="Border" Background="{TemplateBinding Background}" 
                                        BorderThickness="0,0,0,3" BorderBrush="Transparent" Padding="{TemplateBinding Padding}" Margin="2,0">
                                    <ContentPresenter ContentSource="Header" HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter TargetName="Border" Property="Background" Value="#1E1E1E"/>
                                        <Setter TargetName="Border" Property="BorderBrush" Value="#4CAF50"/>
                                        <Setter Property="Foreground" Value="White"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
            </TabControl.Resources>
            
            <!-- Tab: Principal -->
            <TabItem Header="Principal">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        <!-- Servidor -->
                        <TextBlock x:Name="LblServer" Text="Servidor" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="ServerPath" Width="400" Height="35" Padding="10" 
                                     Background="#3C3C3C" Foreground="White" IsReadOnly="True"/>
                            <Button x:Name="BrowseServer" Content="Examinar" Width="100" Height="35" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold"
                                    Margin="10,0,0,0" Cursor="Hand"/>
                        </StackPanel>
                        
                        <!-- PlayIT -->
                        <TextBlock x:Name="LblPlayit" Text="PlayIT (Opcional)" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="PlayitPath" Width="400" Height="35" Padding="10" 
                                     Background="#3C3C3C" Foreground="White" IsReadOnly="True"/>
                            <Button x:Name="BrowsePlayit" Content="Examinar" Width="100" Height="35" 
                                    Background="#2196F3" Foreground="White" FontWeight="Bold"
                                    Margin="10,0,0,0" Cursor="Hand"/>
                        </StackPanel>
                        
                        <!-- Controles -->
                        <TextBlock x:Name="LblServerControl" Text="Control del Servidor" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,15">
                            <Button x:Name="StartBtn" Content="Iniciar" Width="110" Height="40" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold" Margin="0,0,10,0" Cursor="Hand"/>
                            <Button x:Name="StopBtn" Content="Detener" Width="110" Height="40" 
                                    Background="#FF6B6B" Foreground="White" FontWeight="Bold" Margin="0,0,10,0" Cursor="Hand"/>
                            <Button x:Name="RestartBtn" Content="Reiniciar" Width="110" Height="40" 
                                    Background="#FFB74D" Foreground="White" FontWeight="Bold" Margin="0,0,10,0" Cursor="Hand"/>
                            <Button x:Name="KillProcessBtn" Content="Terminar" Width="110" Height="40" 
                                    Background="#9C27B0" Foreground="White" FontWeight="Bold" Cursor="Hand"/>
                        </StackPanel>
                        
                        <!-- Backups -->
                        <TextBlock x:Name="LblBackups" Text="Backups" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <ComboBox x:Name="BackupSelect" Width="350" Height="32" Background="#000000" 
                                      Foreground="White" Padding="8" Margin="0,0,10,0" BorderBrush="#555555" BorderThickness="1">
                                <ComboBox.ItemContainerStyle>
                                    <Style TargetType="ComboBoxItem">
                                        <Setter Property="Foreground" Value="White"/>
                                        <Setter Property="Background" Value="#000000"/>
                                    </Style>
                                </ComboBox.ItemContainerStyle>
                            </ComboBox>
                            <Button x:Name="RestoreBackupBtn" Content="Restaurar" Width="90" Height="32" 
                                    Background="#FF9800" Foreground="White" FontWeight="Bold" Cursor="Hand"/>
                        </StackPanel>
                        
                        <!-- Estado -->
                        <TextBlock x:Name="LblStatus" Text="Estado" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <TextBlock x:Name="StatusText" Text="Estado: No configurado" FontSize="12" Foreground="#FFB74D" Margin="0,0,0,20"/>
                        
                        <!-- Consola -->
                        <TextBlock x:Name="LblConsole" Text="Consola" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <Border Background="#0D0D0D" BorderBrush="#3C3C3C" BorderThickness="1" Padding="10" Margin="0,0,0,10">
                            <ScrollViewer x:Name="ConsoleScroll" Height="200" VerticalScrollBarVisibility="Auto">
                                <TextBox x:Name="OutputBox" Background="Transparent" Foreground="#00FF00" 
                                         FontFamily="Consolas" FontSize="10" BorderThickness="0" 
                                         IsReadOnly="True" TextWrapping="Wrap" AcceptsReturn="True"/>
                            </ScrollViewer>
                        </Border>
                        <Button x:Name="ClearLog" Content="Limpiar Consola" Width="150" Height="30" 
                                Background="#555555" Foreground="White" FontWeight="Bold" 
                                HorizontalAlignment="Left" Cursor="Hand" Margin="0,0,0,10"/>
                        
                        <!-- Jugadores Online -->
                        <TextBlock x:Name="LblPlayersOnline" Text="Jugadores Online" FontSize="13" FontWeight="Bold" Margin="0,10,0,8"/>
                        <Border Background="#2D2D2D" BorderBrush="#3C3C3C" BorderThickness="1" Padding="15" CornerRadius="5">
                            <TextBlock x:Name="PlayersBox" Text="Nadie conectado" FontSize="11" Foreground="#888888" TextWrapping="Wrap"/>
                        </Border>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>
            
            <!-- Tab: PlayIT -->
            <TabItem Header="PlayIT">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        
                        <TextBlock x:Name="LblIPServer" Text="IP Server" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="PlayitMinecraftIP" Width="400" Height="35" Padding="10" 
                                     Background="#3C3C3C" Foreground="White" IsReadOnly="True" Text="No detectado"/>
                            <Button x:Name="CopyMinecraftIP" Content="Copiar" Width="100" Height="35" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold"
                                    Margin="10,0,0,0" Cursor="Hand"/>
                        </StackPanel>
                        
                        <TextBlock x:Name="LblIPVoicechat" Text="IP Voicechat" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="PlayitVoicechatIP" Width="400" Height="35" Padding="10" 
                                     Background="#3C3C3C" Foreground="White" IsReadOnly="True" Text="No detectado"/>
                            <Button x:Name="CopyVoicechatIP" Content="Copiar" Width="100" Height="35" 
                                    Background="#2196F3" Foreground="White" FontWeight="Bold"
                                    Margin="10,0,0,0" Cursor="Hand"/>
                        </StackPanel>
                        
                        <Button x:Name="OpenPlayitWeb" Content="Abrir Panel de PlayIT" Width="220" Height="45" 
                                Background="#9C27B0" Foreground="White" FontWeight="Bold" FontSize="14"
                                HorizontalAlignment="Left" Cursor="Hand" Margin="0,10,0,0"/>
                        
                        <TextBlock x:Name="LblPlayitStatus" Text="Estado" FontSize="14" FontWeight="Bold" Margin="0,30,0,10" Foreground="#4CAF50"/>
                        <TextBlock x:Name="PlayitStatus" Text="PlayIT no iniciado" FontSize="12" Foreground="#888888" TextWrapping="Wrap"/>
                        
                    </StackPanel>
                </ScrollViewer>
            </TabItem>

            <!-- Tab: Configuracion -->
            <TabItem Header="Configuracion">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        
                        <!-- Auto-Shutdown -->
                        <TextBlock x:Name="LblAutoShutdown" Text="Auto-Shutdown" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="AutoShutdownCheck" Content="Activar apagado automatico por inactividad" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,30">
                            <TextBlock x:Name="LblIdleMinutes" Text="Minutos inactivo:" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="IdleMinutesBox" Width="80" Height="30" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="30" FontSize="12"/>
                        </StackPanel>
                        
                        <!-- Horarios -->
                        <TextBlock x:Name="LblOperatingHours" Text="Horarios de Operacion" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="StartOnBootCheck" Content="Iniciar servidor al encender PC" 
                                  Foreground="White" Margin="0,0,0,15" FontSize="12"/>
                        <Grid Margin="0,0,0,30">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="120"/>
                                <ColumnDefinition Width="200"/>
                            </Grid.ColumnDefinitions>
                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="15"/>
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            
                            <TextBlock x:Name="LblStartTime" Grid.Row="0" Grid.Column="0" Text="Hora inicio:" VerticalAlignment="Center" FontSize="12"/>
                            <StackPanel Grid.Row="0" Grid.Column="1" Orientation="Horizontal">
                                <TextBox x:Name="StartHourBox" Width="60" Height="30" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="08" FontSize="12"/>
                                <TextBlock Text=":" VerticalAlignment="Center" Margin="5,0" FontSize="14"/>
                                <TextBox x:Name="StartMinBox" Width="60" Height="30" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="00" FontSize="12"/>
                            </StackPanel>
                            
                            <TextBlock x:Name="LblEndTime" Grid.Row="2" Grid.Column="0" Text="Hora fin:" VerticalAlignment="Center" FontSize="12"/>
                            <StackPanel Grid.Row="2" Grid.Column="1" Orientation="Horizontal">
                                <TextBox x:Name="StopHourBox" Width="60" Height="30" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="23" FontSize="12"/>
                                <TextBlock Text=":" VerticalAlignment="Center" Margin="5,0" FontSize="14"/>
                                <TextBox x:Name="StopMinBox" Width="60" Height="30" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="30" FontSize="12"/>
                            </StackPanel>
                        </Grid>
                        
                        <!-- Auto-Backup -->
                        <TextBlock x:Name="LblAutoBackup" Text="Auto-Backup" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="AutoBackupCheck" Content="Activar backup automatico periodico" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBlock x:Name="LblIntervalMin" Text="Intervalo (min):" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="BackupIntervalBox" Width="80" Height="30" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="60" FontSize="12"/>
                        </StackPanel>

                        <!-- Auto Clear Console -->
                        <TextBlock x:Name="LblConsoleSettings" Text="Consola" FontSize="14" FontWeight="Bold" Margin="10,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="AutoClearCheck" Content="Limpiar consola automatico" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                            <TextBlock x:Name="LblEveryMin" Text="Cada (min):" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="AutoClearMinutesBox" Width="80" Height="30" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="0" FontSize="12"/>
                        </StackPanel>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,30">
                            <TextBlock x:Name="LblLineLimit" Text="Limite lineas:" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="AutoClearLinesBox" Width="80" Height="30" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="500" FontSize="12"/>
                        </StackPanel>
                        
                        <!-- Idioma -->
                        <TextBlock x:Name="LblLanguage" Text="Idioma" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <ComboBox x:Name="LanguageSelect" Width="200" Height="35" Background="#3C3C3C" 
                                  Foreground="White" Padding="8" Margin="0,0,0,30" BorderBrush="#555555" BorderThickness="1"
                                  HorizontalAlignment="Left">
                            <ComboBoxItem Content="Espanol" Tag="es"/>
                            <ComboBoxItem Content="English" Tag="en"/>
                        </ComboBox>
                        
                        <Button x:Name="SaveConfigBtn" Content="Guardar Configuracion" Width="220" Height="45" 
                                Background="#4CAF50" Foreground="White" FontWeight="Bold" FontSize="14"
                                HorizontalAlignment="Left" Cursor="Hand"/>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

$window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))

# Variables globales
$script:serverManager = $null
$script:backupManager = $null
$script:scheduleManager = $null
$script:serverProcess = $null
$script:playitProcess = $null
$script:cmdProcess = $null
$script:javaProcess = $null
$script:logTimer = $null
$script:serverLog = ""
$script:playitLog = ""
$script:playitErrLog = ""
$script:serverLastLine = 0
$script:playitLastLine = 0
$script:playitShownTunnel = $false
$script:playitShownIPs = @()
$script:playitMinecraftIP = ""
$script:playitVoicechatIP = ""
$script:playitIPsDetected = $false
$script:autoShutdownEnabled = $false
$script:autoShutdownMinutes = 30
$script:autoBackupEnabled = $false
$script:backupIntervalMinutes = 60
$script:autoClearEnabled = $false
$script:autoClearMinutes = 0
$script:autoClearMaxLines = 500
$script:lastClearTime = Get-Date
$script:consoleStickToBottom = $true
$script:serverState = "idle"  # idle|starting|running|stopping
$script:onlinePlayers = @()
$script:backupNameMap = @{}
$script:lastServerPath = ""
$script:lastServerConfigPath = Join-Path $scriptPath "config\last_server.txt"
$script:currentLanguage = "es"
$script:languageConfigPath = Join-Path $scriptPath "config\language.txt"

$script:translations = @{
    es = @{
        app_title = "SERVER LAUNCH"; app_subtitle = "Gestor de Servidores Minecraft"
        server = "Servidor"; browse = "Examinar"; playit_optional = "PlayIT (Opcional)"
        server_control = "Control del Servidor"; start = "Iniciar"; stop = "Detener"
        restart = "Reiniciar"; terminate = "Terminar"; backups = "Backups"; restore = "Restaurar"
        status = "Estado"; console = "Consola"; clear_console = "Limpiar Consola"
        players_online = "Jugadores Online"; no_players = "Nadie conectado"
        ip_server = "IP Server"; ip_voicechat = "IP Voicechat"; copy = "Copiar"
        open_playit = "Abrir Panel de PlayIT"; playit_status = "Estado"; playit_not_started = "PlayIT no iniciado"
        not_detected = "No detectado"; ips_detected = "IPs detectadas correctamente"
        auto_shutdown = "Auto-Shutdown"; enable_auto_shutdown = "Activar apagado automatico por inactividad"
        idle_minutes = "Minutos inactivo:"; operating_hours = "Horarios de Operacion"
        start_on_boot = "Iniciar servidor al encender PC"; start_time = "Hora inicio:"
        end_time = "Hora fin:"; auto_backup = "Auto-Backup"; enable_auto_backup = "Activar backup automatico periodico"
        interval_min = "Intervalo (min):"; console_settings = "Consola"; auto_clear = "Limpiar consola automatico"
        every_min = "Cada (min):"; line_limit = "Limite lineas:"; language = "Idioma"
        save_config = "Guardar Configuracion"; select_server = "Selecciona un servidor primero"
        error = "Error"; success = "Exito"; info = "Informacion"; select_backup = "Selecciona un backup primero"
        system = "Sistema"; backup = "Backup"; config = "Config"
        detected_server = "Servidor detectado:"; launch_started = "ServerLaunch v2.0 iniciado"
        select_to_start = "Selecciona un servidor para comenzar"; starting_server = "Iniciando servidor..."
        stopping_services = "Deteniendo todos los servicios..."
        stop_flag_created = "Bandera stop_server.flag creada"; stop_sent = "Comando 'stop' enviado"
        waiting_clean_stop = "Esperando apagado limpio (hasta 90s, sin forzar Java)..."
        still_running = "Sigue en ejecucion tras 90s. No se forzo para evitar corrupcion. Usa 'Terminar' si es necesario."
        backup_stopped = "BackupManager detenido"
        all_stopped = "Todos los servicios detenidos correctamente"; restarting = "Reiniciando servidor..."
        killing_java = "Terminando todos los procesos Java..."; java_killed = "Todos los procesos Java terminados"
        processes_killed = "Procesos terminados"; restoring_backup = "Restaurando backup:"
        restore_complete = "Restauracion completada"; restore_failed = "Fallo la restauracion"
        saving_config = "Guardando configuracion..."; config_saved = "Configuracion guardada"
        auto_backup_enabled = "Auto-backup habilitado (cada"; runbat_notfound = "No se encontro run.bat"
        playit_notfound = "PlayIT no encontrado en:"; all_started = "Todos los servicios iniciados correctamente"
        server_running = "Servidor en ejecucion"; server_stopped_status = "Servidor detenido"
        stopping = "Deteniendo..."; still_running_status = "Servidor aun en ejecucion"
        restoring = "Restaurando..."; backup_restored = "Backup restaurado"; error_restoring = "Error al restaurar"
        error_starting = "Error al iniciar"; not_running = "No esta en ejecucion"
        cant_restart = "No se puede reiniciar: no esta corriendo"; player_count = "jugador(es):"
        playit_ip_copied = "IP de Minecraft copiada:"; playit_vc_copied = "IP de Voicechat copiada:"
        no_ip_detected = "No hay IP detectada para copiar"; server_loaded = "Servidor cargado correctamente"
        error_loading = "Error al cargar servidor:"; invalid_path = "Ruta invalida:"
        config_saved_msg = "Configuracion guardada correctamente"; error_saving = "Error al guardar:"
        hours_saved = "Horarios guardados:"; boot_enabled = "Inicio automatico habilitado"
        error_saving_hours = "Error guardando horarios:"; min_short = "min"; lines_short = "lineas"
    }
    en = @{
        app_title = "SERVER LAUNCH"; app_subtitle = "Minecraft Server Manager"
        server = "Server"; browse = "Browse"; playit_optional = "PlayIT (Optional)"
        server_control = "Server Control"; start = "Start"; stop = "Stop"
        restart = "Restart"; terminate = "Kill"; backups = "Backups"; restore = "Restore"
        status = "Status"; console = "Console"; clear_console = "Clear Console"
        players_online = "Players Online"; no_players = "No one connected"
        ip_server = "Server IP"; ip_voicechat = "Voicechat IP"; copy = "Copy"
        open_playit = "Open PlayIT Panel"; playit_status = "Status"; playit_not_started = "PlayIT not started"
        not_detected = "Not detected"; ips_detected = "IPs detected successfully"
        auto_shutdown = "Auto-Shutdown"; enable_auto_shutdown = "Enable automatic shutdown on idle"
        idle_minutes = "Idle minutes:"; operating_hours = "Operating Hours"
        start_on_boot = "Start server on PC boot"; start_time = "Start time:"
        end_time = "End time:"; auto_backup = "Auto-Backup"; enable_auto_backup = "Enable automatic periodic backup"
        interval_min = "Interval (min):"; console_settings = "Console"; auto_clear = "Auto-clear console"
        every_min = "Every (min):"; line_limit = "Line limit:"; language = "Language"
        save_config = "Save Configuration"; select_server = "Select a server first"
        error = "Error"; success = "Success"; info = "Information"; select_backup = "Select a backup first"
        system = "System"; backup = "Backup"; config = "Config"
        detected_server = "Server detected:"; launch_started = "ServerLaunch v2.0 started"
        select_to_start = "Select a server to begin"; starting_server = "Starting server..."
        stopping_services = "Stopping all services..."
        stop_flag_created = "stop_server.flag created"; stop_sent = "'stop' command sent"
        waiting_clean_stop = "Waiting for clean shutdown (up to 90s, without forcing Java)..."
        still_running = "Still running after 90s. Not forced to avoid corruption. Use 'Kill' if needed."
        backup_stopped = "BackupManager stopped"
        all_stopped = "All services stopped successfully"; restarting = "Restarting server..."
        killing_java = "Killing all Java processes..."; java_killed = "All Java processes killed"
        processes_killed = "Processes killed"; restoring_backup = "Restoring backup:"
        restore_complete = "Restore completed"; restore_failed = "Restore failed"
        saving_config = "Saving configuration..."; config_saved = "Configuration saved"
        auto_backup_enabled = "Auto-backup enabled (every"; runbat_notfound = "run.bat not found"
        playit_notfound = "PlayIT not found at:"; all_started = "All services started successfully"
        server_running = "Server running"; server_stopped_status = "Server stopped"
        stopping = "Stopping..."; still_running_status = "Server still running"
        restoring = "Restoring..."; backup_restored = "Backup restored"; error_restoring = "Error restoring"
        error_starting = "Error starting"; not_running = "Not running"
        cant_restart = "Cannot restart: not running"; player_count = "player(s):"
        playit_ip_copied = "Minecraft IP copied:"; playit_vc_copied = "Voicechat IP copied:"
        no_ip_detected = "No IP detected to copy"; server_loaded = "Server loaded successfully"
        error_loading = "Error loading server:"; invalid_path = "Invalid path:"
        config_saved_msg = "Configuration saved successfully"; error_saving = "Error saving:"
        hours_saved = "Hours saved:"; boot_enabled = "Boot autostart enabled"
        error_saving_hours = "Error saving hours:"; min_short = "min"; lines_short = "lines"
    }
}

function Get-Text {
    param([string]$key)
    if ($script:translations[$script:currentLanguage][$key]) {
        return $script:translations[$script:currentLanguage][$key]
    }
    return $key
}

function Update-UILanguage {
    # Actualizar todos los textos de la interfaz segun el idioma actual
    
    # Header
    $window.FindName("HeaderTitle").Text = Get-Text 'app_title'
    $window.FindName("HeaderSubtitle").Text = Get-Text 'app_subtitle'
    
    # Botones
    $window.FindName("BrowseServer").Content = Get-Text 'browse'
    $window.FindName("BrowsePlayit").Content = Get-Text 'browse'
    $window.FindName("StartBtn").Content = Get-Text 'start'
    $window.FindName("StopBtn").Content = Get-Text 'stop'
    $window.FindName("RestartBtn").Content = Get-Text 'restart'
    $window.FindName("KillProcessBtn").Content = Get-Text 'terminate'
    $window.FindName("RestoreBackupBtn").Content = Get-Text 'restore'
    $window.FindName("ClearLog").Content = Get-Text 'clear_console'
    $window.FindName("CopyMinecraftIP").Content = Get-Text 'copy'
    $window.FindName("CopyVoicechatIP").Content = Get-Text 'copy'
    $window.FindName("OpenPlayitWeb").Content = Get-Text 'open_playit'
    $window.FindName("SaveConfigBtn").Content = Get-Text 'save_config'
    
    # CheckBoxes
    $window.FindName("AutoShutdownCheck").Content = Get-Text 'enable_auto_shutdown'
    $window.FindName("StartOnBootCheck").Content = Get-Text 'start_on_boot'
    $window.FindName("AutoBackupCheck").Content = Get-Text 'enable_auto_backup'
    $window.FindName("AutoClearCheck").Content = Get-Text 'auto_clear'
    
    # TextBlocks - Tab Principal
    $window.FindName("LblServer").Text = Get-Text 'server'
    $window.FindName("LblPlayit").Text = Get-Text 'playit_optional'
    $window.FindName("LblServerControl").Text = Get-Text 'server_control'
    $window.FindName("LblBackups").Text = Get-Text 'backups'
    $window.FindName("LblStatus").Text = Get-Text 'status'
    $window.FindName("LblConsole").Text = Get-Text 'console'
    $window.FindName("LblPlayersOnline").Text = Get-Text 'players_online'
    
    # TextBlocks - Tab PlayIT
    $window.FindName("LblIPServer").Text = Get-Text 'ip_server'
    $window.FindName("LblIPVoicechat").Text = Get-Text 'ip_voicechat'
    $window.FindName("LblPlayitStatus").Text = Get-Text 'playit_status'
    
    # TextBlocks - Tab Configuracion
    $window.FindName("LblAutoShutdown").Text = Get-Text 'auto_shutdown'
    $window.FindName("LblIdleMinutes").Text = Get-Text 'idle_minutes'
    $window.FindName("LblOperatingHours").Text = Get-Text 'operating_hours'
    $window.FindName("LblStartTime").Text = Get-Text 'start_time'
    $window.FindName("LblEndTime").Text = Get-Text 'end_time'
    $window.FindName("LblAutoBackup").Text = Get-Text 'auto_backup'
    $window.FindName("LblIntervalMin").Text = Get-Text 'interval_min'
    $window.FindName("LblConsoleSettings").Text = Get-Text 'console_settings'
    $window.FindName("LblEveryMin").Text = Get-Text 'every_min'
    $window.FindName("LblLineLimit").Text = Get-Text 'line_limit'
    $window.FindName("LblLanguage").Text = Get-Text 'language'
    
    # Actualizar estado inicial si no hay servidor cargado
    $statusText = $window.FindName("StatusText")
    if ($statusText -and $statusText.Text -notmatch "PID|running|stopped") {
        $statusText.Text = "$(Get-Text 'status'): $(Get-Text 'select_to_start')"
    }
    
    # Actualizar jugadores si no hay nadie
    $playersBox = $window.FindName("PlayersBox")
    if ($playersBox -and $script:onlinePlayers.Count -eq 0) {
        $playersBox.Text = Get-Text 'no_players'
    }
    
    # Actualizar estado PlayIT si no esta iniciado
    $playitStatus = $window.FindName("PlayitStatus")
    if ($playitStatus -and $playitStatus.Text -notmatch "PID") {
        $playitStatus.Text = Get-Text 'playit_not_started'
    }
    
    # Actualizar IPs de PlayIT si no estan detectadas
    $minecraftIP = $window.FindName("PlayitMinecraftIP")
    if ($minecraftIP -and -not $script:playitIPsDetected) {
        $minecraftIP.Text = Get-Text 'not_detected'
    }
    $voicechatIP = $window.FindName("PlayitVoicechatIP")
    if ($voicechatIP -and -not $script:playitIPsDetected) {
        $voicechatIP.Text = Get-Text 'not_detected'
    }
}

function Get-ServerJavaProcesses {
    param([string]$serverPath)
    if (-not $serverPath) { return @() }
    Get-Process -Name java,javaw -ErrorAction SilentlyContinue | Where-Object {
        try {
            ($_.Path -and $_.Path -like "*$serverPath*") -or
            ($_.StartInfo -and $_.StartInfo.WorkingDirectory -and $_.StartInfo.WorkingDirectory -like "*$serverPath*")
        } catch { $false }
    }
}

function Wait-ForServerStop {
    param([int]$timeoutSeconds = 90)
    $elapsed = 0
    while ($elapsed -lt $timeoutSeconds) {
        $aliveProc = ($script:serverProcess -and -not $script:serverProcess.HasExited)
        $javaProcs = Get-ServerJavaProcesses $script:serverManager.ServerPath
        if (-not $aliveProc -and (-not $javaProcs -or $javaProcs.Count -eq 0)) { return $true }
        Start-Sleep -Seconds 3
        $elapsed += 3
    }
    return $false
}

function Cleanup-AfterServerStopped {
    if ($script:logTimer) { $script:logTimer.Stop(); $script:logTimer = $null }
    if ($script:serverProcess) {
        try { $script:serverProcess.Dispose() } catch { }
        $script:serverProcess = $null
    }
    if ($script:backupManager) { $script:backupManager.Stop(); Append-Log "[Backup] BackupManager detenido" }
    if ($script:playitProcess -and -not $script:playitProcess.HasExited) {
        try {
            Stop-Process -Id $script:playitProcess.Id -Force -ErrorAction Stop
            Append-Log "[Playit] PlayIT detenido (PID: $($script:playitProcess.Id))"
        } catch {
            Append-Log "[Playit] No se pudo detener por PID: $_"
        }
    }
    $playitProcs = Get-Process -Name playit -ErrorAction SilentlyContinue
    if ($playitProcs) {
        $playitProcs | ForEach-Object {
            try {
                Stop-Process -Id $_.Id -Force -ErrorAction Stop
                Append-Log "[Playit] Proceso playit.exe terminado (PID: $($_.Id))"
            } catch { }
        }
    }
    Remove-Item $script:playitLog -ErrorAction SilentlyContinue
    Remove-Item $script:playitErrLog -ErrorAction SilentlyContinue
    Remove-Item $script:serverLog -ErrorAction SilentlyContinue
    $script:serverManager.IsRunning = $false
    $script:onlinePlayers = @()
    Update-PlayerList
    Update-Status "Servidor detenido" "#FF6B6B"
    Append-Log "[Sistema] Todos los servicios detenidos correctamente"
    Set-ControlState "idle"
}

# Funciones auxiliares
function Update-Status {
    param([string]$msg, [string]$color = "#FFB74D")
    $window.FindName("StatusText").Text = "Estado: $msg"
    $window.FindName("StatusText").Foreground = $color
}

function Append-Log {
    param([string]$line)
    $box = $window.FindName("OutputBox")
    $scroll = $window.FindName("ConsoleScroll")
    if ($box) {
        $timestamp = Get-Date -Format "HH:mm:ss"
        $shouldStick = $script:consoleStickToBottom
        $box.AppendText("[$timestamp] $line`r`n")
        # Auto clear
        if ($script:autoClearEnabled) {
            $minutesSince = ((Get-Date) - $script:lastClearTime).TotalMinutes
            $lineCount = $box.LineCount
            if (($script:autoClearMinutes -gt 0 -and $minutesSince -ge $script:autoClearMinutes) -or
                ($script:autoClearMaxLines -gt 0 -and $lineCount -gt $script:autoClearMaxLines)) {
                $box.Clear()
                $script:lastClearTime = Get-Date
                $shouldStick = $true
            }
        }
        if ($shouldStick) {
            $box.ScrollToEnd()
            if ($scroll) { $scroll.ScrollToEnd() }
        }
    }
}

function Update-PlayerList {
    $box = $window.FindName("PlayersBox")
    if ($box) {
        if ($script:onlinePlayers.Count -eq 0) {
            $box.Text = Get-Text 'no_players'
            $box.Foreground = "#888888"
        } else {
            $box.Text = "$($script:onlinePlayers.Count) $(Get-Text 'player_count') " + ($script:onlinePlayers -join ", ")
            $box.Foreground = "#4CAF50"
        }
    }
}

function Refresh-BackupList {
    if ($script:backupManager -and $script:serverManager) {
        $script:backupManager.CurrentServerName = $script:serverManager.ServerName
        $script:backupManager.CurrentServerPath = $script:serverManager.ServerPath
        
        $backups = $script:backupManager.GetBackupList()
        
        try {
            $comboBox = $window.FindName("BackupSelect")
            if ($comboBox) {
                $displayBackups = @()
                foreach ($backup in $backups) {
                    if ($backup -match '(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})') {
                        $display = "$($matches[3])/$($matches[2])/$($matches[1]) $($matches[4]):$($matches[5]):$($matches[6])"
                        $displayBackups += @{ Display = $display; Actual = $backup }
                    }
                }
                $script:backupNameMap = @{}
                foreach ($item in $displayBackups) {
                    $script:backupNameMap[$item.Display] = $item.Actual
                }
                $comboBox.ItemsSource = $displayBackups.Display
                if ($displayBackups.Count -gt 0) {
                    $comboBox.SelectedIndex = 0
                }
            }
        }
        catch { }
    }
}

function Load-ServerPath {
    param([string]$path)
    if (-not (Test-Path $path)) { Append-Log "[ERROR] Ruta invalida: $path"; return }
    $window.FindName("ServerPath").Text = $path
    try {
        $script:serverManager = [ServerManager]::new($path)
        $script:scheduleManager = [ScheduleManager]::new($path)
        $backupRoot = Join-Path $scriptPath "backups"
        $script:backupManager = [BackupManager]::new($backupRoot, { param($msg) Append-Log $msg })
        Update-Status "Servidor cargado correctamente" "#4CAF50"
        Append-Log "[Sistema] Servidor detectado: $($script:serverManager.ServerName)"
        Refresh-BackupList
    }
    catch {
        Append-Log "[ERROR] Error al cargar servidor: $_"
        Update-Status "Error al cargar servidor" "#FF6B6B"
    }
}

# Control state helper
function Set-ControlState {
    param([string]$state)
    $script:serverState = $state
    $start = $window.FindName("StartBtn")
    $stop = $window.FindName("StopBtn")
    $restart = $window.FindName("RestartBtn")
    $kill = $window.FindName("KillProcessBtn")
    switch ($state) {
        "idle" {
            if ($start) { $start.IsEnabled = $true }
            if ($stop) { $stop.IsEnabled = $false }
            if ($restart) { $restart.IsEnabled = $false }
        }
        "starting" {
            if ($start) { $start.IsEnabled = $false }
            if ($stop) { $stop.IsEnabled = $false }
            if ($restart) { $restart.IsEnabled = $false }
        }
        "running" {
            if ($start) { $start.IsEnabled = $false }
            if ($stop) { $stop.IsEnabled = $true }
            if ($restart) { $restart.IsEnabled = $true }
        }
        "stopping" {
            if ($start) { $start.IsEnabled = $false }
            if ($stop) { $stop.IsEnabled = $false }
            if ($restart) { $restart.IsEnabled = $false }
        }
    }
    if ($kill) { $kill.IsEnabled = $true }
}

# Botón: Limpiar consola
$window.FindName("ClearLog").Add_Click({
    $box = $window.FindName("OutputBox")
    if ($box) { $box.Clear() }
    $script:lastClearTime = Get-Date
    $script:consoleStickToBottom = $true
})

# Scroll change detection para consola
$consoleScroll = $window.FindName("ConsoleScroll")
if ($consoleScroll) {
    $consoleScroll.Add_ScrollChanged({
        param($s,$e)
        $scroll = $window.FindName("ConsoleScroll")
        if ($scroll) {
            $script:consoleStickToBottom = ($scroll.VerticalOffset -ge ($scroll.ScrollableHeight - 5))
        }
    })
}

# Botón: Examinar Servidor
$window.FindName("BrowseServer").Add_Click({
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Seleccionar carpeta del servidor"
    
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Load-ServerPath $dialog.SelectedPath
        $script:lastServerPath = $dialog.SelectedPath
        try {
            $dir = Split-Path $script:lastServerConfigPath -Parent
            if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
            Set-Content -Path $script:lastServerConfigPath -Value $script:lastServerPath -Encoding UTF8
        } catch { }
    }
})

# Botón: Examinar PlayIT
$window.FindName("BrowsePlayit").Add_Click({
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Seleccionar carpeta de PlayIT"
    
    if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $window.FindName("PlayitPath").Text = $dialog.SelectedPath
    }
})

# Botón: Copiar IP Minecraft
$window.FindName("CopyMinecraftIP").Add_Click({
    $ip = $window.FindName("PlayitMinecraftIP").Text
    if ($ip -and $ip -ne "No detectado") {
        [System.Windows.Clipboard]::SetText($ip)
        Append-Log "[Playit] IP de Minecraft copiada: $ip"
    } else {
        [System.Windows.MessageBox]::Show($window, "No hay IP detectada para copiar", "PlayIT")
    }
})

# Botón: Copiar IP Voicechat
$window.FindName("CopyVoicechatIP").Add_Click({
    $ip = $window.FindName("PlayitVoicechatIP").Text
    if ($ip -and $ip -ne "No detectado") {
        [System.Windows.Clipboard]::SetText($ip)
        Append-Log "[Playit] IP de Voicechat copiada: $ip"
    } else {
        [System.Windows.MessageBox]::Show($window, "No hay IP detectada para copiar", "PlayIT")
    }
})

# Botón: Abrir panel PlayIT
$window.FindName("OpenPlayitWeb").Add_Click({
    Start-Process "https://playit.gg/account/agents"
})

# Botón: Iniciar
$window.FindName("StartBtn").Add_Click({
    if ($script:serverState -eq "starting") { Append-Log "[Sistema] Ya se esta iniciando"; return }
    if ($script:serverState -eq "running") { Append-Log "[Sistema] El servidor ya esta iniciado"; return }
    if ($script:serverManager) {
        Set-ControlState "starting"
        Update-Status "Iniciando..." "#FFB74D"
        Append-Log "[Sistema] Iniciando servidor..."
        
        try {
            # Rutas para logs temporales
            $script:playitLog = "$env:TEMP\playit_output.log"
            $script:playitErrLog = "$env:TEMP\playit_error.log"
            $script:serverLog = "$env:TEMP\minecraft_server.log"
            
            # Limpiar logs anteriores
            Remove-Item $script:playitLog -ErrorAction SilentlyContinue
            Remove-Item $script:playitErrLog -ErrorAction SilentlyContinue
            Remove-Item $script:serverLog -ErrorAction SilentlyContinue
            New-Item -ItemType File -Path $script:playitLog -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item -ItemType File -Path $script:playitErrLog -Force -ErrorAction SilentlyContinue | Out-Null
            New-Item -ItemType File -Path $script:serverLog -Force -ErrorAction SilentlyContinue | Out-Null
            
            # Iniciar PlayIT primero
            $playitExe = "C:\Program Files\playit_gg\bin\playit.exe"
            if (Test-Path $playitExe) {
                try {
                    $script:playitProcess = Start-Process -FilePath $playitExe `
                        -WindowStyle Hidden `
                        -RedirectStandardOutput $script:playitLog `
                        -RedirectStandardError $script:playitErrLog `
                        -PassThru
                    Append-Log "[Playit] PlayIT iniciado (PID: $($script:playitProcess.Id))"
                    $script:playitLastLine = 0
                    $script:playitShownTunnel = $false
                    $script:playitShownIPs = @()
                }
                catch {
                    Append-Log "[PlayitErr] Error al iniciar PlayIT: $_"
                }
            } else {
                Append-Log "[Sistema] PlayIT no encontrado en: $playitExe"
            }
            
            # Iniciar servidor
            $runBat = Join-Path $script:serverManager.ServerPath "run.bat"
            if (Test-Path $runBat) {
                # Crear archivo temporal para redirigir stdin
                $stdinFile = "$env:TEMP\minecraft_stdin.txt"
                if (Test-Path $stdinFile) { Remove-Item $stdinFile -Force -ErrorAction SilentlyContinue }
                "" | Out-File -FilePath $stdinFile -Encoding ASCII
                
                # Iniciar con redirección de I/O
                $psi = New-Object System.Diagnostics.ProcessStartInfo
                $psi.FileName = "cmd.exe"
                $psi.Arguments = "/c run.bat > `"$($script:serverLog)`" 2>&1"
                $psi.WorkingDirectory = $script:serverManager.ServerPath
                $psi.UseShellExecute = $false
                $psi.RedirectStandardInput = $true
                $psi.CreateNoWindow = $true

                $script:serverProcess = New-Object System.Diagnostics.Process
                $script:serverProcess.StartInfo = $psi
                $null = $script:serverProcess.Start()
                
                $script:cmdProcess = $script:serverProcess
                $script:serverManager.IsRunning = $true
                $script:serverLastLine = 0
                Append-Log "[Server] Servidor iniciado (PID: $($script:serverProcess.Id))"
                
                # Habilitar auto-backup si está configurado
                if ($script:autoBackupEnabled -and $script:backupManager) {
                    try {
                        $script:backupManager.Start($script:serverManager.ServerName, $script:serverManager.ServerPath, $script:backupIntervalMinutes)
                        Append-Log "[Backup] Auto-backup habilitado (cada $script:backupIntervalMinutes min)"
                    }
                    catch { }
                }
            } else {
                Append-Log "[ERROR] No se encontro run.bat"
                Update-Status "Error: run.bat no encontrado" "#FF6B6B"
                return
            }
            
            # Timer para leer logs en tiempo real
            $script:logTimer = New-Object System.Windows.Threading.DispatcherTimer
            $script:logTimer.Interval = [System.TimeSpan]::FromMilliseconds(500)
            $script:logTimer.Add_Tick({
                # Leer output de PlayIT
                if (Test-Path $script:playitLog) {
                    try {
                        $lines = Get-Content $script:playitLog -ErrorAction SilentlyContinue
                        if ($lines -and $lines.Count -gt $script:playitLastLine) {
                            $newLines = $lines[$script:playitLastLine..($lines.Count-1)]
                            foreach ($line in $newLines) {
                                $trimmed = $line.Trim()
                                if ($trimmed) {
                                    if ($trimmed -match "tunnel running" -and -not $script:playitShownTunnel) {
                                        Append-Log "[Playit] $trimmed"
                                        $script:playitShownTunnel = $true
                                    }
                                    elseif ($trimmed -match "=>") {
                                        if ($trimmed -notmatch "disabled" -and $script:playitShownIPs -notcontains $trimmed) {
                                            Append-Log "[Playit] $trimmed"
                                            $script:playitShownIPs += $trimmed
                                        }
                                        
                                        # Detectar IPs solo una vez
                                        if (-not $script:playitIPsDetected) {
                                            # Minecraft Java: buscar antes del =>
                                            if ($trimmed -match "(\S+\.gl\.joinmc\.link)\s*=>.*minecraft-java") {
                                                $script:playitMinecraftIP = $matches[1]
                                                $window.FindName("PlayitMinecraftIP").Text = $script:playitMinecraftIP
                                                $window.FindName("PlayitStatus").Text = "IPs detectadas correctamente"
                                                $window.FindName("PlayitStatus").Foreground = "#4CAF50"
                                            }
                                            # Voicechat UDP: buscar puerto antes del =>
                                            if ($trimmed -match "(\S+\.gl\.at\.ply\.gg:\d+)\s*=>.*Udp") {
                                                $script:playitVoicechatIP = $matches[1]
                                                $window.FindName("PlayitVoicechatIP").Text = $script:playitVoicechatIP
                                            }
                                            
                                            # Marcar como detectado si tenemos ambas
                                            if ($script:playitMinecraftIP -and $script:playitVoicechatIP) {
                                                $script:playitIPsDetected = $true
                                            }
                                        }
                                    }
                                }
                            }
                            $script:playitLastLine = $lines.Count
                        }
                    }
                    catch { }
                }
                
                # Leer output del servidor
                if (Test-Path $script:serverLog) {
                    try {
                        $lines = Get-Content $script:serverLog -ErrorAction SilentlyContinue
                        if ($lines -and $lines.Count -gt $script:serverLastLine) {
                            $newLines = $lines[$script:serverLastLine..($lines.Count-1)]
                            foreach ($line in $newLines) {
                                $trimmed = $line.Trim()
                                if ($trimmed) {
                                    Append-Log "[Server] $trimmed"
                                    
                                    # Detectar jugadores
                                    if ($trimmed -match "(\w+)\s+(joined the game|se unio al juego)") {
                                        $playerName = $matches[1]
                                        if ($script:onlinePlayers -notcontains $playerName) {
                                            $script:onlinePlayers += $playerName
                                            Update-PlayerList
                                        }
                                    }
                                    elseif ($trimmed -match "(\w+)\s+(left the game|salio del juego)") {
                                        $playerName = $matches[1]
                                        $script:onlinePlayers = $script:onlinePlayers | Where-Object { $_ -ne $playerName }
                                        Update-PlayerList
                                    }
                                }
                            }
                            $script:serverLastLine = $lines.Count
                        }
                    }
                    catch { }
                }
                
                # Verificar si el servidor sigue corriendo
                if ($script:serverProcess -and $script:serverProcess.HasExited) {
                    Append-Log "[Server] El servidor se ha detenido"
                    Cleanup-AfterServerStopped
                }
            })
            $script:logTimer.Start()
            
            Update-Status "Servidor en ejecucion" "#4CAF50"
            Append-Log "[Sistema] Todos los servicios iniciados correctamente"
            Set-ControlState "running"
        }
        catch {
            Append-Log "[ERROR] Error al iniciar: $_"
            Update-Status "Error al iniciar" "#FF6B6B"
            Set-ControlState "idle"
        }
    } else {
        [System.Windows.MessageBox]::Show($window, "Selecciona un servidor primero", "Error",
            [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
    }
})

# Botón: Detener
$window.FindName("StopBtn").Add_Click({
    if ($script:serverState -ne "running") { Append-Log "[Sistema] No esta en ejecucion"; return }
    if ($script:serverManager) {
        Set-ControlState "stopping"
        Update-Status "Deteniendo..." "#FFB74D"
        Append-Log "[Sistema] Deteniendo todos los servicios..."
        try {
            # Señal de parada
            if ($script:serverManager -and $script:serverManager.ServerPath) {
                New-Item -Path (Join-Path $script:serverManager.ServerPath "stop_server.flag") -ItemType File -Force -ErrorAction SilentlyContinue | Out-Null
                Append-Log "[Server] Bandera stop_server.flag creada"
            }
            
            # Enviar comando stop al servidor
            if ($script:serverProcess -and -not $script:serverProcess.HasExited) {
                try {
                    $script:serverProcess.StandardInput.WriteLine("stop")
                    $script:serverProcess.StandardInput.Flush()
                    Append-Log "[Server] Comando 'stop' enviado"
                } catch {
                    Append-Log "[Server] No se pudo enviar stop por stdin: $_"
                }
            }
            
            Append-Log "[Server] Esperando apagado limpio (hasta 90s, sin forzar Java)..."
            
            # Timer para esperar sin bloquear UI
            $script:stopWaitTime = 0
            $script:stopTimer = New-Object System.Windows.Threading.DispatcherTimer
            $script:stopTimer.Interval = [System.TimeSpan]::FromSeconds(3)
            $script:stopTimer.Add_Tick({
                $script:stopWaitTime += 3
                
                # Check if any java process related to server is still alive
                $javaProcs = Get-Process -Name java,javaw -ErrorAction SilentlyContinue | Where-Object {
                    try {
                        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)" -ErrorAction SilentlyContinue).CommandLine
                        $cmdLine -and ($cmdLine -like "*$($script:serverManager.ServerPath)*" -or $cmdLine -like "*run.bat*")
                    } catch { $false }
                }
                
                if (-not $javaProcs -or $javaProcs.Count -eq 0) {
                    $script:stopTimer.Stop()
                    if ($script:serverState -ne "idle") {
                        Cleanup-AfterServerStopped
                    }
                    return
                }
                
                if ($script:stopWaitTime -ge 90) {
                    $script:stopTimer.Stop()
                    Append-Log "[Server] Sigue en ejecucion tras 90s. No se forzo para evitar corrupcion. Usa 'Terminar' si es necesario."
                    Update-Status "Servidor aun en ejecucion" "#FFB74D"
                    Set-ControlState "running"
                }
            })
            $script:stopTimer.Start()
        }
        catch {
            Append-Log "[ERROR] Error al detener: $_"
            Set-ControlState "idle"
        }
    }
})

# Botón: Reiniciar
$window.FindName("RestartBtn").Add_Click({
    if ($script:serverState -ne "running") { Append-Log "[Sistema] No se puede reiniciar: no esta corriendo"; return }
    if ($script:serverManager) {
        Append-Log "[Sistema] Reiniciando servidor..."
        $window.FindName("StopBtn").RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
        Start-Sleep -Seconds 3
        $window.FindName("StartBtn").RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
    }
})

# Botón: Terminar procesos
$window.FindName("KillProcessBtn").Add_Click({
    Append-Log "[Sistema] Terminando todos los procesos Java..."
    Get-Process -Name java,javaw -ErrorAction SilentlyContinue | Stop-Process -Force
    Append-Log "[Sistema] Todos los procesos Java terminados"
    if ($script:serverManager) {
        $script:serverManager.IsRunning = $false
    }
    Update-Status "Procesos terminados" "#FF6B6B"
    Set-ControlState "idle"
})

# Botón: Restaurar Backup
$window.FindName("RestoreBackupBtn").Add_Click({
    if ($script:backupManager -and $script:serverManager) {
        $selectedDisplay = $window.FindName("BackupSelect").SelectedItem
        if ($selectedDisplay) {
            $actualBackup = $script:backupNameMap[$selectedDisplay]
            if ($actualBackup) {
                Append-Log "[Backup] Restaurando backup: $selectedDisplay"
                Update-Status "Restaurando..." "#FFB74D"
                try {
                    # Asegurar que BackupManager tiene la info del servidor
                    $script:backupManager.CurrentServerName = $script:serverManager.ServerName
                    $script:backupManager.CurrentServerPath = $script:serverManager.ServerPath
                    
                    $result = $script:backupManager.RestoreBackup($actualBackup)
                    if ($result) {
                            Append-Log "[Backup] Restauracion completada"
                        Update-Status "Backup restaurado" "#4CAF50"
                    } else {
                        Append-Log "[ERROR] Fallo la restauracion"
                        Update-Status "Error al restaurar" "#FF6B6B"
                    }
                }
                catch {
                    Append-Log "[ERROR] $_"
                    Update-Status "Error al restaurar" "#FF6B6B"
                }
            }
        } else {
                [System.Windows.MessageBox]::Show($window, "Selecciona un backup primero", "Error")
        }
    }
})

# Botón: Guardar Configuración
$window.FindName("SaveConfigBtn").Add_Click({
    try {
        Append-Log "[Config] Guardando configuracion..."
        
        # Auto-Shutdown
        $autoShutdownCheck = $window.FindName("AutoShutdownCheck")
        if ($autoShutdownCheck) {
            $script:autoShutdownEnabled = $autoShutdownCheck.IsChecked
        }
        $idleText = $window.FindName("IdleMinutesBox").Text
        if ([string]::IsNullOrEmpty($idleText)) { $idleText = "30" }
        $script:autoShutdownMinutes = [int]$idleText
        
        # Horarios
        $startH = [int]$window.FindName("StartHourBox").Text
        $startM = [int]$window.FindName("StartMinBox").Text
        $stopH = [int]$window.FindName("StopHourBox").Text
        $stopM = [int]$window.FindName("StopMinBox").Text
        
        if ($script:scheduleManager) {
            try {
                $script:scheduleManager.SetOperatingHours($startH, $startM, $stopH, $stopM)
                Append-Log "[Config] Horarios guardados: ${startH}:${startM} - ${stopH}:${stopM}"
            } catch {
                Append-Log "[Config] Error guardando horarios: $_"
            }
            
            $bootCheck = $window.FindName("StartOnBootCheck")
            if ($bootCheck -and $bootCheck.IsChecked) {
                try {
                    $script:scheduleManager.EnableBootAutoStart()
                    Append-Log "[Config] Inicio automatico habilitado"
                } catch { }
            }
        }
        
        # Auto-Backup
        $backupCheck = $window.FindName("AutoBackupCheck")
        if ($backupCheck) {
            $script:autoBackupEnabled = $backupCheck.IsChecked
        }
        $backupText = $window.FindName("BackupIntervalBox").Text
        if ([string]::IsNullOrEmpty($backupText)) { $backupText = "60" }
        $script:backupIntervalMinutes = [int]$backupText
        
        # Auto Clear
        $autoClearCheck = $window.FindName("AutoClearCheck")
        if ($autoClearCheck) { $script:autoClearEnabled = $autoClearCheck.IsChecked }
        $acMinutes = $window.FindName("AutoClearMinutesBox").Text
        if ([string]::IsNullOrEmpty($acMinutes)) { $acMinutes = "0" }
        $script:autoClearMinutes = [int]$acMinutes
        $acLines = $window.FindName("AutoClearLinesBox").Text
        if ([string]::IsNullOrEmpty($acLines)) { $acLines = "500" }
        $script:autoClearMaxLines = [int]$acLines
        $script:lastClearTime = Get-Date
        
        # Guardar idioma
        try {
            $dir = Split-Path $script:languageConfigPath -Parent
            if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
            Set-Content -Path $script:languageConfigPath -Value $script:currentLanguage -Encoding UTF8
        } catch { }

        Append-Log "[$(Get-Text 'config')] $(Get-Text 'config_saved')"
        Append-Log "[Config] Auto-Shutdown: $script:autoShutdownEnabled ($script:autoShutdownMinutes $(Get-Text 'min_short'))"
        Append-Log "[Config] Auto-Backup: $script:autoBackupEnabled ($script:backupIntervalMinutes $(Get-Text 'min_short'))"
        Append-Log "[Config] Auto-Clear: $script:autoClearEnabled ($(Get-Text 'min_short') $script:autoClearMinutes, $(Get-Text 'lines_short') $script:autoClearMaxLines)"
        
        [System.Windows.MessageBox]::Show($window, (Get-Text 'config_saved_msg'), (Get-Text 'success'),
            [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
    catch {
        Append-Log "[ERROR] $(Get-Text 'error_saving') $_"
        [System.Windows.MessageBox]::Show($window, "$(Get-Text 'error_saving') $_", (Get-Text 'error'),
            [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
})

# Establecer PlayIT por defecto
$playitExe = "C:\Program Files\playit_gg\bin\playit.exe"
if (Test-Path $playitExe) {
    $playitDir = Split-Path $playitExe -Parent
    $window.FindName("PlayitPath").Text = $playitDir
}

# Estado inicial botones
Set-ControlState "idle"

# Cargar idioma
if (Test-Path $script:languageConfigPath) {
    try {
        $lang = Get-Content -Path $script:languageConfigPath -Raw -ErrorAction SilentlyContinue
        if ($lang -and ($lang.Trim() -eq "en" -or $lang.Trim() -eq "es")) {
            $script:currentLanguage = $lang.Trim()
        }
    } catch { }
}
$langCombo = $window.FindName("LanguageSelect")
if ($langCombo) {
    foreach ($item in $langCombo.Items) {
        if ($item.Tag -eq $script:currentLanguage) {
            $langCombo.SelectedItem = $item
            break
        }
    }
    # Evento cambio de idioma
    $langCombo.Add_SelectionChanged({
        $item = $langCombo.SelectedItem
        if ($item -and $item.Tag) {
            $script:currentLanguage = $item.Tag
            Update-UILanguage
        }
    })
}

# Actualizar idioma de la interfaz
Update-UILanguage

# Cargar ultimo servidor
if (Test-Path $script:lastServerConfigPath) {
    try {
        $lastPath = Get-Content -Path $script:lastServerConfigPath -Raw -ErrorAction SilentlyContinue
        if ($lastPath -and (Test-Path $lastPath.Trim())) {
            Load-ServerPath $lastPath.Trim()
        }
    } catch { }
}

# Mensaje inicial
Append-Log "[$(Get-Text 'system')] $(Get-Text 'launch_started')"
Append-Log "[$(Get-Text 'system')] $(Get-Text 'select_to_start')"

# Event handler para cuando se cierra la ventana
$window.Add_Closing({
    param($sender, $e)
    try {
        # Detener timer si existe
        if ($script:logTimer) { $script:logTimer.Stop() }
        if ($script:stopTimer) { $script:stopTimer.Stop() }
        
        # Terminar procesos de servidor
        Get-Process -Name java,javaw -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        
        # Terminar PlayIT
        if ($script:playitProcess -and -not $script:playitProcess.HasExited) {
            Stop-Process -Id $script:playitProcess.Id -Force -ErrorAction SilentlyContinue
        }
        Get-Process -Name playit -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
        
        # Terminar cmd/powershell si quedaron
        if ($script:cmdProcess -and -not $script:cmdProcess.HasExited) {
            Stop-Process -Id $script:cmdProcess.Id -Force -ErrorAction SilentlyContinue
        }
        
        # Limpiar logs temporales
        Remove-Item $script:playitLog -ErrorAction SilentlyContinue
        Remove-Item $script:playitErrLog -ErrorAction SilentlyContinue
        Remove-Item $script:serverLog -ErrorAction SilentlyContinue
    } catch { }
})

# Mostrar ventana
$window.Show() | Out-Null
[System.Windows.Threading.Dispatcher]::Run()
