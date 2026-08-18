param (
    [string]$Path = "C:\Users\savery\Desktop",
    [switch]$RemoveVideos
)

# Strip any trailing backslashes that corrupt PowerShell string parsing
$Path = $Path.TrimEnd('\')

# Ensure helper function exists inside the script session
function compress-pptx { node C:\Users\savery\github\powerpoint-compressor\src\index.js $args }

# Get all pptx files
$files = Get-ChildItem -Path "$Path" -Filter "*.pptx" -Recurse -ErrorAction SilentlyContinue | 
  Where-Object { 
    $_.Name -notmatch "\.tmp\.pptx$" -and 
    $_.DirectoryName -notmatch "(AppData|Temp|node_modules|\.git)"
  }

if (-not $files) {
    Write-Host "No matching .pptx files found in: $Path" -ForegroundColor Yellow
    return
}

foreach ($file in $files) {
    $originalPath = $file.FullName
    $tempPath = "$originalPath.tmp.pptx"
    $origSizeMB = [math]::Round($file.Length / 1MB, 2)

    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "Processing ($origSizeMB MB): $($file.Name)" -ForegroundColor Yellow
    Write-Host "Path: $originalPath" -ForegroundColor Gray
    Write-Host "========================================" -ForegroundColor Cyan
    
    if ($RemoveVideos) {
        compress-pptx --remove-videos "$originalPath" "$tempPath"
    } else {
        compress-pptx "$originalPath" "$tempPath"
    }
    
    if (Test-Path "$tempPath") {
      $tempFile = Get-Item "$tempPath"
      if ($tempFile.Length -lt $file.Length) {
        $newSizeMB = [math]::Round($tempFile.Length / 1MB, 2)
        $savedMB = [math]::Round($origSizeMB - $newSizeMB, 2)
        Remove-Item "$originalPath" -Force
        Rename-Item -Path "$tempPath" -NewName $file.Name
        Write-Host "Success: Overwrote original. Saved $savedMB MB ($origSizeMB MB -> $newSizeMB MB)" -ForegroundColor Green
      } else {
        Remove-Item "$tempPath" -Force
        Write-Host "Skipped: Compressed output was not smaller than original." -ForegroundColor DarkYellow
      }
    } else {
      Write-Host "Error: Compression failed for $($file.Name)" -ForegroundColor Red
    }
}
