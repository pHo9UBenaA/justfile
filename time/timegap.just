# Calculate time gap for work sessions
# 
# This tool calculates work time progress against a target:
# - Shows how much time has elapsed since start
# - Accounts for break time taken
# - Calculates remaining work time or overtime
# - Provides expected end time
#
# Usage: just time::timegap::timegap START_TIME TARGET_HOURS BREAK_HOURS
# Examples:
#   just time::timegap::timegap "09:00" 8 1     # Started at 9:00, target 8h, 1h break
#   just time::timegap::timegap "08:30" 7.5 0.5 # Started at 8:30, target 7.5h, 30min break
timegap START_TIME TARGET_HOURS BREAK_HOURS="0":
    #!/bin/bash
    set -e

    START_TIME="{{ START_TIME }}"
    TARGET_HOURS="{{ TARGET_HOURS }}"
    BREAK_HOURS="{{ BREAK_HOURS }}"

    # Validate input format (HH:MM)
    if ! echo "$START_TIME" | grep -qE '^[0-9]{1,2}:[0-9]{2}$'; then
        echo "Error: START_TIME must be in HH:MM format (e.g., '09:00')"
        exit 1
    fi

    # Validate numeric inputs
    if ! echo "$TARGET_HOURS" | grep -qE '^[0-9]+(\.[0-9]+)?$'; then
        echo "Error: TARGET_HOURS must be a number (e.g., 8 or 8.5)"
        exit 1
    fi

    if ! echo "$BREAK_HOURS" | grep -qE '^[0-9]+(\.[0-9]+)?$'; then
        echo "Error: BREAK_HOURS must be a number (e.g., 1 or 1.5)"
        exit 1
    fi

    # Get current time
    CURRENT_TIME=$(date '+%H:%M')
    
    # Function to convert HH:MM to minutes
    time_to_minutes() {
        local time_str="$1"
        local hours=$(echo "$time_str" | cut -d':' -f1)
        local minutes=$(echo "$time_str" | cut -d':' -f2)
        # Remove leading zeros to avoid octal interpretation
        hours=$((10#$hours))
        minutes=$((10#$minutes))
        echo $((hours * 60 + minutes))
    }

    # Function to convert minutes to HH:MM format
    minutes_to_time() {
        local total_minutes="$1"
        local hours=$((total_minutes / 60))
        local minutes=$((total_minutes % 60))
        printf "%02d:%02d" "$hours" "$minutes"
    }

    # Function to convert decimal hours to minutes
    hours_to_minutes() {
        local hours="$1"
        echo "$hours * 60" | bc -l | cut -d'.' -f1
    }

    # Calculate elapsed time
    start_minutes=$(time_to_minutes "$START_TIME")
    current_minutes=$(time_to_minutes "$CURRENT_TIME")
    
    # Handle day boundary (if current time is earlier than start time, assume next day)
    if [ "$current_minutes" -lt "$start_minutes" ]; then
        current_minutes=$((current_minutes + 24 * 60))
    fi
    
    elapsed_minutes=$((current_minutes - start_minutes))
    
    # Convert target and break hours to minutes
    target_minutes=$(hours_to_minutes "$TARGET_HOURS")
    break_minutes=$(hours_to_minutes "$BREAK_HOURS")
    
    # Calculate net work time (elapsed - break)
    net_work_minutes=$((elapsed_minutes - break_minutes))
    
    # Calculate gap (positive = overtime, negative = undertime)
    gap_minutes=$((net_work_minutes - target_minutes))
    
    # Convert times for display
    elapsed_time=$(minutes_to_time "$elapsed_minutes")
    net_work_time=$(minutes_to_time "$net_work_minutes")
    target_time=$(minutes_to_time "$target_minutes")
    break_time=$(minutes_to_time "$break_minutes")
    
    # Display results
    echo "=========================================="
    echo "          Work Time Calculator"
    echo "=========================================="
    echo "Start time:      $START_TIME"
    echo "Current time:    $CURRENT_TIME"
    echo "Elapsed time:    $elapsed_time"
    echo "Break time:      $break_time"
    echo "Net work time:   $net_work_time"
    echo "Target time:     $target_time"
    echo "=========================================="
    
    if [ "$gap_minutes" -gt 0 ]; then
        gap_time=$(minutes_to_time "$gap_minutes")
        echo "Status:          ✅ OVERTIME by $gap_time"
        echo "You've exceeded your target by $gap_time!"
    elif [ "$gap_minutes" -lt 0 ]; then
        remaining_minutes=$((-gap_minutes))
        remaining_time=$(minutes_to_time "$remaining_minutes")
        # Calculate expected end time
        end_minutes=$((current_minutes + remaining_minutes))
        if [ "$end_minutes" -ge $((24 * 60)) ]; then
            end_minutes=$((end_minutes - 24 * 60))
        fi
        end_time=$(minutes_to_time "$end_minutes")
        echo "Status:          ⏰ UNDERTIME by $remaining_time"
        echo "Remaining work:  $remaining_time"
        echo "Expected end:    $end_time"
    else
        echo "Status:          🎯 TARGET REACHED"
        echo "Perfect! You've reached your target work time."
    fi
    echo "=========================================="
