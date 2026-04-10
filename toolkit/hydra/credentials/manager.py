"""Hydra Credential Manager - Encrypted storage and caching"""

import sqlite3
import json
from pathlib import Path
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta
from cryptography.fernet import Fernet


class CredentialManager:
    """Manage credentials with optional encryption"""
    
    def __init__(self, db_path="./config/credentials.db", encryption_key=None):
        """Initialize credential manager
        
        Args:
            db_path (str): Path to credential database
            encryption_key (bytes): Fernet encryption key (None = no encryption)
        """
        self.db_path = Path(db_path)
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        self.cipher = None
        
        if encryption_key:
            self.cipher = Fernet(encryption_key)
        
        self._init_db()
    
    def _init_db(self):
        """Initialize database schema"""
        conn = sqlite3.connect(self.db_path)
        conn.execute("""
            CREATE TABLE IF NOT EXISTS credentials (
                id INTEGER PRIMARY KEY,
                protocol TEXT NOT NULL,
                target TEXT NOT NULL,
                username TEXT,
                password TEXT,
                port INTEGER,
                created_at TIMESTAMP,
                last_used TIMESTAMP,
                notes TEXT
            )
        """)
        
        conn.execute("""
            CREATE TABLE IF NOT EXISTS credential_groups (
                id INTEGER PRIMARY KEY,
                name TEXT UNIQUE NOT NULL,
                description TEXT,
                created_at TIMESTAMP
            )
        """)
        
        conn.execute("""
            CREATE TABLE IF NOT EXISTS group_credentials (
                group_id INTEGER,
                credential_id INTEGER,
                FOREIGN KEY (group_id) REFERENCES credential_groups(id),
                FOREIGN KEY (credential_id) REFERENCES credentials(id)
            )
        """)
        
        conn.commit()
        conn.close()
    
    def _encrypt(self, text: str) -> str:
        """Encrypt text"""
        if self.cipher is None:
            return text
        encrypted = self.cipher.encrypt(text.encode())
        return encrypted.decode()
    
    def _decrypt(self, encrypted_text: str) -> str:
        """Decrypt text"""
        if self.cipher is None:
            return encrypted_text
        decrypted = self.cipher.decrypt(encrypted_text.encode())
        return decrypted.decode()
    
    def add_credential(self, protocol: str, target: str, username: str, 
                      password: str, port: int = None, notes: str = None) -> int:
        """Add a new credential
        
        Args:
            protocol (str): Protocol (ssh, ftp, http, etc)
            target (str): Target host/IP
            username (str): Username
            password (str): Password to store
            port (int): Optional port number
            notes (str): Optional notes
            
        Returns:
            Credential ID
        """
        encrypted_password = self._encrypt(password)
        
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            INSERT INTO credentials 
            (protocol, target, username, password, port, created_at, notes)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (protocol, target, username, encrypted_password, port, datetime.now(), notes))
        
        cred_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return cred_id
    
    def get_credential(self, cred_id: int) -> Optional[Dict[str, Any]]:
        """Get credential by ID
        
        Args:
            cred_id (int): Credential ID
            
        Returns:
            Credential dictionary
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, protocol, target, username, password, port, created_at, notes
            FROM credentials WHERE id = ?
        """, (cred_id,))
        
        row = cursor.fetchone()
        conn.close()
        
        if row is None:
            return None
        
        return {
            'id': row[0],
            'protocol': row[1],
            'target': row[2],
            'username': row[3],
            'password': self._decrypt(row[4]),
            'port': row[5],
            'created_at': row[6],
            'notes': row[7]
        }
    
    def get_credentials_by_protocol(self, protocol: str) -> List[Dict[str, Any]]:
        """Get all credentials for a protocol
        
        Args:
            protocol (str): Protocol name (ssh, ftp, http, etc)
            
        Returns:
            List of credentials
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, protocol, target, username, password, port, created_at, notes
            FROM credentials WHERE protocol = ?
        """, (protocol,))
        
        rows = cursor.fetchall()
        conn.close()
        
        credentials = []
        for row in rows:
            credentials.append({
                'id': row[0],
                'protocol': row[1],
                'target': row[2],
                'username': row[3],
                'password': self._decrypt(row[4]),
                'port': row[5],
                'created_at': row[6],
                'notes': row[7]
            })
        
        return credentials
    
    def get_credentials_by_target(self, target: str) -> List[Dict[str, Any]]:
        """Get all credentials for a target
        
        Args:
            target (str): Target host/IP
            
        Returns:
            List of credentials
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, protocol, target, username, password, port, created_at, notes
            FROM credentials WHERE target = ?
        """, (target,))
        
        rows = cursor.fetchall()
        conn.close()
        
        credentials = []
        for row in rows:
            credentials.append({
                'id': row[0],
                'protocol': row[1],
                'target': row[2],
                'username': row[3],
                'password': self._decrypt(row[4]),
                'port': row[5],
                'created_at': row[6],
                'notes': row[7]
            })
        
        return credentials
    
    def list_all_credentials(self) -> List[Dict[str, Any]]:
        """List all credentials (passwords encrypted)
        
        Returns:
            List of all credentials
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, protocol, target, username, port, created_at, notes
            FROM credentials ORDER BY protocol, target
        """)
        
        rows = cursor.fetchall()
        conn.close()
        
        credentials = []
        for row in rows:
            credentials.append({
                'id': row[0],
                'protocol': row[1],
                'target': row[2],
                'username': row[3],
                'port': row[4],
                'created_at': row[5],
                'notes': row[6]
            })
        
        return credentials
    
    def delete_credential(self, cred_id: int) -> bool:
        """Delete credential
        
        Args:
            cred_id (int): Credential ID
            
        Returns:
            True if deleted, False otherwise
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("DELETE FROM credentials WHERE id = ?", (cred_id,))
        deleted = cursor.rowcount > 0
        
        conn.commit()
        conn.close()
        
        return deleted
    
    def create_group(self, name: str, description: str = None) -> int:
        """Create credential group
        
        Args:
            name (str): Group name
            description (str): Optional description
            
        Returns:
            Group ID
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            INSERT INTO credential_groups (name, description, created_at)
            VALUES (?, ?, ?)
        """, (name, description, datetime.now()))
        
        group_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return group_id
    
    def add_to_group(self, group_id: int, cred_id: int):
        """Add credential to group
        
        Args:
            group_id (int): Group ID
            cred_id (int): Credential ID
        """
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute("""
            INSERT INTO group_credentials (group_id, credential_id)
            VALUES (?, ?)
        """, (group_id, cred_id))
        
        conn.commit()
        conn.close()
    
    def export_json(self, output_file: str, with_passwords: bool = False):
        """Export credentials to JSON (optionally encrypted)
        
        Args:
            output_file (str): File to export to
            with_passwords (bool): Include passwords in export
        """
        credentials = self.list_all_credentials()
        
        if with_passwords:
            # Include decrypted passwords
            for cred in credentials:
                full_cred = self.get_credential(cred['id'])
                cred['password'] = full_cred['password']
        
        with open(output_file, 'w') as f:
            json.dump(credentials, f, indent=2, default=str)
    
    def generate_encryption_key(self) -> bytes:
        """Generate a new encryption key"""
        return Fernet.generate_key()


# Convenience functions
def create_credential_manager(db_path="./config/credentials.db", encryption=True):
    """Create credential manager with optional encryption
    
    Usage:
        from toolkit.hydra.credentials.manager import create_credential_manager
        
        cm = create_credential_manager()
        cred_id = cm.add_credential("ssh", "192.168.1.100", "admin", "password123")
        cred = cm.get_credential(cred_id)
        print(cred['password'])
    """
    key = None
    if encryption:
        key = Fernet.generate_key()
    
    return CredentialManager(db_path, key)
