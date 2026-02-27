Import-Csv -Path "C:\UsersShares\utilisateurs.csv" | ForEach-Object {
    $sam = $_.sam
    $nom = $_.nom
    $groupe = $_.groupe

    $user = Get-ADUser -Filter { SamAccountName -eq $sam } -ErrorAction SilentlyContinue
    if (-not $user) {
        try {
            New-ADUser -Name $nom `
                       -SamAccountName $sam `
                       -UserPrincipalName "$sam@barzini.local" `
                       -Title $nom `
                       -Path "OU=Test,OU=Utilisateurs,DC=Barzini,DC=local" `
                       -AccountPassword (ConvertTo-SecureString "P@ssw0rd2025" -AsPlainText -Force) `
                       -Enabled $true `
                       -ChangePasswordAtLogon $true
            Write-Host "✅ Utilisateur $sam créé."
        } catch {
            Write-Warning "⚠️ Erreur création $sam : $_"
        }
    }

    try {
        Add-ADGroupMember -Identity $groupe -Members $sam
        Write-Host "👥 Ajouté au groupe $groupe"
    } catch {
        Write-Warning "⚠️ Erreur ajout au groupe $groupe : $_"
    }

    $folder = "C:\UsersShares\$sam"
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder
        Write-Host "📁 Dossier créé : $folder"
    }

    $acl = Get-Acl $folder
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("$sam", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)
    Set-Acl $folder $acl
    Write-Host "🔐 Droits NTFS appliqués à $sam"

    try {
        if (-not (Get-SmbShare -Name $sam -ErrorAction SilentlyContinue)) {
            New-SmbShare -Name $sam -Path $folder -FullAccess $sam
            Write-Host "✅ Partage SMB créé pour $sam"
        }
    } catch {
        Write-Warning "⚠️ Erreur partage SMB pour $sam : $_"
    }

    Write-Host "--------------------------------------"
}
