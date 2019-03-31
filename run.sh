#! /bin/bash
set -e

REPO_CORE=https://github.com/lightningnetwork/lnd
COMMIT_CORE=d2186cc9da29853091175189268b073f49586cf0

if [ "$root_dir" == '/repo' ]; then
	repos="${REPO_CORE}_${COMMIT_CORE}"
	for repo in ${repos}; do
	  TARGETHOST=armv7a-linux-androideabi
	  docker run -v $PWD:/repo debian:stretch /bin/bash -c "/repo/stretch_deps.sh && /repo/fetchbuild.sh ${repo/_/ } $TARGETHOST 32 /repo" &
	  TARGETHOST=aarch64-linux-android
	  docker run -v $PWD:/repo debian:stretch /bin/bash -c "/repo/fetchbuild.sh ${repo/_/ } $TARGETHOST 64 /repo" &
#	  TARGETHOST=x86_64-linux-android
#	  docker run -v $PWD:/repo debian:stretch /bin/bash -c "/repo/fetchbuild.sh ${repo/_/ } $TARGETHOST 64 /repo" &
#	  TARGETHOST=i686-linux-android
#	  docker run -v $PWD:/repo debian:stretch /bin/bash -c "/repo/fetchbuild.sh ${repo/_/ } $TARGETHOST 32 /repo" &
	done


	wait

	echo "DONE"
else
	#TARGETHOST=armv7a-linux-androideabi
	TARGETHOST=aarch64-linux-android
	./fetchbuild.sh $REPO_CORE $COMMIT_CORE $TARGETHOST 64 $PWD
fi

