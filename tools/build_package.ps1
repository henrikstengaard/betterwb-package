# Build Package
# -------------
#
# Author: Henrik Nørfjand Stengaard
# Date:   2017-04-14
#
# A PowerShell script to build package for HstWB Installer.


Add-Type -Assembly System.IO.Compression.FileSystem


# paths
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
$rootDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("..")
$packageDir = Join-Path -Path $rootDir -ChildPath "package"
$screenshotsDir = Join-Path -Path $rootDir -ChildPath "screenshots"
$readmeMarkdownFile = Join-Path -Path $rootDir -ChildPath "README.md"

# get screenshot files
$screenshotFiles = @()

if (Test-Path $screenshotsDir)
{
	$screenshotFiles += Get-ChildItem -Path $screenshotsDir -Filter *.png
}


# copy screenshot files, if any exist
if ($screenshotFiles.Count -gt 0)
{
	Write-Host "Copying screenshots for package..." -ForegroundColor "Yellow"
	$packageScreenshotsDir = Join-Path -Path $packageDir -ChildPath "screenshots"

	if (!(Test-Path $packageScreenshotsDir))
	{
		mkdir $packageScreenshotsDir | Out-Null
	}

	$screenshotFiles | ForEach-Object { Copy-Item -Path $_.FullName -Destination $packageScreenshotsDir -Force }
	Write-Host "Done." -ForegroundColor "Yellow"
}


# Build html
Write-Host "Building readme html for package from readme markdown..." -ForegroundColor "Yellow"
& ".\build_html.ps1" -markdownFile $readmeMarkdownFile -htmlFile (Join-Path -Path $packageDir -ChildPath "README.html")
Write-Host "Done." -ForegroundColor "Yellow"


# Build guide
Write-Host "Building readme guide for package from readme markdown..." -ForegroundColor "Yellow"
& ".\build_guide.ps1" -markdownFile $readmeMarkdownFile -guideFile (Join-Path -Path $packageDir -ChildPath "README.guide")
Write-Host "Done." -ForegroundColor "Yellow"


# c# code for forward slash encoder used to create zip files with forward slash as path separator in entries compatible with amiga
$source = @"
using System.Text;

namespace HstWB.Package
{ 
	public class ForwardSlashEncoder : UTF8Encoding
	{
		public ForwardSlashEncoder() : base(true)
		{
		}

		public override byte[] GetBytes(string s)
		{
			s = s.Replace("\\", "/");
			return base.GetBytes(s);
		}
	}
}
"@
Add-Type -TypeDefinition $source -Language CSharp 


# create instance of forward slash encoder
$forwardSlashEncoder = New-Object 'HstWB.Package.ForwardSlashEncoder'


# read package ini lines
$packageIniFile = [System.IO.Path]::Combine($packageDir, 'package.ini')
$packageIniLines = Get-Content $packageIniFile


# get package name and version from package ini lines
$packageName = ($packageIniLines | Where-Object { $_ -match '^Name' } | Select-Object -First 1) -replace '^Name=', ''
$packageVersion = ($packageIniLines | Where-Object { $_ -match '^Version' } | Select-Object -First 1) -replace '^Version=', ''


# write progress message
Write-Host "Build package '$packageName' v$packageVersion" -ForegroundColor "Yellow"


# compress content directories to zip files
$contentDirs = Get-ChildItem -Path $rootDir | Where-Object { $_.PSIsContainer -and $_.Name -notmatch '(package|screenshots|tools|licenses)' }
foreach ($contentDir in $contentDirs)
{
	# write progress message
	Write-Host ("Compressing content '" + $contentDir.Name + "' zip file...")

	# content zip file
	$contentZipFile = [System.IO.Path]::Combine($packageDir, ($contentDir.Name + ".zip"))

	# delete content zip file, if it exists
	if (test-path -path $contentZipFile)
	{
		remove-item $contentZipFile -force
	}

	# compress content directory
	[System.IO.Compression.ZipFile]::CreateFromDirectory($contentDir.FullName, $contentZipFile, $compressionLevel, $false, $forwardSlashEncoder)	
}


# write progress message
Write-Host "Compressing package zip file..." -ForegroundColor "Yellow"

# package file
$packageFile = Join-Path -Path $rootDir -ChildPath ("{0}.{1}.zip" -f ($packageName -replace '\s', '.'), $packageVersion)

# delete package file, if it exists
if (test-path -path $packageFile)
{
	remove-item $packageFile -force
}

# compress package directory
[System.IO.Compression.ZipFile]::CreateFromDirectory($packageDir, $packageFile, $compressionLevel, $false, $forwardSlashEncoder)


# write progress message
Write-Host "Done." -ForegroundColor "Yellow"
