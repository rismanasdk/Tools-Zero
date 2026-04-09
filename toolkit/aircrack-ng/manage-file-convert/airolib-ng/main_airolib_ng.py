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


AIROLIB_COMMANDS = [
    ("Show database stats", "airolib-ng [database] --stats"),
    ("Execute SQL statement", "airolib-ng [database] --sql [sql]"),
    ("Clean database", "airolib-ng [database] --clean"),
    ("Clean database deeply", "airolib-ng [database] --clean all"),
    ("Start batch processing", "airolib-ng [database] --batch"),
    ("Verify database", "airolib-ng [database] --verify"),
    ("Verify database deeply", "airolib-ng [database] --verify all"),
    ("Import ESSID list", "airolib-ng [database] --import essid [file]"),
    ("Import password list", "airolib-ng [database] --import passwd [file]"),
    ("Import cowpatty file", "airolib-ng [database] --import cowpatty [file]"),
    ("Export cowpatty file", "airolib-ng [database] --export cowpatty [essid] [file]"),
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
        tool_name="Airolib-ng",
        header="Airolib-ng",
        missing_tool_message="Please install the original tool first, then try again.",
    )


def main_airolib_ng():
    print("\nAirolib-ng Query\n")
    print("Airolib-ng Command\n")
    for index, (label, template) in enumerate(AIROLIB_COMMANDS, start=1):
        print(f"{index}. {label}")
        print(template)
        print()

    select = input("\nSelect-Options>Aircrack-ng>Manage-File-Convert>Airolib-ng>").strip()
    if not select.isdigit():
        print("Input command must be a number.")
        return

    index = int(select) - 1
    if index < 0 or index >= len(AIROLIB_COMMANDS):
        print("Selected command is not available.")
        return

    _, template = AIROLIB_COMMANDS[index]
    command = build_command(template)
    if command:
        run_command(command)


if __name__ == "__main__":
    main_airolib_ng()
