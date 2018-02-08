BEGIN {
    loadKarma();
    registerListener("command_karma");
}

function command_karma(service, parts       ,karmaStart, matches) {
    karmaStart="^:!([^\\+\\-]+){1}(\\+\\+|--){1}$";
    if (parts[2] == "PRIVMSG" && parts[4] ~ karmaStart) {
       print "we've got karma\!"; 
       match(parts[4], "^:!([^\\+\\-]+){1}(\\+\\+|--){1}$", matches);
       if (matches[2] == "++") {
           karma[matches[1]] = karma[matches[1]] + 1;
       }

       if (matches[2] == "--") {
           karma[matches[1]] = karma[matches[1]] - 1;
       }

       writeKarma();
       print "PRIVMSG " parts[3] " :" matches[1] " now has " karma[matches[1]] " karma" |& service;
       return "stop";
    }
}


function loadKarma(	line, parts) {
  print "loading karma";
  while(( getline line<"karmastore.txt") > 0 ) {
    split(line, parts);
    karma[parts[1]] = parts[2];
    print parts[1] " - " parts[2];
  }

  close("karmastore.txt");
}


function writeKarma(	name, value) {
  for(name in karma) {
    value = karma[name];
    print name " " value > "karmastore.txt";
  }

  close("karmastore.txt");
}
