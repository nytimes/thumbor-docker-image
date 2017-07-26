FROM julianbei/alpine-opencv-microimage:p2-3.1 AS build
ENV THUMBOR_VERSION 6.3.2
RUN apk add --no-cache libjpeg-turbo-dev libpng-dev tiff-dev curl-dev jasper-dev
RUN pip install --upgrade pip
RUN pip install thumbor==${THUMBOR_VERSION}

FROM python:2-alpine
RUN apk add --no-cache libjpeg libpng tiff libcurl libjasper libstdc++ libdc1394 libwebp libgfortran
COPY --from=build /usr/local/lib /usr/local/lib
COPY --from=build /usr/lib/python2.7 /usr/lib/python2.7
COPY --from=build /usr/bin/thumbor /usr/bin/thumbor-config /usr/bin/thumbor-url /usr/bin/
COPY --from=build /usr/lib/libopenblas.so.3 /usr/lib/libopenblasp-r0.2.19.so /usr/lib/
RUN ln -s /usr/local/bin/python /usr/bin/python
ENV PYTHONPATH /usr/lib/python2.7/site-packages:/usr/local/lib/python2.7/site-packages

ENTRYPOINT ["/usr/bin/thumbor"]
EXPOSE 8888
