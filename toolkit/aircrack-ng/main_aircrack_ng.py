import importlib.util
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent


def load_module(module_path, module_name):
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main_aircrack_ng():
    help_module = load_module(BASE_DIR / "help_commands.py", "aircrack_help")
    help_module.helps()
    select = input("\nSelect-Options>Aircrack-ng>").strip()

    if select == "1":
        big_five_help = load_module(
            BASE_DIR / "the-big-five" / "help_commands.py",
            "aircrack_big_five_help",
        )
        big_five_help.helps()

        sub_select = input("\nSelect-Options>Aircrack-ng>The-Big-Five>").strip()
        if sub_select == "1":
            module = load_module(
                BASE_DIR / "the-big-five" / "airodump-ng" /"main_airodump_ng.py",
                "aircrack_airodump_main",
            )
            module.main_airodump_ng()
        elif sub_select == "2":
            module = load_module(
                BASE_DIR / "the-big-five" / "aireplay-ng" / "main_aireplay_ng.py",
                "aircrack_aireplay_main",
            )
            module.main_aireplay_ng()
        elif sub_select == "3":
            module = load_module(
                BASE_DIR / "the-big-five" / "aircrack-ng" / "main_aircrack_tool.py",
                "aircrack_tool_main",
            )
            module.main_aircrack_tool()
        elif sub_select == "4":
            module = load_module(
                BASE_DIR / "the-big-five" / "airbase-ng" / "main_airbase_ng.py",
                "airbase_tool_main",
            )
            module.main_airbase_ng()
        else:
            print("Category selection is not yet available.")
    elif select == "2":
        helper_help = load_module(
            BASE_DIR / "helper-tools" / "help_commands.py",
            "aircrack_helper_help",
        )
        helper_help.helps()

        sub_select = input("\nSelect-Options>Aircrack-ng>Helper-Tools>").strip()
        if sub_select == "1":
            module = load_module(
                BASE_DIR / "helper-tools" / "airdecap-ng" / "main_airdecap_ng.py",
                "airdecap_tool_main",
            )
            module.main_airdecap_ng()
        elif sub_select == "2":
            module = load_module(
                BASE_DIR / "helper-tools" / "airserv-ng" / "main_airserv_ng.py",
                "airserv_tool_main",
            )
            module.main_airserv_ng()
        elif sub_select == "3":
            module = load_module(
                BASE_DIR / "helper-tools" / "airtun-ng" / "main_airtun_ng.py",
                "airtun_tool_main",
            )
            module.main_airtun_ng()
        elif sub_select == "4":
            module = load_module(
                BASE_DIR / "helper-tools" / "ivstools" / "main_ivstools.py",
                "ivstools_tool_main",
            )
            module.main_ivstools()
        elif sub_select == "5":
            module = load_module(
                BASE_DIR / "helper-tools" / "packetforge-ng" / "main_packetforge_ng.py",
                "packetforge_tool_main",
            )
            module.main_packetforge_ng()
        else:
            print("Category selection is not yet available.")
    else:
        print("Category selection is not yet available.")


if __name__ == "__main__":
    main_aircrack_ng()
