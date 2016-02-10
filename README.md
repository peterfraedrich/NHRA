# NHRA
What like the drag racing series? **no**

**NHRA** stands for **Nagios Host RESTful API**. NHRA is a RESTful API for adding/removing hosts from a Nagios configuration. This was in response to the stupid decision of the developers to make operations engineers update text files by hand.

### Why do I need this?
Unless you like writing text files by hand, then you probably need this.

### How does it work?
Instead of parsing Nagios `.cfg` files, we just back them up and dump from a MongoDB database that NHRA maintains. Whenever a host is added through the API, the details are saved into a MongoDB database, then dumped to a clean copy of the `hosts.cfg`.

### How do I use it?
Once the daemon (`nhra.service`) is running, you can update the hosts through the URL. See the `API` documentation below.

### Any weird things I should know about?
Right now NHRA only supports using a template called `linux-default`. This will change, but for now you're SOL.

## API
All HTTP hooks are `GET`, because it makes it easy to use a browser or curl or whatnot.

All requests should be in the format of `http://someurl/<method>?param=value&param=value...`

Valid params (HTTP queries, really) are as follows:
```c++
key=<key>                   // your API key, an 8-character string
hostname=<hostname>         // the FQDN of the host you are adding. this is the database key so it must be unique.
ip=<ip_address>             // IP address of the host you are adding
alias=<alias>               // the friendly name of the host. Nagios uses this, IDGAF what you put as long as its a string. 
```

As of right now there are only 2 API hooks:
```c++
/add                        // adds a host to the config
/remove                     // removes a host from the config
```

### API Key
Each server, on first-run, generates an 8-character key based on an UUID. This is to keep unauthorized scripts/people from updating the configuration files. This is what I'm calling 'lazy authentication'. If someone really wants to get past it, they could, but this way keeps the casual interloper from f---ing everything up. The key must be supplied with all queries else you will get an error message.

 The API key can be found in `/etc/nhra/nhra.conf`.

### Examples

To add a host:
```C++
Server to add:              172.16.10.1
FQDN:                       app1.hexapp.net
Alias:                      APP_1
API Key:                    abcd1234

Command:
$> curl http://nagios.hexapp.net:5000/add?key=abcd1234&ip=172.16.10.1&hostname=app1.hexapp.net&alias=APP_1
200
```

To remove a host:
```C++
FQDN to remove:             oldDB.hexapp.net
API Key:                    abcd1234

Command:
$> curl http://nagios.hexapp.net:5000/add?key=abcd1234&hostname=oldDB.hexapp.net
200
```

### Known Bugs
None?

### Acknowledgements
`NHRA` uses some pretty cool open-source software:
* `pymongo` (Apache)[http://choosealicense.com/licenses/apache-2.0/] -- https://github.com/mongodb/mongo-python-driver
* `flask` (BSD)[http://choosealicense.com/licenses/isc/] -- http://flask.pocoo.org/