#!/bin/bash

COLOR='\033[0;32m'
NC='\033[0m' # No Color

CONF=$(cat project.godot | grep "config/name")
VALUE="${CONF##*=}"
FRONT_TRIMMED="${VALUE#*\"}"
GAME="${FRONT_TRIMMED%\"*}"
GAME_UC=$(echo $GAME | awk '{print toupper($0)}')
GAME_LC=$(echo $GAME | awk '{print tolower($0)}')
echo "----------------------------------------------------------"
printf "Project name: ${COLOR}${GAME}${NC}\n"
echo "----------------------------------------------------------"
# cp _export_presets.cfg export_presets.cfg

cat _export_presets.cfg | sed -e "s/%PROJECT_NAME%/${GAME}/g" > export_presets.cfg
echo "✅ Created export preset file"

mkdir Builds
mkdir Builds/linux
mkdir Builds/osx
mkdir Builds/win
echo "✅ Created build folders"

if cat project.godot | grep -q file_customization
then
	echo "🚫 Skip adding file customization settings";
else
	cat _project_file_customization.godot >> project.godot
	echo "✅ Added file customization settings"
fi

if cat project.godot | grep -q editor_plugins
then
	echo "🚫 Skip adding editor plugins";
else
	cat _project_editor_plugins.godot >> project.godot
	echo "✅ Added editor plugins"
fi

if cat project.godot | grep -q editor_plugins
then
	echo "🚫 Skip adding input section";
else
	cat _project_input.godot >> project.godot
	echo "✅ Added input section"
fi
