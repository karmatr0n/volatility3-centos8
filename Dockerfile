FROM centos:centos8

ENV YARA_VERSION 4.0.2
ENV YARA_PY_VERSION 4.0.2

RUN yum -y groupinstall "Development Tools"
RUN yum -y install python3-setuptools \
      openssl-devel \
      python38-devel \
      jansson-devel 

RUN curl -L -O http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/file-devel-5.33-16.el8.x86_64.rpm
RUN yum install -y file-devel-5.33-16.el8.x86_64.rpm \
  && set -x \
  && echo "Install Yara from source..." \
  && cd /tmp/ \
  && git clone --recursive --branch v$YARA_VERSION https://github.com/VirusTotal/yara.git \
  && cd /tmp/yara \
  && ./bootstrap.sh \
  && sync \
  && ./configure --prefix=/usr --with-crypto \
  --enable-magic \
  --enable-cuckoo \
  --enable-dotnet \
  && make \
  && make install \
  && echo "Install yara-python..." \
  && cd /tmp/ \
  && git clone --recursive --branch v$YARA_PY_VERSION https://github.com/VirusTotal/yara-python \
  && cd yara-python \
  && python3 setup.py build --dynamic-linking \
  && python3 setup.py install 

RUN yum -y install epel-release \
  && yum repolist \
  && yum install -y golang golang-bin golang-x-sys-devel\
  && set -x \
  && cd /tmp/ \
  && git clone https://github.com/volatilityfoundation/dwarf2json.git \
  && cd dwarf2json \
  && go build \
  && mv dwarf2json /usr/bin 

RUN yum install -y capstone capstone-devel python3-capstone \
  && pip3 install pycryptodome \
  && pip3 install pefile \
  && cd /tmp/ \
  && git clone https://github.com/volatilityfoundation/volatility3.git

RUN cd /tmp/volatility3/volatility/symbols \
  && curl -fL https://downloads.volatilityfoundation.org/volatility3/symbols/linux.zip -o linux.zip \
  && curl -fL https://downloads.volatilityfoundation.org/volatility3/symbols/mac.zip -o mac.zip \
  && curl -fL https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip -o windows.zip

VOLUME /data
WORKDIR /tmp/volatility3

ENTRYPOINT ["/bin/bash"]
