#
# List of available commands
#
# Copyright (c) 2018.
# All rights reserved.
#

printf %s "\
available commands:
   all             execute all commands
   disk            create disk volume
      -d|diskname    sandbox name
   instance        create instance
      -i|instance    instance name
      -z|zone        zone
   firewall        setup firewall on ports
      -p|ports       ports to configure
"
