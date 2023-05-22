# Bash Script Documentation

This documentation provides an overview of a Bash script that automates project creation, optionally creates a GitHub repository, configures project dependencies, and pushes the project to GitHub.

## Table of Contents

- [Overview](#overview)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Customization](#customization)

## Overview

The Bash script performs the following tasks:

1. Prompts the user to enter a project name.
2. Checks if a directory with the same name already exists. If it does, displays an error message and exits.
3. Creates a new project directory and displays a success message.
4. Prompts the user if they want to create a GitHub repository.
5. If GitHub repository creation is requested, the script creates a repository using the GitHub API and a personal access token.
6. Creates a Vite project with a React TypeScript template inside the project directory.
7. Removes unnecessary files and folders from the project structure.
8. Optionally installs additional packages such as Sass, React Router, Redux, ESLint, and Prettier.
9. Configures ESLint and Prettier with custom configuration files.
10. Lints the project and automatically fixes any issues.
11. If GitHub repository creation is requested, initializes a local Git repository, configures user information, adds files, commits changes, and pushes to the remote repository.
12. Opens the project in Visual Studio Code.

## Dependencies

The script relies on the following dependencies:

- Bash (Bourne Again SHell)
- curl (to interact with the GitHub API)
- yarn (to create the Vite project and manage packages)
- Git (to initialize and manage version control)

Make sure these dependencies are installed and accessible in the system before running the script.

## Usage

To use the script, follow these steps:

1. Copy the script code into a new file, e.g., `create_project.sh`.
2. Open the terminal and navigate to the directory containing the script file.
3. Make the script file executable by running the command: `chmod +x create_project.sh`.
4. Execute the script by running the command: `./create_project.sh`.
5. Follow the prompts and provide the necessary information as requested.
6. Wait for the script to complete the project creation process.

## Customization

To customize the script for your specific needs, consider the following:

- Replace the placeholder values `{YOUR_GITHUB_NAME}`, `{YOUR_GITHUB_EMAIL}`, and `{YOUR_GITHUB_TOKEN}` with your actual GitHub username, email, and token, respectively.
- Modify the package installations and configurations based on your project requirements.
- Customize the script messages, prompts, and error handling as desired.

Ensure that you understand the script's behavior and potential implications before making any modifications.

## Conclusion

The provided Bash script simplifies the process of creating a project, setting up a GitHub repository, configuring dependencies, and pushing the project to GitHub. By automating these tasks, it saves time and reduces manual effort. Feel free to customize the script according to your project needs and use it as a starting point for your own project creation automation.

