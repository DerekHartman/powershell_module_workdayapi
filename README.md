# Workday Powershell Script Module #

## Description ##
Provides simple methods for accessing the Workday API.

This simple Powershell Module has been written to fulfill my employer's Workday automation needs. I see this as a prototype, while I experiment with the best way to expose the complexities of the Workday API in a Powershell-y way. Thinking that the community might find it helpful and may even wish to comment or contribute, I have hosted the source here.

## Features ##

* Easy command-line use after setting default configuration and securely saving it to the current user's profile.
* Get Worker information for one or all workers.
* Get / Set / Update Worker email.
* Get / Set / Update Worker phone.
* Upload Worker Photos.
* Upload Worker Documents.
* Run reports.
* Submit arbitrary API calls.
 
## Examples ##
    Set-WorkdayCredential
    Set-WorkdayEndpoint -Endpoint Staffing        -Uri 'https://SERVICE.workday.com/ccx/service/TENANT/Staffing/v25.1'
    Set-WorkdayEndpoint -Endpoint Human_Resources -Uri 'https://SERVICE.workday.com/ccx/service/TENANT/Human_Resources/v25.1'
    Save-WorkdayConfiguration

    Set-WorkdayWorkerPhone -EmployeeId -WorkPhone 9876543210

    Get-WorkdayWorkerPhone -EmpoyeeId 123

    Type          Number            Primary Public
    ----          ------            ------- ------
    Home/Landline +1 (123) 456-7890 0        False
    Work/Landline +1 (987) 654-3210 0         True


    $response = Invoke-WorkdayRequest -Request '<bsvc:Server_Timestamp_Get xmlns:bsvc="urn:com.workday/bsvc" />' -Uri https://SERVICE.workday.com/ccx/service/TENANT/Human_Resources/v25.1 
    $response.Server_Timestamp

    wd                   version Server_Timestamp_Data        
    --                   ------- ---------------------        
    urn:com.workday/bsvc v25.1   2015-12-02T12:18:30.841-08:00


    Get-Command -Module WorkdayApi | Get-Help | Format-Table Name, Synopsis -AutoSize

    Name                        Synopsis                                                                                
    ----                        --------                                                                                
    Export-WorkdayDocument      Exports Workday Documents.                                                              
    Get-WorkdayEndpoint         Gets the default Uri value for all or a particular Endpoint.                            
    Get-WorkdayReport           Returns the XML result from any Workday report, based on its URI.                       
    Get-WorkdayWorker           Gets Worker information as Workday XML.                                                 
    Get-WorkdayWorkerDocument   Gets Workday Worker Documents.                                                          
    Get-WorkdayWorkerEmail      Returns a Worker's email addresses.                                                     
    Get-WorkdayWorkerPhone      Returns a Worker's phone numbers.                                                       
    Invoke-WorkdayRequest       Sends XML requests to Workday API, with proper authentication and receives XML response.
    Remove-WorkdayConfiguration Removes Workday configuration file from the current users Profile.                      
    Save-WorkdayConfiguration   Saves default Workday configuration to a file in the current users Profile.             
    Set-WorkdayCredential       Sets the default Workday API credentials.                                               
    Set-WorkdayEndpoint         Sets the default Uri value for a particular Endpoint.                                   
    Set-WorkdayWorkerDocument   Uploads a document to a Worker's records in Workday.                                    
    Set-WorkdayWorkerEmail      Sets a Worker's email in Workday.                                                       
    Set-WorkdayWorkerPhone      Sets a Worker's phone number in Workday.                                                
    Set-WorkdayWorkerPhoto      Uploads an image file to Workday and set it as a Worker's photo.                        
    Update-WorkdayWorkerEmail   Updates a Worker's email in Workday, only if it is different.                           
    Update-WorkdayWorkerPhone   Updates a Worker's phone number in Workday, only if it is different.                    


## Installation ##

The only dependency is Powershell version 4.

To install...

* Download the files.
* Execute the script Install-WorkdayModule.ps1