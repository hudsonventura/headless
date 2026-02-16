FROM hudsonventura/headless:ubuntu_24.04


RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    sudo apt update

RUN sudo apt install -y fonts-liberation libasound2t64 libnspr4 libnss3 xdg-utils && \
    sudo apt install -y ./google-chrome-stable_current_amd64.deb*

# Wrap Google Chrome to run with --no-sandbox to avoid needing privileged container modes
RUN sudo mv /usr/bin/google-chrome-stable /usr/bin/google-chrome-stable.real && \
    printf '#!/bin/bash\nexec /usr/bin/google-chrome-stable.real --no-sandbox --disable-dev-shm-usage "$@"\n' | sudo tee /usr/bin/google-chrome-stable && \
    sudo chmod +x /usr/bin/google-chrome-stable
