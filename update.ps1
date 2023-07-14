Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$toolsPath = Join-Path -Path $currentPath -ChildPath 'tools'

$owner = 'Wintellect'
$repository = 'Paraffin'

function global:au_BeforeUpdate($Package) {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    Copy-Item -Path "$toolsPath\VERIFICATION.txt.template" -Destination "$toolsPath\VERIFICATION.txt" -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_AfterUpdate($Package) {
    $licenseUri = "https://raw.githubusercontent.com/$($owner)/$($repository)/$($Latest.Version)/CPL.TXT"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    Set-Content -Path 'tools\LICENSE.txt' -Value "From: $licenseUri`r`n`r`n$licenseContents" -NoNewline
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "(<packageSourceUrl>)[^<]*(</packageSourceUrl>)" = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            "(<licenseUrl>)[^<]*(</licenseUrl>)"             = "`$1https://github.com/$($owner)/$($repository)/blob/$($Latest.SoftwareVersion)/CPL.TXT`$2"
            "(<projectSourceUrl>)[^<]*(</projectSourceUrl>)" = "`$1https://github.com/$($owner)/$($repository)/tree/$($Latest.SoftwareVersion)`$2"
            "(<releaseNotes>)[^<]*(</releaseNotes>)"         = "`$1https://github.com/$($owner)/$($repository)/blob/$($Latest.SoftwareVersion)/ChangeLog.md`$2"
            "(<copyright>)[^<]*(</copyright>)"               = "`$1(c) 2007-$((Get-Date).Year), John Robbins - john@wintellect.com`$2"
        }
        'tools\VERIFICATION.txt'        = @{
            '%checksumValue%'   = "$($Latest.Checksum32)"
            '%checksumType%'    = "$($Latest.ChecksumType32.ToUpper())"
            '%tagReleaseUrl%'   = "https://github.com/$($owner)/$($repository)/releases/tag/$($Latest.SoftwareVersion)"
            '%archiveUrl%'      = "$($Latest.Url32)"
            '%archiveFileName%' = "$($Latest.FileName32)"
        }
        'tools\chocolateyinstall.ps1'   = @{
            "(^[$]archiveFileName\s*=\s*)('.*')" = "`$1'$($Latest.FileName32)'"
        }
    }
}

function global:au_GetLatest {
    $version = Get-LatestStableVersion

    return @{
        SoftwareVersion = $version
        Url32           = Get-SoftwareUri
        Version         = $version #This may change if building a package fix version
    }
}

Update-Package -ChecksumFor None -NoReadme
