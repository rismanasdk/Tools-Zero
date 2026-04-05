import os
import shutil
import subprocess
from runtime_utils import execute_logged_command


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
    execute_logged_command(
        command,
        tool_name="Airmon-ng",
        header="Airmon-ng",
        warn_if_not_root=True,
        missing_tool_message="Please install the original tool first, then try again.",
    )


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
