# Server Scripts
#### Setting up Anaconda and Google Drive integration + setting a clean environment for new projects

This package is based on a script by Nadav Oved.

## Usage
The scripts should be downloaded and moved to ~/bin/, and given execution permissions.

### Setting up a new project environment
When starting work on a new project in the server, we need the following items:
  - Project name
  - ID of project datasets directory in Google Drive (can be extracted from the directory URL in the browser)
  - ID of project experiments directory in Google Drive (can be extracted from the directory URL in the browser)
  - A .yml file describing the needed anaconda environment (can be produced from an existing environment using `conda env export > my_env.yml`)
  - Username of the github repository owner (The repository path is `https://github.com/${OWNER_USERNAME}/${PROJECT_NAME}.git`

Once you have these, just execute:
  `>> setup_project.sh PROJECT_NAME DATASETS_ID EXPERIMENTS_ID CONDA_YML OWNER_USERNAME`
During the execution, you will need to provide:
  - Authorization from Google Drive (You will be given a link. Post it in your browser, choose the relevant Google account and post the resulting link in the terminal).
  - Read and accept the Anaconda terms and conditions (if the script needs to install anaconda)
  - Accept the installation of python packages by anaconda (simply type 'Y' when prompted).
 
After the execution, check that it worked. If your project name was "TestProject"
  `>> TestProject_env`
 
 This should activate the corresponding anaconda environment. If the command is not recognized, run `source ~/.bash_profile` and try again.
 
 ### Setting up utilities unrelated to project
 If you want to set up Google Drive or Anaconda without downloading any project, simply run `setup_drive.sh` or `setup_anaconda.sh`.
