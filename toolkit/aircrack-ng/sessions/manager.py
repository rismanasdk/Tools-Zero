"""Aircrack-ng Session Manager - Save and restore attack sessions"""

import json
from pathlib import Path
from typing import Dict, List, Any, Optional
from datetime import datetime


class SessionManager:
    """Manage aircrack-ng attack sessions"""
    
    def __init__(self, sessions_dir="./toolkit/aircrack-ng/sessions"):
        """Initialize session manager
        
        Args:
            sessions_dir (str): Directory to store session files
        """
        self.sessions_dir = Path(sessions_dir)
        self.sessions_dir.mkdir(parents=True, exist_ok=True)
        self.current_session = None
    
    def create_session(self, name: str, network_name: str = None, 
                      bssid: str = None, channel: int = None,
                      encryption: str = None) -> Dict[str, Any]:
        """Create a new attack session
        
        Args:
            name (str): Session name
            network_name (str): Wireless network name (SSID)
            bssid (str): Basic Service Set Identifier (MAC address)
            channel (int): WiFi channel
            encryption (str): Encryption type (WEP, WPA, WPA2, WPA3, Open)
            
        Returns:
            Session dictionary
        """
        session = {
            'name': name,
            'timestamp': datetime.now().isoformat(),
            'network': {
                'ssid': network_name,
                'bssid': bssid,
                'channel': channel,
                'encryption': encryption
            },
            'attack_info': {
                'type': None,  # Monitor, Inject, Deauth, Crack, etc
                'status': 'initialized',
                'devices': [],
                'capture_file': None,
                'handshake_captured': False,
                'start_time': None,
                'end_time': None
            },
            'statistics': {
                'packets_captured': 0,
                'ives_collected': 0,
                'attempts': 0
            },
            'notes': []
        }
        
        self.current_session = session
        return session
    
    def save_session(self, session: Dict[str, Any] = None, 
                    output_file: str = None) -> str:
        """Save session to file
        
        Args:
            session (Dict): Session data (uses current if not provided)
            output_file (str): Optional custom output path
            
        Returns:
            Path to saved session file
        """
        if session is None:
            if self.current_session is None:
                raise ValueError("No session to save")
            session = self.current_session
        
        if output_file is None:
            name = session.get('name', 'session').replace(' ', '_')
            output_file = self.sessions_dir / f"{name}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        else:
            output_file = Path(output_file)
        
        output_file.parent.mkdir(parents=True, exist_ok=True)
        
        with open(output_file, 'w') as f:
            json.dump(session, f, indent=2)
        
        return str(output_file)
    
    def load_session(self, session_file: str) -> Dict[str, Any]:
        """Load session from file
        
        Args:
            session_file (str): Path to session file
            
        Returns:
            Session dictionary
        """
        session_path = Path(session_file)
        
        if not session_path.exists():
            raise FileNotFoundError(f"Session file not found: {session_file}")
        
        with open(session_path, 'r') as f:
            session = json.load(f)
        
        self.current_session = session
        return session
    
    def list_sessions(self) -> List[Dict[str, Any]]:
        """List all saved sessions
        
        Returns:
            List of session metadata
        """
        sessions = []
        for session_file in self.sessions_dir.glob('*.json'):
            with open(session_file, 'r') as f:
                session = json.load(f)
                sessions.append({
                    'name': session.get('name'),
                    'timestamp': session.get('timestamp'),
                    'file': str(session_file),
                    'network': session.get('network', {}),
                    'status': session.get('attack_info', {}).get('status')
                })
        
        # Sort by timestamp descending
        sessions.sort(key=lambda x: x['timestamp'], reverse=True)
        return sessions
    
    def update_attack_status(self, attack_type: str, status: str):
        """Update current session attack status
        
        Args:
            attack_type (str): Type of attack (Deauth, Crack, Handshake, etc)
            status (str): Current status (running, completed, failed, etc)
        """
        if self.current_session is None:
            raise ValueError("No session loaded")
        
        self.current_session['attack_info']['type'] = attack_type
        self.current_session['attack_info']['status'] = status
        self.current_session['attack_info']['start_time'] = datetime.now().isoformat()
    
    def add_device(self, device_name: str, mode: str):
        """Add network device to session
        
        Args:
            device_name (str): Device name (wlan0, etc)
            mode (str): Monitor or Managed mode
        """
        if self.current_session is None:
            raise ValueError("No session loaded")
        
        device = {
            'name': device_name,
            'mode': mode,
            'added_at': datetime.now().isoformat()
        }
        
        self.current_session['attack_info']['devices'].append(device)
    
    def set_capture_file(self, filepath: str):
        """Set capture file for session
        
        Args:
            filepath (str): Path to capture file
        """
        if self.current_session is None:
            raise ValueError("No session loaded")
        
        self.current_session['attack_info']['capture_file'] = filepath
    
    def mark_handshake_captured(self):
        """Mark that WPA handshake has been captured"""
        if self.current_session is None:
            raise ValueError("No session loaded")
        
        self.current_session['attack_info']['handshake_captured'] = True
        self.current_session['attack_info']['end_time'] = datetime.now().isoformat()
    
    def add_note(self, note: str):
        """Add note to current session
        
        Args:
            note (str): Note text
        """
        if self.current_session is None:
            raise ValueError("No session loaded")
        
        self.current_session['notes'].append({
            'timestamp': datetime.now().isoformat(),
            'text': note
        })
    
    def delete_session(self, session_file: str) -> bool:
        """Delete session file
        
        Args:
            session_file (str): Path to session file
            
        Returns:
            True if deleted, False otherwise
        """
        session_path = Path(session_file)
        
        if not session_path.exists():
            return False
        
        session_path.unlink()
        return True
    
    def export_summary(self, output_file: str = None) -> str:
        """Export session summary as text
        
        Args:
            output_file (str): Optional file to export to
            
        Returns:
            Summary text
        """
        if self.current_session is None:
            raise ValueError("No session loaded")
        
        session = self.current_session
        summary = f"""
═══════════════════════════════════════════════════════
AIRCRACK-NG SESSION SUMMARY
═══════════════════════════════════════════════════════

Session Name: {session['name']}
Created: {session['timestamp']}

NETWORK INFORMATION
───────────────────
SSID: {session['network']['ssid']}
BSSID: {session['network']['bssid']}
Channel: {session['network']['channel']}
Encryption: {session['network']['encryption']}

ATTACK INFORMATION
───────────────────
Attack Type: {session['attack_info']['type']}
Status: {session['attack_info']['status']}
Capture File: {session['attack_info']['capture_file']}
Handshake Captured: {session['attack_info']['handshake_captured']}

STATISTICS
───────────────────
Packets Captured: {session['statistics']['packets_captured']}
IVs Collected: {session['statistics']['ives_collected']}
Attempts: {session['statistics']['attempts']}

NOTES
───────────────────
"""
        
        for note in session['notes']:
            summary += f"[{note['timestamp']}] {note['text']}\n"
        
        if output_file:
            with open(output_file, 'w') as f:
                f.write(summary)
        
        return summary


# Convenience functions
def create_session_manager(sessions_dir="./toolkit/aircrack-ng/sessions"):
    """Create session manager
    
    Usage:
        from toolkit.aircrack_ng.sessions.manager import create_session_manager
        
        sm = create_session_manager()
        session = sm.create_session(
            name="Office WiFi Attack",
            network_name="OfficeNet",
            bssid="AA:BB:CC:DD:EE:FF",
            channel=6,
            encryption="WPA2"
        )
        sm.save_session()
    """
    return SessionManager(sessions_dir)
