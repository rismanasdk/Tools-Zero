# Install Tools

This project uses a Python wrapper in the `toolkit/` folder, but the main tool is a system application, not the `pip` module.

## Mapping folders to Ubuntu packages

- `toolkit/nmap` -> `nmap`
- `toolkit/aircrack-ng` -> `aircrack-ng`
- `toolkit/hydra` -> `hydra`
- `toolkit/johntheripper` -> `john`
- `toolkit/medusa` -> `medusa`
- `toolkit/nikto` -> `nikto`
- `toolkit/sqlmap` -> `sqlmap`
- `toolkit/dirbuster` -> `gobuster` as an alternative available on Ubuntu
- `toolkit/brutesuite` -> no matching official Ubuntu package

## How to install

Run:

```bash
bash scripts/install_tools.sh
```
