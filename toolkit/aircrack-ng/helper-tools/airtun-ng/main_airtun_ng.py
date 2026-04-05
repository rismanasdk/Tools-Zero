import re
import shlex
import shutil
import subprocess
from runtime_utils import execute_logged_command


AIRTUN_CATEGORIES = {
    "1": {
        "title": "General Options",
        "commands": [
            ("Set packets per second", "airtun-ng -x [nbpps] [replay interface]"),
            ("Set access point MAC address", "airtun-ng -a [bssid] [replay interface]"),
            ("Capture packets from interface", "airtun-ng -i [iface] [replay interface]"),
            ("Read PRGA from file", "airtun-ng -y [file] [replay interface]"),
            ("Use WEP key to encrypt packets", "airtun-ng -w [wepkey] [replay interface]"),
            ("Use WPA passphrase to decrypt packets", "airtun-ng -p [pass] -a [bssid] -e [essid] [replay interface]"),
            ("Set target network SSID", "airtun-ng -e [essid] [replay interface]"),
            ("Set frame direction or WDS tunnel mode", "airtun-ng -t [tods] [replay interface]"),
            ("Read frames from pcap file", "airtun-ng -r [file] [replay interface]"),
            ("Set source MAC address", "airtun-ng -h [MAC] [replay interface]"),
        ],
    },
    "2": {
        "title": "WDS Bridge Mode Options",
        "commands": [
            ("Set transmitter MAC address", "airtun-ng -s [transmitter] [replay interface]"),
            ("Enable bidirectional mode", "airtun-ng -b [replay interface]"),
        ],
    },
    "3": {
        "title": "Repeater Options",
        "commands": [
            ("Activate repeat mode", "airtun-ng --repeat [replay interface]"),
            ("Set BSSID to repeat", "airtun-ng --bssid [mac] [replay interface]"),
            ("Set netmask for BSSID filter", "airtun-ng --netmask [mask] [replay interface]"),
        ],
    },
}


def show_help():
    titles = [
        "General Options",
        "WDS Bridge Mode Options",
        "Repeater Options",
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
    execute_logged_command(command, tool_name="Airtun-ng", header="Airtun-ng")


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Airtun-ng Query\n")
    print("Airtun-ng Command\n")
    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = AIRTUN_CATEGORIES.get(choice)
    if not category:
        print("Selected category is not available.")
        return
    show_category_commands(category)
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Airtun-ng>Commands>").strip()
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


def main_airtun_ng():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Airtun-ng>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_airtun_ng()
