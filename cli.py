from banner import banner
from menu import menus
from pathlib import Path
import subprocess

BASE_DIR = Path(__file__).resolve().parent

def run_nmap_main():
    script = BASE_DIR / "toolkit" / "nmap" / "main_nmap.sh"
    subprocess.run(["bash", str(script)], check=False)

def run_aircrack_main():
    script = BASE_DIR / "toolkit" / "aircrack-ng" / "main_aircrack_ng.sh"
    subprocess.run(["bash", str(script)], check=False)

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

def run_tcp_relay_main():
    script = BASE_DIR / "toolkit" / "tcp-relay" / "main_tcp_relay.sh"
    subprocess.run(["bash", str(script)], check=False)

def run_c_utils_main():
    script = BASE_DIR / "toolkit" / "c-utils" / "main_c_utils.sh"
    subprocess.run(["bash", str(script)], check=False)

def main():
    actions = {
        "1": run_nmap_main,
        "2": run_aircrack_main,
        "3": run_hydra_main,
        "4": run_john_main,
        "5": run_medusa_main,
        "6": run_gobuster_main,
        "7": run_nikto_main,
        "8": run_sqlmap_main,
        "9": run_tcp_relay_main,
        "10": run_c_utils_main,
        "11": lambda: None,
        "q": lambda: None,
        "quit": lambda: None,
        "exit": lambda: None,
    }

    while True:
        print(banner)
        menus()
        try:
            select = input("\nSelect-Options>").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print("\nExiting Tools Zero.")
            return

        if select in {"11", "q", "quit", "exit"}:
            print("Exiting Tools Zero.")
            return

        action = actions.get(select)
        if action is None:
            print("Selected option is not available.")
            continue

        action()
