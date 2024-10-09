import os
import sys
from typing import Union
from datetime import datetime

import argparse
import print_format as pf

from flask import Flask, send_file, request
from waitress import serve

units = None
app = Flask(__name__)

file_name = "unicorn_sightings.txt"
file_path = f"output/{file_name}"

help_string = """
Welcome to the Space Purple Unicorn Counter!
::::: Try 'curl -X PUT localhost:8321/unicorn_spotted/?location=moon&brightness=100' to record a unicorn sighting!
::::: Or 'curl localhost:8321/export/' to download the unicorn sightings file!
"""

if os.environ.get('EXPORT') == 'True':
    @app.route("/export/", methods=["GET"])
    def chart():
        if not os.path.exists(file_path):
            return {"message": "No unicorn sightings yet!"}
            
        return send_file(file_path, as_attachment=True)

@app.route("/unicorn_spotted/", methods=["PUT"])
def unicorn_sighting() -> dict:
    #e.g. curl localhost:8321/unicorn_spotted/?location=moon&brightness=10

    location = request.args.get("location")
    brightness = request.args.get("brightness")

    # --------------------------------------------------------------------------
    # Write the sighting to a file and print to the console
    with open(file_path, "a") as unicorn_file:
        # Append the location to the file
        line = pf.get_str(location, brightness, units)
        unicorn_file.write(line)

        # Print the line to the console
        console_line = f"::::: ({datetime.now()}) Unicorn spotted at {location}!! Brightness: {brightness} {units}"
        print(console_line)
        sys.stdout.flush()

    return {"message": "Unicorn sighting recorded!"}


if __name__ == "__main__":
    # --------------------------------------------------------------------------
    # Parse the command line arguments
    parser = argparse.ArgumentParser(description="Run the unicorn sighting API")
    parser.add_argument(
        "--units",
        type=str,
        default="iuhc",
        choices=["iuhc", "iulu"],
        help="The units to use for the unicorn brightness",
    )
    args = parser.parse_args()

    # --------------------------------------------------------------------------
    # Set the units
    units = args.units
    if units == "iuhc":
        unit_long_name = "Imperial Unicorn Hoove Candles"
    elif units == "iulu":
        unit_long_name = "Intergalactic Unicorn Luminiocity Units"

    # --------------------------------------------------------------------------
    # Print the initialization message
    logo = r"""
            \\
             \\
              \\
               \\
                >\/7
            _.-(6'  \
           (=___._/` \            ____  ____  _    _  ____
                )  \ |           / ___||  _ \| |  | |/ ___|
               /   / |           \___ \| |_) | |  | | |
              /    > /            ___) |  __/| |__| | |___
             j    < _\           |____/|_|    \____/ \____|
         _.-' :      ``.
         \ r=._\        `.       Space Purple Unicorn Counter
        <`\\_  \         .`-.
         \ r-7  `-. ._  ' .  `\
          \`,      `-.`7  7)   )
           \/         \|  \'  / `-._
                      ||    .'
                       \\  (
                        >\  >
                    ,.-' >.'
                   <.'_.''
                     <'
    """
    print(logo)
    print(f"::::: Initializing SPUC...")
    print(f"::::: Units set to {unit_long_name} [{units}].")
    print(f"{help_string}")
    sys.stdout.flush()

    # --------------------------------------------------------------------------
    # Run the API

    serve(app, host="0.0.0.0", port=8321)
