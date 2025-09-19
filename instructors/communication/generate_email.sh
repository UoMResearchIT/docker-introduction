#!/bin/bash

cd "$(dirname "$0")"

# Set variables
export teaching_modality="in-person"
export day_1="6"
export day_2="7 October 2025"
export location="University Place 6.213"
export further_loc="On the second day, we will meet at University Place 6.207."
export start_time="10:00"
export end_time="15:00"
export link_to_material="https://uomresearchit.github.io/docker-introduction/"
export installation_guide="https://uomresearchit.github.io/docker-introduction/#installation-of-docker"
export troubleshooting_session="3 October 2025 at 13:00"
export troubleshooting_link="https://teams.microsoft.com/l/meetup-join/19%3ameeting_N2I1ODRhODUtNDZiMi00YmVkLWJkMGQtZjFlZWMwNmZiZDI0%40thread.v2/0?context=%7b%22Tid%22%3a%22c152cb07-614e-4abb-818a-f035cfa91a77%22%2c%22Oid%22%3a%2201b8d286-9fd6-40cb-bc64-3ec1d2bc4ac6%22%7d"
export feedback_form_link="https://forms.gle/cCt5UDus4HwytZda6"

# Generate email from template
name=${day_2// /_}
envsubst < reminder_email.template > ${name}_email.md

echo "Email generated: ${name}_email.md"