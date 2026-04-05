import re
import shlex
import shutil
import subprocess


AIRCRACK_CATEGORIES = {
    "1": {
        "title": "Common Options",
        "commands": [
            ("Force attack mode", "aircrack-ng -a [amode] [capture file(s)]"),
            ("Use ESSID for target selection", "aircrack-ng -e [essid] [capture file(s)]"),
            ("Select target by BSSID", "aircrack-ng -b [bssid] [capture file(s)]"),
            ("Set number of CPUs to use", "aircrack-ng -p [nbcpu] [capture file(s)]"),
            ("Enable quiet mode", "aircrack-ng -q [capture file(s)]"),
            ("Combine APs into a virtual one", "aircrack-ng -C [MACs] [capture file(s)]"),
            ("Log found key to file", "aircrack-ng -l [file name] [capture file(s)]"),
        ],
    },
    "2": {
        "title": "Static WEP Cracking Options",
        "commands": [
            ("Restrict search to alphanumeric characters", "aircrack-ng -c [capture file(s)]"),
            ("Restrict search to BCD hex characters", "aircrack-ng -t [capture file(s)]"),
            ("Restrict search to numeric characters", "aircrack-ng -h [capture file(s)]"),
            ("Set beginning of WEP key", "aircrack-ng -d [start] [capture file(s)]"),
            ("Filter WEP data packets by MAC", "aircrack-ng -m [maddr] [capture file(s)]"),
            ("Specify WEP key length", "aircrack-ng -n [nbits] [capture file(s)]"),
            ("Keep only IVs with selected key index", "aircrack-ng -i [index] [capture file(s)]"),
            ("Set fudge factor", "aircrack-ng -f [fudge] [capture file(s)]"),
            ("Disable selected Korek attack", "aircrack-ng -k [korek] [capture file(s)]"),
            ("Disable last keybytes bruteforce", "aircrack-ng -x [capture file(s)]"),
            ("Enable last keybyte bruteforce", "aircrack-ng -x1 [capture file(s)]"),
            ("Enable last two keybytes bruteforce", "aircrack-ng -x2 [capture file(s)]"),
            ("Disable bruteforce multithreading", "aircrack-ng -X [capture file(s)]"),
            ("Show key in ASCII while cracking", "aircrack-ng -s [capture file(s)]"),
            ("Run experimental single bruteforce attack", "aircrack-ng -y [capture file(s)]"),
            ("Use PTW WEP cracking method", "aircrack-ng -z [capture file(s)]"),
            ("Use PTW debug mode", "aircrack-ng -P [number] [capture file(s)]"),
            ("Use Korek WEP cracking method", "aircrack-ng -K [capture file(s)]"),
            ("Run in WEP decloak mode", "aircrack-ng -D [capture file(s)]"),
            ("Run only one PTW try", "aircrack-ng -1 [capture file(s)]"),
            ("Set maximum IVs to use", "aircrack-ng -M [number] [capture file(s)]"),
            ("Run in visual inspection mode", "aircrack-ng -V [capture file(s)]"),
        ],
    },
    "3": {
        "title": "WEP And WPA-PSK Cracking Options",
        "commands": [
            ("Use one or more wordlists", "aircrack-ng -w [words] [capture file(s)]"),
            ("Create a new cracking session", "aircrack-ng -N [file] [capture file(s)]"),
            ("Restore a cracking session", "aircrack-ng -R [file]"),
        ],
    },
    "4": {
        "title": "WPA-PSK Options",
        "commands": [
            ("Create EWSA project file", "aircrack-ng -E [file] [capture file(s)]"),
            ("Create Hashcat HCCAPX file", "aircrack-ng -j [file] [capture file(s)]"),
            ("Create Hashcat capture file", "aircrack-ng -J [file] [capture file(s)]"),
            ("Run WPA cracking speed test", "aircrack-ng -S"),
            ("Set WPA speed test duration", "aircrack-ng -Z [sec]"),
            ("Use airolib-ng database", "aircrack-ng -r [database] [capture file(s)]"),
        ],
    },
    "5": {
        "title": "SIMD Selection",
        "commands": [
            ("Use selected SIMD optimization", "aircrack-ng --simd [optimization] [capture file(s)]"),
            ("Show available SIMD optimizations", "aircrack-ng --simd-list"),
        ],
    },
}


def show_help():
    titles = [
        "Common Options",
        "Static WEP Cracking Options",
        "WEP And WPA-PSK Cracking Options",
        "WPA-PSK Options",
        "SIMD Selection",
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

    print("\nAircrack-ng Command")
    print(" ".join(command))
    print()

    result = subprocess.run(command, text=True, capture_output=True)

    if result.stdout:
        print(result.stdout)

    if result.stderr:
        print(result.stderr)


def show_category_commands(category):
    print(f"\n{category['title']}\n")
    print("Aircrack-ng Query\n")
    print("Aircrack-ng Command\n")

    for index, (label, template) in enumerate(category["commands"], start=1):
        print(f"{index}. {label}")
        print(template)
        print()


def handle_category(choice):
    category = AIRCRACK_CATEGORIES.get(choice)
    if not category:
        print("Selected category is not available.")
        return

    show_category_commands(category)
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>Commands>").strip()

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


def main_aircrack_tool():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Aircrack-ng>").strip()
    handle_category(select)


if __name__ == "__main__":
    main_aircrack_tool()
