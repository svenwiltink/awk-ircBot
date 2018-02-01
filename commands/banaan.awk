BEGIN {
    registerCommand("banaan",  "command_banaan");
}
function command_banaan(service, parts) {
    print "PRIVMSG " parts[3] " :BANAAN!" |& service;
}
