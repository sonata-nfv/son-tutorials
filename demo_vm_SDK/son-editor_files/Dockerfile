FROM tiangolo/uwsgi-nginx-flask:flask-python3.5

#install infconfig
RUN apt-get update
RUN apt-get install -y net-tools 

# install son-cli
RUN git clone https://github.com/sonata-nfv/son-cli.git
WORKDIR son-cli/
RUN git reset --hard c3a20faab34d37b3d74753a4a09b8ac88d336f19
RUN pip3 install numpy scipy matplotlib
RUN python3 setup.py install
WORKDIR /

#install the son-editor-frontend
RUN git clone https://github.com/sonata-nfv/son-editor-frontend /var/www/
WORKDIR /var/www/son-editor-frontend
RUN git reset --hard 601a819154e3aaea61523ee875259f715798e632
COPY ./constants.js /var/www/js/constants.js
WORKDIR /

#install the son-editor-backend
RUN rm -rf /app
RUN git clone https://github.com/sonata-nfv/son-editor-backend.git /app
#COPY . /app
WORKDIR /app
RUN git reset --hard f9f175569cba67132ca993a47f4d97cf52285c95
RUN pip install -e .
COPY ./config.yaml /app/src/son_editor/config.yaml

# load nginx config
COPY ./nginx.conf /etc/nginx/conf.d/nginx.conf
COPY ./uwsgi.ini /app/uwsgi.ini


EXPOSE 80
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 777 entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
