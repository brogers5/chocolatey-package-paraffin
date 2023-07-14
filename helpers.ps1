Import-Module PowerShellForGitHub

$installerFileNameRegex = 'Paraffin.zip$'
$owner = 'Wintellect'
$repository = 'Paraffin'

function Get-LatestStableVersion {
    $latestRelease = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]

    return [version] $latestRelease.tag_name
}

function Get-SoftwareUri([version] $Version) {
    if ($null -eq $Version) {
        # Default to latest stable version
        $release = (Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Latest)[0]
    }
    else {
        $release = Get-GitHubRelease -OwnerName $owner -RepositoryName $repository -Tag "$($Version.ToString())"
    }
    $releaseAssets = Get-GitHubReleaseAsset -OwnerName $owner -RepositoryName $repository -Release $release.ID

    $windowsPortableArchiveAsset = $null
    foreach ($asset in $releaseAssets) {
        if ($asset.name -match $installerFileNameRegex) {
            $windowsPortableArchiveAsset = $asset
            break;
        }
        else {
            continue;
        }
    }

    if ($null -eq $windowsPortableArchiveAsset) {
        throw "Cannot find published Windows portable archive asset!"
    }

    return $windowsPortableArchiveAsset.browser_download_url
}
