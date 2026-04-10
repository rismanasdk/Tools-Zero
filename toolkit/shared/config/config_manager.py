"""Configuration management for Tools Zero toolkit"""

import json
import os
from pathlib import Path
from typing import Dict, Any


class ConfigManager:
    """Centralized configuration management for toolkit"""
    
    _loaded_config = {}
    _config_dir = None
    _default_config_file = None
    _user_config_file = None
    
    # Default configuration template
    DEFAULT_CONFIG = {
        "logging": {
            "enabled": True,
            "level": "INFO",
            "path": "./logs",
            "max_size_mb": 10,
            "backup_count": 5
        },
        "proxy": {
            "enabled": False,
            "http": None,
            "https": None,
            "no_proxy": "127.0.0.1,localhost"
        },
        "wordlists": {
            "path": "./wordlists",
            "auto_download": False,
            "sources": [
                "https://raw.githubusercontent.com/danielmiessler/SecLists/master/",
            ]
        },
        "timeout": {
            "default": 30,
            "long_running": 300,
            "connection": 10
        },
        "credentials": {
            "encrypted": True,
            "cache_enabled": False,
            "cache_duration": 3600
        },
        "tools": {
            "nmap": {
                "default_args": "-sV -sC --script vuln",
                "output_format": "xml"
            },
            "hydra": {
                "threads": 16,
                "timeout": 30,
                "max_retries": 3
            },
            "johntheripper": {
                "wordlist_path": "./wordlists/rockyou.txt",
                "gpu_enabled": False,
                "rules": "Jumbo"
            },
            "gobuster": {
                "threads": 50,
                "timeout": 5
            }
        }
    }
    
    @classmethod
    def initialize(cls, config_dir="./config"):
        """Initialize configuration manager
        
        Args:
            config_dir (str): Directory to store configuration files
        """
        cls._config_dir = Path(config_dir)
        cls._config_dir.mkdir(parents=True, exist_ok=True)
        
        cls._default_config_file = cls._config_dir / "default_config.json"
        cls._user_config_file = cls._config_dir / "config.json"
        
        # Create default config if not exists
        if not cls._default_config_file.exists():
            cls._write_config(cls._default_config_file, cls.DEFAULT_CONFIG)
        
        # Load configs
        cls._load_configs()
    
    @classmethod
    def _load_configs(cls):
        """Load default and user configurations"""
        cls._loaded_config = cls.DEFAULT_CONFIG.copy()
        
        # Load and merge user config if exists
        if cls._user_config_file and cls._user_config_file.exists():
            try:
                user_cfg = cls._read_config(cls._user_config_file)
                cls._loaded_config = cls._deep_merge(cls._loaded_config, user_cfg)
            except Exception as e:
                print(f"Warning: Failed to load user config: {e}")
        
        # Override with environment variables
        cls._apply_env_overrides()
    
    @classmethod
    def _apply_env_overrides(cls):
        """Apply environment variable overrides"""
        env_overrides = {
            "LOG_LEVEL": ["logging", "level"],
            "LOG_PATH": ["logging", "path"],
            "HTTP_PROXY": ["proxy", "http"],
            "HTTPS_PROXY": ["proxy", "https"],
            "WORDLIST_PATH": ["wordlists", "path"],
            "TIMEOUT": ["timeout", "default"],
        }
        
        for env_var, config_path in env_overrides.items():
            if env_var in os.environ:
                cls._set_nested(cls._loaded_config, config_path, os.environ[env_var])
    
    @classmethod
    def _deep_merge(cls, base: Dict, override: Dict) -> Dict:
        """Deep merge override dictionary into base"""
        result = base.copy()
        for key, value in override.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = cls._deep_merge(result[key], value)
            else:
                result[key] = value
        return result
    
    @classmethod
    def _read_config(cls, filepath: Path) -> Dict:
        """Read configuration from JSON file"""
        with open(filepath, 'r') as f:
            return json.load(f)
    
    @classmethod
    def _write_config(cls, filepath: Path, config: Dict):
        """Write configuration to JSON file"""
        filepath.parent.mkdir(parents=True, exist_ok=True)
        with open(filepath, 'w') as f:
            json.dump(config, f, indent=2)
    
    @classmethod
    def _get_nested(cls, config: Dict, path: list) -> Any:
        """Get value from nested dictionary using path list"""
        current = config
        for key in path:
            current = current.get(key, {})
        return current
    
    @classmethod
    def _set_nested(cls, config: Dict, path: list, value: Any):
        """Set value in nested dictionary using path list"""
        current = config
        for key in path[:-1]:
            if key not in current:
                current[key] = {}
            current = current[key]
        current[path[-1]] = value
    
    @classmethod
    def get(cls, *args, default=None) -> Any:
        """Get configuration value
        
        Usage:
            ConfigManager.get("logging", "level")  # Returns "INFO"
            ConfigManager.get("logging", "level", default="DEBUG")  # With default
        """
        if not cls._loaded_config:
            cls.initialize()
        
        current = cls._loaded_config
        for key in args:
            if isinstance(current, dict):
                current = current.get(key)
            else:
                return default
        
        return current if current is not None else default
    
    @classmethod
    def set(cls, *args, value):
        """Set configuration value
        
        Usage:
            ConfigManager.set("logging", "level", value="DEBUG")
        """
        if not cls._loaded_config:
            cls.initialize()
        
        cls._set_nested(cls._loaded_config, list(args), value)
    
    @classmethod
    def get_all(cls) -> Dict:
        """Get entire configuration dictionary"""
        if not cls._loaded_config:
            cls.initialize()
        return cls._loaded_config.copy()
    
    @classmethod
    def save_user_config(cls):
        """Save current configuration to user config file"""
        if cls._user_config_file:
            cls._write_config(cls._user_config_file, cls._loaded_config)
    
    @classmethod
    def reload(cls):
        """Reload configurations from files"""
        cls._load_configs()
    
    @classmethod
    def get_config_dir(cls) -> Path:
        """Get configuration directory"""
        if cls._config_dir is None:
            cls.initialize()
        return cls._config_dir


# Convenience functions
def get_config(*args, default=None):
    """
    Usage:
        from toolkit.shared.config.config_manager import get_config
        log_level = get_config("logging", "level")
        timeout = get_config("timeout", "default", default=30)
    """
    return ConfigManager.get(*args, default=default)


def set_config(*args, value):
    """
    Usage:
        from toolkit.shared.config.config_manager import set_config
        set_config("logging", "level", value="DEBUG")
    """
    ConfigManager.set(*args, value=value)


def get_all_config():
    """Get entire configuration"""
    return ConfigManager.get_all()


def save_config():
    """Save current configuration"""
    ConfigManager.save_user_config()


def reload_config():
    """Reload configuration from files"""
    ConfigManager.reload()
