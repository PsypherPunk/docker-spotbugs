FROM openjdk:8

RUN mkdir -p /spotbugs

WORKDIR /spotbugs

RUN echo -e "da234794c8947c92db89f79b4ced7b2df0bf40a6  spotbugs-4.0.1.zip\nfad67bc6c31032dd3cf7419c1f4abe2376658757  findsecbugs-cli-1.10.1.zip" > sha1sum.txt && \
    wget --quiet https://github.com/spotbugs/spotbugs/releases/download/4.0.1/spotbugs-4.0.1.zip && \
    wget --quiet https://github.com/find-sec-bugs/find-sec-bugs/releases/download/version-1.10.1/findsecbugs-cli-1.10.1.zip && \
    sha1sum -c sha1sum.txt && \
    unzip -o spotbugs-4.0.1.zip && \
    rm spotbugs-4.0.1.zip && \
    unzip -oj findsecbugs-cli-1.10.1.zip lib/findsecbugs-plugin-1.10.1.jar && \
    rm findsecbugs-cli-1.10.1.zip

RUN groupadd -g 999 spotbugs && \
    useradd -r -u 999 -g spotbugs spotbugs && \
    chown -R spotbugs:spotbugs /spotbugs

USER spotbugs:spotbugs

CMD ["java",                                       \
     "-jar",                                       \
     "/spotbugs/spotbugs-4.0.1/lib/spotbugs.jar", \
     "-textui",                                    \
     "-html",                                      \
     "-exitcode",                                  \
     "-pluginList",                                \
     "/spotbugs/findsecbugs-plugin-1.10.1.jar",     \
     "/spotbugs/build/"]

