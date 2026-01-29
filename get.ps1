# Install Software with winget
$apps = @(
    "7zip.7zip",
    "RARLab.WinRAR",
    "AIMP.AIMP",
    "VideoLAN.VLC",
    "BraveSoftware.Brave",
    "FastStone.ImageViewer",
    "SumatraPDF.SumatraPDF",
    "Notepad++.Notepad++",
    "FDM.FDM",
    "Microsoft.PowerToys",
    "WinHance.WinHance"  # Menambahkan WinHance ke dalam daftar
)

# Gunakan winget sebagai sumber default
$source = "winget"

# Function to download apps in parallel
$jobs = @()
foreach ($app in $apps) {
    $jobs += Start-Job -ScriptBlock {
        Write-Host "Downloading $app..."
        winget install --id $using:app --exact --source $using:source --silent
    }
}

# Tunggu hingga semua download selesai
$jobs | ForEach-Object { 
    Wait-Job -Job $_
    Receive-Job -Job $_
    Remove-Job -Job $_
}

Write-Host "All applications are downloaded. Starting installation..."

# Install Software secara sequential
foreach ($app in $apps) {
    # Cek apakah aplikasi sudah terinstal
    $installed = winget show --id $app --source $source -e

    if ($installed) {
        Write-Host "$app is already installed. Skipping installation."
    } else {
        Write-Host "Installing $app from source $source..."
        
        try {
            # Instalasi aplikasi dengan error handling
            winget install --id $app --exact --source $source --silent
        } catch {
            Write-Host "Error installing $app. Please check the installer and try again."
        }
    }
}


Write-Host "Process complete."

