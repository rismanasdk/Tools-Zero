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


WPACLEAN_COMMANDS = [
    ("Clean capture files", "wpaclean [out.cap] [in.cap] [in2.cap]"),
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
    execute_logged_command(
        command,
        tool_name="Wpaclean",
        header="Wpaclean",
        missing_tool_message="Please install the original tool first, then try again.",
    )


def main_wpaclean():
    print("\nWpaclean Query\n")
    print("Wpaclean Command\n")
    for index, (label, template) in enumerate(WPACLEAN_COMMANDS, start=1):
        print(f"{index}. {label}")
        print(template)
        print()

    select = input("\nSelect-Options>Aircrack-ng>Manage-File-Convert>Wpaclean>").strip()
    if select != "1":
        print("Selected command is not available.")
        return

    _, template = WPACLEAN_COMMANDS[0]
    command = build_command(template)
    if command:
        run_command(command)


if __name__ == "__main__":
    main_wpaclean()
