
# Export and Download Endpoint Inventory Report

## Overview
This PowerShell script automates the process of exporting an endpoint inventory report from the Trend Micro XDR API, monitoring the export status, and downloading the resulting ZIP file. The process is fully automated, including polling for the export task completion and saving the report locally.

## Prerequisites
- PowerShell 5.1 or later
- Trend Micro XDR API token
- Internet access

## Installation & Usage

1. Clone or download the script.

   ```bash
   git clone https://github.com/jmlake569/export-endpoint-inventory.git
   ```

2. Navigate to the project folder:

   ```bash
   cd export-endpoint-inventory
   ```

3. Run the script:

   ```powershell
   .\export_and_download.ps1 -token "YOUR_API_TOKEN"
   ```

   Replace `YOUR_API_TOKEN` with your valid API token.

## Features
- Sends an export request to the Trend Micro API.
- Polls the export task status until completion.
- Automatically downloads the report once it’s ready.
- Saves the report locally as a ZIP file named `endpoints_export.zip`.

## Example Output
```plaintext
Sending export request...
Full Response Headers:
Key                       Value
---                       -----
Operation-Location        https://api.xdr.trendmicro.com/v3.0/endpointSecurity/tasks/...
Export request initiated. Polling task status at: https://api.xdr.trendmicro.com/v3.0/endpointSecurity/tasks/...
Current task status: running
...
Current task status: succeeded
Export completed successfully.
Downloading the export file from: https://upload.xdr.trendmicro.com/...
Export file downloaded successfully to .\endpoints_export.zip
```

## Troubleshooting

### 1. Failed to Initiate Export Request
If you see the error:
```plaintext
Write-Error: Failed to retrieve a task status URL from the response.
```
Ensure that:
- Your API token is valid.
- The `Content-Type` header is correctly set to `application/json;charset=utf-8`.
- The API endpoint is accessible.

### 2. Export Task Fails
If the export task status is `failed`, the script will terminate. Check the error details in the API response and ensure that your API token has the necessary permissions.

### 3. File Not Downloaded
If the file is not downloaded, ensure that:
- The `resourceLocation` field is present in the API response.
- The machine running the script has access to the download URL.

## License
This script is provided "as is" without warranty of any kind. Use at your own risk.
