"""Aircrack-ng Report Generator - Create professional penetration test reports"""

import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any, Optional


class ReportGenerator:
    """Generate aircrack-ng penetration test reports"""
    
    def __init__(self, report_dir="./toolkit/aircrack-ng/reports"):
        """Initialize report generator
        
        Args:
            report_dir (str): Directory to store reports
        """
        self.report_dir = Path(report_dir)
        self.report_dir.mkdir(parents=True, exist_ok=True)
    
    def create_html_report(self, sessions: List[Dict[str, Any]], 
                          output_file: str = None, title: str = "Wireless Security Assessment") -> str:
        """Create HTML report from sessions
        
        Args:
            sessions (List): List of session dictionaries
            output_file (str): Optional output file path
            title (str): Report title
            
        Returns:
            HTML string
        """
        report_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }}
        
        .container {{
            max-width: 900px;
            margin: 40px auto;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 20px;
            text-align: center;
        }}
        
        .header h1 {{
            font-size: 2.5em;
            margin-bottom: 10px;
        }}
        
        .header p {{
            font-size: 0.95em;
            opacity: 0.95;
        }}
        
        .content {{
            padding: 40px;
        }}
        
        .section {{
            margin-bottom: 30px;
        }}
        
        .section h2 {{
            color: #667eea;
            border-bottom: 2px solid #667eea;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }}
        
        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }}
        
        th {{
            background-color: #667eea;
            color: white;
            padding: 12px;
            text-align: left;
            font-weight: 600;
        }}
        
        td {{
            padding: 10px 12px;
            border-bottom: 1px solid #ddd;
        }}
        
        tr:hover {{
            background-color: #f9f9f9;
        }}
        
        .status-success {{
            color: #28a745;
            font-weight: bold;
        }}
        
        .status-warning {{
            color: #ffc107;
            font-weight: bold;
        }}
        
        .status-danger {{
            color: #dc3545;
            font-weight: bold;
        }}
        
        .status-info {{
            color: #17a2b8;
            font-weight: bold;
        }}
        
        .stat-box {{
            display: inline-block;
            background-color: #f0f0f0;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            margin: 10px 10px 10px 0;
            border-radius: 4px;
        }}
        
        .stat-box .number {{
            font-size: 1.8em;
            font-weight: bold;
            color: #667eea;
        }}
        
        .stat-box .label {{
            font-size: 0.9em;
            color: #666;
        }}
        
        .footer {{
            background-color: #f9f9f9;
            padding: 20px;
            text-align: center;
            font-size: 0.85em;
            color: #666;
            border-top: 1px solid #ddd;
        }}
        
        .note {{
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 12px;
            margin-top: 15px;
            border-radius: 4px;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>{title}</h1>
            <p>Generated: {report_date}</p>
        </div>
        
        <div class="content">
            <div class="section">
                <h2>Executive Summary</h2>
                <p>This report documents the results of the wireless security assessment, including network discovery,
                   vulnerability identification, and exploitation attempts.</p>
                
                <div>
                    <div class="stat-box">
                        <div class="number">{len(sessions)}</div>
                        <div class="label">Networks Tested</div>
                    </div>
                    <div class="stat-box">
                        <div class="number">{sum(1 for s in sessions if s.get('attack_info', {}).get('handshake_captured'))}</div>
                        <div class="label">Handshakes Captured</div>
                    </div>
                    <div class="stat-box">
                        <div class="number">{sum(s.get('statistics', {}).get('packets_captured', 0) for s in sessions)}</div>
                        <div class="label">Total Packets</div>
                    </div>
                </div>
            </div>
            
            <div class="section">
                <h2>Assessed Networks</h2>
                <table>
                    <tr>
                        <th>Network Name (SSID)</th>
                        <th>BSSID</th>
                        <th>Channel</th>
                        <th>Encryption</th>
                        <th>Handshake Status</th>
                        <th>Packets Captured</th>
                    </tr>
"""
        
        for session in sessions:
            network = session.get('network', {})
            attack_info = session.get('attack_info', {})
            stats = session.get('statistics', {})
            
            handshake_status = '<span class="status-success">✓ Captured</span>' if attack_info.get('handshake_captured') else '<span class="status-danger">✗ Not Captured</span>'
            
            html += f"""                    <tr>
                        <td>{network.get('ssid', 'Unknown')}</td>
                        <td>{network.get('bssid', 'Unknown')}</td>
                        <td>{network.get('channel', 'Unknown')}</td>
                        <td>{network.get('encryption', 'Unknown')}</td>
                        <td>{handshake_status}</td>
                        <td>{stats.get('packets_captured', 0)}</td>
                    </tr>
"""
        
        html += """                </table>
            </div>
            
            <div class="section">
                <h2>Detailed Session Information</h2>
"""
        
        for session in sessions:
            network = session.get('network', {})
            attack_info = session.get('attack_info', {})
            stats = session.get('statistics', {})
            
            html += f"""                <div class="note">
                    <strong>Session: {session.get('name', 'Unknown')}</strong> ({session.get('timestamp', 'Unknown')})<br>
                    <strong>Network:</strong> {network.get('ssid')} ({network.get('bssid')})<br>
                    <strong>Channel:</strong> {network.get('channel')} | 
                    <strong>Encryption:</strong> {network.get('encryption')}<br>
                    <strong>Attack Type:</strong> {attack_info.get('type')} | 
                    <strong>Status:</strong> {attack_info.get('status')}<br>
                    <strong>Packets:</strong> {stats.get('packets_captured')} | 
                    <strong>IVs:</strong> {stats.get('ives_collected')} |
                    <strong>Attempts:</strong> {stats.get('attempts')}
                </div>
"""
        
        html += """            </div>
            
            <div class="section">
                <h2>Recommendations</h2>
                <ul>
                    <li>Update to WPA3 encryption where possible for stronger security</li>
                    <li>Use strong, randomly generated WiFi passwords (20+ characters)</li>
                    <li>Disable WPS (WiFi Protected Setup) on access points</li>
                    <li>Regularly update router firmware</li>
                    <li>Monitor for rogue access points</li>
                    <li>Implement MAC address filtering if applicable</li>
                    <li>Use VPN for sensitive wireless connections</li>
                </ul>
            </div>
        </div>
        
        <div class="footer">
            <p>This report was generated by Tools Zero Aircrack-ng Module</p>
            <p>&copy; 2024 - Confidential</p>
        </div>
    </div>
</body>
</html>
"""
        
        if output_file:
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, 'w') as f:
                f.write(html)
            return str(output_path)
        
        return html
    
    def create_json_report(self, sessions: List[Dict[str, Any]], 
                          output_file: str = None) -> str:
        """Create JSON report from sessions
        
        Args:
            sessions (List): List of session dictionaries
            output_file (str): Optional output file path
            
        Returns:
            JSON string
        """
        report = {
            'metadata': {
                'generated_at': datetime.now().isoformat(),
                'total_networks': len(sessions),
                'total_packets': sum(s.get('statistics', {}).get('packets_captured', 0) for s in sessions),
                'handshakes_captured': sum(1 for s in sessions if s.get('attack_info', {}).get('handshake_captured'))
            },
            'sessions': sessions
        }
        
        json_str = json.dumps(report, indent=2, default=str)
        
        if output_file:
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, 'w') as f:
                f.write(json_str)
            return str(output_path)
        
        return json_str
    
    def create_csv_report(self, sessions: List[Dict[str, Any]], 
                         output_file: str = None) -> str:
        """Create CSV report from sessions
        
        Args:
            sessions (List): List of session dictionaries
            output_file (str): Optional output file path
            
        Returns:
            CSV string
        """
        csv_lines = ["Network Name,BSSID,Channel,Encryption,Handshake,Packets,IVs,Attempts,Status"]
        
        for session in sessions:
            network = session.get('network', {})
            attack_info = session.get('attack_info', {})
            stats = session.get('statistics', {})
            
            handshake = "Yes" if attack_info.get('handshake_captured') else "No"
            
            csv_lines.append(f"""{network.get('ssid', '')},{network.get('bssid', '')},{network.get('channel', '')},{network.get('encryption', '')},{handshake},{stats.get('packets_captured', 0)},{stats.get('ives_collected', 0)},{stats.get('attempts', 0)},{attack_info.get('status', '')}""")
        
        csv_str = "\n".join(csv_lines)
        
        if output_file:
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            with open(output_path, 'w') as f:
                f.write(csv_str)
            return str(output_path)
        
        return csv_str


# Convenience functions
def create_report_generator(report_dir="./toolkit/aircrack-ng/reports"):
    """Create report generator
    
    Usage:
        from toolkit.aircrack_ng.reports.generator import create_report_generator
        
        rg = create_report_generator()
        html_path = rg.create_html_report(sessions, output_file="report.html")
    """
    return ReportGenerator(report_dir)
