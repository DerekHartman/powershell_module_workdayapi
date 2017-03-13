function Set-WorkdayWorkerDocument {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$EmployeeId,
		[Parameter(Mandatory = $true)]
		[ValidateScript({Test-Path $_ -PathType Leaf})]
		[string]$Path,
        [string]$FileName,
        [Parameter(Mandatory = $true)]
        [ValidateSet('WID', 'Document_Category__Workday_Owned__ID', 'Document_Category_ID')]
        [string]$CategoryType,
        [Parameter(Mandatory = $true)]
        [string]$CategoryId,
        [string]$Comment,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Uri,
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]$Username,
		[Parameter(Mandatory = $true)]
		[string]$Password,
        [switch]$Passthru
	)
	$request = [xml]@'
<bsvc:Put_Worker_Document_Request bsvc:Add_Only="false" xmlns:bsvc="urn:com.workday/bsvc">
  <bsvc:Worker_Document_Data>
    <bsvc:Filename>Filename</bsvc:Filename>
    <!--Optional:-->
    <bsvc:Comment></bsvc:Comment>
    <bsvc:File>Z2Vybw==</bsvc:File>
    <bsvc:Document_Category_Reference>
      <bsvc:ID bsvc:type="CategoryType">CategoryId</bsvc:ID>
    </bsvc:Document_Category_Reference>
	<bsvc:Worker_Reference>
		<bsvc:ID bsvc:type="Employee_ID">Employee_ID</bsvc:ID>
	</bsvc:Worker_Reference>
    <bsvc:Content_Type>ContentType</bsvc:Content_Type>
  </bsvc:Worker_Document_Data>
</bsvc:Put_Worker_Document_Request>
'@

    if ([string]::IsNullOrWhiteSpace($FileName)) {
        $FileName = [string] (Split-Path -Path $Path -Leaf)
    }
	$request.Put_Worker_Document_Request.Worker_Document_Data.Worker_Reference.ID.InnerText = $EmployeeId
	$request.Put_Worker_Document_Request.Worker_Document_Data.Filename = $FileName
    $request.Put_Worker_Document_Request.Worker_Document_Data.File = [System.Convert]::ToBase64String( [system.io.file]::ReadAllBytes( $Path ) )
    $request.Put_Worker_Document_Request.Worker_Document_Data.Document_Category_Reference.ID.type = $CategoryType
    $request.Put_Worker_Document_Request.Worker_Document_Data.Document_Category_Reference.ID.InnerText = $CategoryId
    $request.Put_Worker_Document_Request.Worker_Document_Data.Comment = $Comment
	$request.Put_Worker_Document_Request.Worker_Document_Data.Content_Type = [System.Web.MimeMapping]::GetMimeMapping( $fileName )

	Invoke-WorkdayRequest -Request $request -Uri $Uri -Username $Username -Password $Password | where {$Passthru} | Write-Output
	}