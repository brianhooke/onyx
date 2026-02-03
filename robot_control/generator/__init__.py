"""
RAPID Code Generator Package

Clean architecture for generating RAPID robot programs:
- patterns.py: Pure geometry (serpentine, etc.)
- rapid.py: RAPID code emission helpers
- tools/: Individual tool procedure generators
- generator.py: Main orchestrator
"""

from .generator import ToolpathGenerator

__all__ = ['ToolpathGenerator']
