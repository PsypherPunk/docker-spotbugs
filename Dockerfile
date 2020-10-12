FROM openjdk:8

RUN mkdir -p /spotbugs

WORKDIR /spotbugs

RUN echo -e "b815b43f9eef93c378de89124ba9bb3f9698a873d57ee2140241ea344b75b123  spotbugs-4.1.3.zip\nc6d621846943f92839abc01ea8fee4a318ed881b1b38f3c87593a17a3de0c3da  findsecbugs-cli-1.10.1.zip" > sha256sum.txt && \
    wget --quiet https://github.com/spotbugs/spotbugs/releases/download/4.1.3/spotbugs-4.1.3.zip && \
    wget --quiet https://github.com/find-sec-bugs/find-sec-bugs/releases/download/version-1.10.1/findsecbugs-cli-1.10.1.zip && \
    sha256sum -c sha256sum.txt && \
    unzip -o spotbugs-4.1.3.zip && \
    rm spotbugs-4.1.3.zip && \
    unzip -oj findsecbugs-cli-1.10.1.zip lib/findsecbugs-plugin-1.10.1.jar && \
    rm findsecbugs-cli-1.10.1.zip

RUN groupadd -g 999 spotbugs && \
    useradd -r -u 999 -g spotbugs spotbugs && \
    chown -R spotbugs:spotbugs /spotbugs

USER spotbugs:spotbugs

CMD ["java",                                       \
     "-jar",                                       \
     "/spotbugs/spotbugs-4.1.3/lib/spotbugs.jar", \
     "-textui",                                    \
     "-html",                                      \
     "-exitcode",                                  \
     "-pluginList",                                \
     "/spotbugs/findsecbugs-plugin-1.10.1.jar",     \
     "/spotbugs/build/"]

