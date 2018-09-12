FROM osrf/ros:melodic-desktop-full-bionic

RUN rm -rf /var/lib/apt/lists/*

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# ==================
# below sourced from https://gitlab.com/nvidia/opengl/blob/ubuntu18.04/base/Dockerfile

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
        libxau6 libxau6:i386 \
        libxdmcp6 libxdmcp6:i386 \
        libxcb1 libxcb1:i386 \
        libxext6 libxext6:i386 \
        libx11-6 libx11-6:i386 && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# ==================
# below sourced from https://gitlab.com/nvidia/opengl/blob/ubuntu18.04/glvnd/runtime/Dockerfile

RUN apt-get update && apt-get install -y --no-install-recommends \
    	libglvnd0 libglvnd0:i386 \
	libgl1 libgl1:i386 \
	libglx0 libglx0:i386 \
	libegl1 libegl1:i386 \
	libgles2 libgles2:i386 && \
    rm -rf /var/lib/apt/lists/*

COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# ==================
# install CUDA 9.1 with nvidia390 dirver(known compatible and supported for ubuntu 18.04)

 #nvidia-390
RUN apt-get update && apt install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository -y ppa:graphics-drivers/ppa 

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nvidia-390
COPY ./keyboard /etc/default/keyboard

RUN apt-get update && apt-get install -y --no-install-recommends nvidia-cuda-toolkit gcc-6

# nvidia-container-runtime
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.1"
