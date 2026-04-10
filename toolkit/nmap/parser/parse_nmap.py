"""Nmap XML output parser for Tools Zero"""

import xml.etree.ElementTree as ET
import json
import csv
from pathlib import Path
from typing import List, Dict, Any


class NmapParser:
    """Parser for nmap XML output"""
    
    def __init__(self, xml_file):
        """Initialize parser with nmap XML file
        
        Args:
            xml_file (str or Path): Path to nmap XML output file
        """
        self.xml_file = Path(xml_file)
        if not self.xml_file.exists():
            raise FileNotFoundError(f"Nmap XML file not found: {xml_file}")
        
        try:
            self.tree = ET.parse(self.xml_file)
            self.root = self.tree.getroot()
        except ET.ParseError as e:
            raise ValueError(f"Invalid XML file: {e}")
    
    def get_hosts_summary(self) -> List[Dict[str, Any]]:
        """Get summary of all hosts scanned
        
        Returns:
            List of host dictionaries with basic info
        """
        hosts = []
        for host_elem in self.root.findall('.//host'):
            status = host_elem.find('status').get('state')
            
            # Get IP
            ip_elem = host_elem.find('.//address[@addrtype="ipv4"]')
            if ip_elem is None:
                ip_elem = host_elem.find('.//address[@addrtype="ipv6"]')
            ip = ip_elem.get('addr') if ip_elem is not None else 'Unknown'
            
            # Get MAC
            mac_elem = host_elem.find('.//address[@addrtype="mac"]')
            mac = mac_elem.get('addr') if mac_elem is not None else 'Unknown'
            
            # Get hostname
            hostname = 'Unknown'
            hostname_elem = host_elem.find('.//hostname')
            if hostname_elem is not None:
                hostname = hostname_elem.get('name', 'Unknown')
            
            # Get OS
            os_info = 'Unknown'
            osmatch = host_elem.find('.//osmatch')
            if osmatch is not None:
                os_info = osmatch.get('name', 'Unknown')
            
            # Count open ports
            open_ports = len(host_elem.findall('.//port[state[@state="open"]]'))
            
            hosts.append({
                'ip': ip,
                'mac': mac,
                'hostname': hostname,
                'status': status,
                'os': os_info,
                'open_ports': open_ports
            })
        
        return hosts
    
    def get_host_details(self, ip: str) -> Dict[str, Any]:
        """Get detailed information for a specific host
        
        Args:
            ip (str): IP address to get details for
            
        Returns:
            Dictionary with comprehensive host details
        """
        for host_elem in self.root.findall('.//host'):
            ip_elem = host_elem.find('.//address[@addrtype="ipv4"]')
            if ip_elem is None:
                ip_elem = host_elem.find('.//address[@addrtype="ipv6"]')
            
            if ip_elem is not None and ip_elem.get('addr') == ip:
                return self._parse_host_element(host_elem)
        
        return {}
    
    def _parse_host_element(self, host_elem) -> Dict[str, Any]:
        """Parse individual host element"""
        # Basic info
        status = host_elem.find('status').get('state')
        
        ip_elem = host_elem.find('.//address[@addrtype="ipv4"]')
        if ip_elem is None:
            ip_elem = host_elem.find('.//address[@addrtype="ipv6"]')
        ip = ip_elem.get('addr') if ip_elem is not None else 'Unknown'
        
        mac_elem = host_elem.find('.//address[@addrtype="mac"]')
        mac = mac_elem.get('addr') if mac_elem is not None else 'Unknown'
        
        hostname = 'Unknown'
        hostname_elem = host_elem.find('.//hostname')
        if hostname_elem is not None:
            hostname = hostname_elem.get('name', 'Unknown')
        
        # Ports
        ports = []
        for port_elem in host_elem.findall('.//port'):
            port_num = port_elem.get('portid')
            protocol = port_elem.get('protocol')
            state_elem = port_elem.find('state')
            state = state_elem.get('state')
            
            service_elem = port_elem.find('service')
            service = 'Unknown'
            extrainfo = ''
            if service_elem is not None:
                service = service_elem.get('name', 'Unknown')
                extrainfo = service_elem.get('extrainfo', '')
            
            ports.append({
                'port': int(port_num),
                'protocol': protocol,
                'state': state,
                'service': service,
                'extrainfo': extrainfo
            })
        
        # Sort by port number
        ports.sort(key=lambda x: x['port'])
        
        # OS
        os_info = 'Unknown'
        osmatch = host_elem.find('.//osmatch')
        if osmatch is not None:
            os_info = osmatch.get('name', 'Unknown')
        
        return {
            'ip': ip,
            'mac': mac,
            'hostname': hostname,
            'status': status,
            'os': os_info,
            'ports': ports
        }
    
    def filter_by_port_state(self, state: str = 'open') -> List[Dict[str, Any]]:
        """Get ports filtered by state (open, closed, filtered)
        
        Args:
            state (str): Port state to filter by
            
        Returns:
            List of filtered ports
        """
        filtered_ports = []
        for host_elem in self.root.findall('.//host'):
            ip_elem = host_elem.find('.//address[@addrtype="ipv4"]')
            if ip_elem is None:
                ip_elem = host_elem.find('.//address[@addrtype="ipv6"]')
            ip = ip_elem.get('addr') if ip_elem is not None else 'Unknown'
            
            for port_elem in host_elem.findall(f'.//port[state[@state="{state}"]]'):
                port_num = port_elem.get('portid')
                service_elem = port_elem.find('service')
                service = service_elem.get('name') if service_elem is not None else 'Unknown'
                
                filtered_ports.append({
                    'ip': ip,
                    'port': int(port_num),
                    'service': service,
                    'state': state
                })
        
        return sorted(filtered_ports, key=lambda x: (x['ip'], x['port']))
    
    def to_dict(self) -> Dict[str, Any]:
        """Convert scan to dictionary
        
        Returns:
            Dictionary representation of the scan
        """
        return {
            'hosts': self.get_hosts_summary(),
            'scan_info': {
                'start_time': self.root.get('starttime', 'Unknown'),
                'end_time': self.root.get('endtime', 'Unknown'),
            }
        }
    
    def to_json(self, output_file: str = None) -> str:
        """Export scan to JSON format
        
        Args:
            output_file (str): Optional file to write JSON to
            
        Returns:
            JSON string
        """
        data = self.to_dict()
        json_str = json.dumps(data, indent=2)
        
        if output_file:
            Path(output_file).write_text(json_str)
        
        return json_str
    
    def to_csv(self, output_file: str = None) -> None:
        """Export scan to CSV format
        
        Args:
            output_file (str): File to write CSV to
        """
        if not output_file:
            raise ValueError("output_file parameter required for CSV export")
        
        ports_flattened = self.filter_by_port_state('open')
        
        with open(output_file, 'w', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=['ip', 'port', 'service', 'state'])
            writer.writeheader()
            writer.writerows(ports_flattened)
    
    def to_html(self, output_file: str = None) -> str:
        """Export scan to HTML format
        
        Args:
            output_file (str): Optional file to write HTML to
            
        Returns:
            HTML string
        """
        hosts = self.get_hosts_summary()
        
        html = """<!DOCTYPE html>
<html>
<head>
    <title>Nmap Scan Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .status-up { color: green; font-weight: bold; }
        .status-down { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>Nmap Scan Report</h1>
"""
        
        html += f"""    <p>
        <strong>Scan Start:</strong> {self.root.get('starttime', 'Unknown')}<br>
        <strong>Scan End:</strong> {self.root.get('endtime', 'Unknown')}<br>
        <strong>Total Hosts:</strong> {len(hosts)}
    </p>
    <table>
        <tr>
            <th>IP Address</th>
            <th>MAC Address</th>
            <th>Hostname</th>
            <th>Status</th>
            <th>OS</th>
            <th>Open Ports</th>
        </tr>
"""
        
        for host in hosts:
            status_class = f"status-{host['status']}"
            html += f"""        <tr>
            <td>{host['ip']}</td>
            <td>{host['mac']}</td>
            <td>{host['hostname']}</td>
            <td class="{status_class}">{host['status'].upper()}</td>
            <td>{host['os']}</td>
            <td>{host['open_ports']}</td>
        </tr>
"""
        
        html += """    </table>
</body>
</html>
"""
        
        if output_file:
            Path(output_file).write_text(html)
        
        return html


# Convenience function
def parse_nmap(xml_file):
    """Quick parse nmap XML file
    
    Usage:
        from toolkit.nmap.parser.parse_nmap import parse_nmap
        parser = parse_nmap("scan.xml")
        print(parser.get_hosts_summary())
    """
    return NmapParser(xml_file)
