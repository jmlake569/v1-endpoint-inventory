#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 --token YOUR_API_TOKEN"
  exit 1
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --token) TOKEN="$2"; shift ;;
    *) usage ;;
  esac
  shift
done

# Check if the token is provided
if [ -z "$TOKEN" ]; then
  echo "API token is required."
  usage
fi

# Define the API base URL
EXPORT_URL="https://api.xdr.trendmicro.com/v3.0/endpointSecurity/endpoints/export"
HEADERS=(
  "-H" "Authorization: Bearer $TOKEN"
  "-H" "Content-Type: application/json;charset=utf-8"
)

# Define an empty body for the request to get all data without filters
BODY="{}"

# Step 1: Initiate the export request
echo "Initiating export request without filters..."
RESPONSE=$(curl -s -i -X POST "${HEADERS[@]}" -d "$BODY" "$EXPORT_URL")

# Extract HTTP status and operation-location for task status URL
HTTP_STATUS=$(echo "$RESPONSE" | grep HTTP | awk '{print $2}')
OPERATION_LOCATION=$(echo "$RESPONSE" | grep -i 'operation-location:' | awk '{print $2}' | tr -d '\r')

# Verify that the request was accepted
if [ "$HTTP_STATUS" -ne 202 ] || [ -z "$OPERATION_LOCATION" ]; then
  echo "Failed to retrieve the task status URL from the response."
  exit 1
fi

# Step 2: Poll the task status until it's "succeeded"
echo "Polling task status at $OPERATION_LOCATION..."
STATUS="running"
while [ "$STATUS" != "succeeded" ]; do
  TASK_RESPONSE=$(curl -s -X GET "${HEADERS[@]}" "$OPERATION_LOCATION")
  STATUS=$(echo "$TASK_RESPONSE" | jq -r '.status')
  
  # Print current task status
  echo "Current task status: $STATUS"

  # Check if the task has failed
  if [ "$STATUS" == "failed" ]; then
    echo "Export failed."
    echo "$TASK_RESPONSE" | jq .
    exit 1
  fi

  # Wait before retrying
  sleep 15
done

# Step 3: Once succeeded, download the file from resource location
echo "Export completed successfully."
RESOURCE_LOCATION=$(echo "$TASK_RESPONSE" | jq -r '.resourceLocation')
if [ "$RESOURCE_LOCATION" != "null" ]; then
  OUTPUT_FILE="endpoints_export.zip"
  echo "Downloading the export file to $OUTPUT_FILE..."
  curl -L -o "$OUTPUT_FILE" "$RESOURCE_LOCATION"
  echo "Download complete. File saved as $OUTPUT_FILE."
else
  echo "No download URL found in the response."
fi
