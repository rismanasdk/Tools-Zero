from banner import banner
from menu import menus
import importlib.util
from pathlib import Path

from toolkit.nmap.main_nmap import main_nmap


BASE_DIR = Path(__file__).resolve().parent


def load_aircrack_main():
    module_path = BASE_DIR / "toolkit" / "aircrack-ng" / "main_aircrack_ng.py"
    spec = importlib.util.spec_from_file_location("aircrack_main", module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.main_aircrack_ng


def main():
    print(banner)
    menus()

    while True:

        select = input("\nSelect-Options>")

        if select == "1":
            main_nmap()
        elif select == "2":
            main_aircrack_ng = load_aircrack_main()
            main_aircrack_ng()
