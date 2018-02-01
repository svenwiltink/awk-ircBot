BEGIN {
    includeFile = "";
    while (("ls commands" | getline commandFile) > 0) {
        includeFile = includeFile "@include \"commands/" commandFile  "\"" "\n";
    }

    print includeFile > "commands.awk";
}

