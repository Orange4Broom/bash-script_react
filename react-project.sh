#!/bin/bash

# Colors
RED='\033[31m'   # Red color for error messages
GREEN='\033[32m' # Green color for success messages
CYAN='\033[36m'  # Cyan color for user prompts
NC='\033[0m'     # Reset color

text="" # Variable to store loading animation text
GithubName="{YOUR_GITHUB_NAME}"   # GitHub username
GithubEmail="{YOUR_GITHUB_EMAIL}" # GitHub email
TOKEN={YOUR_GITHUB_TOKEN} # GitHub token for API authentication
github=false # Flag to indicate if GitHub repository should be created

loadinganimation() {
    local chars="/-\|"    # Characters for loading animation
    local delay=0.1       # Delay between animation frames
    local i=0             # Animation character index

    while :; do
        echo -ne "\r ${text} ${chars:$i:1}" # Display text and animation character
        ((i = (i + 1) % 4))                 # Increment character index
        sleep "$delay"                      # Delay between frames
    done
}

echo -e "${CYAN}Enter the project name:${NC}"
read -p "> " pname # Prompt user for project name

if [[ -d $pname ]]; then
    echo -e "${RED}Error: Folder '$pname' already exists.${NC}"
    exit 1 # Error if project folder already exists
else
    echo -e "${GREEN}Start creating project $pname${NC} \n"
fi

echo -e "${CYAN}Do you want to create a GitHub repository? (y/n)${NC}"
read -p "> " answer # Prompt user for GitHub repository creation

if [[ $answer == "y" ]]; then
    github=true # Set flag to create GitHub repository
    text="Creating GitHub repository..."
    loadinganimation &

    JSON_STRING='{"name":"'"$pname"'","private":false,"auto_init":false}' # JSON payload for creating repository

    curl -H "Authorization: token $TOKEN" -d "$JSON_STRING" https://api.github.com/user/repos -s &> /dev/null

    kill $! # Kill the loading animation function
    wait $! 2>/dev/null
    echo -e "\n${GREEN}GitHub repository $pname created${NC}\n"
else
    echo -e "${RED}Not creating GitHub repository${NC}\n"
fi

yarn create vite $pname --template react-ts &> /dev/null # Create Vite project with specified template

cd $pname # Change directory to the project folder

text="Removing unnecessary files..."
loadinganimation &

rm -r src/assets        # Remove unnecessary assets folder
rm public/vite.svg      # Remove unnecessary Vite logo file
rm .eslintrc.cjs        # Remove ESLint configuration file
rm ./**/*.css           # Remove CSS files recursively
rm src/App.tsx          # Remove default App.tsx file
cp ~/scripts/App.tsx src # Copy custom App.tsx file to src folder
sed -i '' '4d' src/main.tsx # Remove line 4 from main.tsx file

kill $! # Kill the loading animation function
wait $! 2>/dev/null

echo -e "\n${GREEN}Unnecessary files removed${NC}\n"

echo -e "${CYAN}Do you want to install starting packages (eslint, prettier, sass, redux)? (y/n)${NC}"
read -p "> " answer # Prompt user for installing packages

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

    cp ~/scripts/config.json .eslintrc.json # Copy ESLint config file
    yarn add -D prettier eslint-config-prettier eslint-plugin-prettier &> /dev/null
    cp ~/scripts/prettier.json .prettierrc.json # Copy Prettier config file
    yarn lint --fix &> /dev/null # Run linting and auto-fix issues

    kill $! # Kill the loading animation function
    wait $! 2>/dev/null

    echo -e "\n${GREEN}Packages installed and project structure created :)${NC}\n"
else
    echo -e "${RED}Not installing packages${NC}\n"
fi

echo -e "${GREEN}Project $pname created${NC}"

if [[ $github == true ]]; then
    echo -e "${CYAN}Do you want to push the project to GitHub? (y/n)${NC}"
    read -p "> " answer # Prompt user for pushing to GitHub

    if [[ $answer == "y" ]]; then
        text="Pushing to GitHub..."
        loadinganimation &

        git init  &> /dev/null
        git config user.name "$GithubName" &> /dev/null
        git config user.email "$GithubEmail" &> /dev/null
        git add . &> /dev/null
        git commit -m "Initial commit" &> /dev/null
        git branch -M master &> /dev/null
        git remote add origin git@github.com:$GithubName/$pname.git &> /dev/null
        git push -u origin master &> /dev/null

        kill $! # Kill the loading animation function
        wait $! 2>/dev/null

        echo -e "\n${GREEN}Project $pname pushed to GitHub${NC}\n"
    fi
else
    echo -e "${RED}Not pushing to GitHub${NC}"
fi

echo -e "${GREEN}Opening project in VSCode...${NC}"
code . # Open project in VSCode
