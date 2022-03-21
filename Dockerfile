FROM openjdk:8

RUN mkdir -p /spotbugs

WORKDIR /spotbugs

ENV spotbugs_version="4.6.0"
ENV spotbugs_checksum="8486f721d80e62c300fd2db5076badac3d969b596904c23f429c922a03041ac0"
ENV findsecbugs_version="1.11.0"
ENV findsecbugs_checksum="3f6e5af3a19e7f0ad1d07a30a3c2afa3d4d822a261ed893b57fe89ed336f04cb"

RUN set -o errexit && \
    printf '%s  spotbugs-%s.zip\n%s  findsecbugs-cli-%s.zip' "${spotbugs_checksum}" "${spotbugs_version}" "${findsecbugs_checksum}" "${findsecbugs_version}" > sha256sum.txt && \
    wget --quiet "https://github.com/spotbugs/spotbugs/releases/download/${spotbugs_version}/spotbugs-${spotbugs_version}.zip" && \
    wget --quiet "https://github.com/find-sec-bugs/find-sec-bugs/releases/download/version-${findsecbugs_version}/findsecbugs-cli-${findsecbugs_version}.zip" && \
    sha256sum -c sha256sum.txt && \
    unzip -o "spotbugs-${spotbugs_version}.zip" && \
    rm "spotbugs-${spotbugs_version}.zip" && \
    unzip -oj "findsecbugs-cli-${findsecbugs_version}.zip" "lib/findsecbugs-plugin-${findsecbugs_version}.jar" && \
    rm "findsecbugs-cli-${findsecbugs_version}.zip"

RUN groupadd -g 999 spotbugs && \
    useradd -r -u 999 -g spotbugs spotbugs && \
    chown -R spotbugs:spotbugs /spotbugs

USER spotbugs:spotbugs

CMD ["java",                                       \
     "-jar",                                       \
     "/spotbugs/spotbugs-${spotbugs_version}/lib/spotbugs.jar", \
     "-textui",                                    \
     "-html",                                      \
     "-exitcode",                                  \
     "-pluginList",                                \
     "/spotbugs/findsecbugs-plugin-${findsecbugs_version}.jar",     \
     "/spotbugs/build/"]

