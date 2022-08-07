# Disable SSL validation
# https://til.intrepidintegration.com/powershell/ssl-cert-bypass
Add-Type @'
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
'@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy



if (Test-Path -Path C:\app\ALREADY_REGISTERED) {
    Write-Host "User $env:CPM_USERNAME already exists. Syncing credential file."

    $AuthenticationToken = Invoke-RestMethod -Uri "$env:PVWA_URL/PasswordVault/API/auth/Cyberark/Logon" -Method Post -Body @{Username = $env:VAULT_USER; Password = $env:VAULT_PASS; concurrentSession = $true }
    if ($null -ne $AuthenticationToken) {
        $AuthenticatedWebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $AuthenticatedWebSession.Headers.Add('Authorization', $AuthenticationToken);
    }

    Get-Service -Name 'CyberArk Password Manager' | Stop-Service

    $TemporaryPassword = 'PASSthatWiLLChange!1'

    Write-Host "Setting password for $env:CPM_USERNAME in the Vault."
    $Users = (Invoke-RestMethod -Uri "$env:PVWA_URL/PasswordVault/API/Users" -WebSession $AuthenticatedWebSession).Users
    $CPMUser = $Users | Where-Object { $_.Username -eq $env:CPM_USERNAME }

    $Body = @{
        id          = $CPMUser.Id;
        newPassword = $TemporaryPassword
    } | ConvertTo-Json
    Invoke-WebRequest -Uri "$env:PVWA_URL/PasswordVault/API/Users/$($CPMUser.id)/ResetPassword" -Method POST -Body $Body -WebSession $AuthenticatedWebSession -ContentType 'application/json' -UseBasicParsing | Out-Null

    Write-Host "Creating credential file for $env:CPM_USERNAME."
    $CreateCredFileArguments = @(
        'user.ini',
        'Password',
        '/EntropyFile',
        '/DPAPIMachineProtection',
        "/Username $env:CPM_USERNAME",
        "/Password $TemporaryPassword"
    )
    Start-Process -FilePath 'C:\Program Files (x86)\CyberArk\Password Manager\Vault\CreateCredFile.exe' -ArgumentList $CreateCredFileArguments -WorkingDirectory 'C:\Program Files (x86)\CyberArk\Password Manager\Vault'
    Get-Service -Name 'CyberArk Password Manager' | Start-Service

} else {
    Write-Host 'Container has not had the registration process ran. Running now.'

    .'C:\tmp\Update-XmlConfig.ps1' -File C:\tmp\InstallationAutomation\Registration\CPMRegisterComponentConfig.xml -ParameterNameValueHashTable @{acceptEula = $Env:ACCEPT_EULA; vaultip = $env:VAULT_IP; vaultUser = $env:VAULT_USER; username = $env:CPM_USERNAME }
    Set-Location C:\tmp\InstallationAutomation\Registration
    .'C:\tmp\InstallationAutomation\Registration\CPMRegisterCommponent.ps1' -pwd $env:VAULT_PASS

    Out-File -FilePath C:\app\ALREADY_REGISTERED
}

Get-Content 'C:\Program Files (x86)\CyberArk\Password Manager\Logs\pm.log' -Wait -Tail 20