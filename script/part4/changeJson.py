import os  # Used for general OS interface operations
import subprocess
import json  # Used for JSON manipulation
from pathlib import Path  # Used for filesystem paths manipulation
import argparse #For arguments

# Define the wallpaper directory and the theme control file

parser = argparse.ArgumentParser(description="Process wallpaper ctlFile")
parser.add_argument('--config', type=str, help='Path to ctlFile', required=True)
args = parser.parse_args()

swwwDir = Path.home() / ".config" / "swww"
ctlFile = Path(args.config)

# Check and create the theme.json file if it doesn't exist
if not ctlFile.exists():
  ctlFile.touch()
  print(f"Created {ctlFile}")

# Read the current content of theme.json or start a new one if empty
if ctlFile.stat().st_size == 0:
  themes = []
else:
  with open(ctlFile, "r") as file:
    themes = json.load(file)

# List all theme directories
theme_dirs = [d for d in swwwDir.iterdir() if d.is_dir()]

for dir in theme_dirs:
  # Check if the theme already exists in the JSON
  if not any(theme["name"] == dir.name for theme in themes):
    if dir.name != "wall.data": #dont add wall.data folder
      themes.append(
      {
        "name": dir.name,
        "active": False,
        "imgPath": str(next(dir.glob("*"), Path()))
      })
      print(f"Added Theme: {dir.name}")
  

  #Active theme if any isn't active
  for theme in themes:
    if not any(theme["active"] == True for theme in themes):
      themes[0]["active"] = True

# Update theme.json with the current themes list
with open(ctlFile, "w") as file:
    json.dump(themes, file, indent=4)

print(f"Updated {ctlFile} with current themes")
