BEGIN {
	registerCommand("biereta", "command_biereta");
}

function command_biereta(service, parts,      command, hours, minutes, seconds, etaseconds) {
        command = "echo \"$(date +%s --date='17:00:00') - $(date +%s)\" | bc"
        command | getline etaseconds;
        close(command);

        hours = etaseconds / 3600;
        minutes = etaseconds % 3600 / 60;
        seconds = etaseconds % 60;

        if (hours <= 0 && minutes <= 0 && seconds <= 0) {
           print "PRIVMSG " parts[3] " :TIJD VOOR BIER!" |& service;
           return;
        }

        printf("PRIVMSG " parts[3] " :nog %d uur %d minuten en %d seconden\n", hours, minutes, seconds) |& service;
}
