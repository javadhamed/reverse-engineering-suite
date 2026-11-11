# Reverse Engineering Suite Installer for Windows (PowerShell)
# Installs: reverse-api-engineer, replica-skill, craft-anything, rea-agents, Ghidra, and OpenJDK 21
# Integrates automatically with Antigravity, Claude Code, Codex, and Cursor MCP configs.

[CmdletBinding()]
param(
    [switch]$SkipGhidra,
    [switch]$SkipJava,
    [string]$FluxDownToken = ""
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "`n=== [STEP] $Message ===" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host " [OK] $Message" -ForegroundColor Green
}

function Write-WarnMsg {
    param([string]$Message)
    Write-Host " [WARN] $Message" -ForegroundColor Yellow
}

$localBin = Join-Path $env:USERPROFILE ".local\bin"
if (!(Test-Path $localBin)) {
    New-Item -ItemType Directory -Path $localBin -Force | Out-Null
}

# Update User PATH if needed
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$localBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$localBin;$userPath", "User")
    $env:PATH = "$localBin;$env:PATH"
    Write-Success "Added $localBin to User PATH"
}

# -------------------------------------------------------------
# 1. Install reverse-api-engineer
# -------------------------------------------------------------
Write-Step "Installing reverse-api-engineer"
try {
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        Write-Host "Installing with uv tool..."
        uv tool install "reverse-api-engineer[manual]" --force
    } elseif (Get-Command pip -ErrorAction SilentlyContinue) {
        Write-Host "Installing with pip..."
        pip install "reverse-api-engineer[manual]"
    } else {
        Write-WarnMsg "Neither uv nor pip was found. Please install Python 3.11+ and uv."
    }
    Write-Success "reverse-api-engineer installed successfully."
} catch {
    Write-WarnMsg "Failed to install reverse-api-engineer: $_"
}

