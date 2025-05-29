
<#
.SYNOPSIS

Tail and follow file (tail -f) and write to output debug string so it shows in debugview

.PARAMETER Titles
1 or more titles of output for OutputDebugString; must match number of files

.PARAMETER Filenames
1 or more filepaths of files to tail

.EXAMPLE

.\TailToOutputDebugString.ps1 -Title imoslog -Filenames %TEMP%\imoslog.<env>.<YYYYMMDD>.txt %TEMP%\imoslog.<YYYYMMDD>.txt
writes the output from %TEMP%\imoslog.<env>.<YYYYMMDD>.txt and/or %TEMP%\imoslog.<YYYYMMDD>.txt to OutputDebugString() as title imoslog 

#>

[CmdletBinding()]

Param
(
    [Parameter(Mandatory=$true,HelpMessage="1 or more titles of output for OutputDebugString; must match number of files")]
    [string[]]$Titles,
    [Parameter(Mandatory=$true,HelpMessage="1 or more filepaths of files to tail")]
    [string[]]$Filenames
	
)
## https://stackoverflow.com/questions/60363812/how-to-write-to-debug-stream-with-powershell-core-so-its-captured-by-sysinterna
function startTailingJob {
	[CmdletBinding(DefaultParameterSetName = 'StartTailingJob')]

	Param
	(
		[Parameter(ParameterSetName = 'StartTailingJob',Mandatory=$true,HelpMessage="filepath of files to tail")]
		[string]$Filename,
		[Parameter(ParameterSetName = 'StartTailingJob',Mandatory=$true,HelpMessage="title of output for OutputDebugString")]
		[string]$Title
		
	)
	Write-Host ("Starting Tailing Job {0} for {1}" -f $Filename, $Title)
	return (Start-Job -ScriptBlock {
		$filename = $using:Filename
		$title = $using:Title
$WinAPI = @'
	public class WinAPI
	{
		[System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Auto)]
		public static extern void OutputDebugString(string message);
	}
'@

Add-Type $WinAPI -Language CSharp
		
		$FirstWait = $true
		while ((Test-Path -Path $filename) -eq $false) {
			if ($FirstWait -eq $true) {
				Write-Output ("Waiting for creation of {0}..." -f $filename)
				$FirstWait = $false
			}
			Start-Sleep -Milliseconds 500
		}

		Write-Output ("Tailing {0} for {1} to: OutputDebugString and Host" -f $filename, $title)
		Get-Content $filename -Tail 1 -Wait | % { 
			foreach($line in $_){
				$message = "{0}> {1} {2}" -f $title, (Get-Date -Format "yyyyMMdd.HH_mm_ss_fff"), $line
				[WinAPI]::OutputDebugString($message)
				Write-Output $message
			}
		}
	}).Id
}
[Int[]]$jobIds = @()
if ($Filenames.Length -ne $Titles.Length) {
	Write-Error("The number of Filenames ({0}) does not match the number of titles ({1})" -f $Filenames.Length, $Titles.Length)
	exit 1
}
For($i = 0; $i -lt $Filenames.Length; $i++) {
	$jobIds += (startTailingJob -Filename $Filenames[$i] -Title $Titles[$i])
}
Receive-Job -id $jobIds -Wait -AutoRemoveJob