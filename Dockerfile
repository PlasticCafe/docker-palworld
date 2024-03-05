FROM cm2network/steamcmd:root as build 
ENV STEAMAPPID 2394010
ENV STEAMAPPDIR "${HOMEDIR}/Steam/steamapps/common/PalServer"
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
	wget \
        ca-certificates \
	lib32z1 

FROM build as base
USER ${USER}
WORKDIR ${STEAMAPPDIR} 
RUN mkdir -p ${HOMEDIR}/.steam/sdk64/ \
	&& bash ${STEAMCMDDIR}/steamcmd.sh +login anonymous +app_update 1007 +quit \
	&& bash ${STEAMCMDDIR}/steamcmd.sh +login anonymous +app_update ${STEAMAPPID} validate +quit \
	&& cp ${HOMEDIR}/Steam/steamapps/common/Steamworks\ SDK\ Redist/linux64/steamclient.so ${HOMEDIR}/.steam/sdk64/ 

ENTRYPOINT ./PalServer.sh port=6664 -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS EpicApp=PalServer 

