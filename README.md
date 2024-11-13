
# Export and Download Endpoint Inventory Report

## Overview
This repository provides scripts in both PowerShell and Bash to automate the process of exporting an endpoint inventory report from the Trend Micro's Vision One. The scripts handle task initiation, monitoring the export status, and downloading the resulting ZIP file.

## Prerequisites
- Trend Micro XDR API token
- Internet access

### PowerShell Requirements
- PowerShell 5.1 or later

### Bash Requirements
- `curl` and `jq` installed

## Installation & Usage

### Clone the Repository

```bash
git clone https://github.com/jmlake569/v1-endpoint-inventory.git
cd v1-endpoint-inventory
```

### PowerShell Script

1. Navigate to the `powershell` folder:

   ```bash
   cd powershell
   ```

2. Run the PowerShell script:

   ```powershell
   .\endpoint_inventory_report.ps1 -token "YOUR_API_TOKEN"
   ```

   Replace `YOUR_API_TOKEN` with your valid API token.

### Bash Script

1. Navigate to the `bash` folder:

   ```bash
   cd bash
   ```

2. Run the Bash script:

   ```bash
   ./endpoint_inventory_report.sh --token YOUR_API_TOKEN
   ```

   Replace `YOUR_API_TOKEN` with your valid API token.

## Features
- Sends an export request to the Trend Micro API.
- Polls the export task status until completion.
- Automatically downloads the report once it’s ready.
- Saves the report locally as a ZIP file.

## Example Output

### PowerShell Script
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

### Bash Script
```plaintext
Initiating export request without filters...
Polling task status at https://api.xdr.trendmicro.com/v3.0/endpointSecurity/tasks/...
Current task status: running
...
Current task status: succeeded
Export completed successfully.
Downloading the export file from https://upload.xdr.trendmicro.com/...
Export file downloaded successfully as endpoints_export.zip
```

## License
This script is provided "as is" without warranty of any kind. Use at your own risk.

