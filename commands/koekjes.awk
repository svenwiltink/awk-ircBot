BEGIN {
    registerCommand("koekjes",  "command_koekjes");
}
function command_koekjes(service, parts) {
    print "PRIVMSG " parts[3] " :zijn fucking lekkah" |& service;
}
