@include "commands.awk";

BEGIN {
    RS = ORS = "\r\n"
    IRCService = "/inet/tcp/0/irc.freenode.net/6667"
    PROCINFO["/inet/tcp/0/irc.freenode.net/6667", "READ_TIMEOUT"] = 1000
    PROCINFO["/inet/tcp/0/irc.freenode.net/6667", "RETRY"] = 1

    login(IRCService);

    while(1==1) {
        checkIrcForInput(IRCService);
    }
    close(HttpService)
}

function login(service) {
   print "PASS " |&  service;
   print "NICK bananenbot" |& service;
   print "USER bananenbot irc.freenode.net bla : bananenbot" |& service;
}

function registerCommand(name, functionName) {
    print "trying to register command " name;
    commands[name] = functionName;
}

function registerListener(listenerName) {
    print "trying to register a listener " listenerName;
    listeners[listenerName] = listenerName;
}

function checkIrcForInput(service,          banaan, line, parts, i, cmdStart) {
    if (banaan = (service |& getline line) > 0) {
        print line;
        split(line, parts);
        if (parts[1] == "PING") {
            print "We've received a PING request";
            print "PONG" |& service;
            return;
        }

        if (parts[2] == "001") {
            print "JOIN \#bananentaart" |& service;
            return;
        }

        if (parts[2] == "PRIVMSG") {
            for(i in listeners) {
                if(@i(service, parts) == "stop") {
                    return;
                }
            }
        }

        cmdStart="^:!";
        if (parts[2] == "PRIVMSG" && parts[4] ~ cmdStart) {
            print "We've got a command";
            command = parts[4];
            sub(":!", "", command);
            if (command in commands) {
               print "we have found an existing command";
               functionName = commands[command];
               @functionName(service, parts);
               return;
            }

            print "PRIVMSG " parts[3] " :Unknown command" |& service;
        }

        return;
    }
}

function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }
