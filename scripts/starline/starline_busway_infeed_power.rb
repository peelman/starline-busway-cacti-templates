#!/usr/bin/env ruby
#
# Copyright (C) 2016 Nick Peelman <nick@peelman.us>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'snmp'
require 'optparse'

options = {}
@parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options]"
  opts.release = "0.1"

  opts.on('-H', '--host HOSTNAME', 'REQUIRED: Busway IP or Hostname') do |h|
    options[:host] = h
  end

  opts.on('-c', '--community COMMUNITY', 'SNMP Community String') do |c|
    options[:community] = c
  end

  opts.on('-v', '--version [VERSION]', 'SNMP Version') do |v|
    options[:version] = v
  end

  opts.on_tail('-h', '--help', 'Display help') do
    puts opts
    exit
  end
end

begin
  @parser.parse!
  mandatory = [:host]                                                     # Enforce the presence of
  missing = mandatory.select{ |param| options[param].nil? }               # the named arguments
  unless missing.empty?                                                   #
    puts "Missing options: #{missing.join(', ')}"                         #
    puts @parser                                                          #
    exit 1                                                                #
  end                                                                     #
rescue OptionParser::InvalidOption, OptionParser::MissingArgument         #
  puts $!.to_s                                                            # Friendly output when parsing fails
  puts @parser                                                            #
  exit 1                                                                  #
end

OIDS = [
        "1.3.6.1.4.1.35774.2.1.4.7.0",    # UEC-STARLINE-MIB::infeedTotalActivePower.0
        "1.3.6.1.4.1.35774.2.1.6.1.10.1", # UEC-STARLINE-MIB::infeedPhaseActivePower.phaseA
        "1.3.6.1.4.1.35774.2.1.6.1.10.2", # UEC-STARLINE-MIB::infeedPhaseActivePower.phaseB
        "1.3.6.1.4.1.35774.2.1.6.1.10.3"  # UEC-STARLINE-MIB::infeedPhaseActivePower.phaseC
]

output = ""

manager = SNMP::Manager.new(:host => options[:host], :community => options[:community], :version => :SNMPv2c, :mib_modules => ["UEC-STARLINE-MIB"])
response = manager.get(OIDS)

response.each_varbind do |vb|
  name = vb.name.to_s.partition('::').last
  output += "#{name}:#{vb.value} "
  #output += "#{vb.name}:#{vb.value} "
end

puts output

exit 0
