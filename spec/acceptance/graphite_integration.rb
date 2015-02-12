#!/usr/bin/env ruby

require 'socket'
require 'net/http'
require 'json'

CARBON_PORT = 2003
GRAPHITE_PORT = 8000

def send_metric(name, value, carbon_port=2003)
  sock = TCPSocket.new('localhost', carbon_port)
  sock.puts "#{name} #{value} #{Integer(Time.now)}"
  sock.close
end

def get_metric(name, value, graphite_port=8000)
  uri = URI("http://localhost:#{graphite_port}/render?from=-1minss&until=now&target=#{name}&format=json")
  resp = Net::HTTP.get(uri)

  data = JSON::load(resp)
  return false unless \
    data.size == 1 && \
    data.first['target'] == name && \
    data.first.has_key?('datapoints')

  match = data.first['datapoints'].select { |dp| dp.first == value }
  return false unless match.size == 1

  return true
end

def get_metric_retry(*args)
  10.times do |attempt|
    return true if get_metric(*args)
    puts "Attempt #{attempt+1} failed"
    sleep 0.5
  end

  return false
end

name, value = "foo.bar", rand()
send_metric(name, value, CARBON_PORT)
success = get_metric_retry(name, value, GRAPHITE_PORT)

raise "Unable to get metric our from Graphite" unless success
puts "All OK"
