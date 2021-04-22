# deploy-ceph-monitor

Deploys a monitor on ceph clusters on proxmox.

I use this for proxmox to workaround the unability to use multiple ceph networks in the config.
The error I have on proxmox is 
```
Error: any valid prefix is expected rather than "192.168.1.10/24, 10.0.10.0/24".
command '/sbin/ip address show to '192.168.1.10/24, 10.0.10.0/24' up' failed: exit code 1
```

you need to change the PUBLIC_ADDR variable to match you public-addr network from the ceph.conf configuration file

