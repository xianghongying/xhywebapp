FROM registry.cn-hangzhou.aliyuncs.com/xhyimages/xhyubuntu:26.04
MAINTAINER Xianghy <xhy@itzgr.com>
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip3 install --break-system-packages -qr /tmp/requirements.txt
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp
EXPOSE 5000
CMD ["python3", "app.py"]
