FROM rocker/shiny

COPY --chmod=755 ./scripts/install_reqs.sh /rocker_scripts/install_reqs.sh
RUN /rocker_scripts/install_reqs.sh

COPY . /srv/shiny-server/