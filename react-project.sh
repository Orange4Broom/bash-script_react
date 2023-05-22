#!/bin/bash

# Colors
RED='\033[31m'
GREEN='\033[32m'
CYAN='\033[36m'
NC='\033[0m'

text=""

loadinganimation() {
    local chars="/-\|"
    local delay=0.1
    local i=0
    
    while :; do
        echo -ne "\r ${text} ${chars:$i:1}"
        ((i = (i + 1) % 4))
        sleep "$delay"
    done
}

github=false

echo -e "${CYAN}Enter the project name:${NC}"
read -p "> " pname

if [[ -d $pname ]]; then
        echo -e "${RED}Error: Folder '$pname' already exists.${NC}"
    exit 1
    else
        echo -e "${GREEN}Start creating project $pname${NC} \n"
fi

echo -e "${CYAN}Do you want to create a github repository? (y/n)${NC}"
read -p "> " answer
if [[ $answer == "y" ]]; then
    github=true
    text="Creating github repository..."
    loadinganimation &

    TOKEN=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

    JSON_STRING='{"name":"'"$pname"'","private":false,"auto_init":false}'

    curl -H "Authorization: token $TOKEN" -d "$JSON_STRING" https://api.github.com/user/repos -s &> /dev/null
    
    kill $!
    wait $! 2>/dev/null
    echo -e "\n${GREEN}Github repository $pname created${NC}\n"
else
    echo -e "${RED}Not creating github repository${NC}\n"
fi

yarn create vite $pname --template react-ts &> /dev/null

cd $pname

text="Removing unnecessary files..."
loadinganimation &

rm -r src/assets
rm public/vite.svg
rm .eslintrc.cjs
rm ./**/*.css
rm src/App.tsx
cp ~/scripts/App.tsx src
sed -i '' '4d' src/main.tsx

kill $!
wait $! 2>/dev/null

echo -e "\n${GREEN}Unnecessary files removed${NC}\n"

echo -e "${CYAN}Do you want to install starting packages (eslint, prettier, sass, redux)? (y/n)${NC}"
read -p "> " answer
if [[ $answer == "y" ]]; then
    text="Installing packages..."
    loadinganimation &

    yarn add -D sass &> /dev/null
    yarn add react-router-dom &> /dev/null
    yarn add redux &> /dev/null
    yarn add react-redux &> /dev/null
    yarn add @reduxjs/toolkit &> /dev/null
    yarn add -D eslint &> /dev/null
    yarn add -D eslint-plugin-react &> /dev/null

    cp ~/scripts/config.json .eslintrc.json
    yarn add -D prettier eslint-config-prettier eslint-plugin-prettier &> /dev/null
    cp ~/scripts/prettier.json .prettierrc.json
    yarn lint --fix &> /dev/null

    kill $!
    wait $! 2>/dev/null

    echo -e "\n${GREEN}Packages installed and project structure created :)${NC}\n"
else
    echo -e "${RED}Not installing packages${NC}\n"
fi

echo -e "${GREEN}Project $pname created${NC}"

if [[ $github == true ]]; then
    echo -e "${CYAN}Do you want to push the project to github? (y/n)${NC}"
    read -p "> " answer
    if [[ $answer == "y" ]]; then
        text="Pushing to github..."
        loadinganimation &

        git init  &> /dev/null
        git config user.name "Orange4Broom" &> /dev/null
        git config user.email "orang4broom@gmail.com" &> /dev/null
        git add . &> /dev/null
        git commit -m "Initial commit" &> /dev/null
        git branch -M master &> /dev/null
        git remote add origin git@github.com:{YOUR_GITHUB_NAME}/$pname.git &> /dev/null
        git push -u origin master &> /dev/null

        kill $!
        wait $! 2>/dev/null

        echo -e "\n${GREEN}Project $pname pushed to github${NC}\n"
    fi
    else
        echo -e "${RED}Not pushing to github${NC}"
fi

echo -e "${GREEN}Opening project in VSCode...${NC}"
code . 