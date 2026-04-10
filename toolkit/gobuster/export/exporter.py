"""Gobuster result exporters for multiple formats"""

import json
import csv
from pathlib import Path
from typing import List, Dict, Any, Optional
from datetime import datetime


class GobusterExporter:
    """Export gobuster results to various formats"""
    
    def __init__(self, gobuster_output_file: Optional[str] = None):
        """Initialize exporter
        
        Args:
            gobuster_output_file (str): Path to gobuster output file (if parsing existing results)
        """
        self.results = []
        self.output_file = gobuster_output_file
        self.metadata = {
            'generated_at': datetime.now().isoformat(),
            'total_results': 0,
            'status_codes': {}
        }
    
    def add_result(self, url: str, status_code: int, size: int = None, 
                   lines: int = None, words: int = None, headers: Dict = None):
        """Add a result to the export collection
        
        Args:
            url (str): Full URL found
            status_code (int): HTTP status code
            size (int): Response size in bytes
            lines (int): Response lines
            words (int): Response words
            headers (Dict): Response headers
        """
        result = {
            'url': url,
            'status_code': status_code,
            'size': size,
            'lines': lines,
            'words': words,
            'headers': headers or {}
        }
        
        self.results.append(result)
        self.metadata['total_results'] += 1
        self.metadata['status_codes'][str(status_code)] = self.metadata['status_codes'].get(str(status_code), 0) + 1
    
    def add_results_from_list(self, results: List[Dict]):
        """Add multiple results at once
        
        Args:
            results (List): List of result dictionaries
        """
        for result in results:
            self.add_result(
                url=result.get('url'),
                status_code=result.get('status_code'),
                size=result.get('size'),
                lines=result.get('lines'),
                words=result.get('words'),
                headers=result.get('headers')
            )
    
    def parse_gobuster_output(self, output_text: str):
        """Parse gobuster text output
        
        Args:
            output_text (str): Raw gobuster output
        """
        lines = output_text.strip().split('\n')
        for line in lines:
            line = line.strip()
            if not line or line.startswith('==='):
                continue
            
            # Parse format: /path (Status: 200, Size: 1234, Words: 56, Lines: 7)
            try:
                parts = line.split('(Status:')
                if len(parts) >= 2:
                    url = parts[0].strip()
                    status_part = parts[1]
                    
                    status_code = int(status_part.split(',')[0])
                    
                    size = None
                    if 'Size:' in status_part:
                        size = int(status_part.split('Size:')[1].split(',')[0].strip())
                    
                    self.add_result(url, status_code, size)
            except (IndexError, ValueError):
                continue
    
    def to_json(self, output_file: Optional[str] = None, pretty: bool = True) -> str:
        """Export results to JSON format
        
        Args:
            output_file (str): Optional file path to write to
            pretty (bool): Pretty print JSON
            
        Returns:
            JSON string
        """
        export_data = {
            'metadata': self.metadata,
            'results': self.results
        }
        
        if pretty:
            json_str = json.dumps(export_data, indent=2)
        else:
            json_str = json.dumps(export_data)
        
        if output_file:
            Path(output_file).write_text(json_str)
        
        return json_str
    
    def to_csv(self, output_file: str) -> None:
        """Export results to CSV format
        
        Args:
            output_file (str): File path to write to
        """
        with open(output_file, 'w', newline='') as f:
            fieldnames = ['url', 'status_code', 'size', 'lines', 'words']
            writer = csv.DictWriter(f, fieldnames=fieldnames)
            writer.writeheader()
            
            for result in self.results:
                writer.writerow({
                    'url': result['url'],
                    'status_code': result['status_code'],
                    'size': result['size'],
                    'lines': result['lines'],
                    'words': result['words']
                })
    
    def to_html(self, output_file: str, title: str = "Gobuster Results") -> str:
        """Export results to HTML format
        
        Args:
            output_file (str): File path to write to
            title (str): HTML page title
            
        Returns:
            HTML string
        """
        # Categorize by status code
        status_200 = [r for r in self.results if r['status_code'] == 200]
        status_301 = [r for r in self.results if r['status_code'] == 301]
        status_302 = [r for r in self.results if r['status_code'] == 302]
        status_403 = [r for r in self.results if r['status_code'] == 403]
        status_404 = [r for r in self.results if r['status_code'] == 404]
        status_other = [r for r in self.results if r['status_code'] not in [200, 301, 302, 403, 404]]
        
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
            font-family: 'Segoe UI', Tahoma, Geneva, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 40px auto;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }}
        
        .header {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }}
        
        .header h1 {{
            font-size: 2em;
            margin-bottom: 10px;
        }}
        
        .header p {{
            font-size: 0.95em;
            opacity: 0.9;
        }}
        
        .content {{
            padding: 30px;
        }}
        
        .stats {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }}
        
        .stat-box {{
            background: #f9f9f9;
            border-left: 4px solid #667eea;
            padding: 20px;
            border-radius: 4px;
        }}
        
        .stat-box .number {{
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }}
        
        .stat-box .label {{
            color: #666;
            font-size: 0.9em;
            margin-top: 5px;
        }}
        
        .section {{
            margin-bottom: 40px;
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
            word-break: break-all;
        }}
        
        tr:hover {{
            background-color: #f9f9f9;
        }}
        
        .status-200 {{ color: #28a745; font-weight: bold; }}
        .status-301 {{ color: #17a2b8; font-weight: bold; }}
        .status-302 {{ color: #17a2b8; font-weight: bold; }}
        .status-403 {{ color: #ffc107; font-weight: bold; }}
        .status-404 {{ color: #dc3545; font-weight: bold; }}
        
        .footer {{
            background: #f9f9f9;
            padding: 20px;
            text-align: center;
            font-size: 0.85em;
            color: #666;
            border-top: 1px solid #ddd;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>{title}</h1>
            <p>Generated: {self.metadata['generated_at']}</p>
        </div>
        
        <div class="content">
            <div class="stats">
                <div class="stat-box">
                    <div class="number">{len(self.results)}</div>
                    <div class="label">Total Results</div>
                </div>
                <div class="stat-box">
                    <div class="number">{len(status_200)}</div>
                    <div class="label">Status 200 OK</div>
                </div>
                <div class="stat-box">
                    <div class="number">{len(status_403)}</div>
                    <div class="label">Status 403 Forbidden</div>
                </div>
                <div class="stat-box">
                    <div class="number">{len(status_301 + status_302)}</div>
                    <div class="label">Redirects</div>
                </div>
            </div>
"""
        
        # Add tables for each status
        for status, results_list, heading in [
            (200, status_200, "Status 200 - OK"),
            (301, status_301, "Status 301 - Moved Permanently"),
            (302, status_302, "Status 302 - Found"),
            (403, status_403, "Status 403 - Forbidden"),
            (404, status_404, "Status 404 - Not Found"),
            (None, status_other, "Other Status Codes")
        ]:
            if results_list:
                html += f"""            <div class="section">
                <h2>{heading}</h2>
                <table>
                    <tr>
                        <th>URL</th>
                        <th>Status</th>
                        <th>Size</th>
                        <th>Lines</th>
                        <th>Words</th>
                    </tr>
"""
                
                for result in results_list:
                    status_class = f"status-{result['status_code']}"
                    html += f"""                    <tr>
                        <td>{result['url']}</td>
                        <td class="{status_class}">{result['status_code']}</td>
                        <td>{result['size'] or 'N/A'}</td>
                        <td>{result['lines'] or 'N/A'}</td>
                        <td>{result['words'] or 'N/A'}</td>
                    </tr>
"""
                
                html += """                </table>
            </div>
"""
        
        html += """        </div>
        
        <div class="footer">
            <p>Report generated by Tools Zero Gobuster Module</p>
        </div>
    </div>
</body>
</html>
"""
        
        Path(output_file).write_text(html)
        return html
    
    def to_text(self, output_file: Optional[str] = None) -> str:
        """Export results to plain text format
        
        Args:
            output_file (str): Optional file path
            
        Returns:
            Text string
        """
        lines = [
            "=" * 80,
            "GOBUSTER RESULTS REPORT",
            "=" * 80,
            f"Generated: {self.metadata['generated_at']}",
            f"Total Results: {self.metadata['total_results']}",
            f"Status Codes Found: {dict(self.metadata['status_codes'])}",
            "",
            "-" * 80,
            "Results:",
            "-" * 80,
        ]
        
        for result in self.results:
            lines.append(f"URL: {result['url']}")
            lines.append(f"  Status: {result['status_code']}")
            if result['size']:
                lines.append(f"  Size: {result['size']} bytes")
            if result['lines']:
                lines.append(f"  Lines: {result['lines']}")
            if result['words']:
                lines.append(f"  Words: {result['words']}")
            lines.append("")
        
        text = "\n".join(lines)
        
        if output_file:
            Path(output_file).write_text(text)
        
        return text


# Convenience function
def create_exporter() -> GobusterExporter:
    """Create gobuster exporter instance
    
    Usage:
        from toolkit.gobuster.export.exporter import create_exporter
        
        exporter = create_exporter()
        exporter.add_result('/admin', 200, size=1024)
        exporter.add_result('/api/v1', 403)
        exporter.to_html('results.html')
        exporter.to_json('results.json')
        exporter.to_csv('results.csv')
    """
    return GobusterExporter()
