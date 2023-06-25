$path = $args[0]

$setwallpapersrc = @"
using System.Runtime.InteropServices;

public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc

if (Test-Connection -ComputerName google.com -Quiet) {
  Remove-Item -Path "$env:TEMP\Bing\Daily.jpg"
  $Market = "en-US"
  $Resolution = "1920x1080"
  $ImageFileName = "Daily.jpg"
  $DownloadDirectory = "$env:TEMP\Bing"
  $BingImageFullPath = "$($DownloadDirectory)\$($ImageFileName)"

  if ((Test-Path $DownloadDirectory) -ne $True) {
    New-Item -ItemType directory -Path $DownloadDirectory     
  }

  if((test-Path $BingImageFullPath) -eq $False){

    [xml]$Bingxml = (New-Object System.Net.WebClient).DownloadString("http://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=$($Market)");
    $ImageUrl = "http://www.bing.com$($Bingxml.images.image.urlBase)_$($Resolution).jpg";

    Invoke-WebRequest -UseBasicParsing -Uri $ImageUrl -OutFile "$BingImageFullPath";
    [Wallpaper]::SetWallpaper($BingImageFullPath)
    }
  }
 else {
    [Wallpaper]::SetWallpaper($BingImageFullPath)
}