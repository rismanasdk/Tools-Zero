import re
import shlex
import shutil
import subprocess
from runtime_utils import execute_logged_command


IVSTOOLS_COMMANDS = [
    ("Extract IVs from a pcap file", "ivstools --convert [pcap file] [ivs output file]"),
    ("Merge IVS files", "ivstools --merge [ivs file 1] [ivs file 2] [output file]"),
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
    execute_logged_command(command, tool_name="IvsTools", header="IvsTools")


def main_ivstools():
    print("\nIvsTools Query\n")
    print("IvsTools Command\n")
    for index, (label, template) in enumerate(IVSTOOLS_COMMANDS, start=1):
        print(f"{index}. {label}")
        print(template)
        print()
    select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>IvsTools>").strip()
    if not select.isdigit():
        print("Input command must be a number.")
        return
    index = int(select) - 1
    if index < 0 or index >= len(IVSTOOLS_COMMANDS):
        print("Selected command is not available.")
        return
    _, template = IVSTOOLS_COMMANDS[index]
    command = build_command(template)
    if command:
        run_command(command)


if __name__ == "__main__":
    main_ivstools()
