import os
import tempfile
import subprocess
import random
import sys
import toml
from pathlib import Path

config_home = Path(os.getenv('XDG_CONFIG_HOME', Path.home() / '.config'))
alacritty_config_path = config_home / "alacritty" / "alacritty.toml"

r = random.randrange(0, 4) * 8
g = random.randrange(0, 4) * 8
b = random.randrange(0, 4) * 8
color = f"#{r:02x}{g:02x}{b:02x}"
opacity = random.uniform(0.7, 0.85)

with open(alacritty_config_path, 'r') as file:
    data = toml.load(file)

if 'window' not in data:
    data['window'] = {}
if 'colors' not in data:
    data['colors'] = {}
if 'primary' not in data['colors']:
    data['colors']['primary'] = {}

data['window']['opacity'] = opacity
data['colors']['primary']['background'] = color

# Write the updated data back to the TOML file
with tempfile.NamedTemporaryFile(mode='w', suffix='.toml', delete=False, dir='/tmp') as temp_file:
    toml.dump(data, temp_file)
    temp_file.flush()
    print(f"Generated color: {color}, opacity: {opacity:.2f}")
    print(f"Config file: {temp_file.name}")
    subprocess.run(["open", "-na", "Alacritty", "--args", "--config-file", temp_file.name] + sys.argv[1:])
