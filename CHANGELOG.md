# Changelog

## 2.1.1 - 2018-04-10

### Breaking Changes

- None

### Non-Breaking Changes
- Added Get-WorkdayWorkerByIdLookupTable.
- New sample script Update_Email_By_WorkerID.ps1. 

## 2.1.0 - 2018-04-09

### Breaking Changes

- None

### Non-Breaking Changes
- Set-WorkdayWorkerEmail will now update a primary email address, without deleting all non-primary addresses. Use the new switch -Append, with -Secondary, to append multiple non-Primary email addresses.
- Update-* commands (Update-WorkdayWorkerEmail, Update-WorkdayWorkerOtherId, Update-WorkdayWorkerPhone) now output details of the request; such as Worker Type, Id and input values and no longer output XML.
