def menus():
    menu = ["Nmap", "Aircrack-ng", "Hydra", "JohnTheRipper", "Medusa", "BruteSuite", "Gobuster", "Nikto", "Sqlmap"]
    colomn = 3
    line = (len(menu) + colomn - 1) // colomn

    per_colomn = []
    for i in range(colomn):
        col_data = []
        for j in range(i * line, (i + 1) * line):
            if j < len(menu):
                col_data.append(f"{j+1}. {menu[j]}")
            else:
                col_data.append("")
        per_colomn.append(col_data)

    width_colomn = [max(len(item) for item in col) for col in per_colomn]

    for i in range(line):
        line_teks = ""
        for j in range(colomn):
            line_teks += f"{per_colomn[j][i]:<{width_colomn[j]+2}}"
        print(line_teks)
