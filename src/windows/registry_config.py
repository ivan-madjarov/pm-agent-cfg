#!/usr/bin/env python3
"""
PM Agent Registry Configuration Tool for Windows
Configures DesktopCentral DCAgent registry settings with performance options.
"""

import winreg
import sys
import argparse
from enum import Enum
from typing import Dict, Any
import logging

class PerformanceMode(Enum):
    """Performance mode options for agent resource utilization."""
    LOW = "low"
    HIGH = "high"

class RegistryConfig:
    """Handles Windows Registry configuration for PM Agent."""
    
    # Registry paths and default values
    PATCH_KEY = r"SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent\Patch"
    AGENT_KEY = r"SOFTWARE\WOW6432Node\AdventNet\DesktopCentral\DCAgent"
    
    PATCH_SCAN_TIMEOUT = "Patch_scan_timeout"
    THREAD_MAX_CPU_USAGE = "THRDMAXCPUUSAGE_2C"
    
    # Performance settings
    PERFORMANCE_SETTINGS = {
        PerformanceMode.LOW: {
            PATCH_SCAN_TIMEOUT: 200,
            THREAD_MAX_CPU_USAGE: 15
        },
        PerformanceMode.HIGH: {
            PATCH_SCAN_TIMEOUT: 200,
            THREAD_MAX_CPU_USAGE: 30
        }
    }
    
    def __init__(self):
        """Initialize the registry configuration handler."""
        self.logger = self._setup_logging()
    
    def _setup_logging(self) -> logging.Logger:
        """Set up logging configuration."""
        logger = logging.getLogger(__name__)
        logger.setLevel(logging.INFO)
        
        if not logger.handlers:
            handler = logging.StreamHandler()
            formatter = logging.Formatter(
                '%(asctime)s - %(levelname)s - %(message)s',
                datefmt='%Y-%m-%d %H:%M:%S'
            )
            handler.setFormatter(formatter)
            logger.addHandler(handler)
        
        return logger
    
    def create_registry_value(self, key_path: str, value_name: str, value_data: int) -> bool:
        """
        Create or update a DWORD registry value.
        
        Args:
            key_path: Registry key path
            value_name: Name of the registry value
            value_data: Data for the registry value
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            with winreg.CreateKey(winreg.HKEY_LOCAL_MACHINE, key_path) as key:
                winreg.SetValueEx(key, value_name, 0, winreg.REG_DWORD, value_data)
                self.logger.info(f"Successfully set {key_path}\\{value_name} = {value_data}")
                return True
                
        except PermissionError:
            self.logger.error("Permission denied. Please run as Administrator.")
            return False
        except Exception as e:
            self.logger.error(f"Failed to set registry value: {e}")
            return False
    
    def configure_performance_mode(self, mode: PerformanceMode) -> bool:
        """
        Configure registry settings for the specified performance mode.
        
        Args:
            mode: Performance mode (LOW or HIGH)
            
        Returns:
            bool: True if all settings applied successfully
        """
        self.logger.info(f"Configuring PM Agent for {mode.value} performance mode...")
        
        settings = self.PERFORMANCE_SETTINGS[mode]
        success_count = 0
        total_settings = len(settings)
        
        # Configure patch scan timeout
        if self.create_registry_value(
            self.PATCH_KEY, 
            self.PATCH_SCAN_TIMEOUT, 
            settings[self.PATCH_SCAN_TIMEOUT]
        ):
            success_count += 1
        
        # Configure thread max CPU usage
        if self.create_registry_value(
            self.AGENT_KEY, 
            self.THREAD_MAX_CPU_USAGE, 
            settings[self.THREAD_MAX_CPU_USAGE]
        ):
            success_count += 1
        
        if success_count == total_settings:
            self.logger.info(f"Successfully configured PM Agent for {mode.value} performance mode")
            return True
        else:
            self.logger.warning(f"Only {success_count}/{total_settings} settings applied successfully")
            return False
    
    def read_current_settings(self) -> Dict[str, Any]:
        """
        Read current registry settings.
        
        Returns:
            dict: Current registry values
        """
        settings = {}
        
        try:
            # Read patch scan timeout
            with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, self.PATCH_KEY) as key:
                value, _ = winreg.QueryValueEx(key, self.PATCH_SCAN_TIMEOUT)
                settings[self.PATCH_SCAN_TIMEOUT] = value
        except FileNotFoundError:
            settings[self.PATCH_SCAN_TIMEOUT] = "Not set"
        except Exception as e:
            settings[self.PATCH_SCAN_TIMEOUT] = f"Error: {e}"
        
        try:
            # Read thread max CPU usage
            with winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, self.AGENT_KEY) as key:
                value, _ = winreg.QueryValueEx(key, self.THREAD_MAX_CPU_USAGE)
                settings[self.THREAD_MAX_CPU_USAGE] = value
        except FileNotFoundError:
            settings[self.THREAD_MAX_CPU_USAGE] = "Not set"
        except Exception as e:
            settings[self.THREAD_MAX_CPU_USAGE] = f"Error: {e}"
        
        return settings
    
    def display_current_settings(self):
        """Display current registry settings."""
        self.logger.info("Current PM Agent Registry Settings:")
        settings = self.read_current_settings()
        
        print(f"Patch Scan Timeout: {settings.get(self.PATCH_SCAN_TIMEOUT, 'Unknown')}")
        print(f"Thread Max CPU Usage: {settings.get(self.THREAD_MAX_CPU_USAGE, 'Unknown')}")


def main():
    """Main function to handle command line interface."""
    parser = argparse.ArgumentParser(
        description="PM Agent Registry Configuration Tool for Windows",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Performance Modes:
  low   - Low performance mode  (CPU usage: 15%, Timeout: 200)
  high  - High performance mode (CPU usage: 30%, Timeout: 200)

Examples:
  %(prog)s --mode high          # Configure for high performance
  %(prog)s --mode low           # Configure for low performance  
  %(prog)s --status             # Show current settings
        """
    )
    
    parser.add_argument(
        "--mode", 
        choices=["low", "high"],
        help="Agent Resource Utilization Limit (low=15%%, high=30%%)"
    )
    
    parser.add_argument(
        "--status",
        action="store_true",
        help="Display current registry settings"
    )
    
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Enable verbose logging"
    )
    
    args = parser.parse_args()
    
    # Set up logging level
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    config = RegistryConfig()
    
    # Display current settings if requested
    if args.status:
        config.display_current_settings()
        return 0
    
    # Configure performance mode if specified
    if args.mode:
        mode = PerformanceMode.LOW if args.mode == "low" else PerformanceMode.HIGH
        
        print(f"\nConfiguring PM Agent for {mode.value} performance mode...")
        print(f"Agent Resource Utilization Limit: {args.mode} performance")
        print(f"CPU Usage Limit: {config.PERFORMANCE_SETTINGS[mode][config.THREAD_MAX_CPU_USAGE]}%")
        print(f"Patch Scan Timeout: {config.PERFORMANCE_SETTINGS[mode][config.PATCH_SCAN_TIMEOUT]} seconds")
        print()
        
        if config.configure_performance_mode(mode):
            print("✓ Configuration applied successfully!")
            print("\nNOTE: You may need to restart the DCAgent service for changes to take effect.")
            return 0
        else:
            print("✗ Configuration failed. Check the logs above.")
            return 1
    
    # If no arguments provided, show help
    parser.print_help()
    return 0


if __name__ == "__main__":
    sys.exit(main())
