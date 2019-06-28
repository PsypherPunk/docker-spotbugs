FROM openjdk:8

RUN mkdir -p /spotbugs

WORKDIR /spotbugs

RUN echo -e "\n3b800628cea8338030f33874fcf6d21425b9ed59 spotbugs-3.1.12.zip\nf8b7b42c7008ad126ac12b5ee4ade33ca9ef56a1 findsecbugs-plugin-1.9.0.jar" > sha1sum.txt && \
    wget --quiet http://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/3.1.12/spotbugs-3.1.12.zip && \
    wget --quiet http://repo.maven.apache.org/maven2/com/h3xstream/findsecbugs/findsecbugs-plugin/1.9.0/findsecbugs-plugin-1.9.0.jar && \
    sha1sum -c sha1sum.txt && \
    unzip spotbugs-3.1.12.zip && \
    rm spotbugs-3.1.12.zip

RUN groupadd -g 999 spotbugs && \
    useradd -r -u 999 -g spotbugs spotbugs && \
    chown -R spotbugs:spotbugs /spotbugs

USER spotbugs:spotbugs

CMD ["java",                                       \
     "-jar",                                       \
     "/spotbugs/spotbugs-3.1.12/lib/spotbugs.jar", \
     "-textui",                                    \
     "-html",                                      \
     "-exitcode",                                  \
     "-pluginList",                                \
     "/spotbugs/findsecbugs-plugin-1.9.0.jar",     \
     "/spotbugs/build/"]

