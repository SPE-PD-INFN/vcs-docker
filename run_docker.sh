docker run -e DISPLAY=$DISPLAY --rm --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -v /home/fmarini:/home/fmarini -v /eda:/eda -v /extra/eda:/extra/eda --net=host -w "$(pwd)" -it centos7-vcs
