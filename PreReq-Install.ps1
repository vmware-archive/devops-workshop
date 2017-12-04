[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$GRADLE_SETUP_DOC="https://dev-docs.web.pcf-phx.apps.boeing.com/recipe/dev-setup-gradle/"
$PACKAGE_LIST = @{
    "Java Development Kit" = "http://fork-me.pages.boeing.com/devops-setup/InstallJDK"
    "Git" = "http://gitlab.pages.boeing.com/git-at-boeing/w.ps1"
    "Spring Tool Suite" = "http://fork-me.pages.boeing.com/devops-setup/InstallSTS"
    "Cloud Foundry CLI" = "http://fork-me.pages.boeing.com/devops-setup/InstallCFCLI"
    "Postman" = "http://fork-me.pages.boeing.com/devops-setup/Postman/InstallPostman"
}

function main {
    Write-Warning "This script assumes you have set up gradle and ~\.gradle\gradle.properties. Refer to this documentation: `n${GRADLE_SETUP_DOC}`n"
    Write-Output "Welcome to the DevOps-Java Workshop!"
    Write-Output "This script will install all required prerequisite software for the workshop."
    Write-Output "The following packages will be installed:"
    foreach ($PACKAGE_NAME in $PACKAGE_LIST.Keys) {Write-Output "`t- ${PACKAGE_NAME}"}
    Read-Host -Prompt "Press any key to continue or CTRL+C to abort"

     foreach ($PACKAGE in $PACKAGE_LIST.Keys) {
         $SCRIPT = $PACKAGE_LIST.Item($PACKAGE)
		 Invoke-Command -ScriptBlock ([scriptblock]::Create((new-object net.webclient).DownloadString('${SCRIPT}')))
     }
}

main
