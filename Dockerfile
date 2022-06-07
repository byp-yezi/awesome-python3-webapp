FROM ubuntu:20.04


RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN sed -i 's#http://archive.ubuntu.com/#http://mirrors.tuna.tsinghua.edu.cn/#' /etc/apt/sources.list \
    && sed -i 's#http://security.ubuntu.com/#http://mirrors.tuna.tsinghua.edu.cn/#' /etc/apt/sources.list

RUN apt-get update -y \
    && apt-get -y install python3.9 \
    && apt-get -y install python3-pip python3-dev \
    && cd /usr/local/bin \
    && rm -f python \
    && rm -f python3 \
    && rm -f pip \
    && rm -f pip3 \
    && ln -s /usr/bin/python3.9 python \
    && ln -s /usr/bin/python3.9 python3 \
    && ln -s /usr/bin/pip3 pip \
    && ln -s /usr/bin/pip3 pip3 \
    && python -m pip install --upgrade pip \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

COPY ./requirements.txt /requirements.txt

WORKDIR /

RUN python3 -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

COPY . /

#设置环境变量
ENV TZ Asia/Shanghai
ENV LANG zh_CN.UTF-8

ENTRYPOINT [ "python3" ]

CMD [ "app/app.py" ]