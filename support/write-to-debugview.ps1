
<#
.SYNOPSIS

Write single output message with title to DebugView

.PARAMETER Title
Title for OutputDebugString

.PARAMETER Message
Message for OutputDebugString

.PARAMETER RepeatFrequencySeconds
Optional, repeat message every RepeatFrequencySeconds

.EXAMPLE

.\write-to-debugview.ps1 -Title TIMESTAMP -Message "Time Checkpoint"
writes "Time Checkpoint" to OutputDebugString() as title TIMESTAMP
every outputdebug message from this script always includes a timestamp

.\write-to-debugview.ps1 -Title TIMESTAMP -Message "Time Checkpoint" -RepeatFrequencySeconds 30
writes "Time Checkpoint" to OutputDebugString() as title TIMESTAMP every 30 seconds until stopping
every outputdebug message from this script always includes a timestamp

#>

[CmdletBinding()]

Param
(
    [Parameter(Mandatory=$true,HelpMessage="Title for OutputDebugString")]
    [string]$Title,
    [Parameter(Mandatory=$true,HelpMessage="Message for OutputDebugString")]
    [string]$Message,
	[Parameter(HelpMessage="Optional, repeat message every RepeatFrequencySeconds")]
	[int]$RepeatFrequencySeconds
	
)
[double] $sleepSeconds = 0.0
if ($PSBoundParameters.ContainsKey('RepeatFrequencySeconds')) {
	$sleepSeconds = 1.0 * $RepeatFrequencySeconds
	if ($sleepSeconds -gt 0.0) {
		Write-Host ("Debugview Heartbeat: OutputDebugString('{0} <timestamp> {1}') every {2} seconds" -f $Title, $Message, $sleepSeconds)
	}
}
## https://stackoverflow.com/questions/60363812/how-to-write-to-debug-stream-with-powershell-core-so-its-captured-by-sysinterna
$WinAPI = @'
	public class WinAPI
	{
		[System.Runtime.InteropServices.DllImport("kernel32.dll", CharSet = System.Runtime.InteropServices.CharSet.Auto)]
		public static extern void OutputDebugString(string message);
	}
'@

Add-Type $WinAPI -Language CSharp
do {
	$debugMessage = "{0}> {1} {2}" -f $Title, (Get-Date -Format "yyyyMMdd.HH_mm_ss_fff"), $Message
	[WinAPI]::OutputDebugString($debugMessage)
	Write-Output $debugMessage
	if ($sleepSeconds -gt 0.0) {
		Start-Sleep -Seconds $repeatFrequencySeconds
	}
} while ($sleepSeconds -gt 0.0)