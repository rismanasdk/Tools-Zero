import importlib.util
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent


def load_module(module_path, module_name):
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main_manage_file_convert():
    help_module = load_module(BASE_DIR / "help_commands.py", "aircrack_manage_help")
    help_module.helps()
    select = input("\nSelect-Options>Aircrack-ng>Manage-File-Convert>").strip()

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
    else:
        print("Category selection is not yet available.")


if __name__ == "__main__":
    main_manage_file_convert()
