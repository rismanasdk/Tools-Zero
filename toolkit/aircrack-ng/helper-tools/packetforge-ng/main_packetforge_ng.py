import re
import shlex
import shutil
import subprocess
from runtime_utils import execute_logged_command


PACKETFORGE_CATEGORIES = {
    "1": {
        "title": "Forge Options",
        "commands": [
            ("Set frame control word", "packetforge-ng --arp -p [fctrl] -w [file]"),
            ("Set access point MAC address", "packetforge-ng --arp -a [bssid] -w [file]"),
            ("Set destination MAC address", "packetforge-ng --arp -c [dmac] -w [file]"),
            ("Set source MAC address", "packetforge-ng --arp -h [smac] -w [file]"),
            ("Set FromDS bit", "packetforge-ng --arp -j -w [file]"),
            ("Clear ToDS bit", "packetforge-ng --arp -o -w [file]"),
            ("Disable WEP encryption", "packetforge-ng --arp -e -w [file]"),
            ("Set destination IP and optional port", "packetforge-ng --udp -k [ip[:port]] -w [file]"),
            ("Set source IP and optional port", "packetforge-ng --udp -l [ip[:port]] -w [file]"),
            ("Set time to live", "packetforge-ng --udp -t [ttl] -w [file]"),
            ("Write packet to pcap file", "packetforge-ng --arp -w [file]"),
            ("Specify size of null packet", "packetforge-ng --null -s [size] -w [file]"),
            ("Set number of packets to generate", "packetforge-ng --arp -n [packets] -w [file]"),
        ],
    },
    "2": {
        "title": "Source Options",
        "commands": [
            ("Read packet from raw file", "packetforge-ng --custom -r [file] -w [output file]"),
            ("Read PRGA from file", "packetforge-ng --arp -y [file] -w [output file]"),
        ],
    },
    "3": {
        "title": "Modes",
        "commands": [
            ("Forge an ARP packet", "packetforge-ng --arp -a [bssid] -h [smac] -k [ip[:port]] -l [ip[:port]] -w [file]"),
            ("Forge a UDP packet", "packetforge-ng --udp -a [bssid] -h [smac] -k [ip[:port]] -l [ip[:port]] -w [file]"),
            ("Forge an ICMP packet", "packetforge-ng --icmp -a [bssid] -h [smac] -k [ip[:port]] -l [ip[:port]] -w [file]"),
            ("Build a null packet", "packetforge-ng --null -a [bssid] -h [smac] -w [file]"),
            ("Build a custom packet", "packetforge-ng --custom -r [file] -w [output file]"),
        ],
    },
}


def show_help():
    titles = [
        "Forge Options",
        "Source Options",
        "Modes",
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
    execute_logged_command(command, tool_name="Packetforge-ng", header="Packetforge-ng")


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Packetforge-ng Query\n")
    print("Packetforge-ng Command\n")
    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = PACKETFORGE_CATEGORIES.get(choice)
    if not category:
        print("Selected category is not available.")
        return
    show_category_commands(category)
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Packetforge-ng>Commands>").strip()
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


def main_packetforge_ng():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Packetforge-ng>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_packetforge_ng()
