import re
import shlex
import shutil
import subprocess


AIRGRAPH_COMMANDS = [
    ("Create CAPR graph", "airgraph-ng -i [input csv] -o [output png] -g CAPR"),
    ("Create CPG graph", "airgraph-ng -i [input csv] -o [output png] -g CPG"),
    (
        "Create CAPR graph and keep dot file",
        "airgraph-ng -i [input csv] -o [output png] -g CAPR -d",
    ),
    ("About", "airgraph-ng -a"),
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
        print(f"\nCommand '{command[0]}' cannot be found in the system.")
        print("Please install the original tool first, then try again.")
        return

    command[0] = binary_path
    print("\nAirgraph-ng Command")
    print(" ".join(command))
    print()

    result = subprocess.run(command, text=True, capture_output=True)
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr)


def main_airgraph_ng():
    print("\nAirgraph-ng Query\n")
    print("Airgraph-ng Command\n")
    for index, (label, template) in enumerate(AIRGRAPH_COMMANDS, start=1):
        print(f"{index}. {label}")
        print(template)
        print()

    select = input("\nSelect-Options>Aircrack-ng>Manage-File-Convert>Airgraph-ng>").strip()
    if not select.isdigit():
        print("Input command must be a number.")
        return

    index = int(select) - 1
    if index < 0 or index >= len(AIRGRAPH_COMMANDS):
        print("Selected command is not available.")
        return

    _, template = AIRGRAPH_COMMANDS[index]
    command = build_command(template)
    if command:
        run_command(command)


if __name__ == "__main__":
    main_airgraph_ng()
