import sys
from pathlib import Path

for parent in Path(__file__).resolve().parents:
    if (parent / "runtime_utils.py").exists():
        sys.path.insert(0, str(parent))
        break

from runtime_utils import load_module


BASE_DIR = Path(__file__).resolve().parent


def main_manage_file_convert():
    while True:
        help_module = load_module(BASE_DIR / "help_commands.py", "aircrack_manage_help")
        help_module.helps()
        print("b. Back")
        print("q. Quit")
        select = input("\nSelect-Options>Aircrack-ng>Manage-File-Convert>").strip().lower()

        if select == "1":
            module = load_module(
                BASE_DIR / "airgraph-ng" / "main_airgraph_ng.py",
                "airgraph_main",
            )
            module.main_airgraph_ng()
        elif select == "2":
            module = load_module(
                BASE_DIR / "airolib-ng" / "main_airolib_ng.py",
                "airolib_main",
            )
            module.main_airolib_ng()
        elif select == "3":
            module = load_module(
                BASE_DIR / "wpaclean" / "main_wpaclean.py",
                "wpaclean_main",
            )
            module.main_wpaclean()
        elif select == "b":
            return
        elif select == "q":
            raise SystemExit(0)
        else:
            print("Category selection is not yet available.")
        print()


if __name__ == "__main__":
    main_manage_file_convert()
