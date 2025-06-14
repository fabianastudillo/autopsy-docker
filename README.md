# Autopsy

Dockerfile for building the version 4.22.1 of Autopsy for Linux.

## Run
Note: The `xhost +` command is in the documentation for convienience. It is a security risk (https://laurentschneider.com/wordpress/2007/03/xhost-is-a-huge-security-hole.html). If you have concerns about your X security, please using xauth instead.

## Using Docker

I based this dockerfile in [source](https://github.com/bannsec/autopsy_docker/). I decide to generate my own container because I want to run the last version of the Autopsy (4.22.1).

```
$ xhost +
$ docker run \
            -d \
            -it \
            --shm-size 2G \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v $(pwd)/case/:/root/case \
            -e DISPLAY=$DISPLAY \
            -e JAVA_TOOL_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel' \
            --network host \
            --device /dev/dri \
            bannsec/autopsy
```

## Using Docker Compose

Just run:

```
$ docker-compose build
$ xhost + && docker-compose up -d
```

## Loading an image file for a case

The volume mounted in the local folder `./case/` should be used to share disk
images and cases files, so put here your evidence and load it in the Autopsy
wizard.
