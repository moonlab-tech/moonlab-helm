#!/usr/bin/env python3
"""
Script to automatically update README.md with chart information.
Discovers all charts in the charts/ directory and updates the Available Charts section.
Also updates version badges in individual chart README files.
"""

import os
import yaml
import re
from pathlib import Path

def get_chart_info(chart_path):
    """Extract chart information from Chart.yaml"""
    chart_yaml_path = chart_path / "Chart.yaml"
    if not chart_yaml_path.exists():
        return None
    
    with open(chart_yaml_path, 'r', encoding='utf-8') as f:
        chart_data = yaml.safe_load(f)
    
    return {
        'name': chart_data.get('name', ''),
        'version': chart_data.get('version', ''),
        'description': chart_data.get('description', ''),
        'home': chart_data.get('home', ''),
        'appVersion': chart_data.get('appVersion', ''),
        'path': chart_path.name
    }

def get_chart_description(chart_path):
    """Try to get description from README.md if available"""
    readme_path = chart_path / "README.md"
    if not readme_path.exists():
        return ""
    
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Try to extract description from first paragraph
    lines = content.split('\n')
    for line in lines:
        line = line.strip()
        if line and not line.startswith('#') and not line.startswith('!['):
            # Remove markdown formatting
            line = re.sub(r'[*`]', '', line)
            return line[:100] + "..." if len(line) > 100 else line
    
    return ""

def update_chart_readme_badges(chart_info):
    """Update version badges in individual chart README files"""
    readme_path = Path("charts") / chart_info['path'] / "README.md"
    if not readme_path.exists():
        return
    
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Update version badges
    # Pattern to match version badges like ![Version: 1.0.0](...)
    version_pattern = r'!\[Version: [^\]]+\]\([^)]+\)'
    type_pattern = r'!\[Type: [^\]]+\]\([^)]+\)'
    app_version_pattern = r'!\[AppVersion: [^\]]+\]\([^)]+\)'
    
    # Create new badges
    new_version_badge = f"![Version: {chart_info['version']}](https://img.shields.io/badge/Version-{chart_info['version']}-informational?style=flat-square)"
    new_type_badge = "![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)"
    new_app_version_badge = f"![AppVersion: {chart_info['appVersion']}](https://img.shields.io/badge/AppVersion-{chart_info['appVersion']}-informational?style=flat-square)"
    
    # Replace badges
    content = re.sub(version_pattern, new_version_badge, content)
    content = re.sub(type_pattern, new_type_badge, content)
    content = re.sub(app_version_pattern, new_app_version_badge, content)
    
    # Write back to file
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Updated badges in {readme_path}")

def discover_charts():
    """Discover all charts in the charts/ directory"""
    charts_dir = Path("charts")
    if not charts_dir.exists():
        return []
    
    charts = []
    for chart_path in charts_dir.iterdir():
        if chart_path.is_dir() and (chart_path / "Chart.yaml").exists():
            chart_info = get_chart_info(chart_path)
            if chart_info:
                # Get description from README if available
                description = get_chart_description(chart_path)
                if description:
                    chart_info['description'] = description
                charts.append(chart_info)
    
    # Sort charts by name
    charts.sort(key=lambda x: x['name'])
    return charts

def update_readme(charts):
    """Update README.md with chart information"""
    readme_path = Path("README.md")
    if not readme_path.exists():
        print("README.md not found!")
        return
    
    with open(readme_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Find the Available Charts section
    start_pattern = r'## Available Charts\s*\n\s*\| Chart \| Description \| Version \|\s*\|-+\|-+\|-+\|\s*'
    end_pattern = r'\n## '
    
    start_match = re.search(start_pattern, content, re.MULTILINE)
    if not start_match:
        print("Could not find 'Available Charts' section in README.md")
        return
    
    start_pos = start_match.end()
    
    # Find the end of the table
    remaining_content = content[start_pos:]
    end_match = re.search(end_pattern, remaining_content)
    end_pos = start_pos + end_match.start() if end_match else len(content)
    
    # Generate new table content
    table_lines = []
    for chart in charts:
        # Create badge for version
        badge = f"![Version](https://img.shields.io/badge/{chart['name']}-{chart['version']}-success)"
        table_lines.append(f"| [{chart['name']}](charts/{chart['path']}/) | {chart['description']} | {badge} |")
    
    new_table_content = '\n'.join(table_lines)
    
    # Replace the table content
    new_content = content[:start_pos] + new_table_content + '\n\n' + content[end_pos:]
    
    # Write back to README.md
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"Updated README.md with {len(charts)} charts")

def main():
    """Main function"""
    print("Discovering charts...")
    charts = discover_charts()
    
    if not charts:
        print("No charts found!")
        return
    
    print(f"Found {len(charts)} charts:")
    for chart in charts:
        print(f"  - {chart['name']} v{chart['version']}")
    
    print("\nUpdating main README.md...")
    update_readme(charts)
    
    print("\nUpdating individual chart README badges...")
    for chart in charts:
        update_chart_readme_badges(chart)
    
    print("Done!")

if __name__ == "__main__":
    main() 