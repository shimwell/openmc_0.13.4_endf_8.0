

FROM mcr.microsoft.com/vscode/devcontainers/miniconda:0-3

RUN sudo apt-get -y update
RUN sudo apt install -y g++ cmake libhdf5-dev libpng-dev
RUN sudo apt install -y libgl1-mesa-glx
RUN sudo apt-get install -y git

RUN git clone --recurse-submodules https://github.com/openmc-dev/openmc.git
RUN cd openmc && mkdir build 
RUN cd openmc/build &&  cmake ..
RUN cd openmc/build &&  make
RUN cd openmc/build &&  make install
RUN cd openmc && pip install .


RUN pip install openmc_data_downloader
RUN pip install vtk

RUN sudo mkdir -m 777 -p /usr/nuclear_data

RUN openmc_data_downloader -d /usr/nuclear_data -l ENDFB-8.0-NNDC TENDL-2019 -p neutron photon -e all -i H3 --no-overwrite

RUN pip install openmc_data && \
    download_endf_chain -d /usr/nuclear_data -r b8.0

ENV OPENMC_CROSS_SECTIONS=/usr/nuclear_data/cross_sections.xml
ENV OPENMC_CHAIN_FILE=/usr/nuclear_data/chain-endf-b8.0.xml
