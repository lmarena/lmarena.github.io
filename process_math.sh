#!/bin/bash

# Function to process a single file
process_file() {
    local file="$1"
    local temp_file="${file}.temp"

    # Convert single dollar signs to double, but not if they're already double
    sed -E '
        # Skip lines that contain double dollar signs
        /\$\$/b
        
        # For lines with single dollar signs
        /\$[^$]+\$/{
            # Replace single $ with double $$ for all occurrences in the line
            s/\$([^$]+)\$/\$\$\1\$\$/g
        }
    ' "$file" > "$temp_file"

    mv "$temp_file" "$file"
    echo "Processed: $file"
}

# Find all .md files in _post folder and its subfolders
find _posts -type f -name "*.md" | while read -r file; do
    process_file "$file"
done

echo "All .md files have been processed."