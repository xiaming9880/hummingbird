# basic setup
FROM ubuntu:18.04
RUN apt-get update && apt-get -y update
RUN apt-get install -y build-essential python3.7 python3-pip git

# Register the version in alternatives
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1

# Set python 3 as the default python
RUN update-alternatives --set python /usr/bin/python3.7

RUN pip3 -q install pip --upgrade

# Install HB
RUN pip3 install hummingbird-ml

# Install HB dev tools
RUN pip3 install flake8 coverage autopep8 jupyter pre-commit

# Jupyter
EXPOSE 8888

# Create a new system user
RUN useradd -ms /bin/bash jupyter

# Change to this new user
USER jupyter

# Pull repo to get notebooks
RUN cd ~/ &&  git clone https://github.com/microsoft/hummingbird.git

# Install precommit hooks
RUN cd ~/hummingbird && pre-commit install

# Set the container working directory to the user home folder
WORKDIR /home/jupyter/hummingbird/notebooks

# Start the jupyter notebook
ENTRYPOINT ["jupyter", "notebook", "--ip=*"]
