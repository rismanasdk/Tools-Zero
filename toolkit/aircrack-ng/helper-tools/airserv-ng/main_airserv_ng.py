import re
import shlex
import shutil
import subprocess


AIRSERV_COMMANDS = [
    ("Show help screen", "airserv-ng -h"),
    ("Set TCP port to listen on", "airserv-ng -p [port]"),
    ("Set wifi interface to use", "airserv-ng -d [iface]"),
    ("Set channel to use", "airserv-ng -c [chan]"),
    ("Set debug level", "airserv-ng -v [level]"),
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
    binary_path = shutil.which(command[0])
    if not binary_path:
        print(f"\nCommand '{command[0]}' not found in the system.")
        print("Please install the tool first, then try again.")
        return
    command[0] = binary_path
    print("\nAirserv-ng Command")
    print(" ".join(command))
    print()
    result = subprocess.run(command, text=True, capture_output=True)
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr)


def main_airserv_ng():
    print("\nAirserv-ng Query\n")
    print("Airserv-ng Command\n")
    for index, (label, template) in enumerate(AIRSERV_COMMANDS, start=1):
        print(f"{index}. {label}")
        print(template)
        print()
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>Airserv-ng>").strip()
    if not select.isdigit():
        print("Input command must be a number.")
        return
    index = int(select) - 1
    if index < 0 or index >= len(AIRSERV_COMMANDS):
        print("Selected command is not available.")
        return
    _, template = AIRSERV_COMMANDS[index]
    command = build_command(template)
    if command:
        run_command(command)


if __name__ == "__main__":
    main_airserv_ng()
