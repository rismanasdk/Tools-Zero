import re
import shlex
import shutil
import subprocess


AIREPLAY_CATEGORIES = {
    "1": {
        "title": "Filter Options",
        "commands": [
            ("Set access point MAC address", "aireplay-ng -b [bssid] [replay interface]"),
            ("Set destination MAC address", "aireplay-ng -d [dmac] [replay interface]"),
            ("Set source MAC address", "aireplay-ng -s [smac] [replay interface]"),
            ("Set minimum packet length", "aireplay-ng -m [len] [replay interface]"),
            ("Set maximum packet length", "aireplay-ng -n [len] [replay interface]"),
            ("Set frame control type field", "aireplay-ng -u [type] [replay interface]"),
            ("Set frame control subtype field", "aireplay-ng -v [subt] [replay interface]"),
            ("Set To DS bit", "aireplay-ng -t [tods] [replay interface]"),
            ("Set From DS bit", "aireplay-ng -f [fromds] [replay interface]"),
            ("Set WEP bit", "aireplay-ng -w [iswep] [replay interface]"),
        ],
    },
    "2": {
        "title": "Replay Options",
        "commands": [
            ("Set packets per second", "aireplay-ng -x [nbpps] [replay interface]"),
            ("Set frame control word", "aireplay-ng -p [fctrl] [replay interface]"),
            ("Set access point MAC address", "aireplay-ng -a [bssid] [replay interface]"),
            ("Set destination MAC address", "aireplay-ng -c [dmac] [replay interface]"),
            ("Set source MAC address", "aireplay-ng -h [smac] [replay interface]"),
            (
                "Set target AP SSID for fakeauth or injection test",
                "aireplay-ng -e [essid] [replay interface]",
            ),
            ("Inject FromDS packets in ARP replay", "aireplay-ng -j [replay interface]"),
            ("Change ring buffer size", "aireplay-ng -g [value] [replay interface]"),
            ("Set destination IP in fragments", "aireplay-ng -k [IP] [replay interface]"),
            ("Set source IP in fragments", "aireplay-ng -l [IP] [replay interface]"),
            ("Set packets per burst", "aireplay-ng -o [npckts] [replay interface]"),
            ("Set keep-alive interval", "aireplay-ng -q [sec] [replay interface]"),
            ("Set keystream for shared key auth", "aireplay-ng -y [prga] [replay interface]"),
            ("Bit rate test", "aireplay-ng --bittest [replay interface]"),
            ("Disable AP detection", "aireplay-ng -D [replay interface]"),
            ("Choose first matching packet or fast test", "aireplay-ng --fast [replay interface]"),
            ("Disable /dev/rtc usage", "aireplay-ng -R [replay interface]"),
        ],
    },
    "3": {
        "title": "Source Options",
        "commands": [
            ("Capture packets from interface", "aireplay-ng [replay interface]"),
            ("Extract packets from pcap file", "aireplay-ng -r [file] [replay interface]"),
        ],
    },
    "4": {
        "title": "Attack Modes",
        "commands": [
            ("Deauthentication attack", "aireplay-ng --deauth [count] -a [bssid] [replay interface]"),
            ("Fake authentication attack", "aireplay-ng --fakeauth [delay] -a [bssid] -h [smac] [replay interface]"),
            ("Interactive packet replay", "aireplay-ng --interactive [replay interface]"),
            ("ARP request replay attack", "aireplay-ng --arpreplay -b [bssid] -h [smac] [replay interface]"),
            ("KoreK chopchop attack", "aireplay-ng --chopchop -b [bssid] [replay interface]"),
            ("Fragmentation attack", "aireplay-ng --fragment -b [bssid] -h [smac] [replay interface]"),
            ("Injection test", "aireplay-ng --test [replay interface]"),
        ],
    },
}


def show_help():
    titles = [
        "Filter Options",
        "Replay Options",
        "Source Options",
        "Attack Modes",
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
    binary_path = shutil.which(command[0])
    if not binary_path:
        print(f"\nCommand '{command[0]}' not found in the system.")
        print("Please install the tool first, then try again.")
        return

    command[0] = binary_path

    print("\nAireplay-ng Command")
    print(" ".join(command))
    print()

    result = subprocess.run(command, text=True, capture_output=True)

    if result.stdout:
        print(result.stdout)

    if result.stderr:
        print(result.stderr)


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Aireplay-ng Query\n")
    print("Aireplay-ng Command\n")

    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = AIREPLAY_CATEGORIES.get(choice)
    if not category:
        print("Selected category is not available.")
        return

    show_category_commands(category)
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>Commands>").strip()

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


def main_aireplay_ng():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Aireplay-ng>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_aireplay_ng()
