[xml]$XAML = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="randomSelector" Width="1280" Height="720" ResizeMode="NoResize">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="3.5*"/>
            <RowDefinition Height="3.5*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
            <RowDefinition Height="1*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Image Name="imgBackground" Grid.RowSpan="10" Grid.Row="0" Grid.Column="0" Grid.ColumnSpan="10" Stretch="UniformToFill"/>
        <Image Name="imgFrame" Grid.RowSpan="2" Grid.Row="1" Grid.Column="0" Grid.ColumnSpan="2"/>
        <Image Name="imgContent" Grid.RowSpan="2" Grid.Row="1" Grid.Column="0" Grid.ColumnSpan="2" Margin="30"/>
        <Label Name="lbTitle" Grid.RowSpan="1" Grid.Row="1" Grid.Column="2" Grid.ColumnSpan="2" Foreground="White" FontSize="25"/>
        <Label Name="lbContent" Grid.RowSpan="1" Grid.Row="2" Grid.Column="2" Grid.ColumnSpan="2" Foreground="White" FontSize="25"/>
        <Button Name="btnBack" Grid.Column="1" HorizontalAlignment="Center" Grid.Row="4" VerticalAlignment="Center">
            <Image Name="imgBtnBack" Height="50"/>
        </Button>
        <Button Name="btnRNG" Grid.Column="2" HorizontalAlignment="Center" Grid.Row="4" VerticalAlignment="Center">
            <Image Name="imgBtnRNG"/>
        </Button>
    </Grid>
</Window>
"@

[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 	| out-null
try{$Form=[Windows.Markup.XamlReader]::Load( (New-Object System.Xml.XmlNodeReader $XAML) )}
catch{}

$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

$Global:AppBasePath = (Get-Item $PSCommandPath).DirectoryName
$imgBackground.Source = $AppBasePath + "\res\background.png"
$imgFrame.Source = $AppBasePath + "\res\frame.png"
$imgBtnBack.Source = $AppBasePath + "\res\back.png"
$imgBtnRNG.Source = $AppBasePath + "\res\random2.png"
$btnBack.Background = $null
$btnBack.BorderBrush = $null
$btnRNG.Background = $null
$btnRNG.BorderBrush = $null
$btnRNG.Add_Click({
    $max = $Global:data.Length
    $entry = $Global:data[$(Get-Random -Maximum $max)]
    $tmp = $entry -split "&&"
    $lbTitle.Content = $tmp[0];
    $lbContent.Content = $tmp[1];
    $imgContent.Source = $Global:AppBasePath + "\covers\" + $tmp[0].Trim() + ".jpg"
})

$path = $AppBasePath + "\list.txt"
$Global:data = [System.IO.File]::ReadAllLines($path)

$Form.ShowDialog()