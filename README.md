[appurl]: https://rclone.org/
[docker-rclone-mount]: https://github.com/tynor88/docker-rclone-mount

# docker-rclone

Docker for [Rclone][appurl] - a command line program to sync files and directories to and from various cloud services.

**Cloud Services**
* Google Drive
* Amazon S3
* Openstack Swift / Rackspace cloud files / Memset Memstore
* Dropbox
* Google Cloud Storage
* Amazon Drive
* Microsoft One Drive
* Hubic
* Backblaze B2
* Yandex Disk
* The local filesystem

The default command is set to prevent Google Drive upload quota limit of 750Gb per 24hour by limiting the upload speed to 9M/seg.

**Features**

* MD5/SHA1 hashes checked at all times for file integrity
* Timestamps preserved on files
* Partial syncs supported on a whole file basis
* Copy mode to just copy new/changed files
* Sync (one way) mode to make a directory identical
* Check mode to check for file hash equality
* Can sync to and from network, eg two different cloud accounts
* Optional encryption (Crypt)

## Usage

```
docker create \
  --name=Rclone \
  -e DESTINATION=<sync destination from rclone.conf> \
  -v </path for rclone.conf>:/config \
  -v </path for data to backup>:/data \
  kyosfonica/rclone
```

**Parameters**

* `-v /config` The path where the rclone.conf file is located
* `-v /data` The path to the data which should be backed up by Rclone
* `-e RCLONE_CONFIG_PASS` If the rclone.conf is encrypted, specify the password here (Optional)
* `-e DESTINATION` The destination where the data should be backed up to (must be the same name as specified in rclone.conf)
* `-e DESTINATION_SUBPATH` If the data should be backed up to a subpath on the destination (will automaticaly be created if it does not exist) (Optional)
* `-e CRON_SCHEDULE` A custom cron schedule which will override the default value of: 0 * * * * (hourly) (Optional)
* `-e COMMAND` A custom rclone command which will override the default value of: rclone copy --transfers=2 --checkers=8 --bwlimit=9M /data $DESTINATION:/$DESTINATION_SUBPATH (Optional)


## Info

* Shell access whilst the container is running: `docker exec -it Rclone /bin/ash`
* To monitor the logs of the container in realtime: `docker logs -f Rclone`
