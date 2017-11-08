Set-Variable -Name GRADLE_DOC_URL -Value "https://dev-docs.web.pcf-phx.apps.boeing.com/recipe/dev-setup-gradle/"

$INSTALL_LIST = @{}
$INSTALL_FUNCTIONS = @{}
$INSTALL_ARGS = @{}
[System.Collections.ArrayList]$INSTALL_PACKAGES = @()

Set-Variable -Name DOWNLOAD_DIR -Value "~\Downloads\DevOpsPackages"
Set-Variable -Name GRADLE_PROPS -Value "~\.gradle\gradle.properties"

if (!(Test-Path $DOWNLOAD_DIR)) {mkdir $DOWNLOAD_DIR}
$SRES_HEADER = @{}
$STS_INSTALL_DIR="$($env:HOMEPATH)\STS"
$STS_EXE_SUBPATH="\sts-bundle\sts-3.8.3.RELEASE\STS.exe"
$CFCLI_INSTALL_EXE="cf_installer.exe"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Install"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Do not install"
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

# Main Function. This is called at the last line of the script. Declaration is here for ease of understanding/reading
function main {
    Write-Output "Checking for SRES credentials in gradle.properties..."
    
    setupSRESHeader
    setupPackages
    askUserForPackageSelection
    
    Write-Output "`nPress any key to continue..."; cmd /c pause | out-null
    
    installSelectedPackages

    Write-Output "Setup Complete!`nPlease report any bugs to Alexander Schwach"
}

function setupPackages {
    $INSTALL_LIST.Add("JDK","https://sres.web.boeing.com/artifactory/list/tools/jdkAndjre/Jdk/8u144/windows/jdk-8u144-windows-x64.exe")
    $INSTALL_FUNCTIONS.Add("JDK", $function:installJDK)
    $INSTALL_ARGS.Add("JDK", "/s")

    $INSTALL_LIST.Add("Git","https://git.web.boeing.com/gitlab/git-at-boeing/raw/master/Windows/setup.ps1")
    $INSTALL_FUNCTIONS.Add("Git", $function:installGit)
    $INSTALL_ARGS.Add("Git", "")

    $INSTALL_LIST.Add("Cloud Foundry CLI","https://sres.web.boeing.com/artifactory/list/tools/tools/CloudFoundryCi/6.29.1/windows/cf-cli-installer_6.29.1_winx64.zip")
    $INSTALL_FUNCTIONS.Add("Cloud Foundry CLI", $function:installCFCLI)
    $INSTALL_ARGS.Add("Cloud Foundry CLI", "/SILENT")

    $INSTALL_LIST.Add("Visual Studio Code","https://sres.web.boeing.com/artifactory/list/tools/tools/VSCode/1.8.1/windows/VSCodeSetup-1.8.1.exe")
    $INSTALL_FUNCTIONS.Add("Visual Studio Code", $function:installVSCODE)
    $INSTALL_ARGS.Add("Visual Studio Code", "/SILENT /NORESTARTAPPLICATIONS /CLOSEAPPLICATIONS")    

    $INSTALL_LIST.Add("Spring Tool Suite","https://sres.web.boeing.com/artifactory/list/tools/ides/SpringToolSuite/3.8.3/windows/spring-tool-suite-3.8.3.RELEASE-e4.6.2-win32-x86_64.zip")
    $INSTALL_FUNCTIONS.Add("Spring Tool Suite", $function:installSTS)
    $INSTALL_ARGS.Add("Spring Tool Suite", "")    
}

function askUserForPackageSelection {
    foreach ($PACKAGE in $INSTALL_LIST.Keys) {
        $result = $host.ui.PromptForChoice("", "Install $($PACKAGE)?", $options, 0) 
        if ($result -eq 0) {
            $INSTALL_PACKAGES.Add($PACKAGE) | out-null
            Write-Output "`n"
        }
    }
    Write-Output "Setup will install:"
    ForEach ($PACKAGE in $INSTALL_PACKAGES) {
        Write-Output "`t- $($PACKAGE)"
    }
}

function installSelectedPackages {
    $INSTALL_PACKAGES | ForEach-Object {
        $FUNCTION = $INSTALL_FUNCTIONS.Item($_)
        $PACKAGE = $_
        $URL = $INSTALL_LIST.Item($_) 
        & $FUNCTION $PACKAGE $URL # Call the package specific installation function
    }
}

function installJDK {
    $PACKAGE_NAME = $Args[0]
    $DOWNLOAD_URL = $Args[1]
    $PACKAGE_FILEPATH = getPackageDownloadFilepath $DOWNLOAD_URL
    
    downloadSRESPackage $PACKAGE_NAME $DOWNLOAD_URL $PACKAGE_FILEPATH
    
    Write-Output "Installing $PACKAGE_NAME silently..."
    Start-Process -Filepath $PACKAGE_FILEPATH -ArgumentList @("$($INSTALL_ARGS.Item($PACKAGE_NAME))") -Wait
    Write-Output "$PACKAGE_NAME Installed!"
}

