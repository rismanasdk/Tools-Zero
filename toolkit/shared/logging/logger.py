"""Centralized logging module for Tools Zero toolkit"""

import logging
import sys
from pathlib import Path
from datetime import datetime
from logging.handlers import RotatingFileHandler


class ToolsZeroLogger:
    """Centralized logger for all toolkit components"""
    
    # Log levels
    DEBUG = logging.DEBUG
    INFO = logging.INFO
    WARNING = logging.WARNING
    ERROR = logging.ERROR
    CRITICAL = logging.CRITICAL
    
    _loggers = {}
    _log_dir = None
    _log_level = logging.INFO
    
    @classmethod
    def configure(cls, log_dir="./logs", level=logging.INFO):
        """Configure the logging system
        
        Args:
            log_dir (str): Directory to store log files
            level (int): Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
        """
        cls._log_dir = Path(log_dir)
        cls._log_dir.mkdir(parents=True, exist_ok=True)
        cls._log_level = level
    
    @classmethod
    def get_logger(cls, tool_name, level=None):
        """Get or create logger for a specific tool
        
        Args:
            tool_name (str): Name of the tool/module
            level (int): Optional logging level override
            
        Returns:
            logging.Logger: Configured logger instance
        """
        if tool_name in cls._loggers:
            return cls._loggers[tool_name]
        
        if cls._log_dir is None:
            cls.configure()
        
        logger = logging.getLogger(tool_name)
        logger.setLevel(level or cls._log_level)
        
        # Remove existing handlers
        logger.handlers.clear()
        
        # Create formatters
        detailed_formatter = logging.Formatter(
            '%(asctime)s [%(name)s] %(levelname)s: %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        simple_formatter = logging.Formatter(
            '[%(name)s] %(levelname)s: %(message)s'
        )
        
        # File handler - rotating logs
        log_file = cls._log_dir / f"{tool_name}.log"
        file_handler = RotatingFileHandler(
            log_file,
            maxBytes=10*1024*1024,  # 10 MB
            backupCount=5
        )
        file_handler.setFormatter(detailed_formatter)
        logger.addHandler(file_handler)
        
        # Console handler
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setFormatter(simple_formatter)
        logger.addHandler(console_handler)
        
        cls._loggers[tool_name] = logger
        return logger
    
    @classmethod
    def debug(cls, tool_name, message):
        """Log debug message"""
        cls.get_logger(tool_name).debug(message)
    
    @classmethod
    def info(cls, tool_name, message):
        """Log info message"""
        cls.get_logger(tool_name).info(message)
    
    @classmethod
    def warning(cls, tool_name, message):
        """Log warning message"""
        cls.get_logger(tool_name).warning(message)
    
    @classmethod
    def error(cls, tool_name, message):
        """Log error message"""
        cls.get_logger(tool_name).error(message)
    
    @classmethod
    def critical(cls, tool_name, message):
        """Log critical message"""
        cls.get_logger(tool_name).critical(message)


# Convenience instances for direct usage
def setup_logger(tool_name, log_dir="./logs", level=logging.INFO):
    """Setup and return a logger for a tool
    
    Usage:
        from toolkit.shared.logging.logger import setup_logger
        logger = setup_logger("nmap", level=logging.DEBUG)
        logger.info("Scan started")
    """
    ToolsZeroLogger.configure(log_dir, level)
    return ToolsZeroLogger.get_logger(tool_name, level)


def get_logger(tool_name):
    """Get existing logger or create new one
    
    Usage:
        from toolkit.shared.logging.logger import get_logger
        logger = get_logger("hydra")
    """
    return ToolsZeroLogger.get_logger(tool_name)
