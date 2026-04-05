import re
import shlex
import shutil
import subprocess

from toolkit.nmap.help_commands import helps


NMAP_CATEGORIES = {
    "1": {
        "title": "Basic Scanning Techniques",
        "commands": [
            ("Scan a single target", "nmap [target]"),
            ("Scan multiple targets", "nmap [target1,target2,etc]"),
            ("Scan a list of targets", "nmap -iL [list.txt]"),
            ("Scan a range of hosts", "nmap [range of IP addresses]"),
            ("Scan an entire subnet", "nmap [IP address/cidr]"),
            ("Scan random hosts", "nmap -iR [number]"),
            ("Excluding targets from a scan", "nmap [targets] --exclude [targets]"),
            ("Excluding targets using a list", "nmap [targets] --excludefile [list.txt]"),
            ("Perform an aggressive scan", "nmap -A [target]"),
            ("Scan an IPv6 target", "nmap -6 [target]"),
        ],
    },
    "2": {
        "title": "Discovery Options",
        "commands": [
            ("Perform a ping scan only", "nmap -sP [target]"),
            ("Don't ping", "nmap -PN [target]"),
            ("TCP SYN Ping", "nmap -PS [target]"),
            ("TCP ACK ping", "nmap -PA [target]"),
            ("UDP ping", "nmap -PU [target]"),
            ("SCTP Init Ping", "nmap -PY [target]"),
            ("ICMP echo ping", "nmap -PE [target]"),
            ("ICMP Timestamp ping", "nmap -PP [target]"),
            ("ICMP address mask ping", "nmap -PM [target]"),
            ("IP protocol ping", "nmap -PO [target]"),
            ("ARP ping", "nmap -PR [target]"),
            ("Traceroute", "nmap --traceroute [target]"),
            ("Force reverse DNS resolution", "nmap -R [target]"),
            ("Disable reverse DNS resolution", "nmap -n [target]"),
            ("Alternative DNS lookup", "nmap --system-dns [target]"),
            ("Manually specify DNS servers", "nmap --dns-servers [servers] [target]"),
            ("Create a host list", "nmap -sL [targets]"),
        ],
    },
    "3": {
        "title": "Firewall Evasion Techniques",
        "commands": [
            ("Fragment packets", "nmap -f [target]"),
            ("Specify a specific MTU", "nmap --mtu [MTU] [target]"),
            ("Use a decoy", "nmap -D RND:[number] [target]"),
            ("Idle zombie scan", "nmap -sI [zombie] [target]"),
            ("Manually specify a source port", "nmap --source-port [port] [target]"),
            ("Append random data", "nmap --data-length [size] [target]"),
            ("Randomize target scan order", "nmap --randomize-hosts [target]"),
            ("Spoof MAC Address", "nmap --spoof-mac [MAC|0|vendor] [target]"),
            ("Send bad checksums", "nmap --badsum [target]"),
        ],
    },
    "4": {
        "title": "Version Detection",
        "commands": [
            ("Operating system detection", "nmap -O [target]"),
            ("Attempt to guess an unknown OS", "nmap -O --osscan-guess [target]"),
            ("Service version detection", "nmap -sV [target]"),
            ("Troubleshooting version scans", "nmap -sV --version-trace [target]"),
            ("Perform a RPC scan", "nmap -sR [target]"),
        ],
    },
    "5": {
        "title": "Output Options",
        "commands": [
            ("Save output to a text file", "nmap -oN [scan.txt] [target]"),
            ("Save output to a xml file", "nmap -oX [scan.xml] [target]"),
            ("Grepable output", "nmap -oG [scan.txt] [target]"),
            ("Output all supported file types", "nmap -oA [path/filename] [target]"),
            ("Periodically display statistics", "nmap --stats-every [time] [target]"),
            ("133t output", "nmap -oS [scan.txt] [target]"),
        ],
    },
    "6": {
        "title": "Scripting Engine",
        "commands": [
            ("Execute individual scripts", "nmap --script [script.nse] [target]"),
            ("Execute multiple scripts", "nmap --script [expression] [target]"),
            ("Execute scripts by category", "nmap --script [cat] [target]"),
            ("Execute multiple scripts categories", "nmap --script [cat1,cat2,etc]"),
            ("Troubleshoot scripts", "nmap --script [script] --script-trace [target]"),
            ("Update the script database", "nmap --script-updatedb"),
        ],
    },
    "7": {
        "title": "Combined Commands",
        "commands": [
            ("Performs stealth scans (SYN), detects operating systems, and displays more detailed (verbose) output for in-depth network audits.", "nmap -sS -O -v [target]"),
            ("Perform a UDP scan with OS detection", "nmap -sU -O [target]"),
            ("Perform a comprehensive scan", "nmap -sS -sU -A -T4 [target]"),
            ("Using the Nmap Scripting Engine (NSE) to detect specific vulnerabilities in detected services.", "nmap --script=vuln [target]"),
        ],
    }
}


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

    print("\nNmap Command")
    print(" ".join(command))
    print()

    result = subprocess.run(command, text=True, capture_output=True)

    if result.stdout:
        print(result.stdout)

    if result.stderr:
        print(result.stderr)


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Nmap Query\n")
    print("Nmap Command\n")

    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = NMAP_CATEGORIES.get(choice)
    if not category:
        print("Category selection is not yet available.")
        return

    show_category_commands(category)
    final = input("\nSelect-Options>Nmap>Commands>").strip()

    if not final.isdigit():
        print("Input command must be a number.")
        return

    index = int(final) - 1
    commands = category["commands"]

    if index < 0 or index >= len(commands):
        print("Selected command is not available.")
        return

    _, template = commands[index]
    command = build_command(template)
    if command:
        run_command(command)


def main_nmap():
    helps()
    select = input("\nSelect-Options>Nmap>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_nmap()
