#!/bin/bash


# Script to set up project requirements (create/pull drive folder, conda environment)
# Arguments:
#   $1 - project name
#   $2 - Google Drive ID for the datasets folder (extracted from the directory URL in the browser).
#   $3 - Google Drive ID for the experiments folder (extracted from the directory URL in the browser).
#   $4 - Path to .yml file for conda setup.
#   $5 - Git username of the repository owner (for cloning).

if [ ! -d $HOME/bin/go ] || [ ! -d $HOME/GoogleDrive/ ]
then
    ~/bin/setup_drive.sh
fi

PROJECT_NAME=$1

echo "Setting up project folder in drive..."

echo "export ${PROJECT_NAME}_HOME=\$HOME/GoogleDrive/Research/${PROJECT_NAME}/" >> ~/.bash_profile

echo "export ${PROJECT_NAME}_DATASETS_ID='$2'" >> ~/.bash_profile
echo "export ${PROJECT_NAME}_EXPERIMENTS_ID='$3'" >> ~/.bash_profile

echo "alias '${PROJECT_NAME}_drive_push'='cd \$${PROJECT_NAME}_HOME && drive push -verbose -files -fix-clashes'" >> ~/.bash_profile
echo "alias '${PROJECT_NAME}_drive_pull'='cd \$${PROJECT_NAME}_HOME && drive pull -verbose -id \$1'" >> ~/.bash_profile

cd ~/GoogleDrive/
drive init
mkdir -p ~/GoogleDrive/Research/${PROJECT_NAME}/
cd ~/GoogleDrive/Research/${PROJECT_NAME}/
drive pull -verbose -no-prompt -id $2 # sync Datasets from Google Drive
drive pull -verbose -no-prompt -id $3 # sync Experiments from Google Drive

echo "Setting up anaconda environment..."

if [ ! -d $HOME/anaconda3/ ]
then
    ~/bin/setup_anaconda.sh
fi

source ~/anaconda3/etc/profile.d/conda.sh
conda env create --file $4 --name ${PROJECT_NAME}
conda activate ${PROJECT_NAME}

# Optional: install apex
# if [ ! -d "$HOME/dev/apex/" ]
# then
#   cd $HOME/dev/
#   git clone https://github.com/NVIDIA/apex
# fi
# cd $HOME/dev/apex/
# git pull
# pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./

conda deactivate

# Clone project from github
if [ ! -d "$HOME/dev/${PROJECT_NAME}/" ]
then
  echo "Clone ${PROJECT_NAME} git repository from user $4..."
  mkdir -p ~/dev
  cd ~/dev/
  git clone https://github.com/$5/${PROJECT_NAME}.git
  echo "export ${PROJECT_NAME}_REPO=\$HOME/dev/${PROJECT_NAME}/" >> ~/.bash_profile
fi
echo "alias '${PROJECT_NAME}_env'='conda_env && conda activate ${PROJECT_NAME} && export PYTHONPATH=\$${PROJECT_NAME}_REPO:\$PYTHONPATH && cd \$${PROJECT_NAME}_REPO'" >> ~/.bash_profile

source ~/.bash_profile