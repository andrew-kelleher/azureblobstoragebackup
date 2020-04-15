# Scenario
Microsoft's Azure services continue to expand and develop at an incredible rate. However, one of the features that's currently lacking is out of the box support for Blob storage backup.

# Solution
Create a simple solution that leverages the following Azure services to backup Blob storage on a schedule - 

- Azure Functions with PowerShell
- AzCopy
- Azure File Shares
- Recovery Services vaults

# Deployment
This repo contains the PowerShell script that is called by the Azure Function App.

Full walkthrough and further background is [here](https://medium.com/azure-architects/how-to-backup-azure-blob-storage-accounts-13a09e6feae2) on the Azure Architects blog.