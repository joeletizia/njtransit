require 'nokogiri'
require 'pry'
require 'active_record'
require_relative './train_data'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/njtransit_analysis.db'
)

def persist_node(node)
  # Track, Line, Train id
  content =  "#{node.content}|#{node.next.next.content}|#{node.next.next.next.next.content}"
  track, line, train = content.split("|")
  if track.present? && train.present?
    train_data = TrainData.create(line: line, train_id: train, track: track)
  end
end

html = `curl http://dv.njtransit.com/mobile/tid-mobile.aspx?sid=NY`

doc = Nokogiri::HTML(html)
nodes = doc.search('td[align="center"][valign="middle"]')

nodes.each do |node|
  persist_node(node)
end


