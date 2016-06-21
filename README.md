OVERVIEW
--------

This is a collection of scripts and Cacti templates to graph the output from
[Starline Busway](http://starlinepower.com) systems.  I have included a pair of
host templates, one for endfeed units, and another for Critical Power Monitors
(CPMs).

Endfeed units have Load to Load (l2l) and Load to Neutral (l2n) voltage
graphs, as well as current and power usage graphs.  Power usage includes a 99-
percentile line.  These graphs enable the monitoring of
the overall health of a busway.

CPMs include all the graphs of the Endfeed units, as well as an SNMP query
to query and monitor outlets in each unit.  This allows for the monitoring of
the load at each CPM, as well as more granular outlet-level monitoring. Outlet-
level power templates also include a 99 percentile line suitable for billing.

The included scripts are written in Ruby, and requires the SNMP gem.  It also
requires the conversion of SNMP MIBs to compatible YAML files.  More info on
this nightmare can be found [here](http://snmplib.rubyforge.org).  For
convenience, I included the converted Starline MIB in here.  On my Cacti system, it's
path is `/var/lib/gems/1.9.1/gems/snmp-1.1.1/data/ruby/snmp/mibs/`.  ***YMMV***.

 The Cacti templates have all been exported from Cacti 0.8.8a.

Importing into newer versions of Cacti should work, but importing into previous versions of Cacti will probably not work - if you have problems with the
templates, please try upgrading first before reporting a bug.

INSTALLATION
------------

1. Copy snmp_queries/busway_outlets.xml to your Cacti server, and place it
under `<cacti_path>/resource/snmp_queries`. Under Debian/Ubuntu, this is
`/usr/share/cacti/resource/snmp_queries`, but may be different for other systems.
1. Copy the scripts/starline folder to your Cacti server, and place it under `<cacti_path>/scripts`.
1. Copy the `ruby_mibs/UEC-STARLINE-MIB.yaml` file to your Cacti server, and place it under the proper path for your system.
1. Log into your Cacti web interface, and click on "Import Templates". Import
all of the templates under the templates directory.

You should then be able to go to the host device you want to monitor, and add
the new data queries. Then, click on "Create Graphs for this Host", and
select the devices you want to graph.


FEEDBACK
--------
Any comments, criticism, bug reports, suggestions, fixes, etc. all appreciated!
