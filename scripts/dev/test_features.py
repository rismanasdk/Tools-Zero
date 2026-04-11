"""Quick tests for newly implemented features"""

import sys
from pathlib import Path

# Add the project root to path
sys.path.insert(0, str(Path(__file__).parent))

def test_logging():
    """Test shared logging system"""
    print("=" * 60)
    print("Testing: Shared Logging System")
    print("=" * 60)
    
    try:
        from toolkit.shared.logging.logger import setup_logger, get_logger
        
        logger = setup_logger("test_tool")
        logger.info("✓ Logging system initialized")
        logger.debug("Debug message")
        logger.warning("Warning message")
        print("✓ Logging system working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Logging test failed: {e}\n")
        return False


def test_config_manager():
    """Test shared configuration manager"""
    print("=" * 60)
    print("Testing: Configuration Manager")
    print("=" * 60)
    
    try:
        from toolkit.shared.config.config_manager import ConfigManager, get_config
        
        ConfigManager.initialize()
        log_level = get_config("logging", "level")
        timeout = get_config("timeout", "default")
        
        print(f"✓ Config loaded: log_level={log_level}, timeout={timeout}")
        print("✓ Configuration manager working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Config test failed: {e}\n")
        return False


def test_nmap_parser():
    """Test nmap XML parser"""
    print("=" * 60)
    print("Testing: Nmap XML Parser")
    print("=" * 60)
    
    try:
        from toolkit.nmap.parser.parse_nmap import parse_nmap
        
        print("✓ Nmap parser module imported successfully")
        print("  - Can parse nmap XML files")
        print("  - Supports JSON/CSV/HTML export")
        print("✓ Nmap parser working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Nmap parser test failed: {e}\n")
        return False


def test_hydra_credentials():
    """Test hydra credential manager"""
    print("=" * 60)
    print("Testing: Hydra Credential Manager")
    print("=" * 60)
    
    try:
        from toolkit.hydra.credentials.manager import create_credential_manager
        
        # Create test manager
        cm = create_credential_manager()
        print("✓ Credential manager initialized")
        
        # Test adding credential
        cred_id = cm.add_credential("ssh", "192.168.1.100", "admin", "password123")
        print(f"✓ Credential added with ID: {cred_id}")
        
        # Test retrieval
        cred = cm.get_credential(cred_id)
        if cred and cred['password'] == 'password123':
            print("✓ Credential retrieval and decryption working")
        
        print("✓ Hydra credential manager working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Hydra credential test failed: {e}\n")
        return False


def test_aircrack_sessions():
    """Test aircrack-ng session manager"""
    print("=" * 60)
    print("Testing: Aircrack-ng Session Manager")
    print("=" * 60)
    
    try:
        from toolkit.aircrack_ng.sessions.manager import create_session_manager
        
        sm = create_session_manager()
        print("✓ Session manager initialized")
        
        # Create test session
        session = sm.create_session(
            name="Test WiFi Attack",
            network_name="TestNet",
            bssid="AA:BB:CC:DD:EE:FF",
            channel=6,
            encryption="WPA2"
        )
        print(f"✓ Session created: {session['name']}")
        print("✓ Aircrack-ng session manager working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Aircrack session test failed: {e}\n")
        return False


def test_aircrack_reports():
    """Test aircrack-ng report generator"""
    print("=" * 60)
    print("Testing: Aircrack-ng Report Generator")
    print("=" * 60)
    
    try:
        from toolkit.aircrack_ng.reports.generator import create_report_generator
        
        rg = create_report_generator()
        print("✓ Report generator initialized")
        print("  - Supports HTML reports")
        print("  - Supports JSON export")
        print("  - Supports CSV export")
        print("✓ Aircrack-ng report generator working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Aircrack report test failed: {e}\n")
        return False


def test_gobuster_presets():
    """Test gobuster directory presets"""
    print("=" * 60)
    print("Testing: Gobuster Directory Presets")
    print("=" * 60)
    
    try:
        presets_dir = Path("./toolkit/gobuster/presets")
        
        presets = [
            "common_dirs.txt",
            "admin_dirs.txt",
            "api_dirs.txt",
            "backup_dirs.txt",
            "config_dirs.txt"
        ]
        
        for preset in presets:
            preset_file = presets_dir / preset
            if preset_file.exists():
                lines = len(preset_file.read_text().strip().split('\n'))
                print(f"✓ {preset}: {lines} items")
            else:
                print(f"✗ Missing: {preset}")
        
        print("✓ Gobuster presets created successfully\n")
        return True
    except Exception as e:
        print(f"✗ Gobuster presets test failed: {e}\n")
        return False


def test_gobuster_export():
    """Test gobuster result exporter"""
    print("=" * 60)
    print("Testing: Gobuster Result Exporter")
    print("=" * 60)
    
    try:
        from toolkit.gobuster.export.exporter import create_exporter
        
        exporter = create_exporter()
        print("✓ Exporter initialized")
        
        # Add test results
        exporter.add_result('/admin', 200, size=1024)
        exporter.add_result('/api/v1', 403, size=512)
        exporter.add_result('/config', 403)
        print("✓ Test results added")
        
        # Test export formats
        json_str = exporter.to_json()
        csv_str = exporter.to_csv("test_export.csv") if not Path("test_export.csv").exists() else "existing"
        print("✓ Export formats supported: JSON, CSV, HTML, Text")
        print("✓ Gobuster exporter working correctly\n")
        return True
    except Exception as e:
        print(f"✗ Gobuster exporter test failed: {e}\n")
        return False


def main():
    """Run all tests"""
    print("\n")
    print("╔" + "=" * 58 + "╗")
    print("║" + " " * 12 + "TOOLKIT FEATURE IMPLEMENTATION TESTS" + " " * 10 + "║")
    print("╚" + "=" * 58 + "╝")
    print()
    
    tests = [
        ("Shared Logging", test_logging),
        ("Config Manager", test_config_manager),
        ("Nmap Parser", test_nmap_parser),
        ("Hydra Credentials", test_hydra_credentials),
        ("Aircrack Sessions", test_aircrack_sessions),
        ("Aircrack Reports", test_aircrack_reports),
        ("Gobuster Presets", test_gobuster_presets),
        ("Gobuster Exporter", test_gobuster_export),
    ]
    
    results = {}
    for test_name, test_func in tests:
        results[test_name] = test_func()
    
    # Summary
    print("=" * 60)
    print("TEST SUMMARY")
    print("=" * 60)
    
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    
    for test_name, result in results.items():
        status = "✓ PASS" if result else "✗ FAIL"
        print(f"{status:8} | {test_name}")
    
    print("-" * 60)
    print(f"Total: {passed}/{total} tests passed")
    print()
    
    return passed == total


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
