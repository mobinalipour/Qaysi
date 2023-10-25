# QAYSI

A script for reverse tunnel between two servers

Reverse tunnel is one of the types of tunneling method between two servers and it can be said that it is the most used for those who set up a virtual private network in countries like Iran, China, Russia, etc.

The advantage that the reverse tunnel method provides is that it will work well if the external server or the second server is censored, and it will solve the problem of censoring the external server or the second server which is done by governments.

The steps of implementing the reverse tunnel method are well explained in this link, and Qaysi was created to make all these steps faster and solve the complexity of this method for non-technical users.
## Some of the features

- One command run
- user friendly
- Great for non technical users
- Set cron job for increased stability
- and more ...

## Run

Just run following command on your second/censored/filtered server

```bash
    bash <(curl -s https://raw.githubusercontent.com/mobinalipour/Qaysi/main/Qaysi.sh)
```
    
## Usage

Make sure to run the Qaysi script on the filtered/censored/second server.

After running the script, it will install the required packages (sshpass), and then it will ask you for the free/first server information, and by entering the information, it will start setting up the tunnel, and after the completion, it will show you the completed steps.

After the execution of the script, a service names qaysi will be created on your OS, which you can tunnel more ports in the future by running the following commands:

``` bash
    systemctl start qaysi@the_port_you_want
```
``` bash
    systemctl enable qaysi@the_port_you_want
```

and then you should create cron job for new tunneled ports. enter below command to view all other cron jobs and enter new cron job :
```bash
    crontab -e
```

or you can just run Qaysi one more time to set more new port to get tunneled.
## Thanks to
Mohmmad Hossein Gholi Nasab LINK
