import re
import shlex
import shutil
import subprocess


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
    binary_path = shutil.which(command[0])
    if not binary_path:
        print(f"\nCommand '{command[0]}' cannot be found in the system.")
        print("Please install the original tool first, then try again.")
        return

    command[0] = binary_path
    print("\nWpaclean Command")
    print(" ".join(command))
    print()

    result = subprocess.run(command, text=True, capture_output=True)
    if result.stdout:
        print(result.stdout)
    if result.stderr:
        print(result.stderr)


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
