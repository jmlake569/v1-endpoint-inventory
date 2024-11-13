param (
    [string]$token  # Your API token
)

# Ensure the token is provided
if (-not $token) {
    Write-Error "API token is required. Please provide a valid token."
    exit 1
}

# Define the API endpoint URL and headers
$exportUrl = "https://api.xdr.trendmicro.com/v3.0/endpointSecurity/endpoints/export"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json;charset=utf-8"
}

# Define an empty JSON body
$body = "{}"

# Step 1: Initiate the export request and display the full response for debugging
try {
    Write-Host "Sending export request..."
    $response = Invoke-WebRequest -Uri $exportUrl -Method Post -Headers $headers -Body $body -ContentType "application/json"

    # Display the response headers for inspection
    Write-Host "Full Response Headers:"
    $response.Headers | Format-Table -AutoSize

    # Extract the operation-location header as a single string
    $locationHeader = ($response.Headers["Operation-Location"] | Select-Object -First 1)
    if ($locationHeader) {
        Write-Host "Export request initiated. Polling task status at: $locationHeader" -ForegroundColor Yellow
    } else {
        Write-Error "Failed to retrieve the operation-location from headers. Full Response: $($response | ConvertTo-Json -Depth 4)"
        exit 1
    }
} catch {
    Write-Error "Failed to initiate export request: $_"
    exit 1
}

# Step 2: Poll the export status until it's complete
$status = "running"
while ($status -ne "succeeded") {
    try {
        $statusResponse = Invoke-RestMethod -Uri $locationHeader -Method Get -Headers $headers
        $status = $statusResponse.status

        if ($status -eq "succeeded") {
            Write-Host "Export completed successfully." -ForegroundColor Green
            break
        } elseif ($status -eq "failed") {
            Write-Error "Export failed. Exiting script."
            exit 1
        } else {
            Write-Host "Current task status: $status. Checking status again in 10 seconds..."
            Start-Sleep -Seconds 10
        }
    } catch {
        Write-Error "Failed to retrieve export status: $_"
        exit 1
    }
}

# Step 3: Download the export file (ZIP) once the export is complete
$resourceLocation = $statusResponse.resourceLocation
$outputFilePath = ".\endpoints_export.zip"
if ($resourceLocation) {
    try {
        Write-Host "Downloading the export file from: $resourceLocation"
        Invoke-WebRequest -Uri $resourceLocation -OutFile $outputFilePath
        Write-Host "Export file downloaded successfully to $outputFilePath" -ForegroundColor Green
    } catch {
        Write-Error "Failed to download the export file: $_"
    }
} else {
    Write-Error "No download URL found in the task response."
}
