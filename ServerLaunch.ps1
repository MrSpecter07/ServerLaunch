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
        <TabControl x:Name="MainTabControl" Grid.Row="1" Background="#1E1E1E" BorderThickness="0" Margin="20,0,20,20">
            <TabControl.Resources>
                <!-- Estilo para botones con estado disabled en gris -->
                <Style TargetType="Button">
                    <Setter Property="Foreground" Value="White"/>
                    <Setter Property="Padding" Value="10,5"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="Button">
                                <Border x:Name="ButtonBorder" Background="{TemplateBinding Background}" 
                                        BorderBrush="{TemplateBinding BorderBrush}" 
                                        BorderThickness="{TemplateBinding BorderThickness}"
                                        Padding="{TemplateBinding Padding}">
                                    <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsEnabled" Value="False">
                                        <Setter TargetName="ButtonBorder" Property="Background" Value="#666666"/>
                                        <Setter Property="Foreground" Value="#999999"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
                
                <!-- Estilo personalizado para ListBoxItem sin estados estándar -->
                <Style TargetType="ListBoxItem">
                    <Setter Property="Background" Value="#1E1E1E"/>
                    <Setter Property="Foreground" Value="#E0E0E0"/>
                    <Setter Property="Padding" Value="10,8"/>
                    <Setter Property="Margin" Value="0,3"/>
                    <Setter Property="BorderBrush" Value="Transparent"/>
                    <Setter Property="BorderThickness" Value="2"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="ListBoxItem">
                                <Border Background="{TemplateBinding Background}" 
                                        BorderBrush="{TemplateBinding BorderBrush}"
                                        BorderThickness="{TemplateBinding BorderThickness}"
                                        Padding="{TemplateBinding Padding}">
                                    <ContentPresenter VerticalAlignment="Center"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <Trigger Property="IsMouseOver" Value="True">
                                        <Setter Property="Background" Value="#2D2D2D"/>
                                        <Setter Property="BorderBrush" Value="#666666"/>
                                    </Trigger>
                                    <Trigger Property="IsSelected" Value="True">
                                        <Setter Property="Background" Value="#3C3C3C"/>
                                        <Setter Property="BorderBrush" Value="#888888"/>
                                        <Setter Property="Foreground" Value="#FFFFFF"/>
                                    </Trigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
                
                <!-- Estilo personalizado para ListBox -->
                <Style TargetType="ListBox">
                    <Setter Property="Background" Value="#1A1A1A"/>
                    <Setter Property="Foreground" Value="#E0E0E0"/>
                    <Setter Property="BorderBrush" Value="#555555"/>
                    <Setter Property="BorderThickness" Value="1"/>
                    <Setter Property="Padding" Value="5"/>
                    <Setter Property="ScrollViewer.VerticalScrollBarVisibility" Value="Auto"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="ListBox">
                                <Border Background="{TemplateBinding Background}" 
                                        BorderBrush="{TemplateBinding BorderBrush}" 
                                        BorderThickness="{TemplateBinding BorderThickness}"
                                        Padding="{TemplateBinding Padding}">
                                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                                        <ItemsPresenter/>
                                    </ScrollViewer>
                                </Border>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
                
                <!-- Estilo global para ComboBoxItem (dropdown items) -->
                <Style TargetType="ComboBoxItem">
                    <Setter Property="Background" Value="#1E1E1E"/>
                    <Setter Property="Foreground" Value="#E0E0E0"/>
                    <Setter Property="Padding" Value="8,6"/>
                    <Setter Property="HorizontalContentAlignment" Value="Stretch"/>
                    <Setter Property="VerticalContentAlignment" Value="Center"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="ComboBoxItem">
                                <Border x:Name="Bd" 
                                        Background="{TemplateBinding Background}" 
                                        BorderBrush="{TemplateBinding BorderBrush}"
                                        BorderThickness="0"
                                        Padding="{TemplateBinding Padding}"
                                        SnapsToDevicePixels="True">
                                    <ContentPresenter 
                                        HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}"
                                        VerticalAlignment="{TemplateBinding VerticalContentAlignment}"
                                        SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}"/>
                                </Border>
                                <ControlTemplate.Triggers>
                                    <MultiTrigger>
                                        <MultiTrigger.Conditions>
                                            <Condition Property="IsSelected" Value="False"/>
                                            <Condition Property="IsMouseOver" Value="True"/>
                                        </MultiTrigger.Conditions>
                                        <Setter TargetName="Bd" Property="Background" Value="#3C3C3C"/>
                                    </MultiTrigger>
                                    <MultiTrigger>
                                        <MultiTrigger.Conditions>
                                            <Condition Property="IsSelected" Value="True"/>
                                        </MultiTrigger.Conditions>
                                        <Setter TargetName="Bd" Property="Background" Value="#3C3C3C"/>
                                    </MultiTrigger>
                                </ControlTemplate.Triggers>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
                
                <!-- Estilo global para ComboBox -->
                <Style TargetType="ComboBox">
                    <Setter Property="Background" Value="#3C3C3C"/>
                    <Setter Property="Foreground" Value="#E0E0E0"/>
                    <Setter Property="BorderBrush" Value="#ABADB3"/>
                    <Setter Property="BorderThickness" Value="1"/>
                    <Setter Property="Padding" Value="8"/>
                    <Setter Property="Template">
                        <Setter.Value>
                            <ControlTemplate TargetType="ComboBox">
                                <Grid>
                                    <ToggleButton x:Name="DropDownButton" 
                                                  Focusable="False" 
                                                  IsChecked="{Binding IsDropDownOpen, Mode=TwoWay, RelativeSource={RelativeSource TemplatedParent}}"
                                                  Background="{TemplateBinding Background}" 
                                                  BorderBrush="{TemplateBinding BorderBrush}"
                                                  BorderThickness="{TemplateBinding BorderThickness}">
                                        <ToggleButton.Template>
                                            <ControlTemplate TargetType="ToggleButton">
                                                <Grid Background="{TemplateBinding Background}">
                                                    <Grid.ColumnDefinitions>
                                                        <ColumnDefinition Width="*"/>
                                                        <ColumnDefinition Width="20"/>
                                                    </Grid.ColumnDefinitions>
                                                    <Border Grid.ColumnSpan="2" Background="{TemplateBinding Background}" 
                                                            BorderBrush="{TemplateBinding BorderBrush}" 
                                                            BorderThickness="{TemplateBinding BorderThickness}"/>
                                                    <Path Grid.Column="1" HorizontalAlignment="Center" VerticalAlignment="Center"
                                                          Fill="#1A1A1A" Data="M0,0 L4,4 L8,0 Z"/>
                                                </Grid>
                                            </ControlTemplate>
                                        </ToggleButton.Template>
                                    </ToggleButton>
                                    <ContentPresenter x:Name="ContentPresenter" 
                                                      Margin="8,0,28,0"
                                                      VerticalAlignment="Center"
                                                      HorizontalAlignment="Left"
                                                      Content="{TemplateBinding SelectionBoxItem}"
                                                      ContentTemplate="{TemplateBinding SelectionBoxItemTemplate}"
                                                      ContentTemplateSelector="{TemplateBinding ItemTemplateSelector}"
                                                      IsHitTestVisible="False"/>
                                    <Popup x:Name="PART_Popup" 
                                           AllowsTransparency="True" 
                                           IsOpen="{TemplateBinding IsDropDownOpen}"
                                           Placement="Bottom" 
                                           PopupAnimation="Slide">
                                        <Border x:Name="DropDownBorder" 
                                                Background="#1E1E1E" 
                                                BorderBrush="{TemplateBinding BorderBrush}" 
                                                BorderThickness="1"
                                                MinWidth="{TemplateBinding ActualWidth}">
                                            <ScrollViewer SnapsToDevicePixels="True">
                                                <ItemsPresenter KeyboardNavigation.DirectionalNavigation="Contained"/>
                                            </ScrollViewer>
                                        </Border>
                                    </Popup>
                                </Grid>
                            </ControlTemplate>
                        </Setter.Value>
                    </Setter>
                </Style>
                
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
            <TabItem x:Name="TabPrincipal" Header="Principal">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        <!-- Servidor -->
                        <TextBlock x:Name="LblServer" Text="Servidor" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="ServerPath" Width="400" Height="40" Padding="10" 
                                     Background="#3C3C3C" Foreground="White" IsReadOnly="True"/>
                            <Button x:Name="BrowseServer" Content="Examinar" Width="100" Height="35" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold"
                                    Margin="10,0,0,0" Cursor="Hand"/>
                        </StackPanel>
                        
                        <!-- PlayIT -->
                        <TextBlock x:Name="LblPlayit" Text="PlayIT (Opcional)" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="PlayitPath" Width="400" Height="40" Padding="10" 
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
                            <ComboBox x:Name="BackupSelect" Width="350" Height="32" Margin="0,0,10,0">
                                <ComboBox.Resources>
                                    <Style TargetType="ComboBoxItem">
                                        <Setter Property="Background" Value="Transparent"/>
                                        <Setter Property="Foreground" Value="#E0E0E0"/>
                                    </Style>
                                </ComboBox.Resources>
                            </ComboBox>
                            <Button x:Name="ReloadBackupsBtn" Content="Recargar" Width="90" Height="32" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold" Cursor="Hand" Margin="0,0,10,0"/>
                            <Button x:Name="RestoreBackupBtn" Content="Restaurar" Width="90" Height="32" 
                                    Background="#FF9800" Foreground="White" FontWeight="Bold" Cursor="Hand"/>
                        </StackPanel>
                        
                        <!-- Estado -->
                        <TextBlock x:Name="LblStatus" Text="Estado" FontSize="13" FontWeight="Bold" Margin="0,0,0,8"/>
                        <TextBlock x:Name="StatusText" Text="No configurado" FontSize="12" Foreground="#FFB74D" Margin="0,0,0,20"/>
                        
                        <!-- Consola -->
                        <TextBlock x:Name="LblConsole" Text="Consola" FontSize="13" FontWeight="Bold" Margin="10,0,0,8"/>
                        <Border Background="#0D0D0D" BorderBrush="#3C3C3C" BorderThickness="1" Padding="10" Margin="0,0,0,10">
                            <ScrollViewer x:Name="ConsoleScroll" Height="200" VerticalScrollBarVisibility="Auto">
                                <TextBox x:Name="OutputBox" Background="Transparent" Foreground="#00FF00" 
                                         FontFamily="Consolas" FontSize="10" BorderThickness="0" 
                                         IsReadOnly="True" TextWrapping="Wrap" AcceptsReturn="True"/>
                            </ScrollViewer>
                        </Border>
                        
                        <!-- Input de Comandos -->
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                            <TextBox x:Name="CommandInput" Height="35" Padding="10" Background="#3C3C3C" Foreground="White" 
                                     BorderBrush="#ABADB3" BorderThickness="1" FontFamily="Consolas" FontSize="10"
                                     VerticalContentAlignment="Center" HorizontalAlignment="Left" Width="500"/>
                            <Button x:Name="SendCommandBtn" Content="Enviar" Width="100" Height="35" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold" 
                                    Cursor="Hand" Margin="10,0,0,0"/>
                        </StackPanel>
                        
                        <Button x:Name="ClearLog" Content="Limpiar Consola" Width="150" Height="30" 
                                Background="#555555" Foreground="White" FontWeight="Bold" 
                                HorizontalAlignment="Left" Cursor="Hand" Margin="10,0,0,10"/>
                        
                        <!-- Jugadores Online -->
                        <TextBlock x:Name="LblPlayersOnline" Text="Jugadores Online" FontSize="13" FontWeight="Bold" Margin="10,10,0,8"/>
                        <Border Background="#2D2D2D" BorderBrush="#3C3C3C" BorderThickness="1" Padding="15" CornerRadius="5">
                            <TextBlock x:Name="PlayersBox" Text="Sin jugadores conectados" FontSize="11" Foreground="#888888" TextWrapping="Wrap"/>
                        </Border>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>
            
            <!-- Tab: PlayIT -->
            <TabItem x:Name="TabPlayIT" Header="PlayIT">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        
                        <TextBlock x:Name="LblIPServer" Text="IP Server" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="PlayitMinecraftIP" Width="400" Height="40" Padding="10" 
                                     Background="#3C3C3C" Foreground="White" IsReadOnly="True" Text="No detectado"/>
                            <Button x:Name="CopyMinecraftIP" Content="Copiar" Width="100" Height="35" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold"
                                    Margin="10,0,0,0" Cursor="Hand"/>
                        </StackPanel>
                        
                        <TextBlock x:Name="LblIPVoicechat" Text="IP Voicechat" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBox x:Name="PlayitVoicechatIP" Width="400" Height="40" Padding="10" 
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

            <!-- Tab: Server Settings -->
            <TabItem x:Name="TabServerSettings" Header="Server Settings">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        <!-- Basic Settings -->
                        <TextBlock x:Name="LblBasicSettings" Text="Configuracion Basica" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        
                        <TextBlock x:Name="LblMotd" Text="MOTD (Message of the Day):" FontSize="12" Margin="0,0,0,5"/>
                        <TextBox x:Name="ServerMOTD" Width="550" Height="40" Padding="8" Background="#3C3C3C" Foreground="White" Margin="0,0,0,15" HorizontalAlignment="Left"/>
                        
                        <Grid Margin="0,0,0,15">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="200"/>
                                <ColumnDefinition Width="200"/>
                                <ColumnDefinition Width="200"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock x:Name="LblMaxPlayers" Text="Max Players:" FontSize="12" Margin="0,0,0,5"/>
                                <TextBox x:Name="ServerMaxPlayers" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                <TextBlock x:Name="LblViewDistance" Text="View Distance:" FontSize="12" Margin="0,0,0,5"/>
                                <TextBox x:Name="ServerViewDistance" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White"/>
                            </StackPanel>
                            <StackPanel Grid.Column="2" Margin="10,0,0,0">
                                <TextBlock x:Name="LblSimulationDistance" Text="Simulation Distance:" FontSize="12" Margin="0,0,0,5"/>
                                <TextBox x:Name="ServerSimulationDistance" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White"/>
                            </StackPanel>
                        </Grid>
                        
                        <Grid Margin="0,0,0,15">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="200"/>
                                <ColumnDefinition Width="200"/>
                                <ColumnDefinition Width="200"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock x:Name="LblSpawnProtection" Text="Spawn Protection:" FontSize="12" Margin="0,0,0,5"/>
                                <TextBox x:Name="ServerSpawnProtection" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                <TextBlock x:Name="LblPlayerIdleTimeout" Text="Player Idle Timeout:" FontSize="12" Margin="0,0,0,5"/>
                                <TextBox x:Name="ServerIdleTimeout" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White"/>
                            </StackPanel>
                        </Grid>
                        
                        <!-- World Settings -->
                        <TextBlock x:Name="LblWorldSettings" Text="Configuracion del Mundo" FontSize="14" FontWeight="Bold" Margin="0,15,0,10" Foreground="#4CAF50"/>
                        
                        <TextBlock x:Name="LblLevelName" Text="Level Name:" FontSize="12" Margin="0,0,0,5"/>
                        <TextBox x:Name="ServerLevelName" Width="350" Height="40" Padding="8" Background="#3C3C3C" Foreground="White" Margin="0,0,0,15" HorizontalAlignment="Left"/>
                        
                        <TextBlock x:Name="LblLevelSeed" Text="Level Seed:" FontSize="12" Margin="0,0,0,5"/>
                        <TextBox x:Name="ServerLevelSeed" Width="350" Height="40" Padding="8" Background="#3C3C3C" Foreground="White" Margin="0,0,0,15" HorizontalAlignment="Left"/>
                        
                        <TextBlock x:Name="LblLevelType" Text="Level Type:" FontSize="12" Margin="0,0,0,5"/>
                        <ComboBox x:Name="ServerLevelType" Width="250" Height="32" Margin="0,0,0,15" HorizontalAlignment="Left">
                            <ComboBox.Resources>
                                <Style TargetType="ComboBoxItem">
                                    <Setter Property="Background" Value="Transparent"/>
                                    <Setter Property="Foreground" Value="#E0E0E0"/>
                                </Style>
                            </ComboBox.Resources>
                            <ComboBoxItem Content="minecraft\:normal" Tag="minecraft\:normal"/>
                            <ComboBoxItem Content="minecraft\:flat" Tag="minecraft\:flat"/>
                            <ComboBoxItem Content="minecraft\:large_biomes" Tag="minecraft\:large_biomes"/>
                            <ComboBoxItem Content="minecraft\:amplified" Tag="minecraft\:amplified"/>
                        </ComboBox>
                        
                        <Grid Margin="0,0,0,15">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="250"/>
                                <ColumnDefinition Width="250"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock x:Name="LblGamemode" Text="Gamemode:" FontSize="12" Margin="0,0,0,8" VerticalAlignment="Center"/>
                                <ComboBox x:Name="ServerGamemode" Width="200" Height="32" HorizontalAlignment="Left">
                                    <ComboBox.Resources>
                                        <Style TargetType="ComboBoxItem">
                                            <Setter Property="Background" Value="Transparent"/>
                                            <Setter Property="Foreground" Value="#E0E0E0"/>
                                        </Style>
                                    </ComboBox.Resources>
                                    <ComboBoxItem Content="survival" Tag="survival"/>
                                    <ComboBoxItem Content="creative" Tag="creative"/>
                                    <ComboBoxItem Content="adventure" Tag="adventure"/>
                                    <ComboBoxItem Content="spectator" Tag="spectator"/>
                                </ComboBox>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                <TextBlock x:Name="LblDifficulty" Text="Difficulty:" FontSize="12" Margin="0,0,0,8" VerticalAlignment="Center"/>
                                <ComboBox x:Name="ServerDifficulty" Width="200" Height="32" HorizontalAlignment="Left" SelectedIndex="2">
                                    <ComboBox.Resources>
                                        <Style TargetType="ComboBoxItem">
                                            <Setter Property="Background" Value="Transparent"/>
                                            <Setter Property="Foreground" Value="#E0E0E0"/>
                                        </Style>
                                    </ComboBox.Resources>
                                    <ComboBoxItem Content="peaceful" Tag="peaceful"/>
                                    <ComboBoxItem Content="easy" Tag="easy"/>
                                    <ComboBoxItem Content="normal" Tag="normal"/>
                                    <ComboBoxItem Content="hard" Tag="hard"/>
                                </ComboBox>
                            </StackPanel>
                        </Grid>
                        
                        <Grid Margin="0,0,0,15">
                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="250"/>
                                <ColumnDefinition Width="250"/>
                            </Grid.ColumnDefinitions>
                            <StackPanel Grid.Column="0">
                                <TextBlock x:Name="LblMaxTickTime" Text="Max Tick Time:" FontSize="12" Margin="0,0,0,8" VerticalAlignment="Center"/>
                                <TextBox x:Name="ServerMaxTickTime" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White" HorizontalAlignment="Left"/>
                            </StackPanel>
                            <StackPanel Grid.Column="1" Margin="10,0,0,0">
                                <TextBlock x:Name="LblMaxWorldSize" Text="Max World Size:" FontSize="12" Margin="0,0,0,8" VerticalAlignment="Center"/>
                                <TextBox x:Name="ServerMaxWorldSize" Width="150" Height="40" Padding="8" Background="#3C3C3C" Foreground="White" HorizontalAlignment="Left"/>
                            </StackPanel>
                        </Grid>
                        
                        <!-- Security & Features -->
                        <TextBlock x:Name="LblSecuritySettings" Text="Seguridad y Caracteristicas" FontSize="14" FontWeight="Bold" Margin="0,15,0,10" Foreground="#4CAF50"/>
                        
                        <CheckBox x:Name="ServerOnlineMode" Content="Online Mode (verificacion de cuentas Mojang)" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerEnforceSecureProfile" Content="Enforce Secure Profile" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerEnableCodeOfConduct" Content="Enable Code of Conduct" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerWhitelist" Content="Whitelist (solo jugadores autorizados)" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerEnforceWhitelist" Content="Enforce Whitelist" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerHardcore" Content="Hardcore Mode" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerPvp" Content="PvP Enabled" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerForceGamemode" Content="Force Gamemode (fuerza el gamemode en login)" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerAllowFlight" Content="Allow Flight" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerHideOnlinePlayers" Content="Hide Online Players" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerAcceptsTransfers" Content="Accepts Transfers" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerGenerateStructures" Content="Generate Structures" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerSyncChunkWrites" Content="Sync Chunk Writes" Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="ServerLogIPs" Content="Log IPs" Foreground="White" Margin="0,0,0,20" FontSize="12"/>
                        
                        <StackPanel Orientation="Horizontal" HorizontalAlignment="Left">
                            <Button x:Name="SaveServerPropertiesBtn" Content="Guardar Propiedades del Servidor" Width="270" Height="45" 
                                    Background="#4CAF50" Foreground="White" FontWeight="Bold" FontSize="14"
                                    Cursor="Hand" Margin="0,0,10,0"/>
                            <Button x:Name="ReloadServerPropertiesBtn" Content="Recargar Propiedades" Width="200" Height="45" 
                                    Background="#2196F3" Foreground="White" FontWeight="Bold" FontSize="14"
                                    Cursor="Hand"/>
                        </StackPanel>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>

            <!-- Tab: Configuracion -->
            <TabItem x:Name="TabConfiguracion" Header="Configuracion">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel Margin="20">
                        
                        <!-- Auto-Shutdown -->
                        <TextBlock x:Name="LblAutoShutdown" Text="Auto-Shutdown" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="AutoShutdownCheck" Content="Activar apagado automatico por inactividad" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <TextBlock x:Name="LblIdleMsg" Text="(Apagara el servidor cuando no hay jugadores por X minutos)" Foreground="#999999" FontSize="10" Margin="0,0,0,10" TextWrapping="Wrap"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,15">
                            <TextBlock x:Name="LblIdleMinutes" Text="Minutos inactivo:" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="IdleMinutesBox" Width="80" Height="40" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="30" FontSize="12"/>
                        </StackPanel>
                        <CheckBox x:Name="ShutdownPCCheck" Content="Apagar computadora despues de cerrar el servidor" 
                                  Foreground="White" Margin="0,0,0,15" FontSize="12"/>
                        <CheckBox x:Name="OnlyShutdownOutsideHoursCheck" Content="Solo apagar fuera de horas de operacion (no interrumpir durante horarios)" 
                                  Foreground="White" Margin="0,0,0,30" FontSize="12"/>
                        
                        <!-- Horarios -->
                        <TextBlock x:Name="LblOperatingHours" Text="Horarios de Operacion" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="EnableOperatingHoursCheck" Content="Activar horarios de operacion (24/7 si esta deshabilitado)" 
                                  Foreground="White" Margin="0,0,0,15" FontSize="12"/>
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
                                <TextBox x:Name="StartHourBox" Width="60" Height="40" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="08" FontSize="12" MaxLength="2"/>
                                <TextBlock Text=":" VerticalAlignment="Center" Margin="5,0" FontSize="14"/>
                                <TextBox x:Name="StartMinBox" Width="60" Height="40" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="00" FontSize="12" MaxLength="2"/>
                            </StackPanel>
                            
                            <TextBlock x:Name="LblEndTime" Grid.Row="2" Grid.Column="0" Text="Hora fin:" VerticalAlignment="Center" FontSize="12"/>
                            <StackPanel Grid.Row="2" Grid.Column="1" Orientation="Horizontal">
                                <TextBox x:Name="StopHourBox" Width="60" Height="40" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="23" FontSize="12" MaxLength="2"/>
                                <TextBlock Text=":" VerticalAlignment="Center" Margin="5,0" FontSize="14"/>
                                <TextBox x:Name="StopMinBox" Width="60" Height="40" Padding="8" 
                                         Background="#3C3C3C" Foreground="White" Text="30" FontSize="12" MaxLength="2"/>
                            </StackPanel>
                        </Grid>
                        <TextBlock x:Name="LblHoursRange" Text="(Horas: 0-23, Minutos: 0-59)" Foreground="#999999" FontSize="10" Margin="0,0,0,30" TextWrapping="Wrap"/>
                        
                        <!-- Auto-Backup -->
                        <TextBlock x:Name="LblAutoBackup" Text="Auto-Backup" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="AutoBackupCheck" Content="Activar backup automatico periodico" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <CheckBox x:Name="BackupBeforeCloseCheck" Content="Hacer backup antes de cerrar el servidor" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,20">
                            <TextBlock x:Name="LblIntervalMin" Text="Intervalo (min):" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="BackupIntervalBox" Width="80" Height="40" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="60" FontSize="12"/>
                        </StackPanel>

                        <!-- Auto Clear Console -->
                        <TextBlock x:Name="LblConsoleSettings" Text="Consola" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <CheckBox x:Name="EnableConsoleLoggingCheck" Content="Habilitar logging de consola (registra estado en archivos)" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <TextBlock x:Name="LblMonitoringMessages" Text="(Mostrara mensajes de monitoreo: jugadores, inactividad, etc.)" Foreground="#999999" FontSize="10" Margin="0,0,0,10" TextWrapping="Wrap"/>
                        <CheckBox x:Name="AutoClearCheck" Content="Limpiar consola automatico" 
                                  Foreground="White" Margin="0,0,0,10" FontSize="12"/>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,10">
                            <TextBlock x:Name="LblEveryMin" Text="Cada (min):" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="AutoClearMinutesBox" Width="80" Height="40" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="0" FontSize="12"/>
                        </StackPanel>
                        <StackPanel Orientation="Horizontal" Margin="0,0,0,30">
                            <TextBlock x:Name="LblLineLimit" Text="Limite lineas:" VerticalAlignment="Center" Margin="0,0,10,0" FontSize="12"/>
                            <TextBox x:Name="AutoClearLinesBox" Width="80" Height="40" Padding="8" 
                                     Background="#3C3C3C" Foreground="White" Text="500" FontSize="12"/>
                        </StackPanel>
                        
                        <!-- Idioma -->
                        <TextBlock x:Name="LblLanguage" Text="Idioma" FontSize="14" FontWeight="Bold" Margin="0,0,0,10" Foreground="#4CAF50"/>
                        <ComboBox x:Name="LanguageSelect" Width="200" Height="35" Margin="0,0,0,30" HorizontalAlignment="Left">
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
$script:shutdownPCAfterServer = $false
$script:enableOperatingHours = $false
$script:onlyShutdownOutsideHours = $false
$script:enableConsoleLogging = $false
$script:startHourSaved = 8  # Default operating hours
$script:startMinSaved = 0
$script:stopHourSaved = 23
$script:stopMinSaved = 30
$script:consoleLogsDir = Join-Path $scriptPath "logs"
$script:autoBackupEnabled = $false
$script:backupBeforeCloseEnabled = $false
$script:backupIntervalMinutes = 60
$script:autoClearEnabled = $false
$script:autoClearMinutes = 0
$script:autoClearMaxLines = 500
$script:lastClearTime = Get-Date
$script:consoleStickToBottom = $true
$script:serverState = "idle"  # idle|starting|running|stopping
$script:onlinePlayers = @()
$script:backupDisplayToActual = @{}  # Mapeo de display a nombre real
$script:isRefreshingBackups = $false  # Flag para evitar llamadas recursivas
$script:serverFullyLoaded = $false  # Server loaded flags
$script:serverLoadFlag1 = $false  # "Preparing level" flag
$script:serverLoadFlag2 = $false  # "Dedicated server took X seconds to load" flag
$script:serverLoadStartTime = $null  # Timer for 30-second timeout on flag 2
$script:lastPlayerSeenTime = $null  # Last time a player was detected
$script:idleCheckTimer = $null  # Timer para verificar inactividad
$script:lastServerPath = ""
$script:lastServerConfigPath = Join-Path $scriptPath "config\last_server.txt"
$script:currentLanguage = "es"
$script:languageConfigPath = Join-Path $scriptPath "config\language.txt"
$script:settingsConfigPath = Join-Path $scriptPath "config\settings.json"

