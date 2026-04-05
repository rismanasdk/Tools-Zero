import re
import shlex
import shutil
import subprocess
from runtime_utils import execute_logged_command


AIRDECAP_CATEGORIES = {
    "1": {
        "title": "Common Options",
        "commands": [
            ("Keep 802.11 header", "airdecap-ng -l [pcap file]"),
            ("Filter by access point MAC address", "airdecap-ng -b [bssid] [pcap file]"),
            ("Set target network SSID", "airdecap-ng -e [essid] [pcap file]"),
            ("Set decrypted output file", "airdecap-ng -o [fname] [pcap file]"),
        ],
    },
    "2": {
        "title": "WEP Specific Option",
        "commands": [
            ("Set WEP key in hex", "airdecap-ng -w [key] [pcap file]"),
            ("Set corrupted WEP output file", "airdecap-ng -c [fname] [pcap file]"),
        ],
    },
    "3": {
        "title": "WPA Specific Options",
        "commands": [
            ("Set WPA passphrase", "airdecap-ng -p [pass] [pcap file]"),
            ("Set WPA Pairwise Master Key in hex", "airdecap-ng -k [pmk] [pcap file]"),
        ],
    },
}


def show_help():
    titles = [
        "Common Options",
        "WEP Specific Option",
        "WPA Specific Options",
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
    execute_logged_command(command, tool_name="Airdecap-ng", header="Airdecap-ng")


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Airdecap-ng Query\n")
    print("Airdecap-ng Command\n")
    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = AIRDECAP_CATEGORIES.get(choice)
    if not category:
        print("Selected category is not available.")
        return
    show_category_commands(category)
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Airdecap-ng>Commands>").strip()
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


def main_airdecap_ng():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Airdecap-ng>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_airdecap_ng()
