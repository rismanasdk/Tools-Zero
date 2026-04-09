import sys
from pathlib import Path
import re
import shlex
import shutil
import subprocess

for parent in Path(__file__).resolve().parents:
    if (parent / "runtime_utils.py").exists():
        sys.path.insert(0, str(parent))
        break

from runtime_utils import execute_logged_command


AIRBASE_CATEGORIES = {
    "1": {
        "title": "Options",
        "commands": [
            ("Set access point MAC address", "airbase-ng -a [bssid] [replay interface]"),
            ("Capture packets from interface", "airbase-ng -i [iface] [replay interface]"),
            ("Use WEP key to encrypt or decrypt packets", "airbase-ng -w [WEP key] [replay interface]"),
            ("Set source MAC for MITM mode", "airbase-ng -h [MAC] [replay interface]"),
            ("Disallow specified client MACs", "airbase-ng -f [disallow] [replay interface]"),
            ("Set WEP flag in beacons", "airbase-ng -W [0|1] [replay interface]"),
            ("Quiet mode", "airbase-ng -q [replay interface]"),
            ("Verbose mode", "airbase-ng -v [replay interface]"),
            ("Enable MITM mode", "airbase-ng -M [replay interface]"),
            ("Enable ad-hoc mode", "airbase-ng -A [replay interface]"),
            ("External packet processing", "airbase-ng -Y [in|out|both] [replay interface]"),
            ("Set channel", "airbase-ng -c [channel] [replay interface]"),
            ("Hidden ESSID", "airbase-ng -X [replay interface]"),
            ("Force shared key authentication", "airbase-ng -s [replay interface]"),
            ("Set shared key challenge length", "airbase-ng -S [length] [replay interface]"),
            ("Enable Caffe-Latte attack", "airbase-ng -L [replay interface]"),
            ("Enable Hirte attack", "airbase-ng -N [replay interface]"),
            ("Set packets per second", "airbase-ng -x [nbpps] [replay interface]"),
            ("Disable responses to broadcast probes", "airbase-ng -y [replay interface]"),
            ("Set all WPA WEP open tags", "airbase-ng -0 [replay interface]"),
            ("Set WPA1 tags", "airbase-ng -z [type] [replay interface]"),
            ("Set WPA2 tags", "airbase-ng -Z [type] [replay interface]"),
            ("Set fake EAPOL type", "airbase-ng -V [type] [replay interface]"),
            ("Write sent and received frames to pcap file", "airbase-ng -F [prefix] [replay interface]"),
            ("Respond to all probes", "airbase-ng -P [replay interface]"),
            ("Set beacon interval", "airbase-ng -I [interval] [replay interface]"),
            ("Enable beaconing of probed ESSIDs", "airbase-ng -C [seconds] -P [replay interface]"),
        ],
    },
    "2": {
        "title": "Filter Options",
        "commands": [
            ("Filter or use a BSSID", "airbase-ng --bssid [MAC] [replay interface]"),
            ("Read BSSID list from file", "airbase-ng --bssids [file] [replay interface]"),
            ("Accept client by MAC", "airbase-ng --client [MAC] [replay interface]"),
            ("Read client MAC list from file", "airbase-ng --clients [file] [replay interface]"),
            ("Specify a single ESSID", "airbase-ng --essid [ESSID] [replay interface]"),
            ("Read ESSID list from file", "airbase-ng --essids [file] [replay interface]"),
        ],
    },
}


def show_help():
    titles = [
        "Options",
        "Filter Options",
    ]
    for index, title in enumerate(titles, start=1):
        print(f"{index}. {title}")


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
    execute_logged_command(command, tool_name="Airbase-ng", header="Airbase-ng")


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Airbase-ng Query\n")
    print("Airbase-ng Command\n")

    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = AIRBASE_CATEGORIES.get(choice)
    if not category:
        print("Selected category is not available.")
        return

    show_category_commands(category)
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Airbase-ng>Commands>").strip()

    if not select.isdigit():
        print("Input command must be a number.")
        return

    index = int(select) - 1
    commands = category["commands"]
    if index < 0 or index >= len(commands):
        print("Selected command is not available.")
        return

    _, template = commands[index]
    command = build_command(template)
    if command:
        run_command(command)


def main_airbase_ng():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Airbase-ng>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_airbase_ng()
