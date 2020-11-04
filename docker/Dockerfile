# SPDX-FileCopyrightText: 2020 SAP SE or an SAP affiliate company and Gardener contributors
#
# SPDX-License-Identifier: Apache-2.0

FROM raviqqe/liche:0.2.0 AS liche
FROM eu.gcr.io/gardener-project/cc/job-image:1.816.0 AS docs-toolbelt

# install hunspell
ARG HUNSPELL_BASE_URL="http://download.services.openoffice.org/contrib/dictionaries"

RUN apk add --no-cache \
    hunspell 

RUN mkdir -p /tmp/hunspell /usr/share/hunspell \
  && { \
       echo "5869d8bd80eb2eb328ebe36b356348de4ae2acb1db6df39d1717d33f89f63728  en_GB.zip"; \
       echo "9227f658f182c9cece797352f041a888134765c11bffc91951c010a73187baea  en_US.zip"; \
     } > /tmp/hunspell-sha256sum.txt \
  && cd /tmp/hunspell \
  && for file in $(awk '{print $2}' /tmp/hunspell-sha256sum.txt); do \
       wget -O "${file}" "${HUNSPELL_BASE_URL}/${file}"; \
       grep "${file}" /tmp/hunspell-sha256sum.txt | sha256sum -c -; \
       unzip "/tmp/hunspell/${file}"; \
     done \
  && cp *.aff *.dic /usr/share/hunspell \
  && rm -rf /tmp/*

RUN ln -s /usr/share/hunspell/en_US.aff /usr/share/hunspell/default.aff \
  && ln -s /usr/share/hunspell/en_US.dic /usr/share/hunspell/default.dic

# install proselint
RUN pip install --no-cache-dir proselint


RUN apk add --update libc6-compat libstdc++ nodejs npm \
    && addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/bash -D node
# install write good
RUN npm install -g write-good

# install markdownlint
RUN npm install markdownlint-cli2 --global

# install liche
COPY --from=liche /liche /usr/local/bin/liche

# RUN npm install broken-link-checker -g

WORKDIR /workdir

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY help-toolbelt /usr/local/bin/help-toolbelt
COPY VERSION /etc/ops-toolbelt/VERSION
ENTRYPOINT ["entrypoint.sh"]
CMD ["help-toolbelt"]