function installGit {
    $PACKAGE_NAME = $Args[0]
    $DOWNLOAD_URL = $Args[1]

    Write-Output "Calling $PACKAGE_NAME install script at $DOWNLOAD_URL..."
    powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('$($DOWNLOAD_URL)'))"
    Write-Output "Complete!"
}

function installSTS {
    $PACKAGE_NAME = $Args[0]
    $DOWNLOAD_URL = $Args[1]
    $PACKAGE_FILEPATH = getPackageDownloadFilepath $DOWNLOAD_URL

    if (Test-Path $STS_INSTALL_DIR) {
        $result = $host.ui.PromptForChoice("", "STS already exists at $STS_INSTALL_DIR! Overwrite?", $options, 0) 
        if ($result -eq 0) {
            downloadSRESPackage $PACKAGE_NAME $DOWNLOAD_URL $PACKAGE_FILEPATH
            extractSRESArchive $PACKAGE_NAME $PACKAGE_FILEPATH $STS_INSTALL_DIR
            createShortcut "$($env:HOMEPATH)\Desktop\Spring Tool Suite.lnk" "$($STS_INSTALL_DIR)\$($STS_EXE_SUBPATH)"
            Write-Output "$PACKAGE_NAME installed at $STS_INSTALL_DIR!"
        } else {
            Write-Output "Skipping $PACKAGE_NAME..."
        }
    }
}

function installCFCLI {
    $PACKAGE_NAME = $Args[0]
    $DOWNLOAD_URL = $Args[1]
    $PACKAGE_FILEPATH = getPackageDownloadFilepath $DOWNLOAD_URL
    $EXTRACT_DIR = "$($DOWNLOAD_DIR)\$($PACKAGE_NAME)"
    $PACKAGE_INSTALL_ARGS = $INSTALL_ARGS.Item($PACKAGE_NAME)

    downloadSRESPackage $PACKAGE_NAME $DOWNLOAD_URL $PACKAGE_FILEPATH
    extractSRESArchive $PACKAGE_NAME $PACKAGE_FILEPATH $EXTRACT_DIR

    Write-Output "Installing $PACKAGE_NAME..."
    Start-Process -Filepath "$($EXTRACT_DIR)\$($CFCLI_INSTALL_EXE)" -ArgumentList @("$($PACKAGE_INSTALL_ARGS)") -Wait
    Write-Output "$PACKAGE_NAME installed!"
}

function installVSCODE {
    $PACKAGE_NAME = $Args[0]
    $DOWNLOAD_URL = $Args[1]
    $PACKAGE_FILEPATH = getPackageDownloadFilepath $DOWNLOAD_URL
    
    downloadSRESPackage $PACKAGE_NAME $DOWNLOAD_URL $PACKAGE_FILEPATH
    
    Write-Output "Installing $PACKAGE_NAME silently..."
    Start-Process -Filepath $PACKAGE_FILEPATH -ArgumentList @("$($INSTALL_ARGS.Item($PACKAGE_NAME))") -Wait
    Write-Output "$PACKAGE_NAME Installed!"
}

function setupSRESHeader {
    $SRES_PASS = ""
    if (!(Test-Path $GRADLE_PROPS)) {
        Write-Output "gradle.properties does not exist at '$GRADLE_PROPS'! Configure gradle.properties and retry!"
        Write-Output $GRADLE_DOC_URL
        exit 1
    }
    Get-Content $GRADLE_PROPS | Foreach-Object {
        $var = $_.Split('=')
        if ($var[0] -eq "mavenPassword") {
            $SRES_PASS = $var[1]
        }
    }
    if ($SRES_PASS.length -eq 0) {
        Write-Output "SRES Key was empty! Please make sure gradle.properties is configured correctly and retry!"
        Write-Output $GRADLE_DOC_URL
        exit 1
    } # TODO: Maybe add something that will prompt for the SRES Key manually?
    $SRES_HEADER.Add("X-JFrog-Art-Api", $SRES_PASS)
}

function getPackageDownloadFilepath {
    $DOWNLOAD_URL = $Args[0]
    $URL_BASENAME = getSRESPackageBasename $DOWNLOAD_URL
    $FILEPATH = "$($DOWNLOAD_DIR)\$($URL_BASENAME)"
    return $FILEPATH
}

function getSRESPackageBasename {
    return $Args[0].Substring($Args[0].LastIndexOf("/") + 1)
}

function downloadSRESPackage {
    Write-Output "Downloading $($Args[0])..."
    Invoke-WebRequest $($Args[1]) -Headers $SRES_HEADER -OutFile $Args[2]
    Write-Output "$($Args[0]) downloaded!"
}

function extractSRESArchive {
    Write-Output "Extracting $($Args[0]) to $($Args[2])"
    Expand-Archive -Force -path $Args[1] -destinationpath $Args[2]
    Write-Output "$($Args[0]) installed at:`n`t$($Args[2])"
}

function createShortcut {
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($Args[0])
    $Shortcut.TargetPath = $Args[1]
    $Shortcut.Save()
}

main
