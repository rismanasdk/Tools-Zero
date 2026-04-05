import re
import shlex
import shutil
import subprocess
from runtime_utils import execute_logged_command


AIRODUMP_COMMANDS = [
    ("Save only captured IVs", "airodump-ng --ivs [interface]"),
    ("Use GPSd", "airodump-ng --gpsd [interface]"),
    ("Dump file prefix", "airodump-ng --write [prefix] [interface]"),
    ("Record all beacons in dump file", "airodump-ng --beacons [interface]"),
    ("Display update delay in seconds", "airodump-ng --update [secs] [interface]"),
    ("Print ack/cts/rts statistics", "airodump-ng --showack [interface]"),
    ("Hide known stations for showack", "airodump-ng --showack -h [interface]"),
    ("Time in ms between hopping channels", "airodump-ng -f [msecs] [interface]"),
    ("Set berlin timeout", "airodump-ng --berlin [secs] [interface]"),
    ("Read packets from a file", "airodump-ng -r [file]"),
    ("Simulate packet arrival while reading file", "airodump-ng -r [file] -T"),
    ("Active scanning simulation", "airodump-ng -x [msecs] [interface]"),
    ("Display manufacturer from IEEE OUI list", "airodump-ng --manufacturer [interface]"),
    ("Display AP uptime from beacon timestamp", "airodump-ng --uptime [interface]"),
    ("Display WPS information", "airodump-ng --wps [interface]"),
    (
        "Set output format",
        "airodump-ng --output-format [formats] --write [prefix] [interface]",
    ),
    ("Ignore negative one fixed channel message", "airodump-ng --ignore-negative-one [interface]"),
    ("Set output write interval", "airodump-ng --write-interval [seconds] --write [prefix] [interface]"),
    ("Override background detection", "airodump-ng --background [enable] [interface]"),
    ("Minimum AP packets before display", "airodump-ng -n [int] [interface]"),
    ("Filter APs by cipher suite", "airodump-ng --encrypt [suite] [interface]"),
    ("Filter APs by mask", "airodump-ng --netmask [netmask] [interface]"),
    ("Filter APs by BSSID", "airodump-ng --bssid [bssid] [interface]"),
    ("Filter APs by ESSID", "airodump-ng --essid [essid] [interface]"),
    ("Filter APs by ESSID regex", "airodump-ng --essid-regex [regex] [interface]"),
    ("Filter unassociated clients", "airodump-ng -a [interface]"),
    ("Set channel to HT20", "airodump-ng --ht20 [interface]"),
    ("Set channel to HT40-", "airodump-ng --ht40- [interface]"),
    ("Set channel to HT40+", "airodump-ng --ht40+ [interface]"),
    ("Capture on specific channels", "airodump-ng --channel [channels] [interface]"),
    ("Select hopping band", "airodump-ng --band [abg] [interface]"),
    ("Use specific frequencies in MHz", "airodump-ng -C [frequencies] [interface]"),
    ("Set channel switching method", "airodump-ng --cswitch [method] [interface]"),
]


def extract_placeholders(template):
    return re.findall(r"\[([^\]]+)\]", template)


def build_command(template):
    command = template

    for placeholder in extract_placeholders(template):
        value = input(f"Input {placeholder}> ").strip()
        if not value:
            print(f"{placeholder} cannot be empty.")
            return None
        command = command.replace(f"[{placeholder}]", value, 1)

    return shlex.split(command)


def run_command(command):
    execute_logged_command(command, tool_name="Airodump-ng", header="Airodump-ng")


def show_commands():
    print("\nThe Big Five\n")
    print("Airodump-ng Query\n")
    print("Airodump-ng Command\n")

    for index, (label, template) in enumerate(AIRODUMP_COMMANDS, start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def main_airodump_ng():
    show_commands()
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Airodump-ng>").strip()

    if not select.isdigit():
        print("Input command must be a number.")
        return

    index = int(select) - 1
    if index < 0 or index >= len(AIRODUMP_COMMANDS):
        print("Selected command is not available.")
        return

    _, template = AIRODUMP_COMMANDS[index]
    command = build_command(template)
    if command:
        run_command(command)


if __name__ == "__main__":
    main_airodump_ng()