# -------------------------------------------------------------
# 2. Install replica-skill
# -------------------------------------------------------------
Write-Step "Installing replica-skill to agent skills"
try {
    $skillsTargets = @(
        "$env:USERPROFILE\.gemini\config\skills",
        "$env:USERPROFILE\.claude\skills",
        "$env:USERPROFILE\.agents\skills"
    )

    $tempClone = Join-Path $env:TEMP "replica-skill-install-$([Guid]::NewGuid().ToString('N'))"
    git clone --depth 1 https://github.com/Jakeschincariol/replica-skill.git $tempClone

    foreach ($targetDir in $skillsTargets) {
        $parent = Split-Path $targetDir -Parent
        if (Test-Path $parent) {
            if (!(Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
            Copy-Item -Path "$tempClone\replica-*" -Destination $targetDir -Recurse -Force
            Write-Success "Copied replica-* skills to $targetDir"
        }
    }
    Remove-Item -Path $tempClone -Recurse -Force -ErrorAction SilentlyContinue
} catch {
    Write-WarnMsg "Failed to clone replica-skill: $_"
}

# -------------------------------------------------------------
# 3. Install Craft Anything
# -------------------------------------------------------------
Write-Step "Installing Craft Anything"
try {
    $craftDir = Join-Path $env:LOCALAPPDATA "Programs\craft-anything"
    if (!(Test-Path $craftDir)) { New-Item -ItemType Directory -Path $craftDir -Force | Out-Null }

    $craftZip = Join-Path $env:TEMP "craft-anything-windows-x64.zip"
    $craftReleaseUrl = "https://github.com/storytold/craft-anything/releases/download/v0.6.0/craft-anything-0.6.0-windows-x64-portable.zip"

    Write-Host "Downloading Craft Anything v0.6.0..."
    Invoke-WebRequest -Uri $craftReleaseUrl -OutFile $craftZip -UseBasicParsing

    Write-Host "Extracting Craft Anything..."
    Expand-Archive -Path $craftZip -DestinationPath $craftDir -Force
    Remove-Item -Path $craftZip -Force -ErrorAction SilentlyContinue

    $craftExtracted = Get-ChildItem -Path $craftDir -Directory | Where-Object { $_.Name -like "craft-anything*" } | Select-Object -First 1
    if ($craftExtracted) {
        Copy-Item -Path "$($craftExtracted.FullName)\craft-anything*.exe" -Destination $localBin -Force
        Write-Success "Craft Anything binaries copied to $localBin"
    }

    # Run setup for Antigravity & clients
    if (Test-Path "$localBin\craft-anything-cli.exe") {
        & "$localBin\craft-anything-cli.exe" setup --client antigravity --yes -ErrorAction SilentlyContinue | Out-Null
        Write-Success "Craft Anything MCP server registered."
    }
} catch {
    Write-WarnMsg "Failed to install Craft Anything: $_"
}

# -------------------------------------------------------------
# 4. Install REA (Reverse Engineer Anything)
# -------------------------------------------------------------
Write-Step "Installing REA (Reverse Engineer Anything) MCP Server & Skills"
try {
    if (Get-Command npx -ErrorAction SilentlyContinue) {
        npx --yes rea-agents setup --client antigravity --yes
        Write-Success "REA registered in Antigravity."
    } else {
        Write-WarnMsg "npx is not installed. Node.js is required for REA."
    }
} catch {
    Write-WarnMsg "Failed to run REA setup: $_"
}

# -------------------------------------------------------------
# 5. Install OpenJDK 21 & Ghidra (Optional / Recommended)
# -------------------------------------------------------------
if (-not $SkipJava) {
    Write-Step "Setting up OpenJDK 21"
    try {
        $javaDir = Join-Path $env:LOCALAPPDATA "Programs\java-21"
        if (!(Test-Path $javaDir)) { New-Item -ItemType Directory -Path $javaDir -Force | Out-Null }

        $existingJdk = Get-ChildItem -Path $javaDir -Directory -Filter "jdk-21*" | Select-Object -First 1
        if (-not $existingJdk) {
            $jdkZip = Join-Path $env:TEMP "openjdk-21.zip"
            $jdkUrl = "https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.13%2B9/OpenJDK21U-jdk_x64_windows_hotspot_21.0.13_9.zip"
            Write-Host "Downloading Eclipse Temurin OpenJDK 21..."
            Invoke-WebRequest -Uri $jdkUrl -OutFile $jdkZip -UseBasicParsing
            Expand-Archive -Path $jdkZip -DestinationPath $javaDir -Force
            Remove-Item -Path $jdkZip -Force -ErrorAction SilentlyContinue
            $existingJdk = Get-ChildItem -Path $javaDir -Directory -Filter "jdk-21*" | Select-Object -First 1
        }

        if ($existingJdk) {
            $javaHome = $existingJdk.FullName
            [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, "User")
            $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
            if ($userPath -notlike "*$javaHome\bin*") {
                [Environment]::SetEnvironmentVariable("Path", "$javaHome\bin;$userPath", "User")
            }
            Write-Success "JAVA_HOME configured at $javaHome"
        }
    } catch {
        Write-WarnMsg "Failed to setup Java 21: $_"
    }
}

if (-not $SkipGhidra) {
    Write-Step "Setting up Ghidra 12.2"
    try {
        $ghidraParent = Join-Path $env:LOCALAPPDATA "Programs\ghidra"
        if (!(Test-Path $ghidraParent)) { New-Item -ItemType Directory -Path $ghidraParent -Force | Out-Null }

        $existingGhidra = Get-ChildItem -Path $ghidraParent -Directory -Filter "ghidra_*" | Select-Object -First 1
        if (-not $existingGhidra) {
            $ghidraZip = Join-Path $env:TEMP "ghidra.zip"
            $ghidraUrl = "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.2_build/ghidra_12.2_PUBLIC_20261016.zip"
            Write-Host "Downloading Ghidra 12.2 (NSA)..."
            Invoke-WebRequest -Uri $ghidraUrl -OutFile $ghidraZip -UseBasicParsing
            Expand-Archive -Path $ghidraZip -DestinationPath $ghidraParent -Force
            Remove-Item -Path $ghidraZip -Force -ErrorAction SilentlyContinue
            $existingGhidra = Get-ChildItem -Path $ghidraParent -Directory -Filter "ghidra_*" | Select-Object -First 1
        }

        if ($existingGhidra) {
            $ghidraPath = $existingGhidra.FullName
            [Environment]::SetEnvironmentVariable("GHIDRA_INSTALL_DIR", $ghidraPath, "User")
            Write-Success "GHIDRA_INSTALL_DIR configured at $ghidraPath"

            # Create Desktop Shortcut
            $wsh = New-Object -ComObject WScript.Shell
            $desktop = [System.Environment]::GetFolderPath('Desktop')
            $s = $wsh.CreateShortcut((Join-Path $desktop "Ghidra.lnk"))
            $s.TargetPath = "$ghidraPath\ghidraRun.bat"
            $s.WorkingDirectory = $ghidraPath
            $s.Description = "Ghidra Reverse Engineering"
            $s.Save()
            Write-Success "Created Ghidra desktop shortcut."
        }
    } catch {
        Write-WarnMsg "Failed to setup Ghidra: $_"
    }
}

# -------------------------------------------------------------
# 6. Configure MCP Config Json
# -------------------------------------------------------------
Write-Step "Updating Antigravity MCP Configuration"
try {
    $mcpJsonPath = "$env:USERPROFILE\.gemini\config\mcp_config.json"
    $configObj = @{ mcpServers = @{} }
    if (Test-Path $mcpJsonPath) {
        $raw = Get-Content $mcpJsonPath -Raw -ErrorAction SilentlyContinue
        if ($raw) {
            $parsed = $raw | ConvertFrom-Json
            if ($parsed.mcpServers) {
                foreach ($prop in $parsed.mcpServers.PSObject.Properties) {
                    $configObj.mcpServers[$prop.Name] = $prop.Value
                }
            }
        }
    }

    # Add craft-anything
    $configObj.mcpServers["craft-anything"] = @{
        command = "$localBin\craft-anything-cli.exe"
        args = @("mcp")
    }

    # Add rea
    $reaEnv = @{}
    $currentJava = [Environment]::GetEnvironmentVariable("JAVA_HOME", "User")
    $currentGhidra = [Environment]::GetEnvironmentVariable("GHIDRA_INSTALL_DIR", "User")
    if ($currentJava) { $reaEnv["JAVA_HOME"] = $currentJava; $reaEnv["PATH"] = "$currentJava\bin;%PATH%" }
    if ($currentGhidra) { $reaEnv["GHIDRA_INSTALL_DIR"] = $currentGhidra }

    $configObj.mcpServers["rea"] = @{
        command = "cmd.exe"
        args = @("/d", "/c", "npx", "-y", "rea-agents@6.7.0", "mcp")
        env = $reaEnv
    }

    # Add fluxdown if token passed or running
    if ($FluxDownToken) {
        $configObj.mcpServers["fluxdown"] = @{
            url = "http://127.0.0.1:17800/mcp"
            headers = @{ Authorization = "Bearer $FluxDownToken" }
        }
    }

    $configObj | ConvertTo-Json -Depth 6 | Set-Content -Path $mcpJsonPath -Encoding utf8
    Write-Success "Updated $mcpJsonPath successfully."
} catch {
    Write-WarnMsg "Failed to update MCP config: $_"
}

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "  Reverse Engineering Suite installation is complete!    " -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
