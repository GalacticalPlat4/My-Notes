#region Functions
function Sync-SharepointLocation {
    param (
        [guid]$siteId,
        [guid]$webId,
        [guid]$listId,
        [mailaddress]$userEmail,
        [string]$webUrl,
        [string]$webTitle,
        [string]$listTitle,
        [string]$syncPath
    )
    try {
        Add-Type -AssemblyName System.Web
        #Encode site, web, list, url & email
        [string]$siteId = [System.Web.HttpUtility]::UrlEncode($siteId)
        [string]$webId = [System.Web.HttpUtility]::UrlEncode($webId)
        [string]$listId = [System.Web.HttpUtility]::UrlEncode($listId)
        [string]$userEmail = [System.Web.HttpUtility]::UrlEncode($userEmail)
        [string]$webUrl = [System.Web.HttpUtility]::UrlEncode($webUrl)
        #build the URI
        $uri = New-Object System.UriBuilder
        $uri.Scheme = "odopen"
        $uri.Host = "sync"
        $uri.Query = "siteId=$siteId&webId=$webId&listId=$listId&userEmail=$userEmail&webUrl=$webUrl&listTitle=$listTitle&webTitle=$webTitle"
        #launch the process from URI
        Write-Host $uri.ToString()
        start-process -filepath $($uri.ToString())
    }
    catch {
        $errorMsg = $_.Exception.Message
    }
    if ($errorMsg) {
        Write-Warning "Sync failed."
        Write-Warning $errorMsg
    }
    else {
        Write-Host "Sync completed."
        while (!(Get-ChildItem -Path $syncPath -ErrorAction SilentlyContinue)) {
            Start-Sleep -Seconds 2
        }
        return $true
    }    
}
#endregion
#Getting siteId: https://companyname.sharepoint.com/sites/sitename/_api/site/id
#Getting webId: https://companyname.sharepoint.com/sites/sitename/_api/web/id
#Getting listId: Go into Sharepoint site > Documents > Settings > Library settings > More library settings > On the URL you will see your listId. (Please skip the %XX from the beginning and %XX from the end - Your ID will be in the middle.)
#region Main Process
try {
    #region Sharepoint Sync
    [mailaddress]$userUpn = cmd /c "whoami/upn"
    $params = @{
        #replace with data captured from your sharepoint site.
        siteId    = "{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}"
        webId     = "{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}"
        listId    = "{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}"
        userEmail = $userUpn
        webUrl    = "https://XXXXX(companyname).sharepoint.com/sites/XXXXXXXXXXX(sitename)"
        webTitle  = "XXXXXXXXXX(sitename)"
        listTitle = "XXXXXXXXXXX(Sharepoint document name)"
    } 
    $params.syncPath  = "$(split-path $env:onedrive)\$($userUpn.Host)\$($params.webTitle) - $($Params.listTitle)"
    Write-Host "SharePoint params:"
    $params | Format-Table
    if (!(Test-Path $($params.syncPath))) {
        Write-Host "Sharepoint folder not found locally, will now sync.." -ForegroundColor Yellow
        $sp = Sync-SharepointLocation @params
        if (!($sp)) {
            Throw "Sharepoint sync failed."
        }
    }
    else {
        Write-Host "Location already syncronized: $($params.syncPath)" -ForegroundColor Yellow
    }
    #endregion
}
catch {
    $errorMsg = $_.Exception.Message
}
finally {
    if ($errorMsg) {
        Write-Warning $errorMsg
        Stop-Transcript
        Throw $errorMsg
    }
    else {
        Write-Host "Completed successfully..."
        Stop-Transcript
    }
}
#endregion