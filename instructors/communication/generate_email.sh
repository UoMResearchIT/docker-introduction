#!/bin/bash

cd "$(dirname "$0")"

# Set variables
export teaching_modality="in-person"
export day_1="6"
export day_2="7 October 2025"
export location=""
export start_time="10:00"
export end_time="15:00"
export link_to_material="https://uomresearchit.github.io/docker-introduction/"
export installation_guide="https://uomresearchit.github.io/docker-introduction/#installation-of-docker"
export troubleshooting_session="3 October 2025 at 13:00"
export troubleshooting_link=""
export feedback_form_link=""

# Generate email from template
name=${day_2// /_}
envsubst < reminder_email.template > ${name}_email.md

echo "Email generated: ${name}_email.md"