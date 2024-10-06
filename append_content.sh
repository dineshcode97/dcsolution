#!/bin/bash

# Define an array of file paths
files=("/etc/nginx/nginx01.conf" "/etc/nginx/nginxo2.conf" "/etc/nginx/nginx03.conf")

# Check if all files exist
for file in "${files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "$file does not exist."
    exit 1
  fi
done

# Process each file in the array
for file in "${files[@]}"; do
  # Check if the /metrics location block exists
  if ! grep -q "location /metrics" "$file"; then
      # If it doesn't exist, add the /metrics location block after 'server_name _;'
      sed -i '/server_name _;/a \
      location /metrics {\
          proxy_pass http://sidecar_metrics:5000/metrics;  # Ensure '\''http'\'' is included\
          proxy_set_header Host $host;\
          proxy_set_header X-Real-IP $remote_addr;\
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;\
          proxy_set_header X-Forwarded-Proto $scheme;\
      }' "$file"

      echo "The /metrics location block was added to $file."
  else
      echo "The /metrics location block already exists in $file."
  fi
done

echo "All files processed!"

