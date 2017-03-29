﻿function Update-WorkdayWorkerBadgeId {
<#
.SYNOPSIS
    Updates a Worker's phone number in Workday, only if it is different.

.DESCRIPTION
    Updates a Worker's phone number in Workday, only if it is different.
    Change requests are always recorded in Workday's audit log even when
    the number is the same. Unlike Set-WorkdayWorkerPhone, this cmdlet
    first checks the current phone number before requesting a change. 

.PARAMETER WorkerId
    The Worker's Id at Workday.

.PARAMETER WorkerType
    The type of ID that the WorkerId represents. Valid values
    are 'WID', 'Contingent_Worker_ID' and 'Employee_ID'.

.PARAMETER Human_ResourcesUri
    Human_Resources Endpoint Uri for the request. If not provided, the value
    stored with Set-WorkdayEndpoint -Endpoint Human_Resources is used.


.PARAMETER Username
    Username used to authenticate with Workday. If empty, the value stored
    using Set-WorkdayCredential will be used.

.PARAMETER Password
    Password used to authenticate with Workday. If empty, the value stored
    using Set-WorkdayCredential will be used.

.EXAMPLE
    
Update-WorkdayWorkerPhone -WorkerId 123 -Number 1234567890

#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true,
            ParameterSetName="Search",
            Position=0)]
		[ValidatePattern ('^[a-fA-F0-9\-]{1,32}$')]
		[string]$WorkerId,
        [Parameter(ParameterSetName="Search")]
		[ValidateSet('WID', 'Contingent_Worker_ID', 'Employee_ID')]
		[string]$WorkerType = 'Employee_ID',
        [Parameter(ParameterSetName="Search")]
		[string]$Human_ResourcesUri,
        [Parameter(ParameterSetName="Search")]
		[string]$Username,
        [Parameter(ParameterSetName="Search")]
		[string]$Password,
        [Parameter(Mandatory = $true,
            ParameterSetName="NoSearch")]
        [xml]$WorkerXml,
		[Parameter(Mandatory = $true)]
		[ValidatePattern('^[0-9]+$')]
		[string]$BadgeId,
        [Parameter(Mandatory = $true)]
        [datetime]$IssuedDate,
        [Parameter(Mandatory = $true)]
        [datetime]$ExpirationDate
	)

    if ([string]::IsNullOrWhiteSpace($Human_ResourcesUri)) { $Human_ResourcesUri = $WorkdayConfiguration.Endpoints['Human_Resources'] }

    if ($PsCmdlet.ParameterSetName -eq 'NoSearch') {
        $otherIds = Get-WorkdayWorkerOtherId -WorkerXml $WorkerXml
        $WorkerType = 'WID'
        $workerReference = $WorkerXml.GetElementsByTagName('wd:Worker_Reference') | Select -First 1
        $WorkerId = $workerReference.ID | where {$_.type -eq 'WID'} | select -ExpandProperty InnerText
    } else {
        $otherIds = Get-WorkdayWorkerOtherId -WorkerId $WorkerId -WorkerType $WorkerType -Human_ResourcesUri:$Human_ResourcesUri -Username:$Username -Password:$Password
    }

    $current = $otherIds | Where-Object {$_.Type -eq 'Custom_ID/Badge_ID'} | select -First 1
    
    if ($current -eq $null) {
            $current = [pscustomobject][ordered]@{
                 Type       = 'Custom_ID/Badge_ID'
                 Id         = 'New'
                 Descriptor = $null
                 Issued_Date = Get-Date
                 Expiration_Date = Get-Date
             }
    }        

    $msg = '{{0}} Current [{0} {1:g} to {2:g}] Proposed [{3} {4:g} to {5:g}]' -f $current.Id, $current.Issued_Date, $current.Expiration_Date, $BadgeId, $IssuedDate, $ExpirationDate

    $output = [pscustomobject][ordered]@{
        Success = $false
        Message = $msg -f 'Failed'
        Xml     = $null
    }

    $idSame = $current.Id -eq $BadgeId
    $issueDateSame = [math]::Abs(($current.Issued_Date - $IssuedDate).Days) -eq 0
    $expireDateSame = [math]::Abs(($current.Expiration_Date - $ExpirationDate).Days) -eq 0

    if ( $idSame -and $issueDateSame -and $expireDateSame ) {
        $output.Message = $msg -f 'Matched'
        $output.Success = $true
    } else {
        $params = $PSBoundParameters
        $null = $params.Remove('WorkerXml')
        $null = $params.Remove('WorkerId')
        $null = $params.Remove('WorkerType')
        $o = Set-WorkdayWorkerBadgeId -WorkerId $WorkerId -WorkerType $WorkerType @params
        
        if ($o -ne $null -and $o.Success) {
            $output.Success = $true
            $output.Message = $msg -f 'Changed'
            $output.Xml = $o.Xml
        }
    }

    Write-Verbose $output.Message
    Write-Output $output
}
