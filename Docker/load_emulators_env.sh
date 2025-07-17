#!/bin/bash

# Path to the configuration file
EMULATORS_CONFIG_FILE="${SETTINGS}/emulators.rc"
mkdir -p "${SETTINGS}"

# Copy emulators config if not already present
if ! [ -f "${EMULATORS_CONFIG_FILE}" ]; then
    echo "INFO: Emulators config not present, copying default"
    cp emulators.rc "${EMULATORS_CONFIG_FILE}"
fi

# Check if the file exists
if [[ ! -f "${EMULATORS_CONFIG_FILE}" ]]; then
    echo "File ${EMULATORS_CONFIG_FILE} not found."
    exit 1
fi

# Read and process each line
while IFS= read -r line; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # If the line starts with BOX64_, export it as an environment variable
    if [[ "$line" == BOX64_* ]]; then
        export "$line"
        echo "export $line"
    fi

    # If the line starts with FEX_, export it as an environment variable
    if [[ "$line" == FEX_* ]]; then
        export "$line"
        echo "export $line"
    fi
done < "${EMULATORS_CONFIG_FILE}"