$script:translations = @{
    es = @{
        app_title = "SERVER LAUNCH"; app_subtitle = "Gestor de Servidores Minecraft"
        server = "Servidor"; browse = "Examinar"; playit_optional = "PlayIT (Opcional)"
        server_control = "Control del Servidor"; start = "Iniciar"; stop = "Detener"
        restart = "Reiniciar"; terminate = "Terminar"; backups = "Backups"; restore = "Restaurar"; reload_backups = "Recargar"
        status = "Estado"; console = "Consola"; clear_console = "Limpiar Consola"; send_command = "Enviar"
        players_online = "Jugadores Online"; no_players = "Sin jugadores conectados"
        ip_server = "IP Server"; ip_voicechat = "IP Voicechat"; copy = "Copiar"
        open_playit = "Abrir Panel de PlayIT"; playit_status = "Estado"; playit_not_started = "PlayIT no iniciado"
        not_detected = "No detectado"; ips_detected = "IPs detectadas correctamente"
        auto_shutdown = "Auto-Shutdown"; enable_auto_shutdown = "Activar apagado automatico por inactividad"
        idle_minutes = "Minutos inactivo:"; shutdown_pc = "Apagar computadora despues de cerrar el servidor"
        only_shutdown_outside = "Solo apagar fuera de horas de operacion (no interrumpir durante horarios)"
        enable_console_logging = "Habilitar logging de consola (registra estado en archivos)"
        enable_operating_hours = "Activar horarios de operacion (24/7 si esta deshabilitado)"; operating_hours = "Horarios de Operacion"
        start_on_boot = "Iniciar servidor al encender PC"; start_time = "Hora inicio:"
        end_time = "Hora fin:"; auto_backup = "Auto-Backup"; enable_auto_backup = "Activar backup automatico periodico"
        backup_before_close = "Hacer backup antes de cerrar el servidor"
        interval_min = "Intervalo (min):"; console_settings = "Consola"; auto_clear = "Limpiar consola automatico"
        every_min = "Cada (min):"; line_limit = "Limite lineas:"; language = "Idioma"
        save_config = "Guardar Configuracion"; select_server = "Selecciona un servidor primero"
        error = "Error"; success = "Exito"; info = "Informacion"; warning = "Advertencia"; select_backup = "Selecciona un backup primero"
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
        error_loading = "Error al cargar servidor"; invalid_path = "Ruta invalida:"
        config_saved_msg = "Configuracion guardada correctamente"; error_saving = "Error al guardar:"
        hours_saved = "Horarios guardados:"; boot_enabled = "Inicio automatico habilitado"
        error_saving_hours = "Error guardando horarios:"; min_short = "min"; lines_short = "lineas"
        cannot_shutdown_during_hours = "No se puede apagar durante las horas de operacion configuradas. Desactiva 'Solo apagar fuera de horas' si es necesario apagar ahora."
        monitoring_messages = "(Mostrara mensajes de monitoreo: jugadores, inactividad, etc.)"
        tab_principal = "Principal"; tab_playit = "PlayIT"; tab_configuracion = "Configuracion"; tab_server_settings = "Configuracion del Servidor"
        server_fully_loaded = "Servidor completamente cargado"
        idle_shutdown_msg = "Servidor inactivo por X minutos - apagando"
        idle_msg = "(Apagara el servidor cuando no hay jugadores por X minutos)"
        server_ready_join = "Servidor listo - ya pueden unirse"
        ips_detected_success = "IPs detectadas correctamente"
        not_configured = "No configurado"
        hours_range = "(Horas: 0-23, Minutos: 0-59)"
        basic_settings = "Configuracion Basica"; world_settings = "Configuracion del Mundo"
        security_settings = "Seguridad y Caracteristicas"
        motd = "MOTD (Message of the Day):"; max_players = "Max Players:"
        view_distance = "View Distance:"; simulation_distance = "Simulation Distance:"
        spawn_protection = "Spawn Protection:"; player_idle_timeout = "Player Idle Timeout:"
        level_name = "Level Name:"; level_seed = "Level Seed:"; level_type = "Level Type:"
        gamemode = "Gamemode:"; difficulty = "Difficulty:"; max_tick_time = "Max Tick Time:"
        max_world_size = "Max World Size:"; online_mode = "Online Mode (verificacion de cuentas Mojang)"
        enforce_secure_profile = "Enforce Secure Profile"; enable_code_of_conduct = "Enable Code of Conduct"
        whitelist = "Whitelist (solo jugadores autorizados)"; enforce_whitelist = "Enforce Whitelist"
        hardcore_mode = "Hardcore Mode"; pvp_enabled = "PvP Enabled"
        force_gamemode = "Force Gamemode (fuerza el gamemode en login)"
        allow_flight = "Allow Flight"; hide_online_players = "Hide Online Players"
        accepts_transfers = "Accepts Transfers"; generate_structures = "Generate Structures"
        sync_chunk_writes = "Sync Chunk Writes"; log_ips = "Log IPs"
        save_server_properties = "Guardar Propiedades del Servidor"
        reload_server_properties = "Recargar Propiedades"
        server_properties_saved = "Propiedades del servidor guardadas correctamente"
        server_properties_applied = "Propiedades aplicadas - reinicia el servidor para que tengan efecto"
        server_properties_reloaded = "Propiedades del servidor recargadas"
        error_saving_properties = "Error al guardar propiedades del servidor"
        run_bat_created = "run.bat creado correctamente en:"; eula_accepted = "EULA aceptado automaticamente"
        no_server_jar = "No se encontro server.jar ni run.bat en el directorio del servidor"
        generating_properties = "Generando server.properties - iniciando servidor brevemente..."
        properties_generated = "server.properties generado correctamente"; eula_accepted_successfully = "EULA aceptado exitosamente"
    }
    en = @{
        app_title = "SERVER LAUNCH"; app_subtitle = "Minecraft Server Manager"
        server = "Server"; browse = "Browse"; playit_optional = "PlayIT (Optional)"
        server_control = "Server Control"; start = "Start"; stop = "Stop"
        restart = "Restart"; terminate = "Kill"; backups = "Backups"; restore = "Restore"; reload_backups = "Reload"
        status = "Status"; console = "Console"; clear_console = "Clear Console"; send_command = "Send"
        players_online = "Players Online"; no_players = "No players connected"
        ip_server = "Server IP"; ip_voicechat = "Voicechat IP"; copy = "Copy"
        open_playit = "Open PlayIT Panel"; playit_status = "Status"; playit_not_started = "PlayIT not started"
        not_detected = "Not detected"; ips_detected = "IPs detected successfully"
        auto_shutdown = "Auto-Shutdown"; enable_auto_shutdown = "Enable automatic shutdown on idle"
        idle_minutes = "Idle minutes:"; shutdown_pc = "Shutdown computer after closing server"
        only_shutdown_outside = "Only shutdown outside operating hours (do not interrupt)"
        enable_console_logging = "Enable console logging (records status in files)"
        enable_operating_hours = "Enable operating hours (24/7 if disabled)"; operating_hours = "Operating Hours"
        start_on_boot = "Start server on PC boot"; start_time = "Start time:"
        end_time = "End time:"; auto_backup = "Auto-Backup"; enable_auto_backup = "Enable automatic periodic backup"
        backup_before_close = "Backup before closing server"
        interval_min = "Interval (min):"; console_settings = "Console"; auto_clear = "Auto-clear console"
        every_min = "Every (min):"; line_limit = "Line limit:"; language = "Language"
        save_config = "Save Settings"; select_server = "Select a server first"
        error = "Error"; success = "Success"; info = "Information"; warning = "Warning"; select_backup = "Select a backup first"
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
        cannot_shutdown_during_hours = "Cannot shutdown during configured operating hours. Disable 'Only shutdown outside hours' if you need to shutdown now."
        monitoring_messages = "(Will show monitoring messages: players, inactivity, etc.)"
        tab_principal = "Main"; tab_playit = "PlayIT"; tab_configuracion = "Settings"; tab_server_settings = "Server Settings"
        server_fully_loaded = "Server fully loaded"
        idle_shutdown_msg = "Server idle for X minutes - shutting down"
        idle_msg = "(Will shutdown server when no players for X minutes)"
        server_ready_join = "Server ready - players can join now"
        ips_detected_success = "IPs detected successfully"
        not_configured = "Not configured"
        hours_range = "(Hours: 0-23, Minutes: 0-59)"
        basic_settings = "Basic Settings"; world_settings = "World Settings"
        security_settings = "Security & Features"
        motd = "MOTD (Message of the Day):"; max_players = "Max Players:"
        view_distance = "View Distance:"; simulation_distance = "Simulation Distance:"
        spawn_protection = "Spawn Protection:"; player_idle_timeout = "Player Idle Timeout:"
        level_name = "Level Name:"; level_seed = "Level Seed:"; level_type = "Level Type:"
        gamemode = "Gamemode:"; difficulty = "Difficulty:"; max_tick_time = "Max Tick Time:"
        max_world_size = "Max World Size:"; online_mode = "Online Mode (Mojang account verification)"
        enforce_secure_profile = "Enforce Secure Profile"; enable_code_of_conduct = "Enable Code of Conduct"
        whitelist = "Whitelist (authorized players only)"; enforce_whitelist = "Enforce Whitelist"
        hardcore_mode = "Hardcore Mode"; pvp_enabled = "PvP Enabled"
        force_gamemode = "Force Gamemode (forces gamemode on login)"
        allow_flight = "Allow Flight"; hide_online_players = "Hide Online Players"
        accepts_transfers = "Accepts Transfers"; generate_structures = "Generate Structures"
        sync_chunk_writes = "Sync Chunk Writes"; log_ips = "Log IPs"
        save_server_properties = "Save Server Properties"
        reload_server_properties = "Reload Properties"
        server_properties_saved = "Server properties saved successfully"
        server_properties_applied = "Properties applied - restart server for changes to take effect"
        server_properties_reloaded = "Server properties reloaded"
        error_saving_properties = "Error saving server properties"
        run_bat_created = "run.bat created successfully at:"; eula_accepted = "EULA accepted automatically"
        no_server_jar = "server.jar or run.bat not found in server directory"
        generating_properties = "Generating server.properties - starting server briefly..."
        properties_generated = "server.properties generated successfully"; eula_accepted_successfully = "EULA accepted successfully"
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
    $window.FindName("ReloadBackupsBtn").Content = Get-Text 'reload_backups'
    $window.FindName("RestoreBackupBtn").Content = Get-Text 'restore'
    $window.FindName("SendCommandBtn").Content = Get-Text 'send_command'
    $window.FindName("ClearLog").Content = Get-Text 'clear_console'
    $window.FindName("CopyMinecraftIP").Content = Get-Text 'copy'
    $window.FindName("CopyVoicechatIP").Content = Get-Text 'copy'
    $window.FindName("OpenPlayitWeb").Content = Get-Text 'open_playit'
    $window.FindName("SaveConfigBtn").Content = Get-Text 'save_config'
    
    # CheckBoxes
    $window.FindName("AutoShutdownCheck").Content = Get-Text 'enable_auto_shutdown'
    $window.FindName("ShutdownPCCheck").Content = Get-Text 'shutdown_pc'
    $window.FindName("OnlyShutdownOutsideHoursCheck").Content = Get-Text 'only_shutdown_outside'
    $window.FindName("EnableOperatingHoursCheck").Content = Get-Text 'enable_operating_hours'
    $window.FindName("StartOnBootCheck").Content = Get-Text 'start_on_boot'
    $window.FindName("AutoBackupCheck").Content = Get-Text 'enable_auto_backup'
    $window.FindName("BackupBeforeCloseCheck").Content = Get-Text 'backup_before_close'
    $window.FindName("EnableConsoleLoggingCheck").Content = Get-Text 'enable_console_logging'
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
    $window.FindName("LblMonitoringMessages").Text = Get-Text 'monitoring_messages'
    $window.FindName("LblIdleMsg").Text = Get-Text 'idle_msg'
    $window.FindName("LblEveryMin").Text = Get-Text 'every_min'
    $window.FindName("LblLineLimit").Text = Get-Text 'line_limit'
    $window.FindName("LblLanguage").Text = Get-Text 'language'
    
    # Traducir rango de horas
    $window.FindName("LblHoursRange").Text = Get-Text 'hours_range'
    
    # Traducir pestañas
    $window.FindName("TabPrincipal").Header = Get-Text 'tab_principal'
    $window.FindName("TabPlayIT").Header = Get-Text 'tab_playit'
    $window.FindName("TabServerSettings").Header = Get-Text 'tab_server_settings'
    $window.FindName("TabConfiguracion").Header = Get-Text 'tab_configuracion'
    
    # TextBlocks - Tab Server Settings
    $window.FindName("LblBasicSettings").Text = Get-Text 'basic_settings'
    $window.FindName("LblWorldSettings").Text = Get-Text 'world_settings'
    $window.FindName("LblSecuritySettings").Text = Get-Text 'security_settings'
    $window.FindName("SaveServerPropertiesBtn").Content = Get-Text 'save_server_properties'
    $window.FindName("ReloadServerPropertiesBtn").Content = Get-Text 'reload_server_properties'
    
    # Traducciones de Server Settings - Labels
    try {
        $window.FindName("LblMotd").Text = "MOTD (Message of the Day):"
        $window.FindName("LblMaxPlayers").Text = "Max Players:"
        $window.FindName("LblViewDistance").Text = "View Distance:"
        $window.FindName("LblSimulationDistance").Text = "Simulation Distance:"
        $window.FindName("LblSpawnProtection").Text = "Spawn Protection:"
        $window.FindName("LblPlayerIdleTimeout").Text = "Player Idle Timeout:"
        $window.FindName("LblLevelName").Text = "Level Name:"
        $window.FindName("LblLevelSeed").Text = "Level Seed:"
        $window.FindName("LblLevelType").Text = "Level Type:"
        $window.FindName("LblGamemode").Text = "Gamemode:"
        $window.FindName("LblDifficulty").Text = "Difficulty:"
        $window.FindName("LblMaxTickTime").Text = "Max Tick Time:"
        $window.FindName("LblMaxWorldSize").Text = "Max World Size:"
    } catch { }
    
    # Actualizar estado inicial si no hay servidor cargado - similar a PlayIT
    $statusText = $window.FindName("StatusText")
    if ($statusText) {
        if (-not $script:serverManager -or -not $script:serverManager.IsRunning) {
            # Si el servidor NO está corriendo, mostrar "select_to_start"
            $statusText.Text = Get-Text 'select_to_start'
        } else {
            # Si el servidor está corriendo, mostrar "server_loaded"
            $statusText.Text = Get-Text 'server_loaded'
        }
    }
    
    # Actualizar jugadores si no hay ninguno conectado
    $playersBox = $window.FindName("PlayersBox")
    if ($playersBox -and $script:onlinePlayers.Count -eq 0) {
        $playersBox.Text = Get-Text 'no_players'
    }
    
    # Actualizar estado PlayIT si no esta iniciado
    $playitStatus = $window.FindName("PlayitStatus")
    if ($playitStatus -and (-not $script:playitProcess -or $script:playitProcess.HasExited)) {
        $playitStatus.Text = Get-Text 'playit_not_started'
    }
    
    # Actualizar IPs de PlayIT si no estan detectadas - solo si estan vacías
    $minecraftIP = $window.FindName("PlayitMinecraftIP")
    if ($minecraftIP -and [string]::IsNullOrWhiteSpace($minecraftIP.Text)) {
        $minecraftIP.Text = Get-Text 'not_detected'
    }
    $voicechatIP = $window.FindName("PlayitVoicechatIP")
    if ($voicechatIP -and [string]::IsNullOrWhiteSpace($voicechatIP.Text)) {
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

function Test-IsWithinOperatingHours {
    if (-not $script:enableOperatingHours) { return $false }
    
    try {
        $now = Get-Date
        $currentHour = $now.Hour
        $currentMin = $now.Minute
        $currentTotalMin = $currentHour * 60 + $currentMin
        
        # Usar las variables guardadas o el ScheduleManager
        $startH = if ($script:scheduleManager) { $script:scheduleManager.StartHour } else { $script:startHourSaved }
        $startM = if ($script:scheduleManager) { $script:scheduleManager.StartMin } else { $script:startMinSaved }
        $stopH = if ($script:scheduleManager) { $script:scheduleManager.StopHour } else { $script:stopHourSaved }
        $stopM = if ($script:scheduleManager) { $script:scheduleManager.StopMin } else { $script:stopMinSaved }
        
        $startTotal = $startH * 60 + $startM
        $stopTotal = $stopH * 60 + $stopM
        
        if ($startTotal -le $stopTotal) {
            return ($currentTotalMin -ge $startTotal -and $currentTotalMin -lt $stopTotal)
        } else {
            # Hours cross midnight
            return ($currentTotalMin -ge $startTotal -or $currentTotalMin -lt $stopTotal)
        }
    } catch {
        return $false
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
    Update-Status "server_stopped_status" "#FF6B6B"
    Append-Log "[Sistema] Todos los servicios detenidos correctamente"
    Set-ControlState "idle"
    
    # Backup before close if enabled
    if ($script:backupBeforeCloseEnabled -and $script:backupManager) {
        try {
            Append-Log "[Backup] Realizando backup antes de cerrar..."
            $script:backupManager.RunBackup()
            Append-Log "[Backup] Backup completado antes de cerrar"
        } catch {
            Append-Log "[Backup][ERROR] Error al realizar backup antes de cerrar: $_"
        }
    }
    
    # Shutdown PC if enabled
    if ($script:shutdownPCAfterServer) {
        Append-Log "[Sistema] Apagando computadora..."
        cmd /c "shutdown /s /f /t 0"
    }
}

# Funciones auxiliares
function Update-Status {
    param([string]$msg, [string]$color = "#FFB74D")
    # Intentar traducir el mensaje
    $translatedMsg = Get-Text $msg
    if ($translatedMsg -eq $msg) {
        # Si no hay traducción, usar el mensaje como está
        $statusText = $msg
    } else {
        $statusText = $translatedMsg
    }
    $window.FindName("StatusText").Text = $statusText
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
        
        # Log to file if console logging is enabled
        if ($script:enableConsoleLogging) {
            try {
                $logDir = $script:consoleLogsDir
                if (-not (Test-Path $logDir)) {
                    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
                }
                $logFile = Join-Path $logDir ("console_$(Get-Date -Format 'yyyyMMdd').log")
                $logEntry = "[$timestamp] $line"
                Add-Content -Path $logFile -Value $logEntry -Encoding UTF8 -ErrorAction SilentlyContinue
            } catch { }
        }
        
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

# Funciones para server.properties
function Load-ServerProperties {
    param([string]$serverPath)
    
    if (-not $serverPath) { return }
    
    $propsFile = Join-Path $serverPath "server.properties"
    if (-not (Test-Path $propsFile)) { 
        Append-Log "[Server] server.properties no encontrado - cargando valores por defecto"
        return 
    }
    
    try {
        $props = @{}
        Get-Content $propsFile -Encoding UTF8 | ForEach-Object {
            if ($_ -match '^([^#][^=]+)=(.*)$') {
                $key = $matches[1].Trim()
                $value = $matches[2].Trim()
                $props[$key] = $value
            }
        }
        
        # Cargar valores en la UI
        # Cargar valores en la UI
        if ($props.ContainsKey("motd")) { 
            $window.FindName("ServerMOTD").Text = $props["motd"] 
        }
        if ($props.ContainsKey("max-players")) { 
            $window.FindName("ServerMaxPlayers").Text = $props["max-players"] 
        }
        if ($props.ContainsKey("view-distance")) { 
            $window.FindName("ServerViewDistance").Text = $props["view-distance"] 
        }
        if ($props.ContainsKey("simulation-distance")) { 
            $window.FindName("ServerSimulationDistance").Text = $props["simulation-distance"] 
        }
        if ($props.ContainsKey("spawn-protection")) { 
            $window.FindName("ServerSpawnProtection").Text = $props["spawn-protection"] 
        }
        if ($props.ContainsKey("player-idle-timeout")) { 
            $window.FindName("ServerIdleTimeout").Text = $props["player-idle-timeout"] 
        }
        if ($props.ContainsKey("level-name")) { 
            $window.FindName("ServerLevelName").Text = $props["level-name"] 
        }
        if ($props.ContainsKey("level-seed")) { 
            $window.FindName("ServerLevelSeed").Text = $props["level-seed"] 
        }
        if ($props.ContainsKey("max-tick-time")) { 
            $window.FindName("ServerMaxTickTime").Text = $props["max-tick-time"] 
        }
        if ($props.ContainsKey("max-world-size")) { 
            $window.FindName("ServerMaxWorldSize").Text = $props["max-world-size"] 
        }
        
        # ComboBoxes
        if ($props.ContainsKey("level-type")) {
            $combo = $window.FindName("ServerLevelType")
            $levelTypeValue = $props["level-type"]
            
            # Verificar si el usuario seleccionó algo recientemente
            $timeSinceLastUserSelection = if ($script:lastComboBoxUserSelection) { (Get-Date) - $script:lastComboBoxUserSelection } else { [TimeSpan]::MaxValue }
            
            # Solo actualizar si ha pasado más de 2 segundos desde la última selección del usuario
            if ($timeSinceLastUserSelection.TotalSeconds -gt 2) {
                foreach ($item in $combo.Items) {
                    if ($item.Tag -eq $levelTypeValue) {
                        $combo.SelectedItem = $item
                        break
                    }
                }
            }
        }
        if ($props.ContainsKey("gamemode")) {
            $combo = $window.FindName("ServerGamemode")
            
            # Verificar si el usuario seleccionó algo recientemente
            $timeSinceLastUserSelection = if ($script:lastComboBoxUserSelection) { (Get-Date) - $script:lastComboBoxUserSelection } else { [TimeSpan]::MaxValue }
            
            # Solo actualizar si ha pasado más de 2 segundos desde la última selección del usuario
            if ($timeSinceLastUserSelection.TotalSeconds -gt 2) {
                foreach ($item in $combo.Items) {
                    if ($item.Tag -eq $props["gamemode"]) {
                        $combo.SelectedItem = $item
                        break
                    }
                }
            }
        }
        if ($props.ContainsKey("difficulty")) {
            $combo = $window.FindName("ServerDifficulty")
            
            # Verificar si el usuario seleccionó algo recientemente
            $timeSinceLastUserSelection = if ($script:lastComboBoxUserSelection) { (Get-Date) - $script:lastComboBoxUserSelection } else { [TimeSpan]::MaxValue }
            
            # Solo actualizar si ha pasado más de 2 segundos desde la última selección del usuario
            if ($timeSinceLastUserSelection.TotalSeconds -gt 2) {
                foreach ($item in $combo.Items) {
                    if ($item.Tag -eq $props["difficulty"]) {
                        $combo.SelectedItem = $item
                        break
                    }
                }
            }
        }
        
        # CheckBoxes
        if ($props.ContainsKey("online-mode")) { 
            $window.FindName("ServerOnlineMode").IsChecked = ($props["online-mode"] -eq "true") 
        }
        if ($props.ContainsKey("enforce-secure-profile")) { 
            $window.FindName("ServerEnforceSecureProfile").IsChecked = ($props["enforce-secure-profile"] -eq "true") 
        }
        if ($props.ContainsKey("enable-code-of-conduct")) { 
            $window.FindName("ServerEnableCodeOfConduct").IsChecked = ($props["enable-code-of-conduct"] -eq "true") 
        }
        if ($props.ContainsKey("white-list")) { 
            $window.FindName("ServerWhitelist").IsChecked = ($props["white-list"] -eq "true") 
        }
        if ($props.ContainsKey("enforce-whitelist")) { 
            $window.FindName("ServerEnforceWhitelist").IsChecked = ($props["enforce-whitelist"] -eq "true") 
        }
        if ($props.ContainsKey("hardcore")) { 
            $window.FindName("ServerHardcore").IsChecked = ($props["hardcore"] -eq "true") 
        }
        if ($props.ContainsKey("pvp")) { 
            $window.FindName("ServerPvp").IsChecked = ($props["pvp"] -eq "true") 
        }
        if ($props.ContainsKey("force-gamemode")) { 
            $window.FindName("ServerForceGamemode").IsChecked = ($props["force-gamemode"] -eq "true") 
        }
        if ($props.ContainsKey("allow-flight")) { 
            $window.FindName("ServerAllowFlight").IsChecked = ($props["allow-flight"] -eq "true") 
        }
        if ($props.ContainsKey("hide-online-players")) { 
            $window.FindName("ServerHideOnlinePlayers").IsChecked = ($props["hide-online-players"] -eq "true") 
        }
        if ($props.ContainsKey("accepts-transfers")) { 
            $window.FindName("ServerAcceptsTransfers").IsChecked = ($props["accepts-transfers"] -eq "true") 
        }
        if ($props.ContainsKey("generate-structures")) { 
            $window.FindName("ServerGenerateStructures").IsChecked = ($props["generate-structures"] -eq "true") 
        }
        if ($props.ContainsKey("sync-chunk-writes")) { 
            $window.FindName("ServerSyncChunkWrites").IsChecked = ($props["sync-chunk-writes"] -eq "true") 
        }
        if ($props.ContainsKey("log-ips")) { 
            $window.FindName("ServerLogIPs").IsChecked = ($props["log-ips"] -eq "true") 
        }
        
        Append-Log "[Server] Propiedades del servidor cargadas"
    }
    catch {
        Append-Log "[Server][ERROR] Error al cargar server.properties: $_"
    }
}

function Save-ServerProperties {
    param([string]$serverPath)
    
    if (-not $serverPath) { 
        [System.Windows.MessageBox]::Show($window, (Get-Text 'select_server'), (Get-Text 'error'))
        return $false
    }
    
    $propsFile = Join-Path $serverPath "server.properties"
    if (-not (Test-Path $propsFile)) {
        Append-Log "[Server][WARN] server.properties no encontrado, se creara uno nuevo"
    }
    
    try {
        # Leer el archivo existente para preservar comentarios y orden
        $lines = @()
        if (Test-Path $propsFile) {
            $lines = Get-Content $propsFile -Encoding UTF8
        }
        
        # Función helper para actualizar una propiedad
        function Update-Property {
            param($key, $value)
            $found = $false
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match "^$key=") {
                    $lines[$i] = "$key=$value"
                    $found = $true
                    break
                }
            }
            if (-not $found) {
                $lines += "$key=$value"
            }
        }
        
        # Actualizar propiedades desde la UI
        Update-Property "motd" $window.FindName("ServerMOTD").Text
        Update-Property "max-players" $window.FindName("ServerMaxPlayers").Text
        Update-Property "view-distance" $window.FindName("ServerViewDistance").Text
        Update-Property "simulation-distance" $window.FindName("ServerSimulationDistance").Text
        Update-Property "spawn-protection" $window.FindName("ServerSpawnProtection").Text
        Update-Property "player-idle-timeout" $window.FindName("ServerIdleTimeout").Text
        Update-Property "level-name" $window.FindName("ServerLevelName").Text
        Update-Property "level-seed" $window.FindName("ServerLevelSeed").Text
        Update-Property "max-tick-time" $window.FindName("ServerMaxTickTime").Text
        Update-Property "max-world-size" $window.FindName("ServerMaxWorldSize").Text
        
        # ComboBoxes
        $levelType = $window.FindName("ServerLevelType").SelectedItem
        if ($levelType) { Update-Property "level-type" $levelType.Tag }
        
        $gamemode = $window.FindName("ServerGamemode").SelectedItem
        if ($gamemode) { Update-Property "gamemode" $gamemode.Tag }
        
        $difficulty = $window.FindName("ServerDifficulty").SelectedItem
        if ($difficulty) { Update-Property "difficulty" $difficulty.Tag }
        
        # CheckBoxes
        Update-Property "online-mode" $(if ($window.FindName("ServerOnlineMode").IsChecked) { "true" } else { "false" })
        Update-Property "enforce-secure-profile" $(if ($window.FindName("ServerEnforceSecureProfile").IsChecked) { "true" } else { "false" })
        Update-Property "enable-code-of-conduct" $(if ($window.FindName("ServerEnableCodeOfConduct").IsChecked) { "true" } else { "false" })
        Update-Property "white-list" $(if ($window.FindName("ServerWhitelist").IsChecked) { "true" } else { "false" })
        Update-Property "enforce-whitelist" $(if ($window.FindName("ServerEnforceWhitelist").IsChecked) { "true" } else { "false" })
        Update-Property "hardcore" $(if ($window.FindName("ServerHardcore").IsChecked) { "true" } else { "false" })
        Update-Property "pvp" $(if ($window.FindName("ServerPvp").IsChecked) { "true" } else { "false" })
        Update-Property "force-gamemode" $(if ($window.FindName("ServerForceGamemode").IsChecked) { "true" } else { "false" })
        Update-Property "allow-flight" $(if ($window.FindName("ServerAllowFlight").IsChecked) { "true" } else { "false" })
        Update-Property "hide-online-players" $(if ($window.FindName("ServerHideOnlinePlayers").IsChecked) { "true" } else { "false" })
        Update-Property "accepts-transfers" $(if ($window.FindName("ServerAcceptsTransfers").IsChecked) { "true" } else { "false" })
        Update-Property "generate-structures" $(if ($window.FindName("ServerGenerateStructures").IsChecked) { "true" } else { "false" })
        Update-Property "sync-chunk-writes" $(if ($window.FindName("ServerSyncChunkWrites").IsChecked) { "true" } else { "false" })
        Update-Property "log-ips" $(if ($window.FindName("ServerLogIPs").IsChecked) { "true" } else { "false" })
        
        # Guardar archivo
        Set-Content -Path $propsFile -Value $lines -Encoding UTF8
        
        Append-Log "[Server] $(Get-Text 'server_properties_saved')"
        return $true
    }
    catch {
        Append-Log "[Server][ERROR] $(Get-Text 'error_saving_properties'): $_"
        return $false
    }
}

function Create-RunBat {
    param([string]$serverPath)
    
    if (-not $serverPath) { return }
    
    $runBatPath = Join-Path $serverPath "run.bat"
    
    # No crear si ya existe
    if (Test-Path $runBatPath) { return }
    
    try {
        # Buscar Java 21 primero, luego otros
        $javaPath = $null
        $javaDirs = @(
            "C:\Program Files\Java\jdk-21",
            "C:\Program Files\Java\jre-21",
            "C:\Program Files\Java\jdk-17",
            "C:\Program Files\Java\jre-17"
        )
        
        foreach ($dir in $javaDirs) {
            $testPath = Join-Path $dir "bin\java.exe"
            if (Test-Path $testPath) {
                $javaPath = $testPath
                break
            }
        }
        
        if (-not $javaPath) {
            $javaPath = "java"  # Usar del PATH si no se encuentra
        }
        
        # Contenido del run.bat
        $content = @"
@echo off
"$javaPath" -Xmx2G -Xms1G -jar server.jar nogui
pause
"@
        
        Set-Content -Path $runBatPath -Value $content -Encoding ASCII
        Append-Log "[Server] $(Get-Text 'run_bat_created') $runBatPath"
    }
    catch {
        Append-Log "[Server][ERROR] Error al crear run.bat: $_"
    }
}

function Accept-EULA {
    param([string]$serverPath)
    
    if (-not $serverPath) { return }
    
    $eulaPath = Join-Path $serverPath "eula.txt"
    
    try {
        # Siempre crear o sobrescribir el eula.txt con eula=true
        $content = @"
#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://aka.ms/MinecraftEULA).
#$(Get-Date -Format "ddd MMM dd HH:mm:ss yyyy")
eula=true
"@
        
        Set-Content -Path $eulaPath -Value $content -Encoding UTF8
        Append-Log "[Server] $(Get-Text 'eula_accepted_successfully')"
    }
    catch {
        Append-Log "[Server][ERROR] Error al aceptar EULA: $_"
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
    # Evitar llamadas recursivas
    if ($script:isRefreshingBackups) { return }
    $script:isRefreshingBackups = $true
    
    try {
        if ($script:backupManager -and $script:serverManager) {
            $script:backupManager.CurrentServerName = $script:serverManager.ServerName
            $script:backupManager.CurrentServerPath = $script:serverManager.ServerPath
            
            $backups = $script:backupManager.GetBackupList()
            
            try {
                $comboBox = $window.FindName("BackupSelect")
                if ($comboBox) {
                    # GUARDAR LA SELECCIÓN ANTERIOR
                    $previousSelectedIndex = $comboBox.SelectedIndex
                    
                    # Limpiar items existentes
                    $comboBox.Items.Clear()
                    $comboBox.ItemsSource = $null
                    
                    # Guardar mapeo para usar luego
                    $script:backupMap = @{}
                    
                    foreach ($backup in $backups) {
                        if ($backup -match '(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})') {
                            $display = "$($matches[3])/$($matches[2])/$($matches[1]) $($matches[4]):$($matches[5]):$($matches[6])"
                        } else {
                            $display = $backup
                        }
                        
                        $item = New-Object System.Windows.Controls.ComboBoxItem
                        $item.Content = $display
                        $item.Tag = $backup
                        
                        # Guardar en mapeo
                        $script:backupMap[$display] = $backup
                        
                        [void]$comboBox.Items.Add($item)
                    }
                    
                    # Remover SelectionChanged anterior si existe
                    if ($comboBox.SelectionChanged) {
                        foreach ($handler in $comboBox.SelectionChanged.GetInvocationList()) {
                            $comboBox.RemoveHandler([System.Windows.Controls.Primitives.Selector]::SelectionChangedEvent, $handler)
                        }
                    }
                    
                    # Agregar handler para SelectionChanged
                    $script:backupSelectionChangedHandler = {
                        param($sender, $e)
                        
                        if ($e.AddedItems.Count -gt 0) {
                            $selected = $e.AddedItems[0]
                            
                            if ($selected -is [System.Windows.Controls.ComboBoxItem]) {
                                $sender.IsDropDownOpen = $false
                            }
                        }
                    }
                    
                    $comboBox.Add_SelectionChanged($script:backupSelectionChangedHandler)
                    
                    $comboBox.Height = 32
                    
                    if ($comboBox.Items.Count -eq 0) {
                        $comboBox.IsEnabled = $false
                    } else {
                        $comboBox.IsEnabled = $true
                        
                        # RESTAURAR LA SELECCIÓN ANTERIOR si sigue siendo válida
                        if ($previousSelectedIndex -ge 0 -and $previousSelectedIndex -lt $comboBox.Items.Count) {
                            $comboBox.SelectedIndex = $previousSelectedIndex
                        } else {
                            $comboBox.SelectedIndex = 0
                        }
                    }
                }
            }
            catch { }
        }
    }
    finally {
        $script:isRefreshingBackups = $false
    }
}

# Función genérica para proteger selección en ComboBox durante cambios
function Protect-ComboBoxSelection {
    param(
        [string]$ComboBoxName
    )
    
    $comboBox = $window.FindName($ComboBoxName)
    if ($comboBox) {
        # Guardar selección anterior
        $previousSelectedIndex = $comboBox.SelectedIndex
        
        # Ejecutar un refresh suave que dispara SelectionChanged sin resetear
        # Por ahora solo devolvemos el índice para que el caller lo pueda usar
        return $previousSelectedIndex
    }
    return -1
}

# Función para restaurar selección en ComboBox
function Restore-ComboBoxSelection {
    param(
        [string]$ComboBoxName,
        [int]$PreviousSelectedIndex
    )
    
    $comboBox = $window.FindName($ComboBoxName)
    if ($comboBox -and $previousSelectedIndex -ge 0 -and $previousSelectedIndex -lt $comboBox.Items.Count) {
        $comboBox.SelectedIndex = $previousSelectedIndex
    }
}

function Load-ServerPath {
    param([string]$path)
    if (-not (Test-Path $path)) { 
        Append-Log "[ERROR] Ruta invalida - $path"
        Update-Status "error_loading" "#FF6B6B"
        return 
    }
    
    # Verificar que exista server.jar o run.bat
    $hasServerJar = Test-Path (Join-Path $path "server.jar")
    $hasRunBat = Test-Path (Join-Path $path "run.bat")
    
    if (-not $hasServerJar -and -not $hasRunBat) {
        Append-Log "[ERROR] No se encontro server.jar ni run.bat en el directorio"
        Update-Status "error_loading" "#FF6B6B"
        $window.FindName("ServerPath").Text = ""
        return
    }
    
    $window.FindName("ServerPath").Text = $path
    try {
        $script:serverManager = [ServerManager]::new($path)
        $script:scheduleManager = [ScheduleManager]::new($path)
        $backupRoot = Join-Path $scriptPath "backups"
        $script:backupManager = [BackupManager]::new($backupRoot, { param($msg) Append-Log $msg })
        Update-Status "server_loaded" "#4CAF50"
        Append-Log "[Sistema] Servidor detectado: $($script:serverManager.ServerName)"
        Refresh-BackupList
        
        # Aceptar EULA automáticamente
        Accept-EULA -serverPath $path
        
        # Crear run.bat si no existe
        Create-RunBat -serverPath $path
        
        # Verificar si existe server.properties
        $propsFile = Join-Path $path "server.properties"
        if (-not (Test-Path $propsFile)) {
            Append-Log "[Server] Generando server.properties - iniciando servidor brevemente..."
            # Intentar iniciar el servidor brevemente para que genere server.properties
            if ($hasServerJar) {
                # Usar Java 21
                $javaPath = "C:\Program Files\Java\jdk-21\bin\java.exe"
                if (-not (Test-Path $javaPath)) {
                    $javaPath = "java"
                }
                
                # Iniciar servidor con timeout para que genere propiedades
                $psi = New-Object System.Diagnostics.ProcessStartInfo
                $psi.FileName = $javaPath
                $psi.Arguments = "-Xmx1G -Xms512M -jar server.jar nogui"
                $psi.WorkingDirectory = $path
                $psi.RedirectStandardOutput = $true
                $psi.RedirectStandardError = $true
                $psi.UseShellExecute = $false
                $psi.CreateNoWindow = $true
                
                try {
                    $proc = [System.Diagnostics.Process]::Start($psi)
                    if ($proc) {
                        $proc.WaitForExit(15000)  # Esperar 15 segundos para que genere las propiedades
                        if (-not $proc.HasExited) {
                            try { $proc.Kill() } catch { }
                        }
                        try { $proc.Dispose() } catch { }
                    }
                    Start-Sleep -Seconds 3  # Esperar 3 segundos adicionales para que escriba los archivos
                    
                    # Verificar si se generó
                    if (Test-Path $propsFile) {
                        Append-Log "[Server] server.properties generado correctamente"
                    } else {
                        Append-Log "[Server] server.properties aun no se ha generado"
                    }
                } catch {
                    Append-Log "[Server][WARN] No se pudo generar server.properties automáticamente - $_"
                }
            }
        }
    }
    catch {
        Append-Log "[ERROR] $(Get-Text 'error_loading') $_"
        Update-Status "error_loading" "#FF6B6B"
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

# Evento: TabControl - Cargar propiedades al seleccionar pestaña Server Settings
$mainTabControl = $window.FindName("MainTabControl")
if ($mainTabControl) {
    $mainTabControl.Add_SelectionChanged({
        $selectedTab = $mainTabControl.SelectedItem
        if ($selectedTab -and $selectedTab.Name -eq "TabServerSettings") {
            # Recargar propiedades del servidor si hay uno cargado
            if ($script:serverManager -and $script:serverManager.ServerPath) {
                Load-ServerProperties -serverPath $script:serverManager.ServerPath
            }
        }
        if ($selectedTab -and $selectedTab.Name -eq "TabPrincipal") {
            # Recargar lista de backups al abrir el tab Principal
            if ($script:backupManager -and $script:serverManager) {
                Refresh-BackupList
            }
        }
    })
}

# ComboBox: ServerLevelType SelectionChanged
$serverLevelType = $window.FindName("ServerLevelType")
if ($serverLevelType) {
    $serverLevelType.Add_SelectionChanged({
        param($s, $e)
        # Marcar timestamp para evitar que Load-ServerProperties resete esta selección
        $script:lastComboBoxUserSelection = Get-Date
        $s.IsDropDownOpen = $false
    })
}

# ComboBox: ServerGamemode SelectionChanged
$serverGamemode = $window.FindName("ServerGamemode")
if ($serverGamemode) {
    $serverGamemode.Add_SelectionChanged({
        param($s, $e)
        # Marcar timestamp para evitar que Load-ServerProperties resete esta selección
        $script:lastComboBoxUserSelection = Get-Date
        $s.IsDropDownOpen = $false
    })
}

# ComboBox: ServerDifficulty SelectionChanged
$serverDifficulty = $window.FindName("ServerDifficulty")
if ($serverDifficulty) {
    $serverDifficulty.Add_SelectionChanged({
        param($s, $e)
        # Marcar timestamp para evitar que Load-ServerProperties resete esta selección
        $script:lastComboBoxUserSelection = Get-Date
        $s.IsDropDownOpen = $false
    })
}

# Botón: Limpiar consola
$window.FindName("ClearLog").Add_Click({
    $box = $window.FindName("OutputBox")
    if ($box) { $box.Clear() }
    $script:lastClearTime = Get-Date
    $script:consoleStickToBottom = $true
})

# Botón: Enviar Comando
$window.FindName("SendCommandBtn").Add_Click({
    $commandInput = $window.FindName("CommandInput")
    if ($commandInput -and $commandInput.Text -and $script:cmdProcess) {
        $command = $commandInput.Text.Trim()
        if ($command) {
            try {
                $script:cmdProcess.StandardInput.WriteLine($command)
                $script:cmdProcess.StandardInput.Flush()
                Append-Log "[Comando] > $command"
                $commandInput.Clear()
            }
            catch {
                Append-Log "[ERROR] No se pudo enviar comando: $_"
            }
        }
    }
})

# Enter en TextBox de Comandos
$commandInput = $window.FindName("CommandInput")
if ($commandInput) {
    $commandInput.Add_KeyDown({
        param($s, $e)
        if ($e.Key -eq [System.Windows.Input.Key]::Return) {
            $e.Handled = $true
            $sendBtn = $window.FindName("SendCommandBtn")
            if ($sendBtn) {
                $sendBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
            }
        }
    })
}

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
        Update-Status "starting" "#FFB74D"
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
            
            # Iniciar PlayIT primero (solo si se configuró una ruta o existe la ruta por defecto)
            $playitToUse = $script:playitPath
            if (-not $playitToUse -or -not (Test-Path $playitToUse)) {
                # Intentar ruta por defecto si no está configurada
                $defaultPlayitPath = "C:\Program Files\playit_gg\bin\playit.exe"
                if (Test-Path $defaultPlayitPath) {
                    $playitToUse = $defaultPlayitPath
                }
            }
            
            if ($playitToUse -and (Test-Path $playitToUse)) {
                try {
                    $script:playitProcess = Start-Process -FilePath $playitToUse `
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
                if ($script:playitPath) {
                    Append-Log "[Sistema] PlayIT no encontrado en: $($script:playitPath)"
                } else {
                    Append-Log "[Sistema] PlayIT no configurado - ejecutando solo en LAN"
                }
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
                Update-Status "error_run_bat" "#FF6B6B"
                return
            }
            
            # Timer para leer logs en tiempo real
            $script:logTimer = New-Object System.Windows.Threading.DispatcherTimer
            $script:logTimer.Interval = [System.TimeSpan]::FromMilliseconds(1000)
            $script:logTimer.Add_Tick({
                # Leer output de PlayIT
                if (Test-Path $script:playitLog) {
                    try {
                        $fileInfo = Get-Item $script:playitLog -ErrorAction SilentlyContinue
                        if ($fileInfo -and $fileInfo.Length -gt 0) {
                            $lines = Get-Content $script:playitLog -Tail 50 -ErrorAction SilentlyContinue
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
                                                $window.FindName("PlayitStatus").Text = Get-Text 'ips_detected_success'
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
                    }
                    catch { }
                }
                
                # Leer output del servidor
                if (Test-Path $script:serverLog) {
                    try {
                        $fileInfo = Get-Item $script:serverLog -ErrorAction SilentlyContinue
                        if ($fileInfo -and $fileInfo.Length -gt 0) {
                            $lines = Get-Content $script:serverLog -Tail 100 -ErrorAction SilentlyContinue
                        if ($lines -and $lines.Count -gt $script:serverLastLine) {
                            $newLines = $lines[$script:serverLastLine..($lines.Count-1)]
                            foreach ($line in $newLines) {
                                $trimmed = $line.Trim()
                                if ($trimmed) {
                                    Append-Log "[Server] $trimmed"
                                    
                                    # Detectar Flag 1: "Preparing level"
                                    if ($trimmed -match "Preparing level" -and -not $script:serverLoadFlag1) {
                                        $script:serverLoadFlag1 = $true
                                        $script:serverLoadStartTime = Get-Date
                                        Append-Log "[Server] FLAG 1 DETECTED: Server preparing level (starting to load)"
                                    }
                                    
                                    # Detectar Flag 2: "Dedicated server took X seconds to load"
                                    if ($trimmed -match "Dedicated server took.*seconds to load" -and -not $script:serverLoadFlag2) {
                                        $script:serverLoadFlag2 = $true
                                        Append-Log "[Server] FLAG 2 DETECTED: Server fully loaded"
                                        # Ambas flags detectadas - servidor completamente listo
                                        if ($script:serverLoadFlag1 -and $script:serverLoadFlag2) {
                                            $script:serverFullyLoaded = $true
                                            Update-Status "server_ready_join" "#4CAF50"
                                            Append-Log "[Server] SERVER FULLY LOADED - Auto-Shutdown and Operating Hours now active"
                                        }
                                    }
                                    
                                    # Timeout: si pasaron 30 segundos desde flag 1, forzar flag 2
                                    if ($script:serverLoadFlag1 -and -not $script:serverLoadFlag2 -and $script:serverLoadStartTime) {
                                        $elapsed = (Get-Date) - $script:serverLoadStartTime
                                        if ($elapsed.TotalSeconds -ge 30) {
                                            $script:serverLoadFlag2 = $true
                                            Append-Log "[Server] FLAG 2 TIMEOUT: 30s passed, auto-enabling server as fully loaded"
                                            $script:serverFullyLoaded = $true
                                            Update-Status "server_ready_join" "#4CAF50"
                                        }
                                    }
                                    
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
                                    
                                    # Actualizar tiempo de último jugador visto
                                    if ($script:onlinePlayers.Count -gt 0) {
                                        $script:lastPlayerSeenTime = Get-Date
                                    }
                                }
                            }
                            $script:serverLastLine = $lines.Count
                        }
                        }
                    }
                    catch { }
                }
                
                # Auto-Shutdown por inactividad (solo después de que servidor está completamente cargado)
                if ($script:serverFullyLoaded -and $script:autoShutdownEnabled -and $script:serverState -eq "running") {
                    if ($script:onlinePlayers.Count -eq 0) {
                        # No hay jugadores - comprobar inactividad
                        if ($null -eq $script:lastPlayerSeenTime) {
                            $script:lastPlayerSeenTime = Get-Date
                        }
                        
                        $minutesSinceLastPlayer = ((Get-Date) - $script:lastPlayerSeenTime).TotalMinutes
                        if ($minutesSinceLastPlayer -ge $script:autoShutdownMinutes) {
                            # Verificar horarios ANTES de apagar (en caso de que se hayan actualizado)
                            if (-not ($script:onlyShutdownOutsideHours -and (Test-IsWithinOperatingHours))) {
                                Append-Log "[Auto-Shutdown] Servidor inactivo por $($script:autoShutdownMinutes) minutos - apagando"
                                
                                # Llamar a StopBtn logic
                                $stopBtn = $window.FindName("StopBtn")
                                if ($stopBtn -and $stopBtn.IsEnabled) {
                                    $stopBtn.RaiseEvent([System.Windows.RoutedEventArgs]::new([System.Windows.Controls.Button]::ClickEvent))
                                }
                            } else {
                                Append-Log "[Auto-Shutdown] Dentro de horarios de operacion - no se apaga"
                            }
                        }
                    } else {
                        # Hay jugadores - resetear el timer
                        $script:lastPlayerSeenTime = Get-Date
                    }
                }
                
                # Verificar si el servidor sigue corriendo
                if ($script:serverProcess -and $script:serverProcess.HasExited) {
                    Append-Log "[Server] El servidor se ha detenido"
                    Cleanup-AfterServerStopped
                }
            })
            $script:logTimer.Start()
            
            # Resetear flags de carga del servidor y timers de auto-shutdown
            $script:serverFullyLoaded = $false
            $script:serverLoadFlag1 = $false
            $script:serverLoadFlag2 = $false
            $script:serverLoadStartTime = $null
            $script:lastPlayerSeenTime = $null  # Resetear inactividad timer
            $script:onlinePlayers = @()  # Limpiar lista de jugadores
            
            Update-Status "server_running" "#4CAF50"
            Append-Log "[Sistema] Todos los servicios iniciados correctamente"
            Set-ControlState "running"
        }
        catch {
            Append-Log "[ERROR] Error al iniciar: $_"
            Update-Status "error_starting" "#FF6B6B"
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
    
    # Check if only shutdown outside operating hours and we're currently within them
    if ($script:onlyShutdownOutsideHours -and (Test-IsWithinOperatingHours)) {
        $now = Get-Date -Format "HH:mm:ss"
        Append-Log "[Sistema] Cannot shutdown during operating hours ($now). Disabled to prevent interruption."
        [System.Windows.MessageBox]::Show($window, 
            (Get-Text 'cannot_shutdown_during_hours'),
            (Get-Text 'warning'),
            [System.Windows.MessageBoxButton]::OK,
            [System.Windows.MessageBoxImage]::Warning)
        return
    }
    
    if ($script:serverManager) {
        Set-ControlState "stopping"
        Update-Status "stopping" "#FFB74D"
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
                    Update-Status "still_running" "#FFB74D"
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
    Append-Log "[Sistema] Terminando proceso Java del servidor..."
    if ($script:serverManager -and $script:serverManager.ServerPath) {
        $javaProcs = Get-ServerJavaProcesses $script:serverManager.ServerPath
        foreach ($proc in $javaProcs) {
            try {
                Stop-Process -Id $proc.Id -Force
                Append-Log "[Sistema] Proceso Java terminado (PID: $($proc.Id))"
            } catch {
                Append-Log "[Sistema][WARN] No se pudo terminar proceso PID $($proc.Id): $_"
            }
        }
    }
    if ($script:serverManager) {
        $script:serverManager.IsRunning = $false
    }
    Update-Status "processes_killed" "#FF6B6B"
    Set-ControlState "idle"
})

# Botón: Recargar Backups
$window.FindName("ReloadBackupsBtn").Add_Click({
    if ($script:backupManager -and $script:serverManager) {
        Append-Log "[Backup] Recargando lista de backups..."
        Refresh-BackupList
        Append-Log "[Backup] Lista de backups recargada"
    }
})

# Botón: Restaurar Backup
$window.FindName("RestoreBackupBtn").Add_Click({
    if ($script:backupManager -and $script:serverManager) {
        $comboBox = $window.FindName("BackupSelect")
        $selectedItem = $comboBox.SelectedItem
        
        if ($selectedItem -and $selectedItem -is [System.Windows.Controls.ComboBoxItem]) {
            $actualBackup = $selectedItem.Tag
            $selectedDisplay = $selectedItem.Content
            
            if ($actualBackup) {
                Append-Log "[Backup] Restaurando backup: $selectedDisplay"
                Update-Status "restoring" "#FFB74D"
                try {
                    # Asegurar que BackupManager tiene la info del servidor
                    $script:backupManager.CurrentServerName = $script:serverManager.ServerName
                    $script:backupManager.CurrentServerPath = $script:serverManager.ServerPath
                    
                    $result = $script:backupManager.RestoreBackup($actualBackup)
                    if ($result) {
                            Append-Log "[Backup] Restauracion completada"
                        Update-Status "backup_restored" "#4CAF50"
                    } else {
                        Append-Log "[ERROR] Fallo la restauracion"
                        Update-Status "error_restoring" "#FF6B6B"
                    }
                }
                catch {
                    Append-Log "[ERROR] $_"
                    Update-Status "error_restoring" "#FF6B6B"
                }
            }
        } else {
                [System.Windows.MessageBox]::Show($window, "Selecciona un backup primero", "Error")
        }
    }
})

# Botón: Guardar Propiedades del Servidor
$window.FindName("SaveServerPropertiesBtn").Add_Click({
    if (-not $script:serverManager -or -not $script:serverManager.ServerPath) {
        [System.Windows.MessageBox]::Show($window, (Get-Text 'select_server'), (Get-Text 'error'))
        return
    }
    
    try {
        $success = Save-ServerProperties -serverPath $script:serverManager.ServerPath
        if ($success) {
            [System.Windows.MessageBox]::Show($window, (Get-Text 'server_properties_applied'), (Get-Text 'success'),
                [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        } else {
            [System.Windows.MessageBox]::Show($window, (Get-Text 'error_saving_properties'), (Get-Text 'error'),
                [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
        }
    }
    catch {
        Append-Log "[Server][ERROR] $_"
        [System.Windows.MessageBox]::Show($window, "$(Get-Text 'error_saving_properties'): $_", (Get-Text 'error'),
            [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    }
})

# Botón: Recargar Propiedades del Servidor
$window.FindName("ReloadServerPropertiesBtn").Add_Click({
    if (-not $script:serverManager -or -not $script:serverManager.ServerPath) {
        [System.Windows.MessageBox]::Show($window, (Get-Text 'select_server'), (Get-Text 'error'))
        return
    }
    
    try {
        Load-ServerProperties -serverPath $script:serverManager.ServerPath
        Append-Log "[Server] $(Get-Text 'server_properties_reloaded')"
        [System.Windows.MessageBox]::Show($window, (Get-Text 'server_properties_reloaded'), (Get-Text 'success'),
            [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    }
    catch {
        Append-Log "[Server][ERROR] Error al recargar propiedades: $_"
        [System.Windows.MessageBox]::Show($window, "Error al recargar propiedades: $_", (Get-Text 'error'),
            [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
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
        
        # Shutdown PC option
        $shutdownPCCheck = $window.FindName("ShutdownPCCheck")
        if ($shutdownPCCheck) {
            $script:shutdownPCAfterServer = $shutdownPCCheck.IsChecked
        }
        
        # Only shutdown outside operating hours
        $onlyShutdownOutsideCheck = $window.FindName("OnlyShutdownOutsideHoursCheck")
        if ($onlyShutdownOutsideCheck) {
            $script:onlyShutdownOutsideHours = $onlyShutdownOutsideCheck.IsChecked
        }
        
        # Console logging
        $enableLoggingCheck = $window.FindName("EnableConsoleLoggingCheck")
        if ($enableLoggingCheck) {
            $script:enableConsoleLogging = $enableLoggingCheck.IsChecked
            # Create logs directory if logging is enabled
            if ($script:enableConsoleLogging) {
                $logsPath = $script:consoleLogsDir
                if (-not (Test-Path $logsPath)) {
                    New-Item -ItemType Directory -Path $logsPath -Force | Out-Null
                }
            }
        }
        
        # Operating Hours validation and save
        $enableHoursCheck = $window.FindName("EnableOperatingHoursCheck")
        if ($enableHoursCheck) {
            $script:enableOperatingHours = $enableHoursCheck.IsChecked
        }
        
        # Horarios con validacion
        $startHText = $window.FindName("StartHourBox").Text
        $startMText = $window.FindName("StartMinBox").Text
        $stopHText = $window.FindName("StopHourBox").Text
        $stopMText = $window.FindName("StopMinBox").Text
        
        # Validar y limitar valores
        if (-not [int]::TryParse($startHText, [ref]$null)) { $startHText = "08" }
        if (-not [int]::TryParse($startMText, [ref]$null)) { $startMText = "00" }
        if (-not [int]::TryParse($stopHText, [ref]$null)) { $stopHText = "23" }
        if (-not [int]::TryParse($stopMText, [ref]$null)) { $stopMText = "30" }
        
        $startH = [Math]::Max(0, [Math]::Min(23, [int]$startHText))
        $startM = [Math]::Max(0, [Math]::Min(59, [int]$startMText))
        $stopH = [Math]::Max(0, [Math]::Min(23, [int]$stopHText))
        $stopM = [Math]::Max(0, [Math]::Min(59, [int]$stopMText))
        
        # Actualizar textboxes con valores validados
        $window.FindName("StartHourBox").Text = $startH.ToString().PadLeft(2, '0')
        $window.FindName("StartMinBox").Text = $startM.ToString().PadLeft(2, '0')
        $window.FindName("StopHourBox").Text = $stopH.ToString().PadLeft(2, '0')
        $window.FindName("StopMinBox").Text = $stopM.ToString().PadLeft(2, '0')
        
        # Guardar en variables globales para que se usen en auto-shutdown
        $script:startHourSaved = $startH
        $script:startMinSaved = $startM
        $script:stopHourSaved = $stopH
        $script:stopMinSaved = $stopM
        
        if ($script:enableOperatingHours -and $script:scheduleManager) {
            try {
                $script:scheduleManager.SetOperatingHours($startH, $startM, $stopH, $stopM)
                Append-Log "[Config] Operating hours saved: ${startH}:${startM} - ${stopH}:${stopM}"
            } catch {
                Append-Log "[Config] Error saving hours: $_"
            }
            
            $bootCheck = $window.FindName("StartOnBootCheck")
            if ($bootCheck -and $bootCheck.IsChecked) {
                try {
                    $script:scheduleManager.EnableBootAutoStart()
                    Append-Log "[Config] Boot autostart enabled"
                } catch { }
            }
        } else {
            Append-Log "[Config] Operating hours disabled (24/7 mode)"
        }
        
        # Auto-Backup
        $backupCheck = $window.FindName("AutoBackupCheck")
        if ($backupCheck) {
            $script:autoBackupEnabled = $backupCheck.IsChecked
        }
        $backupText = $window.FindName("BackupIntervalBox").Text
        if ([string]::IsNullOrEmpty($backupText)) { $backupText = "60" }
        $script:backupIntervalMinutes = [int]$backupText
        
        # Backup Before Close
        $backupBeforeCloseCheck = $window.FindName("BackupBeforeCloseCheck")
        if ($backupBeforeCloseCheck) {
            $script:backupBeforeCloseEnabled = $backupBeforeCloseCheck.IsChecked
        }
        
        # Backup Before Close
        $backupBeforeCloseCheck = $window.FindName("BackupBeforeCloseCheck")
        if ($backupBeforeCloseCheck) {
            $script:backupBeforeCloseEnabled = $backupBeforeCloseCheck.IsChecked
        }
        
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
        Append-Log "[Config] Auto-Shutdown on idle: $script:autoShutdownEnabled ($script:autoShutdownMinutes min)"
        Append-Log "[Config] Shutdown PC after server: $script:shutdownPCAfterServer"
        Append-Log "[Config] Only shutdown outside hours: $script:onlyShutdownOutsideHours"
        Append-Log "[Config] Console Logging: $script:enableConsoleLogging"
        Append-Log "[Config] Operating Hours Enabled: $script:enableOperatingHours"
        Append-Log "[Config] Auto-Backup: $script:autoBackupEnabled ($script:backupIntervalMinutes min)"
        Append-Log "[Config] Auto-Clear: $script:autoClearEnabled"
        
        # Guardar configuración a archivo
        Save-Configuration
        
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

# Actualizar UI con el idioma cargado ANTES de cargar el servidor
Update-UILanguage

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

# Cargar ultimo servidor
# Función para guardar configuración
function Save-Configuration {
    try {
        # Leer valores actuales de los textboxes si existen
        $sHour = $script:scheduleManager.StartHour
        $sMin = $script:scheduleManager.StartMin
        $eHour = $script:scheduleManager.StopHour
        $eMin = $script:scheduleManager.StopMin
        
        try {
            $shBox = $window.FindName("StartHourBox").Text
            if ($shBox -and [int]::TryParse($shBox, [ref]$null)) { $sHour = [int]$shBox }
        } catch { }
        
        try {
            $smBox = $window.FindName("StartMinBox").Text
            if ($smBox -and [int]::TryParse($smBox, [ref]$null)) { $sMin = [int]$smBox }
        } catch { }
        
        try {
            $ehBox = $window.FindName("StopHourBox").Text
            if ($ehBox -and [int]::TryParse($ehBox, [ref]$null)) { $eHour = [int]$ehBox }
        } catch { }
        
        try {
            $emBox = $window.FindName("StopMinBox").Text
            if ($emBox -and [int]::TryParse($emBox, [ref]$null)) { $eMin = [int]$emBox }
        } catch { }
        
        $config = @{
            serverPath = $script:serverPath
            playitPath = $script:playitPath
            autoShutdownEnabled = $script:autoShutdownEnabled
            autoShutdownMinutes = $script:autoShutdownMinutes
            shutdownPCAfterServer = $script:shutdownPCAfterServer
            onlyShutdownOutsideHours = $script:onlyShutdownOutsideHours
            enableOperatingHours = $script:enableOperatingHours
            startHour = $sHour
            startMin = $sMin
            stopHour = $eHour
            stopMin = $eMin
            startOnBoot = $script:startOnBoot
            autoBackupEnabled = $script:autoBackupEnabled
            backupIntervalMinutes = $script:backupIntervalMinutes
            backupBeforeCloseEnabled = $script:backupBeforeCloseEnabled
            autoClearEnabled = $script:autoClearEnabled
            autoClearMinutes = $script:autoClearMinutes
            autoClearMaxLines = $script:autoClearMaxLines
            enableConsoleLogging = $script:enableConsoleLogging
        }
        
        $dir = Split-Path $script:settingsConfigPath -Parent
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        $config | ConvertTo-Json | Set-Content -Path $script:settingsConfigPath -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch { }
}

# Función para cargar configuración
function Load-Configuration {
    try {
        if (Test-Path $script:settingsConfigPath) {
            $config = Get-Content -Path $script:settingsConfigPath -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json
            
            if ($config.serverPath) { $script:serverPath = $config.serverPath }
            if ($config.playitPath) { $script:playitPath = $config.playitPath }
            if ($null -ne $config.backupBeforeCloseEnabled) { $script:backupBeforeCloseEnabled = $config.backupBeforeCloseEnabled }
            if ($config.autoShutdownEnabled -ne $null) { $script:autoShutdownEnabled = $config.autoShutdownEnabled }
            if ($config.autoShutdownMinutes) { $script:autoShutdownMinutes = $config.autoShutdownMinutes }
            if ($config.shutdownPCAfterServer -ne $null) { $script:shutdownPCAfterServer = $config.shutdownPCAfterServer }
            if ($config.onlyShutdownOutsideHours -ne $null) { $script:onlyShutdownOutsideHours = $config.onlyShutdownOutsideHours }
            if ($config.enableOperatingHours -ne $null) { $script:enableOperatingHours = $config.enableOperatingHours }
            if ($config.startHour -ne $null) { $script:startHourSaved = $config.startHour }
            if ($config.startMin -ne $null) { $script:startMinSaved = $config.startMin }
            if ($config.stopHour -ne $null) { $script:stopHourSaved = $config.stopHour }
            if ($config.stopMin -ne $null) { $script:stopMinSaved = $config.stopMin }
            if ($config.startHour -ne $null -and $script:scheduleManager) { $script:scheduleManager.StartHour = $config.startHour }
            if ($config.startMin -ne $null -and $script:scheduleManager) { $script:scheduleManager.StartMin = $config.startMin }
            if ($config.stopHour -ne $null -and $script:scheduleManager) { $script:scheduleManager.StopHour = $config.stopHour }
            if ($config.stopMin -ne $null -and $script:scheduleManager) { $script:scheduleManager.StopMin = $config.stopMin }
            if ($config.startOnBoot -ne $null) { $script:startOnBoot = $config.startOnBoot }
            if ($config.autoBackupEnabled -ne $null) { $script:autoBackupEnabled = $config.autoBackupEnabled }
            if ($config.backupIntervalMinutes) { $script:backupIntervalMinutes = $config.backupIntervalMinutes }
            if ($config.autoClearEnabled -ne $null) { $script:autoClearEnabled = $config.autoClearEnabled }
            if ($config.autoClearMinutes) { $script:autoClearMinutes = $config.autoClearMinutes }
            if ($config.autoClearMaxLines) { $script:autoClearMaxLines = $config.autoClearMaxLines }
            if ($config.enableConsoleLogging -ne $null) { $script:enableConsoleLogging = $config.enableConsoleLogging }
        }
    } catch { }
}

if (Test-Path $script:lastServerConfigPath) {
    try {
        $lastPath = Get-Content -Path $script:lastServerConfigPath -Raw -ErrorAction SilentlyContinue
        if ($lastPath -and (Test-Path $lastPath.Trim())) {
            Load-ServerPath $lastPath.Trim()
        }
    } catch { }
}

# Cargar configuración guardada
Load-Configuration

# Actualizar UI con configuración cargada
try {
    if ($script:autoShutdownEnabled) { $window.FindName("AutoShutdownCheck").IsChecked = $true }
    if ($script:shutdownPCAfterServer) { $window.FindName("ShutdownPCCheck").IsChecked = $true }
    if ($script:onlyShutdownOutsideHours) { $window.FindName("OnlyShutdownOutsideHoursCheck").IsChecked = $true }
    if ($script:enableOperatingHours) { $window.FindName("EnableOperatingHoursCheck").IsChecked = $true }
    if ($script:autoBackupEnabled) { $window.FindName("AutoBackupCheck").IsChecked = $true }
    if ($script:backupBeforeCloseEnabled) { $window.FindName("BackupBeforeCloseCheck").IsChecked = $true }
    if ($script:autoClearEnabled) { $window.FindName("AutoClearCheck").IsChecked = $true }
    if ($script:enableConsoleLogging) { $window.FindName("EnableConsoleLoggingCheck").IsChecked = $true }
    if ($script:startOnBoot) { $window.FindName("StartOnBootCheck").IsChecked = $true }
    
    # Cargar valores de texto
    $window.FindName("IdleMinutesBox").Text = $script:autoShutdownMinutes.ToString()
    $window.FindName("BackupIntervalBox").Text = $script:backupIntervalMinutes.ToString()
    $window.FindName("AutoClearMinutesBox").Text = $script:autoClearMinutes.ToString()
    $window.FindName("AutoClearLinesBox").Text = $script:autoClearMaxLines.ToString()
    
    # Cargar horarios
    $window.FindName("StartHourBox").Text = $script:startHourSaved.ToString().PadLeft(2, '0')
    $window.FindName("StartMinBox").Text = $script:startMinSaved.ToString().PadLeft(2, '0')
    $window.FindName("StopHourBox").Text = $script:stopHourSaved.ToString().PadLeft(2, '0')
    $window.FindName("StopMinBox").Text = $script:stopMinSaved.ToString().PadLeft(2, '0')
    
    # Cargar rutas de servidores
    if ($script:serverPath) { $window.FindName("ServerPath").Text = $script:serverPath }
    if ($script:playitPath) { $window.FindName("PlayitPath").Text = $script:playitPath }
} catch { }


# Mensaje inicial
Append-Log "[$(Get-Text 'system')] $(Get-Text 'launch_started')"
Append-Log "[$(Get-Text 'system')] $(Get-Text 'select_to_start')"

# Event handler para cuando se cierra la ventana
$window.Add_Closing({
    param($sender, $e)
    # Cierre ultra-rápido sin esperas
    try { Save-Configuration } catch { }
    try { if ($script:logTimer) { $script:logTimer.Stop(); $script:logTimer.Dispose() } } catch { }
    try { if ($script:stopTimer) { $script:stopTimer.Stop(); $script:stopTimer.Dispose() } } catch { }
    try { Remove-Item $script:playitLog -ErrorAction SilentlyContinue -Force } catch { }
    try { Remove-Item $script:playitErrLog -ErrorAction SilentlyContinue -Force } catch { }
    try { Remove-Item $script:serverLog -ErrorAction SilentlyContinue -Force } catch { }
    try { if ($script:serverProcess -and -not $script:serverProcess.HasExited) { $script:serverProcess.Kill($true) } } catch { }
    try { if ($script:playitProcess -and -not $script:playitProcess.HasExited) { Stop-Process -Id $script:playitProcess.Id -Force -ErrorAction Stop } } catch { }
    try { 
        if ($script:serverManager -and $script:serverManager.ServerPath) {
            $javaProcs = Get-ServerJavaProcesses $script:serverManager.ServerPath
            foreach ($proc in $javaProcs) {
                try { Stop-Process -Id $proc.Id -Force } catch { }
            }
        }
    } catch { }
    try { Get-Process -Name playit -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue } catch { }
    try { if ($script:cmdProcess -and -not $script:cmdProcess.HasExited) { Stop-Process -Id $script:cmdProcess.Id -Force -ErrorAction Stop } } catch { }
    try { $script:serverProcess.Dispose() } catch { }
    try { $script:playitProcess.Dispose() } catch { }
    [System.Environment]::Exit(0)
})

# Mostrar ventana
$window.Show() | Out-Null
[System.Windows.Threading.Dispatcher]::Run()
