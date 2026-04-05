from banner import banner
from menu import menus
import importlib.util
from pathlib import Path
import subprocess

from toolkit.nmap.main_nmap import main_nmap


BASE_DIR = Path(__file__).resolve().parent


def load_aircrack_main():
    module_path = BASE_DIR / "toolkit" / "aircrack-ng" / "main_aircrack_ng.py"
    spec = importlib.util.spec_from_file_location("aircrack_main", module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.main_aircrack_ng


def run_hydra_main():
    script = BASE_DIR / "toolkit" / "hydra" / "main_hydra.sh"
    subprocess.run(["bash", str(script)], check=False)


def run_john_main():
    script = BASE_DIR / "toolkit" / "johntheripper" / "main_john.sh"
    subprocess.run(["bash", str(script)], check=False)


def run_medusa_main():
    script = BASE_DIR / "toolkit" / "medusa" / "main_medusa.sh"
    subprocess.run(["bash", str(script)], check=False)


def run_gobuster_main():
    script = BASE_DIR / "toolkit" / "gobuster" / "main_gobuster.sh"
    subprocess.run(["bash", str(script)], check=False)


def run_nikto_main():
    script = BASE_DIR / "toolkit" / "nikto" / "main_nikto.sh"
    subprocess.run(["bash", str(script)], check=False)


def run_sqlmap_main():
    script = BASE_DIR / "toolkit" / "sqlmap" / "main_sqlmap.sh"
    subprocess.run(["bash", str(script)], check=False)


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
        elif select == "3":
            run_hydra_main()
        elif select == "4":
            run_john_main()
        elif select == "5":
            run_medusa_main()
        elif select == "7":
            run_gobuster_main()
        elif select == "8":
            run_nikto_main()
        elif select == "9":
            run_sqlmap_main()
