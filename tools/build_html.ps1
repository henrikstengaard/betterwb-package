# Build Html
# ----------
#
# Author: Henrik Nørfjand Stengaard
# Date:   2017-04-03
#
# A PowerShell script to build html from markdown and embeds github styling.
#
# Following software is required for running this script.
#
# PanDoc:
# https://github.com/jgm/pandoc/releases
# https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-windows.msi
# 
# Note: Pandoc is installed in local appdata and might be caught to AntiVirus as malware

Param(
	[Parameter(Mandatory=$true)]
	[string]$markdownFile,
	[Parameter(Mandatory=$true)]
	[string]$htmlFile
)


# paths
$pandocFile = Join-Path $env:LOCALAPPDATA -ChildPath 'Pandoc\pandoc.exe'

# fail, if pandoc file doesn't exist
if (!(Test-Path -path $pandocFile))
{
	Write-Error "Error: Pandoc file '$pandocFile' doesn't exist!"
	exit 1
}


# pandoc
$pandocArgs = "-f markdown_github -c ""github-pandoc.css"" -t html5 ""$markdownFile"" -o ""$htmlFile"""
$pandocProcess = Start-Process -FilePath $pandocFile -ArgumentList $pandocArgs -Wait -NoNewWindow -PassThru

# exit, if pandoc fails
if ($pandocProcess.ExitCode -ne 0)
{
	Write-Error "Failed to run '$pandocFile' with arguments '$pandocArgs'"
	exit 1
}

# read github pandoc css and html
$githubPandocFile = Resolve-Path 'github-pandoc.css'
$githubPandocCss = [System.IO.File]::ReadAllText($githubPandocFile)
$html = [System.IO.File]::ReadAllText($htmlFile)

# embed github pandoc css and remove stylesheet link
$html = $html -replace '<style[^<>]+>(.*?)</style>', "<style type=""text/css"">`$1`r`n$githubPandocCss</style>" -replace '<link\s+rel="stylesheet"\s+href="github-pandoc.css">', ''
[System.IO.File]::WriteAllText($htmlFile, $html)