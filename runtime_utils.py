import importlib.util
import shlex
import shutil
import subprocess
from datetime import datetime
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent
LOG_DIR = Path.cwd() / "logs" if Path.cwd() == PROJECT_ROOT else PROJECT_ROOT / "logs"
HISTORY_FILE = LOG_DIR / "command_history.log"


def load_module(module_path, module_name):
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    if spec is None or spec.loader is None:
        raise ImportError(f"Unable to load module from {module_path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _slugify(name):
    parts = []
    current = []
    for char in name.lower():
        if char.isalnum():
            current.append(char)
        elif current:
            parts.append("".join(current))
            current = []
    if current:
        parts.append("".join(current))
    return "-".join(parts) or "tool"


def _ensure_log_dir(tool_name):
    tool_log_dir = LOG_DIR / _slugify(tool_name)
    tool_log_dir.mkdir(parents=True, exist_ok=True)
    return tool_log_dir


def _record_history(tool_name, status, command_text):
    LOG_DIR.mkdir(parents=True, exist_ok=True)
    with HISTORY_FILE.open("a", encoding="utf-8") as history:
        history.write(
            f"{datetime.now():%Y-%m-%d %H:%M:%S} | {tool_name} | exit={status} | {command_text}\n"
        )


def execute_logged_command(command, tool_name, header, warn_if_not_root=False, missing_tool_message=None):
    binary_path = shutil.which(command[0])
    if not binary_path:
        print(f"\nCommand '{command[0]}' not found in the system.")
        if missing_tool_message:
            print(missing_tool_message)
        else:
            print("Please install the tool first, then try again.")
        return 1

    command = command.copy()
    command[0] = binary_path

    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    log_file = _ensure_log_dir(tool_name) / f"{timestamp}.log"
    command_text = shlex.join(command)

    print(f"\n{header} Command")
    print(command_text)
    print()
    print(f"Output log: {log_file}")
    print()

    if warn_if_not_root:
        geteuid = getattr(__import__("os"), "geteuid", None)
        if callable(geteuid) and geteuid() != 0:
            print(f"{header} usually needs to be run as root or via sudo.")
            print()

    status = 0
    with log_file.open("w", encoding="utf-8") as output:
        process = subprocess.Popen(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        assert process.stdout is not None
        for line in process.stdout:
            print(line, end="")
            output.write(line)
        status = process.wait()

    _record_history(tool_name, status, command_text)

    if status != 0:
        print(f"\n{header} exited with status {status}.")

    return status
