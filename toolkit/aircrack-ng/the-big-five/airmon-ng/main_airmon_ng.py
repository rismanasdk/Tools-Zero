import os
import shutil
import subprocess


def show_help():
    items = [
        "Start monitor mode",
        "Stop monitor mode",
        "Check interfering processes",
        "Check and kill interfering processes",
        "Verbose mode",
        "Debug mode",
        "Elite mode",
    ]
    for index, item in enumerate(items, start=1):
        print(f"{index}. {item}")


def run_command(command):
    binary_path = shutil.which(command[0])
    if not binary_path:
        print(f"\nCommand '{command[0]}' cannot be found in the system.")
        print("Please install the original tool first, then try again.")
        return

    command[0] = binary_path

    print("\nAirmon-ng Command")
    print(" ".join(command))
    print()

    if os.geteuid() != 0:
        print("Airmon-ng usually needs to be run as root or via sudo.")

    result = subprocess.run(command, text=True, capture_output=True)

    if result.stdout:
        print(result.stdout)

    if result.stderr:
        print(result.stderr)


def main_airmon_ng():
    show_help()
    select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>Airmon-ng>").strip()

    if select == "1":
        iface = input("Input interface> ").strip()
        channel = input("Input channel (optional, enter to skip)> ").strip()
        if not iface:
            print("Interface cannot be empty.")
            return
        command = ["airmon-ng", "start", iface]
        if channel:
            command.append(channel)
        run_command(command)
    elif select == "2":
        iface = input("Input interface> ").strip()
        if not iface:
            print("Interface cannot be empty.")
            return
        run_command(["airmon-ng", "stop", iface])
    elif select == "3":
        run_command(["airmon-ng", "check"])
    elif select == "4":
        run_command(["airmon-ng", "check", "kill"])
    elif select == "5":
        run_command(["airmon-ng", "--verbose"])
    elif select == "6":
        run_command(["airmon-ng", "--debug"])
    elif select == "7":
        run_command(["airmon-ng", "--elite"])
    else:
        print("Selected command is not available.")


if __name__ == "__main__":
    main_airmon_ng()
