#!/bin/bash
echo "Starting to set up Anaconda environment in 5 seconds..."
sleep 5
mkdir ~/bin
cd ~/bin
wget https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
bash Anaconda3-2019.03-Linux-x86_64.sh
source ~/anaconda3/etc/profile.d/conda.sh

echo "Conda PyTorch Env Setup"
conda create --name pytorch
conda activate pytorch
conda install -y pip numpy scipy pandas tabulate six requests beautifulsoup4 nltk h5py lxml numexpr scikit-learn matplotlib spacy boto3 ftfy pyyaml
conda install -y pytorch torchvision cudatoolkit -c pytorch
conda install -y cudnn
conda deactivate

echo "Conda Keras Env Setup"
conda create --name keras
conda activate keras
conda install -y pip numpy scipy pandas tabulate six requests beautifulsoup4 nltk h5py lxml numexpr scikit-learn matplotlib boto3 spacy
conda install -y tensorflow-gpu keras cudnn
conda deactivate

echo "Conda AllenNLP Env Setup"
conda create --name allennlp
conda activate allennlp
conda install -y pip tensorflow-gpu cudnn mkl pandas tabulate tqdm cython seaborn beautifulsoup4 scikit-learn numpy scipy nltk lxml matplotlib
pip install allennlp ray torchvision ignite textacy
conda deactivate

echo "Conda BERT Env Setup"
conda create --name bert
conda activate bert
conda install -y pip tensorflow-gpu cudnn mkl pandas tabulate tqdm cython seaborn beautifulsoup4 scikit-learn numpy scipy nltk lxml matplotlib
conda install -y pytorch torchvision ignite cudatoolkit -c pytorch
pip install pytorch-pretrained-bert ray textacy
pip install --upgrade botocore
conda deactivate

# echo "Clone git repository"
# mkdir -p ~/dev
# cd ~/dev/
# git clone <link to your github repo>
# echo "export MOOD_REPO=\$HOME/dev/Mood/" >> ~/.bash_profile

# echo "Google Drive Setup"
# cd ~/bin
# wget https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
# tar -xzvf go1.12.4.linux-amd64.tar.gz
# mkdir -p $HOME/bin/go/packages
# echo "export GOROOT=\$HOME/bin/go" >> ~/.bash_profile
# echo "export GOPATH=\$GOROOT/packages" >> ~/.bash_profile
# echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> ~/.bash_profile
# source ~/.bash_profile
# go get -u -v github.com/odeke-em/drive/cmd/drive
# drive init ~/GoogleDrive

echo "Creating aliases"
echo "alias 'conda_env'='source \$HOME/anaconda3/etc/profile.d/conda.sh'" >> ~/.bash_profile
echo "alias 'pytorch_env'='conda_env && conda activate pytorch'" >> ~/.bash_profile
echo "alias 'mood_keras'='conda_env && conda activate keras'" >> ~/.bash_profile
echo "alias 'mood_allennlp'='conda_env && conda activate allennlp'" >> ~/.bash_profile
echo "alias 'mood_bert'='conda_env && conda activate bert'" >> ~/.bash_profile
echo "alias 'lla'='ls -lhtra'" >> ~/.bash_profile
source ~/.bash_profile

echo "Finished setting up Anaconda environment!"
